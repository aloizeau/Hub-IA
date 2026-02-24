resource "random_string" "suffix" {
  length  = 6
  upper   = false
  special = false
}

locals {
  suffix      = random_string.suffix.result
  name_prefix = "${var.project_name}-${var.environment}"

  tags = merge(var.tags, {
    project     = var.project_name
    environment = var.environment
    managed_by  = "terraform"
    location    = var.location
  })
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-${local.name_prefix}"
  location = var.location
  tags     = local.tags
}

module "networking" {
  source = "./modules/networking"

  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  name_prefix         = local.name_prefix
  address_space       = var.address_space
  tags                = local.tags
}

module "ai_foundry" {
  source = "./modules/ai_foundry"

  resource_group_name            = azurerm_resource_group.rg.name
  resource_group_id              = azurerm_resource_group.rg.id
  location                       = var.location
  name_prefix                    = local.name_prefix
  suffix                         = local.suffix
  private_endpoint_subnet_id     = module.networking.private_endpoints_subnet_id
  private_dns_zone_id_ai_foundry = module.networking.private_dns_zone_id_ai_foundry
  private_dns_zone_id_notebooks  = module.networking.private_dns_zone_id_notebooks
  private_dns_zone_id_blob       = module.networking.private_dns_zone_id_blob
  private_dns_zone_id_file       = module.networking.private_dns_zone_id_file
  private_dns_zone_id_vault      = module.networking.private_dns_zone_id_vault
  gpt_model_id                   = var.gpt_model_id
  anthropic_model_id             = var.anthropic_model_id
  mistral_model_id               = var.mistral_model_id
  tags                           = local.tags

  depends_on = [module.networking]
}

module "ai_services" {
  source = "./modules/ai_services"

  resource_group_name           = azurerm_resource_group.rg.name
  location                      = var.location
  name_prefix                   = local.name_prefix
  suffix                        = local.suffix
  private_endpoint_subnet_id    = module.networking.private_endpoints_subnet_id
  private_dns_zone_id_cognitive = module.networking.private_dns_zone_id_cognitive
  tags                          = local.tags

  depends_on = [module.networking]
}

module "ai_search" {
  source = "./modules/ai_search"

  resource_group_name        = azurerm_resource_group.rg.name
  location                   = var.location
  name_prefix                = local.name_prefix
  suffix                     = local.suffix
  private_endpoint_subnet_id = module.networking.private_endpoints_subnet_id
  private_dns_zone_id_search = module.networking.private_dns_zone_id_search
  sku                        = var.ai_search_sku
  replica_count              = var.ai_search_replica_count
  partition_count            = var.ai_search_partition_count
  tags                       = local.tags

  depends_on = [module.networking]
}
