# Define an Azure Resource Group resource.
resource "azurerm_resource_group" "rsc_grp" {
  name     = var.resource_group_name  # Name of the Azure Resource Group.
  location = var.location          # Location where the Resource Group will be created.

  # A Resource Group is a logical container for Azure resources, providing management and organization.
}
