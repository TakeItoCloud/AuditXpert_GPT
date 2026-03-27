function Convert-AxFindingSetToMarkdown {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [psobject[]]$Finding
    )

    $lines = @(
        '# AuditXpert Findings'
        ''
        '| FindingId | Service | Severity | RiskScore | Title |'
        '|---|---|---|---:|---|'
    )

    foreach ($item in $Finding) {
        $lines += "| $($item.FindingId) | $($item.Service) | $($item.Severity) | $($item.RiskScore) | $($item.Title) |"
    }

    $lines -join [Environment]::NewLine
}
