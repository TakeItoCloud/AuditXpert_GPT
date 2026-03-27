function Test-AxConnectorAccess {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateSet('MicrosoftGraph', 'ExchangeOnline', 'Azure', 'HybridLocal')]
        [string]$Connector,

        [Parameter()]
        [string]$AuthMethod,

        [Parameter()]
        [switch]$Detailed
    )

    $definition = Get-AxConnectorDefinition -Name $Connector
    $selectedAuthMethod = if ($PSBoundParameters.ContainsKey('AuthMethod')) { $AuthMethod } else { $definition.AuthMethods[0] }

    if ($definition.AuthMethods -notcontains $selectedAuthMethod) {
        throw "Auth method '$selectedAuthMethod' is not supported for connector '$Connector'."
    }

    $dependencyChecks = foreach ($dependency in $definition.ModuleDependencies) {
        Test-AxModuleAvailability -Name $dependency.Name -MinimumVersion $dependency.MinimumVersion
    }

    $missingDependencies = $dependencyChecks | Where-Object { -not $_.Available -or -not $_.MeetsVersion }
    $status = if ($missingDependencies) { 'Unavailable' } else { 'Ready' }
    $message = if ($missingDependencies) {
        'Connector prerequisites are not satisfied. Install or update the required modules before connecting.'
    }
    else {
        'Connector prerequisites are satisfied. Live connection logic is intentionally stubbed for this phase.'
    }

    $result = [pscustomobject]@{
        Connector              = $Connector
        Service                = $definition.Service
        AuthMethod             = $selectedAuthMethod
        Status                 = $status
        Message                = $message
        ModuleDependencyCheck  = $dependencyChecks
        PermissionRequirements = $definition.PermissionRequirements
    }

    if ($Detailed) {
        return $result
    }

    [pscustomobject]@{
        Connector  = $result.Connector
        AuthMethod = $result.AuthMethod
        Status     = $result.Status
        Message    = $result.Message
    }
}
