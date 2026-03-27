You are working in this project repository/folder:
C:\Scripts\Assessment\AuditXpert_GPT

Objective for this step:
Implement the normalized findings schema, the assessment-rule model, the orchestrator pipeline, and common export functions.

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
- src\AuditXpert.Assessments\Public\*.ps1
- src\AuditXpert.Assessments\Private\*.ps1
- src\AuditXpert.Cli\Public\*.ps1
- src\AuditXpert.Cli\Private\*.ps1
- docs\Findings-Schema.md
- docs\Assessment-Rule-Model.md
- docs\Export-Formats.md
- samples\findings\*.json
- tests\Assessments\*.Tests.ps1
- README.md
- CHANGELOG.md
- DEVELOPMENT_HISTORY.md
- NEXT_STEP.md
- TEST_PLAN.md

Implementation requirements:
- Define a normalized finding object with fields such as:
  - FindingId
  - Category
  - Service
  - Scope
  - Severity
  - Likelihood
  - Impact
  - RiskScore
  - Title
  - Description
  - Evidence
  - Recommendation
  - RemediationType
  - FrameworkMappings
  - Source
  - Timestamp
- Define an assessment-rule contract with metadata and evaluation logic.
- Implement an orchestrator function that can run selected assessment packs and collect findings into a unified output set.
- Implement export functions for JSON, CSV, Markdown, and HTML.
- Build sample fixture data and tests against it.

Safeguards:
- Keep scoring transparent and configurable.
- Preserve raw evidence references.
- Do not couple reporting templates to rule execution.

Validation to perform:
- Pester tests for finding shape and export functions.
- Confirm orchestrator can run stub rules and export results.

Documentation updates required after implementation:
- Update DEVELOPMENT_HISTORY.md.
- Update NEXT_STEP.md to the Microsoft 365 assessment phase.
- Update README.md.
- Update CHANGELOG.md.
- Update TEST_PLAN.md.
- Update ARCHITECTURE_NOTES.md.

Expected output:
- Summary of findings schema and engine
- Validation results
- Summary of documentation updates
