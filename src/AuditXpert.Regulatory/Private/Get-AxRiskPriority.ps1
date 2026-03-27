function Get-AxRiskPriority {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateSet('Informational', 'Low', 'Medium', 'High', 'Critical')]
        [string]$Severity,

        [Parameter(Mandatory)]
        [ValidateSet('Informational', 'Low', 'Medium', 'High', 'Critical')]
        [string]$Likelihood,

        [Parameter(Mandatory)]
        [ValidateSet('Informational', 'Low', 'Medium', 'High', 'Critical')]
        [string]$Impact
    )

    $score = @{
        Informational = 1
        Low           = 2
        Medium        = 3
        High          = 4
        Critical      = 5
    }

    $priorityValue = $score[$Severity] + $score[$Likelihood] + $score[$Impact]
    if ($priorityValue -ge 13) { return 'Critical' }
    if ($priorityValue -ge 10) { return 'High' }
    if ($priorityValue -ge 7) { return 'Medium' }
    if ($priorityValue -ge 5) { return 'Low' }
    'Informational'
}
