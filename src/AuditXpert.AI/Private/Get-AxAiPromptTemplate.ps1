function Get-AxAiPromptTemplate {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$TemplateName,

        [Parameter()]
        [ValidateSet('reports', 'shared')]
        [string]$Category = 'reports'
    )

    $rootPath = Get-AxAiTemplateRootPath
    $templatePath = Join-Path -Path $rootPath -ChildPath (Join-Path -Path $Category -ChildPath "$TemplateName.json")

    if (-not (Test-Path -LiteralPath $templatePath)) {
        throw "AI prompt template not found: $templatePath"
    }

    Get-Content -LiteralPath $templatePath -Raw | ConvertFrom-Json
}
