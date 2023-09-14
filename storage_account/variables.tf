variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
}

variable "location" {
  description = "Name of the Azure Location"
  default = "eastus"
}

variable "storage_account_name" {
  description = "Name of the Azure storage_account_name"
  type = string
}

variable "storage_account_id" {
  description = "Name of the Azure storage_account_id"
}

variable "key_vault_id" {
  description = "Name of the Azure key_vault_id"
}

variable "keyvault_key_name" {
  description = "Name of the Azure keyvault_key_name"
}
