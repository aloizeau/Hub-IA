locals {
  # AI Search names: 2–60 chars, lowercase letters, digits, hyphens
  search_name = "srch-${var.name_prefix}-${var.suffix}"
}

# ── Azure AI Search ───────────────────────────────────────────────────────────

resource "azurerm_search_service" "this" {
  name                = local.search_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku
  replica_count       = var.replica_count
  partition_count     = var.partition_count

  # Disable public access – all traffic must go through the private endpoint
  public_network_access_enabled = false

  # Require Azure AD authentication; disable legacy API-key auth
  local_authentication_enabled = false
  authentication_failure_mode  = "http403"

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

# ── Private Endpoint ──────────────────────────────────────────────────────────

resource "azurerm_private_endpoint" "search" {
  name                = "pe-srch-${var.name_prefix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "psc-srch-${var.name_prefix}"
    private_connection_resource_id = azurerm_search_service.this.id
    subresource_names              = ["searchService"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "pdz-srch"
    private_dns_zone_ids = [var.private_dns_zone_id_search]
  }

  tags = var.tags
}
