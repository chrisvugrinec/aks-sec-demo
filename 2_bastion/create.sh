resource_group=aks-sec-demo-admin-resources
bastion_host_name=bastion-host
bastion_subnet_ip_prefix=10.10.1.0/27
vnet_name=mgmt-vnet
adminUsername=chris
vmName=aks-mgmt1
subnetName=aks-mgmt-subnet
subnetPrefix=10.10.2.0/24


# create bastion
az deployment group create -g $resource_group --template-file ./bastion.json --parameters bastion-host-name=$bastion_host_name bastion-subnet-ip-prefix=$bastion_subnet_ip_prefix vnet-name=$vnet_name

# create bastion VM
az deployment group create -g $resource_group --template-file ./vm.json --parameters ./vm.parameters.json --parameters vmName=$vmName virtualNetworkName=$vnet_name  subnetName=$subnetName subnetPrefix=$subnetPrefix
