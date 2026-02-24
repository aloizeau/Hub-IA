output "document_intelligence_id" {
  description = "Resource ID of the Document Intelligence cognitive account"
  value       = azurerm_cognitive_account.document_intelligence.id
}

output "document_intelligence_endpoint" {
  description = "Endpoint URL of the Document Intelligence service"
  value       = azurerm_cognitive_account.document_intelligence.endpoint
}

output "content_safety_id" {
  description = "Resource ID of the Content Safety cognitive account"
  value       = azurerm_cognitive_account.content_safety.id
}

output "content_safety_endpoint" {
  description = "Endpoint URL of the Content Safety service"
  value       = azurerm_cognitive_account.content_safety.endpoint
}
