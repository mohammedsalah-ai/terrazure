data "azurerm_virtual_machine" "t-vm-d" {
  name                = azurerm_linux_virtual_machine.t-linux-vm.name
  resource_group_name = azurerm_resource_group.t-rg.name
}

output "vm-public-ip-addr" {
  value = data.azurerm_virtual_machine.t-vm-d.public_ip_address
}