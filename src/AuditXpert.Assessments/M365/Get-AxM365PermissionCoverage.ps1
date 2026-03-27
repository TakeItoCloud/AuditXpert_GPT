function Get-AxM365PermissionCoverage {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [hashtable]$Context,

        [Parameter(Mandatory)]
        [string]$ServiceArea
    )

    $permissions = Get-AxM365ContextDataset -Context $Context -Name 'Permissions'
    if (-not $permissions) {
        return 'Unknown'
    }

    if ($permissions -is [hashtable]) {
        return ($permissions[$ServiceArea] ?? 'Unknown')
    }

    return ($permissions.$ServiceArea ?? 'Unknown')
}
