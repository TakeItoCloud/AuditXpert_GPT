# Remediation Writing Standard

## Purpose
Recommendations in AuditXpert_GPT reports must be concise, actionable, and implementation-oriented.

## Standard structure
Each recommendation block should support:
- recommendation
- implementation guidance
- priority
- owner where supported
- effort or change-planning notes where supported

## Writing rules
- Start with a clear action.
- Tie the action to the affected control, service, or configuration area.
- Avoid vague wording such as "review as needed" without stating the intended change direction.
- Keep recommendation text separate from raw evidence.
- Keep implementation guidance practical and change-oriented.

## Examples of preferred style
- "Review MFA registration coverage and prioritized rollout actions."
- "Improve backup coverage and resilience settings for critical Azure workloads."

## Current implementation
The reporting layer now preserves the source recommendation text and adds a fixed implementation-guidance line through:
- `src/AuditXpert.Reporting/Private/Get-AxImplementationGuidance.ps1`

## Future hardening direction
- Add owner and effort guidance from a normalized report data contract.
- Add remediation roadmap sequencing by priority, service, and dependency.
