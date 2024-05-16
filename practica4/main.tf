
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
  location = "westeurope"  
}

locals {
  
  mapa_configuracion_redes = {
    "red_1" = {
      name = "red_1",
      direcciones = ["10.0.0.0/16"]    
    },
    "red_2" = {
      name = "red_2",
      direcciones = ["20.0.0.0/16"]    
    }
  }

  mapa_de_subredes = {
    "subnet_1" = {
      name = "subnet_1",
      direcciones = ["10.1.0.0/8"]    
    },
    "subnet_2" = {
      name = "subnet_2",
      direcciones = ["10.1.0.0/8"]    
    }
  }  

}

module "redes" {

  source = "./modules/redes"

  for_each = local.mapa_configuracion_redes

  # Propiedades en entrada
  nombre_grupo_recursos = azurerm_resource_group.cursotf_alfredo_rg.name
  nombre_region = azurerm_resource_group.cursotf_alfredo_rg.location
  mapa_de_subredes = local.mapa_de_subredes

  nombre_red = each.key
  direcciones_red = each.value.direcciones
 
}
