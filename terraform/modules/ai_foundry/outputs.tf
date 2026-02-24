output "hub_id" {
  description = "Resource ID of the Azure AI Foundry Hub"
  value       = azurerm_ai_foundry.hub.id
}

output "project_id" {
  description = "Resource ID of the Azure AI Foundry Project"
  value       = azurerm_ai_foundry_project.project.id
}

output "storage_account_id" {
  description = "Resource ID of the Storage Account used by AI Foundry"
  value       = azurerm_storage_account.this.id
}

output "key_vault_id" {
  description = "Resource ID of the Key Vault used by AI Foundry"
  value       = azurerm_key_vault.this.id
}

output "gpt_endpoint_id" {
  description = "Resource ID of the OpenAI GPT serverless endpoint"
  value       = azapi_resource.gpt_endpoint.id
}

output "claude_endpoint_id" {
  description = "Resource ID of the Anthropic Claude serverless endpoint"
  value       = azapi_resource.claude_endpoint.id
}

output "mistral_endpoint_id" {
  description = "Resource ID of the Mistral AI Large serverless endpoint"
  value       = azapi_resource.mistral_endpoint.id
}
