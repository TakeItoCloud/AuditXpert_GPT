function New-AxAssessmentRule {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$RuleId,

        [Parameter(Mandatory)]
        [string]$Name,

        [Parameter(Mandatory)]
        [string]$AssessmentPack,

        [Parameter(Mandatory)]
        [string]$Service,

        [Parameter()]
        [string]$Description,

        [Parameter()]
        [ValidateSet('Informational', 'Low', 'Medium', 'High', 'Critical')]
        [string]$DefaultSeverity = 'Medium',

        [Parameter(Mandatory)]
        [scriptblock]$Evaluate
    )

    [pscustomobject]@{
        PSTypeName      = 'AuditXpert.AssessmentRule'
        RuleId          = $RuleId
        Name            = $Name
        AssessmentPack  = $AssessmentPack
        Service         = $Service
        Description     = $Description
        DefaultSeverity = $DefaultSeverity
        Evaluate        = $Evaluate
    }
}
