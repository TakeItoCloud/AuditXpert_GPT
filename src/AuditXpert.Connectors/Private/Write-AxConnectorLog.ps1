function Write-AxConnectorLog {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateSet('Debug', 'Information', 'Warning', 'Error')]
        [string]$Level,

        [Parameter(Mandatory)]
        [string]$Component,

        [Parameter(Mandatory)]
        [string]$Message,

        [Parameter()]
        [hashtable]$Data
    )

    $redactedData = @{}

    if ($Data) {
        foreach ($key in $Data.Keys) {
            if ($key -match 'secret|password|token|thumbprint|certificate|clientsecret') {
                $redactedData[$key] = '[REDACTED]'
            }
            else {
                $redactedData[$key] = $Data[$key]
            }
        }
    }

    [pscustomobject]@{
        Timestamp = (Get-Date).ToString('o')
        Level     = $Level
        Component = $Component
        Message   = $Message
        Data      = $redactedData
    }
}
