#!/bin/bash 

terraform -chdir=./infrastructure workspace select central
export CENTRAL_CLUSTER_RG=$(terraform -chdir=./infrastructure output -raw CLUSTER_RG)
export CENTRAL_CLUSTER_NAME=$(terraform -chdir=./infrastructure output -raw CLUSTER_NAME)
export CENTRAL_VNET_NAME=$(terraform -chdir=./infrastructure output -raw VNET_NAME)
export CENTRAL_VNET_ID=$(terraform -chdir=./infrastructure output -raw VNET_RESOURCE_ID)

terraform -chdir=./infrastructure workspace select southcentral
export SOUTH_CENTRAL_CLUSTER_RG=$(terraform -chdir=./infrastructure output -raw CLUSTER_RG)
export SOUTH_CENTRAL_CLUSTER_NAME=$(terraform -chdir=./infrastructure output -raw CLUSTER_NAME)
export SOUTH_CENTRAL_VNET_NAME=$(terraform -chdir=./infrastructure output -raw VNET_NAME)
export SOUTH_CENTRAL_VNET_ID=$(terraform -chdir=./infrastructure output -raw VNET_RESOURCE_ID)