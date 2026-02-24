locals {
  account_name = "oai-${var.name_prefix}-${var.suffix}"
}

# ── Azure OpenAI Account ──────────────────────────────────────────────────────

resource "azurerm_cognitive_account" "openai" {
  name                  = local.account_name
  location              = var.location
  resource_group_name   = var.resource_group_name
  kind                  = "OpenAI"
  sku_name              = "S0"
  custom_subdomain_name = local.account_name

  # Disable public access – all traffic must go through the private endpoint
  public_network_access_enabled = false

  network_acls {
    default_action = "Deny"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

# ── GPT Model Deployment ──────────────────────────────────────────────────────

resource "azurerm_cognitive_deployment" "gpt" {
  name                 = "${var.openai_model_name}-deployment"
  cognitive_account_id = azurerm_cognitive_account.openai.id

  model {
    format  = "OpenAI"
    name    = var.openai_model_name
    version = var.openai_model_version
  }

  sku {
    name     = "GlobalStandard"
    capacity = var.openai_sku_capacity
  }
}

# ── Private Endpoint ──────────────────────────────────────────────────────────

resource "azurerm_private_endpoint" "openai" {
  name                = "pe-oai-${var.name_prefix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "psc-oai-${var.name_prefix}"
    private_connection_resource_id = azurerm_cognitive_account.openai.id
    subresource_names              = ["account"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "pdz-oai"
    private_dns_zone_ids = [var.private_dns_zone_id_openai]
  }

  tags = var.tags
}
