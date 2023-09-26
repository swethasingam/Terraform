# Define an Azure Public IP Address resource.
resource "azurerm_public_ip" "public_ip" {
  name                = "hello-world-pip"       # Name of the Public IP Address.
  location            = var.location            # Location where the Public IP Address will be created.
  resource_group_name = var.resource_group_name # Name of the Azure Resource Group.
  allocation_method   = "Static"                # Specify the allocation method as "Static."

  # A static Public IP Address provides a fixed, unchanging IP address to associated resources.
}