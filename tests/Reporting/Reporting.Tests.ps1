BeforeAll {
    $repoRoot = Split-Path -Path $PSScriptRoot -Parent | Split-Path -Parent
    Import-Module (Join-Path $repoRoot 'src/AuditXpert.Reporting/AuditXpert.Reporting.psd1') -Force
    Import-Module (Join-Path $repoRoot 'src/AuditXpert.Regulatory/AuditXpert.Regulatory.psd1') -Force
    $script:findings = Get-Content -Raw (Join-Path $repoRoot 'samples/governance/sample-governance-findings.json') | ConvertFrom-Json
    $script:governance = Invoke-AxGovernanceAnalysis -Finding $script:findings
    $script:outputPath = Join-Path $repoRoot 'output/phase09-reporting-tests'
    New-Item -ItemType Directory -Force -Path $script:outputPath | Out-Null
}

Describe 'AuditXpert.Reporting rendering' {
    It 'creates a report bundle with executive and technical sections' {
        $bundle = New-AxReportBundle -Finding $script:findings -RiskRegister $script:governance.RiskRegister -Scorecard $script:governance.Scorecard

        $bundle.ExecutiveSummary | Should -Match '# Executive Summary'
        $bundle.TechnicalFindings | Should -Match 'Traceability: AX-M365-ENTRA-001'
        $bundle.RiskRegisterSummary | Should -Match 'Risk Register Summary'
        $bundle.ServiceAppendix | Should -Match 'Service-Specific Appendix'
    }

    It 'exports report files without requiring AI' {
        $bundle = New-AxReportBundle -Finding $script:findings -RiskRegister $script:governance.RiskRegister -Scorecard $script:governance.Scorecard
        $export = Export-AxReportBundle -ReportBundle $bundle -OutputPath $script:outputPath

        $export.Files.Count | Should -Be 6
        (Test-Path -LiteralPath (Join-Path $script:outputPath 'Executive-Summary.md')) | Should -BeTrue
        (Test-Path -LiteralPath (Join-Path $script:outputPath 'Technical-Findings.html')) | Should -BeTrue
    }
}
