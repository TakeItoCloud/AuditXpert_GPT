# AuditXpert Desktop Launcher

## Overview
The `launcher` folder contains the source-run desktop interface for AuditXpert_GPT. It is intentionally separate from the PowerShell assessment engine and acts as a thin orchestration shell over the real backend.

## Design intent
- Keep the PowerShell modules as the system of record for prerequisites, connectors, assessments, governance, reporting, and AI.
- Use Python and PySide6 only for desktop interaction, workflow guidance, and future operator-friendly bindings.
- Avoid duplicating assessment or authentication logic in the UI layer.

## Current state
The launcher now provides:
- a PySide6 desktop entry point
- a panel-based operator UI for profile selection, scope selection, auth intent, AI options, paths, prerequisites, status, and results
- Python-side validation and a PowerShell bridge over `pwsh.exe`
- PowerShell-backed prerequisite validation and guarded module-install flow
- runtime-config export under `runtime/launcher`
- real assessment-orchestrator invocation through `Invoke-AxAssessmentOrchestrator`
- runtime-log capture and results-path surfacing in the UI

The launcher still does not provide:
- packaged installer delivery
- independent assessment or connector logic in Python
- secret storage in repo-backed config files
- full async execution or background job handling yet
- guaranteed live tenant-backed execution for every assessment profile exposed through the UI

## Current limitation
The launcher can successfully validate and invoke the backend while still returning stub assessment content. The latest observed Microsoft 365 launcher run produced a stub finding rather than proving live tenant collection, and delegated launcher auth did not trigger a real sign-in or MFA prompt in that observed path.

## Run locally
Create or activate a Python environment, install dependencies, and launch the shell from the repository root:

```powershell
python -m pip install -r .\launcher\requirements.txt
python .\launcher\main.py
```

## Folder layout
```text
launcher/
|-- main.py
|-- requirements.txt
|-- README.md
|-- samples/
`-- app/
    |-- __init__.py
    |-- models/
    |-- resources/
    |-- services/
    `-- ui/
```

## Key runtime services
- `app/services/process_service.py`: process wrapper for `pwsh.exe`
- `app/services/powershell_bridge_service.py`: launcher-facing PowerShell invocation layer
- `app/services/launcher_validation_service.py`: Python-side config and path validation
- `app/services/prereq_service.py`: prerequisite validation and guarded module-install calls
- `app/services/runtime_config_service.py`: runtime-contract export
- `app/services/runtime_state_service.py`: normalized runtime-state tracking

## Source-run workflow
1. Start the launcher from source.
2. Choose a profile and assessment scope.
3. Validate launcher state.
4. Review prerequisite output.
5. Run the backend profile.
6. Inspect the results panel for output folder, report-capable artifact, and runtime log.

Successful backend invocation does not yet imply live assessment maturity. Operators should inspect the returned findings and runtime log until stub execution paths have been removed or clearly labeled in the UI.

## Docs
- `docs/Launcher-Execution-Flow.md`
- `docs/Launcher-Operator-Guide.md`
- `docs/launcher/configuration-contract.md`
- `docs/launcher/runtime-contract.md`
- `docs/launcher/app-auth-setup-guide.md`

## Integration direction
The launcher is now a functional source-run shell, but packaging remains out of scope. Immediate future work should focus on replacing stub execution with real connector-backed assessment paths, clarifying operator messaging, and making auth and run-state behavior explicit instead of duplicating backend behavior in Python.
