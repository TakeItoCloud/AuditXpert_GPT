function Disconnect-AxAzure {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [psobject]$Session
    )

    process {
        New-AxConnectorSessionObject -Connector 'Azure' -AuthMethod $Session.AuthMethod -State 'Disconnected' -Context $Session.Context -Diagnostics @{
            Message = 'Azure connector disconnected from stub session.'
        }
    }
}
