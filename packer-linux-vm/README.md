# Packer Sample

How to use Packer to create Linux virtual machine images in Azure.

References:

* <https://docs.microsoft.com/en-us/azure/virtual-machines/linux/build-image-with-packer>
* <https://www.packer.io/docs/builders/azure.html>

## Prerequisites

* Packer
* Azure CLI
* az login

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
