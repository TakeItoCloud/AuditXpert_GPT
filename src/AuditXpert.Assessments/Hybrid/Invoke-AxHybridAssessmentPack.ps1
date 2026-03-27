function Invoke-AxHybridAssessmentPack {
    [CmdletBinding()]
    param(
        [Parameter()]
        [hashtable]$Context = @{}
    )

    Invoke-AxAssessmentPack -AssessmentPack 'Hybrid' -Rule (Get-AxHybridAssessmentRule) -Context $Context
}
