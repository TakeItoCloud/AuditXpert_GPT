function Get-AxRiskRegisterMarkdown {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [psobject[]]$RiskRegister
    )

    $template = Get-AxReportTemplate -TemplateName 'governance-vciso'
    $lines = @(
        "# $($template.reportTitle)",
        '',
        "## $(Get-AxTemplateSectionTitle -SectionKey 'report_title_and_metadata')",
        "- Output name: $($template.outputBaseName)",
        "- Audience: $($template.audience)",
        '',
        "## $(Get-AxTemplateSectionTitle -SectionKey 'scope')",
        "- Governance summary generated from normalized risk register rows.",
        '',
        "## $(Get-AxTemplateSectionTitle -SectionKey 'methodology')",
        '- Risk records are derived from normalized findings and governance mapping outputs.',
        '',
        "## $(Get-AxTemplateSectionTitle -SectionKey 'executive_summary')",
        "Total risk register items: $($RiskRegister.Count)",
        '',
        "## $(Get-AxTemplateSectionTitle -SectionKey 'risk_overview')"
    )

    foreach ($priorityGroup in ($RiskRegister | Group-Object Priority | Sort-Object Name)) {
        $lines += "- $($priorityGroup.Name): $($priorityGroup.Count) risk item(s)"
    }

    $lines += ''
    $lines += '## Risk Register Summary'
    $lines += ''
    $lines += '| Risk Title | Priority | Recommended Owner | Related Findings | Related Control Domains |'
    $lines += '|---|---|---|---|---|'

    foreach ($risk in $RiskRegister) {
        $controlDomains = @($risk.RelatedControlDomains) -join ', '
        if ([string]::IsNullOrWhiteSpace($controlDomains)) {
            $controlDomains = 'Not mapped in current dataset'
        }

        $lines += "| $($risk.RiskTitle) | $($risk.Priority) | $($risk.RecommendedOwner) | $(@($risk.RelatedFindings) -join ', ') | $controlDomains |"
    }

    $lines += ''
    $lines += "## $(Get-AxTemplateSectionTitle -SectionKey 'recommendations')"
    foreach ($risk in ($RiskRegister | Select-Object -First 5)) {
        $lines += "- $($risk.RiskTitle): assign $($risk.RecommendedOwner) and track remediation against priority $($risk.Priority)."
    }

    $lines += ''
    $lines += "## $(Get-AxTemplateSectionTitle -SectionKey 'compliance_control_mapping')"
    foreach ($risk in ($RiskRegister | Select-Object -First 5)) {
        $controlDomains = @($risk.RelatedControlDomains)
        if ($controlDomains.Count -gt 0) {
            $lines += "- $($risk.RiskTitle): $($controlDomains -join ', ')"
        }
    }

    $lines += ''
    $lines += "## $(Get-AxTemplateSectionTitle -SectionKey 'evidence_appendix')"
    $lines += '- Governance content should be cross-referenced to the related finding IDs and underlying technical report sections.'
    $lines -join [Environment]::NewLine
}
