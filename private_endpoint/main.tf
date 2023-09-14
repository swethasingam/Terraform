# Define an Azure Private Endpoint resource.
resource "azurerm_private_endpoint" "endpoint" {
  name                = "hello-world-endpoint"  # Name of the Private Endpoint.
  location            = var.resource_group_name  # Location where the Private Endpoint will be created.
  resource_group_name = var.location  # Name of the Azure Resource Group.

  subnet_id = var.subnet_id  # ID of the subnet to associate with the Private Endpoint.

  # Define a private service connection within the Private Endpoint.
  private_service_connection {
    name                           = "hello-world-connection"  # Name of the private service connection.
    private_connection_resource_id = var.private_connection_resource_id # ID of the target Azure Storage Account.
    subresource_names              = ["blob"]  # Subresources to access within the target resource.
    is_manual_connection           = true  # Specify that this is a manual connection.

    # Additional request message to describe the purpose of the connection.
    request_message = jsonencode({
      description = "Connection to Azure Storage Account",  # Description of the connection.
    })
  }
}