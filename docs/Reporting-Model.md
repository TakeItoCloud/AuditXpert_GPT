# Reporting Model

## Purpose
The reporting layer converts normalized findings and governance outputs into reusable report sections for technical and executive audiences using fixed report contracts and controlled section standards.

## Current outputs
- Executive summary
- Technical assessment report
- Governance / vCISO summary
- Service-specific appendix

## Template assets
- `src/AuditXpert.Reporting/Templates/shared/report_schema.json`
- `src/AuditXpert.Reporting/Templates/shared/section_contracts.json`
- `src/AuditXpert.Reporting/Templates/reports/*.json`

## Current standardization behavior
- Report titles and output names are defined by template assets.
- Shared section families are controlled through shared section contracts.
- Severity labels are normalized through the report schema taxonomy.
- Technical finding blocks follow a fixed presentation order.
- Evidence, framework mapping, and implementation guidance are represented consistently even when the source data is sparse.

## Design principles
- Keep generated prose separate from raw evidence
- Preserve traceability to finding IDs in narrative sections
- Support non-AI report generation as the default path
- Prefer template-driven standardization over freeform string assembly where practical
