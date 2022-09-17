#!/bin/bash

while (( "$#" )); do
  case "$1" in
    -n|--name)
      peer_name=$2
      shift 2
      ;;
    -h|--help)
      echo "Usage: ./peer.sh [--name]
        --peer(n)    - A defined name for the peering. Will be auto-generated if not supplied (Optional)
      "
      exit 0
      ;;
    --) 
      shift
      break
      ;;
    -*|--*=) 
      echo "Error: Unsupported flag $1" >&2
      exit 1
      ;;
  esac
done

if [[ -z "${peer_name}" ]]; then
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
