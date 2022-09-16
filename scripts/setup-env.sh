export CENTRAL_CLUSTER_RG=$(terraform -chdir=./infrastructure output -raw CENTRAL_CLUSTER_RG)
export CENTRAL_CLUSTER_NAME=$(terraform -chdir=./infrastructure output -raw CENTRAL_CLUSTER_NAME)
export CENTRAL_CLUSTER_RG=$(terraform -chdir=./infrastructure output -raw CENTRAL_CLUSTER_RG)
export SOUTH_CENTRAL_CLUSTER_NAME=$(terraform -chdir=./infrastructure output -raw SOUTH_CENTRAL_CLUSTER_NAME)

