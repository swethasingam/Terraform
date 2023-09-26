resource "azurerm_key_vault" "keyvault" {
  name                = "hello-world-key-vault" # Name of the Azure Key Vault.
  location            = var.location            # Location where the Key Vault will be created.
  resource_group_name = var.resource_group_name # Name of the Azure Resource Group.

  sku_name  = "standard"    # Specify the SKU (Pricing tier) for the Key Vault.
  tenant_id = var.tenant_id # Tenant ID for Azure Active Directory.

  enabled_for_disk_encryption     = true  # Enable disk encryption with this Key Vault.
  enabled_for_template_deployment = true  # Enable template deployment with this Key Vault.
  soft_delete_retention_days      = 7     # Number of days to retain soft-deleted keys.
  purge_protection_enabled        = false # Disable purge protection.

  # key_permissions = ["get"]                                        # Permissions for keys (Read access).
  # secret_permissions = ["get","set"]                              # Permissions for secrets (Read & Set access).
}