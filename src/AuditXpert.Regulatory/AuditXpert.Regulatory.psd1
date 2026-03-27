@{
    RootModule           = 'AuditXpert.Regulatory.psm1'
    ModuleVersion        = '0.1.0'
    GUID                 = 'e4458b3d-40f0-4d61-a73f-0df07050cbdb'
    Author               = 'AuditXpert_GPT'
    CompanyName          = 'AuditXpert_GPT'
    Copyright            = '(c) AuditXpert_GPT. All rights reserved.'
    Description          = 'Regulatory mapping and governance scaffolding for control alignment.'
    PowerShellVersion    = '7.0'
    CompatiblePSEditions = @('Core')
    FunctionsToExport    = @(
        'Get-AxFrameworkMapping',
        'Invoke-AxFrameworkMapping',
        'New-AxRiskRegister',
        'New-AxGovernanceScorecard',
        'Invoke-AxGovernanceAnalysis'
    )
    CmdletsToExport      = @()
    VariablesToExport    = @()
    AliasesToExport      = @()
}
