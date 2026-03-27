You are working in this project repository/folder:
C:\Scripts\Assessment\AuditXpert_GPT

Objective for this step:
Implement the enterprise desktop launcher user interface, including dynamic controls, authentication submenus, AI explainer toggle fields, output/path selectors, prerequisite action section, status areas, and a separate help window for app-authentication setup guidance.

Before changing anything, review these project context files and follow them as the source of truth:
- PROJECT_DEFINITION.md
- IMPLEMENTATION_PLAN.md
- DEVELOPMENT_HISTORY.md
- NEXT_STEP.md
- README.md
- CHANGELOG.md
- TEST_PLAN.md
- ARCHITECTURE_NOTES.md

Inspect the current launcher files created in prior phases before extending them.

Files and folders to create or modify in this step:
- launcher\app\ui\main_window.py
- launcher\app\ui\auth_panel.py
- launcher\app\ui\assessment_panel.py
- launcher\app\ui\ai_panel.py
- launcher\app\ui\paths_panel.py
- launcher\app\ui\prereqs_panel.py
- launcher\app\ui\status_panel.py
- launcher\app\ui\results_panel.py
- launcher\app\ui\help_window.py
- launcher\app\ui\widgets\__init__.py
- launcher\app\ui\widgets\section_card.py
- docs\launcher\app-auth-setup-guide.md
- docs\launcher\ui-behavior-notes.md
- README.md
- DEVELOPMENT_HISTORY.md
- NEXT_STEP.md
- CHANGELOG.md
- TEST_PLAN.md
- ARCHITECTURE_NOTES.md

Implementation requirements:
- Build a professional desktop window layout appropriate for an enterprise admin tool.
- Include sections for:
  - assessment tool/profile selection
  - scope/module selection
  - authentication settings
  - AI explainer on/off and dependent fields
  - path selectors
  - prerequisite checks and install actions
  - run summary / status
  - results actions
- Authentication UX requirements:
  - Support interactive login and app authentication choices.
  - If app authentication is selected, show sub-options for client secret and certificate.
  - If client secret is selected, reveal an input field for the secret or secure-entry control.
  - If certificate is selected, reveal certificate-related controls.
- Add a visible text link or clickable label such as `How to setup App Auth`.
- Clicking that option must open a separate desktop window with step-by-step guidance for app registration, required permissions, admin consent, client secret setup, and certificate setup.
- The help content should be maintainable from docs or structured text, not hardcoded as a giant string when a cleaner approach is available.
- Bind UI controls to the launcher configuration model cleanly.
- Keep visual design consistent and maintainable.

Safeguards:
- Do not execute PowerShell from button handlers yet beyond safe placeholders if needed.
- Do not hardcode real permission values unless they are already documented in the repo and clearly separated into maintainable configuration.
- Keep control naming clear so later PowerShell bridge code can map reliably.
- Avoid UI duplication or deeply tangled event logic.

Validation to perform:
- Confirm the main window loads successfully.
- Confirm dynamic visibility works for auth mode, auth subtype, and AI controls.
- Confirm the help window opens and displays the setup guidance.
- Confirm launcher state updates correctly when fields change.

Documentation updates required after implementation:
- Update DEVELOPMENT_HISTORY.md with what was created and how it was validated.
- Update NEXT_STEP.md to point to PowerShell process bridging and execution wiring.
- Update README.md with launcher UI usage notes.
- Update CHANGELOG.md.
- Update TEST_PLAN.md with UI smoke-test and control-behavior checks.
- Update ARCHITECTURE_NOTES.md if UI state management introduces important design choices.

Expected output:
- Summary of UI and help-window components created or updated
- Validation results
- Summary of documentation updates
