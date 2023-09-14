# Create an Azure Storage Account resource with a unique name composed of "helloworldstorage" and a random string suffix.
# This resource will be created in the same resource group and location as the specified Azure Resource Group.
# Combine a prefix with the random suffix to create the storage account name
locals {
  storage_account_name = "hwstorage${random_string.random_suffix.result}"
}

output "storage_account_name" {
  value = local.storage_account_name
}

resource "azurerm_storage_account" "storage" {
  name                     = local.storage_account_name  # Name of the storage account
  resource_group_name      = var.resource_group_name  # Name of the associated Azure Resource Group
  location                 = var.location  # Location of the storage account
  account_tier             = "Standard"  # Performance tier of the storage account (Standard or Premium)
  account_replication_type = "LRS"  # Replication type for data redundancy (LRS, GRS, etc.)
  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = [
      customer_managed_key
    ]
  }
}

# Generate a random string with a length of 6 characters, excluding special characters and uppercase letters.
resource "random_string" "random_suffix" {
  length  = 6  # Length of the generated random string
  special = false  # Exclude special characters from the random string
  upper   = false  # Exclude uppercase letters from the random string
}

resource "azurerm_storage_account_customer_managed_key" "example" {
  storage_account_id = var.storage_account_id
  key_vault_id       = var.key_vault_id
  key_name           = var.keyvault_key_name
}

# Configure Terraform to use an Azure Storage Account as the backend for state storage.
terraform {
  backend "azurerm" {
    resource_group_name   = var.resource_group_name     # Name of the Azure Resource Group for the backend.
    storage_account_name  = var.storage_account_name   # Name of the Azure Storage Account for the backend.
    container_name        = var.container_name          # Name of the Azure Blob Storage container for storing state.
    key                   = "terraform.tfstate"            # Name of the state file within the container.

    # Using Azure Storage as a backend allows you to store Terraform state remotely and securely.
    # Ensure that you replace "your-resource-group-name", "your-storage-account-name", and "your-container-name" with
    # actual values corresponding to your Azure environment.
  }
}
