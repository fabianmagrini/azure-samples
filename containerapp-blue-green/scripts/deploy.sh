#!/bin/bash

if [ -z "$environmentID" ] || [ -z "$resourceGroupName" ]
then
  echo "Empty variables, run setup.sh"
  exit
fi

# set execution context (if necessary)
#az account set --subscription <replace with your subscription name or id>

# Modify for your environment.
location=northeurope
deploymentName=containerapp-$environmentID
acrName=containerapp$environmentID

# Deploy Infrastructure

echo "Deploy Bicep template ..."
az deployment group create \
  --name $deploymentName \
  --resource-group $resourceGroupName \
  --template-file "./bicep/main.bicep" \
  --parameters "{ \"environmentName\": { \"value\": \"env-$deploymentName\" }, \"containerAppName\": { \"value\": \"app-$deploymentName\" }, \"registry\": { \"value\": \"$acrName.azurecr.io\" }, \"registryUsername\": { \"value\": \"$acrName\" }, \"registryPassword\": { \"value\": \"$acrPassword\" }}"

fqdn=$(az deployment group show -g $resourceGroupName --query properties.outputs.fqdn.value -n $deploymentName -o tsv)

echo "deploymentName: $deploymentName"
echo "resourceGroupName: $resourceGroupName"
echo "acrName: $acrName"
echo "fqdn: $fqdn"