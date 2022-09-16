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
  location        = "southcentralus"
  resource_name   = "${random_pet.this.id}-${random_id.this.dec}"
  aks_name        = "${local.resource_name}-aks"
  acr_name        = "acr${random_pet.this.id}${random_id.this.dec}"
}

resource "azurerm_resource_group" "this" {
  name     = "${local.resource_name}_rg"
  location = local.location

  tags = {
    Application = "whatos"
    Components  = "aks; skaffold; keyvault"
    DeployedOn  = timestamp()
    Deployer    = data.azurerm_client_config.current.object_id
  }
}
