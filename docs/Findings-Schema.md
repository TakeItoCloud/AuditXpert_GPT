# Findings Schema

## Purpose
The normalized findings schema gives every assessment pack a common output contract so technical rules, governance mapping, and reporting can work from the same structure.

## Required fields
- `FindingId`
- `Category`
- `Service`
- `Scope`
- `Severity`
- `Likelihood`
- `Impact`
- `RiskScore`
- `Title`
- `Description`
- `Evidence`
- `Recommendation`
- `RemediationType`
- `FrameworkMappings`
- `Source`
- `Timestamp`

## Scoring model
Risk scoring is transparent and deterministic in the current phase. `RiskScore` is calculated from the numeric weight of `Likelihood` multiplied by the numeric weight of `Impact`.

Severity labels are separate from the score so future packs can tune presentation without hiding the underlying basis for prioritization.

## Evidence handling
- Preserve raw evidence references as structured objects
- Keep evidence separate from narrative wording
- Ensure downstream reporting can trace each finding back to source connector and rule metadata
