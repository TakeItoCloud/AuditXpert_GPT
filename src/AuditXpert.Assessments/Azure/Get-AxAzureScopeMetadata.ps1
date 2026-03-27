function Get-AxAzureScopeMetadata {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [hashtable]$Context
    )

    $scopeType = $Context.ScopeType ?? 'Subscription'
    $scopeName = $Context.Scope ?? 'DefaultScope'
    $resourceType = $Context.ResourceType ?? 'All'

    [pscustomobject]@{
        ScopeType    = $scopeType
        Scope        = $scopeName
        ResourceType = $resourceType
    }
}
