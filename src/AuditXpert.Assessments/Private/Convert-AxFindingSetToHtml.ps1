function Convert-AxFindingSetToHtml {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [psobject[]]$Finding
    )

    $rows = foreach ($item in $Finding) {
        "<tr><td>$($item.FindingId)</td><td>$($item.Service)</td><td>$($item.Severity)</td><td>$($item.RiskScore)</td><td>$($item.Title)</td></tr>"
    }

    @"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>AuditXpert Findings</title>
    <style>
        body { font-family: Segoe UI, sans-serif; margin: 24px; }
        table { border-collapse: collapse; width: 100%; }
        th, td { border: 1px solid #cccccc; padding: 8px; text-align: left; }
        th { background-color: #f3f3f3; }
    </style>
</head>
<body>
    <h1>AuditXpert Findings</h1>
    <table>
        <thead>
            <tr><th>FindingId</th><th>Service</th><th>Severity</th><th>RiskScore</th><th>Title</th></tr>
        </thead>
        <tbody>
$($rows -join [Environment]::NewLine)
        </tbody>
    </table>
</body>
</html>
"@
}
