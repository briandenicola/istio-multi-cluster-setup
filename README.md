# Introduction 

This repo is to automate the setup of a Multi-primary Istio Mesh of two AKS clusters using Hashicorp Vault or using [Self Signed](https://github.com/briandenicola/istio-multi-primary-setup/tree/self-signed) Certificates

# Prerequisites
1. Azure Subscription
1. Terraform 
1. kubectl
1. istioctl

# Configuration Setup
## Deploy South Central Cluster
```bash
  az login
  terraform -chdir=./infrastructure workspace new southcentral
  terraform -chdir=./infrastructure init
  terraform -chdir=./infrastructure apply -var "location=southcentralus" -auto-approve
```

## Deploy Central Cluster
```bash
  az login

  terraform -chdir=./infrastructure workspace new central
  terraform -chdir=./infrastructure init
  terraform -chdir=./infrastructure apply -var "location=centralus" -auto-approve
```

## Peer Networks
```bash
  source ./scripts/setup-env.sh
  bash ./scripts/peer.sh
```

## Setup Hashicorp Vault
1. [Setup Vault](./Vault.md)

## Request Istio Certificates - Central
```bash

  # https://cert-manager.io/docs/configuration/vault/
  #Update ./cluster-manifests/base/certificate-issuer with values from Vault configuration 
    #  secretId: ""
    #  server: ""
    #  roleId: ""

  source ./scripts/setup-env.sh

  az aks get-credentials -g ${CENTRAL_CLUSTER_RG} -n ${CENTRAL_CLUSTER_NAME} --overwrite-existing
  kubelogin convert-kubeconfig -l azurecli
  kubectl --context="${CENTRAL_CLUSTER_NAME}" apply -f ./cluster-manifests/base/istio-namespace.yaml
  kubectl --context="${CENTRAL_CLUSTER_NAME}" apply -f ./cluster-manifests/base/certificate-issuer.yaml
  kubectl --context="${CENTRAL_CLUSTER_NAME}" apply -f ./cluster-manifests/base/certificate.yaml
  helm --kube-context="${CENTRAL_CLUSTER_NAME}" upgrade -i -n cert-manager cert-manager-istio-csr jetstack/cert-manager-istio-csr \
    --set "app.tls.rootCAFile=/var/run/secrets/istio-csr/ca.pem" \
    --set "app.server.clusterID=${CENTRAL_CLUSTER_NAME}" \
    --set "app.certmanager.issuer.name=vault-issuer" \
    --set "app.tls.certificateDNSNames[0]=cert-manager-istio-csr.istio-system.svc" \
    --set "volumeMounts[0].name=root-ca" \
    --set "volumeMounts[0].mountPath=/var/run/secrets/istio-csr" \
    --set "volumes[0].name=root-ca" \
    --set "volumes[0].secret.secretName=istio-ca"
```

## Request Istio Certificates - South Central
```bash

  #Update ./cluster-manifests/base/certificate-issuer with values from Vault configuration 
    #  secretId: ""
    #  server: ""
    #  roleId: ""

  source ./scripts/setup-env.sh

  az aks get-credentials -g ${SOUTH_CENTRAL_CLUSTER_RG} -n ${SOUTH_CENTRAL_CLUSTER_NAME} --overwrite-existing
  kubelogin convert-kubeconfig -l azurecli
  kubectl --context="${SOUTH_CENTRAL_CLUSTER_NAME}" apply -f ./cluster-manifests/base/istio-namespace.yaml
  kubectl --context="${SOUTH_CENTRAL_CLUSTER_NAME}" apply -f ./cluster-manifests/base/certificate-issuer.yaml
  kubectl --context="${SOUTH_CENTRAL_CLUSTER_NAME}" apply -f ./cluster-manifests/base/certificate.yaml
  helm --kube-ccontext="${SOUTH_CENTRAL_CLUSTER_NAME}"  upgrade -i -n cert-manager cert-manager-istio-csr jetstack/cert-manager-istio-csr \
    --set "app.tls.rootCAFile=/var/run/secrets/istio-csr/ca.pem" \
    --set "app.server.clusterID=${CENTRAL_CLUSTER_NAME}" \
    --set "app.certmanager.issuer.name=vault-issuer" \
    --set "app.tls.certificateDNSNames[0]=cert-manager-istio-csr.istio-system.svc" \
    --set "volumeMounts[0].name=root-ca" \
    --set "volumeMounts[0].mountPath=/var/run/secrets/istio-csr" \
    --set "volumes[0].name=root-ca" \
    --set "volumes[0].secret.secretName=istio-ca"
```

## Install Istio - Central
```bash
  watch kubectl --context="${CENTRAL_CLUSTER_NAME}" apply -f ./cluster-manifests/base/istio-operator.yaml
  kubectl --context="${CENTRAL_CLUSTER_NAME}" apply -k ./cluster-mantifests/central
```

## Install Istio - South Central
```bash
  watch kubectl --context="${SOUTH_CENTRAL_CLUSTER_NAME}" apply -f ./cluster-manifests/base/istio-operator.yaml
  kubectl --context="${SOUTH_CENTRAL_CLUSTER_NAME}" apply -k ./cluster-mantifests/southcentral
```

## Setup Istio Remote Secrets
```bash
  source ./scripts/setup-env.sh

  istioctl x create-remote-secret --context="${CENTRAL_CLUSTER_NAME}" --name="${CENTRAL_CLUSTER_NAME}" \
    | kubectl --context="${SOUTH_CENTRAL_CLUSTER_NAME}" apply -f - 
  istioctl x create-remote-secret --context="${SOUTH_CENTRAL_CLUSTER_NAME}" --name="${SOUTH_CENTRAL_CLUSTER_NAME}" \
    | kubectl --context="${CENTRAL_CLUSTER_NAME}" apply -f - 
```

## Deploy App 
```bash
  kubectl --context="${CENTRAL_CLUSTER_NAME}" apply -f ./apps/os-checker/v1/os-checker.yaml
  kubectl --context="${SOUTH_CENTRAL_CLUSTER_NAME}" apply -f ./apps/os-checker/v2/os-checker.yaml
```

# Validate
```bash
  kubectl run --restart=Never --image=bjd145/utils:3.10 utils
  kubectl exec utils -- curl -sS whatos-api.whatos.svc:8081/api/os
  kubectl exec utils -- curl -sS whatos-api.whatos.svc:8081/api/os
```

# References:
  * https://istio.io/latest/docs/tasks/security/cert-management/plugin-ca-cert/
  * https://istio.io/latest/docs/setup/install/multicluster/multi-primary/
