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

resource "azurerm_resource_group" "recursos_eventhub_alf" {

  name = "recursos-eventhub-alf"
  location = "westeurope"
  
}

resource "azurerm_eventhub_namespace" "pedidos_eh_namespace" {
  name                = "pedidos_eh_namespace"
  location            = azurerm_resource_group.recursos_eventhub_alf.location
  resource_group_name = azurerm_resource_group.recursos_eventhub_alf.name
  sku                 = "Standard"
  capacity            = 1
}

# data "azurerm_eventhub_namespace" "namespace_existente" {
#   name = "namespace_existente"
#   resource_group_name = "nombre_grupo"
# }

resource "azurerm_eventhub" "pedidos_eh" {
  name                = "pedidos_eh"
  namespace_name      = azurerm_eventhub_namespace.pedidos_eh_namespace.name
  resource_group_name = azurerm_resource_group.recursos_eventhub_alf.name
  partition_count     = 2
  message_retention   = 1 # Días
}

resource "azurerm_eventhub_consumer_group" "pedidos_grupo_altas" {
  name                = "pedidosGrupoAltas"
  namespace_name      = azurerm_eventhub_namespace.pedidos_eh_namespace.name
  eventhub_name       = azurerm_eventhub.pedidos_eh.name
  resource_group_name = azurerm_resource_group.recursos_eventhub_alf.name
  user_metadata       = "metadatosADefinir"
}

resource "azurerm_eventhub_authorization_rule" "pedidos_regla_1" {
  name                = "pedidosRegla1"
  namespace_name      = azurerm_eventhub_namespace.pedidos_eh_namespace.name
  eventhub_name       = azurerm_eventhub.pedidos_eh.name
  resource_group_name = azurerm_resource_group.recursos_eventhub_alf.name
  listen              = true
  send                = false
  manage              = false
}
