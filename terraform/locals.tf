resource "random_string" "suffix" {
  length  = 6
  upper   = false
  special = false
}

locals {
  suffix      = random_string.suffix.result
  name_prefix = "${var.project_name}-${var.environment}"

  # ── Derived resource names ─────────────────────────────────────────────────
  # Storage account: 3–24 chars, lowercase alphanumeric only
  storage_name        = lower(replace("st${substr(replace(local.name_prefix, "-", ""), 0, 13)}${local.suffix}", "-", ""))
  kv_name             = "kv-${substr(local.name_prefix, 0, 15)}-${local.suffix}"
  hub_name            = "hub-${local.name_prefix}-${local.suffix}"
  project_name_str    = "proj-${local.name_prefix}-${local.suffix}"
  doc_intel_name      = "di-${local.name_prefix}-${local.suffix}"
  content_safety_name = "cs-${local.name_prefix}-${local.suffix}"
  search_name         = "srch-${local.name_prefix}-${local.suffix}"

  tags = merge(var.tags, {
    project     = var.project_name
    environment = var.environment
    managed_by  = "terraform"
    location    = var.location
  })
}
