# Report Data Flow

## End-to-end current flow
The current reporting path is split between technical report rendering and optional AI narrative packaging.

## Current code path
1. Assessment layers produce normalized findings.
2. Governance layer maps findings into framework domains and produces:
   - mapping rows
   - risk register rows
   - scorecard rows
3. `New-AxReportBundle` consumes:
   - `Finding`
   - `RiskRegister`
   - `Scorecard`
4. Private reporting functions render Markdown sections:
   - executive summary from findings, risk register, and scorecard
   - technical findings from findings only
   - risk register summary from risk register only
   - service appendix from findings grouped by service
5. `Convert-AxMarkdownToSimpleHtml` creates HTML only for:
   - executive summary
   - technical findings
6. `Export-AxReportBundle` writes six files to disk.
7. Separately, `New-AxAiPromptPayload` and `New-AxAiNarrativePackage` construct AI prompt state from:
   - findings
   - risk register
   - scorecard

## Current file-level path

### Findings and governance into reporting
- Assessments produce normalized findings
- Governance analysis produces risk register and scorecard
- Reporting consumes those objects directly

### Reporting module path
- `New-AxReportBundle`
  - `Get-AxExecutiveSummaryMarkdown`
  - `Get-AxTechnicalFindingsMarkdown`
  - `Get-AxRiskRegisterMarkdown`
  - `Get-AxServiceAppendixMarkdown`
  - `Convert-AxMarkdownToSimpleHtml`
- `Export-AxReportBundle`

### AI module path
- `New-AxAiNarrativePackage`
  - `New-AxAiPromptPayload`
  - `Get-AxAiPromptSections`
  - `Get-AxAiApiKey`

## Current output path behavior
- Test path: `output/phase09-reporting-tests`
- Validation path: `output/phase09-reporting-validation`
- Smoke path: `output/smoke-tests/reports`

## Current control points
- Findings schema controls what raw fields are available.
- Governance layer controls mapping, risk register, and scorecard objects.
- Reporting layer controls section rendering and file export.
- AI layer controls prompt packaging and API-key lookup only.

## Current weaknesses in the data path
- Framework mappings do not flow strongly into rendered report sections.
- Evidence arrays are not summarized into structured evidence sections.
- HTML rendering is not a first-class template layer.
- AI prompts are built in code rather than from managed prompt assets.
- There is no report completeness validation gate before export.

## Target hardened flow
1. Normalize findings and validate required reporting fields.
2. Normalize governance records for reporting purposes.
3. Build a report data contract that includes:
   - scope metadata
   - executive summary data
   - technical findings data
   - governance data
   - remediation roadmap data
   - appendix data
4. Render report types through template-specific formatters.
5. Run consistency validation before export.
6. Export to controlled output formats.
7. Optionally generate AI-assisted narrative sections using governed prompt assets and post-generation validation.
