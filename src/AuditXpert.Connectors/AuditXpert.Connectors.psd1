@{
    RootModule           = 'AuditXpert.Connectors.psm1'
    ModuleVersion        = '0.1.0'
    GUID                 = '82098205-dabc-4c2c-831f-6371296a2e83'
    Author               = 'AuditXpert_GPT'
    CompanyName          = 'AuditXpert_GPT'
    Copyright            = '(c) AuditXpert_GPT. All rights reserved.'
    Description          = 'Connector scaffolding for Microsoft cloud and hybrid data collection abstractions.'
    PowerShellVersion    = '7.0'
    CompatiblePSEditions = @('Core')
    FunctionsToExport    = @(
        'Get-AxConnectorMetadata',
        'New-AxConnectorSession',
        'Test-AxConnectorAccess',
        'Connect-AxMicrosoftGraph',
        'Disconnect-AxMicrosoftGraph',
        'Get-AxMicrosoftGraphStubData',
        'Connect-AxExchangeOnline',
        'Disconnect-AxExchangeOnline',
        'Get-AxExchangeOnlineStubData',
        'Connect-AxAzure',
        'Disconnect-AxAzure',
        'Get-AxAzureStubData',
        'Connect-AxHybridLocal',
        'Disconnect-AxHybridLocal',
        'Get-AxHybridLocalStubData',
        'Write-AxConnectorLog'
    )
    CmdletsToExport      = @()
    VariablesToExport    = @()
    AliasesToExport      = @()
}
