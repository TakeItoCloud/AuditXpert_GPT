function Disconnect-AxHybridLocal {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [psobject]$Session
    )

    process {
        New-AxConnectorSessionObject -Connector 'HybridLocal' -AuthMethod $Session.AuthMethod -State 'Disconnected' -Context $Session.Context -Diagnostics @{
            Message = 'Hybrid local connector disconnected from stub session.'
        }
    }
}
