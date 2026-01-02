targetScope = 'subscription'

@description('Resource group name to create or use')
param rgName string = 'webapp-rg1'

@description('Azure region')
param location string = 'uksouth'

@description('Web app name (must be globally unique for *.azurewebsites.net)')
param appName string

// Create or ensure the resource group at subscription scope
resource rg 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: rgName
  location: location
}

// Deploy RG-scoped resources via a module
module webApp './webapp.bicep' = {
  name: 'webAppDeployment'
  scope: rg
  params: {
    location: location
    appName: appName
  }
}
