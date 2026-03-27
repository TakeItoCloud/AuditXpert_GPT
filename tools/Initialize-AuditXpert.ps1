[CmdletBinding()]
param(
    [string]$WorkspaceRoot = (Split-Path -Path $PSScriptRoot -Parent),
    [switch]$PassThru
)

$requiredDirectories = @(
    'output',
    'output\evidence',
    'output\findings',
    'output\governance',
    'output\reports',
    'output\logs',
    'output\releases',
    'output\smoke-tests'
)

$created = foreach ($relativePath in $requiredDirectories) {
    $fullPath = Join-Path $WorkspaceRoot $relativePath
    if (-not (Test-Path -LiteralPath $fullPath)) {
        New-Item -ItemType Directory -Path $fullPath -Force | Out-Null
    }

    [pscustomobject]@{
        Path   = $fullPath
        Exists = (Test-Path -LiteralPath $fullPath -PathType Container)
    }
}

Write-Host 'AuditXpert workspace initialized with consultant-friendly output folders.' -ForegroundColor Green

if ($PassThru) {
    [pscustomobject]@{
        WorkspaceRoot = $WorkspaceRoot
        Directories   = $created
    }
}
