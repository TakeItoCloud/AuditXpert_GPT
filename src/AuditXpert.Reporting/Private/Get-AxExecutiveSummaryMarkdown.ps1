function Get-AxExecutiveSummaryMarkdown {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [psobject[]]$Finding,

        [Parameter()]
        [psobject[]]$RiskRegister = @(),

        [Parameter()]
        [psobject[]]$Scorecard = @()
    )

    $highRisk = @($Finding | Where-Object { $_.Severity -in @('High', 'Critical') }).Count
    $topDomains = @($Scorecard | Sort-Object Score | Select-Object -First 3)

    $lines = @(
        '# Executive Summary'
        ''
        "Total findings: $($Finding.Count)"
        "High or critical findings: $highRisk"
        "Risk register items: $($RiskRegister.Count)"
        ''
        '## Top Governance Domains'
    )

    foreach ($domain in $topDomains) {
        $lines += "- $($domain.Domain): score $($domain.Score), maturity $($domain.Maturity)"
    }

    $lines += ''
    $lines += '> AI-assisted narrative, if enabled later, must remain traceable to finding IDs and is not evidence.'
    $lines -join [Environment]::NewLine
}
