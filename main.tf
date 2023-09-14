module "resource_group" {
  source              = "./resource_group"
  resource_group_name = var.resource_group_name
  location            = var.location
}

module "key_vault" {
  source              = "./key_vault"
  resource_group_name = var.resource_group_name
  location            = var.location
  keyvault_name       = var.keyvault_name
  key_vault_id        = var.key_vault_id
  tenant_id           = var.tenant_id
  object_id           = var.object_id
  keyvault_key_name   = var.keyvault_key_name
}

module "storage_account" {
  source              = "./storage_account"
  storage_account_name = var.storage_account_name
  resource_group_name = var.resource_group_name
  location            = var.location
  storage_account_id  = var.storage_account_id
  key_vault_id        = var.key_vault_id
  keyvault_key_name   = var.keyvault_key_name
}

module "blob_container" {
  source               = "./blob_container"
  storage_account_name = module.storage_account.storage_account_name
  container_name       = var.container_name
}

module "virtual_network" {
  source               = "./virtual_network"
  resource_group_name  = var.resource_group_name
  location             = var.location
  virtual_network_name = var.virtual_network_name
}

module "subnet" {
  source               = "./subnet"
  virtual_network_name = var.virtual_network_name
  resource_group_name  = var.resource_group_name
}

module "public_ip" {
  source              = "./public_ip"
  resource_group_name = var.resource_group_name
  location            = var.location
}

module "network_interface" {
  source                 = "./network_interface"
  network_interface_name = var.network_interface_name
  resource_group_name    = var.resource_group_name
  location               = var.location
  public_ip_address_id   = var.public_ip_address_id
  subnet_id              = var.subnet_id
  virtual_network_name   = var.virtual_network_name
  ip_configuration_name  = var.ip_configuration_name
}

module "user_assigned_identity" {
  source              = "./user_assigned_identity"
  resource_group_name = var.resource_group_name
  location            = var.location
}

module "virtual_machine" {
  source                = "./virtual_machine"
  resource_group_name   = var.resource_group_name
  location              = var.location
  host                  = var.host
  identity_ids          = var.identity_ids
  network_interface_ids = var.network_interface_ids
}

module "role_assignment" {
  source             = "./role_assignment"
  storage_account_id = var.storage_account_id
  principal_id       = var.principal_id
}

module "private_dns_zone" {
  source                = "./private_dns_zone"
  private_dns_zone_name = var.private_dns_zone_name
  resource_group_name   = var.resource_group_name
}

module "private_dns_zone_virtual_network_link" {
  source                = "./private_dns_zone_virtual_network_link"
  private_dns_zone_name = var.private_dns_zone_name
  virtual_network_id    = var.virtual_network_id
  resource_group_name   = var.resource_group_name
}

module "private_endpoint" {
  source                         = "./private_endpoint"
  resource_group_name            = var.resource_group_name
  location                       = var.location
  private_connection_resource_id = var.storage_account_id
  subnet_id                      = var.subnet_id
}

provider "azurerm" {
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  features {}
}