# Introduction 

This repo is to automate the setup of a Multi-primary Istio Mesh of two AKS clusters

## Required Existing Resources and Configuration
| |  |
--------------- | --------------- 
| Azure Virtual Network (Core) | Azure Virtual Network (Kubernetes) |
| A DNS server | [Private Endpoint DNS Configuration](https://docs.microsoft.com/en-us/azure/private-link/private-endpoint-dns#on-premises-workloads-using-a-dns-forwarder) |
| Virtual Networks Peered |  Vnet DNS set to DNS Server |
| Subnet for Kubernetes (at least /23) | Subnet for Private Endpoints named private-endpoints |
| A [Github Actions Runner VM](https://docs.github.com/en/actions/using-github-hosted-runners/about-github-hosted-runners) with: | A User Assigned Manage Identity | 
|| Identity granted Owner permissions over each subscription |
| Azure Container Repository | Private EndPoint for ACR |
| An Azure SPN | Granted AcrPush/AcrPull RBAC from ACR |
| Azure Firewall| [AKS Egress Policies](https://docs.microsoft.com/en-us/azure/aks/limit-egress-traffic) |
| Route Table | Route 0.0.0.0/0 traffic from Kubernetes subnet to Azure Firewall |
| Azure Storage | Blob Container (for Terraform state files) |
| Private DNS Zones (attached to Core Vnet) | privatelink.${region}.azmk8s.io |
|| privatelink.vaultcore.azure.net |
|| privatelink.azurecr.io |
|| Custom Domain (example - bjdazure.tech) |

# Steps 
## Create Istio CA and Cluster Intermediate Certficates 
* cd istio
* make -f ../tools/certs/Makefile.selfsigned.mk root-ca
* make -f ../tools/certs/Makefile.selfsigned.mk ${SC_CLUSTERNAME}-cacerts
* make -f ../tools/certs/Makefile.selfsigned.mk ${CE_CLUSTERNAME}-cacerts

## Create Github Actions  Secrets
* ARM_TENANT_ID - Azure Tenant ID
* SOUTHCENTRAL_SUBSCRIPTION_ID - Azure Subscription for Resources in South Central Region 
* CENTRAL_SUBSCRIPTION_ID - Azure Subscription for Resources in Central Region (can be the same as SOUTHCENTRAL_SUBSCRIPTION_ID )
* CORE_SUBSCRIPTION_ID - Azure Subscription for Core Resources as defined adove (can be the same as SOUTHCENTRAL_SUBSCRIPTION_ID )
* PAT_TOKEN - Github Personal Access Token with repo rights for Flux
* CERTIFICATE - PFX encoded certificate base64'd for Istio Ingress
* CERT_PASSWORD - Private key password for above certificate 
* ROOT_CA_CERT - base64 encoded of the root certicate created above
* CE_CLUSTER_CA_CERT - base64 encoded of the cluster CA certicate created for the Central Region
* CE_CLUSTER_CA_KEY - base64 encoded of the cluster CA private key created for the Central Region
* CE_CLUSTER_CERT_CHAIN - base64 encoded of the cluster certicate chain created for the Central Region
* SC_CLUSTER_CA_CERT - base64 encoded of the cluster CA private key  created for the South Central Region
* SC_CLUSTER_CA_KEY - base64 encoded of the cluster CA certicate created for the South Central Region
* SC_CLUSTER_CERT_CHAIN - base64 encoded of the cluster certicate chain created for the South Central Region 

## Update Values
  _.github/workflows/main.yaml_

* GITHUB_ACCOUNT: briandenicola
* GITHUB_REPO: istio-multi-primary-setup
* REPO_BRANCH: main

## Github Actions
* Manually Trigger Github Action Workflow - Multi-primary Istio Service Mesh

# References:
  * https://istio.io/latest/docs/tasks/security/cert-management/plugin-ca-cert/
  * https://istio.io/latest/docs/setup/install/multicluster/multi-primary/
