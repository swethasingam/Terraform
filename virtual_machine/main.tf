# Define an Azure Virtual Network resource.
# Create an Azure Storage Account resource with a unique name composed of "helloworldstorage" and a random string suffix.
# This resource will be created in the same resource group and location as the specified Azure Resource Group.
# Combine a prefix with the random suffix to create the storage account name
# Define an Azure Key Vault resource.
locals {
  keyvault_name = "hello-world-key-vault"
}

output "keyvault_name" {
  value = local.keyvault_name
}

output "key_vault_id" {
  value = azurerm_key_vault.keyvault.id
}

resource "azurerm_key_vault" "keyvault" {
  name                = "hello-world-key-vault"                    # Name of the Azure Key Vault.
  location            = var.location    # Location where the Key Vault will be created.
  resource_group_name = var.resource_group_name         # Name of the Azure Resource Group.

  sku_name  = "standard"                                           # Specify the SKU (Pricing tier) for the Key Vault.
  tenant_id = var.tenant_id                                       # Tenant ID for Azure Active Directory.

  enabled_for_disk_encryption     = true                           # Enable disk encryption with this Key Vault.
  enabled_for_template_deployment = true                           # Enable template deployment with this Key Vault.
  soft_delete_retention_days      = 7                              # Number of days to retain soft-deleted keys.
  purge_protection_enabled        = false                          # Disable purge protection.

 # key_permissions = ["get"]                                        # Permissions for keys (Read access).
 # secret_permissions = ["get","set"]                              # Permissions for secrets (Read & Set access).
}

resource "azurerm_key_vault_access_policy" "storage" {
  key_vault_id = azurerm_key_vault.keyvault.id
  tenant_id    = var.tenant_id
  object_id    = var.object_id

  secret_permissions = ["Get"]
  key_permissions = [
    "Get",
    "UnwrapKey",
    "WrapKey"
  ]
}

resource "azurerm_key_vault_access_policy" "client" {
  key_vault_id = azurerm_key_vault.keyvault.id
  tenant_id    = var.tenant_id
  object_id    = var.object_id

  secret_permissions = ["Get"]
  key_permissions = [
    "Get",
    "Create",
    "Delete",
    "List",
    "Restore",
    "Recover",
    "UnwrapKey",
    "WrapKey",
    "Purge",
    "Encrypt",
    "Decrypt",
    "Sign",
    "Verify",
    "GetRotationPolicy",
    "SetRotationPolicy"
  ]
}

# Generate a random password.
resource "random_password" "random_password" {
  length           = 16
  special          = true
  upper            = true
  lower            = true
  numeric           = true
  override_special = "_@%"
}


# Create a secret in the Azure Key Vault to store the username.
resource "azurerm_key_vault_secret" "username" {
  name         = "username"                                    # Name of the secret.
  value        = "helloworld"                                  # Value of the secret
  key_vault_id = azurerm_key_vault.keyvault.id                     # ID of the Azure Key Vault.
}

# Create a secret in the Azure Key Vault to store the random password.
resource "azurerm_key_vault_secret" "password" {
  name         = "secret-password"                                  # Name of the secret.
  value        = random_password.random_password.result        # Value of the secret (randomly generated password).
  key_vault_id = azurerm_key_vault.keyvault.id                       # ID of the Azure Key Vault.
}

resource "azurerm_key_vault_key" "keyvault_key" {
  name         = var.keyvault_key_name                   # Name of the RSA key.
  key_vault_id = azurerm_key_vault.keyvault.id       # ID of the Azure Key Vault where the key will be stored.

  key_type     = "RSA"                               # Specify the key type as RSA.
  key_size     = 2048                                # Specify the key size (2048 bits).

    key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey"
  ]

  depends_on = [
    azurerm_key_vault_access_policy.client,
    azurerm_key_vault_access_policy.storage
  ]

  # Define the key options (operations allowed with this key).
  # - "decrypt": Key can be used for decryption operations.
  # - "encrypt": Key can be used for encryption operations.
  # - "sign": Key can be used for signing data.
  # - "verify": Key can be used for verifying signatures.
}

resource "azurerm_storage_account" "storage" {
  name                     = "hwsa"  # Name of the storage account
  resource_group_name      = var.resource_group_name  # Name of the associated Azure Resource Group
  location                 = var.location  # Location of the storage account
  account_tier             = "Standard"  # Performance tier of the storage account (Standard or Premium)
  account_replication_type = "LRS"  # Replication type for data redundancy (LRS, GRS, etc.)
  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = [
      customer_managed_key
    ]
  }
}


resource "azurerm_storage_account_customer_managed_key" "example" {
  storage_account_id = azurerm_storage_account.storage.id
  key_vault_id       = azurerm_key_vault.keyvault.id
  key_name           = var.keyvault_key_name
}

# Define an Azure Role Assignment resource.
resource "azurerm_role_assignment" "vm_storage_access" {
  principal_id        = azurerm_virtual_machine.vm.identity[0].principal_id  # Principal ID of the entity being assigned the role.
  role_definition_name = "Storage Blob Data Contributor"  # Name of the Azure role to assign.
  scope               = azurerm_storage_account.storage.id  # The scope or target resource where the role is being assigned.

  # This resource assigns the "Storage Blob Data Contributor" role to a principal (e.g., a virtual machine)
  # to grant them access to the specified Azure Storage Account.
}

# resource "azurerm_storage_container" "blob_container" {
#   name                  = var.container_name  # Name of the Blob Storage container.
#   storage_account_name  = var.storage_account_name  # Name of the Azure Storage Account.
#   container_access_type = "private"  # Access level for the container (e.g., private, blob, container).
# }

resource "azurerm_virtual_network" "vnet" {
  name                = "hello-world-vnet"                 # Name of the Virtual Network.
  address_space       = ["10.0.0.0/16"]                    # Address space for the Virtual Network.
  location            = var.location                       # Location where the Virtual Network will be created.
  resource_group_name = var.resource_group_name            # Name of the Azure Resource Group.

  # A Virtual Network is a fundamental building block for creating private network communication in Azure.
  # It defines the IP address space that resources within the network can use.
}

# Define an Azure Virtual Machine resource.
# Define an Azure Subnet resource.
resource "azurerm_subnet" "subnet" {
  name                 = "hello-world-subnet"                # Name of the Subnet.
  resource_group_name  = var.resource_group_name  # Name of the Azure Resource Group.
  virtual_network_name = azurerm_virtual_network.vnet.name    # Name of the parent Virtual Network.
  address_prefixes     = ["10.0.1.0/24"]                     # IP address range for the subnet.

  # A subnet is a logical subdivision within an Azure Virtual Network (VNet) and is defined by its address range.
}

# Define an Azure Public IP Address resource.
resource "azurerm_public_ip" "public_ip" {
  name                = "hello-world-pip"                      # Name of the Public IP Address.
  location            = var.location  # Location where the Public IP Address will be created.
  resource_group_name = var.resource_group_name     # Name of the Azure Resource Group.

  allocation_method   = "Static"                                # Specify the allocation method as "Static."

  # A static Public IP Address provides a fixed, unchanging IP address to associated resources.
}

resource "azurerm_network_interface" "nic" {
  name                = "vm-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "hello-world-config"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id  # Reference the public IP address from ./public_ip/main.tf
  }
}

# Define a Virtual Network Link to associate a Virtual Network with a Private DNS Zone.
resource "azurerm_private_dns_zone_virtual_network_link" "network_link" {
  name                  = "hello-world-link"  # Name of the Virtual Network Link.
  resource_group_name   = var.resource_group_name  # Name of the Azure Resource Group.
  private_dns_zone_name = var.private_dns_zone_name  # Name of the Private DNS Zone to link to.
  virtual_network_id    = azurerm_virtual_network.vnet.id  # ID of the Virtual Network to link.

  # This resource establishes a link between the Private DNS Zone and the Virtual Network,
  # enabling DNS resolution for resources in the Virtual Network using the Private DNS Zone.
}

# Define an Azure Private Endpoint resource.
resource "azurerm_private_endpoint" "endpoint" {
  name                = "hello-world-endpoint"  # Name of the Private Endpoint.
  location            = var.location  # Location where the Private Endpoint will be created.
  resource_group_name = var.resource_group_name # Name of the Azure Resource Group.
  subnet_id = azurerm_subnet.subnet.id  # ID of the subnet to associate with the Private Endpoint.

  # Define a private service connection within the Private Endpoint.
  private_service_connection {
    name                           = "hello-world-connection"  # Name of the private service connection.
    private_connection_resource_id = azurerm_storage_account.storage.id # ID of the target Azure Storage Account.
    subresource_names              = ["blob"]  # Subresources to access within the target resource.
    is_manual_connection           = true  # Specify that this is a manual connection.

    # Additional request message to describe the purpose of the connection.
    request_message = jsonencode({
      description = "Connection to Azure Storage Account",  # Description of the connection.
    })
  }
}


# Define an Azure User-Assigned Managed Identity resource.
resource "azurerm_user_assigned_identity" "vm_identity" {
  resource_group_name = var.resource_group_name  # Name of the Azure Resource Group.
  location            = var.location  # Location where the Managed Identity will be created.
  name                = "vm-identity"  # Name of the User-Assigned Managed Identity.

  # A User-Assigned Managed Identity allows applications to authenticate and access Azure resources securely.
}

resource "azurerm_virtual_machine" "vm" {
  name                  = "helloworld-vm"  # Name of the Virtual Machine.
  location              = var.location  # Location where the VM will be created.
  resource_group_name   = var.resource_group_name  # Name of the Azure Resource Group.
  network_interface_ids = [azurerm_network_interface.nic.id] # IDs of attached network interfaces.
  vm_size               = "Standard_DS2_v2"  # Virtual machine size.

  # Define the OS disk configuration.
  storage_os_disk {
    name              = "hello-world-osdisk"  # Name of the OS disk.
    caching           = "ReadWrite"  # Caching settings for the OS disk.
    create_option     = "FromImage"  # Create the OS disk from an image.
    managed_disk_type = "Standard_LRS"  # Managed disk type for the OS disk.
  }

  # Define the image reference for the VM's OS.
  storage_image_reference {
    publisher = "OpenLogic"  # Publisher of the OS image.
    offer     = "CentOS"     # Offer of the OS image.
    sku       = "7_8"        # SKU of the OS image.
    version   = "latest"     # Version of the OS image.
  }

  # Define the OS profile configuration.
  os_profile {
    computer_name  = "helloworld-vm"  # Computer name of the VM.
    admin_username = "adminuser"     # Admin username for the VM.
    admin_password = "Password1234!" # Admin password for the VM (please consider using secrets for production).

    # Specify the OS profile details for Windows VM.
    # For Linux VM, you can use "os_profile_linux_config" instead.
  }

  # Define the Linux OS profile configuration.
  os_profile_linux_config {
    disable_password_authentication = false  # Enable password authentication for SSH.
  }

  # Configure the user-assigned managed identity for the VM.
  identity {
    type         = "UserAssigned"  # Type of identity (UserAssigned).
    identity_ids = [azurerm_user_assigned_identity.vm_identity.id]  # ID of the user-assigned identity.
  }

  # Provisioner block for executing remote commands on the VM.
  provisioner "remote-exec" {
    inline = [
      "sudo yum install -y epel-release",
      "sudo yum install -y tomcat tomcat-webapps tomcat-admin-webapps",
      "sudo systemctl start tomcat",
      "sudo systemctl enable tomcat",
      "sudo sed -i 's/Connector port=\"8080\"/Connector port=\"8080\"/' /etc/tomcat/server.xml",
      "sudo systemctl restart tomcat"
    ]

    # SSH connection details to the VM.
    connection {
      host     = azurerm_public_ip.public_ip.ip_address  # Access public IP via NIC
      type     = "ssh"
      user     = "adminuser"
      password = "Password1234!"
      agent    = false
      timeout  = "5m"
    }
  }
}
