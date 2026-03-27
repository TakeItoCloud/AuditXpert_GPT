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
        ExecutiveSummary      = $executive
        TechnicalFindings     = $technical
        RiskRegisterSummary   = $riskSummary
        ServiceAppendix       = $appendix
        ExecutiveSummaryHtml  = Convert-AxMarkdownToSimpleHtml -Markdown $executive
        TechnicalFindingsHtml = Convert-AxMarkdownToSimpleHtml -Markdown $technical
        TemplateContracts     = @(
            (Get-AxReportTemplate -TemplateName 'executive-summary').reportId
            (Get-AxReportTemplate -TemplateName 'technical-assessment').reportId
            (Get-AxReportTemplate -TemplateName 'governance-vciso').reportId
        )
    }
}
