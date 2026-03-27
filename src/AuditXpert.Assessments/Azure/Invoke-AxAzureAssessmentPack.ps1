function Invoke-AxAzureAssessmentPack {
    [CmdletBinding()]
    param(
        [Parameter()]
        [hashtable]$Context = @{}
    )

    Invoke-AxAssessmentPack -AssessmentPack 'Azure' -Rule (Get-AxAzureAssessmentRule) -Context $Context
}
