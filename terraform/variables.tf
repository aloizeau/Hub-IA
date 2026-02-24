variable "project_name" {
  description = "Name of the project, used as a prefix for all resource names"
  type        = string
  default     = "hub-ia"
}

variable "environment" {
  description = "Deployment environment (dev | staging | prod)"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}

variable "location" {
  description = "Azure region for all resources"
  type        = string
  default     = "swedencentral"
}

variable "address_space" {
  description = "VNet address space CIDR block"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}

# ── AI Foundry serverless model endpoints ─────────────────────────────────────

variable "gpt_model_id" {
  description = "OpenAI GPT model ID in the Azure AI Foundry model catalog"
  type        = string
  default     = "azureml://registries/azure-openai/models/gpt-4/versions/5.3"
}

variable "anthropic_model_id" {
  description = "Anthropic Claude model ID in the Azure AI Foundry model catalog"
  type        = string
  default     = "azureml://registries/azure-model-catalog/models/Anthropic-Claude-Opus/versions/4.6"
}

variable "mistral_model_id" {
  description = "Mistral AI model ID in the Azure AI Foundry model catalog"
  type        = string
  default     = "azureml://registries/azure-model-catalog/models/Mistral-Large/versions/3"
}

# ── Azure AI Search ───────────────────────────────────────────────────────────

variable "ai_search_sku" {
  description = "Azure AI Search pricing tier"
  type        = string
  default     = "standard"

  validation {
    condition = contains(
      ["free", "basic", "standard", "standard2", "standard3",
      "storage_optimized_l1", "storage_optimized_l2"],
      var.ai_search_sku
    )
    error_message = "ai_search_sku must be a valid Azure Cognitive Search tier."
  }
}

variable "ai_search_replica_count" {
  description = "Number of replicas for the AI Search service"
  type        = number
  default     = 1
}

variable "ai_search_partition_count" {
  description = "Number of partitions for the AI Search service"
  type        = number
  default     = 1
}
