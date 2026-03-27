function New-AxRiskRegister {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [psobject[]]$Finding,

        [Parameter()]
        [psobject[]]$Mapping
    )

    $mappingLookup = @{}
    foreach ($map in $Mapping) {
        $mappingLookup[$map.FindingId] = $map.Mappings
    }

    foreach ($item in $Finding) {
        $mappedControls = @($mappingLookup[$item.FindingId])
        Convert-AxFindingToRiskRecord -Finding $item -MappedControls $mappedControls
    }
}
