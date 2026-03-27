function Convert-AxMarkdownToSimpleHtml {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Markdown
    )

    $encoded = [System.Net.WebUtility]::HtmlEncode($Markdown)
    $encoded = $encoded -replace '(?m)^# (.+)$', '<h1>$1</h1>'
    $encoded = $encoded -replace '(?m)^## (.+)$', '<h2>$1</h2>'
    $encoded = $encoded -replace '(?m)^- (.+)$', '<li>$1</li>'
    $encoded = $encoded -replace '(?m)^> (.+)$', '<blockquote>$1</blockquote>'
    $encoded = $encoded -replace '(?m)^(?!<h1>|<h2>|<li>|<blockquote>|\\||$)(.+)$', '<p>$1</p>'
    $encoded = $encoded -replace "(?s)(<li>.*?</li>)", '<ul>$1</ul>'

    @"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>AuditXpert Report</title>
    <style>
        body { font-family: Segoe UI, sans-serif; margin: 24px; line-height: 1.5; }
        h1, h2 { color: #1f3a5f; }
        blockquote { border-left: 4px solid #b0b0b0; margin: 16px 0; padding-left: 12px; color: #444; }
        table { border-collapse: collapse; width: 100%; }
        th, td { border: 1px solid #d8d8d8; padding: 8px; }
    </style>
</head>
<body>
$encoded
</body>
</html>
"@
}
