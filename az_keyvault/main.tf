resource "random_string" "main" {
  length  = 8
  upper   = false
  special = false
}

resource "azurerm_resource_group" "tfrg03" {
  name     = "rg-ssh-kv-${random_string.main.result}"
  location = var.location

  tags = {
    Env           = "Dev"
    Owner         = "deivids@deividsegle.com"
    "Cost Center" = "IT"
  }
}

resource "azurerm_key_vault" "tfkv03" {
  name                       = "kv-${random_string.main.result}"
  location                   = azurerm_resource_group.tfrg03.location
  resource_group_name        = azurerm_resource_group.tfrg03.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days = 7
  purge_protection_enabled   = false

  sku_name = "standard"
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault_access_policy" "kv_access_01" {
  key_vault_id = azurerm_key_vault.tfkv03.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  key_permissions = [
    "Get",
  ]

  secret_permissions = [
    "Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set"
  ]
}