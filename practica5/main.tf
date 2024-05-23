terraform {

  required_providers {

    azurerm = {

      source  = "hashicorp/azurerm"
      version = "~>3.103.0"
    }

  }

  # Versión mínima de Terraform
  required_version = ">=1.5.0"

}

provider "azurerm" {

  features {     
  }

  client_id = var.credenciales_azure.client_id
  client_secret = var.credenciales_azure.client_secret
  tenant_id = var.credenciales_azure.tenant_id
  subscription_id = var.credenciales_azure.subscription_id
  
}

resource "azurerm_resource_group" "recursos_aks" {

  name = "recursos_aks_alfredo"
  location = "westeurope"
  
}

resource "azurerm_virtual_network" "red_aks" {

  name = "red_alfredo_aks"

  address_space = [ "10.1.0.0/16" ]

  location = azurerm_resource_group.recursos_aks.location
  resource_group_name = azurerm_resource_group.recursos_aks.name
  
}

resource "azurerm_subnet" "subred_aks" {
  
  name = "subred_alfredo_aks"
  # address_prefixes = [ cidrsubnet(azurerm_virtual_network.red_aks.address_space[0], 8, 1) ]
  address_prefixes = [ "10.1.0.0/24" ]

  virtual_network_name = azurerm_virtual_network.red_aks.name
  resource_group_name = azurerm_resource_group.recursos_aks.name

}

resource "azurerm_kubernetes_cluster" "cluster_aks" {
  
  name = "cluster_aks_alfredo"

  location = azurerm_resource_group.recursos_aks.location
  resource_group_name = azurerm_resource_group.recursos_aks.name

  dns_prefix = "internal"
  sku_tier = "Standard"


  default_node_pool {
    name = "gruponodos1"
    node_count = 1
    vnet_subnet_id = azurerm_subnet.subred_aks.id
    vm_size = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }
  
}

resource "azurerm_container_registry" "registro_aks" {
  
  name = "RegistroContenedoresCursoTF2024Alf"

  location = azurerm_resource_group.recursos_aks.location
  resource_group_name = azurerm_resource_group.recursos_aks.name

  sku = "Standard"

  admin_enabled = true
  


}

resource "azurerm_role_assignment" "registro_cluter_aks" {

  principal_id = azurerm_kubernetes_cluster.cluster_aks.kubelet_identity[0].object_id
  scope = azurerm_container_registry.registro_aks.id

  role_definition_name = "AcrPull"
  skip_service_principal_aad_check = true
  
}


output "certificado_cliente" {
  value = azurerm_kubernetes_cluster.cluster_aks.kube_config[0].client_certificate
  sensitive = true
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.cluster_aks.kube_config_raw
  sensitive = true
}

output "registro_contenedores" {

  value = azurerm_container_registry.registro_aks
  sensitive = true
}
