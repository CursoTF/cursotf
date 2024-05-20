
variable "nombre_red" {
#    type = string
    default = "Red_creada_desde_modulo"  
}

variable "nombre_region" {
    default = "westeurope"  
}

variable "direcciones_red" {
    default = ["10.0.0.0/16"]  
}

variable "nombre_grupo_recursos" {
    default = "cursotf_grupo_pruebas"
}

# variable "mapa_de_subredes" {
#     type=map(object({
#       name = string,
#       direcciones = list(string)
#     }))
  
# }
