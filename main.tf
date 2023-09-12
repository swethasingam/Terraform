module "resource_group" {
  source = "./resource_group"
}

module "key_vault" {
  source = "./key_vault"
}

module "virtual_network" {
  source = "./virtual_network"
}

# Add modules for other resources here...

provider "azurerm" {
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  features {}
}
