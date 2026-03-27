function Disconnect-AxMicrosoftGraph {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [psobject]$Session
    )

    process {
        New-AxConnectorSessionObject -Connector 'MicrosoftGraph' -AuthMethod $Session.AuthMethod -State 'Disconnected' -Context $Session.Context -Diagnostics @{
            Message = 'Graph connector disconnected from stub session.'
        }
    }
}
