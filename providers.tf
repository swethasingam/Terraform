# Configure Terraform to use the "azurerm" provider at a specific version.
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm" # Source of the "azurerm" provider (HashiCorp's official Azure provider).
      version = "~>3.68.0"          # Version of the "azurerm" provider to use.

      # The "azurerm" provider allows Terraform to interact with Microsoft Azure resources.
      # Ensure that you use the appropriate version of the provider depending on your project's requirements.
    }
  }
}

provider "azurerm" {
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  features {}
}