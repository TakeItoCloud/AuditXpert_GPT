function Get-AxFindingEvidenceSummary {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [psobject]$Finding
    )

    $evidenceItems = @($Finding.Evidence)
    if ($evidenceItems.Count -eq 0) {
        return 'Evidence summary not populated in the current dataset.'
    }

    $summaries = foreach ($evidence in $evidenceItems | Select-Object -First 3) {
        $properties = @($evidence.PSObject.Properties | Where-Object { $_.Name -ne 'Source' })
        $detail = if ($properties.Count -gt 0) {
            ($properties | ForEach-Object { "$($_.Name)=$($_.Value)" }) -join ', '
        }
        else {
            'reference recorded'
        }

        if ($evidence.Source) {
            "$($evidence.Source): $detail"
        }
        else {
            $detail
        }
    }

    $summaries -join '; '
}
