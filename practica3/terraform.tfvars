

region_azure = "westeurope"

etiquetas_comunes = {
    Entorno = "Formación"
    Proyecto = "N/A"    
}

prefijo_reglas = "RULE-"

reglas_servidores_linux_web = {

  "HTTP" : {
      priority = 100,
      destination_port_range = "80"
      name = "HTTP"
    },
  "SSH" :  {
      priority = 101,
      destination_port_range = "22"
      name = "SSH"
    }    
}

nombres_direcciones_ip_publicas = [ "public_ip_1", "public_ip_2", "public_ip_3" ]

configuracion_redes = [
  {
      nombre = "red_1", direccion = ["10.0.0.0/16"]
  },
  {
      nombre = "red_2", direccion = ["20.0.0.0/16"]
  }   
]

#############################################################

mapa_configuracion_redes = {
  "red_1" = {
    name = "red_1",
    direcciones = ["10.0.0.0/16"]    
  },
  "red_2" = {
    name = "red_2",
    direcciones = ["20.0.0.0/16"]    
  }
}
