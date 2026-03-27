You are working in this project repository/folder:
C:\Scripts\Assessment\AuditXpert_GPT

Objective for this step:
Implement hybrid/on-prem assessment packs for Active Directory, Domain Controllers, GPO/security baseline posture, hybrid identity, and optional Exchange hybrid/on-prem signals.

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
- src\AuditXpert.Assessments\Hybrid\*.ps1
- docs\Assessment-Coverage-Hybrid.md
- docs\Least-Privilege-Hybrid.md
- samples\findings\hybrid\*.json
- tests\Assessments\Hybrid\*.Tests.ps1
- README.md
- CHANGELOG.md
- DEVELOPMENT_HISTORY.md
- NEXT_STEP.md
- TEST_PLAN.md

Implementation requirements:
- Create rules for:
  - Active Directory hygiene indicators
  - Privileged group exposure indicators
  - Stale account indicators
  - Domain Controller posture indicators
  - GPO/security baseline comparison indicators
  - Hybrid identity sync posture indicators
  - Optional AD CS posture indicators if support is added
  - Optional Exchange hybrid/on-prem indicators if support is added
- Prefer read-only collection using standard modules and system commands.
- Separate data collection from assessment evaluation.
- Ensure findings fit the normalized schema.

Safeguards:
- Avoid invasive collection methods.
- Handle missing RSAT/AD modules gracefully.
- Clearly mark lab-only or optional checks.

Validation to perform:
- Unit tests for hybrid rule output shape.
- Smoke tests in a lab-friendly mode.
- Validate export of hybrid findings.

Documentation updates required after implementation:
- Update DEVELOPMENT_HISTORY.md.
- Update NEXT_STEP.md to the governance/regulatory phase.
- Update README.md.
- Update CHANGELOG.md.
- Update TEST_PLAN.md.
- Update ARCHITECTURE_NOTES.md.

Expected output:
- Summary of hybrid assessment coverage
- Validation results
- Summary of documentation updates
