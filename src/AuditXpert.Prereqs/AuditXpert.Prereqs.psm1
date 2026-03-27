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

function Get-AuditXpertPrereqStatus {
    [CmdletBinding()]
    param()

    [pscustomobject]@{
        Module      = 'AuditXpert.Prereqs'
        Version     = '0.1.0'
        Initialized = $true
        Scope       = 'Foundation scaffold'
    }
}

Export-ModuleMember -Function 'Get-AuditXpertPrereqStatus'
