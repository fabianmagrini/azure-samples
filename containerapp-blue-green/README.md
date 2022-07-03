# Zero downtime deployment with Azure Container App

Implementing blue green deployments on Azure Container Apps.

References:

* <https://github.com/fabianmagrini/awesome-learn-azure#azure-container-apps>

## Prerequisites

* Azure CLI
* az login

## Run deployment

```sh
chmod 775 *.sh
./setup.sh
```

## Test public url

```sh
fqdn=<fqdn for the Container App>
curl --silent https://$fqdn
```

## Clean up deployment

```sh
resourceGroupName=<resource group name>
az group delete --name $resourceGroupName --yes --no-wait
```
