function Connect-AxMicrosoftGraph {
    [CmdletBinding()]
    param(
        [Parameter()]
        [ValidateSet('Delegated', 'AppOnly')]
        [string]$AuthMethod = 'Delegated',

        [Parameter()]
        [string]$TenantId,

        [Parameter()]
        [string[]]$Scopes = @('Directory.Read.All')
    )

    $access = Test-AxConnectorAccess -Connector 'MicrosoftGraph' -AuthMethod $AuthMethod -Detailed
    if ($access.Status -ne 'Ready') {
        return New-AxConnectorSessionObject -Connector 'MicrosoftGraph' -AuthMethod $AuthMethod -State 'Unavailable' -Context @{
            TenantId = $TenantId
            Scopes   = $Scopes
        } -Diagnostics @{
            Message = $access.Message
            Modules = $access.ModuleDependencyCheck
        }
    }

    Write-AxConnectorLog -Level Information -Component 'Connectors.Graph' -Message 'Initialized Microsoft Graph connector session.' -Data @{
        TenantId = $TenantId
        Scopes   = ($Scopes -join ',')
    } | Out-Null

    New-AxConnectorSessionObject -Connector 'MicrosoftGraph' -AuthMethod $AuthMethod -State 'Connected' -Context @{
        TenantId = $TenantId
        Scopes   = $Scopes
        Mode     = 'Stub'
    } -Diagnostics @{
        Message = 'Graph connector initialized in stub mode for connectivity validation.'
    }
}
