resource "azurerm_user_assigned_identity" "aks_identity" {
  for_each = local.locations
  name                = "${local.aks_name}-${each.key}-cluster-identity"
  resource_group_name = azurerm_resource_group.this[each.key].name
  location            = azurerm_resource_group.this[each.key].location
}

resource "azurerm_user_assigned_identity" "aks_kubelet_identity" {
  for_each = local.locations
  name                = "${local.aks_name}-${each.key}-kubelet-identity"
  resource_group_name = azurerm_resource_group.this[each.key].name
  location            = azurerm_resource_group.this[each.key].location
}