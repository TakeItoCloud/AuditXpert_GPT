function Test-AxModuleAvailability {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Name,

        [Parameter()]
        [string]$MinimumVersion
    )

    $availableModules = Get-Module -ListAvailable -Name $Name | Sort-Object Version -Descending
    $module = $availableModules | Select-Object -First 1

    $isAvailable = $null -ne $module
    $meetsVersion = $false

    if ($isAvailable) {
        if ([string]::IsNullOrWhiteSpace($MinimumVersion)) {
            $meetsVersion = $true
        }
        else {
            $meetsVersion = $module.Version -ge ([version]$MinimumVersion)
        }
    }

    [pscustomobject]@{
        Name             = $Name
        MinimumVersion   = $MinimumVersion
        Available        = $isAvailable
        InstalledVersion = if ($module) { $module.Version.ToString() } else { $null }
        MeetsVersion     = $meetsVersion
    }
}
