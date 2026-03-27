function Get-AxImplementationGuidance {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [psobject]$Finding
    )

    $remediationType = if ($Finding.RemediationType) { [string]$Finding.RemediationType } else { 'Configuration' }
    "Remediation type: $remediationType. Implement through a controlled change plan, validate the effect in the affected scope, and preserve evidence of closure."
}
