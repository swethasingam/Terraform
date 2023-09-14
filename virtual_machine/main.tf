# Define an Azure Virtual Machine resource.
resource "azurerm_virtual_machine" "vm" {
  name                  = "helloworld-vm"  # Name of the Virtual Machine.
  location              = var.location  # Location where the VM will be created.
  resource_group_name   = var.resource_group_name  # Name of the Azure Resource Group.
  network_interface_ids = var.network_interface_ids  # IDs of attached network interfaces.
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
    identity_ids = [var.identity_ids]  # ID of the user-assigned identity.
  }

  # Provisioner block for executing remote commands on the VM.
  provisioner "remote-exec" {
    inline = [
      "sudo yum install -y epel-release",                        # Install EPEL repository.
      "sudo yum install -y tomcat tomcat-webapps tomcat-admin-webapps",  # Install Tomcat.
      "sudo systemctl start tomcat",                             # Start Tomcat service.
      "sudo systemctl enable tomcat",                            # Enable Tomcat to start on boot.
      "sudo sed -i 's/Connector port=\"8080\"/Connector port=\"8080\"/' /etc/tomcat/server.xml",  # Modify Tomcat configuration.
      "sudo systemctl restart tomcat"                            # Restart Tomcat service.
    ]

    # SSH connection details to the VM.
    connection {
      host     = var.host  # Public IP address of the VM.
      type     = "ssh"                                   # SSH connection type.
      user     = "adminuser"                             # SSH username.
      password = "Password1234!"                         # SSH password (please consider using SSH keys for production).
      agent    = false                                   # Disable SSH agent forwarding.
      timeout  = "5m"                                    # Connection timeout.
    }
  }
}
