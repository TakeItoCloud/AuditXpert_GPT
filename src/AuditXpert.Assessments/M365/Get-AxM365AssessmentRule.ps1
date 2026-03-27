function Get-AxM365AssessmentRule {
    [CmdletBinding()]
    param(
        [Parameter()]
        [string]$Area
    )

    $rules = @(
        New-AxAssessmentRule -RuleId 'AX-M365-ENTRA-001' -Name 'Entra ID identity posture coverage' -AssessmentPack 'Microsoft365' -Service 'Microsoft 365' -Description 'Evaluates identity posture using tenant-level Entra ID indicators.' -DefaultSeverity 'High' -Evaluate {
            param($Context)
            $scope = $Context.Scope ?? 'Tenant'
            $dataset = Get-AxM365ContextDataset -Context $Context -Name 'EntraId'
            $coverage = Get-AxM365PermissionCoverage -Context $Context -ServiceArea 'EntraId'
            $mfaPercent = [double]($dataset.MFARegisteredPercent ?? 0)

            New-AxM365Finding -FindingId 'AX-M365-ENTRA-001' -Category 'Identity' -Scope $scope -Severity ($(if ($mfaPercent -lt 60) { 'High' } elseif ($mfaPercent -lt 85) { 'Medium' } else { 'Low' })) -Likelihood 'Medium' -Impact 'High' -Title 'Entra ID MFA registration posture requires review' -Description "MFA registration is $mfaPercent percent for the scoped Microsoft 365 tenant. Permission coverage: $coverage." -Evidence @([pscustomobject]@{ Source = 'EntraIdFixture'; Metric = 'MFARegisteredPercent'; Value = $mfaPercent; PermissionCoverage = $coverage }) -Recommendation 'Review registration campaigns, excluded user populations, and authentication method rollout coverage.' -Source @{ Connector = 'MicrosoftGraph'; RuleId = 'AX-M365-ENTRA-001'; Pack = 'Microsoft365'; Area = 'EntraId' }
        }
        New-AxAssessmentRule -RuleId 'AX-M365-CA-001' -Name 'Conditional Access and MFA enforcement' -AssessmentPack 'Microsoft365' -Service 'Microsoft 365' -Description 'Evaluates Conditional Access coverage and MFA enforcement indicators.' -DefaultSeverity 'High' -Evaluate {
            param($Context)
            $scope = $Context.Scope ?? 'Tenant'
            $dataset = Get-AxM365ContextDataset -Context $Context -Name 'ConditionalAccess'
            $coverage = Get-AxM365PermissionCoverage -Context $Context -ServiceArea 'ConditionalAccess'
            $policyCount = [int]($dataset.PolicyCount ?? 0)
            $protectedApps = [double]($dataset.ProtectedAppsPercent ?? 0)

            New-AxM365Finding -FindingId 'AX-M365-CA-001' -Category 'Identity' -Scope $scope -Severity ($(if ($policyCount -eq 0 -or $protectedApps -lt 60) { 'High' } elseif ($protectedApps -lt 85) { 'Medium' } else { 'Low' })) -Likelihood 'High' -Impact 'High' -Title 'Conditional Access coverage does not meet target enforcement levels' -Description "Conditional Access policy count: $policyCount. Protected application coverage: $protectedApps percent. Permission coverage: $coverage." -Evidence @([pscustomobject]@{ Source = 'ConditionalAccessFixture'; Metric = 'ProtectedAppsPercent'; Value = $protectedApps; PolicyCount = $policyCount; PermissionCoverage = $coverage }) -Recommendation 'Review policy coverage for privileged access, modern authentication apps, and MFA enforcement gaps.' -Source @{ Connector = 'MicrosoftGraph'; RuleId = 'AX-M365-CA-001'; Pack = 'Microsoft365'; Area = 'ConditionalAccess' }
        }
        New-AxAssessmentRule -RuleId 'AX-M365-LEGACY-001' -Name 'Legacy authentication exposure' -AssessmentPack 'Microsoft365' -Service 'Microsoft 365' -Description 'Identifies indicators of legacy authentication exposure where data is available.' -DefaultSeverity 'High' -Evaluate {
            param($Context)
            $scope = $Context.Scope ?? 'Tenant'
            $dataset = Get-AxM365ContextDataset -Context $Context -Name 'LegacyAuth'
            $coverage = Get-AxM365PermissionCoverage -Context $Context -ServiceArea 'LegacyAuth'
            $protocolsEnabled = [int]($dataset.EnabledProtocolCount ?? 0)
            $unsupported = [bool]($dataset.UnsupportedSurface ?? $false)
            $severity = if ($unsupported) { 'Informational' } elseif ($protocolsEnabled -gt 0) { 'High' } else { 'Low' }
            $description = if ($unsupported) {
                "Legacy authentication data is only partially available through approved connectors in this phase. Permission coverage: $coverage."
            }
            else {
                "Legacy authentication protocol indicators enabled: $protocolsEnabled. Permission coverage: $coverage."
            }

            New-AxM365Finding -FindingId 'AX-M365-LEGACY-001' -Category 'Identity' -Scope $scope -Severity $severity -Likelihood ($(if ($protocolsEnabled -gt 0) { 'High' } else { 'Low' })) -Impact 'High' -Title 'Legacy authentication exposure requires validation' -Description $description -Evidence @([pscustomobject]@{ Source = 'LegacyAuthFixture'; Metric = 'EnabledProtocolCount'; Value = $protocolsEnabled; UnsupportedSurface = $unsupported; PermissionCoverage = $coverage }) -Recommendation 'Confirm legacy authentication blocking coverage and document any unsupported protocol visibility in the assessment scope.' -Source @{ Connector = 'MicrosoftGraph'; RuleId = 'AX-M365-LEGACY-001'; Pack = 'Microsoft365'; Area = 'LegacyAuth' }
        }
        New-AxAssessmentRule -RuleId 'AX-M365-ADMIN-001' -Name 'Administrative role hygiene' -AssessmentPack 'Microsoft365' -Service 'Microsoft 365' -Description 'Evaluates privileged role assignment hygiene indicators.' -DefaultSeverity 'High' -Evaluate {
            param($Context)
            $scope = $Context.Scope ?? 'Tenant'
            $dataset = Get-AxM365ContextDataset -Context $Context -Name 'AdminRoles'
            $coverage = Get-AxM365PermissionCoverage -Context $Context -ServiceArea 'AdminRoles'
            $standingAdmins = [int]($dataset.StandingPrivilegedAdmins ?? 0)
            $pimCoverage = [double]($dataset.PIMCoveragePercent ?? 0)

            New-AxM365Finding -FindingId 'AX-M365-ADMIN-001' -Category 'PrivilegedAccess' -Scope $scope -Severity ($(if ($standingAdmins -gt 5 -or $pimCoverage -lt 50) { 'High' } elseif ($standingAdmins -gt 0 -or $pimCoverage -lt 80) { 'Medium' } else { 'Low' })) -Likelihood 'Medium' -Impact 'High' -Title 'Privileged administrative role hygiene can be improved' -Description "Standing privileged admins: $standingAdmins. PIM coverage: $pimCoverage percent. Permission coverage: $coverage." -Evidence @([pscustomobject]@{ Source = 'AdminRolesFixture'; StandingPrivilegedAdmins = $standingAdmins; PIMCoveragePercent = $pimCoverage; PermissionCoverage = $coverage }) -Recommendation 'Review standing privileged assignments, reduce permanent role membership, and strengthen just-in-time role activation coverage.' -Source @{ Connector = 'MicrosoftGraph'; RuleId = 'AX-M365-ADMIN-001'; Pack = 'Microsoft365'; Area = 'AdminRoles' }
        }
        New-AxAssessmentRule -RuleId 'AX-M365-INTUNE-001' -Name 'Intune baseline and policy conflict posture' -AssessmentPack 'Microsoft365' -Service 'Microsoft 365' -Description 'Evaluates Intune security baseline assignment and device policy conflict indicators.' -DefaultSeverity 'Medium' -Evaluate {
            param($Context)
            $scope = $Context.Scope ?? 'Tenant'
            $dataset = Get-AxM365ContextDataset -Context $Context -Name 'Intune'
            $coverage = Get-AxM365PermissionCoverage -Context $Context -ServiceArea 'Intune'
            $baselineAssigned = [bool]($dataset.SecurityBaselineAssigned ?? $false)
            $policyConflicts = [int]($dataset.PolicyConflictCount ?? 0)

            New-AxM365Finding -FindingId 'AX-M365-INTUNE-001' -Category 'EndpointManagement' -Scope $scope -Severity ($(if (-not $baselineAssigned -or $policyConflicts -gt 10) { 'High' } elseif ($policyConflicts -gt 0) { 'Medium' } else { 'Low' })) -Likelihood 'Medium' -Impact 'Medium' -Title 'Intune policy baseline and conflict posture needs review' -Description "Security baseline assigned: $baselineAssigned. Policy conflicts: $policyConflicts. Permission coverage: $coverage." -Evidence @([pscustomobject]@{ Source = 'IntuneFixture'; SecurityBaselineAssigned = $baselineAssigned; PolicyConflictCount = $policyConflicts; PermissionCoverage = $coverage }) -Recommendation 'Validate security baseline rollout and reduce conflicting device configuration or compliance policies.' -Source @{ Connector = 'MicrosoftGraph'; RuleId = 'AX-M365-INTUNE-001'; Pack = 'Microsoft365'; Area = 'Intune' }
        }
        New-AxAssessmentRule -RuleId 'AX-M365-EXO-001' -Name 'Exchange Online mail flow and protection posture' -AssessmentPack 'Microsoft365' -Service 'Microsoft 365' -Description 'Evaluates Exchange Online protection and mail flow indicators.' -DefaultSeverity 'High' -Evaluate {
            param($Context)
            $scope = $Context.Scope ?? 'Tenant'
            $dataset = Get-AxM365ContextDataset -Context $Context -Name 'ExchangeOnline'
            $coverage = Get-AxM365PermissionCoverage -Context $Context -ServiceArea 'ExchangeOnline'
            $antiPhish = [bool]($dataset.AntiPhishEnabled ?? $false)
            $safeLinks = [bool]($dataset.SafeLinksEnabled ?? $false)
            $anonymousConnectors = [int]($dataset.AnonymousInboundConnectorCount ?? 0)

            $severity = if (-not $antiPhish -or -not $safeLinks -or $anonymousConnectors -gt 0) { 'High' } else { 'Low' }
            New-AxM365Finding -FindingId 'AX-M365-EXO-001' -Category 'MessagingSecurity' -Scope $scope -Severity $severity -Likelihood 'Medium' -Impact 'High' -Title 'Exchange Online protection posture requires validation' -Description "Anti-phish enabled: $antiPhish. Safe Links enabled: $safeLinks. Anonymous inbound connectors: $anonymousConnectors. Permission coverage: $coverage." -Evidence @([pscustomobject]@{ Source = 'ExchangeFixture'; AntiPhishEnabled = $antiPhish; SafeLinksEnabled = $safeLinks; AnonymousInboundConnectorCount = $anonymousConnectors; PermissionCoverage = $coverage }) -Recommendation 'Review anti-phish, Safe Links, and inbound connector exposure to align mail flow protections with the target baseline.' -Source @{ Connector = 'ExchangeOnline'; RuleId = 'AX-M365-EXO-001'; Pack = 'Microsoft365'; Area = 'ExchangeOnline' }
        }
        New-AxAssessmentRule -RuleId 'AX-M365-MDE-001' -Name 'Defender-related posture indicators' -AssessmentPack 'Microsoft365' -Service 'Microsoft 365' -Description 'Evaluates approved Defender-related posture feeds available through current connectors.' -DefaultSeverity 'Medium' -Evaluate {
            param($Context)
            $scope = $Context.Scope ?? 'Tenant'
            $dataset = Get-AxM365ContextDataset -Context $Context -Name 'Defender'
            $coverage = Get-AxM365PermissionCoverage -Context $Context -ServiceArea 'Defender'
            $exposureLevel = [string]($dataset.ExposureLevel ?? 'Unknown')
            $recommendationCompletion = [double]($dataset.RecommendationCompletionPercent ?? 0)
            $unsupported = [bool]($dataset.UnsupportedSurface ?? $false)
            $severity = if ($unsupported) { 'Informational' } elseif ($exposureLevel -eq 'High' -or $recommendationCompletion -lt 50) { 'High' } elseif ($exposureLevel -eq 'Medium' -or $recommendationCompletion -lt 75) { 'Medium' } else { 'Low' }

            New-AxM365Finding -FindingId 'AX-M365-MDE-001' -Category 'ThreatProtection' -Scope $scope -Severity $severity -Likelihood 'Medium' -Impact 'High' -Title 'Defender posture indicators highlight follow-up actions' -Description "Exposure level: $exposureLevel. Recommendation completion: $recommendationCompletion percent. Unsupported surface documented: $unsupported. Permission coverage: $coverage." -Evidence @([pscustomobject]@{ Source = 'DefenderFixture'; ExposureLevel = $exposureLevel; RecommendationCompletionPercent = $recommendationCompletion; UnsupportedSurface = $unsupported; PermissionCoverage = $coverage }) -Recommendation 'Use approved Defender feeds to validate uncovered recommendations and document any unsupported surfaces explicitly in the client report.' -Source @{ Connector = 'MicrosoftGraph'; RuleId = 'AX-M365-MDE-001'; Pack = 'Microsoft365'; Area = 'Defender' }
        }
        New-AxAssessmentRule -RuleId 'AX-M365-SS-001' -Name 'Microsoft Secure Score translation' -AssessmentPack 'Microsoft365' -Service 'Microsoft 365' -Description 'Translates Microsoft Secure Score posture into normalized findings.' -DefaultSeverity 'Medium' -Evaluate {
            param($Context)
            $scope = $Context.Scope ?? 'Tenant'
            $dataset = Get-AxM365ContextDataset -Context $Context -Name 'SecureScore'
            $coverage = Get-AxM365PermissionCoverage -Context $Context -ServiceArea 'SecureScore'
            $current = [double]($dataset.CurrentScore ?? 0)
            $maximum = [double]($dataset.MaxScore ?? 100)
            $ratio = if ($maximum -gt 0) { [math]::Round(($current / $maximum) * 100, 2) } else { 0 }
            $topActions = @($dataset.TopImprovementActions)
            $severity = if ($ratio -lt 40) { 'High' } elseif ($ratio -lt 70) { 'Medium' } else { 'Low' }

            New-AxM365Finding -FindingId 'AX-M365-SS-001' -Category 'SecurityPosture' -Scope $scope -Severity $severity -Likelihood 'Medium' -Impact 'Medium' -Title 'Secure Score indicates remaining Microsoft 365 control gaps' -Description "Current Secure Score is $current of $maximum ($ratio percent). Permission coverage: $coverage." -Evidence @([pscustomobject]@{ Source = 'SecureScoreFixture'; CurrentScore = $current; MaxScore = $maximum; RatioPercent = $ratio; TopImprovementActions = $topActions; PermissionCoverage = $coverage }) -Recommendation 'Review the highest-value Secure Score improvement actions and translate them into prioritized remediation workstreams.' -Source @{ Connector = 'MicrosoftGraph'; RuleId = 'AX-M365-SS-001'; Pack = 'Microsoft365'; Area = 'SecureScore' }
        }
    )

    if ([string]::IsNullOrWhiteSpace($Area)) {
        return $rules
    }

    $rules | Where-Object { $_.RuleId -like "AX-M365-$Area*" -or $_.Name -like "*$Area*" }
}
