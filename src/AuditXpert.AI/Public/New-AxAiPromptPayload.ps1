function New-AxAiPromptPayload {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [psobject[]]$Finding,

        [Parameter()]
        [psobject[]]$RiskRegister = @(),

        [Parameter()]
        [psobject[]]$Scorecard = @(),

        [Parameter()]
        [switch]$DisableAI
    )

    $sections = Get-AxAiPromptSections -Finding $Finding -RiskRegister $RiskRegister -Scorecard $Scorecard

    [pscustomobject]@{
        Enabled      = (-not $DisableAI)
        Label        = if ($DisableAI) { 'AI disabled' } else { 'AI-assisted content requires review' }
        SystemPrompt = 'Generate enterprise assessment narrative from normalized findings and governance outputs. Every narrative section must reference finding IDs. Do not present generated text as evidence.'
        UserPayload  = [pscustomobject]@{
            TraceabilityRequirement = 'Every major statement must cite one or more FindingId values.'
            RawEvidencePolicy       = 'Do not restate raw evidence as AI certainty; evidence stays in technical findings.'
            Findings                = $Finding
            RiskRegister            = $RiskRegister
            Scorecard               = $Scorecard
            Sections                = $sections
        }
    }
}
