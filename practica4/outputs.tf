output "id_grupo_recursos" {

  value = azurerm_resource_group.cursotf_alfredo_rg.id
  description = "id asignada al grupo de recursos"
  
}

output "cadena_grupo_recursos" {
  
  value = "ID asignado ${azurerm_resource_group.cursotf_alfredo_rg.id} al grupo ${azurerm_resource_group.cursotf_alfredo_rg.name}"

}


output "datos_de_red" {

    value = values(module.redes)[*].objeto_red
  
}


output "datos_de_subredes" {

    value = values(module.redes)[*].subredes_de_la_red
  
}
