
terraform {

  required_providers {

    local = {
      source  = "hashicorp/local"
      version = "2.5.1"
    }

  }

}

provider "local" {

}

resource "local_file" "fichero_prueba" {

  filename = "${path.module}/texto.txt"

  content = "Texto desde Terraform ${timestamp()}"
}

resource "local_file" "fichero_prueba2" {

  filename = "${path.module}/prueba2.txt"

  source = "${path.module}/main.tf"
}

