#!/bin/bash

az account set -s ${SUBSCRIPTION_ID}
az aks get-credentials -g ${CLUSTER_RG} -n ${CLUSTER_NAME} --overwrite-existing

RESOURCEID=`az identity show --name ${IDENTITY_NAME} --resource-group ${IDENTITY_RG} --query id -o tsv`
az aks pod-identity add --resource-group ${CLUSTER_RG} --cluster-name ${CLUSTER_NAME} --namespace ${NAMESPACE} --name ${IDENTITY_NAME} --identity-resource-id ${RESOURCEID}