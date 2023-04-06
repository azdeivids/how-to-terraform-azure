resource "azurerm_virtual_network" "main_vnet" {
  name                = "vnet-${local.name}-${random_string.main.result}-001"
  location            = azurerm_resource_group.rg_p2s.location
  resource_group_name = azurerm_resource_group.rg_p2s.name
  address_space       = ["10.0.0.0/16"]

  tags = {
    Env           = "Dev"
    Owner         = "deivids@deividsegle.com"
    "Cost Center" = "IT"
  }
}

resource "azurerm_subnet" "default_snet" {
  name                 = "snet-${local.name}-${random_string.main.result}-001"
  resource_group_name  = azurerm_resource_group.rg_p2s.name
  virtual_network_name = azurerm_virtual_network.main_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "main_nsg" {
  name                = "nsg-${local.name}-${random_string.main.result}-001"
  location            = azurerm_resource_group.rg_p2s.location
  resource_group_name = azurerm_resource_group.rg_p2s.name

  tags = {
    Env           = "Dev"
    Owner         = "deivids@deividsegle.com"
    "Cost Center" = "IT"
  }
}

resource "azurerm_subnet_network_security_group_association" "rule01-assoc" {
  subnet_id                 = azurerm_subnet.default_snet.id
  network_security_group_id = azurerm_network_security_group.main_nsg.id
}