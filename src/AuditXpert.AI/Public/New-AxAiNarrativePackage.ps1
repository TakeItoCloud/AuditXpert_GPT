function New-AxAiNarrativePackage {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [psobject[]]$Finding,

        [Parameter()]
        [psobject[]]$RiskRegister = @(),

        [Parameter()]
        [psobject[]]$Scorecard = @(),

        [Parameter()]
        [ValidateSet(
            'executive-summary',
            'technical-assessment',
            'governance-vciso',
            'azure-assessment',
            'microsoft365-assessment',
            'hybrid-infrastructure',
            'remediation-roadmap',
            'service-specific-appendix'
        )]
        [string]$ReportType = 'executive-summary',

        [Parameter()]
        [switch]$DisableAI,

        [Parameter()]
        [string]$EnvironmentVariable = 'AUDITXPERT_OPENAI_API_KEY',

        [Parameter()]
        [string]$ExternalConfigPath
    )

    $payload = New-AxAiPromptPayload -Finding $Finding -RiskRegister $RiskRegister -Scorecard $Scorecard -ReportType $ReportType -DisableAI:$DisableAI
    $apiKey = if ($DisableAI) { $null } else { Get-AxAiApiKey -EnvironmentVariable $EnvironmentVariable -ExternalConfigPath $ExternalConfigPath }

    [pscustomobject]@{
        AIEnabled      = (-not $DisableAI)
        ApiKeyResolved = (-not [string]::IsNullOrWhiteSpace($apiKey))
        ReportType     = $ReportType
        PromptPayload  = $payload
        NarrativeLabel = if ($DisableAI) { 'Non-AI reporting only' } else { 'AI-assisted narrative must be reviewed by the assessor' }
        Traceability   = @($Finding | Select-Object -ExpandProperty FindingId)
        ExpectedSections = @($payload.UserPayload.SectionPlan | Where-Object { $_.AIControlled } | Select-Object -ExpandProperty SectionKey)
    }
}
