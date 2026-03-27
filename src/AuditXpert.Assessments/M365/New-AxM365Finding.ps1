function New-AxM365Finding {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$FindingId,

        [Parameter(Mandatory)]
        [string]$Category,

        [Parameter(Mandatory)]
        [string]$Scope,

        [Parameter(Mandatory)]
        [ValidateSet('Informational', 'Low', 'Medium', 'High', 'Critical')]
        [string]$Severity,

        [Parameter(Mandatory)]
        [ValidateSet('Informational', 'Low', 'Medium', 'High', 'Critical')]
        [string]$Likelihood,

        [Parameter(Mandatory)]
        [ValidateSet('Informational', 'Low', 'Medium', 'High', 'Critical')]
        [string]$Impact,

        [Parameter(Mandatory)]
        [string]$Title,

        [Parameter(Mandatory)]
        [string]$Description,

        [Parameter()]
        [object[]]$Evidence = @(),

        [Parameter(Mandatory)]
        [string]$Recommendation,

        [Parameter()]
        [string]$RemediationType = 'Configuration',

        [Parameter()]
        [object[]]$FrameworkMappings = @([pscustomobject]@{ Framework = 'NIS2'; Control = 'CyberHygiene' }),

        [Parameter(Mandatory)]
        [hashtable]$Source
    )

    New-AxFinding -FindingId $FindingId `
        -Category $Category `
        -Service 'Microsoft 365' `
        -Scope $Scope `
        -Severity $Severity `
        -Likelihood $Likelihood `
        -Impact $Impact `
        -Title $Title `
        -Description $Description `
        -Evidence $Evidence `
        -Recommendation $Recommendation `
        -RemediationType $RemediationType `
        -FrameworkMappings $FrameworkMappings `
        -Source $Source
}
