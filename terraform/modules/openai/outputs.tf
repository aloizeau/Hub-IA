output "cognitive_account_id" {
  description = "Resource ID of the Azure OpenAI cognitive account"
  value       = azurerm_cognitive_account.openai.id
}

output "endpoint" {
  description = "Azure OpenAI service endpoint URL"
  value       = azurerm_cognitive_account.openai.endpoint
}

output "deployment_name" {
  description = "Name of the GPT model deployment"
  value       = azurerm_cognitive_deployment.gpt.name
}
