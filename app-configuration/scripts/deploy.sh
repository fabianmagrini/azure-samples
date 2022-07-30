#!/bin/bash

if [ -z "$environmentID" ] || [ -z "$resourceGroupName" ]
then
  echo "Empty variables, run setup.sh"
  exit
fi

# set execution context (if necessary)
#az account set --subscription <replace with your subscription name or id>

# Modify for your environment.
location=australiaeast
deploymentName=appconnfig-$environmentID
configStoreName=$deploymentName

# Deploy Infrastructure

echo "Deploy Bicep template ..."
az deployment group create \
  --name $deploymentName \
  --resource-group $resourceGroupName \
  --template-file "./bicep/main.bicep" \
  --parameters configStoreName=$configStoreName

#fqdn=$(az deployment group show -g $resourceGroupName --query properties.outputs.fqdn.value -n $deploymentName -o tsv)

echo "deploymentName: $deploymentName"
echo "resourceGroupName: $resourceGroupName"
