

region_azure = "westeurope"

etiquetas_comunes = {
    Entorno = "Formación"
    Proyecto = "N/A"    
}

reglas_servidores_linux_web = [
    {
      priority = 100,
      destination_port_range = "80"
      name = "HTTP"
    },
    {
      priority = 101,
      destination_port_range = "22"
      name = "SSH"
    }    
]
