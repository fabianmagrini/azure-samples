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
  export resourceGroupName=rg-appconfig-$environmentID
fi

# set execution context (if necessary)
#az account set --subscription <replace with your subscription name or id>

# Modify for your environment.
export location=australiaeast

# Create a resource group
echo "Create resource group $resourceGroupName ..."
az group create \
    --name $resourceGroupName \
    --location $location

echo "resourceGroupName: $resourceGroupName"
