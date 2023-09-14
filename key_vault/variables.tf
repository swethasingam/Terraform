variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
}

variable "location" {
  description = "Name of the Azure Location"
  default = "eastus"
}

variable "key_vault_id" {
  description = "Name of the Azure key_vault_id"
}

variable "tenant_id" {
  description = "Azure Tenant ID"
}

variable "keyvault_name" {
  description = "Name of the Azure Storage Account"
}