# Define an Azure Key Vault resource.
locals {
  keyvault_name = "hello-world-key-vault"
}

output "keyvault_name" {
  value = local.keyvault_name
}

output "key_vault_id" {
  value = azurerm_key_vault.keyvault.id
}

resource "azurerm_key_vault" "keyvault" {
  name                = var.keyvault_name                    # Name of the Azure Key Vault.
  location            = var.location    # Location where the Key Vault will be created.
  resource_group_name = var.resource_group_name         # Name of the Azure Resource Group.

  sku_name  = "standard"                                           # Specify the SKU (Pricing tier) for the Key Vault.
  tenant_id = var.tenant_id                                       # Tenant ID for Azure Active Directory.

  enabled_for_disk_encryption     = true                           # Enable disk encryption with this Key Vault.
  enabled_for_template_deployment = true                           # Enable template deployment with this Key Vault.
  soft_delete_retention_days      = 7                              # Number of days to retain soft-deleted keys.
  purge_protection_enabled        = false                          # Disable purge protection.

 # key_permissions = ["get"]                                        # Permissions for keys (Read access).
 # secret_permissions = ["get","set"]                              # Permissions for secrets (Read & Set access).
}

resource "azurerm_key_vault_access_policy" "storage" {
  key_vault_id = var.key_vault_id
  tenant_id    = var.tenant_id
  object_id    = var.object_id

  secret_permissions = ["Get"]
  key_permissions = [
    "Get",
    "UnwrapKey",
    "WrapKey"
  ]
}

resource "azurerm_key_vault_access_policy" "client" {
  key_vault_id = var.key_vault_id
  tenant_id    = var.tenant_id
  object_id    = var.object_id

  secret_permissions = ["Get"]
  key_permissions = [
    "Get",
    "Create",
    "Delete",
    "List",
    "Restore",
    "Recover",
    "UnwrapKey",
    "WrapKey",
    "Purge",
    "Encrypt",
    "Decrypt",
    "Sign",
    "Verify",
    "GetRotationPolicy",
    "SetRotationPolicy"
  ]
}

# Generate a random password.
resource "random_password" "random_password" {
  length           = 16
  special          = true
  upper            = true
  lower            = true
  numeric           = true
  override_special = "_@%"
}


# Create a secret in the Azure Key Vault to store the username.
resource "azurerm_key_vault_secret" "username" {
  name         = "username"                                    # Name of the secret.
  value        = "helloworld"                                  # Value of the secret
  key_vault_id = var.key_vault_id                     # ID of the Azure Key Vault.
}

# Create a secret in the Azure Key Vault to store the random password.
resource "azurerm_key_vault_secret" "password" {
  name         = "secret-password"                                  # Name of the secret.
  value        = random_password.random_password.result        # Value of the secret (randomly generated password).
  key_vault_id = var.key_vault_id                       # ID of the Azure Key Vault.
}

resource "azurerm_key_vault_key" "keyvault_key" {
  name         = var.keyvault_key_name                   # Name of the RSA key.
  key_vault_id = var.key_vault_id       # ID of the Azure Key Vault where the key will be stored.

  key_type     = "RSA"                               # Specify the key type as RSA.
  key_size     = 2048                                # Specify the key size (2048 bits).

    key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey"
  ]

  depends_on = [
    azurerm_key_vault_access_policy.client,
    azurerm_key_vault_access_policy.storage
  ]

  # Define the key options (operations allowed with this key).
  # - "decrypt": Key can be used for decryption operations.
  # - "encrypt": Key can be used for encryption operations.
  # - "sign": Key can be used for signing data.
  # - "verify": Key can be used for verifying signatures.
}