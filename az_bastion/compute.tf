resource "azurerm_network_interface" "vm_nic" {
  name                = "nic-${random_string.main.result}-001"
  location            = azurerm_resource_group.rg_bastion.location
  resource_group_name = azurerm_resource_group.rg_bastion.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.default_snet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vm01" {
  name                = "vm-lin-${random_string.main.result}-001"
  resource_group_name = azurerm_resource_group.rg_bastion.name
  location            = azurerm_resource_group.rg_bastion.location
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