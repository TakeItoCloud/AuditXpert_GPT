# Findings To Report Mapping Standard

## Purpose
The AI layer must consume normalized report-ready records instead of raw uncontrolled finding blobs wherever practical.

## Mapped record fields
The AI reporting mapping model now standardizes these fields:
- `finding_id`
- `title`
- `severity`
- `service`
- `category`
- `affected_scope`
- `issue_summary`
- `evidence`
- `evidence_summary`
- `recommendation`
- `business_impact`
- `technical_impact`
- `control_mapping`
- `remediation_priority`
- `implementation_guidance`
- `owner`
- `effort`
- `traceability`

## Source rules
- Severity and priority derive from the controlled reporting taxonomy.
- Evidence summary derives from the finding evidence payload.
- Control mapping derives from finding framework mappings or related governance control domains.
- Owner and remediation priority derive from related risk-register rows when available.
- Missing optional values should remain explicit rather than fabricated.

## Required mapped fields
These fields are required before AI prompt packaging proceeds:
- `finding_id`
- `title`
- `severity`
- `service`
- `affected_scope`
- `issue_summary`
- `evidence_summary`
- `recommendation`
- `business_impact`
- `technical_impact`
- `control_mapping`
- `remediation_priority`
- `traceability`

## Current implementation
The current mapping path uses:
- `Convert-AxFindingToAiReportRecord`
- `Convert-AxFindingsToAiReportInput`
- `Test-AxAiMappedRecordSet`

## Design rule
AI prompt payloads may still include the raw findings for compatibility, but mapped report records are the authoritative content source for AI narrative preparation.
