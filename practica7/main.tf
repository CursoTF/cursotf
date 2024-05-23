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

    virtual_machine {
      delete_os_disk_on_deletion = true
    }
  }

  client_id = var.credenciales_azure.client_id
  client_secret = var.credenciales_azure.client_secret
  tenant_id = var.credenciales_azure.tenant_id
  subscription_id = var.credenciales_azure.subscription_id
  
}

resource "azurerm_resource_group" "recursos_bbdd_alf" {

  name = "recursos_bbdd_alf"
  location = "westeurope"
  
}


resource "azurerm_mssql_server" "servidor_mssql_alf" {

  name = "servidor-mssql-alf"
  resource_group_name = azurerm_resource_group.recursos_bbdd_alf.name
  location = azurerm_resource_group.recursos_bbdd_alf.location
  version = "12.0"
  administrator_login = "admin2024"
  administrator_login_password = "!!A$[-2024$$$$"

  # Para acceder desde fuera de Azure por IP pública
  # connection_policy = "Proxy"

}

# Para acceder desde fuera de Azure por IP pública
# resource "azurerm_mssql_firewall_rule" "permitir_acceso" {

#   name = "Acceso-Publico"
#   server_id = azurerm_mssql_server.servidor_mssql_alf.id
#   start_ip_address = ""
#   end_ip_address = ""
  
# }

resource "azurerm_mssql_database" "mssql_servidor_1" {

  name = "mssql-servidor-1"
  server_id = azurerm_mssql_server.servidor_mssql_alf.id

  collation = "SQL_Latin1_General_CP1_CI_AS"
  license_type = "LicenseIncluded"
  max_size_gb = 1

  # sku_name = "GP_5_Gen5_2"
  sku_name = "Basic"

  lifecycle {
    
    prevent_destroy = false

  }

  
}


# output "configuracion_db" {

#   value = azurerm_mssql_server.servidor_mssql_alf

#   sensitive = true
  
# }

# output "servidor_db" {

#   value = azurerm_mssql_database.mssql_servidor_1

#   sensitive = true
  
# }


output "ConnectionString" {
  value = "Server=tcp:${azurerm_mssql_server.servidor_mssql_alf.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_mssql_database.mssql_servidor_1.name};Persist Security Info=False;User ID=${azurerm_mssql_server.servidor_mssql_alf.administrator_login};Password=${azurerm_mssql_server.servidor_mssql_alf.administrator_login_password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30"

  sensitive = true

}

# az account get-access-token
# https://management.azure.com/subscriptions/{subscriptionId}/providers/Microsoft.Sql/locations/{locationName}/capabilities?api-version=2021-11-01
