@description('Log analytics workspace name.')
param name string

@description('The location for the Log analytics workspace.')
param location string = resourceGroup().location

@description('The SKU of the workspace.')
param sku string = 'PerGB2018'

@description('The workspace data retention in days.')
@minValue(30)
@maxValue(730)
param retentionDays int = 90

@description('The tags to apply to the Log analytics workspace.')
param resourceTags object = {}

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2021-06-01' = {
  name: name
  location: location
  tags: resourceTags
  properties: any({
    sku: {
      name: sku
    }
    retentionInDays: retentionDays
    features: {
      legacy: 0
      searchVersion: 1
      enableLogAccessUsingOnlyResourcePermissions: true
    }
    workspaceCapping: {
      dailyQuotaGb: -1
    }
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
  })
}

output id string = logAnalyticsWorkspace.id
output clientId string = logAnalyticsWorkspace.properties.customerId
output clientSecret string = logAnalyticsWorkspace.listKeys().primarySharedKey


