function Test-AxAiMappedRecordSet {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [psobject[]]$MappedFinding
    )

    $requiredFields = @(
        'finding_id',
        'title',
        'severity',
        'service',
        'affected_scope',
        'issue_summary',
        'evidence_summary',
        'recommendation',
        'business_impact',
        'technical_impact',
        'control_mapping',
        'remediation_priority',
        'traceability'
    )

    $issues = [System.Collections.Generic.List[string]]::new()

    foreach ($record in $MappedFinding) {
        foreach ($field in $requiredFields) {
            $property = $record.PSObject.Properties[$field]
            $value = if ($property) { $property.Value } else { $null }
            if ($null -eq $value -or ([string]$value).Trim().Length -eq 0) {
                $issues.Add("Mapped finding '$($record.finding_id)' is missing required field '$field'.")
            }
        }
    }

    [pscustomobject]@{
        Valid  = ($issues.Count -eq 0)
        Issues = @($issues)
    }
}
