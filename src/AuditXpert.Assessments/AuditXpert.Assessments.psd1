@{
    RootModule           = 'AuditXpert.Assessments.psm1'
    ModuleVersion        = '0.1.0'
    GUID                 = '6721452b-21cb-4bbd-b674-1ba3361a42e6'
    Author               = 'AuditXpert_GPT'
    CompanyName          = 'AuditXpert_GPT'
    Copyright            = '(c) AuditXpert_GPT. All rights reserved.'
    Description          = 'Assessment engine scaffolding for normalized technical rule packs.'
    PowerShellVersion    = '7.0'
    CompatiblePSEditions = @('Core')
    FunctionsToExport    = @(
        'New-AxFinding',
        'New-AxAssessmentRule',
        'Invoke-AxAssessmentPack',
        'Export-AxFindings',
        'Get-AxM365AssessmentRule',
        'Invoke-AxM365AssessmentPack',
        'Get-AxAzureAssessmentRule',
        'Invoke-AxAzureAssessmentPack',
        'Get-AxHybridAssessmentRule',
        'Invoke-AxHybridAssessmentPack'
    )
    CmdletsToExport      = @()
    VariablesToExport    = @()
    AliasesToExport      = @()
}
