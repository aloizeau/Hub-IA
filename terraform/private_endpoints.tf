# ── Azure Blob Storage ────────────────────────────────────────────────────────

resource "azurerm_private_endpoint" "storage_blob" {
  name                = "pe-stblob-${local.name_prefix}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.private_endpoints.id

  private_service_connection {
    name                           = "psc-stblob-${local.name_prefix}"
    private_connection_resource_id = azurerm_storage_account.ai_foundry.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "pdz-blob"
    private_dns_zone_ids = [azurerm_private_dns_zone.blob.id]
  }

  tags = local.tags
}

# ── Azure File Storage ────────────────────────────────────────────────────────

resource "azurerm_private_endpoint" "storage_file" {
  name                = "pe-stfile-${local.name_prefix}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.private_endpoints.id

  private_service_connection {
    name                           = "psc-stfile-${local.name_prefix}"
    private_connection_resource_id = azurerm_storage_account.ai_foundry.id
    subresource_names              = ["file"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "pdz-file"
    private_dns_zone_ids = [azurerm_private_dns_zone.file.id]
  }

  tags = local.tags
}

# ── Key Vault ─────────────────────────────────────────────────────────────────

resource "azurerm_private_endpoint" "key_vault" {
  name                = "pe-kv-${local.name_prefix}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.private_endpoints.id

  private_service_connection {
    name                           = "psc-kv-${local.name_prefix}"
    private_connection_resource_id = azurerm_key_vault.ai_foundry.id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "pdz-kv"
    private_dns_zone_ids = [azurerm_private_dns_zone.vault.id]
  }

  tags = local.tags
}

# ── AI Foundry Hub ────────────────────────────────────────────────────────────

resource "azurerm_private_endpoint" "ai_foundry" {
  name                = "pe-hub-${local.name_prefix}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.private_endpoints.id

  private_service_connection {
    name                           = "psc-hub-${local.name_prefix}"
    private_connection_resource_id = azurerm_ai_foundry.hub.id
    subresource_names              = ["amlworkspace"]
    is_manual_connection           = false
  }

  # Both zones are required for the ML workspace private endpoint
  private_dns_zone_group {
    name = "pdz-hub"
    private_dns_zone_ids = [
      azurerm_private_dns_zone.ai_foundry.id,
      azurerm_private_dns_zone.notebooks.id,
    ]
  }

  tags = local.tags
}

# ── Document Intelligence ─────────────────────────────────────────────────────

resource "azurerm_private_endpoint" "document_intelligence" {
  name                = "pe-di-${local.name_prefix}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.private_endpoints.id

  private_service_connection {
    name                           = "psc-di-${local.name_prefix}"
    private_connection_resource_id = azurerm_cognitive_account.document_intelligence.id
    subresource_names              = ["account"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "pdz-di"
    private_dns_zone_ids = [azurerm_private_dns_zone.cognitive.id]
  }

  tags = local.tags
}

# ── Content Safety ────────────────────────────────────────────────────────────

resource "azurerm_private_endpoint" "content_safety" {
  name                = "pe-cs-${local.name_prefix}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.private_endpoints.id

  private_service_connection {
    name                           = "psc-cs-${local.name_prefix}"
    private_connection_resource_id = azurerm_cognitive_account.content_safety.id
    subresource_names              = ["account"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "pdz-cs"
    private_dns_zone_ids = [azurerm_private_dns_zone.cognitive.id]
  }

  tags = local.tags
}

# ── AI Search ─────────────────────────────────────────────────────────────────

resource "azurerm_private_endpoint" "search" {
  name                = "pe-srch-${local.name_prefix}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.private_endpoints.id

  private_service_connection {
    name                           = "psc-srch-${local.name_prefix}"
    private_connection_resource_id = azurerm_search_service.this.id
    subresource_names              = ["searchService"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "pdz-srch"
    private_dns_zone_ids = [azurerm_private_dns_zone.search.id]
  }

  tags = local.tags
}
