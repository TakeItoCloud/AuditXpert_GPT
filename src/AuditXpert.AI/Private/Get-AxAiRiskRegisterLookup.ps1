function Get-AxAiRiskRegisterLookup {
    [CmdletBinding()]
    param(
        [Parameter()]
        [psobject[]]$RiskRegister = @()
    )

    $lookup = @{}
    foreach ($risk in $RiskRegister) {
        foreach ($findingId in @($risk.RelatedFindings)) {
            if (-not $lookup.ContainsKey($findingId)) {
                $lookup[$findingId] = [System.Collections.Generic.List[object]]::new()
            }

            $lookup[$findingId].Add($risk)
        }
    }

    $lookup
}
