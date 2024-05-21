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

resource "azurerm_resource_group" "recursos_keyvault" {

  name = "recursos_aks_alfredo"
  location = "westeurope"
  
}

resource "azurerm_key_vault" "cursotf_alfredo_kv_1" {

  name = "cursotf-alfredo-kv-1"

  location = azurerm_resource_group.recursos_keyvault.location
  resource_group_name = azurerm_resource_group.recursos_keyvault.name

  # tenant_id = var.credenciales_azure.tenant_id
  tenant_id = data.azurerm_client_config.current.tenant_id
  
  sku_name = "standard"

  enabled_for_disk_encryption = true

  soft_delete_retention_days = 7

  purge_protection_enabled = true
 
}

data "azurerm_client_config" "current" {
  
}

resource "azurerm_key_vault_access_policy" "cursotf_alfredo_politica_kv" {

  key_vault_id = azurerm_key_vault.cursotf_alfredo_kv_1.id
  # tenant_id = var.credenciales_azure.tenant_id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = data.azurerm_client_config.current.object_id

  secret_permissions = [ 

    "Get", "Delete", "Set", "List"

  ]

  key_permissions = [ 

      "Backup",
      "Create",
      "Decrypt",
      "Delete",
      "Encrypt",
      "Get",
      "Import",
      "List",
      "Purge",
      "Recover",
      "Restore",
      "Sign",
      "UnwrapKey",
      "Update",
      "Verify",
      "WrapKey",
      "GetRotationPolicy",
      "SetRotationPolicy"      

  ]

  certificate_permissions = [ 

      "Create",
      "Delete",
      "DeleteIssuers",
      "Get",
      "GetIssuers",
      "Import",
      "List",
      "ListIssuers",
      "ManageContacts",
      "ManageIssuers",
      "Purge",
      "SetIssuers",
      "Update",

  ]

  
}

resource "azurerm_key_vault_secret" "nombre_usuario" {

  key_vault_id = azurerm_key_vault.cursotf_alfredo_kv_1.id

  name = "nombre-usuario"
  value = "dbuser"

  depends_on = [ azurerm_key_vault_access_policy.cursotf_alfredo_politica_kv ]
  
}

resource "azurerm_key_vault_secret" "clave_usuario" {

  key_vault_id = azurerm_key_vault.cursotf_alfredo_kv_1.id

  name = "clave-usuario"
  value = "laclave"

  depends_on = [ azurerm_key_vault_access_policy.cursotf_alfredo_politica_kv ]
  
}

data "azurerm_key_vault_secret" "nombre_usuario" {
  
  key_vault_id = azurerm_key_vault.cursotf_alfredo_kv_1.id
  name = "nombre-usuario"
}

data "azurerm_key_vault_secret" "clave_usuario" {
  
  key_vault_id = azurerm_key_vault.cursotf_alfredo_kv_1.id
  name = "clave-usuario"
}


output "valores_guardados" {

  value = "Usuario ${data.azurerm_key_vault_secret.nombre_usuario.value} - Clave ${data.azurerm_key_vault_secret.clave_usuario.value}"

  sensitive = true
  
}

output "funciones_hash_crypto" {

  value = {

    md5 = md5("valor_no_seguro")
    md5 = filemd5("main.tf")

    # sha1 
    sha256 = sha256("valor más seguro")
    sha512 = sha512("valor todavía más seguro")

    fichero = filebase64sha256("main.tf")
  }
  
}
