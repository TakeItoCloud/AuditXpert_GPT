# Evidence Traceability Standard

## Purpose
Report content must remain traceable to normalized findings, evidence references, and service scope.

## Minimum traceability requirements
- Every rendered finding block must include the `FindingId`.
- Evidence summaries must derive from the finding evidence payload when present.
- Report content must preserve service and scope references.
- Governance outputs must preserve related finding references.
- AI-assisted narrative, when used later, must not be treated as evidence.

## Required report fields for traceability
- finding title
- finding ID
- affected scope
- service
- evidence summary
- framework or control mapping
- traceability line

## Current implementation
The reporting layer now uses:
- `Get-AxFindingEvidenceSummary`
- `Get-AxFindingFrameworkSummary`
- fixed finding-block ordering in the technical report renderer

## Rules
- Do not remove finding IDs from rendered report content.
- Do not replace evidence references with AI-generated prose.
- Do not collapse service appendix content into generic narrative without preserving service grouping.
- If evidence is absent, render a controlled placeholder rather than hiding the gap.
