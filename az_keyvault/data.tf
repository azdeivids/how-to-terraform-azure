data "azurerm_storage_account" "la_st" {
  name                = "st${local.la_rg_suffix}"
  resource_group_name = "rg-${local.la_rg_suffix}"
}

data "azurerm_log_analytics_workspace" "la_workspace" {
  name                = "log-${local.la_rg_suffix}"
  resource_group_name = "rg-${local.la_rg_suffix}"
}