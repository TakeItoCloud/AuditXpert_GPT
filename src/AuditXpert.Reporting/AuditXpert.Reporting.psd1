@{
    RootModule           = 'AuditXpert.Reporting.psm1'
    ModuleVersion        = '0.1.0'
    GUID                 = '7eb8fe3d-ec4e-4afd-b219-0e4436ddb881'
    Author               = 'AuditXpert_GPT'
    CompanyName          = 'AuditXpert_GPT'
    Copyright            = '(c) AuditXpert_GPT. All rights reserved.'
    Description          = 'Reporting scaffolding for technical and executive output generation.'
    PowerShellVersion    = '7.0'
    CompatiblePSEditions = @('Core')
    FunctionsToExport    = @(
        'New-AxReportBundle',
        'Export-AxReportBundle'
    )
    CmdletsToExport      = @()
    VariablesToExport    = @()
    AliasesToExport      = @()
}
