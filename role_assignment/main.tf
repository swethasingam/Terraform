# Define an Azure Role Assignment resource.
resource "azurerm_role_assignment" "vm_storage_access" {
  principal_id        = azurerm_virtual_machine.vm.identity[0].principal_id  # Principal ID of the entity being assigned the role.
  role_definition_name = "Storage Blob Data Contributor"  # Name of the Azure role to assign.

  scope               = azurerm_storage_account.storage.id  # The scope or target resource where the role is being assigned.

  # This resource assigns the "Storage Blob Data Contributor" role to a principal (e.g., a virtual machine)
  # to grant them access to the specified Azure Storage Account.
}
