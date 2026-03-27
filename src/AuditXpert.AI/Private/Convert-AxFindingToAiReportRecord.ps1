function Convert-AxFindingToAiReportRecord {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [psobject]$Finding,

        [Parameter()]
        [psobject[]]$RelatedRisk = @()
    )

    $severityDefinition = Get-AxAiSeverityDefinition -Severity ([string]$Finding.Severity)
    $owner = @($RelatedRisk | Select-Object -ExpandProperty RecommendedOwner -Unique | Where-Object { $_ }) -join ', '
    $priority = @($RelatedRisk | Select-Object -ExpandProperty Priority -Unique | Where-Object { $_ }) -join ', '

    [pscustomobject]@{
        finding_id              = [string]$Finding.FindingId
        title                   = [string]$Finding.Title
        severity                = [string]$severityDefinition.label
        service                 = [string]$Finding.Service
        category                = [string]$Finding.Category
        affected_scope          = [string]$Finding.Scope
        issue_summary           = [string]$Finding.Description
        evidence                = @($Finding.Evidence)
        evidence_summary        = Get-AxAiEvidenceSummary -Finding $Finding
        recommendation          = [string]$Finding.Recommendation
        business_impact         = if ($Finding.Impact) { "Impact rating: $($Finding.Impact). $($severityDefinition.businessImpact)" } else { [string]$severityDefinition.businessImpact }
        technical_impact        = "Risk score: $($Finding.RiskScore). Likelihood: $($Finding.Likelihood)."
        control_mapping         = Get-AxAiControlMappingSummary -Finding $Finding -RelatedRisk $RelatedRisk
        remediation_priority    = if ([string]::IsNullOrWhiteSpace($priority)) { [string]$severityDefinition.priority } else { $priority }
        implementation_guidance = "Implement through a controlled change plan and validate closure against the affected scope."
        owner                   = if ([string]::IsNullOrWhiteSpace($owner)) { $null } else { $owner }
        effort                  = $null
        traceability            = [string]$Finding.FindingId
    }
}
