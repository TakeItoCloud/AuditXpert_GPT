# AuditXpert_GPT Build Pack

## Purpose
This build pack is designed for Codex in VS Code to create an enterprise-grade assessment and audit platform at:

`C:\Scripts\Assessment\AuditXpert_GPT`

## Recommended product structure
Build **one platform** with **three major modules** instead of two disconnected tools:

1. **Governance & Fractional CISO module**
   - Regulatory mapping
   - Control catalog
   - Risk register
   - Maturity scoring
   - Executive summaries
   - Evidence tracking

2. **Technical Assessment module**
   - Microsoft 365 assessments
   - Entra ID assessments
   - Intune assessments
   - Exchange Online assessments
   - Defender assessments
   - Azure assessments
   - Hybrid/on-prem assessments for Active Directory, Domain Controllers, Windows Server, Exchange hybrid, AD CS, DNS, DHCP, GPO and selected workloads

3. **AI Explainer module**
   - Takes normalized findings as input
   - Produces executive and technical reports
   - Rewrites findings into plain English
   - Assigns business impact, likelihood, priority, and remediation guidance
   - Can later evolve into a SaaS API/UI layer

## Why this structure
Use a **single shared platform** because the data model, authentication layer, evidence storage, permissions checking, export/reporting, and AI explanation layer should be reused.

Do **not** build it as a single monolithic script. Instead, use:
- one repository
- one shared core
- separate modules/connectors
- separate assessment packs
- separate report templates
- separate regulatory mappings

This gives you one product for commercial positioning, but keeps engineering modular.

## High-level repo direction
Target path:
`C:\Scripts\Assessment\AuditXpert_GPT`

Recommended top-level folders:
- `src\AuditXpert.Core`
- `src\AuditXpert.Prereqs`
- `src\AuditXpert.Connectors`
- `src\AuditXpert.Assessments`
- `src\AuditXpert.Regulatory`
- `src\AuditXpert.Reporting`
- `src\AuditXpert.AI`
- `src\AuditXpert.Cli`
- `tests`
- `docs`
- `output`
- `samples`
- `config`

## Build approach
Use the prompts in the `prompts` folder **in order**.

Each prompt tells Codex to:
- read the project context files first
- create or update the required repository files
- keep documentation current
- record what it changed
- define the next step

## Workflow for Codex in VS Code
1. Open the target folder in VS Code.
2. Paste the Phase 01 prompt into Codex.
3. Let Codex create the repo and baseline files.
4. Review the result.
5. Paste the next phase prompt.
6. Continue in order.
7. After each phase, keep the markdown files updated.

## Mandatory continuity files
These files are the memory system for the build:
- `PROJECT_DEFINITION.md`
- `IMPLEMENTATION_PLAN.md`
- `DEVELOPMENT_HISTORY.md`
- `NEXT_STEP.md`
- `README.md`
- `CHANGELOG.md`
- `TEST_PLAN.md`
- `ARCHITECTURE_NOTES.md`

## Design rules
- PowerShell-first implementation
- Python optional only for report transformation or data processing where PowerShell is awkward
- App-only auth where practical
- Strong prerequisite checks before running assessment logic
- Least privilege documentation for every connector
- Normalized findings model shared by all modules
- Export to JSON, CSV, Markdown, and HTML from the same finding set
- Evidence-preserving output folders per run
- No silent remediation by default
- Read-only assessment mode first
- Remediation mode only after the assessment engine is stable

## Immediate next action
Start with `prompts\PHASE-01-FOUNDATION.md`.
