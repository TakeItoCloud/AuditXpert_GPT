BeforeAll {
    $repoRoot = Split-Path -Path $PSScriptRoot -Parent | Split-Path -Parent | Split-Path -Parent
    Import-Module (Join-Path $repoRoot 'src/AuditXpert.Assessments/AuditXpert.Assessments.psd1') -Force
    $fixturePath = Join-Path $repoRoot 'samples/findings/hybrid/hybrid-fixture-context.json'
    $fixtureObject = Get-Content -Raw $fixturePath | ConvertFrom-Json -AsHashtable
    $script:context = @{
        ScopeType = $fixtureObject.ScopeType
        Scope     = $fixtureObject.Scope
        Mode      = $fixtureObject.Mode
        Datasets  = $fixtureObject.Datasets
    }
    $script:outputPath = Join-Path $repoRoot 'output/hybrid-phase07-tests'
    New-Item -ItemType Directory -Force -Path $script:outputPath | Out-Null
}

Describe 'Hybrid assessment rule catalog' {
    It 'returns the expected hybrid rule set' {
        $rules = Get-AxHybridAssessmentRule
        $rules.Count | Should -Be 8
    }
}

Describe 'Hybrid assessment pack output shape' {
    It 'emits normalized findings for all hybrid rule areas' {
        $result = Invoke-AxHybridAssessmentPack -Context $script:context

        $result.FindingCount | Should -Be 8
        foreach ($finding in $result.Findings) {
            $finding.PSObject.Properties.Name | Should -Contain 'FindingId'
            $finding.Service | Should -Be 'Hybrid / On-Prem'
            $finding.Scope | Should -Match 'Domain:contoso.local'
        }
    }
}

Describe 'Hybrid export smoke test' {
    It 'exports findings for a hybrid scope' {
        $findings = (Invoke-AxHybridAssessmentPack -Context $script:context).Findings
        $jsonPath = Join-Path $script:outputPath 'hybrid-findings.json'
        $markdownPath = Join-Path $script:outputPath 'hybrid-findings.md'

        Export-AxFindings -Finding $findings -Format Json -Path $jsonPath | Out-Null
        Export-AxFindings -Finding $findings -Format Markdown -Path $markdownPath | Out-Null

        (Test-Path -LiteralPath $jsonPath) | Should -BeTrue
        (Test-Path -LiteralPath $markdownPath) | Should -BeTrue
    }
}
