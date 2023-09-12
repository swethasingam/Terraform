# Define an Azure Private DNS Zone resource.
resource "azurerm_private_dns_zone" "dns" {
  name                = "privatelink.blob.core.windows.net"  # Name of the Private DNS Zone.
  resource_group_name = azurerm_resource_group.rsc_grp.name  # Name of the Azure Resource Group where the DNS zone will be created.
}