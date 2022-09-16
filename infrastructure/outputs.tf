output "CLUSTER_RG" {
    value = azurerm_kubernetes_cluster.this.resource_group_name
    sensitive = false
}

output "CLUSTER_NAME" {
    value = azurerm_kubernetes_cluster.this.name
    sensitive = false
}

output "VNET_NAME" {
    value = azurerm_virtual_network.this.name
    sensitive = false
}

output "VNET_RESOURCE_ID" {
    value = azurerm_virtual_network.this.id
    sensitive = false
}