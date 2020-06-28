admin_resource_group=aks-sec-demo-admin-resources
resource_group=aks-sec-demo-app1-resources
mgmt_network=mgmt-vnet
cluster_name=aks-sec-demo
# this should be an ip within the aks subnet range
loadbalancerip=10.100.1.100

fqdn=$(az aks show -n $cluster_name -g $resource_group --query privateFqdn -o tsv)
zoneName=$(echo $fqdn | sed 's/^[^.]*.//')
#zoneName=$(az network private-dns zone list --query "[].name" -o tsv | grep $fqdn)

mgmtNetworkID=$(az network vnet show -n $mgmt_network -g $admin_resource_group --query "id" -o tsv)
managedRgName=$(az aks show -n $cluster_name -g $resource_group --query "nodeResourceGroup" -o tsv)

# Linking the private cluster zone to mgmt vnet
echo "zone name: $zoneName"
echo "ID mgmt network: $mgmtNetworkID"
echo "resourcegroup: $managedRgName"
az deployment group create -g $managedRgName --template-file ./dns-link.json  --parameters privateDnsZone=$zoneName vnetMgmtId=$mgmtNetworkID


# create the zone for the app demo.com
az deployment group create -g $resource_group --template-file ./dns-zone.json  --parameters vnet_mgmt_id=$mgmtNetworkID cluster_name=$cluster_name loadbalancerip=$loadbalancerip
