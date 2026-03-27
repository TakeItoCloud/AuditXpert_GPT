function Get-AxSeverityDefinition {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [AllowEmptyString()]
        [string]$Severity
    )

    $schema = Get-AxReportTemplate -TemplateName 'report_schema' -Category 'shared'
    $normalized = switch -Regex ($Severity) {
        '^Critical$' { 'Critical'; break }
        '^High$' { 'High'; break }
        '^Medium$' { 'Medium'; break }
        '^Low$' { 'Low'; break }
        '^Informational$' { 'Informational'; break }
        default { 'Informational' }
    }

    @($schema.severityTaxonomy | Where-Object { $_.label -eq $normalized } | Select-Object -First 1)[0]
}
