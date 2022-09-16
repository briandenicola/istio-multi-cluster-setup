resource "azurerm_log_analytics_workspace" "this" {
  for_each = local.locations
  name                = "${local.resource_name}-${each.key}-logs"
  location            = azurerm_resource_group.this[each.key].location
  resource_group_name = azurerm_resource_group.this[each.key].name
  sku                 = "PerGB2018"
}

resource "azurerm_log_analytics_solution" "this" {
  for_each = local.locations
  solution_name         = "ContainerInsights"
  location              = azurerm_resource_group.this[each.key].location
  resource_group_name   = azurerm_resource_group.this[each.key].name
  workspace_resource_id = azurerm_log_analytics_workspace.this[each.key].id
  workspace_name        = azurerm_log_analytics_workspace.this[each.key].name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }
}

resource "azurerm_application_insights" "this" {
  for_each = local.locations
  name                = "${local.resource_name}-${each.key}-appinsights"
  location            = azurerm_resource_group.this[each.key].location
  resource_group_name = azurerm_resource_group.this[each.key].name
  workspace_id        = azurerm_log_analytics_workspace.this[each.key].id
  application_type    = "web"
}
