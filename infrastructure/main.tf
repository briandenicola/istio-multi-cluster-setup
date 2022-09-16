data "azurerm_client_config" "current" {}

data "http" "myip" {
  url = "http://checkip.amazonaws.com/"
}

resource "random_id" "this" {
  byte_length = 2
}

resource "random_pet" "this" {
  length    = 1
  separator = ""
}

resource "random_password" "password" {
  length  = 25
  special = true
}

locals {
  locations_list  = ["southcentralus", "centralus"]
  locations       = toset(local.locations_list)
  resource_name   = "${random_pet.this.id}-${random_id.this.dec}"
  aks_name        = "${local.resource_name}-aks"
}

resource "azurerm_resource_group" "this" {
  for_each = local.locations
  name     = "${local.resource_name}_${each.key}_rg"
  location = each.key

  tags = {
    Application = "whatos"
    Components  = "aks; istio, ${each.key}"
    DeployedOn  = timestamp()
    Deployer    = data.azurerm_client_config.current.object_id
  }
}
