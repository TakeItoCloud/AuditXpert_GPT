function Invoke-AxGovernanceAnalysis {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [psobject[]]$Finding,

        [Parameter()]
        [string[]]$Framework = @('nis2-domains', 'iso27001-annexa', 'internal-security-baseline')
    )

    $mapping = Invoke-AxFrameworkMapping -Finding $Finding -Framework $Framework
    $riskRegister = New-AxRiskRegister -Finding $Finding -Mapping $mapping
    $scorecard = New-AxGovernanceScorecard -Finding $Finding -Mapping $mapping

    [pscustomobject]@{
        Frameworks   = $Framework
        Mapping      = $mapping
        RiskRegister = $riskRegister
        Scorecard    = $scorecard
        Disclaimer   = 'Governance outputs support assessment and prioritization. They do not constitute automatic compliance certification.'
    }
}
