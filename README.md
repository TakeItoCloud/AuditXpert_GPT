# AuditXpert_GPT

## Overview
AuditXpert_GPT is a PowerShell-first enterprise assessment platform for Microsoft 365, Microsoft Entra ID, Intune, Exchange Online, Microsoft Defender, Azure, and hybrid Microsoft infrastructure. The repository is structured as a phased build with modular engines for shared services, prerequisite validation, connectors, assessments, regulatory mapping, reporting, and AI-assisted narrative generation.

## Current phase status
Phase 10 hardening and packaging scaffolding is in place. The repository now includes initialization, smoke-test, and release-build scripts alongside expanded test coverage and consultant-facing operational guidance.

## Repository structure
```text
AuditXpert_GPT/
|-- Invoke-AuditXpert.ps1
|-- config/
|-- docs/
|-- output/
|-- prompts/
|-- samples/
|-- src/
|   |-- AuditXpert.Core/
|   |   |-- AuditXpert.Core.psd1
|   |   |-- AuditXpert.Core.psm1
|   |   |-- Public/
|   |   `-- Private/
|   |-- AuditXpert.Prereqs/
|   |-- AuditXpert.Connectors/
|   |-- AuditXpert.Assessments/
|   |-- AuditXpert.Regulatory/
|   |-- AuditXpert.Reporting/
|   |-- AuditXpert.AI/
|   `-- AuditXpert.Cli/
|-- tests/
`-- tools/
```

## Modules
- `AuditXpert.Core`: shared runtime scaffolding for configuration, logging, and common utilities
- `AuditXpert.Prereqs`: placeholder prerequisite and readiness engine
- `AuditXpert.Connectors`: connector metadata, readiness checks, safe connect/disconnect lifecycle, and stub data collection
- `AuditXpert.Assessments`: normalized findings schema, rule contract, pack execution, export helpers, Microsoft 365 packs, Azure packs, and hybrid/on-prem assessment packs
- `AuditXpert.Regulatory`: configurable framework mappings, governance analysis, risk register generation, and scorecard views
- `AuditXpert.Reporting`: executive and technical report bundle rendering plus export helpers
- `AuditXpert.AI`: optional AI prompt-rendering and narrative package generation with safe API-key handling
- `AuditXpert.Cli`: assessment orchestration entry points and stub pack execution

## Requirements
- PowerShell 7 or later
- Microsoft Graph PowerShell SDK for future connector phases
- Exchange Online PowerShell module for future connector phases
- Az PowerShell modules for future Azure assessment phases
- Pester for automated validation as the repository matures

## Consultant workflow
Initialize the workspace, run the smoke tests, and build a release package from the repository root:

```powershell
./tools/Initialize-AuditXpert.ps1
./tools/Run-SmokeTests.ps1
./tools/Build-Release.ps1
```

## Reporting usage
Import the reporting and AI modules and generate report output without requiring AI:

```powershell
Import-Module .\src\AuditXpert.Reporting\AuditXpert.Reporting.psd1 -Force
Import-Module .\src\AuditXpert.AI\AuditXpert.AI.psd1 -Force
$reportingFindings = Get-Content .\samples\governance\sample-governance-findings.json -Raw | ConvertFrom-Json
$bundle = New-AxReportBundle -Finding $reportingFindings
$export = Export-AxReportBundle -ReportBundle $bundle -OutputPath .\output\reports
$aiPackage = New-AxAiNarrativePackage -Finding $reportingFindings -DisableAI
$export.Files
```

The reporting layer works without AI enabled. AI-assisted content remains optional, explicitly labeled, and traceable to finding IDs rather than being treated as evidence.

## Validation and testing
Validation expectations now include report-rendering tests, fixture-based AI prompt construction tests, smoke-test orchestration, and release-build verification.

## Operational notes
- Keep the first release read-only and evidence-focused.
- Do not store secrets, tenant IDs, or certificate thumbprints in the repository.
- Keep AI-generated narrative separated from raw evidence artifacts as later phases are implemented.
- Use the `output` subfolders to keep evidence, findings, governance, reports, logs, and release packages separated.

## Next milestone
Future roadmap items include deeper core-runtime implementation, broader connector depth, richer packaging options, and higher-confidence end-to-end validation against real environments.
