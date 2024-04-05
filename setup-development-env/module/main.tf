resource "azurerm_resource_group" "development_env_resource_group" {
  name     = var.development_env_resource_group_name
  location = var.location

  tags = {
    environment = "dev"
  }
}

resource "azurerm_virtual_network" "development_env_vpc" {
  name                = var.development_env_vpc_name
  resource_group_name = azurerm_resource_group.development_env_resource_group.name
  location            = azurerm_resource_group.development_env_resource_group.location
  address_space       = var.address_space

  tags = {
    environment = "dev"
  }
}

resource "azurerm_subnet" "development_env_vpc_subnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.development_env_resource_group.name
  virtual_network_name = azurerm_virtual_network.development_env_vpc.name
  address_prefixes     = var.subnet_address_prefixes
}

resource "azurerm_network_security_group" "development_env_network_security_group" {
  name                = var.network_security_group_name
  location            = azurerm_resource_group.development_env_resource_group.location
  resource_group_name = azurerm_resource_group.development_env_resource_group.name

  tags = {
    environment = "dev"
  }
}

resource "azurerm_network_security_rule" "development_env_network_security_group_security_rules" {
  name                        = var.network_security_group_rules_name
  resource_group_name         = azurerm_resource_group.development_env_resource_group.name
  network_security_group_name = azurerm_network_security_group.development_env_network_security_group.name
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

resource "azurerm_subnet_network_security_group_association" "development_env_subnet_network_security_assoc" {
  subnet_id                 = azurerm_subnet.development_env_vpc_subnet.id
  network_security_group_id = azurerm_network_security_group.development_env_network_security_group.id
}

resource "azurerm_public_ip" "development_env_public_ip" {
  name                = var.public_ip_name
  resource_group_name = azurerm_resource_group.development_env_resource_group.name
  location            = azurerm_resource_group.development_env_resource_group.location
  allocation_method   = "Dynamic"

  tags = {
    environment = "dev"
  }
}

resource "azurerm_network_interface" "development_env_network_interface" {
  name                = var.network_interface_name
  location            = azurerm_resource_group.development_env_resource_group.location
  resource_group_name = azurerm_resource_group.development_env_resource_group.name

  ip_configuration {
    name                          = var.network_interface_ip_config_name
    subnet_id                     = azurerm_subnet.development_env_vpc_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.development_env_public_ip.id
  }

  tags = {
    environment = "dev"
  }
}

resource "azurerm_linux_virtual_machine" "development_env_linux_vm" {
  name                  = var.vm_name
  resource_group_name   = azurerm_resource_group.development_env_resource_group.name
  location              = azurerm_resource_group.development_env_resource_group.location
  size                  = var.vm_size
  admin_username        = var.vm_admin_usrname
  network_interface_ids = [azurerm_network_interface.development_env_network_interface.id]

  custom_data = filebase64(var.vm_custom_data)

  os_disk {
    name                 = var.vm_os_disk_name
    caching              = var.vm_os_disk_caching
    storage_account_type = var.vm_os_disk_storage_type
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001_com_ubuntu_server_jammy"
    sku       = "22_04_lts"
    version   = "latest"
  }

  admin_ssh_key {
    username   = var.vm_admin_usrname
    public_key = file(var.vm_pub_key_path)
  }

  provisioner "local-exec" {
    command = templatefile(
      var.host_OS != "windows" ? "./scripts/ssh_host_add.tpl" : "./scripts/windows_ssh_host_add.tpl",
      {
        hostname = self.public_ip_address,
        user     = var.vm_admin_usrname,
        idfile   = var.vm_private_key_path
      }
    )
    interpreter = var.host_OS != "windows" ? ["bash", "-c"] : ["Powershell", "-Command"]
  }

  tags = {
    environment = "dev"
  }
}