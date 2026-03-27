[CmdletBinding()]
param(
    [string]$WorkspaceRoot = (Split-Path -Path $PSScriptRoot -Parent),
    [string]$Version = '0.1.0',
    [switch]$PassThru
)

$ErrorActionPreference = 'Stop'

& (Join-Path $PSScriptRoot 'Initialize-AuditXpert.ps1') -WorkspaceRoot $WorkspaceRoot | Out-Null

$timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$releaseRoot = Join-Path $WorkspaceRoot "output\releases\AuditXpert_GPT-$Version-$timestamp"
$packageRoot = Join-Path $releaseRoot 'package'
$archivePath = Join-Path $releaseRoot "AuditXpert_GPT-$Version-$timestamp.zip"

New-Item -ItemType Directory -Force -Path $packageRoot | Out-Null

$copyItems = @(
    'src',
    'config',
    'docs',
    'samples',
    'tests',
    'tools',
    'README.md',
    'CHANGELOG.md',
    'PROJECT_DEFINITION.md',
    'IMPLEMENTATION_PLAN.md',
    'DEVELOPMENT_HISTORY.md',
    'NEXT_STEP.md',
    'TEST_PLAN.md',
    'ARCHITECTURE_NOTES.md',
    'Invoke-AuditXpert.ps1'
)

foreach ($item in $copyItems) {
    $sourcePath = Join-Path $WorkspaceRoot $item
    Copy-Item -Path $sourcePath -Destination $packageRoot -Recurse -Force
}

$manifest = [pscustomobject]@{
    Product        = 'AuditXpert_GPT'
    Version        = $Version
    BuiltAt        = (Get-Date).ToString('o')
    PackageContent = $copyItems
    Notes          = 'Read-only assessment toolkit scaffold for consultant use.'
} | ConvertTo-Json -Depth 5

Set-Content -LiteralPath (Join-Path $packageRoot 'release-manifest.json') -Value $manifest -Encoding UTF8

if (Test-Path -LiteralPath $archivePath) {
    Remove-Item -LiteralPath $archivePath -Force
}

Compress-Archive -Path (Join-Path $packageRoot '*') -DestinationPath $archivePath -Force

Write-Host 'AuditXpert release package created.' -ForegroundColor Green

if ($PassThru) {
    [pscustomobject]@{
        ReleaseRoot = $releaseRoot
        PackageRoot = $packageRoot
        ArchivePath = $archivePath
    }
}
