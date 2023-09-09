#create resource for the resource group using variable
resource "azurerm_resource_group" "az_rg" {
    name = var.rg_tr_final
    location = "westus"
}

#create resource for the webapp network security group 
resource "azurerm_network_security_group" "az_nsg_webapp" {
  name                = "nsg-webapp-tr-final"
  location            = "westus"
  resource_group_name = var.rg_tr_final
  
  security_rule {
    name                       = "nsgsr_80"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "nsgsr_8080"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "nsgsr_5000"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "5000"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
    security_rule {
    name                       = "nsgsr_22"
    priority                   = 130
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "147.235.195.25"
    destination_address_prefix = "*"
}
}

#create resource for the db network security group 
resource "azurerm_network_security_group" "az_nsg_db" {
  name                = "nsg-db-tr-final"
  location            = "westus"
  resource_group_name = var.rg_tr_final

    security_rule {
    name                       = "nsgsr_5432"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "5432"
    source_address_prefix      = "10.0.1.0/24"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "nsgsr_22"
    priority                   = 105
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "10.0.1.0/24"
    destination_address_prefix = "*"


  }
  security_rule {
    name                       = "nsgsr_deny"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

#create resource for the virtual network using variable
resource "azurerm_virtual_network" "az_vnet" {
  name                = var.vnet_tr_final
  location            = "westus"
  resource_group_name = "rg-tr-final"
  address_space       = ["10.0.0.0/16"]
}

#create resource for the db subnet 
resource "azurerm_subnet" "az_snet_db_tr_final" {
  name                 = "snet-db-tr-final"
  resource_group_name  = var.rg_tr_final
  virtual_network_name = azurerm_virtual_network.az_vnet.name
  address_prefixes       = ["10.0.0.0/24"] 
}

#create resource for the webapp subnet 
resource "azurerm_subnet" "az_snet_webapp_tr_final" {
  name                 = "snet-webapp-tr-final"
  resource_group_name  = var.rg_tr_final
  virtual_network_name = azurerm_virtual_network.az_vnet.name
  address_prefixes       = ["10.0.1.0/24"] 
}

#create resource for the dv subnet network security group association
resource "azurerm_subnet_network_security_group_association" "az_snetsgas_db" {
  subnet_id                 = azurerm_subnet.az_snet_db_tr_final.id
  network_security_group_id = azurerm_network_security_group.az_nsg_db.id
}

#create resource for the webapp subnet network security group association
resource "azurerm_subnet_network_security_group_association" "az_snetsgas_webapp" {
  subnet_id                 = azurerm_subnet.az_snet_webapp_tr_final.id
  network_security_group_id = azurerm_network_security_group.az_nsg_webapp.id
}

# Create public IPs
resource "azurerm_public_ip" "az_pip_db" {
  name                = "pip-te-db-final"
  location            = "westus"
  resource_group_name = var.rg_tr_final
  allocation_method   = "Static"
}

# Create public IPs
resource "azurerm_public_ip" "az_pip_webapp" {
  name                = "pip-te-webapp-final"
  location            = "westus"
  resource_group_name = var.rg_tr_final
  allocation_method   = "Dynamic"
}

# Create network interface
resource "azurerm_network_interface" "az_nic_db" {
  name                = "nic-tr-db-final"
  location            = "westus"
  resource_group_name = var.rg_tr_final

  ip_configuration {
    name                          = "nic-ip-config-tr-db-final"
    subnet_id                     = azurerm_subnet.az_snet_db_tr_final.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.0.10"
    primary                       = true

  }
}

# Create network interface
resource "azurerm_network_interface" "az_nic_webapp" {
  name                = "nic-tr-webapp-final"
  location            = "westus"
  resource_group_name = var.rg_tr_final

  ip_configuration {
    name                          = "nic-ip-config-tr-webapp-final"
    subnet_id                     = azurerm_subnet.az_snet_webapp_tr_final.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.az_pip_webapp.id
  }
}

# Create db
resource "azurerm_linux_virtual_machine" "az_vm_db" {
  name                  = "vm_db_tr_final"
  location              = "westus"
  resource_group_name   = var.rg_tr_final
  network_interface_ids = [azurerm_network_interface.az_nic_db.id]
  size                  = "Standard_DS1_v2"
  admin_password = var.admin_password
  admin_username = var.admin_username
  disable_password_authentication = false

  os_disk {
    name                 = "os-disk-tr-db-final"
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  computer_name  = "vm-db"
}

# Create web
resource "azurerm_linux_virtual_machine" "az_vm_webapp" {
  name                  = "vm_webapp_tr_final"
  location              = "westus"
  resource_group_name   = var.rg_tr_final
  network_interface_ids = [azurerm_network_interface.az_nic_webapp.id]
  size                  = "Standard_DS1_v2"
  admin_password = var.admin_password
  admin_username = var.admin_username
  disable_password_authentication = false


  os_disk {
    name                 = "os-disk-tr-webapp-final"
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  computer_name  = "vm-webapp"

}

resource "azurerm_virtual_machine_extension" "az_vm_ext_script_db" {
  name                 = "vm-extension-db"
  virtual_machine_id   = azurerm_linux_virtual_machine.az_vm_db.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.1"

  settings = <<SETTINGS
 {
   "script": "${base64encode(file("${path.module}//dbscript.sh"))}"

 }
SETTINGS


   depends_on = [
    azurerm_linux_virtual_machine.az_vm_db
  ]

}

data "template_file" "base64_encoded_script" {
  template = file("${path.module}/vm-webapp-flask-script.sh")
}

# Create an extension virtual machine for webapp
resource "azurerm_virtual_machine_extension" "az_vm_ext_script_webapp" {
  name                 = "vm-extension-webapp"
  virtual_machine_id   = azurerm_linux_virtual_machine.az_vm_webapp.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.1"

  settings = <<SETTINGS
 {
  "script": "${base64encode(file("${path.module}//vm-webapp-flask-script.sh"))}"
 }

SETTINGS

  depends_on = [
    azurerm_linux_virtual_machine.az_vm_webapp,
    azurerm_virtual_machine_extension.az_vm_ext_script_db,
    azurerm_linux_virtual_machine.az_vm_db
]
}