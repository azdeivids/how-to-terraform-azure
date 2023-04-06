resource "azurerm_subnet" "vgw_snet" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.rg_p2s.name
  virtual_network_name = azurerm_virtual_network.main_vnet.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_public_ip" "vpn_pip" {
  name                = "pip-vgw${local.name}-${random_string.main.result}-001"
  location            = azurerm_resource_group.rg_p2s.location
  resource_group_name = azurerm_resource_group.rg_p2s.name

  allocation_method = "Dynamic"
}

resource "azurerm_virtual_network_gateway" "vpn" {
  name                = "vgw-${local.name}-${random_string.main.result}-001"
  location            = azurerm_resource_group.rg_p2s.location
  resource_group_name = azurerm_resource_group.rg_p2s.name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku           = "VpnGw1"

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.vpn_pip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.vgw_snet.id
  }

  vpn_client_configuration {
    address_space        = ["10.2.0.0/24"]
    aad_tenant           = "https://login.microsoftonline.com/${data.azurerm_client_config.current.tenant_id}/"
    aad_audience         = "41b23e61-6c1e-4545-b367-cd054e0ed4b4"
    aad_issuer           = "https://sts.windows.net/${data.azurerm_client_config.current.tenant_id}/"
    vpn_client_protocols = ["OpenVPN"]
    vpn_auth_types       = ["AAD"]
  }
}