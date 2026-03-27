function Test-AxAiRenderedSectionSet {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [psobject[]]$SectionPlan,

        [Parameter(Mandatory)]
        [psobject[]]$RenderedSection
    )

    $renderedKeys = @($RenderedSection | Select-Object -ExpandProperty SectionKey)
    $issues = [System.Collections.Generic.List[string]]::new()

    foreach ($section in $SectionPlan | Where-Object { $_.Required -and $_.AIControlled }) {
        if ($section.SectionKey -notin $renderedKeys) {
            $issues.Add("Rendered AI section set is missing required section '$($section.SectionKey)'.")
            continue
        }

        $matched = @($RenderedSection | Where-Object { $_.SectionKey -eq $section.SectionKey } | Select-Object -First 1)[0]
        if ($null -eq $matched.Content -or ([string]$matched.Content).Trim().Length -eq 0) {
            $issues.Add("Rendered AI section '$($section.SectionKey)' does not contain content.")
        }
    }

    [pscustomobject]@{
        Valid  = ($issues.Count -eq 0)
        Issues = @($issues)
    }
}
