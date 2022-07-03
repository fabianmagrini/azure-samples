#!/bin/bash

# Overide settings on the command line
# ARG1 is environmentID
# ARG2 is resourceGroupName
if [ $# -eq 2 ]
then
  environmentID=$1
  resourceGroupName=$2
else
  environmentID=$RANDOM
  resourceGroupName=rg-containerapp-$environmentID
fi

# set execution context (if necessary)
#az account set --subscription <replace with your subscription name or id>

# Modify for your environment.
location=northeurope
deploymentName=containerapp-$environmentID
acrName=containerapp$environmentID

# Create a resource group
echo "Create resource group $resourceGroupName ..."
az group create \
    --name $resourceGroupName \
    --location $location

# Create an Azure Container Registry
az acr create -n $acrName -g $resourceGroupName -l $location --sku Basic --admin-enabled true

# Grab Admin Password from ACR
acrPassword=$(az acr credential show -n $acrName --query "passwords[0].value" -o tsv)

# Deploy Infrastructure

echo "Deploy Bicep template ..."
az deployment group create \
  --name $deploymentName \
  --resource-group $resourceGroupName \
  --template-file "./main.bicep" \
  --parameters "{ \"environmentName\": { \"value\": \"env-$deploymentName\" }, \"containerAppName\": { \"value\": \"app-$deploymentName\" }, \"registry\": { \"value\": \"$acrName.azurecr.io\" }, \"registryUsername\": { \"value\": \"$acrName\" }, \"registryPassword\": { \"value\": \"$acrPassword\" }}"

fqdn=$(az deployment group show -g $resourceGroupName --query properties.outputs.fqdn.value -n $deploymentName -o tsv)

echo "deploymentName: $deploymentName"
echo "resourceGroupName: $resourceGroupName"
echo "acrName: $acrName"
echo "fqdn: $fqdn"