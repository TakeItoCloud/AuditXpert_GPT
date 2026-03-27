function Get-AxReportTemplateRootPath {
    [CmdletBinding()]
    param()

    Join-Path -Path $PSScriptRoot -ChildPath '..\Templates'
}
