resource "azurerm_virtual_machine" "vm" {
  name                  = "helloworld-vm"                    # Name of the Virtual Machine.
  location              = var.location                       # Location where the VM will be created.
  resource_group_name   = var.resource_group_name            # Name of the Azure Resource Group.
  network_interface_ids = [azurerm_network_interface.nic.id] # IDs of attached network interfaces.
  vm_size               = "Standard_DS2_v2"                  # Virtual machine size.

  # Define the OS disk configuration.
  storage_os_disk {
    name              = "hello-world-osdisk" # Name of the OS disk.
    caching           = "ReadWrite"          # Caching settings for the OS disk.
    create_option     = "FromImage"          # Create the OS disk from an image.
    managed_disk_type = "Standard_LRS"       # Managed disk type for the OS disk.
  }

  # Define the image reference for the VM's OS.
  storage_image_reference {
    publisher = "OpenLogic" # Publisher of the OS image.
    offer     = "CentOS"    # Offer of the OS image.
    sku       = "7_8"       # SKU of the OS image.
    version   = "latest"    # Version of the OS image.
  }

  # Define the OS profile configuration.
  os_profile {
    computer_name  = "helloworld-vm" # Computer name of the VM.
    admin_username = "adminuser"     # Admin username for the VM.
    admin_password = "Password1234!" # Admin password for the VM (please consider using secrets for production).

    # Specify the OS profile details for Windows VM.
    # For Linux VM, you can use "os_profile_linux_config" instead.
  }

  # Define the Linux OS profile configuration.
  os_profile_linux_config {
    disable_password_authentication = false # Enable password authentication for SSH.
  }

  # Configure the user-assigned managed identity for the VM.
  identity {
    type         = "UserAssigned"                                  # Type of identity (UserAssigned).
    identity_ids = [azurerm_user_assigned_identity.vm_identity.id] # ID of the user-assigned identity.
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
      host     = azurerm_public_ip.public_ip.ip_address # Access public IP via NIC
      type     = "ssh"
      user     = "adminuser"
      password = "Password1234!"
      agent    = false
      timeout  = "5m"
    }
  }
}
