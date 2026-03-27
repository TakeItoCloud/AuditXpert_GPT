function Get-AxServiceAppendixMarkdown {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [psobject[]]$Finding
    )

    $appendix = Convert-AxReportDataToServiceAppendix -Finding $Finding
    $lines = @('# Service-Specific Appendix', '')
    foreach ($section in $appendix) {
        $lines += "## $($section.Service)"
        foreach ($item in $section.Findings) {
            $lines += "- $($item.FindingId): $($item.Title)"
        }
        $lines += ''
    }

    $lines -join [Environment]::NewLine
}
