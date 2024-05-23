# __generated__ by Terraform
# Please review these resources and move them into your main configuration files.

# __generated__ by Terraform from "/subscriptions/eee932a1-4207-417c-91b8-da540623dfed/resourceGroups/CURSOTF_ALFREDO_RG"
resource "azurerm_resource_group" "grupo_importado" {
  location   = "westeurope"
  name       = "CURSOTF_ALFREDO_RG"
}

# __generated__ by Terraform
resource "azurerm_virtual_network" "red_importada" {
  address_space           = ["10.0.0.0/16"]
  location                = "westeurope"
  name                    = "CURSOTF_ALFREDO_VN"
  resource_group_name     = "CURSOTF_ALFREDO_RG"
}

# __generated__ by Terraform from "/subscriptions/eee932a1-4207-417c-91b8-da540623dfed/resourceGroups/CURSOTF_ALFREDO_RG/providers/Microsoft.Network/virtualNetworks/CURSOTF_ALFREDO_VN/subnets/CURSOTF_ALFREDO_SN_1"
resource "azurerm_subnet" "subred_importada" {
  address_prefixes                              = ["10.0.2.0/24"]
  name                                          = "CURSOTF_ALFREDO_SN_1"
  resource_group_name                           = "CURSOTF_ALFREDO_RG"
  virtual_network_name                          = "CURSOTF_ALFREDO_VN"

  lifecycle {
    
    prevent_destroy = true

    create_before_destroy = true

    ignore_changes = [ 
      address_prefixes
     ]

    replace_triggered_by = [ azurerm_virtual_network.red_importada.address_space ]

    precondition {
      condition = startswith(azurerm_subnet.name, "CURSOTF")
      error_message = "Nombre de subred no cumple normativa"
    }

    postcondition {
      condition = true
      error_message = "No ha bloqueado creación de recurso"
    }

  }

  provisioner "local-exec" {
    command = "./notificar_creacion_correcta.cmd"
    on_failure = continue
    environment = {
      AZURE_USER = "algo"
    }
    # when = destroy
  }

  connection {
    type = "ssh"
    user = ""
    password = ""
    host = "asdfafads"
  }

  provisioner "file" {

    # content = "el contenido del fichero"
    source = "path del fichero"
    destination = "~azuser/certificado.pem"
    
  }
  
  provisioner "remote-exec" {

    # connection {
    #   type = "ssh"
    #   user = ""
    #   password = ""
    #   host = "asdfafads"
    # }

    # script = "/tmp/algo.sh"
    # scripts = [ "/temp/algo.sh", "/temp/algomas.sh" ]
    inline = [ 
      "apt update -y",
      "apt get httpd -y"
    ]

    on_failure = fail
    
  }


}
