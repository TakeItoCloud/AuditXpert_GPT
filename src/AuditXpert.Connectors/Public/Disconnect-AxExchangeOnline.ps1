function Disconnect-AxExchangeOnline {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [psobject]$Session
    )

    process {
        New-AxConnectorSessionObject -Connector 'ExchangeOnline' -AuthMethod $Session.AuthMethod -State 'Disconnected' -Context $Session.Context -Diagnostics @{
            Message = 'Exchange Online connector disconnected from stub session.'
        }
    }
}
