function Connect-AxExchangeOnline {
    [CmdletBinding()]
    param(
        [Parameter()]
        [ValidateSet('Delegated', 'AppOnly')]
        [string]$AuthMethod = 'Delegated',

        [Parameter()]
        [string]$Organization
    )

    $access = Test-AxConnectorAccess -Connector 'ExchangeOnline' -AuthMethod $AuthMethod -Detailed
    if ($access.Status -ne 'Ready') {
        return New-AxConnectorSessionObject -Connector 'ExchangeOnline' -AuthMethod $AuthMethod -State 'Unavailable' -Context @{
            Organization = $Organization
        } -Diagnostics @{
            Message = $access.Message
            Modules = $access.ModuleDependencyCheck
        }
    }

    Write-AxConnectorLog -Level Information -Component 'Connectors.ExchangeOnline' -Message 'Initialized Exchange Online connector session.' -Data @{
        Organization = $Organization
    } | Out-Null

    New-AxConnectorSessionObject -Connector 'ExchangeOnline' -AuthMethod $AuthMethod -State 'Connected' -Context @{
        Organization = $Organization
        Mode         = 'Stub'
    } -Diagnostics @{
        Message = 'Exchange Online connector initialized in stub mode for connectivity validation.'
    }
}
