function Get-AxReportScopeSummary {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [psobject[]]$Finding
    )

    $services = @($Finding | Select-Object -ExpandProperty Service -Unique | Sort-Object)
    $scopes = @($Finding | Select-Object -ExpandProperty Scope -Unique | Sort-Object)

    [pscustomobject]@{
        ServiceSummary = if ($services.Count -gt 0) { $services -join ', ' } else { 'No services provided' }
        ScopeSummary   = if ($scopes.Count -gt 0) { $scopes -join '; ' } else { 'No scope data provided' }
    }
}
