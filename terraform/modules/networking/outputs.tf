output "vnet_id" {
  description = "ID of the Virtual Network"
  value       = azurerm_virtual_network.vnet.id
}

output "vnet_name" {
  description = "Name of the Virtual Network"
  value       = azurerm_virtual_network.vnet.name
}

output "private_endpoints_subnet_id" {
  description = "ID of the private-endpoints subnet"
  value       = azurerm_subnet.private_endpoints.id
}

output "private_dns_zone_id_ai_foundry" {
  description = "Private DNS zone ID for AI Foundry (privatelink.api.azureml.ms)"
  value       = azurerm_private_dns_zone.ai_foundry.id
}

output "private_dns_zone_id_notebooks" {
  description = "Private DNS zone ID for notebooks (privatelink.notebooks.azure.net)"
  value       = azurerm_private_dns_zone.notebooks.id
}

output "private_dns_zone_id_cognitive" {
  description = "Private DNS zone ID for Cognitive Services (privatelink.cognitiveservices.azure.com)"
  value       = azurerm_private_dns_zone.cognitive.id
}

output "private_dns_zone_id_search" {
  description = "Private DNS zone ID for AI Search (privatelink.search.windows.net)"
  value       = azurerm_private_dns_zone.search.id
}

output "private_dns_zone_id_blob" {
  description = "Private DNS zone ID for Blob Storage (privatelink.blob.core.windows.net)"
  value       = azurerm_private_dns_zone.blob.id
}

output "private_dns_zone_id_file" {
  description = "Private DNS zone ID for File Storage (privatelink.file.core.windows.net)"
  value       = azurerm_private_dns_zone.file.id
}

output "private_dns_zone_id_vault" {
  description = "Private DNS zone ID for Key Vault (privatelink.vaultcore.azure.net)"
  value       = azurerm_private_dns_zone.vault.id
}
