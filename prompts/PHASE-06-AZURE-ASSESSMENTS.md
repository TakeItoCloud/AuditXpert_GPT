You are working in this project repository/folder:
C:\Scripts\Assessment\AuditXpert_GPT

Objective for this step:
Implement Azure assessment packs covering governance, security posture, networking, compute, monitoring, resilience, and recommendation ingestion.

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
- src\AuditXpert.Assessments\Azure\*.ps1
- docs\Assessment-Coverage-Azure.md
- docs\Least-Privilege-Azure.md
- samples\findings\azure\*.json
- tests\Assessments\Azure\*.Tests.ps1
- README.md
- CHANGELOG.md
- DEVELOPMENT_HISTORY.md
- NEXT_STEP.md
- TEST_PLAN.md

Implementation requirements:
- Implement Azure packs for:
  - Subscription and management group inventory
  - Azure Policy and initiative compliance indicators
  - Defender for Cloud recommendation ingestion
  - Azure Advisor recommendation ingestion
  - Virtual machine posture indicators
  - Virtual network and NSG exposure indicators
  - Diagnostic settings / logging coverage indicators
  - Key Vault, storage, backup, and resilience indicators where feasible
- Preserve links between native recommendation sources and normalized findings.
- Allow scope selection by management group, subscription, resource group, or resource type.

Safeguards:
- Keep logic read-only.
- Handle large estates with pagination and batching patterns.
- Do not depend on portal-only manual steps where an API is available.

Validation to perform:
- Unit tests for Azure rule output shape.
- Smoke tests using fixtures.
- Validate export and report readiness for an Azure sample scope.

Documentation updates required after implementation:
- Update DEVELOPMENT_HISTORY.md.
- Update NEXT_STEP.md to the hybrid/on-prem phase.
- Update README.md.
- Update CHANGELOG.md.
- Update TEST_PLAN.md.
- Update ARCHITECTURE_NOTES.md.

Expected output:
- Summary of Azure assessment coverage
- Validation results
- Summary of documentation updates
