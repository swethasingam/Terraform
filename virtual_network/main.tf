# Define an Azure Virtual Network resource.
resource "azurerm_virtual_network" "vnet" {
  name                = var.virtual_network_name                 # Name of the Virtual Network.
  address_space       = ["10.0.0.0/16"]                    # Address space for the Virtual Network.
  location            = var.location                       # Location where the Virtual Network will be created.
  resource_group_name = var.resource_group_name            # Name of the Azure Resource Group.

  # A Virtual Network is a fundamental building block for creating private network communication in Azure.
  # It defines the IP address space that resources within the network can use.
}