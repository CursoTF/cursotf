
resource "azurerm_virtual_network" "cursotf_vn" {

  name = var.nombre_red
  location = var.nombre_region
  address_space = var.direcciones_red
  resource_group_name = var.nombre_grupo_recursos
 
}

resource "azurerm_subnet" "cursotf_sn" {

  for_each = var.mapa_de_subredes

  name = "Subnet-${each.key}"
  resource_group_name = var.nombre_grupo_recursos
  virtual_network_name = var.nombre_red
  address_prefixes = cidrsubnets(var.direcciones_red[0], 4 , 4)
  
}

