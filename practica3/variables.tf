##############################################################################
# Catálogo de tipos de variable en Terraform

variable "variable_bool" {
  type = bool
  default = true
  description = "Expresión true o false"  
}

variable "variable_cadena" {
  type = string
  default = "Valor de la cadena algo más"
  sensitive = true
  nullable = false
}

variable "variable_numerico" {
  type = number
  default = 1000  
  validation {
    condition = var.variable_numerico >= 0 && var.variable_numerico <= 2000
    error_message = "Debe estar entre 0 y 2000"
  }
}

variable "variable_objeto" {
  type = object({
    client_id = string
    tenant_id = string
    lista_roles = list(object({
      id = number
      name = string
    }))
  })
  default = {
    client_id = "1000"
    tenant_id = "2000"
    lista_roles = [
      {
        id = 10, name = "admin"     
      },
      {
        id = 20, name = "monitor"     
      } 
    ]
  }  
}

variable "variable_lista" {
  type = list(string)
  default = [ "valor1", "valor2" ]
}

# Igual que una lista pero con valores únicos y ordenados (lo ordena Terraform)
variable "variable_conjunto" {
  type = set(number)
  default = [ 10, 30, 20, 10 ]  
}

variable "variable_mapa" {

  type = map(string)
  default = {
    "net1" = "10.0.0.0/16"
    "net2" = "20.0.0.0/16"
  }  
}

variable "variable_tupla" {
  type = tuple([ bool, string, list(number) ])
  default = [ true, "la cadena", [ 1, 2, 3 ] ]  
}


###########################################################################
# Variables que usamos

variable "credenciales_azure" {
    type = object({
        client_id = string
        client_secret = string
        tenant_id = string
        subscription_id = string
    })
    sensitive = true
}

variable "region_azure" {
  type = string
}

variable "etiquetas_comunes" {
  type = object({
    Entorno =  string
    Proyecto = string
  })
}

variable "prefijo_reglas" {
  type = string  
}

variable "reglas_servidores_linux_web" {

  # type = list(object({
  #   priority = number
  #   destination_port_range = string
  #   name = string
  # }))  
  type = map(
    object({
      priority = number
      destination_port_range = string
      name = string
    })
  )  

}

variable "nombres_direcciones_ip_publicas" {
  type = set(string)
}


variable "configuracion_redes" {
  type = list(object({
    nombre = string
    direccion = list(string)
  }))
}

variable "mapa_configuracion_redes" {
  type = map(object({
    name = string,
    direcciones = list(string)
  }))
  
}

