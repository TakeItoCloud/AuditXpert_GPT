[CmdletBinding()]
param(
    [switch]$PassThru
)

$moduleDefinitions = @(
    @{
        Name = 'AuditXpert.Core'
        Path = Join-Path -Path $PSScriptRoot -ChildPath 'src/AuditXpert.Core/AuditXpert.Core.psd1'
    }
    @{
        Name = 'AuditXpert.Prereqs'
        Path = Join-Path -Path $PSScriptRoot -ChildPath 'src/AuditXpert.Prereqs/AuditXpert.Prereqs.psd1'
    }
    @{
        Name = 'AuditXpert.Connectors'
        Path = Join-Path -Path $PSScriptRoot -ChildPath 'src/AuditXpert.Connectors/AuditXpert.Connectors.psd1'
    }
    @{
        Name = 'AuditXpert.Assessments'
        Path = Join-Path -Path $PSScriptRoot -ChildPath 'src/AuditXpert.Assessments/AuditXpert.Assessments.psd1'
    }
    @{
        Name = 'AuditXpert.Regulatory'
        Path = Join-Path -Path $PSScriptRoot -ChildPath 'src/AuditXpert.Regulatory/AuditXpert.Regulatory.psd1'
    }
    @{
        Name = 'AuditXpert.Reporting'
        Path = Join-Path -Path $PSScriptRoot -ChildPath 'src/AuditXpert.Reporting/AuditXpert.Reporting.psd1'
    }
    @{
        Name = 'AuditXpert.AI'
        Path = Join-Path -Path $PSScriptRoot -ChildPath 'src/AuditXpert.AI/AuditXpert.AI.psd1'
    }
    @{
        Name = 'AuditXpert.Cli'
        Path = Join-Path -Path $PSScriptRoot -ChildPath 'src/AuditXpert.Cli/AuditXpert.Cli.psd1'
    }
)

if ($PSVersionTable.PSVersion.Major -lt 7) {
    throw 'AuditXpert_GPT requires PowerShell 7 or later.'
}

$results = foreach ($module in $moduleDefinitions) {
    if (-not (Test-Path -LiteralPath $module.Path)) {
        throw "Module manifest not found: $($module.Path)"
    }

    Import-Module -Name $module.Path -Force -ErrorAction Stop | Out-Null

    [pscustomobject]@{
        Module  = $module.Name
        Path    = $module.Path
        Loaded  = $true
        Version = (Test-ModuleManifest -Path $module.Path).Version.ToString()
    }
}

Write-Host 'AuditXpert bootstrap validation completed.' -ForegroundColor Green
Write-Host 'Repository skeleton is loadable. Assessment orchestration will be implemented in later phases.' -ForegroundColor Yellow

if ($PassThru) {
    $results
}
