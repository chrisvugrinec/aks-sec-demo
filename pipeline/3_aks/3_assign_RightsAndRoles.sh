admin_resource_group=$1
resource_group=$2
cluster_name=$3
aks_vnet_name=$4
scopeId=$(az aks show -n $cluster_name -g $resource_group --query id -o tsv)
# GroupsID configured in AAD for users of this AKS cluster(s)
aksGroupId=$5

# Needed for developers (login with personal account)
function createDevPersonalAccounts(){
   az role assignment create --assignee $aksGroupId  --role "Reader" --scope $scopeId
   az role assignment create --assignee $aksGroupId  --role "Azure Kubernetes Service Cluster User Role" --scope $scopeId
}

# This Non Personal Account (Service Principal) will be distributed to the developer to setup their own pipelines
# they need to config the buildmachine to access the aks cluster with kubelogin  https://github.com/Azure/kubelogin
function createDevNonPersonalAccount(){
   az ad sp create-for-rbac --skip-assignment --name $resource_group-$cluster_name >sp-2bdistributed.txt
}

# Needed for managed ID to create network resources on aks subnet
function assignContribRoleToManagedIdentity(){
   appId=$(az ad sp list --all --filter "displayname eq '"$cluster_name"'" --query [].appId -o tsv)
   subnetId=$(az network vnet subnet show -n $cluster_name-subnet -g $admin_resource_group --vnet-name $aks_vnet_name --query id -o tsv)
   az role assignment create --assignee $appId --role "Contributor" --scope $subnetId
}

createDevPersonalAccounts
createDevNonPersonalAccount
assignContribRoleToManagedIdentity
