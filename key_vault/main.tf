# Define an Azure Key Vault resource.
resource "azurerm_key_vault" "keyvault" {
  name                = "hello-world-key-vault"                    # Name of the Azure Key Vault.
  location            = azurerm_resource_group.rsc_grp.location    # Location where the Key Vault will be created.
  resource_group_name = azurerm_resource_group.rsc_grp.name         # Name of the Azure Resource Group.

  sku_name  = "standard"                                           # Specify the SKU (Pricing tier) for the Key Vault.
  tenant_id = var.tenant_id                                       # Tenant ID for Azure Active Directory.

  enabled_for_disk_encryption     = true                           # Enable disk encryption with this Key Vault.
  enabled_for_template_deployment = true                           # Enable template deployment with this Key Vault.
  soft_delete_retention_days      = 7                              # Number of days to retain soft-deleted keys.
  purge_protection_enabled        = false                          # Disable purge protection.

  key_permissions = [
    "get",                                                         # Permissions for keys (Read access).
  ]

  secret_permissions = [
    "get",                                                         # Permissions for secrets (Read access).
    "set",                                                         # Permissions for secrets (Set access).
  ]
}

# Generate a random password.
data "random_password" "random_password" {
  length           = 16                                            # Length of the random password.
  special          = true                                          # Include special characters.
  upper            = true                                          # Include uppercase letters.
  lower            = true                                          # Include lowercase letters.
  number           = true                                          # Include numbers.
  override_special = "_@%"                                         # Specify additional special characters.
}

# Create a secret in the Azure Key Vault to store the username.
resource "azurerm_key_vault_secret" "username" {
  name         = "my-username"                                    # Name of the secret.
  value        = "your-username"                                  # Value of the secret
  key_vault_id = azurerm_key_vault.example.id                     # ID of the Azure Key Vault.
}

# Create a secret in the Azure Key Vault to store the random password.
resource "azurerm_key_vault_secret" "password_secret" {
  name         = "secret-password"                                  # Name of the secret.
  value        = data.random_password.random_password.result        # Value of the secret (randomly generated password).
  key_vault_id = azurerm_key_vault.keyvault.id                       # ID of the Azure Key Vault.
}