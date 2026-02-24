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
  description = "Subnet ID in which to create private endpoints"
  type        = string
}

variable "private_dns_zone_id_cognitive" {
  description = "Resource ID of the Cognitive Services private DNS zone"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
