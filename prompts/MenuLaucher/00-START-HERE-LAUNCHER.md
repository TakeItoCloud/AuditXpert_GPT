# AuditXpert_GPT Desktop Launcher Prompt Pack

## Purpose
This prompt pack extends the existing AuditXpert_GPT repository with a desktop launcher built in Python using PySide6 while preserving the PowerShell assessment engine as the system of record for prerequisites, authentication, orchestration, collection, analysis, and reporting.

## Important operating model
- The existing PowerShell engine remains the execution layer.
- The new Python desktop launcher is a thin orchestration and UX layer.
- Each prompt is intended to be pasted into Codex in VS Code one phase at a time.
- After each phase, Codex must update the project-memory markdown files.
- Do not skip phases unless the repository already contains the requested functionality and Codex can verify that safely.

## Before using the first launcher prompt
Open the existing repository at:
- `C:\Scripts\Assessment\AuditXpert_GPT`

Ensure the root project-memory files are present:
- `PROJECT_DEFINITION.md`
- `IMPLEMENTATION_PLAN.md`
- `DEVELOPMENT_HISTORY.md`
- `NEXT_STEP.md`
- `README.md`
- `CHANGELOG.md`
- `TEST_PLAN.md`
- `ARCHITECTURE_NOTES.md`

## Recommended execution order
1. `prompts\PHASE-11-LAUNCHER-FOUNDATION.md`
2. `prompts\PHASE-12-LAUNCHER-CONFIG-CONTRACT.md`
3. `prompts\PHASE-13-LAUNCHER-UI-AND-HELP.md`
4. `prompts\PHASE-14-LAUNCHER-POWERSHELL-BRIDGE.md`
5. `prompts\PHASE-15-LAUNCHER-PREREQS-AUTH-VALIDATION.md`
6. `prompts\PHASE-16-LAUNCHER-PACKAGING-AND-DOCS.md`

## What these prompts assume
These prompts assume the earlier AuditXpert build phases already created or planned:
- a modular PowerShell codebase
- project-memory markdown files
- a CLI or bootstrap entry point
- scoped modules such as Core, Prereqs, Connectors, Assessments, Reporting, AI, and Cli

If the live repo differs from those assumptions, Codex must adapt to the actual current codebase rather than force the old assumptions blindly.

## What to tell Codex before each phase
Use a short preface such as:

```text
You are working in C:\Scripts\Assessment\AuditXpert_GPT.
Read the existing project-memory markdown files and inspect the current repository before making changes.
Use the actual codebase as the source of truth for implementation details, while preserving the existing architecture and phased approach.
I will now paste the next phase prompt.
```

## Expected result
At the end of these phases, the repository should contain:
- a Python PySide6 desktop launcher
- a normalized launcher configuration contract
- dynamic authentication UI
- prerequisite check/install actions
- a help window for app authentication setup
- a PowerShell bridge that launches the correct profiles/scripts with the correct variables
- updated docs, history, test plan, and next-step continuity
