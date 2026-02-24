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

variable "private_dns_zone_id_search" {
  description = "Resource ID of the AI Search private DNS zone"
  type        = string
}

variable "sku" {
  description = "Azure AI Search pricing tier"
  type        = string
  default     = "standard"
}

variable "replica_count" {
  description = "Number of replicas"
  type        = number
  default     = 1
}

variable "partition_count" {
  description = "Number of partitions"
  type        = number
  default     = 1
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
