# Installation

## Requirements
- PowerShell 7 or later
- Pester for local validation and smoke-test execution
- Optional workload modules depending on the target assessment scope

## Initial setup
1. Open the repository in PowerShell 7.
2. Run `./tools/Initialize-AuditXpert.ps1`.
3. Run `./tools/Run-SmokeTests.ps1` to validate the local workspace.

## Notes
- Defaults are read-only.
- AI remains optional and can be disabled completely.
- Secrets must be supplied by environment variable or secure external configuration, not checked into the repository.
