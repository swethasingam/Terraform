variable "tenant_id" {
  description = "Azure Tenant ID"
}

variable "object_id" {
  description = "Azure object_id"
}

variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
}

variable "private_dns_zone_name" {
  description = "Name of the Azure private_dns_zone_name"
}

variable "location" {
  description = "Name of the Azure Location"
  default = "eastus"
}

variable "keyvault_key_name" {
  description = "Name of the Azure Storage Account"
}