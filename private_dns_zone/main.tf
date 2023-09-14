# Define an Azure Private DNS Zone resource.
resource "azurerm_private_dns_zone" "dns" {
  name                = var.private_dns_zone_name # Name of the Private DNS Zone.
  resource_group_name = var.resource_group_name  # Name of the Azure Resource Group where the DNS zone will be created.
}