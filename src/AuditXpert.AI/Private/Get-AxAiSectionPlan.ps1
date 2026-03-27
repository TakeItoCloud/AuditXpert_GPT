function Get-AxAiSectionPlan {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [psobject]$ReportTemplate,

        [Parameter(Mandatory)]
        [psobject]$PromptTemplate
    )

    $sectionContracts = Get-AxReportingTemplate -TemplateName 'section_contracts' -Category 'shared'

    foreach ($sectionKey in @($ReportTemplate.mandatorySections)) {
        $sectionContract = @($sectionContracts.sections | Where-Object { $_.key -eq $sectionKey } | Select-Object -First 1)[0]
        $instructionProperty = $PromptTemplate.sectionInstructions.PSObject.Properties[$sectionKey]
        [pscustomobject]@{
            SectionKey    = $sectionKey
            SectionTitle  = if ($sectionContract) { [string]$sectionContract.title } else { $sectionKey }
            Required      = $true
            AIControlled  = ($null -ne $instructionProperty)
            Instructions  = if ($instructionProperty) { [string]$instructionProperty.Value } else { 'Populate from the fixed report template without AI-generated expansion.' }
        }
    }
}
