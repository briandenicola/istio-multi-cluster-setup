#!/bin/bash

az login --identity
az account set -s ${SUBSCRIPTION_ID}
az aks get-credentials -g ${CLUSTER_RG} -n ${CLUSTER_NAME} --overwrite-existing
kubelogin convert-kubeconfig -l msi

kubectl create ns flux-system || true
flux --context="${CLUSTER_NAME}" bootstrap github --owner=${GITHUB_ACCOUNT} --repository=${GITHUB_REPO} --path=${CLUSTER_BOOTSTRAP_PATH} --branch=${REPO_BRANCH}  --personal=true --private=false --token-auth