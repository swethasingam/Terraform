# Define an Azure Resource Group resource.
resource "azurerm_resource_group" "rsc_grp" {
  name     = "hello-world-rg"  # Name of the Azure Resource Group.
  location = "eastus"         # Location where the Resource Group will be created.

  # A Resource Group is a logical container for Azure resources, providing management and organization.
}
