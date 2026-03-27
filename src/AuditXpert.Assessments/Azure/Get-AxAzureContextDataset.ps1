function Get-AxAzureContextDataset {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [hashtable]$Context,

        [Parameter(Mandatory)]
        [string]$Name
    )

    if (-not $Context.ContainsKey('Datasets')) {
        return $null
    }

    $datasets = $Context.Datasets
    if ($datasets -is [hashtable]) {
        return $datasets[$Name]
    }

    return $datasets.$Name
}
