#!/bin/bash

# Overide settings on the command line
# ARG1 is environmentID
# ARG2 is resourceGroupName
if [ $# -eq 2 ]
then
  export environmentID=$1
  export resourceGroupName=$2
else
  export environmentID=$RANDOM
  export resourceGroupName=rg-containerapp-$environmentID
fi

# set execution context (if necessary)
#az account set --subscription <replace with your subscription name or id>

# Modify for your environment.
export location=northeurope
export acrName=containerapp$environmentID

# Create a resource group
echo "Create resource group $resourceGroupName ..."
az group create \
    --name $resourceGroupName \
    --location $location

# Create an Azure Container Registry
echo "Create Azure Container Registry $acrName ..."
az acr create -n $acrName -g $resourceGroupName -l $location --sku Basic --admin-enabled true

# Grab Admin Password from ACR
export acrPassword=$(az acr credential show -n $acrName --query "passwords[0].value" -o tsv)

echo "resourceGroupName: $resourceGroupName"
echo "acrName: $acrName"
