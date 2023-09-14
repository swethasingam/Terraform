resource "azurerm_storage_container" "blob_container" {
  name                  = var.container_name  # Name of the Blob Storage container.
  storage_account_name  = var.storage_account_name  # Name of the Azure Storage Account.
  container_access_type = "private"  # Access level for the container (e.g., private, blob, container).
}

# This resource creates a Blob Storage container within the specified Azure Storage Account.
