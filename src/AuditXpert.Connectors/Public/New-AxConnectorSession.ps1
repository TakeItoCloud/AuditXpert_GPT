function New-AxConnectorSession {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateSet('MicrosoftGraph', 'ExchangeOnline', 'Azure', 'HybridLocal')]
        [string]$Connector,

        [Parameter(Mandatory)]
        [string]$AuthMethod,

        [Parameter()]
        [hashtable]$Context = @{}
    )

    $definition = Get-AxConnectorDefinition -Name $Connector

    if ($definition.AuthMethods -notcontains $AuthMethod) {
        throw "Auth method '$AuthMethod' is not supported for connector '$Connector'."
    }

    New-AxConnectorSessionObject -Connector $Connector -AuthMethod $AuthMethod -State 'Initialized' -Context $Context
}
