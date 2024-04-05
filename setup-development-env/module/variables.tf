variable "development_env_resource_group_name" {
    description = "name for the resource group for the development environment"
    type = string
    default = "development_env"
}

variable "location" {
    description = "resource group location"
    type = string
    default = "East US"
}

variable "development_env_vpc_name" {
    description = "virtual network name"
    type = string
    default = "development_env_virtual_network"
}

variable "address_space" {
    description = "virtual network address space, a list of CIDR blocks"
    type = list(string)
    default = ["10.10.0.0/16"]
}

variable "subnet_name" {
    description = "virtual network subnet name"
    type = string
    default = "development_env_subnet"
}

variable "subnet_address_prefixes" {
    description = "CIDR blocks defining the subnet"
    type = list(string)
    default = ["10.10.1.0/24"]
}

variable "network_security_group_name" {
    description = "network security group name that'll be assigned to the created subnet"
    type = string
    default = "development_env_network_security_group"
}

variable "network_security_group_rules_name" {
    description = "network security group rules name"
    type = string
    default = "development_network_security_group_rules"
}

variable "public_ip_name" {
    description = "public ip name"
    type = string
    default = "development_env_public_ip"
}

variable "network_interface_name" {
    description = "network interface that'll be assigned to the VM"
    type = string
    default = "development_env_network_interface"
}

variable "network_interface_ip_config_name" {
    description = "name of ip configuration of the network interface"
    type = string
    default = "development_network_interface_ip_config"
}

variable "vm_name" {
    description = "name of development virtual machine"
    type = string
    default = "dev_linux_vm"
}

variable "vm_size" {
    description = "size of the vm"
    type = string
    default = "Standard_F2"
}

variable "vm_admin_usrname" {
    description = "username of the admin user on the vm"
    type = string
    default = "dev"
}

variable "vm_custom_data" {
    description = "path to the init script"
    type = string
    default = "./scripts/init.sh"
}

variable "vm_os_disk_name" {
    description = "virutal machine OS disk name"
    type = string
    default = "dev_linux_vm_os_disk"
}

variable "vm_os_disk_caching" {
    description = "virutal machine OS disk caching"
    type = string
    default = "ReadWrite"
}

variable "vm_os_disk_storage_type" {
    description = "virtual machine OS disk storage"
    type = string
    default = "Standard_LRS"
}

variable "vm_pub_key_path" {
    description = "path to a ssh public key"
    type = string
    default = "~/.ssh/id_rsa.pub"
}

variable "vm_private_key_path" {
    description = "path to the ssh private key"
    type = string
    default = "~/.ssh/id_rsa"
}

variable "host_OS" {
    description = "OS of the machine running the terraform script"
    type = string
    default = "windows"
}



