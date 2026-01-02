targetScope = 'subscription'

param location string = 'eastus'
param rgName string
param adminUsername string
@secure()
param adminPassword string

// Resource Group (subscription scope)
resource rg 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: rgName
  location: location
}

// VNet (scoped to RG)
resource vnet 'Microsoft.Network/virtualNetworks@2023-05-01' = {
  name: 'vm-vnet'
  scope: rg
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: ['10.0.0.0/16']
    }
    subnets: [
      {
        name: 'default'
        properties: {
          addressPrefix: '10.0.1.0/24'
        }
      }
    ]
  }
}

// NIC
resource nic 'Microsoft.Network/networkInterfaces@2023-05-01' = {
  name: 'vm-nic'
  scope: rg
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: vnet.properties.subnets[0].id
          }
          privateIPAllocationMethod: 'Dynamic'
        }
      }
    ]
  }
}

// VM
resource vm 'Microsoft.Compute/virtualMachines@2023-03-01' = {
  name: 'demo-vm'
  scope: rg
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B1s'
    }
    osProfile: {
      computerName: 'demo-vm'
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: '0001-com-ubuntu-server-jammy'
        sku: '22_04-lts'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
        }
      ]
    }
  }
}

// VM Extension (child resource)
resource webInstall 'Microsoft.Compute/virtualMachines/extensions@2023-03-01' = {
  name: 'customScript'
  parent: vm
  properties: {
    publisher: 'Microsoft.Azure.Extensions'
    type: 'CustomScript'
    typeHandlerVersion: '2.1'
    autoUpgradeMinorVersion: true
    settings: {
      commandToExecute: '''
        sudo apt-get update
        sudo apt-get install -y nginx
        sudo systemctl enable nginx
        sudo systemctl start nginx
      '''
    }
  }
}
