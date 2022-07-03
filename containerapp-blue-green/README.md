# Zero downtime deployment with Azure Container App

Implementing blue green deployments on Azure Container Apps.

References:

* <https://github.com/fabianmagrini/awesome-learn-azure#azure-container-apps>

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

## Test public url

```sh
fqdn=<fqdn for the Container App>
curl --silent https://$fqdn
```

## Clean up deployment

```sh
./scripts/cleanup.sh

# delete resource group
resourceGroupName=<resource group name>
az group delete --name $resourceGroupName --yes --no-wait
```
