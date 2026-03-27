function Get-AxAiPromptSections {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [psobject[]]$MappedFinding,

        [Parameter(Mandatory)]
        [psobject[]]$SectionPlan,

        [Parameter()]
        [psobject[]]$RiskRegister = @(),

        [Parameter()]
        [psobject[]]$Scorecard = @()
    )

    $topFindings = $MappedFinding | Select-Object -First 5

    foreach ($section in $SectionPlan | Where-Object { $_.AIControlled }) {
        $sectionRecords = switch ($section.SectionKey) {
            'executive_summary' { $topFindings }
            'risk_overview' { $MappedFinding | Group-Object severity | Sort-Object Name }
            'key_findings' { $topFindings }
            'recommendations' { $topFindings | Select-Object finding_id, title, recommendation, remediation_priority, owner }
            'remediation_roadmap' { $topFindings | Select-Object finding_id, title, remediation_priority, owner, effort, recommendation }
            'compliance_control_mapping' { $topFindings | Select-Object finding_id, title, control_mapping, traceability }
            'service_specific_detail' { $MappedFinding | Group-Object service | Sort-Object Name }
            'evidence_appendix' { $topFindings | Select-Object finding_id, affected_scope, evidence_summary, traceability }
            default { @() }
        }

        [pscustomobject]@{
            SectionKey    = $section.SectionKey
            SectionTitle  = $section.SectionTitle
            Instructions  = $section.Instructions
            Records       = @($sectionRecords)
            RiskRegister  = if ($section.SectionKey -in @('executive_summary', 'risk_overview', 'compliance_control_mapping')) { $RiskRegister } else { @() }
            Scorecard     = if ($section.SectionKey -in @('executive_summary', 'risk_overview', 'compliance_control_mapping')) { $Scorecard } else { @() }
        }
    }
}
