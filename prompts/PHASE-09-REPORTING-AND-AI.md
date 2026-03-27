You are working in this project repository/folder:
C:\Scripts\Assessment\AuditXpert_GPT

Objective for this step:
Implement the reporting engine and AI explainer layer that convert normalized findings and governance outputs into enterprise technical and executive reports.

Before changing anything, review these project context files and follow them as the source of truth:
- PROJECT_DEFINITION.md
- IMPLEMENTATION_PLAN.md
- DEVELOPMENT_HISTORY.md
- NEXT_STEP.md
- README.md
- CHANGELOG.md
- TEST_PLAN.md
- ARCHITECTURE_NOTES.md

Files and folders to create or modify in this step:
- src\AuditXpert.Reporting\Public\*.ps1
- src\AuditXpert.Reporting\Private\*.ps1
- src\AuditXpert.AI\Public\*.ps1
- src\AuditXpert.AI\Private\*.ps1
- docs\Reporting-Model.md
- docs\AI-Explainer-Model.md
- samples\reports\*.md
- samples\reports\*.html
- tests\Reporting\*.Tests.ps1
- tests\AI\*.Tests.ps1
- README.md
- CHANGELOG.md
- DEVELOPMENT_HISTORY.md
- NEXT_STEP.md
- TEST_PLAN.md

Implementation requirements:
- Create report templates for:
  - Executive summary
  - Technical findings report
  - Risk register summary
  - Service-specific appendix
- Build an AI prompt-rendering pipeline that uses normalized findings and governance output as input.
- Require traceability from each narrative section back to finding IDs.
- Keep raw evidence separate from generated prose.
- Support safe handling of API key configuration via environment variable or secure external config.
- Add a clear switch to disable AI and generate non-AI reports only.

Safeguards:
- Do not send secrets or raw tokens to logs.
- Do not present AI-generated narrative as evidence.
- Clearly label AI-assisted content.

Validation to perform:
- Unit tests for report rendering.
- Fixture-based tests for AI prompt payload construction.
- Confirm report output can be generated without AI enabled.

Documentation updates required after implementation:
- Update DEVELOPMENT_HISTORY.md.
- Update NEXT_STEP.md to the hardening/packaging phase.
- Update README.md.
- Update CHANGELOG.md.
- Update TEST_PLAN.md.
- Update ARCHITECTURE_NOTES.md.

Expected output:
- Summary of reporting and AI implementation
- Validation results
- Summary of documentation updates
