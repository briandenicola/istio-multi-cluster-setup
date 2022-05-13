#!/bin/bash

export NAMESPACE=istio-system

az login --identity

az account set -s ${SUBSCRIPTION_ID}
az aks get-credentials -g ${CLUSTER_RG} -n ${CLUSTER_NAME} --overwrite-existing

kubectl create ns ${NAMESPACE}
cat <<EOF | kubectl --context="${CLUSTER_NAME}" apply -f -
apiVersion: v1
kind: Secret
metadata:
  name: cacerts
  namespace: ${NAMESPACE}
type: Opaque
data:
  ca-cert.pem: ${CLUSTER_CA_CERT}
  ca-key.pem: ${CLUSTER_CA_KEY}
  root-cert.pem: ${CLUSTER_ROOT_CA_CERT}
  cert-chain.pem: ${CLUSTER_CERT_CHAIN}
EOF