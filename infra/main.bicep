targetScope = 'subscription'
param rgName string = 'webapp-rg'
param location string = 'eastus'
param appName string

resource rg
'Microsoft.Resources/resourceGroups@2022-09-01' = {
    name: rgName
    location: location
}

module webApp './webapp.bicep'= {
    name: 'webAppDeployment'
    scope: rg
    params: {
        location: location
        appName: appName
    }
}
