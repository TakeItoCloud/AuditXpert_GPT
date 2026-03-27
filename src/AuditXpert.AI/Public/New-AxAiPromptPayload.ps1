function New-AxAiPromptPayload {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [psobject[]]$Finding,

        [Parameter()]
        [psobject[]]$RiskRegister = @(),

        [Parameter()]
        [psobject[]]$Scorecard = @(),

        [Parameter()]
        [ValidateSet(
            'executive-summary',
            'technical-assessment',
            'governance-vciso',
            'azure-assessment',
            'microsoft365-assessment',
            'hybrid-infrastructure',
            'remediation-roadmap',
            'service-specific-appendix'
        )]
        [string]$ReportType = 'executive-summary',

        [Parameter()]
        [switch]$DisableAI
    )

    $mappedFindings = Convert-AxFindingsToAiReportInput -Finding $Finding -RiskRegister $RiskRegister
    $mappingValidation = Test-AxAiMappedRecordSet -MappedFinding $mappedFindings
    if (-not $mappingValidation.Valid) {
        throw ($mappingValidation.Issues -join ' ')
    }

    $reportTemplateName = if ($ReportType -eq 'service-specific-appendix') { 'technical-assessment' } else { $ReportType }
    $reportTemplate = Get-AxReportingTemplate -TemplateName $reportTemplateName -Category 'reports'
    $promptTemplate = Get-AxAiPromptTemplate -TemplateName $ReportType -Category 'reports'
    $rules = Get-AxAiPromptTemplate -TemplateName 'prompt_rules' -Category 'shared'
    $sectionPlan = Get-AxAiSectionPlan -ReportTemplate $reportTemplate -PromptTemplate $promptTemplate
    $sectionValidation = Test-AxAiSectionPlan -ReportTemplate $reportTemplate -PromptTemplate $promptTemplate
    if (-not $sectionValidation.Valid) {
        throw ($sectionValidation.Issues -join ' ')
    }

    $sections = Get-AxAiPromptSections -MappedFinding $mappedFindings -SectionPlan $sectionPlan -RiskRegister $RiskRegister -Scorecard $Scorecard

    $systemPromptLines = @(
        "Report type: $ReportType",
        "Audience: $($promptTemplate.audience)",
        "Tone: $($promptTemplate.tone)"
    ) + @($rules.globalRules) + @(
        $rules.sharedFragments.severityWordRule,
        $rules.sharedFragments.businessImpactRule,
        $rules.sharedFragments.technicalImpactRule,
        $rules.sharedFragments.remediationRule,
        $rules.sharedFragments.evidenceRule,
        $rules.sharedFragments.controlMappingRule,
        $rules.sharedFragments.sectionGuardrailRule
    )

    [pscustomobject]@{
        Enabled      = (-not $DisableAI)
        Label        = if ($DisableAI) { 'AI disabled' } else { 'AI-assisted content requires review' }
        ReportType   = $ReportType
        SystemPrompt = ($systemPromptLines -join [Environment]::NewLine)
        UserPayload  = [pscustomobject]@{
            TraceabilityRequirement = 'Every major statement must cite one or more finding_id values from the mapped records.'
            RawEvidencePolicy       = 'Do not restate raw evidence as AI certainty; evidence stays in controlled report sections and mapped evidence summaries.'
            Findings                = $Finding
            MappedFindings          = $mappedFindings
            RiskRegister            = $RiskRegister
            Scorecard               = $Scorecard
            ReportTemplate          = $reportTemplate
            PromptTemplate          = $promptTemplate
            SectionPlan             = $sectionPlan
            Sections                = $sections
            Validation              = [pscustomobject]@{
                MappedFindingsValid = $mappingValidation.Valid
                SectionPlanValid    = $sectionValidation.Valid
                Issues              = @($mappingValidation.Issues + $sectionValidation.Issues)
            }
        }
    }
}
