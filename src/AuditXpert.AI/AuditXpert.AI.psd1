@{
    RootModule           = 'AuditXpert.AI.psm1'
    ModuleVersion        = '0.1.0'
    GUID                 = '46770cb9-63a6-426d-b5c2-32f30e4a1ec0'
    Author               = 'AuditXpert_GPT'
    CompanyName          = 'AuditXpert_GPT'
    Copyright            = '(c) AuditXpert_GPT. All rights reserved.'
    Description          = 'AI narrative and prompt-handling scaffolding for evidence-backed report generation.'
    PowerShellVersion    = '7.0'
    CompatiblePSEditions = @('Core')
    FunctionsToExport    = @(
        'New-AxAiPromptPayload',
        'New-AxAiNarrativePackage'
    )
    CmdletsToExport      = @()
    VariablesToExport    = @()
    AliasesToExport      = @()
}
