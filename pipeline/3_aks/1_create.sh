# Parameters
resource_group=$1
location=$2
admin_resource_group=$3
clustername=$4
aks_vnet_name=$5
route_table_name=$6
aksSubnetPrefix=$7
dnsPrefix=$clustername

# subnet
function createSubnet(){
   az deployment group create -g $admin_resource_group --template-file ./aks-subnet.json --parameters ./aks-subnet.parameters.json --parameters clusterName=$clustername vnetName=$aks_vnet_name subnetPrefix=$aksSubnetPrefix
}

# link
function createLinkToRouteTable(){
   az network vnet subnet update -g $admin_resource_group --vnet-name $aks_vnet_name --name $clustername-subnet --route-table $route_table_name
}

# aks cluster
function createAksCluster(){
   subscriptionId=$(az account show --query id -o tsv)
   tenantID=$(az account show --query homeTenantId -o tsv)
   az deployment group create -g $resource_group --template-file ./aks.json --parameters ./aks.parameters.json --parameters clusterName=$clustername existingVirtualNetworkName=$aks_vnet_name dnsPrefix=$dnsPrefix subscriptionId=$subscriptionId tenantID=$tenantID existingVirtualNetworkResourceGroup=$admin_resource_group
}

createSubnet
createLinkToRouteTable
createAksCluster

