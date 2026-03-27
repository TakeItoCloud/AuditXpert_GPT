function Export-AxFindings {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [psobject[]]$Finding,

        [Parameter(Mandatory)]
        [ValidateSet('Json', 'Csv', 'Markdown', 'Html')]
        [string]$Format,

        [Parameter()]
        [string]$Path
    )

    foreach ($item in $Finding) {
        Test-AxFindingShape -Finding $item | Out-Null
    }

    $content = switch ($Format) {
        'Json' { $Finding | ConvertTo-Json -Depth 8 }
        'Csv' { ($Finding | Convert-AxFindingToFlatObject | ConvertTo-Csv -NoTypeInformation) -join [Environment]::NewLine }
        'Markdown' { Convert-AxFindingSetToMarkdown -Finding $Finding }
        'Html' { Convert-AxFindingSetToHtml -Finding $Finding }
    }

    if ($Path) {
        Set-Content -LiteralPath $Path -Value $content -Encoding UTF8
    }

    $content
}
