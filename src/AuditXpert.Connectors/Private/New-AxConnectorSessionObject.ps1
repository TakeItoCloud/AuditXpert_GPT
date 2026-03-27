function New-AxConnectorSessionObject {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Connector,

        [Parameter(Mandatory)]
        [string]$AuthMethod,

        [Parameter(Mandatory)]
        [ValidateSet('Initialized', 'Connected', 'Disconnected', 'Unavailable')]
        [string]$State,

        [Parameter()]
        [hashtable]$Context = @{},

        [Parameter()]
        [hashtable]$Diagnostics = @{}
    )

    [pscustomobject]@{
        PSTypeName  = 'AuditXpert.ConnectorSession'
        Connector   = $Connector
        AuthMethod  = $AuthMethod
        State       = $State
        CreatedAt   = (Get-Date).ToString('o')
        Context     = $Context
        Diagnostics = $Diagnostics
    }
}
