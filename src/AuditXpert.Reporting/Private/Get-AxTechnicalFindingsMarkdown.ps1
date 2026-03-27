function Get-AxTechnicalFindingsMarkdown {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [psobject[]]$Finding
    )

    $lines = @('# Technical Findings Report', '')
    foreach ($item in $Finding) {
        $lines += "## $($item.Title)"
        $lines += "Finding ID: $($item.FindingId)"
        $lines += "Service: $($item.Service)"
        $lines += "Severity: $($item.Severity)"
        $lines += "Description: $($item.Description)"
        $lines += "Recommendation: $($item.Recommendation)"
        $lines += "Traceability: $($item.FindingId)"
        $lines += ''
    }

    $lines -join [Environment]::NewLine
}
