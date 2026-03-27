function Convert-AxReportDataToServiceAppendix {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [psobject[]]$Finding
    )

    $groups = $Finding | Group-Object Service
    foreach ($group in $groups) {
        [pscustomobject]@{
            Service  = $group.Name
            Findings = @($group.Group)
        }
    }
}
