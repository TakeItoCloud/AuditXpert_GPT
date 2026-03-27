You are working in this project repository/folder:
C:\Scripts\Assessment\AuditXpert_GPT

Objective for this step:
Implement the shared core framework and prerequisite engine, including configuration loading, logging, run context, module checks, permission manifest structure, and install prompts for missing prerequisites.

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
- src\AuditXpert.Core\Public\*.ps1
- src\AuditXpert.Core\Private\*.ps1
- src\AuditXpert.Prereqs\Public\*.ps1
- src\AuditXpert.Prereqs\Private\*.ps1
- config\default.settings.json
- config\permissions-manifest.json
- samples\sample-scope.m365.json
- samples\sample-scope.azure.json
- samples\sample-scope.hybrid.json
- docs\Prerequisites.md
- docs\Permissions-Model.md
- tests\Core\*.Tests.ps1
- tests\Prereqs\*.Tests.ps1
- README.md
- TEST_PLAN.md
- CHANGELOG.md
- DEVELOPMENT_HISTORY.md
- NEXT_STEP.md

Implementation requirements:
- Implement a configuration loader with sane defaults and override support.
- Implement structured logging with timestamp, run ID, level, component, and message.
- Implement a run context object that stores execution metadata, scope, output path, and operator details.
- Implement prerequisite checks for:
  - PowerShell version
  - Required modules
  - internet connectivity where needed
  - output path creation
  - presence of required config files
- Implement a permissions manifest model that documents required roles/scopes per connector and per assessment pack.
- If a required module is missing, prompt the operator before attempting installation.
- Keep install behavior optional and operator-driven.
- Expose clear functions such as `Test-AxEnvironmentReadiness`, `Get-AxRequiredModule`, `Install-AxRequiredModule`, `New-AxRunContext`, and `Write-AxLog`.

Safeguards:
- No connector sign-in logic yet beyond interface placeholders.
- Do not assume admin rights for module installation.
- Do not suppress errors silently.
- Keep module responsibilities separated.

Validation to perform:
- Pester tests for config loader and logging.
- Smoke tests for missing-module detection.
- Smoke tests for install prompt logic.
- Confirm sample settings load correctly.

Documentation updates required after implementation:
- Update DEVELOPMENT_HISTORY.md.
- Update NEXT_STEP.md to the connectors/authentication phase.
- Update README.md with prerequisite usage.
- Update CHANGELOG.md.
- Update TEST_PLAN.md.
- Update ARCHITECTURE_NOTES.md if needed.

Expected output:
- Summary of implemented core functions
- Validation results
- Summary of documentation updates
