resource "azurerm_storage_account" "storage" {
  name                     = "hwsa"                  # Name of the storage account
  resource_group_name      = var.resource_group_name # Name of the associated Azure Resource Group
  location                 = var.location            # Location of the storage account
  account_tier             = "Standard"              # Performance tier of the storage account (Standard or Premium)
  account_replication_type = "LRS"                   # Replication type for data redundancy (LRS, GRS, etc.)
  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = [
      customer_managed_key
    ]
  }
}


resource "azurerm_storage_account_customer_managed_key" "example" {
  storage_account_id = azurerm_storage_account.storage.id
  key_vault_id       = azurerm_key_vault.keyvault.id
  key_name           = var.keyvault_key_name
}


resource "azurerm_storage_container" "blob_container" {
  name                  = var.container_name       # Name of the Blob Storage container.
  storage_account_name  = var.storage_account_name # Name of the Azure Storage Account.
  container_access_type = "private"                # Access level for the container (e.g., private, blob, container).
}


# # Configure Terraform to use an Azure Storage Account as the backend for state storage.
# terraform {
#   backend "azurerm" {
#     resource_group_name   = var.resource_group_name     # Name of the Azure Resource Group for the backend.
#     storage_account_name  = var.storage_account_name   # Name of the Azure Storage Account for the backend.
#     container_name        = var.container_name          # Name of the Azure Blob Storage container for storing state.
#     key                   = "terraform.tfstate"            # Name of the state file within the container.

#     # Using Azure Storage as a backend allows you to store Terraform state remotely and securely.
#     # Ensure that you replace "your-resource-group-name", "your-storage-account-name", and "your-container-name" with
#     # actual values corresponding to your Azure environment.
#   }
# }