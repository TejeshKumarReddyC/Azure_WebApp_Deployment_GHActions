targetScope = 'subscription'

param location string = 'eastus'
param rgName string
param adminUsername string
@secure()
param adminPassword string

// Resource Group
resource rg 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: rgName
  location: location
}

// VM Module (RG scoped)
module vmModule './vm/vm.bicep' = {
  name: 'vmDeployment'
  scope: rg
  params: {
    location: location
    adminUsername: adminUsername
    adminPassword: adminPassword
  }
}
