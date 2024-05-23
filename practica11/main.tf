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

resource "azurerm_resource_group" "recursos_appinsight_alf" {

  name = "recursos_appinsight_alf"
  location = "westeurope"
  
}

resource "azurerm_application_insights" "pedidos_appinsight" {
  name                = "pedidos-appinsight"
  location            = azurerm_resource_group.recursos_appinsight_alf.location
  resource_group_name = azurerm_resource_group.recursos_appinsight_alf.name
  # web, java, ios, Node.JS, MobileCenter, other
  application_type    = "web"
  # retention_in_days = 90
}

output "instrumentation_key" {
  value = azurerm_application_insights.pedidos_appinsight.instrumentation_key
}

output "app_id" {
  value = azurerm_application_insights.pedidos_appinsight.app_id
}


# resource "azurerm_application_insights_analytics_item" "pedidos_appinsight_peticiones" {
#   name                    = "pedidos-appinsight-peticiones"
#   application_insights_id = azurerm_application_insights.pedidos_appinsight.id
#   content                 = "requests //simple example query"
#   scope                   = "shared"
#   type                    = "query"
# }

# resource "azurerm_application_insights_smart_detection_rule" "pedidos_appinsight_bajo_rendimiento" {
#   # Slow page load time, Slow server response time, Long dependency duration, Degradation in server response time, Degradation in dependency duration, Degradation in trace severity ratio, Abnormal rise in exception volume, Potential memory leak detected, Potential security issue detected and Abnormal rise in daily data volume, Long dependency duration, Degradation in server response time, Degradation in dependency duration, Degradation in trace severity ratio, Abnormal rise in exception volume, Potential memory leak detected, Potential security issue detected, Abnormal rise in daily data volume
#   name                    = "Slow server response time"
#   application_insights_id = azurerm_application_insights.pedidos_appinsight.id
#   enabled                 = false
# }
