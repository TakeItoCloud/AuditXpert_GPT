function Get-AxRegulatoryRootPath {
    [CmdletBinding()]
    param()

    Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent | Split-Path -Parent
}
