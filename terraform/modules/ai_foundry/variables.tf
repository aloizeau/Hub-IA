variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "resource_group_id" {
  description = "Resource ID of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "name_prefix" {
  description = "Name prefix for resources"
  type        = string
}

variable "suffix" {
  description = "Random suffix to ensure globally-unique resource names"
  type        = string
}

variable "private_endpoint_subnet_id" {
  description = "Subnet ID in which to create private endpoints"
  type        = string
}

variable "private_dns_zone_id_ai_foundry" {
  description = "Private DNS zone ID for AI Foundry (privatelink.api.azureml.ms)"
  type        = string
}

variable "private_dns_zone_id_notebooks" {
  description = "Private DNS zone ID for notebooks (privatelink.notebooks.azure.net)"
  type        = string
}

variable "private_dns_zone_id_blob" {
  description = "Private DNS zone ID for Blob Storage"
  type        = string
}

variable "private_dns_zone_id_file" {
  description = "Private DNS zone ID for File Storage"
  type        = string
}

variable "private_dns_zone_id_vault" {
  description = "Private DNS zone ID for Key Vault"
  type        = string
}

variable "gpt_model_id" {
  description = "OpenAI GPT model ID in the Azure AI Foundry model catalog"
  type        = string
}

variable "anthropic_model_id" {
  description = "Anthropic Claude model ID in the Azure AI Foundry catalog"
  type        = string
}

variable "mistral_model_id" {
  description = "Mistral AI Large model ID in the Azure AI Foundry catalog"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
