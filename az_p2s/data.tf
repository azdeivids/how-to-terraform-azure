data "azurerm_key_vault" "main_kv" {
  name                = var.main_kv_name
  resource_group_name = var.main_kv_rg_name
}

data "azurerm_key_vault_secret" "ssh_pub_key" {
  name         = var.ssh_pub_key_name
  key_vault_id = data.azurerm_key_vault.main_kv.id
}

data "http" "myip" {
  url = "https://ipv4.icanhazip.com/"
}

data "azurerm_client_config" "current" {
}