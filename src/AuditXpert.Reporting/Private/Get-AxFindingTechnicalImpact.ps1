function Get-AxFindingTechnicalImpact {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [psobject]$Finding
    )

    $sourceSummary = if ($Finding.Source) {
        $connector = $Finding.Source.Connector
        $ruleId = $Finding.Source.RuleId
        "Observed through $connector using rule $ruleId."
    }
    else {
        'Source-system metadata not populated in the current finding payload.'
    }

    "$sourceSummary Risk score: $($Finding.RiskScore). Likelihood: $($Finding.Likelihood)."
}
