resource "azurerm_key_vault_key" "keyvault_key" {
  name         = var.keyvault_key_name         # Name of the RSA key.
  key_vault_id = azurerm_key_vault.keyvault.id # ID of the Azure Key Vault where the key will be stored.

  key_type = "RSA" # Specify the key type as RSA.
  key_size = 2048  # Specify the key size (2048 bits).

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