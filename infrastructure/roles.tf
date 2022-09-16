resource "azurerm_role_assignment" "aks_role_assignemnt_nework" {
  for_each = local.locations
  scope                = azurerm_virtual_network.this[each.key].id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.aks_identity[each.key].principal_id
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "aks_role_assignemnt_msi" {
  for_each = local.locations
  scope                = azurerm_user_assigned_identity.aks_kubelet_identity[each.key].id
  role_definition_name = "Managed Identity Operator"
  principal_id         = azurerm_user_assigned_identity.aks_identity[each.key].principal_id
  skip_service_principal_aad_check = true 
}

resource "azurerm_role_assignment" "cluster_owner" {
  for_each = local.locations
  scope                = azurerm_kubernetes_cluster.this[each.key].id
  role_definition_name = "Azure Kubernetes Service RBAC Cluster Admin"
  principal_id         = data.azurerm_client_config.current.object_id
}
