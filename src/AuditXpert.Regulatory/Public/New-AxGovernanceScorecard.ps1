function New-AxGovernanceScorecard {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [psobject[]]$Finding,

        [Parameter(Mandatory)]
        [psobject[]]$Mapping
    )

    $domainRows = foreach ($map in $Mapping) {
        foreach ($domain in $map.Mappings.Domain) {
            [pscustomobject]@{
                Domain    = $domain
                FindingId = $map.FindingId
            }
        }
    }
    $groups = $domainRows | Group-Object Domain

    foreach ($group in $groups) {
        $findingsForDomain = foreach ($id in $group.Group.FindingId) {
            $Finding | Where-Object { $_.FindingId -eq $id }
        }

        New-AxScorecardRecord -Domain $group.Name -Findings @($findingsForDomain)
    }
}
