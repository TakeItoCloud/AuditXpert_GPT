BeforeAll {
    $repoRoot = Split-Path -Path $PSScriptRoot -Parent | Split-Path -Parent
    $modulePath = Join-Path $repoRoot 'src/AuditXpert.Connectors/AuditXpert.Connectors.psd1'
    Import-Module -Name $modulePath -Force
}

Describe 'AuditXpert.Connectors metadata' {
    It 'returns four connector definitions' {
        $metadata = Get-AxConnectorMetadata
        $metadata.Count | Should -Be 4
    }

    It 'declares supported auth methods for Azure' {
        $azure = Get-AxConnectorMetadata -Name Azure
        $azure.AuthMethods | Should -Contain 'Delegated'
        $azure.AuthMethods | Should -Contain 'ServicePrincipal'
    }
}

Describe 'AuditXpert.Connectors readiness handling' {
    It 'returns an operator-friendly unavailable result when a required module is missing' {
        Mock Get-Module { @() } -ModuleName AuditXpert.Connectors

        $result = Test-AxConnectorAccess -Connector MicrosoftGraph -AuthMethod Delegated -Detailed

        $result.Status | Should -Be 'Unavailable'
        $result.Message | Should -Match 'Install or update the required modules'
        $result.ModuleDependencyCheck[0].Available | Should -BeFalse
    }

    It 'initializes a stub session when dependencies are available' {
        Mock Get-Module {
            [pscustomobject]@{
                Name    = 'Az.Accounts'
                Version = [version]'2.12.0'
            }
        } -ModuleName AuditXpert.Connectors

        $session = Connect-AxAzure -AuthMethod Delegated -SubscriptionId 'sub-001' -TenantId 'tenant-001'

        $session.State | Should -Be 'Connected'
        $session.Context.SubscriptionId | Should -Be 'sub-001'
    }

    It 'redacts sensitive connector log fields' {
        $log = & (Get-Command Write-AxConnectorLog -Module AuditXpert.Connectors).ScriptBlock -Level Information -Component 'Test' -Message 'Secret-safe' -Data @{
            ClientSecret = 'super-secret'
            TenantId     = 'tenant-001'
        }

        $log.Data.ClientSecret | Should -Be '[REDACTED]'
        $log.Data.TenantId | Should -Be 'tenant-001'
    }
}
