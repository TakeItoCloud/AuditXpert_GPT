function Export-AxReportBundle {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [psobject]$ReportBundle,

        [Parameter(Mandatory)]
        [string]$OutputPath
    )

    if (-not (Test-Path -LiteralPath $OutputPath)) {
        New-Item -ItemType Directory -Path $OutputPath -Force | Out-Null
    }

    Set-Content -LiteralPath (Join-Path $OutputPath 'Executive-Summary.md') -Value $ReportBundle.ExecutiveSummary -Encoding UTF8
    Set-Content -LiteralPath (Join-Path $OutputPath 'Technical-Findings.md') -Value $ReportBundle.TechnicalFindings -Encoding UTF8
    Set-Content -LiteralPath (Join-Path $OutputPath 'Risk-Register-Summary.md') -Value $ReportBundle.RiskRegisterSummary -Encoding UTF8
    Set-Content -LiteralPath (Join-Path $OutputPath 'Service-Appendix.md') -Value $ReportBundle.ServiceAppendix -Encoding UTF8
    Set-Content -LiteralPath (Join-Path $OutputPath 'Executive-Summary.html') -Value $ReportBundle.ExecutiveSummaryHtml -Encoding UTF8
    Set-Content -LiteralPath (Join-Path $OutputPath 'Technical-Findings.html') -Value $ReportBundle.TechnicalFindingsHtml -Encoding UTF8

    [pscustomobject]@{
        OutputPath = $OutputPath
        Files = @(
            'Executive-Summary.md',
            'Technical-Findings.md',
            'Risk-Register-Summary.md',
            'Service-Appendix.md',
            'Executive-Summary.html',
            'Technical-Findings.html'
        )
    }
}
