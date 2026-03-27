You are working in this project repository/folder:
C:\Scripts\Assessment\AuditXpert_GPT

Objective for this step:
Link the desktop launcher selections to the existing PowerShell engine so the chosen profile, scopes, AI setting, auth mode, paths, and other selected options are translated into the correct execution command, variables, config payload, and run workflow.

Before changing anything, review these project context files and follow them as the source of truth:
- PROJECT_DEFINITION.md
- IMPLEMENTATION_PLAN.md
- DEVELOPMENT_HISTORY.md
- NEXT_STEP.md
- README.md
- CHANGELOG.md
- TEST_PLAN.md
- ARCHITECTURE_NOTES.md

Inspect the current PowerShell repository to identify the actual runnable entry points, expected parameters, config files, or orchestration patterns. Use the real implementation as the source of truth. Do not invent final script names or parameters if the repository already defines them.

Files and folders to create or modify in this step:
- launcher\app\services\powershell_bridge.py
- launcher\app\services\process_runner.py
- launcher\app\services\run_request_builder.py
- launcher\app\services\results_locator.py
- launcher\app\ui\main_window.py
- docs\launcher\powershell-bridge-notes.md
- docs\launcher\execution-flow.md
- README.md
- IMPLEMENTATION_PLAN.md
- DEVELOPMENT_HISTORY.md
- NEXT_STEP.md
- CHANGELOG.md
- TEST_PLAN.md
- ARCHITECTURE_NOTES.md

Implementation requirements:
- Build a PowerShell bridge layer that converts launcher selections into a normalized run request.
- The bridge must then translate that run request into the actual PowerShell invocation required by the repository.
- Support the real current execution model in the repo, such as:
  - bootstrap script
  - profile script
  - module entry point
  - config-file driven run
- Ensure the launcher can pass or persist values for:
  - selected tool/profile
  - selected service scopes
  - output path
  - evidence path
  - AI explainer enabled/disabled
  - auth mode
  - tenant/client identifiers
  - app auth subtype
  - secret/certificate metadata
  - install-missing-modules preference
- Use secure handling patterns for sensitive values; do not log raw secrets.
- Add process execution, stdout/stderr capture, status updates, and exit-code handling.
- Wire the main Run action in the UI to this bridge.
- Add post-run results discovery so the UI can offer actions such as open output folder or open latest report.

Safeguards:
- Do not replace working PowerShell orchestration that already exists.
- Do not leak secrets into logs, sample config, or process output windows.
- If the current repo is missing required parameters for UI-driven execution, add extension points carefully and document them.
- Keep the Python layer thin and orchestration-focused.

Validation to perform:
- Confirm the launcher can build a run request from UI state.
- Confirm the bridge generates the expected PowerShell command or config handoff.
- Confirm a safe smoke test can launch a non-destructive run or placeholder execution path.
- Confirm status and error information surface back to the UI.

Documentation updates required after implementation:
- Update DEVELOPMENT_HISTORY.md with what was created and how it was validated.
- Update NEXT_STEP.md to point to prerequisite checks, auth validation, and setup workflows.
- Update README.md with launcher execution notes.
- Update CHANGELOG.md.
- Update TEST_PLAN.md with bridge and process-execution validation cases.
- Update ARCHITECTURE_NOTES.md with bridge design decisions.
- Update IMPLEMENTATION_PLAN.md if the launcher-to-engine integration changes sequencing.

Expected output:
- Summary of bridge and execution files created or updated
- Validation results
- Summary of documentation updates
