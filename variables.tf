# Azure Subscription ID.
variable "subscription_id" {
  description = "Azure Subscription ID"
}

# Azure Service Principal Client ID.
variable "client_id" {
  description = "Azure Service Principal Client ID"
}

# Azure Service Principal Client Secret.
variable "client_secret" {
  description = "Azure Service Principal Client Secret"
}

# Azure Tenant ID.
variable "object_id" {
  description = "Azure object_id"
}

variable "tenant_id" {
  description = "Azure Tenant ID"
}

variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
  type        = string
}

variable "location" {
  description = "Location where the Resource Group will be created"
  type        = string
}

variable "container_name" {
  description = "Name of the Azure Storage Account"
}

variable "keyvault_name" {
  description = "Name of the Azure Storage Account"
}

variable "keyvault_key_name" {
  description = "Name of the Azure Storage Account"
}

variable "virtual_network_name" {
  description = "Name of the virtual network"
  type        = string
}


variable "network_interface_name" {
  description = "Azure network_interface"
}

variable "ip_configuration_name" {
  description = "Azure ip_configuration_name"
}

variable "storage_account_name" {
  description = "Name of the Azure Storage Account for the backend."
  type        = string
}


variable "private_dns_zone_name" {
  description = "Name of the Azure private_dns_zone_name"
}

# variable "private_connection_resource_id" {
#   description = "Name of the private_connection_resource_id"
# }

# variable "identity_ids" {
#   description = "Name of the identity_ids"
# }

# variable "network_interface_ids" {
#   description = "Name of the network_interface_ids"
# }

# variable "virtual_network_id" {
#   description = "Name of the virtual_network_id"
# }

# variable "storage_account_id" {
#   description = "Name of the storage account id"
# }

# variable "principal_id" {
#   description = "Name of the Azure principal_id"
# }

# variable "public_ip_address_id" {
#   description = "Azure public_ip_address_id"
# }

# variable "key_vault_id" {
#   description = "Azure KeyVault ID"
# }

# variable "subnet_id" {
#   description = "Azure subnet ID"
# }