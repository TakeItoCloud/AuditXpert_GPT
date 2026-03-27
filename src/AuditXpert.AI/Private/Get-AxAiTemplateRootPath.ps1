function Get-AxAiTemplateRootPath {
    [CmdletBinding()]
    param()

    Join-Path -Path $PSScriptRoot -ChildPath '..\Templates'
}
