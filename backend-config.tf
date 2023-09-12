# Configure Terraform to use an Azure Storage Account as the backend for state storage.
terraform {
  backend "azurerm" {
    resource_group_name   = "your-resource-group-name"     # Name of the Azure Resource Group for the backend.
    storage_account_name  = "your-storage-account-name"    # Name of the Azure Storage Account for the backend.
    container_name        = "your-container-name"          # Name of the Azure Blob Storage container for storing state.
    key                   = "terraform.tfstate"            # Name of the state file within the container.

    # Using Azure Storage as a backend allows you to store Terraform state remotely and securely.
    # Ensure that you replace "your-resource-group-name", "your-storage-account-name", and "your-container-name" with
    # actual values corresponding to your Azure environment.
  }
}
