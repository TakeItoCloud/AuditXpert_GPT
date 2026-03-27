function Get-AxAzureAssessmentRule {
    [CmdletBinding()]
    param(
        [Parameter()]
        [string]$Area
    )

    $rules = @(
        New-AxAssessmentRule -RuleId 'AX-AZ-INV-001' -Name 'Subscription and management group inventory' -AssessmentPack 'Azure' -Service 'Azure' -Description 'Evaluates baseline Azure inventory and scope coverage.' -DefaultSeverity 'Low' -Evaluate {
            param($Context)
            $scope = Get-AxAzureScopeMetadata -Context $Context
            $dataset = Get-AxAzureContextDataset -Context $Context -Name 'Inventory'
            $subs = [int]($dataset.SubscriptionCount ?? 0)
            $mgs = [int]($dataset.ManagementGroupCount ?? 0)
            $unassigned = [int]($dataset.UnassignedSubscriptionCount ?? 0)
            $severity = if ($unassigned -gt 0) { 'Medium' } else { 'Low' }

            New-AxAzureFinding -FindingId 'AX-AZ-INV-001' -Category 'Governance' -Scope "$($scope.ScopeType):$($scope.Scope)" -Severity $severity -Likelihood 'Low' -Impact 'Medium' -Title 'Azure inventory and scope hierarchy requires review' -Description "Subscriptions discovered: $subs. Management groups discovered: $mgs. Unassigned subscriptions: $unassigned. Resource type filter: $($scope.ResourceType)." -Evidence @([pscustomobject]@{ Source = 'AzureInventoryFixture'; SubscriptionCount = $subs; ManagementGroupCount = $mgs; UnassignedSubscriptionCount = $unassigned; ScopeType = $scope.ScopeType }) -Recommendation 'Validate management group alignment, subscription placement, and scope ownership across the Azure estate.' -Source @{ Connector = 'Azure'; RuleId = 'AX-AZ-INV-001'; Pack = 'Azure'; Area = 'Inventory' }
        }
        New-AxAssessmentRule -RuleId 'AX-AZ-POL-001' -Name 'Azure Policy and initiative compliance indicators' -AssessmentPack 'Azure' -Service 'Azure' -Description 'Evaluates Azure Policy and initiative compliance posture.' -DefaultSeverity 'High' -Evaluate {
            param($Context)
            $scope = Get-AxAzureScopeMetadata -Context $Context
            $dataset = Get-AxAzureContextDataset -Context $Context -Name 'Policy'
            $compliance = [double]($dataset.CompliancePercent ?? 0)
            $nonCompliant = [int]($dataset.NonCompliantResourceCount ?? 0)
            $severity = if ($compliance -lt 70 -or $nonCompliant -gt 25) { 'High' } elseif ($compliance -lt 90 -or $nonCompliant -gt 0) { 'Medium' } else { 'Low' }

            New-AxAzureFinding -FindingId 'AX-AZ-POL-001' -Category 'Governance' -Scope "$($scope.ScopeType):$($scope.Scope)" -Severity $severity -Likelihood 'Medium' -Impact 'High' -Title 'Azure Policy compliance requires remediation planning' -Description "Compliance is $compliance percent with $nonCompliant non-compliant resources in the current scope." -Evidence @([pscustomobject]@{ Source = 'AzurePolicyFixture'; CompliancePercent = $compliance; NonCompliantResourceCount = $nonCompliant; ScopeType = $scope.ScopeType }) -Recommendation 'Review policy assignments, exemptions, and remediation ownership for the non-compliant resource population.' -Source @{ Connector = 'Azure'; RuleId = 'AX-AZ-POL-001'; Pack = 'Azure'; Area = 'Policy' }
        }
        New-AxAssessmentRule -RuleId 'AX-AZ-DFC-001' -Name 'Defender for Cloud recommendation ingestion' -AssessmentPack 'Azure' -Service 'Azure' -Description 'Translates Defender for Cloud recommendations into normalized findings.' -DefaultSeverity 'High' -Evaluate {
            param($Context)
            $scope = Get-AxAzureScopeMetadata -Context $Context
            $dataset = Get-AxAzureContextDataset -Context $Context -Name 'DefenderForCloud'
            $highRecommendations = [int]($dataset.HighSeverityRecommendationCount ?? 0)
            $nativeRecommendationId = [string]($dataset.NativeRecommendationId ?? 'N/A')
            $severity = if ($highRecommendations -gt 0) { 'High' } else { 'Low' }

            New-AxAzureFinding -FindingId 'AX-AZ-DFC-001' -Category 'SecurityPosture' -Scope "$($scope.ScopeType):$($scope.Scope)" -Severity $severity -Likelihood 'Medium' -Impact 'High' -Title 'Defender for Cloud recommendations indicate unresolved Azure risks' -Description "High-severity Defender for Cloud recommendations: $highRecommendations. Native recommendation link preserved for traceability." -Evidence @([pscustomobject]@{ Source = 'DefenderForCloudFixture'; HighSeverityRecommendationCount = $highRecommendations; NativeRecommendationId = $nativeRecommendationId; NativePortalLink = $dataset.NativePortalLink }) -Recommendation 'Review Defender for Cloud recommendations and map ownership for the highest-severity outstanding items.' -Source @{ Connector = 'Azure'; RuleId = 'AX-AZ-DFC-001'; Pack = 'Azure'; Area = 'DefenderForCloud'; NativeRecommendationId = $nativeRecommendationId }
        }
        New-AxAssessmentRule -RuleId 'AX-AZ-ADV-001' -Name 'Azure Advisor recommendation ingestion' -AssessmentPack 'Azure' -Service 'Azure' -Description 'Translates Azure Advisor recommendations into normalized findings.' -DefaultSeverity 'Medium' -Evaluate {
            param($Context)
            $scope = Get-AxAzureScopeMetadata -Context $Context
            $dataset = Get-AxAzureContextDataset -Context $Context -Name 'Advisor'
            $critical = [int]($dataset.CriticalRecommendationCount ?? 0)
            $nativeRecommendationId = [string]($dataset.NativeRecommendationId ?? 'N/A')
            $severity = if ($critical -gt 0) { 'Medium' } else { 'Low' }

            New-AxAzureFinding -FindingId 'AX-AZ-ADV-001' -Category 'Optimization' -Scope "$($scope.ScopeType):$($scope.Scope)" -Severity $severity -Likelihood 'Low' -Impact 'Medium' -Title 'Azure Advisor recommendations highlight optimization work' -Description "Critical Azure Advisor recommendations: $critical. Native recommendation link preserved for source traceability." -Evidence @([pscustomobject]@{ Source = 'AzureAdvisorFixture'; CriticalRecommendationCount = $critical; NativeRecommendationId = $nativeRecommendationId; NativePortalLink = $dataset.NativePortalLink }) -Recommendation 'Review Azure Advisor recommendations across cost, security, reliability, and operational excellence categories.' -Source @{ Connector = 'Azure'; RuleId = 'AX-AZ-ADV-001'; Pack = 'Azure'; Area = 'Advisor'; NativeRecommendationId = $nativeRecommendationId }
        }
        New-AxAssessmentRule -RuleId 'AX-AZ-VM-001' -Name 'Virtual machine posture indicators' -AssessmentPack 'Azure' -Service 'Azure' -Description 'Evaluates Azure VM posture indicators for patching and managed identity coverage.' -DefaultSeverity 'Medium' -Evaluate {
            param($Context)
            $scope = Get-AxAzureScopeMetadata -Context $Context
            $dataset = Get-AxAzureContextDataset -Context $Context -Name 'Compute'
            $unpatched = [int]($dataset.UnpatchedVmCount ?? 0)
            $missingIdentity = [int]($dataset.VmWithoutManagedIdentityCount ?? 0)
            $severity = if ($unpatched -gt 5 -or $missingIdentity -gt 5) { 'High' } elseif ($unpatched -gt 0 -or $missingIdentity -gt 0) { 'Medium' } else { 'Low' }

            New-AxAzureFinding -FindingId 'AX-AZ-VM-001' -Category 'ComputeSecurity' -Scope "$($scope.ScopeType):$($scope.Scope)" -Severity $severity -Likelihood 'Medium' -Impact 'High' -Title 'Azure VM posture indicators require remediation tracking' -Description "Unpatched VMs: $unpatched. VMs without managed identity: $missingIdentity." -Evidence @([pscustomobject]@{ Source = 'AzureComputeFixture'; UnpatchedVmCount = $unpatched; VmWithoutManagedIdentityCount = $missingIdentity; BatchMode = 'FixtureCompatible' }) -Recommendation 'Review VM patch compliance, identity usage, and extension hygiene for the scoped Azure compute estate.' -Source @{ Connector = 'Azure'; RuleId = 'AX-AZ-VM-001'; Pack = 'Azure'; Area = 'Compute' }
        }
        New-AxAssessmentRule -RuleId 'AX-AZ-NET-001' -Name 'Virtual network and NSG exposure indicators' -AssessmentPack 'Azure' -Service 'Azure' -Description 'Evaluates Azure networking exposure through NSGs and public ingress indicators.' -DefaultSeverity 'High' -Evaluate {
            param($Context)
            $scope = Get-AxAzureScopeMetadata -Context $Context
            $dataset = Get-AxAzureContextDataset -Context $Context -Name 'Networking'
            $internetOpen = [int]($dataset.InternetExposedRuleCount ?? 0)
            $unattachedNsgs = [int]($dataset.UnattachedNsgCount ?? 0)
            $severity = if ($internetOpen -gt 0) { 'High' } elseif ($unattachedNsgs -gt 0) { 'Medium' } else { 'Low' }

            New-AxAzureFinding -FindingId 'AX-AZ-NET-001' -Category 'NetworkSecurity' -Scope "$($scope.ScopeType):$($scope.Scope)" -Severity $severity -Likelihood 'High' -Impact 'High' -Title 'Azure network exposure indicators warrant follow-up' -Description "Internet-exposed NSG rules: $internetOpen. Unattached NSGs: $unattachedNsgs. Resource type filter: $($scope.ResourceType)." -Evidence @([pscustomobject]@{ Source = 'AzureNetworkingFixture'; InternetExposedRuleCount = $internetOpen; UnattachedNsgCount = $unattachedNsgs; ScopeType = $scope.ScopeType }) -Recommendation 'Validate inbound exposure, remove unused NSGs, and tighten overly broad network security rules.' -Source @{ Connector = 'Azure'; RuleId = 'AX-AZ-NET-001'; Pack = 'Azure'; Area = 'Networking' }
        }
        New-AxAssessmentRule -RuleId 'AX-AZ-DIAG-001' -Name 'Diagnostic settings and logging coverage' -AssessmentPack 'Azure' -Service 'Azure' -Description 'Evaluates diagnostic settings and monitoring coverage in the selected Azure scope.' -DefaultSeverity 'Medium' -Evaluate {
            param($Context)
            $scope = Get-AxAzureScopeMetadata -Context $Context
            $dataset = Get-AxAzureContextDataset -Context $Context -Name 'Monitoring'
            $coverage = [double]($dataset.DiagnosticCoveragePercent ?? 0)
            $workspaceLinked = [bool]($dataset.LogAnalyticsLinked ?? $false)
            $severity = if ($coverage -lt 60 -or -not $workspaceLinked) { 'High' } elseif ($coverage -lt 90) { 'Medium' } else { 'Low' }

            New-AxAzureFinding -FindingId 'AX-AZ-DIAG-001' -Category 'Monitoring' -Scope "$($scope.ScopeType):$($scope.Scope)" -Severity $severity -Likelihood 'Medium' -Impact 'High' -Title 'Azure diagnostic settings coverage is below target' -Description "Diagnostic settings coverage is $coverage percent. Log Analytics linkage present: $workspaceLinked." -Evidence @([pscustomobject]@{ Source = 'AzureMonitoringFixture'; DiagnosticCoveragePercent = $coverage; LogAnalyticsLinked = $workspaceLinked; PaginationPattern = 'ScopeAware' }) -Recommendation 'Increase diagnostic settings coverage for critical resource types and validate log routing into centralized monitoring.' -Source @{ Connector = 'Azure'; RuleId = 'AX-AZ-DIAG-001'; Pack = 'Azure'; Area = 'Monitoring' }
        }
        New-AxAssessmentRule -RuleId 'AX-AZ-RES-001' -Name 'Key Vault, storage, backup, and resilience indicators' -AssessmentPack 'Azure' -Service 'Azure' -Description 'Evaluates resilience-related Azure controls across key resources.' -DefaultSeverity 'Medium' -Evaluate {
            param($Context)
            $scope = Get-AxAzureScopeMetadata -Context $Context
            $dataset = Get-AxAzureContextDataset -Context $Context -Name 'Resilience'
            $vaultsWithoutSoftDelete = [int]($dataset.KeyVaultWithoutSoftDeleteCount ?? 0)
            $storageWithoutVersioning = [int]($dataset.StorageWithoutVersioningCount ?? 0)
            $unprotectedVmCount = [int]($dataset.VmWithoutBackupCount ?? 0)
            $severity = if ($vaultsWithoutSoftDelete -gt 0 -or $storageWithoutVersioning -gt 0 -or $unprotectedVmCount -gt 0) { 'High' } else { 'Low' }

            New-AxAzureFinding -FindingId 'AX-AZ-RES-001' -Category 'Resilience' -Scope "$($scope.ScopeType):$($scope.Scope)" -Severity $severity -Likelihood 'Medium' -Impact 'High' -Title 'Azure resilience controls require follow-up' -Description "Key Vaults without soft delete: $vaultsWithoutSoftDelete. Storage accounts without versioning: $storageWithoutVersioning. VMs without backup: $unprotectedVmCount." -Evidence @([pscustomobject]@{ Source = 'AzureResilienceFixture'; KeyVaultWithoutSoftDeleteCount = $vaultsWithoutSoftDelete; StorageWithoutVersioningCount = $storageWithoutVersioning; VmWithoutBackupCount = $unprotectedVmCount; BatchingPattern = 'SubscriptionScoped' }) -Recommendation 'Review backup coverage, Key Vault retention protections, and storage resilience settings for critical workloads.' -Source @{ Connector = 'Azure'; RuleId = 'AX-AZ-RES-001'; Pack = 'Azure'; Area = 'Resilience' }
        }
    )

    if ([string]::IsNullOrWhiteSpace($Area)) {
        return $rules
    }

    $rules | Where-Object { $_.RuleId -like "AX-AZ-$Area*" -or $_.Name -like "*$Area*" }
}
