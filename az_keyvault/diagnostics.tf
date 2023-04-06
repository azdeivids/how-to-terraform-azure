resource "random_string" "kv_diag" {
  length  = 8
  upper   = false
  special = false
}

resource "azurerm_monitor_diagnostic_setting" "kv_monitor" {
  name                       = "diag-${random_string.kv_diag.result}"
  target_resource_id         = azurerm_key_vault.tfkv03.id
  storage_account_id         = data.azurerm_storage_account.la_st.id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.la_workspace.id

  log {
    category_group = "audit"

    retention_policy {
      enabled = false
    }
  }
  log {
    category_group = "allLogs"

    retention_policy {
      enabled = false
    }
  }
  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = false
    }
  }

}