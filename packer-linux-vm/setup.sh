#!/bin/bash

# Overide settings on the command line
# ARG1 is environmentID
if [ $# -eq 0 ]
then
  environmentID=$RANDOM
else
  environmentID=$1
fi

# set execution context (if necessary)
#az account set --subscription <replace with your subscription name or id>

# Modify for your environment
export resourceGroupName=packer-rg-$environmentID
export servicePrincipleName=packer-sp-$environmentID
export location=australiaeast
export packerImageName=PackerImage$environmentID

# Create a resource group if it does not exist
if [ $(az group exists --name $resourceGroupName) = false ]
then
  echo "Create resource group $resourceGroupName ..."
  az group create \
  --name $resourceGroupName \
  --location $location
fi

# Create a service principal

echo "Creating service principal $servicePrincipleName ..."
export CLIENT_SECRET=$(az ad sp create-for-rbac --name http://$servicePrincipleName --query password --output tsv)
export CLIENT_ID=$(az ad sp show --id http://$servicePrincipleName --query appId --output tsv)
export TENANT_ID=$(az ad sp show --id http://$servicePrincipleName --query appOwnerTenantId --output tsv)
export SUBSCRIPTION_ID=$(az account show --query id --output tsv)

# Wait 15 seconds to make sure that service principal has propagated
echo "Waiting for service principal to propagate ..."
sleep 15

echo "environmentID: $environmentID"
echo "resourceGroupName: $resourceGroupName"
echo "servicePrincipleName: $servicePrincipleName"
echo "packerImageName: $packerImageName"
echo "CLIENT_ID: $CLIENT_ID"
echo "CLIENT_SECRET: $CLIENT_SECRET"
echo "TENANT_ID: $TENANT_ID"
echo "SUBSCRIPTION_ID: $SUBSCRIPTION_ID"

# Build Packer image
echo "Build Packer image $packerImageName ..."
packer build packer.json

# Create VM from Azure Image
export vmName=packer-vm-$environmentID
az vm create \
    --resource-group $resourceGroupName \
    --name $vmName \
    --image $packerImageName \
    --admin-username azureuser \
    --generate-ssh-keys