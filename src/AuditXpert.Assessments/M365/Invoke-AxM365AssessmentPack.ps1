function Invoke-AxM365AssessmentPack {
    [CmdletBinding()]
    param(
        [Parameter()]
        [hashtable]$Context = @{}
    )

    Invoke-AxAssessmentPack -AssessmentPack 'Microsoft365' -Rule (Get-AxM365AssessmentRule) -Context $Context
}
