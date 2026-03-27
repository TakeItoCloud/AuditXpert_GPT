function Invoke-AxFrameworkMapping {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [psobject[]]$Finding,

        [Parameter()]
        [string[]]$Framework = @('nis2-domains', 'iso27001-annexa', 'internal-security-baseline')
    )

    $allowedFrameworks = @('nis2-domains', 'iso27001-annexa', 'internal-security-baseline')
    foreach ($frameworkName in $Framework) {
        if ($frameworkName -notin $allowedFrameworks) {
            throw "Unsupported framework mapping requested: $frameworkName"
        }
    }

    $mappings = foreach ($frameworkName in $Framework) {
        Get-AxFrameworkMapping -Framework $frameworkName
    }

    foreach ($item in $Finding) {
        $relatedMappings = New-Object System.Collections.Generic.List[object]

        foreach ($frameworkConfig in $mappings) {
            foreach ($mappingEntry in $frameworkConfig.Mappings) {
                if (($mappingEntry.Categories -contains $item.Category) -or ($mappingEntry.Services -contains $item.Service)) {
                    [void]$relatedMappings.Add([pscustomobject]@{
                        Framework = $frameworkConfig.Framework
                        Version   = $frameworkConfig.Version
                        Domain    = $mappingEntry.Domain
                        Control   = $mappingEntry.Control
                    })
                }
            }
        }

        [pscustomobject]@{
            FindingId = $item.FindingId
            Mappings  = @($relatedMappings | Sort-Object Framework, Domain, Control -Unique)
        }
    }
}
