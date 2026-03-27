# Next Step

## Current recommended step
PowerShell process bridging and execution wiring after the Phase 13 launcher UI phase.

## Objective
Bind the launcher state model to safe PowerShell process invocation so the UI can launch supported repository entry points, collect status, and persist run artifacts without duplicating platform logic.

## Why this is next
The launcher now has a shell, a normalized configuration contract, and interactive UI controls. The next step is to wire those controls into explicit PowerShell process calls and execution-state handling.

## Files to create or modify
- Launcher process or bridge services
- Launcher execution-status plumbing
- Safe PowerShell invocation helpers
- Launcher run-history or artifact-handling helpers
- Launcher-focused smoke tests
- Root project-memory markdown files as needed to reflect implementation progress

## Dependencies or prerequisites
- Phase 13 launcher UI complete
- PowerShell 7 preferred
- Python 3.11 or later for launcher validation
- Write access to target folder

## Validation required
- Confirm launcher actions invoke supported PowerShell entry points safely
- Confirm process output and status can be surfaced back into the UI cleanly
- Confirm the launcher remains a thin client and does not duplicate platform logic

## After completion update
- DEVELOPMENT_HISTORY.md
- CHANGELOG.md
- README.md
- TEST_PLAN.md
- ARCHITECTURE_NOTES.md
