function New-AxScorecardRecord {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Domain,

        [Parameter(Mandatory)]
        [psobject[]]$Findings
    )

    $total = $Findings.Count
    $highOrCritical = @($Findings | Where-Object { $_.Severity -in @('High', 'Critical') }).Count
    $score = if ($total -eq 0) { 100 } else { [math]::Round(100 - (($highOrCritical / $total) * 100), 2) }
    $maturity = if ($score -ge 85) { 'Managed' } elseif ($score -ge 65) { 'Defined' } elseif ($score -ge 40) { 'Developing' } else { 'Initial' }

    [pscustomobject]@{
        Domain        = $Domain
        FindingCount  = $total
        HighRiskCount = $highOrCritical
        Score         = $score
        Maturity      = $maturity
    }
}
