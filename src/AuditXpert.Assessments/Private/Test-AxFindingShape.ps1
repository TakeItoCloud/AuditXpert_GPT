function Test-AxFindingShape {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [psobject]$Finding
    )

    $requiredProperties = @(
        'FindingId',
        'Category',
        'Service',
        'Scope',
        'Severity',
        'Likelihood',
        'Impact',
        'RiskScore',
        'Title',
        'Description',
        'Evidence',
        'Recommendation',
        'RemediationType',
        'FrameworkMappings',
        'Source',
        'Timestamp'
    )

    foreach ($property in $requiredProperties) {
        if ($Finding.PSObject.Properties.Name -notcontains $property) {
            throw "Finding is missing required property: $property"
        }
    }

    $true
}
