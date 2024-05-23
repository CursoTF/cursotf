resource "azurerm_resource_group" "res-0" {
  location = "westeurope"
  name     = "CURSOTF_ALFREDO_RG"
}
resource "azurerm_virtual_network" "res-1" {
  address_space       = ["10.0.0.0/16"]
  location            = "westeurope"
  name                = "CURSOTF_ALFREDO_VN"
  resource_group_name = "CURSOTF_ALFREDO_RG"
  depends_on = [
    azurerm_resource_group.res-0,
  ]
}
resource "azurerm_subnet" "res-2" {
  address_prefixes     = ["10.0.1.0/24"]
  name                 = "CURSOTF_ALFREDO_SN_1"
  resource_group_name  = "CURSOTF_ALFREDO_RG"
  virtual_network_name = "CURSOTF_ALFREDO_VN"
  depends_on = [
    azurerm_virtual_network.res-1,
  ]
}
