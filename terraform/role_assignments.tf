# Grant the AI Foundry Hub's system-assigned identity access to its
# backing Storage Account and Key Vault.

resource "azurerm_role_assignment" "hub_storage_blob" {
  scope                = azurerm_storage_account.ai_foundry.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_ai_foundry.hub.identity[0].principal_id
}

resource "azurerm_role_assignment" "hub_storage_file" {
  scope                = azurerm_storage_account.ai_foundry.id
  role_definition_name = "Storage File Data Privileged Contributor"
  principal_id         = azurerm_ai_foundry.hub.identity[0].principal_id
}

resource "azurerm_role_assignment" "hub_key_vault" {
  scope                = azurerm_key_vault.ai_foundry.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = azurerm_ai_foundry.hub.identity[0].principal_id
}
