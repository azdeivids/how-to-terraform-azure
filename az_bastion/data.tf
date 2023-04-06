data "azurerm_key_vault" "main_kv" {
  name                = "kv-10nj1vfv"
  resource_group_name = "rg-ssh-kv-10nj1vfv"
}

data "azurerm_key_vault_secret" "ssh_pub_key" {
  name         = "ssh-public"
  key_vault_id = data.azurerm_key_vault.main_kv.id
}

data "http" "myip" {
  url = "https://ipv4.icanhazip.com/"
}