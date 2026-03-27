$assessmentsManifest = Join-Path -Path $PSScriptRoot -ChildPath '..\AuditXpert.Assessments\AuditXpert.Assessments.psd1'
Import-Module -Name $assessmentsManifest -Force -ErrorAction Stop

$publicPath = Join-Path -Path $PSScriptRoot -ChildPath 'Public'
$privatePath = Join-Path -Path $PSScriptRoot -ChildPath 'Private'

foreach ($path in @($privatePath, $publicPath)) {
    if (-not (Test-Path -LiteralPath $path)) {
        continue
    }

    Get-ChildItem -Path $path -Filter '*.ps1' -File | ForEach-Object {
        . $_.FullName
    }
}
