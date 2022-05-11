#!/bin/bash

az login --identity

az account set -s ${CENTRAL_SUBSCRIPTION_ID}
az aks get-credentials -g ${CE_CLUSTER_RG} -n ${CE_CLUSTER_NAME} --overwrite-existing

az account set -s ${SOUTHCENTRAL_SUBSCRIPTION_ID}
az aks get-credentials -g ${SC_CLUSTER_RG} -n ${SC_CLUSTER_NAME} --overwrite-existing

istioctl x create-remote-secret --context="${CE_CLUSTER_NAME}" --name="${CE_CLUSTER_NAME}"| kubectl apply -f - --context="${SC_CLUSTER_NAME}"
istioctl x create-remote-secret --context="${SC_CLUSTER_NAME}" --name="${SC_CLUSTER_NAME}"| kubectl apply -f - --context="${CE_CLUSTER_NAME}"