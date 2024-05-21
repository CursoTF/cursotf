terraform {

  required_providers {

    azurerm = {

      source  = "hashicorp/azurerm"
      version = "~>3.103.0"
    }

    local = {
      source = "hashicorp/local"
      version = "2.5.1"
    }

    random = {
      source = "hashicorp/random"
      version = "3.6.1"
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

    "Get", "Delete", "Set", "List", "Recover", "Purge", "Restore", "Backup"

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

resource "azurerm_key_vault_key" "clave_rsa" {

  name = "clave-rsa"

  key_vault_id = azurerm_key_vault.cursotf_alfredo_kv_1.id

  # RSA ó EC
  key_type = "RSA"
  key_size = 2048

  key_opts = [ "decrypt", "encrypt", "sign", "verify", "wrapKey", "unwrapKey" ]
  
}

resource "azurerm_key_vault_certificate" "certificado_1" {

  name = "certificado-1"
  key_vault_id = azurerm_key_vault.cursotf_alfredo_kv_1.id

  # certificate {
  #   contents = filebase64("cert.p12")
  #   password = "adfasdfass"
  # }

  certificate_policy {
    
    issuer_parameters {
      name = "Self"
    }

    key_properties {
      
      key_type = "RSA"
      key_size = 2048
      reuse_key = true
      exportable = true
    }

    secret_properties {
      content_type = "application/x-pkcs12"
    }

    x509_certificate_properties {
      
      subject = "cn=Prueba, ou=Formación, o=Acme"
      key_usage = [ "keyCertSign", "dataEncipherment", "digitalSignature" ]
      validity_in_months = 12

      subject_alternative_names {
        dns_names = [ "*.acme.com" ]
      }

    }

    lifetime_action {
      
      action {        
        action_type = "AutoRenew"
      }

      trigger {
        lifetime_percentage = 25
      }
    }

  }
  
}

# data "azurerm_key_vault_certificate" "datos_certificado" {
  
#   name = "certificado-1"
#   key_vault_id = azurerm_key_vault.cursotf_alfredo_kv_1.id
# }

# output "datos_certificado" {

#   value = data.azurerm_key_vault_certificate.datos_certificado

#   sensitive = true
  
# }

# resource "local_file" "fichero_con_el_certificado" {

#   content_base64 = data.azurerm_key_vault_certificate.datos_certificado.certificate_data_base64
#   filename = "certificado.pem"

#   depends_on = [ data.azurerm_key_vault_certificate.datos_certificado ]
  
# }

resource "random_integer" "generar_entero" {
  min = 1
  max = 1000
}

resource "random_password" "generar_clave" {
  min_lower = 3
  min_upper = 3
  min_special = 3
  length = 20  
}

output "probar_proveedor_random" {

  value = {
    entero = random_integer.generar_entero.result
    clave = random_password.generar_clave.result    
  }
  
  sensitive = true
}

# data "azurerm_key_vault_key" "leer_clave_rsa" {
#   key_vault_id = azurerm_key_vault.cursotf_alfredo_kv_1.id
#   name = "clave-rsa"  
# }

# output "datos_clave_rsa" {
#   value = data.azurerm_key_vault_key.leer_clave_rsa
# }

# data "azurerm_key_vault_secret" "nombre_usuario" {
  
#   key_vault_id = azurerm_key_vault.cursotf_alfredo_kv_1.id
#   name = "nombre-usuario"
# }

# data "azurerm_key_vault_secret" "clave_usuario" {
  
#   key_vault_id = azurerm_key_vault.cursotf_alfredo_kv_1.id
#   name = "clave-usuario"
# }


# output "valores_guardados" {

#   value = "Usuario ${data.azurerm_key_vault_secret.nombre_usuario.value} - Clave ${data.azurerm_key_vault_secret.clave_usuario.value}"

#   sensitive = true
  
# }

############################################
# Para leer todos los secretos

# data "azurerm_key_vault_secrets" "secretos" {
#   key_vault_id = azurerm_key_vault.cursotf_alfredo_kv_1.id  
# }

# data "azurerm_key_vault_secret" "secreto" {

#   key_vault_id = azurerm_key_vault.cursotf_alfredo_kv_1.id
#   for_each = toset(data.azurerm_key_vault_secrets.secretos.names)
#   name = each.key  
# }

# output "todos_los_secretos" {

#   value = data.azurerm_key_vault_secret.secreto[*]

#   sensitive = true
  
# }

# output "valores_guardados_2" {

#   value = "Usuario ${data.azurerm_key_vault_secret.secreto["nombre-usuario"].value} - Clave ${data.azurerm_key_vault_secret.secreto["clave-usuario"].value}"

#   sensitive = true
  
# }


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
