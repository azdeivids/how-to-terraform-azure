resource "azurerm_public_ip" "vm_pip" {
  name                = "pip-${random_string.main.result}"
  resource_group_name = azurerm_resource_group.rgvm01.name
  location            = azurerm_resource_group.rgvm01.location
  allocation_method   = "Static"

  tags = {
    Env = "Dev"
  }
}

resource "azurerm_network_interface" "vm_nic" {
  name                = "nic-${random_string.main.result}"
  location            = azurerm_resource_group.rgvm01.location
  resource_group_name = azurerm_resource_group.rgvm01.name

  ip_configuration {
    name                          = "public"
    subnet_id                     = data.azurerm_subnet.nic_snet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_pip.id
  }
}

resource "azurerm_linux_virtual_machine" "vm01" {
  name                = "vm-${random_string.main.result}"
  resource_group_name = azurerm_resource_group.rgvm01.name
  location            = azurerm_resource_group.rgvm01.location
  size                = "Standard_DS2_v2"
  admin_username      = "deivids"

  network_interface_ids = [
    azurerm_network_interface.vm_nic.id,
  ]

  admin_ssh_key {
    username   = "deivids"
    public_key = data.azurerm_key_vault_secret.ssh_pub_key.value
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}