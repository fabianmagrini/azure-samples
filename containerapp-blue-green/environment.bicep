@description('The location for the Environment.')
param location string

@description('The name of the Environment.')
param name string

@description('Log Analytics Workspace ClientId.')
param logAnalyticsClientId string

@description('Log Analytics Workspace ClientSecret.')
param logAnalyticsClientSecret string

@description('The tags to apply to the Environment.')
param resourceTags object = {}

resource env 'Microsoft.App/managedEnvironments@2022-01-01-preview' = {
  name: name
  location: location
  tags: resourceTags
  properties: {
    type: 'managed'
    appLogsConfiguration: {
      destination: 'log-analytics'
      logAnalyticsConfiguration: {
        customerId: logAnalyticsClientId
        sharedKey: logAnalyticsClientSecret
      }
    }
  }
}
output id string = env.id
