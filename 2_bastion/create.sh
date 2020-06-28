admin_resource_group=aks-sec-demo-admin-resources
resource_group=aks-sec-demo-app1-resources
location=australiaeast
bastion_host_name=bastion-host
bastion_subnet_ip_prefix=10.10.1.0/27
vnet_name=mgmt-vnet
adminUsername=chris
vmName=aks-mgmt1
subnetName=aks-mgmt-subnet


# create bastion
az deployment group create -g $admin_resource_group --template-file ./bastion.json --parameters bastion-host-name=$bastion_host_name bastion-subnet-ip-prefix=$bastion_subnet_ip_prefix vnet-name=$vnet_name

# create resourcegroup
az group create -n $resource_group -l $location
# create bastion VM
az deployment group create -g $resource_group --template-file ./vm.json --parameters ./vm.parameters.json --parameters vmName=$vmName virtualNetworkName=$vnet_name  subnetName=$subnetName adminResourceGroup=$admin_resource_group
