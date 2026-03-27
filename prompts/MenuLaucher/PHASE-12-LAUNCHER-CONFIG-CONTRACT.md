You are working in this project repository/folder:
C:\Scripts\Assessment\AuditXpert_GPT

Objective for this step:
Create the normalized launcher configuration contract that captures all operator selections from the desktop UI and maps them safely to PowerShell execution inputs without embedding assessment logic in the UI.

Before changing anything, review these project context files and follow them as the source of truth:
- PROJECT_DEFINITION.md
- IMPLEMENTATION_PLAN.md
- DEVELOPMENT_HISTORY.md
- NEXT_STEP.md
- README.md
- CHANGELOG.md
- TEST_PLAN.md
- ARCHITECTURE_NOTES.md

Inspect the current repository to identify the actual PowerShell entry points, profiles, scripts, modules, or orchestration commands that the launcher must eventually call.

Files and folders to create or modify in this step:
- launcher\app\models\launcher_config.py
- launcher\app\models\auth_config.py
- launcher\app\models\run_profile.py
- launcher\app\services\config_service.py
- launcher\app\services\profile_catalog_service.py
- launcher\app\services\path_service.py
- launcher\samples\launcher-config.sample.json
- docs\launcher\configuration-contract.md
- docs\launcher\profile-mapping-notes.md
- README.md
- IMPLEMENTATION_PLAN.md
- DEVELOPMENT_HISTORY.md
- NEXT_STEP.md
- CHANGELOG.md
- TEST_PLAN.md
- ARCHITECTURE_NOTES.md

Implementation requirements:
- Define typed Python models or dataclasses for launcher settings.
- Include fields for:
  - selected assessment modules
  - selected execution profile/tool
  - output path and evidence path
  - AI explainer enabled or disabled
  - AI provider/model/key placeholders
  - authentication mode
  - interactive login vs app authentication
  - tenant ID and client ID
  - client secret path or secure entry indicator
  - certificate thumbprint / subject / store / optional path metadata
  - install-missing-modules preference
  - open-results-after-run preference
- Create a profile mapping service that can represent how launcher selections map to PowerShell entry points.
- Do not guess unsupported parameters. Discover the real current script and profile names in the repo first, then document any gaps that need later implementation.
- If existing PowerShell entry points are incomplete, build the config contract in a way that supports current capabilities and anticipated extension points cleanly.
- Create a sample config JSON that matches the model.

Safeguards:
- Do not store real secrets in files.
- Do not embed secrets in the sample JSON.
- Do not duplicate the entire PowerShell parameter model unless the repo already defines one.
- Keep this phase focused on the contract and mapping model, not full UI behavior.

Validation to perform:
- Confirm the config models can be instantiated.
- Confirm sample JSON loads and validates.
- Confirm the mapping notes accurately describe current repository execution entry points.
- Confirm docs explain how the launcher config maps to PowerShell.

Documentation updates required after implementation:
- Update DEVELOPMENT_HISTORY.md with what was created and how it was validated.
- Update NEXT_STEP.md to point to the full UI controls and help windows phase.
- Update README.md if launcher usage/setup changed.
- Update CHANGELOG.md.
- Update TEST_PLAN.md with configuration model validation coverage.
- Update ARCHITECTURE_NOTES.md if the config contract introduces a key design decision.
- Update IMPLEMENTATION_PLAN.md if more detail is needed for launcher integration sequencing.

Expected output:
- Summary of config and mapping files created
- Validation results
- Summary of documentation updates
