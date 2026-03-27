$publicPath = Join-Path -Path $PSScriptRoot -ChildPath 'Public'
$privatePath = Join-Path -Path $PSScriptRoot -ChildPath 'Private'
$m365Path = Join-Path -Path $PSScriptRoot -ChildPath 'M365'
$azurePath = Join-Path -Path $PSScriptRoot -ChildPath 'Azure'
$hybridPath = Join-Path -Path $PSScriptRoot -ChildPath 'Hybrid'

foreach ($path in @($privatePath, $publicPath, $m365Path, $azurePath, $hybridPath)) {
    if (-not (Test-Path -LiteralPath $path)) {
        continue
    }

    Get-ChildItem -Path $path -Filter '*.ps1' -File | ForEach-Object {
        . $_.FullName
    }
}
