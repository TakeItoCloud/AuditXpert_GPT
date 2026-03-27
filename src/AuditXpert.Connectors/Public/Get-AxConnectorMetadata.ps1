function Get-AxConnectorMetadata {
    [CmdletBinding()]
    param(
        [Parameter()]
        [ValidateSet('MicrosoftGraph', 'ExchangeOnline', 'Azure', 'HybridLocal')]
        [string]$Name
    )

    Get-AxConnectorDefinition -Name $Name
}
