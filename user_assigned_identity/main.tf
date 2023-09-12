# Define an Azure User-Assigned Managed Identity resource.
resource "azurerm_user_assigned_identity" "vm_identity" {
  resource_group_name = azurerm_resource_group.rsc_grp.name  # Name of the Azure Resource Group.
  location            = azurerm_resource_group.rsc_grp.location  # Location where the Managed Identity will be created.
  name                = "vm-identity"  # Name of the User-Assigned Managed Identity.

  # A User-Assigned Managed Identity allows applications to authenticate and access Azure resources securely.
}