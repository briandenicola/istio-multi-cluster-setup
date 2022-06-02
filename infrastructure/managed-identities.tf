resource "azurerm_user_assigned_identity" "aks_identity" {
  name                = "${var.cluster_name}-cluster-identity"
  resource_group_name = azurerm_resource_group.k8s.name
  location            = azurerm_resource_group.k8s.location
}

resource "azurerm_user_assigned_identity" "aks_kubelet_identity" {
  name                = "${var.cluster_name}-kubelet-identity"
  resource_group_name = azurerm_resource_group.k8s.name
  location            = azurerm_resource_group.k8s.location
}
