output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.rg.name
}

output "vnet_id" {
  description = "ID of the Virtual Network"
  value       = azurerm_virtual_network.vnet.id
}

output "gpt_foundry_endpoint_id" {
  description = "Resource ID of the OpenAI GPT serverless endpoint in AI Foundry"
  value       = azapi_resource.gpt_endpoint.id
}

output "ai_foundry_hub_id" {
  description = "Azure AI Foundry Hub resource ID"
  value       = azurerm_ai_foundry.hub.id
}

output "ai_foundry_project_id" {
  description = "Azure AI Foundry Project resource ID"
  value       = azurerm_ai_foundry_project.project.id
}

output "document_intelligence_endpoint" {
  description = "Azure AI Document Intelligence endpoint URL"
  value       = azurerm_cognitive_account.document_intelligence.endpoint
  sensitive   = true
}

output "content_safety_endpoint" {
  description = "Azure AI Content Safety endpoint URL"
  value       = azurerm_cognitive_account.content_safety.endpoint
  sensitive   = true
}

output "ai_search_name" {
  description = "Azure AI Search service name"
  value       = azurerm_search_service.this.name
}

output "ai_search_endpoint" {
  description = "Azure AI Search endpoint URL"
  value       = "https://${azurerm_search_service.this.name}.search.windows.net"
  sensitive   = true
}

