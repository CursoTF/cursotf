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

resource "azurerm_resource_group" "recursos_redis_alf" {

  name = "recursos-redis-alf"
  location = "westeurope"
  
}

resource "azurerm_redis_cache" "redis_cache_1" {

  name = "redis-cache-1"
  location = azurerm_resource_group.recursos_redis_alf.location
  resource_group_name = azurerm_resource_group.recursos_redis_alf.name
  capacity = 2
  family = "C"
  sku_name = "Standard"
  enable_non_ssl_port = true

  # Cuidado sólo para probar
  public_network_access_enabled = true

  # minimum_tls_version = "1.2"

  redis_configuration {

    
  }
  
}

resource "azurerm_redis_firewall_rule" "regla_firewall_redis_1" {
  name                = "regla_firewall_redis_1"
  redis_cache_name    = azurerm_redis_cache.redis_cache_1.name
  resource_group_name = azurerm_resource_group.recursos_redis_alf.name
  start_ip            = "1.2.3.4"
  end_ip              = "2.3.4.5"
}

resource "azurerm_redis_cache_access_policy" "politica_acceso_1" {
  name           = "politica-acceso-1"
  redis_cache_id = azurerm_redis_cache.redis_cache_1.id
  permissions    = "+@read +@connection +cluster|info"
}

data "azurerm_client_config" "current" {
}

# resource "azurerm_redis_cache_access_policy_assignment" "asignacion_acceso_1" {
#   name               = "asignacion_acceso_1"
#   redis_cache_id     = azurerm_redis_cache.redis_cache_1.id
#   access_policy_name = "PoliticaConsultas"
#   object_id          = data.azurerm_client_config.current.object_id
#   object_id_alias    = "ServicePrincipal"
# }
