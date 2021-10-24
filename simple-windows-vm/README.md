# Simple Windows VM

Create a Windows VM using bicep.

References:

* <https://docs.microsoft.com/en-us/azure/virtual-machines/windows/quick-create-cli>
* <https://github.com/Azure/bicep/tree/main/docs/examples/101/vm-simple-windows>

## Prerequisites

* Azure CLI
* az login
* OpenSSL - used to generate passwords

## Run deployment

```sh
chmod 775 *.sh
./setup.sh
```

## Clean up deployment

```sh
resourceGroupName=<resource group name>
az group delete --name $resourceGroupName --yes --no-wait
```
