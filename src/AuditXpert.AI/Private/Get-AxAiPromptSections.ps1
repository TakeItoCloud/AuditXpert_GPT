function Get-AxAiPromptSections {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [psobject[]]$Finding,

        [Parameter()]
        [psobject[]]$RiskRegister = @(),

        [Parameter()]
        [psobject[]]$Scorecard = @()
    )

    $topFindings = $Finding | Sort-Object RiskScore -Descending | Select-Object -First 5

    [pscustomobject]@{
        ExecutiveFocus = @(
            'Summarize business-facing risk themes without presenting AI prose as evidence.',
            'Reference finding IDs for every major narrative statement.'
        )
        TopFindings = @($topFindings | ForEach-Object {
            [pscustomobject]@{
                FindingId      = $_.FindingId
                Title          = $_.Title
                Severity       = $_.Severity
                Recommendation = $_.Recommendation
            }
        })
        RiskRegister = $RiskRegister
        Scorecard    = $Scorecard
    }
}
