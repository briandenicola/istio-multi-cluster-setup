#!/bin/bash

az login --identity

az account set -s ${CENTRAL_SUBSCRIPTION_ID}
az aks get-credentials -g ${CE_CLUSTER_RG} -n ${CE_CLUSTER_NAME} --overwrite-existing

az account set -s ${SOUTHCENTRAL_SUBSCRIPTION_ID}
az aks get-credentials -g ${SC_CLUSTER_RG} -n ${SC_CLUSTER_NAME} --overwrite-existing

kubectl --context="${CE_CLUSTER_NAME}" create secret generic cacerts -n istio-system \
 --from-literal=ca-cert.pem=${CE_CLUSTER_CA_CERT} \
 --from-literal=ca-key.pem=${CE_CLUSTER_CA_KEY} \
 --from-literal=root-cert.pem=${CE_CLUSTER_ROOT_CA_CERT} \
 --from-literal=cert-chain.pem=${CE_CLUSTER_CERT_CHAIN} \

kubectl --context="${SC_CLUSTER_NAME}" create secret generic cacerts -n istio-system \
 --from-literal=ca-cert.pem=${SC_CLUSTER_CA_CERT} \
 --from-literal=ca-key.pem=${SC_CLUSTER_CA_KEY} \
 --from-literal=root-cert.pem=${SC_CLUSTER_ROOT_CA_CERT} \
 --from-literal=cert-chain.pem=${SC_CLUSTER_CERT_CHAIN} \
