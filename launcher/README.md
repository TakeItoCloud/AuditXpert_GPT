# AuditXpert Desktop Launcher

## Overview
The `launcher` folder contains the desktop user interface foundation for AuditXpert_GPT. It is intentionally separate from the PowerShell assessment engine and acts only as a thin orchestration shell.

## Design intent
- Keep the PowerShell modules as the system of record for prerequisites, connectors, assessments, governance, reporting, and AI.
- Use Python and PySide6 only for desktop interaction, workflow guidance, and future operator-friendly bindings.
- Avoid duplicating assessment or authentication logic in the UI layer.

## Current phase scope
This phase provides:
- a PySide6 application entry point
- a main window shell with enterprise-style placeholder sections
- local theme helpers
- starter package structure for future services, models, and resources

This phase does not provide:
- live PowerShell execution wiring
- tenant authentication logic
- real assessment execution
- result parsing beyond placeholder UI panels

## Run locally
Create or activate a Python environment, install the phase dependencies, and launch the shell from the repository root:

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
`-- app/
    |-- __init__.py
    |-- models/
    |   `-- __init__.py
    |-- resources/
    |   |-- __init__.py
    |   `-- branding.md
    |-- services/
    |   `-- __init__.py
    `-- ui/
        |-- __init__.py
        |-- main_window.py
        `-- theme.py
```

## Integration direction
Future phases should bind launcher actions to explicit PowerShell command contracts rather than importing business rules into Python. The launcher should remain a coordinator, not a second implementation of the platform.
