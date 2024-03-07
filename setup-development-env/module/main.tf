resource "azurerm_resource_group" "t-rg" {
  name     = var.resources-g-name
  location = var.location

  tags = {
    environment = "dev"
  }
}

resource "azurerm_virtual_network" "t-vpc" {
  name                = var.virtual-network-name
  resource_group_name = azurerm_resource_group.t-rg.name
  location            = azurerm_resource_group.t-rg.location
  address_space       = var.addr-space

  tags = {
    environment = "dev"
  }
}

resource "azurerm_subnet" "t-vpc-sn" {
  name                 = var.subnet-name
  resource_group_name  = azurerm_resource_group.t-rg.name
  virtual_network_name = azurerm_virtual_network.t-vpc.name
  address_prefixes     = var.subnet-addr-prefixes
}

resource "azurerm_network_security_group" "t-nsg" {
  name                = var.network-sec-g-name
  location            = azurerm_resource_group.t-rg.location
  resource_group_name = azurerm_resource_group.t-rg.name

  tags = {
    environment = "dev"
  }
}

resource "azurerm_network_security_rule" "t-nsg-sr" {
  name                        = var.network-sec-g-rules-name
  resource_group_name         = azurerm_resource_group.t-rg.name
  network_security_group_name = azurerm_network_security_group.t-nsg.name
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

resource "azurerm_subnet_network_security_group_association" "t-sn-nsg-assoc" {
  subnet_id                 = azurerm_subnet.t-vpc-sn.id
  network_security_group_id = azurerm_network_security_group.t-nsg.id
}

resource "azurerm_public_ip" "t-ip" {
  name                = var.pub-ip-name
  resource_group_name = azurerm_resource_group.t-rg.name
  location            = azurerm_resource_group.t-rg.location
  allocation_method   = "Dynamic"

  tags = {
    environment = "dev"
  }
}

resource "azurerm_network_interface" "t-nic" {
  name                = var.network-interface-name
  location            = azurerm_resource_group.t-rg.location
  resource_group_name = azurerm_resource_group.t-rg.name

  ip_configuration {
    name                          = var.nic-ip-config-name
    subnet_id                     = azurerm_subnet.t-vpc-sn.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.t-ip.id
  }

  tags = {
    environment = "dev"
  }
}

resource "azurerm_linux_virtual_machine" "t-linux-vm" {
  name                  = var.vm-name
  resource_group_name   = azurerm_resource_group.t-rg.name
  location              = azurerm_resource_group.t-rg.location
  size                  = var.vm-size
  admin_username        = var.vm-admin-usrname
  network_interface_ids = [azurerm_network_interface.t-nic.id]

  custom_data = filebase64(var.vm-custom-data)

  os_disk {
    name                 = var.vm-os-disk-name
    caching              = var.vm-os-disk-caching
    storage_account_type = var.vm-os-disk-storage-type
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  admin_ssh_key {
    username   = var.vm-admin-usrname
    public_key = file(var.vm-pub-key-path)
  }

  provisioner "local-exec" {
    command = templatefile(
      var.host-OS != "windows" ? "./scripts/ssh-host-add.tpl" : "./scripts/windows-ssh-host-add.tpl",
      {
        hostname = self.public_ip_address,
        user     = var.vm-admin-usrname,
        idfile   = var.vm-private-key-path
      }
    )
    interpreter = var.host-OS != "windows" ? ["bash", "-c"] : ["Powershell", "-Command"]
  }

  tags = {
    environment = "dev"
  }
}