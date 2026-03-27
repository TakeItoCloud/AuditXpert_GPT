function Test-AxAiSectionPlan {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [psobject]$ReportTemplate,

        [Parameter(Mandatory)]
        [psobject]$PromptTemplate
    )

    $issues = [System.Collections.Generic.List[string]]::new()
    $mandatorySections = @($ReportTemplate.mandatorySections)
    $supportedInstructions = @($PromptTemplate.sectionInstructions.PSObject.Properties.Name)

    foreach ($sectionKey in $mandatorySections) {
        if ($sectionKey -notin @(
            'report_title_and_metadata',
            'scope',
            'methodology'
        ) -and $sectionKey -notin $supportedInstructions) {
            $issues.Add("Prompt template '$($PromptTemplate.reportType)' does not define instructions for mandatory AI-relevant section '$sectionKey'.")
        }
    }

    [pscustomobject]@{
        Valid  = ($issues.Count -eq 0)
        Issues = @($issues)
    }
}
