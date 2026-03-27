# Launcher Configuration Contract

## Purpose
The launcher configuration contract captures operator intent in Python and maps it to current PowerShell execution surfaces without re-implementing assessment, connector, or reporting logic in the desktop UI.

## Model files
- `launcher/app/models/launcher_config.py`
- `launcher/app/models/auth_config.py`
- `launcher/app/models/run_profile.py`
- `launcher/app/services/config_service.py`
- `launcher/app/services/profile_catalog_service.py`
- `launcher/app/services/path_service.py`

## Core model areas

### LauncherConfig
Stores the normalized operator selections:
- selected assessment modules
- selected execution profile
- output path
- evidence path
- export formats
- install missing modules preference
- open results after run preference
- nested authentication settings
- nested AI settings

### AuthConfig
Stores launcher-side authentication intent only:
- authentication mode
- interactive or non-interactive intent
- tenant ID
- client ID
- client secret path placeholder
- secure secret entry indicator
- certificate selector metadata

The contract stores metadata and placeholders only. It does not store live secrets, tokens, or certificate content.

### AiConfig
Stores AI-explainer preferences:
- enabled or disabled
- provider
- model
- environment-variable key name placeholder
- optional secure external config path

### RunProfile
Describes how a launcher selection maps to a real PowerShell entry point:
- script or module-function binding
- supported parameters
- current implementation status
- whether the profile supports assessment module selection, output paths, auth settings, or AI settings

## Design rules
- The launcher contract is normalized around operator intent, not around every PowerShell parameter in the repository.
- Only discovered repository entry points are represented as current profiles.
- Unsupported launcher fields remain stored in the contract for later binding phases instead of being forced into fake PowerShell parameters today.
- Relative paths are treated as repository-relative.

## Current defaulting behavior
- `output_path` defaults to `output/findings`
- `evidence_path` defaults to `output/evidence`
- profile IDs are validated against the current profile catalog

## Sample config
See `launcher/samples/launcher-config.sample.json` for the current contract shape.

## Validation behavior
The config service validates:
- profile existence
- whether the selected profile supports assessment-module selection
- valid authentication mode
- app-auth minimum placeholder requirements
- AI provider or model presence when AI is enabled
- output and evidence path presence after defaults are applied

## What this phase does not do
- It does not execute PowerShell commands from the UI.
- It does not translate auth settings into connector calls yet.
- It does not store secrets or secure values directly in JSON.
