function Get-AxMicrosoftGraphStubData {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [psobject]$Session
    )

    process {
        [pscustomobject]@{
            PSTypeName  = 'AuditXpert.ConnectorDataset'
            Connector   = 'MicrosoftGraph'
            Dataset     = 'TenantSummary'
            RetrievedAt = (Get-Date).ToString('o')
            Items       = @(
                [pscustomobject]@{
                    TenantId         = $Session.Context.TenantId
                    Authentication   = $Session.AuthMethod
                    CollectionMode   = 'Stub'
                    ValidationStatus = $Session.State
                }
            )
        }
    }
}
