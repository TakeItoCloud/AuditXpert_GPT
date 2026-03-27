function Get-AxFrameworkMapping {
    [CmdletBinding()]
    param(
        [Parameter()]
        [ValidateSet('nis2-domains', 'iso27001-annexa', 'internal-security-baseline')]
        [string]$Framework
    )

    $root = Get-AxRegulatoryRootPath
    $mappingPath = Join-Path $root 'config/framework-mappings'

    $files = if ($Framework) {
        @(Join-Path $mappingPath "$Framework.json")
    }
    else {
        Get-ChildItem -Path $mappingPath -Filter '*.json' -File | Select-Object -ExpandProperty FullName
    }

    foreach ($file in $files) {
        Get-Content -Raw $file | ConvertFrom-Json
    }
}
