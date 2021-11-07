
@description('Environment location.')
param location string = resourceGroup().location

@description('Environment Name.')
param environmentName string

@description('Container App Name.')
param containerAppName string

@description('The tags to apply to the resources.')
param resourceTags object = {}

module logAnalytics 'loganalytics.bicep' = {
	name: 'log-analytics-workspace'
	params: {
      location: location
      name: 'law-${environmentName}'
      resourceTags: resourceTags
	}
}

module containerAppEnvironment 'environment.bicep' = {
  name: 'container-app-environment'
  params: {
    name: environmentName
    location: location
    logAnalyticsClientId: logAnalytics.outputs.clientId
    logAnalyticsClientSecret: logAnalytics.outputs.clientSecret
    resourceTags: resourceTags
  }
}

module containerApp 'containerapp.bicep' = {
  name: 'container-app'
  params: {
    name: containerAppName
    location: location
    containerAppEnvironmentId: containerAppEnvironment.outputs.id
    containerImage: 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'
    containerPort: 80
    envVars: [
        {
        name: 'ASPNETCORE_ENVIRONMENT'
        value: 'Production'
        }
    ]
    useExternalIngress: true
    resourceTags: resourceTags
  }
}

output fqdn string = containerApp.outputs.fqdn

