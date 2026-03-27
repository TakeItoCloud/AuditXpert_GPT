function Convert-AxMarkdownToSimpleHtml {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Markdown
    )

    $lines = $Markdown -split "`r?`n"
    $bodyLines = New-Object System.Collections.Generic.List[string]
    $inList = $false
    $inTable = $false

    function Close-List {
        param([System.Collections.Generic.List[string]]$Target, [ref]$Flag)
        if ($Flag.Value) {
            $Target.Add('</ul>')
            $Flag.Value = $false
        }
    }

    function Close-Table {
        param([System.Collections.Generic.List[string]]$Target, [ref]$Flag)
        if ($Flag.Value) {
            $Target.Add('</tbody></table>')
            $Flag.Value = $false
        }
    }

    foreach ($line in $lines) {
        $trimmed = $line.TrimEnd()

        if ([string]::IsNullOrWhiteSpace($trimmed)) {
            Close-List -Target $bodyLines -Flag ([ref]$inList)
            Close-Table -Target $bodyLines -Flag ([ref]$inTable)
            continue
        }

        if ($trimmed -match '^# (.+)$') {
            Close-List -Target $bodyLines -Flag ([ref]$inList)
            Close-Table -Target $bodyLines -Flag ([ref]$inTable)
            $bodyLines.Add("<h1>$([System.Net.WebUtility]::HtmlEncode($Matches[1]))</h1>")
            continue
        }

        if ($trimmed -match '^## (.+)$') {
            Close-List -Target $bodyLines -Flag ([ref]$inList)
            Close-Table -Target $bodyLines -Flag ([ref]$inTable)
            $bodyLines.Add("<h2>$([System.Net.WebUtility]::HtmlEncode($Matches[1]))</h2>")
            continue
        }

        if ($trimmed -match '^### (.+)$') {
            Close-List -Target $bodyLines -Flag ([ref]$inList)
            Close-Table -Target $bodyLines -Flag ([ref]$inTable)
            $bodyLines.Add("<h3>$([System.Net.WebUtility]::HtmlEncode($Matches[1]))</h3>")
            continue
        }

        if ($trimmed -match '^\|') {
            Close-List -Target $bodyLines -Flag ([ref]$inList)
            $cells = @($trimmed.Trim('|').Split('|') | ForEach-Object { $_.Trim() })

            if ($cells.Count -gt 0 -and ($cells -notmatch '^---+$')) {
                if (-not $inTable) {
                    $bodyLines.Add('<table><tbody>')
                    $inTable = $true
                }

                $tag = if ($trimmed -match '\|---') { 'th' } else { 'td' }
                $encodedCells = $cells | ForEach-Object { "<$tag>$([System.Net.WebUtility]::HtmlEncode($_))</$tag>" }
                $bodyLines.Add("<tr>$($encodedCells -join '')</tr>")
            }

            continue
        }

        if ($trimmed -match '^> (.+)$') {
            Close-List -Target $bodyLines -Flag ([ref]$inList)
            Close-Table -Target $bodyLines -Flag ([ref]$inTable)
            $bodyLines.Add("<blockquote>$([System.Net.WebUtility]::HtmlEncode($Matches[1]))</blockquote>")
            continue
        }

        if ($trimmed -match '^- (.+)$') {
            Close-Table -Target $bodyLines -Flag ([ref]$inTable)
            if (-not $inList) {
                $bodyLines.Add('<ul>')
                $inList = $true
            }

            $bodyLines.Add("<li>$([System.Net.WebUtility]::HtmlEncode($Matches[1]))</li>")
            continue
        }

        Close-List -Target $bodyLines -Flag ([ref]$inList)
        Close-Table -Target $bodyLines -Flag ([ref]$inTable)
        $bodyLines.Add("<p>$([System.Net.WebUtility]::HtmlEncode($trimmed))</p>")
    }

    Close-List -Target $bodyLines -Flag ([ref]$inList)
    Close-Table -Target $bodyLines -Flag ([ref]$inTable)

    @"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>AuditXpert Report</title>
    <style>
        body { font-family: Segoe UI, sans-serif; margin: 24px; line-height: 1.5; color: #1f2933; }
        h1, h2, h3 { color: #1f3a5f; }
        blockquote { border-left: 4px solid #b0b0b0; margin: 16px 0; padding-left: 12px; color: #444; }
        table { border-collapse: collapse; width: 100%; margin: 12px 0 20px 0; }
        th, td { border: 1px solid #d8d8d8; padding: 8px; vertical-align: top; }
        ul { margin: 8px 0 16px 18px; }
        p { margin: 6px 0; }
    </style>
</head>
<body>
$($bodyLines -join [Environment]::NewLine)
</body>
</html>
"@
}
