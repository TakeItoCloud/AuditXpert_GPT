function Connect-AxAzure {
    [CmdletBinding()]
    param(
        [Parameter()]
        [ValidateSet('Delegated', 'ServicePrincipal')]
        [string]$AuthMethod = 'Delegated',

        [Parameter()]
        [string]$SubscriptionId,

        [Parameter()]
        [string]$TenantId
    )

    $access = Test-AxConnectorAccess -Connector 'Azure' -AuthMethod $AuthMethod -Detailed
    if ($access.Status -ne 'Ready') {
        return New-AxConnectorSessionObject -Connector 'Azure' -AuthMethod $AuthMethod -State 'Unavailable' -Context @{
            SubscriptionId = $SubscriptionId
            TenantId       = $TenantId
        } -Diagnostics @{
            Message = $access.Message
            Modules = $access.ModuleDependencyCheck
        }
    }

    Write-AxConnectorLog -Level Information -Component 'Connectors.Azure' -Message 'Initialized Azure connector session.' -Data @{
        SubscriptionId = $SubscriptionId
        TenantId       = $TenantId
    } | Out-Null

    New-AxConnectorSessionObject -Connector 'Azure' -AuthMethod $AuthMethod -State 'Connected' -Context @{
        SubscriptionId = $SubscriptionId
        TenantId       = $TenantId
        Mode           = 'Stub'
    } -Diagnostics @{
        Message = 'Azure connector initialized in stub mode for connectivity validation.'
    }
}
