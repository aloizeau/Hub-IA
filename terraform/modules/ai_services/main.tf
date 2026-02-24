locals {
  doc_intel_name      = "di-${var.name_prefix}-${var.suffix}"
  content_safety_name = "cs-${var.name_prefix}-${var.suffix}"
}

# ── Azure AI Document Intelligence ───────────────────────────────────────────

resource "azurerm_cognitive_account" "document_intelligence" {
  name                  = local.doc_intel_name
  location              = var.location
  resource_group_name   = var.resource_group_name
  kind                  = "FormRecognizer"
  sku_name              = "S0"
  custom_subdomain_name = local.doc_intel_name

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

resource "azurerm_private_endpoint" "document_intelligence" {
  name                = "pe-di-${var.name_prefix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "psc-di-${var.name_prefix}"
    private_connection_resource_id = azurerm_cognitive_account.document_intelligence.id
    subresource_names              = ["account"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "pdz-di"
    private_dns_zone_ids = [var.private_dns_zone_id_cognitive]
  }

  tags = var.tags
}

# ── Azure AI Content Safety ───────────────────────────────────────────────────

resource "azurerm_cognitive_account" "content_safety" {
  name                  = local.content_safety_name
  location              = var.location
  resource_group_name   = var.resource_group_name
  kind                  = "ContentSafety"
  sku_name              = "S0"
  custom_subdomain_name = local.content_safety_name

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

resource "azurerm_private_endpoint" "content_safety" {
  name                = "pe-cs-${var.name_prefix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "psc-cs-${var.name_prefix}"
    private_connection_resource_id = azurerm_cognitive_account.content_safety.id
    subresource_names              = ["account"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "pdz-cs"
    private_dns_zone_ids = [var.private_dns_zone_id_cognitive]
  }

  tags = var.tags
}
