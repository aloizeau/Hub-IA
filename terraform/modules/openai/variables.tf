variable "resource_group_name" {
  description = "Name of the resource group"
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
  description = "Subnet ID in which to create the private endpoint"
  type        = string
}

variable "private_dns_zone_id_openai" {
  description = "Resource ID of the OpenAI private DNS zone"
  type        = string
}

variable "openai_model_name" {
  description = "Azure OpenAI model name (e.g. gpt-4)"
  type        = string
  default     = "gpt-4"
}

variable "openai_model_version" {
  description = "Azure OpenAI model version"
  type        = string
  default     = "5.3"
}

variable "openai_sku_capacity" {
  description = "Deployment capacity in thousands of tokens per minute"
  type        = number
  default     = 10
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
