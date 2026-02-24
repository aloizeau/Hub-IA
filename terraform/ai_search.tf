resource "azurerm_search_service" "this" {
  name                = local.search_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  sku                 = var.ai_search_sku
  replica_count       = var.ai_search_replica_count
  partition_count     = var.ai_search_partition_count

  # Disable public access – all traffic must go through the private endpoint
  public_network_access_enabled = false

  # Require Azure AD authentication; disable legacy API-key auth
  local_authentication_enabled = false
  authentication_failure_mode  = "http403"

  identity {
    type = "SystemAssigned"
  }

  tags = local.tags
}
