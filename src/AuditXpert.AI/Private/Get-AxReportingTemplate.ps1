function Get-AxReportingTemplate {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$TemplateName,

        [Parameter()]
        [ValidateSet('reports', 'shared')]
        [string]$Category = 'reports'
    )

    $reportingRoot = Join-Path -Path $PSScriptRoot -ChildPath '..\..\AuditXpert.Reporting\Templates'
    $templatePath = Join-Path -Path $reportingRoot -ChildPath (Join-Path -Path $Category -ChildPath "$TemplateName.json")

    if (-not (Test-Path -LiteralPath $templatePath)) {
        throw "Reporting template not found: $templatePath"
    }

    Get-Content -LiteralPath $templatePath -Raw | ConvertFrom-Json
}
