function Get-AxTechnicalFindingsMarkdown {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [psobject[]]$Finding
    )

    $template = Get-AxReportTemplate -TemplateName 'technical-assessment'
    $scope = Get-AxReportScopeSummary -Finding $Finding
    $lines = @(
        "# $($template.reportTitle)",
        '',
        "## $(Get-AxTemplateSectionTitle -SectionKey 'report_title_and_metadata')",
        "- Output name: $($template.outputBaseName)",
        "- Audience: $($template.audience)",
        '',
        "## $(Get-AxTemplateSectionTitle -SectionKey 'scope')",
        "- Services: $($scope.ServiceSummary)",
        "- Scope references: $($scope.ScopeSummary)",
        '',
        "## $(Get-AxTemplateSectionTitle -SectionKey 'methodology')",
        '- Findings are rendered from the normalized findings schema.',
        '- Controlled severity, remediation, and traceability wording is applied by the reporting layer.',
        '',
        "## $(Get-AxTemplateSectionTitle -SectionKey 'risk_overview')"
    )

    $severityGroups = $Finding |
        Group-Object { (Get-AxSeverityDefinition -Severity ([string]$_.Severity)).label } |
        Sort-Object Name

    foreach ($group in $severityGroups) {
        $severityDefinition = Get-AxSeverityDefinition -Severity ([string]$group.Name)
        $lines += "- $($severityDefinition.label): $($group.Count) finding(s), priority $($severityDefinition.priority)"
    }

    $lines += ''
    $lines += "## $(Get-AxTemplateSectionTitle -SectionKey 'key_findings')"
    foreach ($item in $Finding) {
        $severityDefinition = Get-AxSeverityDefinition -Severity ([string]$item.Severity)
        $lines += "### $($item.Title)"
        $lines += "Finding ID: $($item.FindingId)"
        $lines += "Severity: $($severityDefinition.label)"
        $lines += "Affected scope: $($item.Scope)"
        $lines += "Service: $($item.Service)"
        $lines += "Issue summary: $($item.Description)"
        $lines += "Business impact: $(Get-AxFindingBusinessImpact -Finding $item)"
        $lines += "Technical impact: $(Get-AxFindingTechnicalImpact -Finding $item)"
        $lines += "Evidence summary: $(Get-AxFindingEvidenceSummary -Finding $item)"
        $lines += "Recommendation: $($item.Recommendation)"
        $lines += "Implementation guidance: $(Get-AxImplementationGuidance -Finding $item)"
        $lines += "Framework/control mapping: $(Get-AxFindingFrameworkSummary -Finding $item)"
        $lines += "Traceability: $($item.FindingId)"
        $lines += ''
    }

    $lines += "## $(Get-AxTemplateSectionTitle -SectionKey 'recommendations')"
    foreach ($item in ($Finding | Sort-Object RiskScore -Descending | Select-Object -First 5)) {
        $severityDefinition = Get-AxSeverityDefinition -Severity ([string]$item.Severity)
        $lines += "- [$($item.FindingId)] Priority $($severityDefinition.priority): $($item.Recommendation)"
    }

    $lines += ''
    $lines += "## $(Get-AxTemplateSectionTitle -SectionKey 'service_specific_detail')"
    foreach ($group in ($Finding | Group-Object Service | Sort-Object Name)) {
        $lines += "- $($group.Name): $($group.Count) finding(s)"
    }

    $lines += ''
    $lines += "## $(Get-AxTemplateSectionTitle -SectionKey 'evidence_appendix')"
    $lines += '- Evidence summaries above are condensed from the finding evidence payload and should be cross-referenced with raw evidence artifacts where available.'

    $lines -join [Environment]::NewLine
}
