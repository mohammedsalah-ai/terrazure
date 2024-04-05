data "azurerm_virtual_machine" "development_env_vm" {
  name                = azurerm_linux_virtual_machine.development_env_linux_vm.name
  resource_group_name = azurerm_resource_group.development_env_resource_group.name
}

output "vm_public_ip_address" {
  value = data.azurerm_virtual_machine.development_env_vm.public_ip_address
}