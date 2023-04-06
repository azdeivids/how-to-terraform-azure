data "azurerm_key_vault" "main_kv" {
  name                = "kv-10nj1vfv"
  resource_group_name = "rg-ssh-kv-10nj1vfv"
}

data "azurerm_key_vault_secret" "ssh_pub_key" {
  name         = "ssh-public"
  key_vault_id = data.azurerm_key_vault.main_kv.id
}

data "azurerm_subnet" "nic_snet" {
  name                 = "bluebird-snet-001"
  virtual_network_name = "bluebird-vnet-001"
  resource_group_name  = "rg-bluebird-dev-001"
}