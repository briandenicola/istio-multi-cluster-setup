output "CENTRAL_CLUSTER_RG" {
    value = azurerm_kubernetes_cluster.this["centralus"].resource_group_name
    sensitive = false
}

output "CENTRAL_CLUSTER_NAME" {
    value = azurerm_kubernetes_cluster.this["centralus"].name
    sensitive = false
}

output "SOUTH_CENTRAL_CLUSTER_RG" {
    value = azurerm_kubernetes_cluster.this["southcentralus"].resource_group_name
    sensitive = false
}

output "SOUTH_CENTRAL_CLUSTER_NAME" {
    value = azurerm_kubernetes_cluster.this["southcentralus"].name
    sensitive = false
}

