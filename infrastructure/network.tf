resource "azurerm_virtual_network" "this" {
  for_each            = local.locations
  name                = "${local.resource_name}-network-${each.key}"
  address_space       = ["10.${25+index(local.locations_list,each.key)}.0.0/16"]
  location            = azurerm_resource_group.this[each.key].location
  resource_group_name = azurerm_resource_group.this[each.key].name
}

resource "azurerm_subnet" "this" {
  for_each            = local.locations
  name                 = "servers"
  resource_group_name  = azurerm_resource_group.this[each.key].name
  virtual_network_name = azurerm_virtual_network.this[each.key].name
  address_prefixes     = ["10.${25+index(local.locations_list,each.key)}.2.0/24"]
}

resource "azurerm_network_security_group" "this" {
  for_each            = local.locations
  name                = "${local.resource_name}-nsg"
  location            = azurerm_resource_group.this[each.key].location
  resource_group_name = azurerm_resource_group.this[each.key].name

  security_rule {
    name                       = "port_443"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "this" {
  for_each                  = local.locations
  subnet_id                 = azurerm_subnet.this[each.key].id
  network_security_group_id = azurerm_network_security_group.this[each.key].id
}

resource "azurerm_virtual_network_peering" "this" {
  name                      = "300b7e8f28b6"
  resource_group_name       = azurerm_resource_group.this[local.locations_list[0]].name
  virtual_network_name      = azurerm_virtual_network.this[local.locations_list[0]].name
  remote_virtual_network_id = azurerm_virtual_network.this[local.locations_list[1]].id
  allow_virtual_network_access = true
}