# Parameters
resource_group=aks-sec-demo-app1-resources
location=australiaeast
admin_resource_group=aks-sec-demo-admin-resources
clustername=aks-sec-demo
aks_vnet_name="aks-vnet"
route_table_name="aks-sec-demo-routetable"
aksSubnetPrefix=10.100.1.0/24
dnsPrefix=$clustername

# subnet
function createSubnet(){
   az deployment group create -g $admin_resource_group --template-file ./aks-subnet.json --parameters ./aks-subnet.parameters.json --parameters clusterName=$clustername vnetName=$aks_vnet_name subnetPrefix=$aksSubnetPrefix
}

# link
function createLinkToRoutTable(){
   az network vnet subnet update -g $admin_resource_group --vnet-name $aks_vnet_name --name $clustername-subnet --route-table $route_table_name
}

# aks cluster
function createAksCluster(){
   subscriptionId=$(az account show --query id -o tsv)
   tenantID=$(az account show --query homeTenantId -o tsv)
   az group create -n $resource_group -l $location
   az deployment group create -g $resource_group --template-file ./aks.json --parameters ./aks.parameters.json --parameters clusterName=$clustername existingVirtualNetworkName=$aks_vnet_name dnsPrefix=$dnsPrefix subscriptionId=$subscriptionId tenantID=$tenantID existingVirtualNetworkResourceGroup=$admin_resource_group
}

#createSubnet
#createLinkToRoutTable
createAksCluster
