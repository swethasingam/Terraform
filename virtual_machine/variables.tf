variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
}

variable "location" {
  description = "Name of the Azure Location"
  default = "eastus"
}

variable "host" {
  description = "Azure azurerm_public_ip"
}

variable "identity_ids" {
  description = "Name of the identity_ids"
}

variable "network_interface_ids" {
  description = "Name of the network_interface_ids"
}