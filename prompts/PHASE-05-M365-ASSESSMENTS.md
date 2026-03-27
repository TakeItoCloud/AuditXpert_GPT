You are working in this project repository/folder:
C:\Scripts\Assessment\AuditXpert_GPT

Objective for this step:
Implement the first Microsoft 365 assessment packs for Entra ID, Intune, Exchange Online, Defender-related posture data, and Microsoft Secure Score ingestion.

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
- src\AuditXpert.Assessments\M365\*.ps1
- docs\Assessment-Coverage-M365.md
- docs\Least-Privilege-M365.md
- samples\findings\m365\*.json
- tests\Assessments\M365\*.Tests.ps1
- README.md
- CHANGELOG.md
- DEVELOPMENT_HISTORY.md
- NEXT_STEP.md
- TEST_PLAN.md

Implementation requirements:
- Create assessment packs for:
  - Entra ID identity posture
  - Conditional access and MFA coverage indicators
  - Legacy authentication exposure indicators where available
  - Administrative role hygiene indicators
  - Intune baseline and policy conflict indicators
  - Exchange Online mail flow and protection posture indicators
  - Defender-related posture feeds available through approved connectors
  - Microsoft Secure Score collection and finding translation
- Ensure every rule emits normalized findings.
- Add clear evidence fields and recommendation text placeholders.
- Keep rules modular and service-specific.

Safeguards:
- Do not create or modify tenant configuration.
- Handle partial permission coverage cleanly.
- Document unsupported API surfaces explicitly.

Validation to perform:
- Unit tests for rule output shape.
- Smoke tests using fixture data.
- Validate exports for at least one M365 scope.

Documentation updates required after implementation:
- Update DEVELOPMENT_HISTORY.md.
- Update NEXT_STEP.md to the Azure assessment phase.
- Update README.md.
- Update CHANGELOG.md.
- Update TEST_PLAN.md.
- Update ARCHITECTURE_NOTES.md.

Expected output:
- Summary of M365 assessment coverage
- Validation results
- Summary of documentation updates
