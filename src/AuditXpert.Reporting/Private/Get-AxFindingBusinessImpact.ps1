function Get-AxFindingBusinessImpact {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [psobject]$Finding
    )

    $severityDefinition = Get-AxSeverityDefinition -Severity ([string]$Finding.Severity)
    if ($Finding.Impact) {
        return "Impact rating: $($Finding.Impact). $($severityDefinition.businessImpact)"
    }

    $severityDefinition.businessImpact
}
