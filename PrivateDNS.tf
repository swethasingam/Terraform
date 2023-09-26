# Define an Azure Private DNS Zone resource.
resource "azurerm_private_dns_zone" "dns" {
  name                = var.private_dns_zone_name # Name of the Private DNS Zone.
  resource_group_name = var.resource_group_name   # Name of the Azure Resource Group where the DNS zone will be created.
}

# Define a Virtual Network Link to associate a Virtual Network with a Private DNS Zone.
resource "azurerm_private_dns_zone_virtual_network_link" "network_link" {
  name                  = "hello-world-link"              # Name of the Virtual Network Link.
  resource_group_name   = var.resource_group_name         # Name of the Azure Resource Group.
  private_dns_zone_name = var.private_dns_zone_name       # Name of the Private DNS Zone to link to.
  virtual_network_id    = azurerm_virtual_network.vnet.id # ID of the Virtual Network to link.

  # This resource establishes a link between the Private DNS Zone and the Virtual Network,
  # enabling DNS resolution for resources in the Virtual Network using the Private DNS Zone.
}