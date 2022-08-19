location = "southcentralus"
agent_count = 3
k8s_vnet_resource_group_name = "Apps01_Network_RG"
k8s_vnet = "DevSub01-Vnet-001"
k8s_subnet = "kubernetes"
dns_service_ip = "100.64.0.10"
service_cidr = "100.64.0.0/16"
core_subscription = "ccfc5dda-43af-4b5e-8cc2-1dda18f2382e"
dns_resource_group_name = "Core_DNS_RG"
acr_resource_group = "Core_ContainerRepo_RG"
acr_name = "bjdcsa"
azure_rbac_group_object_id = "15390134-7115-49f3-8375-da9f6f608dce"
github_actions_identity_name = "gha-identity"
github_actions_identity_resource_group = "Core_DevOps_RG"