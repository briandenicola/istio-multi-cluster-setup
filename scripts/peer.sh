#!/bin/bash

if [[ -z "${appName}" ]]; then
  peer_name=`cat /dev/urandom | tr -dc 'a-z' | fold -w 8 | head -n 1`
fi 

az network vnet peering create --name ${peer_name} \
    --remote-vnet ${SOUTH_CENTRAL_VNET_ID} \
    --resource-group ${CENTRAL_CLUSTER_RG} \
    --vnet-name ${CENTRAL_VNET_NAME} \
    --allow-vnet-access \
    --allow-forwarded-traffic 

az network vnet peering create --name ${peer_name} \
    --remote-vnet ${CENTRAL_VNET_ID} \
    --resource-group ${SOUTH_CENTRAL_CLUSTER_RG} \
    --vnet-name ${SOUTH_CENTRAL_VNET_NAME} \
    --allow-vnet-access \
    --allow-forwarded-traffic 
