# AuditXpert_GPT

## Overview
AuditXpert_GPT is a PowerShell-first enterprise assessment platform for Microsoft 365, Microsoft Entra ID, Intune, Exchange Online, Microsoft Defender, Azure, and hybrid Microsoft infrastructure. The repository is structured as a phased build with modular engines for shared services, prerequisite validation, connectors, assessments, regulatory mapping, reporting, AI-assisted narrative generation, and a thin desktop launcher shell.

## Current phase status
Phase 13 launcher UI scaffolding is in place. The desktop launcher now includes panel-based controls for profile selection, auth intent, AI settings, paths, prerequisites, status, results, and a dedicated app-auth help window backed by documentation.

## Repository structure
```text
AuditXpert_GPT/
|-- Invoke-AuditXpert.ps1
|-- config/
|-- docs/
|   `-- launcher/
|-- launcher/
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
- `launcher`: PySide6 desktop shell for future orchestration bindings into the PowerShell platform

## Requirements
- PowerShell 7 or later
- Python 3.11 or later for the desktop launcher
- Microsoft Graph PowerShell SDK for future connector phases
- Exchange Online PowerShell module for future connector phases
- Az PowerShell modules for future Azure assessment phases
- Pester for automated validation as the repository matures
- PySide6 for the desktop launcher shell

## Consultant workflow
Initialize the workspace, run the smoke tests, and build a release package from the repository root:

```powershell
./tools/Initialize-AuditXpert.ps1
./tools/Run-SmokeTests.ps1
./tools/Build-Release.ps1
```

## Launcher usage
Install the launcher dependency and start the desktop shell from the repository root:

```powershell
python -m pip install -r .\launcher\requirements.txt
python .\launcher\main.py
```

The launcher is currently a functional shell only. It does not yet execute assessments directly and should be treated as a future orchestration surface over the existing PowerShell entry points.

## Launcher contract
The launcher now includes a normalized configuration contract and profile catalog:

- `launcher/app/models`: typed dataclasses for launcher settings, authentication intent, and execution profiles
- `launcher/app/services`: config loading, repo-relative path handling, and PowerShell profile mapping
- `launcher/samples/launcher-config.sample.json`: sample operator-selection payload

The current mapping only targets repository entry points that actually exist today. Unsupported launcher fields, such as full auth binding or AI execution switches, are retained in the contract for later phases rather than forced into fake PowerShell parameters.

## Launcher UI behavior
The launcher now exposes the configuration contract through dedicated UI panels:
- assessment and execution-profile selection
- delegated or app-auth intent with dynamic client-secret or certificate controls
- AI toggle fields that appear only when enabled
- output and evidence paths plus launcher preferences
- prerequisite and results sections with safe placeholder actions
- app-auth help guidance loaded from `docs/launcher/app-auth-setup-guide.md`

The UI updates a shared launcher state model only. It still does not run PowerShell commands directly in this phase.

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
Validation expectations now include report-rendering tests, fixture-based AI prompt construction tests, smoke-test orchestration, release-build verification, launcher import or startup smoke validation, launcher configuration-model validation, and launcher UI behavior smoke validation.

## Operational notes
- Keep the first release read-only and evidence-focused.
- Do not store secrets, tenant IDs, or certificate thumbprints in the repository.
- Keep AI-generated narrative separated from raw evidence artifacts as later phases are implemented.
- Use the `output` subfolders to keep evidence, findings, governance, reports, logs, and release packages separated.
- Keep the launcher thin and avoid duplicating PowerShell assessment or authentication logic in Python.

## Next milestone
The next milestone is PowerShell process bridging and execution wiring so the launcher can safely invoke explicit repository entry points using the state it already captures.
