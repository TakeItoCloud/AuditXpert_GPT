function Get-AxConnectorDefinition {
    [CmdletBinding()]
    param(
        [Parameter()]
        [string]$Name
    )

    $definitions = @(
        [pscustomobject]@{
            Name                   = 'MicrosoftGraph'
            Service                = 'Microsoft 365'
            Description            = 'Microsoft Graph connector abstraction for delegated and app-only patterns.'
            AuthMethods            = @('Delegated', 'AppOnly')
            ModuleDependencies     = @([pscustomobject]@{ Name = 'Microsoft.Graph.Authentication'; MinimumVersion = '2.0.0'; Required = $true })
            PermissionRequirements = @(
                [pscustomobject]@{ AssessmentPack = 'PlatformConnectivity'; Type = 'Delegated'; Values = @('Directory.Read.All') }
                [pscustomobject]@{ AssessmentPack = 'PlatformConnectivity'; Type = 'Application'; Values = @('Directory.Read.All') }
            )
            SupportsDisconnect     = $true
        }
        [pscustomobject]@{
            Name                   = 'ExchangeOnline'
            Service                = 'Microsoft 365'
            Description            = 'Exchange Online connector abstraction for delegated and certificate-based sessions.'
            AuthMethods            = @('Delegated', 'AppOnly')
            ModuleDependencies     = @([pscustomobject]@{ Name = 'ExchangeOnlineManagement'; MinimumVersion = '3.0.0'; Required = $true })
            PermissionRequirements = @(
                [pscustomobject]@{ AssessmentPack = 'PlatformConnectivity'; Type = 'Delegated'; Values = @('View-Only Configuration') }
                [pscustomobject]@{ AssessmentPack = 'PlatformConnectivity'; Type = 'Application'; Values = @('Exchange.ManageAsApp') }
            )
            SupportsDisconnect     = $true
        }
        [pscustomobject]@{
            Name                   = 'Azure'
            Service                = 'Azure'
            Description            = 'Azure connector abstraction for delegated and service principal access.'
            AuthMethods            = @('Delegated', 'ServicePrincipal')
            ModuleDependencies     = @([pscustomobject]@{ Name = 'Az.Accounts'; MinimumVersion = '2.12.0'; Required = $true })
            PermissionRequirements = @([pscustomobject]@{ AssessmentPack = 'PlatformConnectivity'; Type = 'RBAC'; Values = @('Reader') })
            SupportsDisconnect     = $true
        }
        [pscustomobject]@{
            Name                   = 'HybridLocal'
            Service                = 'Hybrid / On-Prem'
            Description            = 'Hybrid local collector abstraction for Active Directory and host-side checks.'
            AuthMethods            = @('Integrated', 'RunAs')
            ModuleDependencies     = @([pscustomobject]@{ Name = 'ActiveDirectory'; MinimumVersion = '1.0.0.0'; Required = $false })
            PermissionRequirements = @([pscustomobject]@{ AssessmentPack = 'PlatformConnectivity'; Type = 'Directory'; Values = @('Read access to required local directories and management endpoints') })
            SupportsDisconnect     = $false
        }
    )

    if ([string]::IsNullOrWhiteSpace($Name)) {
        return $definitions
    }

    $match = $definitions | Where-Object { $_.Name -eq $Name }
    if (-not $match) {
        throw "Unknown connector definition: $Name"
    }

    $match
}
