# Define a Virtual Network Link to associate a Virtual Network with a Private DNS Zone.
resource "azurerm_private_dns_zone_virtual_network_link" "example" {
  name                  = "hello-world-link"  # Name of the Virtual Network Link.
  resource_group_name   = azurerm_resource_group.rsc_grp.name  # Name of the Azure Resource Group.
  private_dns_zone_name = azurerm_private_dns_zone.dns.name  # Name of the Private DNS Zone to link to.
  virtual_network_id    = azurerm_virtual_network.vnet.id  # ID of the Virtual Network to link.

  # This resource establishes a link between the Private DNS Zone and the Virtual Network,
  # enabling DNS resolution for resources in the Virtual Network using the Private DNS Zone.
}
