BeforeAll {
    $repoRoot = Split-Path -Path $PSScriptRoot -Parent | Split-Path -Parent | Split-Path -Parent
    Import-Module (Join-Path $repoRoot 'src/AuditXpert.Assessments/AuditXpert.Assessments.psd1') -Force
    $fixturePath = Join-Path $repoRoot 'samples/findings/azure/azure-fixture-context.json'
    $fixtureObject = Get-Content -Raw $fixturePath | ConvertFrom-Json -AsHashtable
    $script:context = @{
        ScopeType    = $fixtureObject.ScopeType
        Scope        = $fixtureObject.Scope
        ResourceType = $fixtureObject.ResourceType
        Datasets     = $fixtureObject.Datasets
    }
    $script:outputPath = Join-Path $repoRoot 'output/azure-phase06-tests'
    New-Item -ItemType Directory -Force -Path $script:outputPath | Out-Null
}

Describe 'Azure assessment rule catalog' {
    It 'returns the expected Azure rule set' {
        $rules = Get-AxAzureAssessmentRule
        $rules.Count | Should -Be 8
    }
}

Describe 'Azure assessment pack output shape' {
    It 'emits normalized findings for all Azure rule areas' {
        $result = Invoke-AxAzureAssessmentPack -Context $script:context

        $result.FindingCount | Should -Be 8
        foreach ($finding in $result.Findings) {
            $finding.PSObject.Properties.Name | Should -Contain 'FindingId'
            $finding.Service | Should -Be 'Azure'
            $finding.Scope | Should -Match 'Subscription:sub-prod-001'
        }
    }
}

Describe 'Azure export smoke test' {
    It 'exports findings for an Azure sample scope' {
        $findings = (Invoke-AxAzureAssessmentPack -Context $script:context).Findings
        $jsonPath = Join-Path $script:outputPath 'azure-findings.json'
        $htmlPath = Join-Path $script:outputPath 'azure-findings.html'

        Export-AxFindings -Finding $findings -Format Json -Path $jsonPath | Out-Null
        Export-AxFindings -Finding $findings -Format Html -Path $htmlPath | Out-Null

        (Test-Path -LiteralPath $jsonPath) | Should -BeTrue
        (Test-Path -LiteralPath $htmlPath) | Should -BeTrue
    }
}
