BeforeAll {
    $repoRoot = Split-Path -Path $PSScriptRoot -Parent | Split-Path -Parent | Split-Path -Parent
    Import-Module (Join-Path $repoRoot 'src/AuditXpert.Assessments/AuditXpert.Assessments.psd1') -Force
    $fixturePath = Join-Path $repoRoot 'samples/findings/m365/m365-fixture-context.json'
    $fixtureObject = Get-Content -Raw $fixturePath | ConvertFrom-Json -AsHashtable
    $script:context = @{
        Scope    = $fixtureObject.Scope
        Datasets = $fixtureObject.Datasets
    }
    $script:outputPath = Join-Path $repoRoot 'output/m365-phase05-tests'
    New-Item -ItemType Directory -Force -Path $script:outputPath | Out-Null
}

Describe 'Microsoft 365 assessment rule catalog' {
    It 'returns the expected M365 rule set' {
        $rules = Get-AxM365AssessmentRule
        $rules.Count | Should -Be 8
    }
}

Describe 'Microsoft 365 assessment pack output shape' {
    It 'emits normalized findings for all M365 rule areas' {
        $result = Invoke-AxM365AssessmentPack -Context $script:context

        $result.FindingCount | Should -Be 8
        foreach ($finding in $result.Findings) {
            $finding.PSObject.Properties.Name | Should -Contain 'FindingId'
            $finding.Service | Should -Be 'Microsoft 365'
            $finding.Evidence.Count | Should -BeGreaterThan 0
        }
    }
}

Describe 'Microsoft 365 export smoke test' {
    It 'exports findings for a Microsoft 365 scope' {
        $findings = (Invoke-AxM365AssessmentPack -Context $script:context).Findings
        $jsonPath = Join-Path $script:outputPath 'm365-findings.json'
        $markdownPath = Join-Path $script:outputPath 'm365-findings.md'

        Export-AxFindings -Finding $findings -Format Json -Path $jsonPath | Out-Null
        Export-AxFindings -Finding $findings -Format Markdown -Path $markdownPath | Out-Null

        (Test-Path -LiteralPath $jsonPath) | Should -BeTrue
        (Test-Path -LiteralPath $markdownPath) | Should -BeTrue
    }
}
