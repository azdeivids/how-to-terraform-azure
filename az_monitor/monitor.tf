resource "random_string" "activity_log" {
  length  = 12
  upper   = false
  special = false
}

resource "azurerm_monitor_diagnostic_setting" "activity_log" {
  name                       = "diag-${random_string.activity_log.result}"
  target_resource_id         = data.azurerm_subscription.current.id
  storage_account_id         = azurerm_storage_account.mon_st.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.la_workspace.id

  log {
    category = "Administrative"

    retention_policy {
      enabled = false
    }

  }

  log {
    category = "Security"

    retention_policy {
      enabled = false
    }

  }
  log {
    category = "ServiceHealth"

    retention_policy {
      enabled = false
    }

  }
  log {
    category = "Alert"

    retention_policy {
      enabled = false
    }

  }

  log {
    category = "Recommendation"

    retention_policy {
      enabled = false
    }

  }

  log {
    category = "Policy"

    retention_policy {
      enabled = false
    }

  }

  log {
    category = "Autoscale"

    retention_policy {
      enabled = false
    }

  }

  log {
    category = "ResourceHealth"

    retention_policy {
      enabled = false
    }

  }


}