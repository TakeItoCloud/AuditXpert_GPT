function Invoke-AxAssessmentOrchestrator {
    [CmdletBinding()]
    param(
        [Parameter()]
        [string[]]$AssessmentPack = @('Microsoft365'),

        [Parameter()]
        [psobject[]]$Rule,

        [Parameter()]
        [hashtable]$Context = @{},

        [Parameter()]
        [string]$OutputPath,

        [Parameter()]
        [ValidateSet('Json', 'Csv', 'Markdown', 'Html')]
        [string[]]$ExportFormat = @()
    )

    if (-not $Rule) {
        $Rule = Get-AxDefaultStubRules
    }

    $packResults = foreach ($pack in $AssessmentPack) {
        Invoke-AxAssessmentPack -AssessmentPack $pack -Rule $Rule -Context $Context
    }

    $allFindings = @($packResults | ForEach-Object { $_.Findings })
    $exports = @()

    if ($OutputPath) {
        if (-not (Test-Path -LiteralPath $OutputPath)) {
            New-Item -ItemType Directory -Path $OutputPath -Force | Out-Null
        }

        foreach ($format in $ExportFormat) {
            $extension = switch ($format) {
                'Json' { 'json' }
                'Csv' { 'csv' }
                'Markdown' { 'md' }
                'Html' { 'html' }
            }

            $targetPath = Join-Path $OutputPath ("findings.$extension")
            Export-AxFindings -Finding $allFindings -Format $format -Path $targetPath | Out-Null

            $exports += [pscustomobject]@{
                Format = $format
                Path   = $targetPath
            }
        }
    }

    [pscustomobject]@{
        Packs        = $packResults
        FindingCount = $allFindings.Count
        Findings     = $allFindings
        Exports      = $exports
        ExecutedAt   = (Get-Date).ToString('o')
    }
}
