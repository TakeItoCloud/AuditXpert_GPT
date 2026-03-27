You are working in this project repository/folder:
C:\Scripts\Assessment\AuditXpert_GPT

Objective for this step:
Add the desktop launcher foundation for AuditXpert_GPT using Python and PySide6, with a clean enterprise folder structure, starter application entry point, UI shell, launcher README content, and integration notes that fit the existing PowerShell-first platform.

Before changing anything, review these project context files and follow them as the source of truth:
- PROJECT_DEFINITION.md
- IMPLEMENTATION_PLAN.md
- DEVELOPMENT_HISTORY.md
- NEXT_STEP.md
- README.md
- CHANGELOG.md
- TEST_PLAN.md
- ARCHITECTURE_NOTES.md

Also inspect the actual current repository structure before creating files. If folder names or module names differ from the planning docs, align to the real repository while preserving the intended architecture.

Files and folders to create or modify in this step:
- launcher\
- launcher\README.md
- launcher\requirements.txt
- launcher\main.py
- launcher\app\__init__.py
- launcher\app\ui\__init__.py
- launcher\app\services\__init__.py
- launcher\app\models\__init__.py
- launcher\app\resources\__init__.py
- launcher\app\ui\main_window.py
- launcher\app\ui\theme.py
- launcher\app\resources\branding.md
- docs\launcher\
- docs\launcher\desktop-launcher-overview.md
- README.md
- IMPLEMENTATION_PLAN.md
- DEVELOPMENT_HISTORY.md
- NEXT_STEP.md
- CHANGELOG.md
- TEST_PLAN.md
- ARCHITECTURE_NOTES.md

Implementation requirements:
- Create a Python-based launcher area that is clearly separated from the PowerShell engine.
- Use PySide6 as the desktop UI framework.
- Create an enterprise-style main window shell with placeholder sections for assessment selection, authentication, AI options, paths, prerequisites, help, execution status, and results.
- Do not implement real business logic in this phase; focus on structure and a working application shell.
- Ensure `main.py` launches the window successfully when dependencies are installed.
- Add a requirements.txt containing only the dependencies actually needed in this phase.
- Add launcher README content explaining how the launcher fits into the broader architecture.
- Update architecture notes to document that the UI is a thin orchestration layer over the PowerShell engine.

Safeguards:
- Do not move or rewrite the existing PowerShell engine.
- Do not duplicate assessment or authentication logic in Python.
- Do not hardcode secrets, tenant IDs, certificate thumbprints, or output paths.
- Keep styling maintainable and internal to the launcher folder.
- Keep this phase limited to scaffolding and a functional shell.

Validation to perform:
- Confirm the launcher folder structure exists.
- Confirm `python launcher\main.py` starts the UI without syntax errors when dependencies are installed.
- Confirm imports resolve cleanly.
- Confirm root docs reflect the new launcher component.

Documentation updates required after implementation:
- Update DEVELOPMENT_HISTORY.md with what was created and how it was validated.
- Update NEXT_STEP.md to point to the configuration contract and UI binding phase.
- Update README.md with the launcher component and repository structure changes.
- Update CHANGELOG.md.
- Update TEST_PLAN.md with launcher smoke-test validation.
- Update ARCHITECTURE_NOTES.md with the desktop launcher design.
- Update IMPLEMENTATION_PLAN.md if a new launcher workstream or phase detail is needed.

Expected output:
- Summary of launcher foundation files and folders created
- Validation results
- Summary of documentation updates
