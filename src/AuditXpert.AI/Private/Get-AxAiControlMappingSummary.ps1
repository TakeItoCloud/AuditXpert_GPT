function Get-AxAiControlMappingSummary {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [psobject]$Finding,

        [Parameter()]
        [psobject[]]$RelatedRisk = @()
    )

    $findingMappings = @($Finding.FrameworkMappings)
    if ($findingMappings.Count -gt 0) {
        $labels = foreach ($mapping in $findingMappings) {
            if ($mapping.Framework -and $mapping.Control) {
                "$($mapping.Framework): $($mapping.Control)"
            }
            elseif ($mapping.Framework) {
                [string]$mapping.Framework
            }
            else {
                [string]$mapping
            }
        }

        $normalized = @($labels | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })
        if ($normalized.Count -gt 0) {
            return $normalized -join '; '
        }
    }

    $riskMappings = foreach ($risk in $RelatedRisk) {
        foreach ($domain in @($risk.RelatedControlDomains)) {
            [string]$domain
        }
    }

    $riskMappings = @($riskMappings | Where-Object { -not [string]::IsNullOrWhiteSpace($_) } | Select-Object -Unique)
    if ($riskMappings.Count -gt 0) {
        return $riskMappings -join '; '
    }

    'Framework or control mapping not populated in the current dataset.'
}
