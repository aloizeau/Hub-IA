# ── Azure AI Document Intelligence ───────────────────────────────────────────

resource "azurerm_cognitive_account" "document_intelligence" {
  name                  = local.doc_intel_name
  location              = var.location
  resource_group_name   = azurerm_resource_group.rg.name
  kind                  = "FormRecognizer"
  sku_name              = "S0"
  custom_subdomain_name = local.doc_intel_name

  public_network_access_enabled = false

  network_acls {
    default_action = "Deny"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = local.tags
}

# ── Azure AI Content Safety ───────────────────────────────────────────────────

resource "azurerm_cognitive_account" "content_safety" {
  name                  = local.content_safety_name
  location              = var.location
  resource_group_name   = azurerm_resource_group.rg.name
  kind                  = "ContentSafety"
  sku_name              = "S0"
  custom_subdomain_name = local.content_safety_name

  public_network_access_enabled = false

  network_acls {
    default_action = "Deny"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = local.tags
}
