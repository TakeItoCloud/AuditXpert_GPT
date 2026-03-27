BeforeAll {
    $repoRoot = Split-Path -Path $PSScriptRoot -Parent
}

Describe 'AuditXpert hardening toolchain' {
    It 'initializes consultant-friendly output folders' {
        $result = & (Join-Path $repoRoot 'tools\Initialize-AuditXpert.ps1') -WorkspaceRoot $repoRoot -PassThru

        $result.Directories.Count | Should -BeGreaterThan 3
        (Test-Path -LiteralPath (Join-Path $repoRoot 'output\reports')) | Should -BeTrue
        (Test-Path -LiteralPath (Join-Path $repoRoot 'output\releases')) | Should -BeTrue
    }

    It 'runs smoke tests without AI enabled' {
        $result = & (Join-Path $repoRoot 'tools\Run-SmokeTests.ps1') -WorkspaceRoot $repoRoot -PassThru

        $result.ReportFiles.Count | Should -Be 6
        $result.GovernanceItems | Should -BeGreaterThan 0
        $result.AIEnabled | Should -BeFalse
    }
}
