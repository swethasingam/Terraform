# Define an Azure Virtual Network resource.
resource "azurerm_virtual_network" "vnet" {
  name                = "hello-world-vnet"                 # Name of the Virtual Network.
  address_space       = ["10.0.0.0/16"]                    # Address space for the Virtual Network.
  location            = azurerm_resource_group.rsc_grp.location  # Location where the Virtual Network will be created.
  resource_group_name = azurerm_resource_group.rsc_grp.name     # Name of the Azure Resource Group.

  # A Virtual Network is a fundamental building block for creating private network communication in Azure.
  # It defines the IP address space that resources within the network can use.
}
