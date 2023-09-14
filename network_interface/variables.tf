variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
}

variable "location" {
  description = "Name of the Azure Location"
  default = "eastus"
}

variable "subnet_id" {
  description = "Azure subnet ID"
}

variable "virtual_network_name" {
  description = "Name of the virtual network"
  type        = string
}

variable "public_ip_address_id" {
  description = "Azure public_ip_address_id"
}

variable "network_interface_name" {
  description = "Azure network_interface"
}

variable "ip_configuration_name" {
  description = "Azure ip_configuration_name"
}