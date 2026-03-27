function Get-AxFindingFrameworkSummary {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [psobject]$Finding
    )

    $mappings = @($Finding.FrameworkMappings)
    if ($mappings.Count -eq 0) {
        return 'Framework mapping not populated in the current finding payload.'
    }

    $labels = foreach ($mapping in $mappings) {
        if ($mapping.Framework -and $mapping.Control) {
            "$($mapping.Framework): $($mapping.Control)"
        }
        elseif ($mapping.Framework) {
            [string]$mapping.Framework
        }
        else {
            [string]$mapping
        }
    }

    @($labels | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }) -join '; '
}
