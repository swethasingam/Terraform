# Define an Azure Network Interface (NIC) resource.
resource "azurerm_network_interface" "nic" {
  name                = "hello-world-nic"  # Name of the Network Interface.
  location            = azurerm_resource_group.rsc_grp.location  # Location where the NIC will be created.
  resource_group_name = azurerm_resource_group.rsc_grp.name  # Name of the Azure Resource Group.

  # Define IP configuration settings for the NIC.
  ip_configuration {
    name                          = "hello-world-config"  # Name of the IP configuration.
    subnet_id                     = azurerm_subnet.subnet.id  # ID of the subnet to associate with.
    private_ip_address_allocation = "Dynamic"  # Allocate a private IP address dynamically.
    public_ip_address_id          = azurerm_public_ip.public_ip.id  # ID of the associated public IP address.
  }
}