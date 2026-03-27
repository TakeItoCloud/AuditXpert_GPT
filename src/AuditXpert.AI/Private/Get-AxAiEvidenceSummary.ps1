function Get-AxAiEvidenceSummary {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [psobject]$Finding
    )

    $items = @($Finding.Evidence)
    if ($items.Count -eq 0) {
        return 'Evidence summary not populated in the current finding payload.'
    }

    $summary = foreach ($item in $items | Select-Object -First 3) {
        $properties = @($item.PSObject.Properties | Where-Object { $_.Name -ne 'Source' })
        $detail = if ($properties.Count -gt 0) {
            ($properties | ForEach-Object { "$($_.Name)=$($_.Value)" }) -join ', '
        }
        else {
            'reference recorded'
        }

        if ($item.Source) {
            "$($item.Source): $detail"
        }
        else {
            $detail
        }
    }

    $summary -join '; '
}
