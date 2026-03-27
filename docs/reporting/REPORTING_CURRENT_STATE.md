# Reporting Current State

## Scope of this inventory
This document reflects the reporting implementation that currently exists in the repository as of this phase. It is based on direct inspection of:
- `src/AuditXpert.Reporting/*`
- `src/AuditXpert.AI/*`
- `tests/Reporting/Reporting.Tests.ps1`
- `tests/AI/AI.Tests.ps1`
- `samples/reports/*`
- `output/phase09-reporting-*`
- `tools/Run-SmokeTests.ps1`

## Current report architecture

### Public reporting entry points
- `src/AuditXpert.Reporting/Public/New-AxReportBundle.ps1`
- `src/AuditXpert.Reporting/Public/Export-AxReportBundle.ps1`

### Private reporting renderers
- `src/AuditXpert.Reporting/Private/Get-AxExecutiveSummaryMarkdown.ps1`
- `src/AuditXpert.Reporting/Private/Get-AxTechnicalFindingsMarkdown.ps1`
- `src/AuditXpert.Reporting/Private/Get-AxRiskRegisterMarkdown.ps1`
- `src/AuditXpert.Reporting/Private/Get-AxServiceAppendixMarkdown.ps1`
- `src/AuditXpert.Reporting/Private/Convert-AxReportDataToServiceAppendix.ps1`
- `src/AuditXpert.Reporting/Private/Convert-AxMarkdownToSimpleHtml.ps1`

### AI prompt and narrative entry points
- `src/AuditXpert.AI/Public/New-AxAiPromptPayload.ps1`
- `src/AuditXpert.AI/Public/New-AxAiNarrativePackage.ps1`
- `src/AuditXpert.AI/Private/Get-AxAiPromptSections.ps1`
- `src/AuditXpert.AI/Private/Get-AxAiApiKey.ps1`

### Upstream dependencies used by reporting
- Normalized findings from the assessments layer
- Governance outputs from `Invoke-AxGovernanceAnalysis`
- Risk register rows from `New-AxRiskRegister`
- Scorecard rows from `New-AxGovernanceScorecard`

## Current report generation flow
1. Findings are collected or loaded.
2. Governance analysis produces `Mapping`, `RiskRegister`, and `Scorecard`.
3. `New-AxReportBundle` renders four Markdown sections:
   - executive summary
   - technical findings report
   - risk register summary
   - service-specific appendix
4. `New-AxReportBundle` also converts only two sections to HTML:
   - executive summary
   - technical findings
5. `Export-AxReportBundle` writes six files to disk:
   - `Executive-Summary.md`
   - `Technical-Findings.md`
   - `Risk-Register-Summary.md`
   - `Service-Appendix.md`
   - `Executive-Summary.html`
   - `Technical-Findings.html`
6. The AI layer separately builds a prompt payload and a narrative package, but it does not write report files or call a model in the repository test path.

## Current report types implemented in code
- Executive Summary
- Technical Findings Report
- Risk Register Summary
- Service-Specific Appendix

## Current AI narrative assets

### Implemented assets
- One hardcoded system prompt in `New-AxAiPromptPayload`
- One structured payload object in `New-AxAiPromptPayload`
- One prompt-section builder in `Get-AxAiPromptSections`
- One narrative-package wrapper in `New-AxAiNarrativePackage`

### Not currently implemented
- External prompt template files
- Prompt versioning assets
- Per-report prompt variants
- Service-specific prompt assets
- Controlled section-level AI generation workflow

## Current output formats

### Report bundle outputs
- Markdown
- HTML

### Findings engine outputs outside the reporting module
- JSON
- CSV
- Markdown
- HTML

### Not currently implemented for report bundles
- PDF
- DOCX
- JSON report bundles
- CSV report bundles

## Current sample assets and outputs

### Samples checked into the repository
- `samples/reports/executive-summary-sample.md`
- `samples/reports/technical-findings-sample.html`

### Generated outputs present in repository output folders
- `output/phase09-reporting-tests/*`
- `output/phase09-reporting-validation/*`
- `output/smoke-tests/reports/*`

### Current governance sample limitation
Sample governance inputs exist in:
- `samples/governance/sample-governance-findings.json`
- `samples/governance/sample-governance-output.json`

However, persisted sample report bundles are minimal and do not include a broad catalog of polished report exemplars.

## Current strengths
- Reporting is cleanly separated into a dedicated PowerShell module.
- The reporting entry surface is small and easy to inspect.
- Markdown-first rendering keeps the current implementation simple and testable.
- AI packaging is separate from raw report rendering.
- Non-AI reporting remains the default path.
- Narrative packages explicitly include finding ID traceability requirements.
- Governance outputs can be injected into the report bundle today.
- Service appendix grouping exists, even if it is lightweight.
- Existing reporting tests and smoke flows already validate that report generation runs.

## Current weaknesses
- Report structure is very thin and not consulting-grade yet.
- Executive summary contains only counts and top domains, with no business summary, scope, methodology, key priorities, or next steps.
- Technical findings omit impact statements, likelihood, risk score, evidence excerpts, remediation type, framework mappings, and source metadata even though the finding schema contains them.
- Risk register summary is Markdown-only and extremely compressed.
- Service appendix is only a grouped finding list and not a real appendix structure.
- HTML generation is simplistic and lossy:
  - list items are wrapped into separate `<ul>` blocks
  - blockquotes are not rendered correctly after HTML encoding
  - Markdown tables are not transformed into HTML tables
  - there is no template-specific layout
- The reporting module exports HTML only for executive and technical sections, not for risk register or appendix.
- No report-level consistency validation exists.
- Severity labels are passed through from findings without report-layer normalization or presentation rules.
- Recommendation structure is inconsistent because the report layer just prints the raw recommendation text.
- Evidence traceability is weak in rendered output because only finding IDs are surfaced consistently.
- Framework mappings are available upstream but not prominently surfaced in report sections.
- There is no remediation roadmap report type.
- There are no service-specific report templates for Azure, Microsoft 365, or hybrid scopes.
- AI prompt content is hardcoded in functions rather than maintained in external prompt assets.
- AI output control is limited to packaging and labeling; there is no section-by-section governance or post-generation validation path.
