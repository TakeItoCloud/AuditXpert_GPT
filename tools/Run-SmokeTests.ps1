[CmdletBinding()]
param(
    [string]$WorkspaceRoot = (Split-Path -Path $PSScriptRoot -Parent),
    [switch]$SkipPester,
    [switch]$PassThru
)

$ErrorActionPreference = 'Stop'

& (Join-Path $PSScriptRoot 'Initialize-AuditXpert.ps1') -WorkspaceRoot $WorkspaceRoot | Out-Null

$moduleManifests = @(
    'src\AuditXpert.Core\AuditXpert.Core.psd1',
    'src\AuditXpert.Prereqs\AuditXpert.Prereqs.psd1',
    'src\AuditXpert.Connectors\AuditXpert.Connectors.psd1',
    'src\AuditXpert.Assessments\AuditXpert.Assessments.psd1',
    'src\AuditXpert.Regulatory\AuditXpert.Regulatory.psd1',
    'src\AuditXpert.Reporting\AuditXpert.Reporting.psd1',
    'src\AuditXpert.AI\AuditXpert.AI.psd1',
    'src\AuditXpert.Cli\AuditXpert.Cli.psd1'
)

$moduleResults = foreach ($relativePath in $moduleManifests) {
    $manifestPath = Join-Path $WorkspaceRoot $relativePath
    Import-Module -Name $manifestPath -Force -ErrorAction Stop | Out-Null

    [pscustomobject]@{
        Manifest = $manifestPath
        Imported = $true
    }
}

$findings = Get-Content -Raw (Join-Path $WorkspaceRoot 'samples\governance\sample-governance-findings.json') | ConvertFrom-Json
Import-Module -Name (Join-Path $WorkspaceRoot 'src\AuditXpert.Regulatory\AuditXpert.Regulatory.psd1') -Force | Out-Null
Import-Module -Name (Join-Path $WorkspaceRoot 'src\AuditXpert.Reporting\AuditXpert.Reporting.psd1') -Force | Out-Null
Import-Module -Name (Join-Path $WorkspaceRoot 'src\AuditXpert.AI\AuditXpert.AI.psd1') -Force | Out-Null

$governance = Invoke-AxGovernanceAnalysis -Finding $findings
$bundle = New-AxReportBundle -Finding $findings -RiskRegister $governance.RiskRegister -Scorecard $governance.Scorecard
$reportOutputPath = Join-Path $WorkspaceRoot 'output\smoke-tests\reports'
$reportExport = Export-AxReportBundle -ReportBundle $bundle -OutputPath $reportOutputPath
$aiPackage = New-AxAiNarrativePackage -Finding $findings -RiskRegister $governance.RiskRegister -Scorecard $governance.Scorecard -DisableAI

$pesterResult = $null
if (-not $SkipPester) {
    if (-not (Get-Module -ListAvailable -Name Pester)) {
        throw 'Pester is not available. Install Pester or run with -SkipPester.'
    }

    $testPaths = Get-ChildItem -Path (Join-Path $WorkspaceRoot 'tests') -Recurse -Filter '*.Tests.ps1' -File |
        Where-Object { $_.Name -ne 'Smoke.Tests.ps1' } |
        Select-Object -ExpandProperty FullName

    $pesterResult = Invoke-Pester -Path $testPaths -PassThru
}

$result = [pscustomobject]@{
    WorkspaceRoot    = $WorkspaceRoot
    ModuleResults    = $moduleResults
    ReportFiles      = $reportExport.Files
    GovernanceItems  = $governance.RiskRegister.Count
    AIEnabled        = $aiPackage.AIEnabled
    PesterPassed     = if ($pesterResult) { $pesterResult.FailedCount -eq 0 } else { $null }
    PesterTotal      = if ($pesterResult) { $pesterResult.TotalCount } else { $null }
    PesterFailed     = if ($pesterResult) { $pesterResult.FailedCount } else { $null }
}

Write-Host 'AuditXpert smoke test completed.' -ForegroundColor Green

if ($PassThru) {
    $result
}
