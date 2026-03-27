# Risk And Severity Standard

## Controlled severity taxonomy
AuditXpert_GPT reporting uses the following fixed severity labels:
- Critical
- High
- Medium
- Low
- Informational

## Definitions

### Critical
- Priority: Immediate
- Meaning: Immediate and material business disruption, control failure, or regulatory exposure is likely without prompt action.

### High
- Priority: Urgent
- Meaning: Significant operational, security, or compliance impact is likely if the issue is not addressed in the near term.

### Medium
- Priority: Planned
- Meaning: Noticeable operational or control weakness exists and should be remediated through a defined improvement plan.

### Low
- Priority: Scheduled
- Meaning: Limited direct impact is expected, but the issue should be corrected to improve consistency and reduce accumulated risk.

### Informational
- Priority: Monitor
- Meaning: The item provides context, status, or advisory information and should be monitored for future change.

## Reporting rules
- Reports must not invent alternate severity labels.
- Priority wording must map back to the controlled severity taxonomy.
- Executive and technical reports must use the same normalized severity language.
- Unknown or unsupported severity values must be normalized conservatively rather than emitted as freeform text.

## Current implementation
The severity taxonomy is represented in:
- `src/AuditXpert.Reporting/Templates/shared/report_schema.json`
- `src/AuditXpert.Reporting/Private/Get-AxSeverityDefinition.ps1`
