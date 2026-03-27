function Get-AxTemplateSectionTitle {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$SectionKey
    )

    $contracts = Get-AxReportTemplate -TemplateName 'section_contracts' -Category 'shared'
    $section = @($contracts.sections | Where-Object { $_.key -eq $SectionKey } | Select-Object -First 1)[0]

    if ($section) {
        return [string]$section.title
    }

    return $SectionKey
}
