function Get-AxRiskScore {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateSet('Informational', 'Low', 'Medium', 'High', 'Critical')]
        [string]$Likelihood,

        [Parameter(Mandatory)]
        [ValidateSet('Informational', 'Low', 'Medium', 'High', 'Critical')]
        [string]$Impact
    )

    $weights = @{
        Informational = 1
        Low           = 2
        Medium        = 3
        High          = 4
        Critical      = 5
    }

    $weights[$Likelihood] * $weights[$Impact]
}
