# All three models are deployed as AI Foundry serverless endpoints using
# pay-as-you-go consumption billing with Azure AD authentication (authMode=AAD).
# No standalone Azure OpenAI account is required.

# ── OpenAI GPT ────────────────────────────────────────────────────────────────

resource "azapi_resource" "gpt_endpoint" {
  type      = "Microsoft.MachineLearningServices/workspaces/serverlessEndpoints@2024-10-01"
  name      = "gpt-endpoint"
  location  = var.location
  parent_id = azurerm_ai_foundry_project.project.id

  body = {
    properties = {
      authMode = "AAD"
      modelSettings = {
        modelId = var.gpt_model_id
      }
    }
    sku = {
      name = "Consumption"
    }
  }

  tags = local.tags

  depends_on = [azurerm_ai_foundry_project.project]
}

# ── Anthropic Claude Opus ─────────────────────────────────────────────────────

resource "azapi_resource" "claude_endpoint" {
  type      = "Microsoft.MachineLearningServices/workspaces/serverlessEndpoints@2024-10-01"
  name      = "claude-opus-endpoint"
  location  = var.location
  parent_id = azurerm_ai_foundry_project.project.id

  body = {
    properties = {
      authMode = "AAD"
      modelSettings = {
        modelId = var.anthropic_model_id
      }
    }
    sku = {
      name = "Consumption"
    }
  }

  tags = local.tags

  depends_on = [azurerm_ai_foundry_project.project]
}

# ── Mistral AI Large ──────────────────────────────────────────────────────────

resource "azapi_resource" "mistral_endpoint" {
  type      = "Microsoft.MachineLearningServices/workspaces/serverlessEndpoints@2024-10-01"
  name      = "mistral-large-endpoint"
  location  = var.location
  parent_id = azurerm_ai_foundry_project.project.id

  body = {
    properties = {
      authMode = "AAD"
      modelSettings = {
        modelId = var.mistral_model_id
      }
    }
    sku = {
      name = "Consumption"
    }
  }

  tags = local.tags

  depends_on = [azurerm_ai_foundry_project.project]
}
