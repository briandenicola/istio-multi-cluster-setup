#!/bin/bash

az login --identity

az account set -s ${PRIMARY_SUBSCRIPTION_ID}
az aks get-credentials -g ${PRIMARY_CLUSTER_RG} -n ${PRIMARY_CLUSTER_NAME} --overwrite-existing
kubelogin convert-kubeconfig -l msi

az account set -s ${SECONDARY_SUBSCRIPTION_ID}
az aks get-credentials -g ${SECONDARY_CLUSTER_RG} -n ${SECONDARY_CLUSTER_NAME} --overwrite-existing
kubelogin convert-kubeconfig -l msi

istioctl x create-remote-secret --context="${PRIMARY_CLUSTER_NAME}" --name="${PRIMARY_CLUSTER_NAME}" | kubectl --context="${SECONDARY_CLUSTER_NAME}" apply -f - 
istioctl x create-remote-secret --context="${SECONDARY_CLUSTER_NAME}" --name="${SECONDARY_CLUSTER_NAME}" | kubectl --context="${PRIMARY_CLUSTER_NAME}" apply -f - 