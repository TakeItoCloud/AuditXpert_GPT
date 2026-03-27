# Hybrid And On-Prem Assessment Coverage

## Current Phase 07 coverage
- Active Directory hygiene indicators
- Privileged group exposure indicators
- Stale account indicators
- Domain Controller posture indicators
- GPO and security baseline comparison indicators
- Hybrid identity sync posture indicators
- Optional AD CS posture indicators
- Optional Exchange hybrid and on-prem indicators

## Collection model
The current hybrid phase is fixture-backed and lab-friendly. Rules are written to align with read-only collection patterns using standard modules and system commands when available, while handling missing RSAT or AD tooling gracefully.

## Optional checks
- AD CS checks are explicitly marked optional and lab-only unless support is enabled
- Exchange hybrid or on-prem checks are explicitly marked optional and lab-only unless support is enabled

## Output model
All hybrid and on-prem rules emit normalized findings through the shared findings engine, with evidence notes that identify optional or lab-only collection boundaries.
