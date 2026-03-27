function Get-AxServiceAppendixMarkdown {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [psobject[]]$Finding
    )

    $appendix = Convert-AxReportDataToServiceAppendix -Finding $Finding
    $lines = @(
        '# Service-Specific Appendix',
        '',
        "## $(Get-AxTemplateSectionTitle -SectionKey 'service_specific_detail')"
    )
    foreach ($section in $appendix) {
        $lines += "## $($section.Service)"
        foreach ($item in $section.Findings) {
            $severityDefinition = Get-AxSeverityDefinition -Severity ([string]$item.Severity)
            $lines += "- $($item.FindingId): $($item.Title) ($($severityDefinition.label))"
        }
        $lines += ''
    }

    $lines += "## $(Get-AxTemplateSectionTitle -SectionKey 'evidence_appendix')"
    $lines += '- Use the service sections above as appendix pointers back to the technical findings report and raw evidence references.'

    $lines -join [Environment]::NewLine
}
