function Invoke-AxAssessmentPack {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$AssessmentPack,

        [Parameter(Mandatory)]
        [psobject[]]$Rule,

        [Parameter()]
        [hashtable]$Context = @{}
    )

    $selectedRules = $Rule | Where-Object { $_.AssessmentPack -eq $AssessmentPack }
    $findings = New-Object System.Collections.Generic.List[object]

    foreach ($item in $selectedRules) {
        $result = & $item.Evaluate $Context
        foreach ($finding in @($result)) {
            Test-AxFindingShape -Finding $finding | Out-Null
            [void]$findings.Add($finding)
        }
    }

    [pscustomobject]@{
        AssessmentPack = $AssessmentPack
        RuleCount      = $selectedRules.Count
        FindingCount   = $findings.Count
        Findings       = $findings.ToArray()
        ExecutedAt     = (Get-Date).ToString('o')
    }
}
