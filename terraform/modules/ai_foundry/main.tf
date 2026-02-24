data "azurerm_client_config" "current" {}

locals {
  # Storage account names: 3–24 chars, lowercase alphanumeric only
  storage_name = lower(
    replace("st${substr(replace(var.name_prefix, "-", ""), 0, 13)}${var.suffix}", "-", "")
  )
  kv_name      = "kv-${substr(var.name_prefix, 0, 15)}-${var.suffix}"
  hub_name     = "hub-${var.name_prefix}-${var.suffix}"
  project_name = "proj-${var.name_prefix}-${var.suffix}"
}

# ── Supporting Services ───────────────────────────────────────────────────────

resource "azurerm_storage_account" "this" {
  name                     = local.storage_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"

  min_tls_version                 = "TLS1_2"
  public_network_access_enabled   = false
  allow_nested_items_to_be_public = false

  network_rules {
    default_action = "Deny"
    bypass         = ["AzureServices"]
  }

  blob_properties {
    delete_retention_policy {
      days = 7
    }
  }

  tags = var.tags
}

resource "azurerm_key_vault" "this" {
  name                = local.kv_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"

  rbac_authorization_enabled = true
  purge_protection_enabled   = true
  soft_delete_retention_days = 90

  public_network_access_enabled = false

  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
  }

  tags = var.tags
}

# ── Azure AI Foundry Hub ──────────────────────────────────────────────────────

resource "azurerm_ai_foundry" "hub" {
  name                = local.hub_name
  location            = var.location
  resource_group_name = var.resource_group_name
  storage_account_id  = azurerm_storage_account.this.id
  key_vault_id        = azurerm_key_vault.this.id

  # Full network isolation: no public access, only approved outbound traffic
  public_network_access = "Disabled"

  managed_network {
    isolation_mode = "AllowOnlyApprovedOutbound"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

# ── Azure AI Foundry Project ──────────────────────────────────────────────────

resource "azurerm_ai_foundry_project" "project" {
  name               = local.project_name
  location           = var.location
  ai_services_hub_id = azurerm_ai_foundry.hub.id

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

# ── Role Assignments for AI Foundry Hub System-Assigned Identity ──────────────

resource "azurerm_role_assignment" "hub_storage_blob" {
  scope                = azurerm_storage_account.this.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_ai_foundry.hub.identity[0].principal_id
}

resource "azurerm_role_assignment" "hub_storage_file" {
  scope                = azurerm_storage_account.this.id
  role_definition_name = "Storage File Data Privileged Contributor"
  principal_id         = azurerm_ai_foundry.hub.identity[0].principal_id
}

resource "azurerm_role_assignment" "hub_key_vault" {
  scope                = azurerm_key_vault.this.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = azurerm_ai_foundry.hub.identity[0].principal_id
}

# ── Private Endpoint: Azure Blob Storage ─────────────────────────────────────

resource "azurerm_private_endpoint" "storage_blob" {
  name                = "pe-stblob-${var.name_prefix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "psc-stblob-${var.name_prefix}"
    private_connection_resource_id = azurerm_storage_account.this.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "pdz-blob"
    private_dns_zone_ids = [var.private_dns_zone_id_blob]
  }

  tags = var.tags
}

# ── Private Endpoint: Azure File Storage ─────────────────────────────────────

resource "azurerm_private_endpoint" "storage_file" {
  name                = "pe-stfile-${var.name_prefix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "psc-stfile-${var.name_prefix}"
    private_connection_resource_id = azurerm_storage_account.this.id
    subresource_names              = ["file"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "pdz-file"
    private_dns_zone_ids = [var.private_dns_zone_id_file]
  }

  tags = var.tags
}

# ── Private Endpoint: Key Vault ───────────────────────────────────────────────

resource "azurerm_private_endpoint" "key_vault" {
  name                = "pe-kv-${var.name_prefix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "psc-kv-${var.name_prefix}"
    private_connection_resource_id = azurerm_key_vault.this.id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "pdz-kv"
    private_dns_zone_ids = [var.private_dns_zone_id_vault]
  }

  tags = var.tags
}

# ── Private Endpoint: AI Foundry Hub ─────────────────────────────────────────

resource "azurerm_private_endpoint" "ai_foundry" {
  name                = "pe-hub-${var.name_prefix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "psc-hub-${var.name_prefix}"
    private_connection_resource_id = azurerm_ai_foundry.hub.id
    subresource_names              = ["amlworkspace"]
    is_manual_connection           = false
  }

  # Both zones are required for the ML workspace private endpoint
  private_dns_zone_group {
    name = "pdz-hub"
    private_dns_zone_ids = [
      var.private_dns_zone_id_ai_foundry,
      var.private_dns_zone_id_notebooks,
    ]
  }

  tags = var.tags
}

# ── Serverless Endpoint: OpenAI GPT ──────────────────────────────────────────
# GPT is deployed via AI Foundry serverless endpoint — no standalone Azure
# OpenAI account is required. The model is served from the AI Foundry model
# catalog using pay-as-you-go consumption billing (authMode = AAD).

resource "azapi_resource" "gpt_endpoint" {
  type      = "Microsoft.MachineLearningServices/workspaces/serverlessEndpoints@2024-10-01"
  name      = "gpt-endpoint"
  location  = var.location
  parent_id = azurerm_ai_foundry_project.project.id

  body = {
    properties = {
      authMode = "AAD"
      modelSettings = {
        modelId = var.gpt_model_id
      }
    }
    sku = {
      name = "Consumption"
    }
  }

  tags = var.tags

  depends_on = [azurerm_ai_foundry_project.project]
}

# ── Serverless Endpoint: Anthropic Claude Opus ────────────────────────────────
# Deployed via AzAPI because azurerm does not yet expose serverlessEndpoints.

resource "azapi_resource" "claude_endpoint" {
  type      = "Microsoft.MachineLearningServices/workspaces/serverlessEndpoints@2024-10-01"
  name      = "claude-opus-endpoint"
  location  = var.location
  parent_id = azurerm_ai_foundry_project.project.id

  body = {
    properties = {
      authMode = "AAD"
      modelSettings = {
        modelId = var.anthropic_model_id
      }
    }
    sku = {
      name = "Consumption"
    }
  }

  tags = var.tags

  depends_on = [azurerm_ai_foundry_project.project]
}

# ── Serverless Endpoint: Mistral AI Large ─────────────────────────────────────

resource "azapi_resource" "mistral_endpoint" {
  type      = "Microsoft.MachineLearningServices/workspaces/serverlessEndpoints@2024-10-01"
  name      = "mistral-large-endpoint"
  location  = var.location
  parent_id = azurerm_ai_foundry_project.project.id

  body = {
    properties = {
      authMode = "AAD"
      modelSettings = {
        modelId = var.mistral_model_id
      }
    }
    sku = {
      name = "Consumption"
    }
  }

  tags = var.tags

  depends_on = [azurerm_ai_foundry_project.project]
}
