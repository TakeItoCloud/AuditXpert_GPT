function Convert-AxFindingToFlatObject {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [psobject]$Finding
    )

    process {
        [pscustomobject]@{
            FindingId         = $Finding.FindingId
            Category          = $Finding.Category
            Service           = $Finding.Service
            Scope             = $Finding.Scope
            Severity          = $Finding.Severity
            Likelihood        = $Finding.Likelihood
            Impact            = $Finding.Impact
            RiskScore         = $Finding.RiskScore
            Title             = $Finding.Title
            Description       = $Finding.Description
            Recommendation    = $Finding.Recommendation
            RemediationType   = $Finding.RemediationType
            FrameworkMappings = ($Finding.FrameworkMappings | ForEach-Object { "$($_.Framework):$($_.Control)" }) -join '; '
            Source            = $Finding.Source.Connector
            Timestamp         = $Finding.Timestamp
            Evidence          = ($Finding.Evidence | ConvertTo-Json -Depth 5 -Compress)
        }
    }
}
