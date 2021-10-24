# Simple Windows VM

Create a Windows VM using bicep.

References:

* <https://docs.microsoft.com/en-us/azure/virtual-machines/windows/quick-create-cli>
* <https://github.com/Azure/bicep/tree/main/docs/examples/101/vm-simple-windows>
* <https://docs.microsoft.com/en-us/azure/network-watcher/traffic-analytics>

## Prerequisites

* Azure CLI
* az login
* OpenSSL - used to generate passwords

## Run deployment

```sh
chmod 775 *.sh
./setup.sh
```

## Configure VM

### Open port 80 for web traffic

```sh
resourceGroupName=<resource group name>
vmName=<vm name>
az vm open-port --port 80 --resource-group $resourceGroupName --name $vmName
```

### Install web server

Create a remote desktop sesion to the VM and install the IIS webserver. Run PowerShell:

```sh
Install-WindowsFeature -name Web-Server -IncludeManagementTools
```

Test using curl

```sh
curl --connect-timeout 5 http://$IPADDRESS
```

## Configure NSG

Get information about a network security group

```sh
resourceGroupName=<resource group name>
networkSecurityGroupName=<nsg name>
az network nsg show --resource-group $resourceGroupName --name $networkSecurityGroupName
```

List current rules

```sh
az network nsg rule list \
--resource-group $resourceGroupName \
--nsg-name $networkSecurityGroupName \
--query '[].{Name:name, Priority:priority, Port:destinationPortRange, Access:access}' \
--output table
```

Create a basic "Allow" NSG rule

```sh
az network nsg rule create --resource-group $resourceGroupName --nsg-name $networkSecurityGroupName \
--name allow-http \
--protocol tcp \
--priority 1010 \
--destination-port-range 80 \
--access Allow
```

## Traffic Analytics

To create an instance of Network Watcher

```sh
az network watcher configure --resource-group NetworkWatcherRG --locations $location --enabled
```

## Clean up deployment

```sh
resourceGroupName=<resource group name>
az group delete --name $resourceGroupName --yes --no-wait
```
