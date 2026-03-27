# Profile Mapping Notes

## Current repository-backed entry points
The launcher contract is based on the actual entry points that exist in the repository today.

### `Invoke-AuditXpert.ps1`
- Type: root PowerShell script
- Current role: bootstrap validation
- Parameters: `PassThru`
- Notes:
  - Imports the planned module manifests.
  - Confirms the repository is loadable.
  - Does not run assessments or accept launcher auth settings.

### `tools/Initialize-AuditXpert.ps1`
- Type: PowerShell script
- Current role: output workspace initialization
- Parameters: `WorkspaceRoot`, `PassThru`
- Notes:
  - Creates the consultant-friendly output folder structure.
  - Can safely consume a launcher-selected workspace root in a future binding phase.

### `tools/Run-SmokeTests.ps1`
- Type: PowerShell script
- Current role: repository smoke validation
- Parameters: `WorkspaceRoot`, `SkipPester`, `PassThru`
- Notes:
  - Runs imports, governance flow, reporting flow, and optional Pester coverage.
  - This is an operational validation profile, not an assessment-execution profile.

### `tools/Build-Release.ps1`
- Type: PowerShell script
- Current role: packaging
- Parameters: `WorkspaceRoot`, `Version`, `PassThru`
- Notes:
  - Creates a release package under `output/releases`.
  - This is a packaging profile, not an assessment-execution profile.

### `Invoke-AxAssessmentOrchestrator`
- Type: PowerShell module function in `src/AuditXpert.Cli/AuditXpert.Cli.psd1`
- Current role: assessment execution surface
- Parameters:
  - `AssessmentPack`
  - `Rule`
  - `Context`
  - `OutputPath`
  - `ExportFormat`
- Notes:
  - This is the closest current target for launcher-driven assessment execution.
  - It can accept assessment-pack selection, output path, and export-format intent today.
  - It does not currently expose dedicated launcher-friendly parameters for authentication, AI settings, or install-missing-modules behavior.
  - Current behavior still depends on stub-rule and context wiring from later integration phases.

## Mapping guidance
- Map launcher execution-profile choices only to the real entry points above.
- Treat auth settings, AI options, and install preferences as stored launcher state until matching PowerShell parameters exist.
- Avoid inventing synthetic PowerShell flags in the launcher just to force a one-to-one parameter map.
- Prefer future wrapper scripts or explicit CLI bindings over direct UI coupling to low-level module internals.

## Current gaps to address in later phases
- A versioned launcher-to-PowerShell execution contract for assessment runs
- A PowerShell entry point that accepts normalized auth intent from the launcher
- A predictable translation layer from launcher assessment-module selection into PowerShell context and pack selection
- A supported path for AI preferences to influence report generation without mixing UI state into raw evidence collection
