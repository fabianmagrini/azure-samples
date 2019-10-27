# Azure samples

Samples for creating Azure infra

## Prerequisites

* Azure CLI
* az login
* jq - utility for extracting values from json

### Logging into the Azure CLI

If you have multiple subscriptions then set subscription after completing the login.

```sh
az login
az account list
az account set --subscription="SUBSCRIPTION_ID"
```

## Appendix

Useful Azure CLI commands

### List subscriptions

```sh
az account list
```

You will find the subscriptionId and tenantId displayed.

Get your account information

```sh
az account list --output json | jq -r '.[].name'
az account show --output json | jq -r '.id'
```

### List Resource Groups

```sh
az group list
```

### List Resources

```sh
az resource list
az resource list --location australiaeast
az resource list --resource-group SuperfundLookupRG
```

### Create a Resource Group

```sh
LOCATION=xxx
GROUPNAME=xxx

az group create --name $GROUPNAME --location $LOCATION
```

### Create a Storage Account

```sh
az storage account create \
  --name STORAGENAME
  --resource-group $GROUPNAME \
  --location $LOCATION \
  --sku Standard_LRS \
  --kind Storage
```

### Create a Service Principal

```sh
az ad sp create-for-rbac -n "Packer" --role contributor \
                            --scopes /subscriptions/{SubID}
```

### List role definitions

```sh
az role definition list --output json | jq ".[] | {name:.roleName, description:.description}"
```
