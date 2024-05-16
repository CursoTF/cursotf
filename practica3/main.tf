
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

  client_id = var.credenciales_azure.client_id
  client_secret = var.credenciales_azure.client_secret
  tenant_id = var.credenciales_azure.tenant_id
  subscription_id = var.credenciales_azure.subscription_id
  
}

resource "azurerm_resource_group" "cursotf_alfredo_rg" {

  name = "CURSOTF_ALFREDO_RG"
  location = var.region_azure

  tags = var.etiquetas_comunes

  ###############################################
  # Meta Arguments
  # depends_on = [  ]
  # count = 1
  # provider = azurerm
  # lifecycle {
    
  # }
  # for_each = 

  
}

# resource "azurerm_virtual_network" "cursotf_alfredo_vn" {

#   count = length(var.configuracion_redes)

#   name = var.configuracion_redes[count.index].nombre
#   location = var.region_azure
#   address_space = var.configuracion_redes[count.index].direccion
#   resource_group_name = azurerm_resource_group.cursotf_alfredo_rg.name
  
# }

# resource "azurerm_subnet" "cursotf_alfredo_subnet_1" {

#   name = "CURSOTF_ALFREDO_SN_1"
#   resource_group_name = azurerm_resource_group.cursotf_alfredo_rg.name
#   virtual_network_name = azurerm_virtual_network.cursotf_alfredo_vn[0].name
#   address_prefixes = [ "10.0.1.0/24" ]
  
# }

resource "azurerm_virtual_network" "cursotf_alfredo_vn" {

  for_each = var.mapa_configuracion_redes

  name = each.key
  location = var.region_azure
  address_space = each.value.direcciones
  resource_group_name = azurerm_resource_group.cursotf_alfredo_rg.name
  
}

resource "azurerm_subnet" "cursotf_alfredo_subnet_1" {

  for_each = azurerm_virtual_network.cursotf_alfredo_vn

  name = "Subnet-${each.key}"
  resource_group_name = azurerm_resource_group.cursotf_alfredo_rg.name
  virtual_network_name = each.value.name
  address_prefixes = cidrsubnets(each.value.address_space[0], 4)
  
}


# resource "azurerm_public_ip" "cursotf_alfredo_ip_1" {

#   name = "public_ip_1"
#   location = azurerm_resource_group.cursotf_alfredo_rg.location
#   resource_group_name = azurerm_resource_group.cursotf_alfredo_rg.name
#   allocation_method = "Dynamic"
#   sku = "Basic"
  
# }

# resource "azurerm_public_ip" "cursotf_alfredo_ip" {

#   for_each = var.nombres_direcciones_ip_publicas

#   name = each.key

#   location = azurerm_resource_group.cursotf_alfredo_rg.location
#   resource_group_name = azurerm_resource_group.cursotf_alfredo_rg.name
#   allocation_method = "Dynamic"
#   sku = "Basic"
  
# }


# resource "azurerm_network_interface" "cursotf_alfredo_nic_1" {

#   name = "nic_1"
#   location = azurerm_resource_group.cursotf_alfredo_rg.location
#   resource_group_name = azurerm_resource_group.cursotf_alfredo_rg.name

#   ip_configuration {
#     name = "nic_1_ip_config"
#     subnet_id = azurerm_subnet.cursotf_alfredo_subnet_1.id
#     private_ip_address_allocation = "Dynamic"
#     public_ip_address_id = azurerm_public_ip.cursotf_alfredo_ip["public_ip_1"].id
#   }
  
# }

resource "azurerm_network_security_group" "cursotf_alfredo_servidorweb" {

  name = "CURSOTF_ALFREDO_SERVIDORWEB"
  location = azurerm_resource_group.cursotf_alfredo_rg.location
  resource_group_name = azurerm_resource_group.cursotf_alfredo_rg.name

  
}

# resource "azurerm_network_security_rule" "cursotf_alfredo_rule" {

#   for_each = var.reglas_servidores_linux_web

#   # each.key
#   # each.value

#   name = "${var.prefijo_reglas}${each.key}"
#   priority = each.value.priority
#   destination_port_range = each.value.destination_port_range

#   resource_group_name = azurerm_resource_group.cursotf_alfredo_rg.name
#   network_security_group_name = azurerm_network_security_group.cursotf_alfredo_servidorweb.name
#   direction = "Inbound"
#   access = "Allow"
#   protocol = "Tcp"
#   source_port_range = "*"
#   source_address_prefix = "*"
#   destination_address_prefix = azurerm_subnet.cursotf_alfredo_subnet_1.address_prefixes[0]

  
# }

# resource "azurerm_subnet_network_security_group_association" "subnet_1_sg" {
#   subnet_id = azurerm_subnet.cursotf_alfredo_subnet_1.id
#   network_security_group_id = azurerm_network_security_group.cursotf_alfredo_servidorweb.id  
# }


