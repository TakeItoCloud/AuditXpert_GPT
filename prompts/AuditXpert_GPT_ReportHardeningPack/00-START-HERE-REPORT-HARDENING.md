# AuditXpert_GPT Report Hardening Pack

## Purpose
This pack adds a dedicated **Report Hardening** workstream to the existing AuditXpert_GPT project so Codex in VS Code can upgrade the current AI-generated reporting output into a **consulting-grade, enterprise-standard reporting system**.

This pack assumes:
- the prior AuditXpert_GPT phases were already run by Codex
- the reporting engine already exists
- the launcher/menu work may already exist
- the project memory files are already present and are the source of truth

## Objective
Codex must refine the existing reporting capability so that generated outputs are:
- consistent
- structured
- auditable
- section-driven
- service-aware
- framework-aware
- executive-safe
- technical-delivery ready

## What this pack is for
Use these prompts to make Codex:
1. inspect the current reporting implementation in the real repo
2. document the current reporting state
3. standardize report schemas, templates, severity language, and compliance mapping
4. harden AI prompt templates so AI fills controlled sections instead of inventing report structure
5. upgrade output renderers and report assets
6. update project memory files after each step

## Important operating rule
Read this file first, but do **not** use it as the main Codex execution prompt.

Instead:
1. open the project in VS Code
2. review this file
3. run the prompt files in the `prompts` folder in order

## Execution order
Run these prompt files in this exact sequence:
1. `PHASE-17-REPORT-HARDENING-ASSESS-AND-INVENTORY.md`
2. `PHASE-18-REPORT-HARDENING-TEMPLATE-STANDARDS.md`
3. `PHASE-19-REPORT-HARDENING-AI-PROMPTS-AND-MAPPINGS.md`
4. `PHASE-20-REPORT-HARDENING-RENDERERS-QA-AND-DOCS.md`

## Expected outcome after all report hardening phases
The project should have:
- a defined enterprise report model
- standardized report types
- a mandatory section contract per report type
- controlled severity language
- controlled risk language
- standardized remediation format
- framework mapping sections where applicable
- evidence linkage rules
- AI prompts constrained to fixed sections
- QA/validation checks for report completeness and consistency
- updated README and project memory files

## Files Codex must keep updated after each phase
Codex must update these files as applicable after every phase:
- `PROJECT_DEFINITION.md`
- `IMPLEMENTATION_PLAN.md`
- `DEVELOPMENT_HISTORY.md`
- `NEXT_STEP.md`
- `README.md`
- `CHANGELOG.md`
- `TEST_PLAN.md`
- `ARCHITECTURE_NOTES.md`

## Operator guidance
Before each phase:
- ensure Codex reads the current repository state
- ensure Codex reads the project memory markdown files
- keep each phase scoped
- do not allow Codex to redesign unrelated modules
- do not package anything in this report hardening workstream unless explicitly required by the phase

## Notes
This pack is intentionally designed to work even if the exact current report implementation differs from the earlier assumptions. Codex must inspect the real codebase and adapt precisely to what already exists.
