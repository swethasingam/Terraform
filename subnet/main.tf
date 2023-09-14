# Define an Azure Subnet resource.
resource "azurerm_subnet" "subnet" {
  name                 = "hello-world-subnet"                # Name of the Subnet.
  resource_group_name  = var.resource_group_name  # Name of the Azure Resource Group.
  virtual_network_name = var.virtual_network_name    # Name of the parent Virtual Network.
  address_prefixes     = ["10.0.1.0/24"]                     # IP address range for the subnet.

  # A subnet is a logical subdivision within an Azure Virtual Network (VNet) and is defined by its address range.
}