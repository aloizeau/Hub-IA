# ── Azure AI Foundry Hub ──────────────────────────────────────────────────────

resource "azurerm_ai_foundry" "hub" {
  name                = local.hub_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  storage_account_id  = azurerm_storage_account.ai_foundry.id
  key_vault_id        = azurerm_key_vault.ai_foundry.id

  # Full network isolation: no public access, only approved outbound traffic
  public_network_access = "Disabled"

  managed_network {
    isolation_mode = "AllowOnlyApprovedOutbound"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = local.tags
}

# ── Azure AI Foundry Project ──────────────────────────────────────────────────

resource "azurerm_ai_foundry_project" "project" {
  name               = local.project_name_str
  location           = var.location
  ai_services_hub_id = azurerm_ai_foundry.hub.id

  identity {
    type = "SystemAssigned"
  }

  tags = local.tags
}
