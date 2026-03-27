function Convert-AxFindingToRiskRecord {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [psobject]$Finding,

        [Parameter()]
        [object[]]$MappedControls = @()
    )

    process {
        [pscustomobject]@{
            RiskTitle            = $Finding.Title
            AffectedScope        = $Finding.Scope
            Severity             = $Finding.Severity
            Likelihood           = $Finding.Likelihood
            Impact               = $Finding.Impact
            Priority             = Get-AxRiskPriority -Severity $Finding.Severity -Likelihood $Finding.Likelihood -Impact $Finding.Impact
            RecommendedOwner     = Get-AxRecommendedOwner -Category $Finding.Category
            RemediationSummary   = $Finding.Recommendation
            RelatedFindings      = @($Finding.FindingId)
            RelatedControlDomains = @($MappedControls | ForEach-Object { $_.Domain })
            EvidenceReferences   = @($Finding.Evidence)
        }
    }
}
