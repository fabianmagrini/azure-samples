@description('The location for the Container App.')
param location string

@description('The name of the Container App.')
param name string

@description('The Environment Id for the Container App.')
param containerAppEnvironmentId string

@description('The tags to apply to the Container App.')
param resourceTags object = {}

@description('The Container Image ref for the Container App.')
param containerImage string

@description('Expose the Container App externally.')
param useExternalIngress bool = false

@description('Port to run the Container App on.')
param containerPort int

@description('Environment variables.')
param envVars array = []

resource containerApp 'Microsoft.Web/containerApps@2021-03-01' = {
  name: name
  kind: 'containerapp'
  location: location
  tags: resourceTags
  properties: {
    kubeEnvironmentId: containerAppEnvironmentId
    configuration: {
      ingress: {
        external: useExternalIngress
        targetPort: containerPort
      }
    }
    template: {
      containers: [
        {
          image: containerImage
          name: name
          env: envVars
        }
      ]
      scale: {
        minReplicas: 0
      }
    }
  }
}

output fqdn string = containerApp.properties.configuration.ingress.fqdn
