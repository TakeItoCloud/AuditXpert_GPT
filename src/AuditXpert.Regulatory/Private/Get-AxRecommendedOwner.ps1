function Get-AxRecommendedOwner {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Category
    )

    switch -Regex ($Category) {
        'Identity|Privileged|HybridIdentity|Directory' { 'Identity Team' ; break }
        'Messaging|Exchange' { 'Messaging Team' ; break }
        'Network' { 'Network Team' ; break }
        'Monitoring|Logging' { 'Operations Team' ; break }
        'Resilience|Backup|Certificate' { 'Infrastructure Team' ; break }
        'Governance|SecurityPosture|Optimization' { 'Security Governance Team' ; break }
        default { 'Platform Engineering Team' }
    }
}
