
output "objeto_red" {
    value = azurerm_virtual_network.cursotf_vn  
}

output "subredes_de_la_red" {
    value = azurerm_virtual_network.cursotf_vn.subnet  
}
