You are working in this project repository/folder:
C:\Scripts\Assessment\AuditXpert_GPT

Objective for this step:
Implement launcher-driven prerequisite checking, optional module installation workflows, and authentication pre-validation so operators can confirm readiness before running assessments.

Before changing anything, review these project context files and follow them as the source of truth:
- PROJECT_DEFINITION.md
- IMPLEMENTATION_PLAN.md
- DEVELOPMENT_HISTORY.md
- NEXT_STEP.md
- README.md
- CHANGELOG.md
- TEST_PLAN.md
- ARCHITECTURE_NOTES.md

Inspect the existing PowerShell prerequisite and authentication code in the repository. Reuse it where available rather than duplicating the logic in Python.

Files and folders to create or modify in this step:
- launcher\app\services\prereq_bridge.py
- launcher\app\services\auth_validation_service.py
- launcher\app\services\module_install_service.py
- launcher\app\ui\prereqs_panel.py
- launcher\app\ui\auth_panel.py
- docs\launcher\prerequisite-workflow.md
- docs\launcher\auth-validation-notes.md
- README.md
- IMPLEMENTATION_PLAN.md
- DEVELOPMENT_HISTORY.md
- NEXT_STEP.md
- CHANGELOG.md
- TEST_PLAN.md
- ARCHITECTURE_NOTES.md

Implementation requirements:
- Add a launcher action to check prerequisites before execution.
- Where the PowerShell engine already has prerequisite logic, invoke it and display normalized results in the UI.
- If missing modules are detected, allow the operator to choose whether to install them.
- Add pre-validation for selected authentication mode:
  - interactive login readiness
  - app auth input completeness
  - client secret input presence when client secret mode is selected
  - certificate metadata presence when certificate mode is selected
- Surface prerequisite and auth-validation results clearly in the UI.
- Separate validation errors, warnings, informational notes, and actionable remediation text.
- Ensure no secrets are echoed back to logs or UI result panes in plain text.

Safeguards:
- Do not build a second independent prerequisite engine in Python if one already exists in PowerShell.
- Do not auto-install modules without an explicit user action.
- Do not attempt destructive changes or tenant modifications.
- Keep this phase limited to readiness checks and install orchestration.

Validation to perform:
- Confirm prerequisite checks can be triggered from the launcher.
- Confirm missing-module scenarios are displayed correctly.
- Confirm module install requests are routed through the intended workflow.
- Confirm auth validation changes dynamically based on selected auth mode and subtype.

Documentation updates required after implementation:
- Update DEVELOPMENT_HISTORY.md with what was created and how it was validated.
- Update NEXT_STEP.md to point to packaging, polish, and distribution readiness.
- Update README.md with launcher prerequisite and auth guidance.
- Update CHANGELOG.md.
- Update TEST_PLAN.md with prerequisite and auth-validation test cases.
- Update ARCHITECTURE_NOTES.md if readiness orchestration introduces key design choices.
- Update IMPLEMENTATION_PLAN.md if prerequisite workflows alter the plan.

Expected output:
- Summary of prerequisite and auth-validation components created or updated
- Validation results
- Summary of documentation updates
