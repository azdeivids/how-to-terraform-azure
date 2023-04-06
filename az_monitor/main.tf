resource "random_string" "main" {
  length  = 8
  upper   = false
  special = false
}

resource "azurerm_resource_group" "mon_rg" {
  name     = "rg-${random_string.main.result}"
  location = var.location
}

resource "azurerm_storage_account" "mon_st" {
  name                     = "st${random_string.main.result}"
  resource_group_name      = azurerm_resource_group.mon_rg.name
  location                 = azurerm_resource_group.mon_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_log_analytics_workspace" "la_workspace" {
  name                = "log-${random_string.main.result}"
  resource_group_name = azurerm_resource_group.mon_rg.name
  location            = azurerm_resource_group.mon_rg.location
  sku                 = "PerGB2018"
  retention_in_days   = 30
}