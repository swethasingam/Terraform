# Generate a random password.
resource "random_password" "random_password" {
  length           = 16
  special          = true
  upper            = true
  lower            = true
  numeric          = true
  override_special = "_@%"
}


# Create a secret in the Azure Key Vault to store the username.
resource "azurerm_key_vault_secret" "username" {
  name         = "username"                    # Name of the secret.
  value        = "helloworld"                  # Value of the secret
  key_vault_id = azurerm_key_vault.keyvault.id # ID of the Azure Key Vault.
}

# Create a secret in the Azure Key Vault to store the random password.
resource "azurerm_key_vault_secret" "password" {
  name         = "secret-password"                      # Name of the secret.
  value        = random_password.random_password.result # Value of the secret (randomly generated password).
  key_vault_id = azurerm_key_vault.keyvault.id          # ID of the Azure Key Vault.
}