# Define an Azure Storage Account resource.
resource "azurerm_storage_account" "storage" {
  name                     = "helloworldstorage${random_string.random_suffix.result}"  # Name of the Storage Account.
  resource_group_name      = azurerm_resource_group.rsc_grp.name  # Name of the Azure Resource Group.
  location                 = azurerm_resource_group.rsc_grp.location  # Location where the Storage Account will be created.

  account_tier             = "Standard"  # Specify the storage account tier (e.g., Standard).
  account_replication_type = "LRS"      # Specify the replication type (e.g., LRS - Locally Redundant Storage).

  # This resource defines an Azure Storage Account for storing various types of data, such as files, blobs, and more.
}