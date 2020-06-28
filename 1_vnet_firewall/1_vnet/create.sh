# Params
resource_group=aks-sec-demo-admin-resources
vnetMgmtName=mgmt-vnet
vnetAksName=aks-vnet
location=australiaeast
vnetMgmtAddressPrefix=10.10.0.0/16
vnetAksAddressPrefix=10.100.0.0/16
mgmtSubnetName=aks-mgmt-subnet
mgmtSubnetPrefix=10.10.2.0/24

az group create -n $resource_group -l $location
az deployment group create -g $resource_group --template-file ./azuredeploy.json --parameters location=$location vnetMgmtName=$vnetMgmtName vnetAksName=$vnetAksName vnetMgmtAddressPrefix=$vnetMgmtAddressPrefix vnetAksAddressPrefix=$vnetAksAddressPrefix subnetName=$mgmtSubnetName subnetPrefix=$mgmtSubnetPrefix
