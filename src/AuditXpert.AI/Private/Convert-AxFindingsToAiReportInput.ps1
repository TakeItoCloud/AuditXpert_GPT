function Convert-AxFindingsToAiReportInput {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [psobject[]]$Finding,

        [Parameter()]
        [psobject[]]$RiskRegister = @()
    )

    $riskLookup = Get-AxAiRiskRegisterLookup -RiskRegister $RiskRegister

    foreach ($item in $Finding) {
        $relatedRisk = if ($riskLookup.ContainsKey($item.FindingId)) { @($riskLookup[$item.FindingId]) } else { @() }
        Convert-AxFindingToAiReportRecord -Finding $item -RelatedRisk $relatedRisk
    }
}
