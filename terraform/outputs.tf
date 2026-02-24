output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.rg.name
}

output "vnet_id" {
  description = "ID of the Virtual Network"
  value       = module.networking.vnet_id
}

output "gpt_foundry_endpoint_id" {
  description = "Resource ID of the OpenAI GPT serverless endpoint in AI Foundry"
  value       = module.ai_foundry.gpt_endpoint_id
}

output "ai_foundry_hub_id" {
  description = "Azure AI Foundry Hub resource ID"
  value       = module.ai_foundry.hub_id
}

output "ai_foundry_project_id" {
  description = "Azure AI Foundry Project resource ID"
  value       = module.ai_foundry.project_id
}

output "document_intelligence_endpoint" {
  description = "Azure AI Document Intelligence endpoint URL"
  value       = module.ai_services.document_intelligence_endpoint
  sensitive   = true
}

output "content_safety_endpoint" {
  description = "Azure AI Content Safety endpoint URL"
  value       = module.ai_services.content_safety_endpoint
  sensitive   = true
}

output "ai_search_name" {
  description = "Azure AI Search service name"
  value       = module.ai_search.search_service_name
}

output "ai_search_endpoint" {
  description = "Azure AI Search endpoint URL"
  value       = module.ai_search.search_service_endpoint
  sensitive   = true
}
