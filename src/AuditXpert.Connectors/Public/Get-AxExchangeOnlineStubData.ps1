function Get-AxExchangeOnlineStubData {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [psobject]$Session
    )

    process {
        [pscustomobject]@{
            PSTypeName  = 'AuditXpert.ConnectorDataset'
            Connector   = 'ExchangeOnline'
            Dataset     = 'OrganizationConfig'
            RetrievedAt = (Get-Date).ToString('o')
            Items       = @(
                [pscustomobject]@{
                    Organization    = $Session.Context.Organization
                    Authentication  = $Session.AuthMethod
                    CollectionMode  = 'Stub'
                    ValidationState = $Session.State
                }
            )
        }
    }
}
