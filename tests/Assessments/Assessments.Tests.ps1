BeforeAll {
    $repoRoot = Split-Path -Path $PSScriptRoot -Parent | Split-Path -Parent
    Import-Module (Join-Path $repoRoot 'src/AuditXpert.Cli/AuditXpert.Cli.psd1') -Force
    Import-Module (Join-Path $repoRoot 'src/AuditXpert.Assessments/AuditXpert.Assessments.psd1') -Force
    $outputPath = Join-Path $repoRoot 'output/phase04-tests'
    New-Item -ItemType Directory -Force -Path $outputPath | Out-Null
}

Describe 'AuditXpert.Assessments finding schema' {
    It 'creates a normalized finding with the required fields' {
        $finding = New-AxFinding -FindingId 'AX-TST-001' `
            -Category 'Identity' `
            -Service 'Microsoft 365' `
            -Scope 'Tenant' `
            -Severity 'Medium' `
            -Likelihood 'Medium' `
            -Impact 'High' `
            -Title 'Test finding' `
            -Description 'Schema validation test' `
            -Evidence @([pscustomobject]@{ Source = 'Test'; Reference = 'Fixture'; Value = 'Evidence' }) `
            -Recommendation 'Test recommendation' `
            -RemediationType 'Configuration' `
            -FrameworkMappings @([pscustomobject]@{ Framework = 'NIS2'; Control = 'AccessControl' }) `
            -Source @{ Connector = 'Test'; RuleId = 'AX-TST-001'; Pack = 'TestPack' }

        $finding.PSObject.Properties.Name | Should -Contain 'FindingId'
        $finding.RiskScore | Should -Be 12
        $finding.Source.Connector | Should -Be 'Test'
    }
}

Describe 'AuditXpert.Assessments export functions' {
    It 'exports findings to JSON, CSV, Markdown, and HTML' {
        $finding = New-AxFinding -FindingId 'AX-TST-002' `
            -Category 'Governance' `
            -Service 'Azure' `
            -Scope 'Subscription' `
            -Severity 'Low' `
            -Likelihood 'Low' `
            -Impact 'Medium' `
            -Title 'Export test finding' `
            -Description 'Export validation test' `
            -Evidence @([pscustomobject]@{ Source = 'Test'; Reference = 'Export'; Value = 'Evidence' }) `
            -Recommendation 'Test recommendation' `
            -RemediationType 'Configuration' `
            -FrameworkMappings @([pscustomobject]@{ Framework = 'ISO27001'; Control = 'A.5' }) `
            -Source @{ Connector = 'Test'; RuleId = 'AX-TST-002'; Pack = 'TestPack' }

        (Export-AxFindings -Finding $finding -Format Json) | Should -Match 'AX-TST-002'
        (Export-AxFindings -Finding $finding -Format Csv) | Should -Match 'FindingId'
        (Export-AxFindings -Finding $finding -Format Markdown) | Should -Match '# AuditXpert Findings'
        (Export-AxFindings -Finding $finding -Format Html) | Should -Match '<html'
    }
}

Describe 'AuditXpert.Cli orchestrator' {
    It 'runs stub rules and writes requested exports' {
        $result = Invoke-AxAssessmentOrchestrator -AssessmentPack @('Microsoft365', 'Azure') -Context @{ Scope = 'TenantOrSubscription' } -OutputPath $outputPath -ExportFormat @('Json', 'Markdown', 'Html', 'Csv')

        $result.FindingCount | Should -Be 2
        $result.Exports.Count | Should -Be 4
        (Test-Path -LiteralPath (Join-Path $outputPath 'findings.json')) | Should -BeTrue
        (Test-Path -LiteralPath (Join-Path $outputPath 'findings.csv')) | Should -BeTrue
        (Test-Path -LiteralPath (Join-Path $outputPath 'findings.md')) | Should -BeTrue
        (Test-Path -LiteralPath (Join-Path $outputPath 'findings.html')) | Should -BeTrue
    }
}
