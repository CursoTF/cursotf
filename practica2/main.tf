# Comentario línea (recomendado)
// Comentario línea
/*
    Comentario de bloque
*/

terraform {

  required_providers {

    azurerm = {

      source  = "hashicorp/azurerm"
      version = "~>3.103.0"
    }

  }

  # Versión mínima de Terraform
  required_version = ">=1.5.0"

}


provider "azurerm" {

  features {

     
  }

  client_id = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
  client_secret = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
  tenant_id = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
  subscription_id = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"

  
  
}

resource "azurerm_resource_group" "cursotf_alfredo_rg" {

  name = "CURSOTF_ALFREDO_RG"
  location = "westeurope"
  
}

resource "azurerm_virtual_network" "cursotf_alfredo_vn" {

  name = "CURSOTF_ALFREDO_VN"
  location = "westeurope"
  address_space = ["10.0.0.0/16"]
  resource_group_name = azurerm_resource_group.cursotf_alfredo_rg.name
  
}

resource "azurerm_subnet" "cursotf_alfredo_subnet_1" {

  name = "CURSOTF_ALFREDO_SN_1"
  resource_group_name = azurerm_resource_group.cursotf_alfredo_rg.name
  virtual_network_name = azurerm_virtual_network.cursotf_alfredo_vn.name
  address_prefixes = [ "10.0.1.0/24" ]
  
}

resource "azurerm_public_ip" "cursotf_alfredo_ip_1" {

  name = "public_ip_1"
  location = azurerm_resource_group.cursotf_alfredo_rg.location
  resource_group_name = azurerm_resource_group.cursotf_alfredo_rg.name
  allocation_method = "Dynamic"
  sku = "Basic"
  
}

resource "azurerm_network_interface" "cursotf_alfredo_nic_1" {

  name = "nic_1"
  location = azurerm_resource_group.cursotf_alfredo_rg.location
  resource_group_name = azurerm_resource_group.cursotf_alfredo_rg.name

  ip_configuration {
    name = "nic_1_ip_config"
    subnet_id = azurerm_subnet.cursotf_alfredo_subnet_1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.cursotf_alfredo_ip_1.id
  }
  
}

resource "azurerm_network_security_group" "cursotf_alfredo_servidorweb" {

  name = "CURSOTF_ALFREDO_SERVIDORWEB"
  location = azurerm_resource_group.cursotf_alfredo_rg.location
  resource_group_name = azurerm_resource_group.cursotf_alfredo_rg.name

  
}

resource "azurerm_network_security_rule" "cursotf_alfredo_httprule" {

  name = "CURSOTF_ALFREDO_HTTP"
  resource_group_name = azurerm_resource_group.cursotf_alfredo_rg.name
  network_security_group_name = azurerm_network_security_group.cursotf_alfredo_servidorweb.name
  priority = 100
  direction = "Inbound"
  access = "Allow"
  protocol = "Tcp"
  source_port_range = "*"
  destination_port_range = "80"
  source_address_prefix = "*"
  destination_address_prefix = azurerm_subnet.cursotf_alfredo_subnet_1.address_prefixes[0]

  
}

resource "azurerm_network_security_rule" "cursotf_alfredo_sshrule" {

  name = "CURSOTF_ALFREDO_SSH"
  resource_group_name = azurerm_resource_group.cursotf_alfredo_rg.name
  network_security_group_name = azurerm_network_security_group.cursotf_alfredo_servidorweb.name
  priority = 101
  direction = "Inbound"
  access = "Allow"
  protocol = "Tcp"
  source_port_range = "*"
  destination_port_range = "22"
  source_address_prefix = "*"
  destination_address_prefix = azurerm_subnet.cursotf_alfredo_subnet_1.address_prefixes[0]

  
}

resource "azurerm_subnet_network_security_group_association" "subnet_1_sg" {
  subnet_id = azurerm_subnet.cursotf_alfredo_subnet_1.id
  network_security_group_id = azurerm_network_security_group.cursotf_alfredo_servidorweb.id  
}

resource "azurerm_virtual_machine" "cursotf_alfredo_vm1" {

  name = "CURSOTF_ALFREDO_VM1"
  location = azurerm_resource_group.cursotf_alfredo_rg.location
  resource_group_name = azurerm_resource_group.cursotf_alfredo_rg.name
  network_interface_ids = [ azurerm_network_interface.cursotf_alfredo_nic_1.id ]
  vm_size = "Standard_B1ls"
  storage_os_disk {
    name = "cursotf_alfredo_disco_vm1"
    caching = "ReadWrite"
    create_option = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  storage_image_reference {
    publisher = "Canonical"
    offer = "UbuntuServer"
    sku = "16.04-LTS"
    version = "latest"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  os_profile {
    computer_name = "cursotf"
    admin_username = "cursotf_alfredo"
    admin_password = "Cursotf_2024!"
  }


  
}

