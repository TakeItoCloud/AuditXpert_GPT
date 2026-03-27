BeforeAll {
    $repoRoot = Split-Path -Path $PSScriptRoot -Parent | Split-Path -Parent
    Import-Module (Join-Path $repoRoot 'src/AuditXpert.AI/AuditXpert.AI.psd1') -Force
    Import-Module (Join-Path $repoRoot 'src/AuditXpert.Regulatory/AuditXpert.Regulatory.psd1') -Force
    $script:findings = Get-Content -Raw (Join-Path $repoRoot 'samples/governance/sample-governance-findings.json') | ConvertFrom-Json
    $script:governance = Invoke-AxGovernanceAnalysis -Finding $script:findings
}

Describe 'AuditXpert.AI prompt rendering' {
    It 'builds a prompt payload with finding traceability' {
        $payload = New-AxAiPromptPayload -Finding $script:findings -RiskRegister $script:governance.RiskRegister -Scorecard $script:governance.Scorecard -ReportType executive-summary

        $payload.Enabled | Should -BeTrue
        $payload.ReportType | Should -Be 'executive-summary'
        $payload.UserPayload.TraceabilityRequirement | Should -Match 'finding_id'
        $payload.UserPayload.Findings[0].FindingId | Should -Be 'AX-M365-ENTRA-001'
        $payload.UserPayload.MappedFindings[0].finding_id | Should -Be 'AX-M365-ENTRA-001'
        $payload.UserPayload.SectionPlan.Count | Should -BeGreaterThan 0
        $payload.UserPayload.Validation.MappedFindingsValid | Should -BeTrue
    }

    It 'supports explicit AI disablement and non-AI reporting mode' {
        $package = New-AxAiNarrativePackage -Finding $script:findings -RiskRegister $script:governance.RiskRegister -Scorecard $script:governance.Scorecard -ReportType technical-assessment -DisableAI

        $package.AIEnabled | Should -BeFalse
        $package.ReportType | Should -Be 'technical-assessment'
        $package.NarrativeLabel | Should -Match 'Non-AI reporting only'
        $package.Traceability.Count | Should -Be 2
    }

    It 'defines AI prompt templates for each supported report type' {
        $templateRoot = Join-Path $repoRoot 'src/AuditXpert.AI/Templates/reports'
        $expected = @(
            'executive-summary.json',
            'technical-assessment.json',
            'governance-vciso.json',
            'azure-assessment.json',
            'microsoft365-assessment.json',
            'hybrid-infrastructure.json',
            'remediation-roadmap.json',
            'service-specific-appendix.json'
        )

        foreach ($file in $expected) {
            (Test-Path -LiteralPath (Join-Path $templateRoot $file)) | Should -BeTrue
        }
    }

    It 'detects missing required mapped finding fields before prompt packaging' {
        $badFinding = [pscustomobject]@{
            FindingId         = 'AX-BAD-001'
            Title             = $null
            Severity          = 'High'
            Service           = 'Azure'
            Category          = 'Security'
            Scope             = 'Subscription:test'
            Description       = 'Bad test record.'
            Evidence          = @()
            Recommendation    = 'Fix it.'
            FrameworkMappings = @()
            Likelihood        = 'Medium'
            Impact            = 'High'
            RiskScore         = 12
        }

        {
            New-AxAiPromptPayload -Finding @($badFinding) -ReportType executive-summary
        } | Should -Throw
    }
}
