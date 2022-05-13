#!/bin/bash

az login --identity

az account set -s ${SUBSCRIPTION_ID}
az aks get-credentials -g ${CLUSTER_RG} -n ${CLUSTER_NAME} --overwrite-existing

kubectl create ns istio-system
kubectl --context="${CLUSTER_NAME}" create secret generic cacerts -n istio-system \
 --from-literal=ca-cert.pem=${CLUSTER_CA_CERT} \
 --from-literal=ca-key.pem=${CLUSTER_CA_KEY} \
 --from-literal=root-cert.pem=${CLUSTER_ROOT_CA_CERT} \
 --from-literal=cert-chain.pem=${CLUSTER_CERT_CHAIN} 