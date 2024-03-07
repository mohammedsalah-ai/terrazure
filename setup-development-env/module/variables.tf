variable "resources-g-name" {
    description = "Resource group name"
    type = string
    default = "dev-rg"
}

variable "location" {
    description = "Resource group location"
    type = string
    default = "East US"
}

variable "virtual-network-name" {
    description = "virtual network name"
    type = string
    default = "dev-virtual-net"
}

variable "addr-space" {
    description = "virtual network address space, a list of CIDR blocks"
    type = list(string)
    default = ["10.10.0.0/16"]
}

variable "subnet-name" {
    description = "virtual network subnet name"
    type = string
    default = "dev-virtual-net-subnet"
}

variable "subnet-addr-prefixes" {
    description = "CIDR blocks defining the subnet"
    type = list(string)
    default = ["10.10.1.0/24"]
}

variable "network-sec-g-name" {
    description = "network security group name that'll be assigned to the created subnet"
    type = string
    default = "dev-network-sec-g"
}

variable "network-sec-g-rules-name" {
    description = "network security group rules name"
    type = string
    default = "dev-network-sec-g-rules"
}

variable "pub-ip-name" {
    description = "public ip name"
    type = string
    default = "dev-pub-ip"
}

variable "network-interface-name" {
    description = "network interface that'll be assigned to the VM"
    type = string
    default = "dev-nic"
}

variable "nic-ip-config-name" {
    description = "name of ip configuration of the network interface"
    type = string
    default = "dev-nic-ip-config"
}

variable "vm-name" {
    description = "name of development virtual machine"
    type = string
    default = "dev-linux-vm"
}

variable "vm-size" {
    description = "size of the vm"
    type = string
    default = "Standard_F2"
}

variable "vm-admin-usrname" {
    description = "username of the admin user on the vm"
    type = string
    default = "dev"
}

variable "vm-custom-data" {
    description = "path to the init script"
    type = string
    default = "./scripts/init.sh"
}

variable "vm-os-disk-name" {
    description = "virutal machine OS disk name"
    type = string
    default = "dev-linux-vm-os-disk"
}

variable "vm-os-disk-caching" {
    description = "virutal machine OS disk caching"
    type = string
    default = "ReadWrite"
}

variable "vm-os-disk-storage-type" {
    description = "virtual machine OS disk storage"
    type = string
    default = "Standard_LRS"
}

variable "vm-pub-key-path" {
    description = "path to a ssh public key"
    type = string
    default = "~/.ssh/id_rsa.pub"
}

variable "vm-private-key-path" {
    description = "path to the ssh private key"
    type = string
    default = "~/.ssh/id_rsa"
}

variable "host-OS" {
    description = "OS of the machine running the terraform script"
    type = string
    default = "windows"
}



