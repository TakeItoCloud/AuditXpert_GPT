function Connect-AxHybridLocal {
    [CmdletBinding()]
    param(
        [Parameter()]
        [ValidateSet('Integrated', 'RunAs')]
        [string]$AuthMethod = 'Integrated',

        [Parameter()]
        [string]$ComputerName = $env:COMPUTERNAME
    )

    $access = Test-AxConnectorAccess -Connector 'HybridLocal' -AuthMethod $AuthMethod -Detailed
    if ($access.Status -ne 'Ready' -and $AuthMethod -eq 'RunAs') {
        return New-AxConnectorSessionObject -Connector 'HybridLocal' -AuthMethod $AuthMethod -State 'Unavailable' -Context @{
            ComputerName = $ComputerName
        } -Diagnostics @{
            Message = $access.Message
            Modules = $access.ModuleDependencyCheck
        }
    }

    Write-AxConnectorLog -Level Information -Component 'Connectors.HybridLocal' -Message 'Initialized hybrid local connector session.' -Data @{
        ComputerName = $ComputerName
    } | Out-Null

    New-AxConnectorSessionObject -Connector 'HybridLocal' -AuthMethod $AuthMethod -State 'Connected' -Context @{
        ComputerName = $ComputerName
        Mode         = 'Stub'
    } -Diagnostics @{
        Message = 'Hybrid local connector initialized in stub mode for connectivity validation.'
    }
}
