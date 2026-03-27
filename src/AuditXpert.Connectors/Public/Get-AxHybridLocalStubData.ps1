function Get-AxHybridLocalStubData {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [psobject]$Session
    )

    process {
        [pscustomobject]@{
            PSTypeName  = 'AuditXpert.ConnectorDataset'
            Connector   = 'HybridLocal'
            Dataset     = 'HostContext'
            RetrievedAt = (Get-Date).ToString('o')
            Items       = @(
                [pscustomobject]@{
                    ComputerName   = $Session.Context.ComputerName
                    Authentication = $Session.AuthMethod
                    CollectionMode = 'Stub'
                }
            )
        }
    }
}
