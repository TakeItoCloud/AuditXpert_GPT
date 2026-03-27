function Get-AxRiskRegisterMarkdown {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [psobject[]]$RiskRegister
    )

    $lines = @(
        '# Risk Register Summary',
        '',
        '| Risk Title | Priority | Recommended Owner | Related Findings |',
        '|---|---|---|---|'
    )

    foreach ($risk in $RiskRegister) {
        $lines += "| $($risk.RiskTitle) | $($risk.Priority) | $($risk.RecommendedOwner) | $(@($risk.RelatedFindings) -join ', ') |"
    }

    $lines -join [Environment]::NewLine
}
