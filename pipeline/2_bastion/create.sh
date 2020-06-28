admin_resource_group=$1
resource_group=$2
location=$3
vnet_name=$4
adminUsername=$5
vmName=$6
subnetName=$7


# create resourcegroup
az group create -n $resource_group -l $location
# create bastion VM
az deployment group create -g $resource_group --template-file ./vm.json --parameters ./vm.parameters.json --parameters vmName=$vmName virtualNetworkName=$vnet_name  subnetName=$subnetName adminResourceGroup=$admin_resource_group
