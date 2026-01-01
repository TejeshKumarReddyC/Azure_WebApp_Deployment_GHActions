param location string
param appName string

resource plan
'Microsoft.Web/serverfarms@2022-09-01' = {
    name: '${appName}-plan'
    location: location
    sku: {
        name: 'B1'
        tier: 'Basic'
    }
    properties: {
        reserved: true
    }
}

resource webApp
'Microsoft.Web/serverfarms@2022-09-01' = {
    name: '${appName}-plan'
    location: location
    properties: {
        serverFarmId: plan.id
        siteConfig: {
            linuxFxVersion: 'NODE|18-lts'
        }
    }
}

output webAppUrl string = 'https://${webApp.properties.defaultHostName}'
