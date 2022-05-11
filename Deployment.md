# Deployment 
The following is a detailed guide on how to standup an AKS cluster using the code in this repository via GitHub Actions 

# Prerequisites 
## Subscriptions and Artifacts
* An Azure subscription (two for a more Enterprise Scale-like deployment)
* A GitHub respository 
* A custom domain with a TLS certificate - the following will use bjdazure.tech and a cert from [Let's Encrypt](https://letsencrypt.org/)
* Enable [AKS Preview Features](./preview-features.md) - Once time per subscription

## Required Existing Resources and Configuration (Per Azure Region)
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