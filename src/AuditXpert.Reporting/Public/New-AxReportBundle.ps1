function New-AxReportBundle {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [psobject[]]$Finding,

        [Parameter()]
        [psobject[]]$RiskRegister = @(),

        [Parameter()]
        [psobject[]]$Scorecard = @()
    )

    $executive = Get-AxExecutiveSummaryMarkdown -Finding $Finding -RiskRegister $RiskRegister -Scorecard $Scorecard
    $technical = Get-AxTechnicalFindingsMarkdown -Finding $Finding
    $riskSummary = Get-AxRiskRegisterMarkdown -RiskRegister $RiskRegister
    $appendix = Get-AxServiceAppendixMarkdown -Finding $Finding

    [pscustomobject]@{
        ExecutiveSummary     = $executive
        TechnicalFindings    = $technical
        RiskRegisterSummary  = $riskSummary
        ServiceAppendix      = $appendix
        ExecutiveSummaryHtml = Convert-AxMarkdownToSimpleHtml -Markdown $executive
        TechnicalFindingsHtml = Convert-AxMarkdownToSimpleHtml -Markdown $technical
    }
}
