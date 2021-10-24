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
  resourceGroupName=simple-rg-$environmentID
fi

# set execution context (if necessary)
#az account set --subscription <replace with your subscription name or id>

# Modify for your environment.
location=australiaeast
deploymentName=simple-$environmentID

# Create a resource group
echo "Create resource group $resourceGroupName ..."
az group create \
    --name $resourceGroupName \
    --location $location

# Deploy Infrastructure
adminUsername=azureuser
adminPassword=$(openssl rand -base64 32)

echo "Deploy Bicep template ..."
az deployment group create \
  --name $deploymentName \
  --resource-group $resourceGroupName \
  --template-file "./main.bicep" \
  --parameters "{ \"adminUsername\": { \"value\": \"$adminUsername\" },  \"adminPassword\": { \"value\": \"$adminPassword\" }}"

echo "environmentID: $environmentID"
echo "resourceGroupName: $resourceGroupName"
echo "adminUsername: $adminUsername"
echo "adminPassword: $adminPassword"