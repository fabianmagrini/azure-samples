# Using Azure KeyVault for Key Wrapping

Example of how to use Azure KeyVault for centralised Key Management to wrap and unwrap one-time symmetric keys for encrypting data.

References:

* <https://github.com/Azure/azure-sdk-for-net/tree/main/sdk/keyvault/Azure.Security.KeyVault.Keys>
* <https://docs.microsoft.com/en-us/azure/key-vault/keys/quick-create-net>

## Prerequisites

* Azure CLI
* az login
* brew install jq

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

## Test adding a key, secret, or certificate to the key vault

```sh
az keyvault key create --vault-name $keyVaultName --name "TestKey" --protection software
az keyvault secret set --vault-name $keyVaultName --name "TestKey" --value "TestKeyValue"
az keyvault key list --vault-name $keyVaultName

```

## Clean up deployment

```sh
./scripts/cleanup.sh

# delete resource group
resourceGroupName=<resource group name>
az group delete --name $resourceGroupName --yes --no-wait
```

## Azure Key Vault key client library for .NET

### Getting started

```sh
dotnet new console --framework net6.0
dotnet run
```

Install the Azure Key Vault keys client library for .NET with NuGet:

```sh
dotnet add package Azure.Security.KeyVault.Keys
```

Authenticate the client using Client secret credential authentication

```sh
dotnet add package Azure.Identity
```

Create/Get credentials

Create a service principal and configure its access to Azure resources

```sh
# Create a service principal and read in the application ID
SP=$(az ad sp create-for-rbac -n KeyWrap --output json)
SP_APP_ID=$(echo $SP | jq -r .appId)
SP_PASSWORD=$(echo $SP | jq -r .password)

# Wait 15 seconds to make sure that service principal has propagated
echo "Waiting for service principal to propagate..."
sleep 15

SP_ID=$(az ad sp show --id $SP_APP_ID --query id --output tsv)

export AZURE_CLIENT_ID=$(echo $SP | jq -r .appId)
export AZURE_CLIENT_SECRET=$(echo $SP | jq -r .password)
export AZURE_TENANT_ID=$(echo $SP | jq -r .tenant)

# Grant the application authorisation to perform key operations on the Azure Key Vault
az keyvault set-policy --name $keyVaultName --spn $AZURE_CLIENT_ID --key-permissions backup delete get list create encrypt decrypt update

# Retrieve Key Vault URL:
export keyVaultUrl=$(az keyvault show --name $keyVaultName --query properties.vaultUri --output tsv)

```

### Grant permissions to perform key operations on the Key Vault

```sh
az keyvault set-policy --name $keyVaultName --spn $AZURE_CLIENT_ID --key-permissions encrypt decrypt wrapKey unwrapKey sign verify get list create update import delete backup restore recover purge rotate getrotationpolicy setrotationpolicy release

```

### Run

```sh
dotnet run plaintext.txt ciphertext.txt
```
