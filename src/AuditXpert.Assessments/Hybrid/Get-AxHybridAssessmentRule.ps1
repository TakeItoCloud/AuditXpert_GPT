function Get-AxHybridAssessmentRule {
    [CmdletBinding()]
    param(
        [Parameter()]
        [string]$Area
    )

    $rules = @(
        New-AxAssessmentRule -RuleId 'AX-HY-AD-001' -Name 'Active Directory hygiene indicators' -AssessmentPack 'Hybrid' -Service 'Hybrid / On-Prem' -Description 'Evaluates Active Directory baseline hygiene indicators.' -DefaultSeverity 'Medium' -Evaluate {
            param($Context)
            $scope = Get-AxHybridScopeMetadata -Context $Context
            $dataset = Get-AxHybridContextDataset -Context $Context -Name 'ActiveDirectory'
            $riskyOus = [int]($dataset.InsecureOuDelegationCount ?? 0)
            $reversibleEncryption = [int]($dataset.AccountsWithReversibleEncryptionCount ?? 0)
            $rsat = [bool]($dataset.RsatAvailable ?? $false)
            $severity = if (-not $rsat) { 'Informational' } elseif ($riskyOus -gt 0 -or $reversibleEncryption -gt 0) { 'High' } else { 'Low' }

            New-AxHybridFinding -FindingId 'AX-HY-AD-001' -Category 'DirectoryHygiene' -Scope "$($scope.ScopeType):$($scope.Scope)" -Severity $severity -Likelihood 'Medium' -Impact 'High' -Title 'Active Directory hygiene indicators require review' -Description "Insecure OU delegations: $riskyOus. Accounts with reversible encryption: $reversibleEncryption. RSAT available: $rsat. Mode: $($scope.Mode)." -Evidence @([pscustomobject]@{ Source = 'ActiveDirectoryFixture'; InsecureOuDelegationCount = $riskyOus; AccountsWithReversibleEncryptionCount = $reversibleEncryption; RsatAvailable = $rsat; CollectionMode = $scope.Mode }) -Recommendation 'Review delegation boundaries, remove reversible password storage, and verify the read-only collection baseline for the scoped directory.' -Source @{ Connector = 'HybridLocal'; RuleId = 'AX-HY-AD-001'; Pack = 'Hybrid'; Area = 'ActiveDirectory' }
        }
        New-AxAssessmentRule -RuleId 'AX-HY-PRIV-001' -Name 'Privileged group exposure indicators' -AssessmentPack 'Hybrid' -Service 'Hybrid / On-Prem' -Description 'Evaluates privileged group membership exposure indicators.' -DefaultSeverity 'High' -Evaluate {
            param($Context)
            $scope = Get-AxHybridScopeMetadata -Context $Context
            $dataset = Get-AxHybridContextDataset -Context $Context -Name 'PrivilegedGroups'
            $excessMembers = [int]($dataset.ExcessPrivilegedMembers ?? 0)
            $nestedGroups = [int]($dataset.NestedPrivilegedGroups ?? 0)
            $severity = if ($excessMembers -gt 5 -or $nestedGroups -gt 0) { 'High' } elseif ($excessMembers -gt 0) { 'Medium' } else { 'Low' }

            New-AxHybridFinding -FindingId 'AX-HY-PRIV-001' -Category 'PrivilegedAccess' -Scope "$($scope.ScopeType):$($scope.Scope)" -Severity $severity -Likelihood 'High' -Impact 'High' -Title 'Privileged group exposure should be reduced' -Description "Excess privileged group members: $excessMembers. Nested privileged groups: $nestedGroups." -Evidence @([pscustomobject]@{ Source = 'PrivilegedGroupsFixture'; ExcessPrivilegedMembers = $excessMembers; NestedPrivilegedGroups = $nestedGroups; CollectionMode = $scope.Mode }) -Recommendation 'Review high-impact privileged groups, eliminate unnecessary nested memberships, and enforce tighter privileged access governance.' -Source @{ Connector = 'HybridLocal'; RuleId = 'AX-HY-PRIV-001'; Pack = 'Hybrid'; Area = 'PrivilegedGroups' }
        }
        New-AxAssessmentRule -RuleId 'AX-HY-STALE-001' -Name 'Stale account indicators' -AssessmentPack 'Hybrid' -Service 'Hybrid / On-Prem' -Description 'Evaluates stale user and computer account indicators.' -DefaultSeverity 'Medium' -Evaluate {
            param($Context)
            $scope = Get-AxHybridScopeMetadata -Context $Context
            $dataset = Get-AxHybridContextDataset -Context $Context -Name 'StaleAccounts'
            $staleUsers = [int]($dataset.StaleUserCount ?? 0)
            $staleComputers = [int]($dataset.StaleComputerCount ?? 0)
            $severity = if ($staleUsers -gt 25 -or $staleComputers -gt 25) { 'High' } elseif ($staleUsers -gt 0 -or $staleComputers -gt 0) { 'Medium' } else { 'Low' }

            New-AxHybridFinding -FindingId 'AX-HY-STALE-001' -Category 'IdentityLifecycle' -Scope "$($scope.ScopeType):$($scope.Scope)" -Severity $severity -Likelihood 'Medium' -Impact 'Medium' -Title 'Stale account population should be reviewed' -Description "Stale users: $staleUsers. Stale computers: $staleComputers." -Evidence @([pscustomobject]@{ Source = 'StaleAccountsFixture'; StaleUserCount = $staleUsers; StaleComputerCount = $staleComputers; CollectionMode = $scope.Mode }) -Recommendation 'Validate stale account criteria, disable or remove inactive principals, and improve lifecycle ownership processes.' -Source @{ Connector = 'HybridLocal'; RuleId = 'AX-HY-STALE-001'; Pack = 'Hybrid'; Area = 'StaleAccounts' }
        }
        New-AxAssessmentRule -RuleId 'AX-HY-DC-001' -Name 'Domain Controller posture indicators' -AssessmentPack 'Hybrid' -Service 'Hybrid / On-Prem' -Description 'Evaluates domain controller security and operational posture indicators.' -DefaultSeverity 'High' -Evaluate {
            param($Context)
            $scope = Get-AxHybridScopeMetadata -Context $Context
            $dataset = Get-AxHybridContextDataset -Context $Context -Name 'DomainControllers'
            $outdatedDcs = [int]($dataset.OutdatedDomainControllerCount ?? 0)
            $unsignedLdap = [int]($dataset.ControllersWithoutLdapSigningCount ?? 0)
            $severity = if ($outdatedDcs -gt 0 -or $unsignedLdap -gt 0) { 'High' } else { 'Low' }

            New-AxHybridFinding -FindingId 'AX-HY-DC-001' -Category 'DomainControllerSecurity' -Scope "$($scope.ScopeType):$($scope.Scope)" -Severity $severity -Likelihood 'Medium' -Impact 'High' -Title 'Domain Controller posture requires remediation planning' -Description "Outdated domain controllers: $outdatedDcs. Controllers without LDAP signing: $unsignedLdap." -Evidence @([pscustomobject]@{ Source = 'DomainControllersFixture'; OutdatedDomainControllerCount = $outdatedDcs; ControllersWithoutLdapSigningCount = $unsignedLdap; CollectionMode = $scope.Mode }) -Recommendation 'Review domain controller patching, protocol hardening, and baseline enforcement across the current domain controller estate.' -Source @{ Connector = 'HybridLocal'; RuleId = 'AX-HY-DC-001'; Pack = 'Hybrid'; Area = 'DomainControllers' }
        }
        New-AxAssessmentRule -RuleId 'AX-HY-GPO-001' -Name 'GPO and security baseline comparison indicators' -AssessmentPack 'Hybrid' -Service 'Hybrid / On-Prem' -Description 'Evaluates GPO drift and baseline comparison indicators.' -DefaultSeverity 'Medium' -Evaluate {
            param($Context)
            $scope = Get-AxHybridScopeMetadata -Context $Context
            $dataset = Get-AxHybridContextDataset -Context $Context -Name 'GpoBaseline'
            $driftCount = [int]($dataset.BaselineDriftCount ?? 0)
            $unlinkedHardenedGpos = [int]($dataset.UnlinkedSecurityGpoCount ?? 0)
            $severity = if ($driftCount -gt 10 -or $unlinkedHardenedGpos -gt 0) { 'High' } elseif ($driftCount -gt 0) { 'Medium' } else { 'Low' }

            New-AxHybridFinding -FindingId 'AX-HY-GPO-001' -Category 'ConfigurationBaseline' -Scope "$($scope.ScopeType):$($scope.Scope)" -Severity $severity -Likelihood 'Medium' -Impact 'High' -Title 'GPO baseline drift requires validation' -Description "Baseline drift findings: $driftCount. Unlinked hardened GPOs: $unlinkedHardenedGpos." -Evidence @([pscustomobject]@{ Source = 'GpoBaselineFixture'; BaselineDriftCount = $driftCount; UnlinkedSecurityGpoCount = $unlinkedHardenedGpos; LabOnly = $true }) -Recommendation 'Review baseline drift, validate intended exceptions, and ensure hardened GPOs are linked and applied as expected.' -Source @{ Connector = 'HybridLocal'; RuleId = 'AX-HY-GPO-001'; Pack = 'Hybrid'; Area = 'GpoBaseline' }
        }
        New-AxAssessmentRule -RuleId 'AX-HY-SYNC-001' -Name 'Hybrid identity sync posture indicators' -AssessmentPack 'Hybrid' -Service 'Hybrid / On-Prem' -Description 'Evaluates Microsoft Entra Connect or hybrid identity sync posture indicators.' -DefaultSeverity 'High' -Evaluate {
            param($Context)
            $scope = Get-AxHybridScopeMetadata -Context $Context
            $dataset = Get-AxHybridContextDataset -Context $Context -Name 'HybridIdentity'
            $syncErrors = [int]($dataset.SyncErrorCount ?? 0)
            $staging = [bool]($dataset.StagingServerPresent ?? $false)
            $severity = if ($syncErrors -gt 0 -or -not $staging) { 'High' } elseif ($syncErrors -eq 0) { 'Low' } else { 'Medium' }

            New-AxHybridFinding -FindingId 'AX-HY-SYNC-001' -Category 'HybridIdentity' -Scope "$($scope.ScopeType):$($scope.Scope)" -Severity $severity -Likelihood 'Medium' -Impact 'High' -Title 'Hybrid identity sync posture needs review' -Description "Sync errors: $syncErrors. Staging server present: $staging." -Evidence @([pscustomobject]@{ Source = 'HybridIdentityFixture'; SyncErrorCount = $syncErrors; StagingServerPresent = $staging; CollectionMode = $scope.Mode }) -Recommendation 'Investigate sync errors, review connector health, and confirm staging or recovery capability for hybrid identity synchronization.' -Source @{ Connector = 'HybridLocal'; RuleId = 'AX-HY-SYNC-001'; Pack = 'Hybrid'; Area = 'HybridIdentity' }
        }
        New-AxAssessmentRule -RuleId 'AX-HY-ADCS-001' -Name 'Optional AD CS posture indicators' -AssessmentPack 'Hybrid' -Service 'Hybrid / On-Prem' -Description 'Evaluates optional AD CS posture indicators when support is enabled.' -DefaultSeverity 'Medium' -Evaluate {
            param($Context)
            $scope = Get-AxHybridScopeMetadata -Context $Context
            $dataset = Get-AxHybridContextDataset -Context $Context -Name 'Adcs'
            $supported = [bool]($dataset.SupportAdded ?? $false)
            $weakTemplates = [int]($dataset.WeakTemplateCount ?? 0)
            $severity = if (-not $supported) { 'Informational' } elseif ($weakTemplates -gt 0) { 'High' } else { 'Low' }
            $description = if (-not $supported) {
                'AD CS posture checks are optional and remain lab-only or unavailable in the current scope.'
            }
            else {
                "Weak AD CS templates detected: $weakTemplates."
            }

            New-AxHybridFinding -FindingId 'AX-HY-ADCS-001' -Category 'CertificateServices' -Scope "$($scope.ScopeType):$($scope.Scope)" -Severity $severity -Likelihood ($(if ($supported) { 'Medium' } else { 'Informational' })) -Impact 'High' -Title 'Optional AD CS posture indicators require follow-up' -Description $description -Evidence @([pscustomobject]@{ Source = 'AdcsFixture'; SupportAdded = $supported; WeakTemplateCount = $weakTemplates; OptionalCheck = $true; LabOnly = $true }) -Recommendation 'If AD CS is in scope, review certificate template exposure, enrollment rights, and escalation pathways using read-only collection.' -Source @{ Connector = 'HybridLocal'; RuleId = 'AX-HY-ADCS-001'; Pack = 'Hybrid'; Area = 'Adcs' }
        }
        New-AxAssessmentRule -RuleId 'AX-HY-EXH-001' -Name 'Optional Exchange hybrid or on-prem indicators' -AssessmentPack 'Hybrid' -Service 'Hybrid / On-Prem' -Description 'Evaluates optional Exchange hybrid or on-prem indicators when support is enabled.' -DefaultSeverity 'Medium' -Evaluate {
            param($Context)
            $scope = Get-AxHybridScopeMetadata -Context $Context
            $dataset = Get-AxHybridContextDataset -Context $Context -Name 'ExchangeHybrid'
            $supported = [bool]($dataset.SupportAdded ?? $false)
            $insecureVirtualDirs = [int]($dataset.InsecureVirtualDirectoryCount ?? 0)
            $severity = if (-not $supported) { 'Informational' } elseif ($insecureVirtualDirs -gt 0) { 'High' } else { 'Low' }
            $description = if (-not $supported) {
                'Exchange hybrid or on-prem posture checks are optional and remain unavailable in the current fixture-backed scope.'
            }
            else {
                "Insecure Exchange virtual directory indicators: $insecureVirtualDirs."
            }

            New-AxHybridFinding -FindingId 'AX-HY-EXH-001' -Category 'MessagingHybrid' -Scope "$($scope.ScopeType):$($scope.Scope)" -Severity $severity -Likelihood ($(if ($supported) { 'Medium' } else { 'Informational' })) -Impact 'High' -Title 'Optional Exchange hybrid indicators should be reviewed if in scope' -Description $description -Evidence @([pscustomobject]@{ Source = 'ExchangeHybridFixture'; SupportAdded = $supported; InsecureVirtualDirectoryCount = $insecureVirtualDirs; OptionalCheck = $true; LabOnly = $true }) -Recommendation 'If Exchange hybrid or on-prem remains in scope, validate exposed virtual directories, authentication posture, and hybrid transport assumptions.' -Source @{ Connector = 'HybridLocal'; RuleId = 'AX-HY-EXH-001'; Pack = 'Hybrid'; Area = 'ExchangeHybrid' }
        }
    )

    if ([string]::IsNullOrWhiteSpace($Area)) {
        return $rules
    }

    $rules | Where-Object { $_.RuleId -like "AX-HY-$Area*" -or $_.Name -like "*$Area*" }
}
