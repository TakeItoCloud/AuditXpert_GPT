You are working in this project repository/folder:
C:\Scripts\Assessment\AuditXpert_GPT

Objective for this step:
Implement the connector framework and authentication abstractions for Microsoft Graph, Exchange Online, Azure, and hybrid/on-prem collection.

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
- src\AuditXpert.Connectors\Public\*.ps1
- src\AuditXpert.Connectors\Private\*.ps1
- docs\Authentication-Model.md
- docs\Connector-Matrix.md
- samples\auth\*.json
- tests\Connectors\*.Tests.ps1
- README.md
- CHANGELOG.md
- DEVELOPMENT_HISTORY.md
- NEXT_STEP.md
- TEST_PLAN.md

Implementation requirements:
- Build connector abstractions instead of embedding sign-in logic in assessment rules.
- Implement connector wrappers for:
  - Microsoft Graph
  - Exchange Online
  - Azure
  - Active Directory / hybrid local collectors
- Support delegated and app-only patterns where practical.
- Create a connector metadata model that declares supported auth methods, module dependencies, and permission requirements.
- Implement safe connect/disconnect lifecycle handling.
- Implement `Test-AxConnectorAccess` style readiness checks.
- Add transcript-safe logging that does not leak secrets.
- Create placeholder collection functions that return typed objects or stubbed datasets for later assessment phases.

Safeguards:
- No real broad data harvesting yet beyond minimal safe connectivity validation.
- Do not embed secrets in config samples.
- Keep connector code separate from rule logic.

Validation to perform:
- Confirm connectors can initialize cleanly.
- Confirm failure paths are operator-friendly when modules or permissions are missing.
- Add Pester coverage for connector metadata and safe error handling.

Documentation updates required after implementation:
- Update DEVELOPMENT_HISTORY.md.
- Update NEXT_STEP.md to findings schema and assessment engine.
- Update README.md.
- Update CHANGELOG.md.
- Update TEST_PLAN.md.
- Update ARCHITECTURE_NOTES.md.

Expected output:
- Summary of connector framework
- Validation results
- Summary of documentation updates
