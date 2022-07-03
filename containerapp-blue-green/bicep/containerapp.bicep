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

@description('Registry.')
param registry string

@description('Registry username.')
param registryUsername string

@secure()
@description('Registry password.')
param registryPassword string

@description('Environment variables.')
param envVars array = []

resource containerApp 'Microsoft.App/containerApps@2022-01-01-preview' = {
  name: name
  kind: 'containerapp'
  location: location
  tags: resourceTags
  properties: {
    managedEnvironmentId: containerAppEnvironmentId
    configuration: {
      activeRevisionsMode: 'multiple'
      secrets: [
          {
              name: 'container-registry-password'
              value: registryPassword
          }
      ]
      ingress: {
        external: useExternalIngress
        targetPort: containerPort
      }
      registries: [
        {
            server: registry
            username: registryUsername
            passwordSecretRef: 'container-registry-password'
        }
      ]
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
        maxReplicas: 1
      }
    }
  }
}

output fqdn string = containerApp.properties.configuration.ingress.fqdn
