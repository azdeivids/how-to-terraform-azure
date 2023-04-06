resource "azurerm_subnet" "bas_snet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.rg_bastion.name
  virtual_network_name = azurerm_virtual_network.main_vnet.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_public_ip" "bas_pip" {
  name                = "pip-bas-${random_string.main.result}"
  location            = azurerm_resource_group.rg_bastion.location
  resource_group_name = azurerm_resource_group.rg_bastion.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "bas_host" {
  name                = "bas-${random_string.main.result}"
  location            = azurerm_resource_group.rg_bastion.location
  resource_group_name = azurerm_resource_group.rg_bastion.name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.bas_snet.id
    public_ip_address_id = azurerm_public_ip.bas_pip.id
  }
}