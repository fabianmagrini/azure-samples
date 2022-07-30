# Sample Azure App Configuration

Create an Azure App Configuration using bicep.

References:

* <https://docs.microsoft.com/en-us/azure/azure-app-configuration/quickstart-bicep?tabs=CLI>

## Prerequisites

* Azure CLI
* az login

## Run setup

```sh
chmod 775 ./scripts/*.sh
# use source as we want to set environment variables in parent shell
source ./scripts/setup.sh
```

## Run deployment

```sh
./scripts/deploy.sh
```

## Test

```sh
az resource list --resource-group $resourceGroupName
```

## Clean up deployment

```sh
./scripts/cleanup.sh

# delete resource group
resourceGroupName=<resource group name>
az group delete --name $resourceGroupName --yes --no-wait
```
