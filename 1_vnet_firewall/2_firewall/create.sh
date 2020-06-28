# Params
resource_group=aks-sec-demo-admin-resources
fw_name=demo-fw
location=australiaeast
# This is the name of the public IP you created in the step before
pip_fw_name=aks-sec-demo-fw-pip
# This is the name of the mgmt vnet you created in step 1
mgmt_vnet_name=mgmt-vnet
subnetPrefixForAFW=10.10.254.0/26
route_table_name=aks-sec-demo-routetable
domain=aks-sec-demo
aksVnetRange=10.100.0.0


# Create Public IP
function createPip(){
   az deployment group create -g $resource_group --template-file ./public-ip.json --parameters pip_fw_name=$pip_fw_name  domain=$domain
}

# Create subnet
function createSubnet(){
   az deployment group create -g $resource_group --template-file ./fw-subnet.json --parameters vnetName=$mgmt_vnet_name subnetPrefix=$subnetPrefixForAFW
}


# Create firewall
function createFirewall(){
   fw_public_ip_id=$(az network public-ip show -n $pip_fw_name -g $resource_group --query id -o tsv)
   fw_public_ip=$(az network public-ip show -g $resource_group -n $pip_fw_name --query "ipAddress" -o tsv)
   mgmt_vnet_id=$(az network vnet show -n $mgmt_vnet_name -g $resource_group --query id -o tsv)
   # create json 
   cat fw.json.template | sed 's/___LOCATION___/'$location'/g' >fw.json
   az deployment group create -g $resource_group --template-file ./fw.json  --parameters fw_name=$fw_name public_ip_id=$fw_public_ip_id mgmt_vnet_id=$mgmt_vnet_id fw_public_ip=$fw_public_ip aksVnetRange=$aksVnetRange
}

# UDR
function createUDR(){
   fw_public_ip=$(az network public-ip show -g $resource_group -n $pip_fw_name --query "ipAddress" -o tsv)
   fw_private_ip=$(az network firewall show -g $resource_group -n $fw_name --query "ipConfigurations[0].privateIpAddress" -o tsv)
   echo "fw public ip: "$fw_public_ip
   echo "fw private ip: "$fw_private_ip
   az deployment group create -g $resource_group --template-file ./udr.json --parameters fw-internal-ip=$fw_private_ip fw-public-ip=$fw_public_ip route_table_name=$route_table_name
}

createPip
createSubnet
createFirewall
createUDR
