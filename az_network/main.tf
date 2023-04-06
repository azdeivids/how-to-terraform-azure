resource "random_string" "main" {
  length  = 8
  upper   = false
  special = false
}

resource "azurerm_resource_group" "vnet_rg" {
  name     = "rg-${var.app_name}-dev-001"
  location = var.location

  tags = {
    Env           = "Dev"
    Owner         = "deivids@deividsegle.com"
    "Cost Center" = "IT"
  }
}

resource "azurerm_virtual_network" "main_vnet" {
  name                = "${var.app_name}-vnet-001"
  location            = azurerm_resource_group.vnet_rg.location
  resource_group_name = azurerm_resource_group.vnet_rg.name
  address_space       = ["10.0.0.0/16"]

  tags = {
    Env           = "Dev"
    Owner         = "deivids@deividsegle.com"
    "Cost Center" = "IT"
  }
}

resource "azurerm_subnet" "snet01" {
  name                 = "${var.app_name}-snet-001"
  resource_group_name  = azurerm_resource_group.vnet_rg.name
  virtual_network_name = azurerm_virtual_network.main_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "snet02" {
  name                 = "${var.app_name}-snet-002"
  resource_group_name  = azurerm_resource_group.vnet_rg.name
  virtual_network_name = azurerm_virtual_network.main_vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_security_group" "nsg01" {
  name                = "${var.app_name}-nsg-001"
  location            = azurerm_resource_group.vnet_rg.location
  resource_group_name = azurerm_resource_group.vnet_rg.name

  tags = {
    Env           = "Dev"
    Owner         = "deivids@deividsegle.com"
    "Cost Center" = "IT"
  }
}

resource "azurerm_network_security_rule" "rule01" {
  resource_group_name         = azurerm_resource_group.vnet_rg.name
  network_security_group_name = azurerm_network_security_group.nsg01.name

  name                       = "rule-100"
  priority                   = 100
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  destination_port_range     = "22"
  source_address_prefix      = "${chomp(data.http.myip.response_body)}/32"
  destination_address_prefix = "*"
}

resource "azurerm_network_security_rule" "rule02" {
  resource_group_name         = azurerm_resource_group.vnet-rg-01.name
  network_security_group_name = azurerm_network_security_group.nsg01.name

  name                       = "rule-200"
  priority                   = 200
  direction                  = "Outbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  destination_port_range     = "*"
  source_address_prefix      = "*"
  destination_address_prefix = "*"
}

resource "azurerm_subnet_network_security_group_association" "rule01-assoc" {
  subnet_id                 = azurerm_subnet.snet01.id
  network_security_group_id = azurerm_network_security_group.nsg01.id
}