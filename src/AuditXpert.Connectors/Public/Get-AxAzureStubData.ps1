function Get-AxAzureStubData {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [psobject]$Session
    )

    process {
        [pscustomobject]@{
            PSTypeName  = 'AuditXpert.ConnectorDataset'
            Connector   = 'Azure'
            Dataset     = 'SubscriptionSummary'
            RetrievedAt = (Get-Date).ToString('o')
            Items       = @(
                [pscustomobject]@{
                    SubscriptionId = $Session.Context.SubscriptionId
                    TenantId       = $Session.Context.TenantId
                    Authentication = $Session.AuthMethod
                    CollectionMode = 'Stub'
                }
            )
        }
    }
}
