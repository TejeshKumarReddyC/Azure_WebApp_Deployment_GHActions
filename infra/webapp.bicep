
targetScope = 'resourceGroup'

@description('Azure region for the plan and site')
param location string

@description('Web app name (must be globally unique for *.azurewebsites.net)')
param appName string

// App Service Plan (Linux)
resource plan 'Microsoft.Web/serverfarms@2023-12-01' = {
  name: '${appName}-plan'
  location: location
  kind: 'linux'
  sku: {
    name: 'B1'         // choose F1, B1, S1, P1v3, etc.
    tier: 'Basic'      // optional; many samples just set name
  }
  properties: {
    reserved: true     // Linux
  }
}

// Web App
resource webApp 'Microsoft.Web/sites@2023-12-01' = {
  name: appName
  location: location
  properties: {
    serverFarmId: plan.id
    httpsOnly: true
    siteConfig: {
      linuxFxVersion: 'node|18-lts'   // runtime stack
    }
  }
}

// Output the default hostname (e.g., my-webapp.azurewebsites.net)
output webAppUrl string = 'https://${webApp.properties.defaultHostName}'
