@description('Environment location.')
param location string = resourceGroup().location

param namePrefix string

var name = '${namePrefix}${uniqueString(resourceGroup().id)}'

resource key_vault 'Microsoft.KeyVault/vaults@2019-09-01' = {
  name: name
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }    
    tenantId: subscription().tenantId
    accessPolicies: []
  }
}

