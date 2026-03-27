BeforeAll {
    $repoRoot = Split-Path -Path $PSScriptRoot -Parent | Split-Path -Parent
    Import-Module (Join-Path $repoRoot 'src/AuditXpert.AI/AuditXpert.AI.psd1') -Force
    Import-Module (Join-Path $repoRoot 'src/AuditXpert.Regulatory/AuditXpert.Regulatory.psd1') -Force
    $script:findings = Get-Content -Raw (Join-Path $repoRoot 'samples/governance/sample-governance-findings.json') | ConvertFrom-Json
    $script:governance = Invoke-AxGovernanceAnalysis -Finding $script:findings
}

Describe 'AuditXpert.AI prompt rendering' {
    It 'builds a prompt payload with finding traceability' {
        $payload = New-AxAiPromptPayload -Finding $script:findings -RiskRegister $script:governance.RiskRegister -Scorecard $script:governance.Scorecard

        $payload.Enabled | Should -BeTrue
        $payload.UserPayload.TraceabilityRequirement | Should -Match 'FindingId'
        $payload.UserPayload.Findings[0].FindingId | Should -Be 'AX-M365-ENTRA-001'
    }

    It 'supports explicit AI disablement and non-AI reporting mode' {
        $package = New-AxAiNarrativePackage -Finding $script:findings -RiskRegister $script:governance.RiskRegister -Scorecard $script:governance.Scorecard -DisableAI

        $package.AIEnabled | Should -BeFalse
        $package.NarrativeLabel | Should -Match 'Non-AI reporting only'
        $package.Traceability.Count | Should -Be 2
    }
}
