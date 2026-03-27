BeforeAll {
    $repoRoot = Split-Path -Path $PSScriptRoot -Parent | Split-Path -Parent
    Import-Module (Join-Path $repoRoot 'src/AuditXpert.Regulatory/AuditXpert.Regulatory.psd1') -Force
    $script:findings = Get-Content -Raw (Join-Path $repoRoot 'samples/governance/sample-governance-findings.json') | ConvertFrom-Json
}

Describe 'AuditXpert.Regulatory mapping model' {
    It 'loads all configured framework mappings' {
        $mappings = Get-AxFrameworkMapping
        $mappings.Count | Should -Be 3
    }

    It 'maps sample findings to control domains' {
        $mappingResult = Invoke-AxFrameworkMapping -Finding $script:findings
        $mappingResult.Count | Should -Be 2
        $mappingResult[0].Mappings.Count | Should -BeGreaterThan 0
    }
}

Describe 'AuditXpert.Regulatory governance outputs' {
    It 'creates a risk register and scorecard from sample findings' {
        $analysis = Invoke-AxGovernanceAnalysis -Finding $script:findings

        $analysis.RiskRegister.Count | Should -Be 2
        $analysis.Scorecard.Count | Should -BeGreaterThan 0
        $analysis.Disclaimer | Should -Match 'do not constitute automatic compliance certification'
    }
}
