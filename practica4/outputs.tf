output "id_grupo_recursos" {

  value = azurerm_resource_group.cursotf_alfredo_rg.id
  description = "id asignada al grupo de recursos"
  
}

output "cadena_grupo_recursos" {
  
  value = "ID asignado ${azurerm_resource_group.cursotf_alfredo_rg.id} al grupo ${azurerm_resource_group.cursotf_alfredo_rg.name}"

}


# output "datos_de_red" {

#     value = module.redes[].objeto_red
  
# }
