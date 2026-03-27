function New-AxFinding {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$FindingId,

        [Parameter(Mandatory)]
        [string]$Category,

        [Parameter(Mandatory)]
        [string]$Service,

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

        [Parameter(Mandatory)]
        [string]$RemediationType,

        [Parameter()]
        [object[]]$FrameworkMappings = @(),

        [Parameter(Mandatory)]
        [hashtable]$Source,

        [Parameter()]
        [datetime]$Timestamp = (Get-Date)
    )

    $finding = [pscustomobject]@{
        PSTypeName        = 'AuditXpert.Finding'
        FindingId         = $FindingId
        Category          = $Category
        Service           = $Service
        Scope             = $Scope
        Severity          = $Severity
        Likelihood        = $Likelihood
        Impact            = $Impact
        RiskScore         = Get-AxRiskScore -Likelihood $Likelihood -Impact $Impact
        Title             = $Title
        Description       = $Description
        Evidence          = $Evidence
        Recommendation    = $Recommendation
        RemediationType   = $RemediationType
        FrameworkMappings = $FrameworkMappings
        Source            = [pscustomobject]$Source
        Timestamp         = $Timestamp.ToString('o')
    }

    Test-AxFindingShape -Finding $finding | Out-Null
    $finding
}
