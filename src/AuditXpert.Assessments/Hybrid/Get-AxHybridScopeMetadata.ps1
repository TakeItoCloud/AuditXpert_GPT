function Get-AxHybridScopeMetadata {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [hashtable]$Context
    )

    [pscustomobject]@{
        ScopeType = $Context.ScopeType ?? 'Domain'
        Scope     = $Context.Scope ?? 'LabDomain'
        Mode      = $Context.Mode ?? 'LabFriendly'
    }
}
