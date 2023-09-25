# Configure Terraform to use an Azure Storage Account as the backend for state storage.
# terraform {
#   backend "azurerm" {
#     resource_group_name   = "hello-world-rg"     # Name of the Azure Resource Group for the backend.
#     storage_account_name  = "hwsa"   # Name of the Azure Storage Account for the backend.
#     container_name        = "helloworld-blobcontainer"          # Name of the Azure Blob Storage container for storing state.
#     key                   = "terraform.tfstate"            # Name of the state file within the container.

#     # Using Azure Storage as a backend allows you to store Terraform state remotely and securely.
#     # Ensure that you replace "your-resource-group-name", "your-storage-account-name", and "your-container-name" with
#     # actual values corresponding to your Azure environment.
#   }
# }

module "resource_group" {
  source              = "./resource_group"
  resource_group_name = var.resource_group_name
  location            = var.location
}

module "virtual_machine" {
  source                = "./virtual_machine"
  resource_group_name   = var.resource_group_name
  location              = var.location
  private_dns_zone_name = var.private_dns_zone_name
  tenant_id                     = var.tenant_id
  object_id = var.object_id
  keyvault_key_name = var.keyvault_key_name
}

module "private_dns_zone" {
  source                = "./private_dns_zone"
  private_dns_zone_name = var.private_dns_zone_name
  resource_group_name   = var.resource_group_name
}

provider "azurerm" {
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  features {}
}