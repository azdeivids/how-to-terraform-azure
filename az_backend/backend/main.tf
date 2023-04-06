resource "random_string" "main" {
  length  = 8
  upper   = false
  special = false
}

resource "azurerm_resource_group" "rg_backend" {
  name     = "rg-terraform-uks-backend"
  location = var.location

  tags = {
    Env           = "Dev"
    Owner         = "deivids@deividsegle.com"
    "Cost Center" = "IT"
    Created       = "4/6/23"
  }
}

resource "azurerm_storage_account" "st_backend" {
  name                      = "st${random_string.main.result}"
  resource_group_name       = azurerm_resource_group.rg_backend.name
  location                  = azurerm_resource_group.rg_backend.location
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  enable_https_traffic_only = true

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Owner = "deivids@deividsegle.com"
  }
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate-${random_string.main.result}"
  storage_account_name  = azurerm_storage_account.st_backend.name
  container_access_type = "private"
}