# Configure the Azure provider
provider "azurerm" {
  features {}
}

# Create a resource group
resource "azurerm_resource_group" "from-terraform-ioannis" {
  name     = "from-terraform-ioannis-resources"
  location = "East US"
}

# Create a virtual network
resource "azurerm_virtual_network" "from-terraform-ioannis" {
  name                = "from-terraform-ioannis-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.from-terraform-ioannis.location
  resource_group_name = azurerm_resource_group.from-terraform-ioannis.name
}

# Create a subnet
resource "azurerm_subnet" "from-terraform-ioannis" {
  name                 = "from-terraform-ioannis-subnet"
  resource_group_name  = azurerm_resource_group.from-terraform-ioannis.name
  virtual_network_name = azurerm_virtual_network.from-terraform-ioannis.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create a public IP address
resource "azurerm_public_ip" "from-terraform-ioannis" {
  name                = "from-terraform-ioannis-pip"
  location            = azurerm_resource_group.from-terraform-ioannis.location
  resource_group_name = azurerm_resource_group.from-terraform-ioannis.name
  allocation_method   = "Dynamic"
}

# Create a network interface
resource "azurerm_network_interface" "from-terraform-ioannis" {
  name                = "from-terraform-ioannis-nic"
  location            = azurerm_resource_group.from-terraform-ioannis.location
  resource_group_name = azurerm_resource_group.from-terraform-ioannis.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.from-terraform-ioannis.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.from-terraform-ioannis.id
  }
}

# Create a virtual machine
resource "azurerm_linux_virtual_machine" "from-terraform-ioannis" {
  name                = "from-terraform-ioannis-vm"
  location            = azurerm_resource_group.from-terraform-ioannis.location
  resource_group_name = azurerm_resource_group.from-terraform-ioannis.name
  network_interface_ids = [azurerm_network_interface.from-terraform-ioannis.id]
  size                = "Standard_DS2_v2"

  admin_username      = "adminuser"
  admin_password      = "Password1234!"

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  computer_name  = "hostname"
  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  lifecycle {
    ignore_changes = [
      size
    ]
  }
}
