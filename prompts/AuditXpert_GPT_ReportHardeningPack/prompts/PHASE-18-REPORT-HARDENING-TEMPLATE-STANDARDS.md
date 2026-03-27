You are working in this project repository/folder:

C:\Scripts\Assessment\AuditXpert_GPT

Objective for this step:
Create and implement the report standardization layer so AuditXpert_GPT uses fixed enterprise report templates, mandatory sections, controlled severity language, controlled remediation structure, and report-type-specific output contracts.

Before changing anything, review these project context files and follow them as the source of truth:
- PROJECT_DEFINITION.md
- IMPLEMENTATION_PLAN.md
- DEVELOPMENT_HISTORY.md
- NEXT_STEP.md
- README.md
- CHANGELOG.md
- TEST_PLAN.md
- ARCHITECTURE_NOTES.md

Also review the report-hardening documentation produced in the previous phase:
- docs\reporting\REPORTING_CURRENT_STATE.md
- docs\reporting\REPORT_HARDENING_GAP_ANALYSIS.md
- docs\reporting\REPORT_TYPES_CATALOG.md
- docs\reporting\REPORT_DATA_FLOW.md
- docs\reporting\REPORT_HARDENING_BACKLOG.md

Files and folders to create or modify in this step:
- create `docs\reporting\REPORT_STANDARDS.md`
- create `docs\reporting\RISK_AND_SEVERITY_STANDARD.md`
- create `docs\reporting\REMEDIATION_WRITING_STANDARD.md`
- create `docs\reporting\EVIDENCE_TRACEABILITY_STANDARD.md`
- create a new folder for report definitions if one does not already exist, such as:
  - `reporting\templates\`
  - or adapt to the existing repo pattern if a report/template folder already exists
- create or update fixed template definition assets for these report types:
  - executive summary report
  - technical assessment report
  - governance / vCISO report
  - Azure assessment report
  - Microsoft 365 assessment report
  - hybrid infrastructure report
  - remediation roadmap report
- create or update a shared section contract definition asset if useful, for example:
  - `reporting\templates\shared\section_contracts.*`
  - `reporting\templates\shared\report_schema.*`
  - adapt extension to the existing implementation pattern
- update renderer logic or template loader logic only as needed to support fixed report contracts
- update the project memory files listed below

Implementation requirements:
- Inspect the existing report/template implementation before deciding exact file names and extensions.
- Do not invent an entirely new architecture if the existing implementation can be extended cleanly.
- Define mandatory sections per report type. At minimum, support these section families where applicable:
  - report title and metadata
  - scope
  - methodology
  - executive summary
  - risk overview
  - key findings
  - recommendations
  - remediation roadmap
  - compliance/control mapping
  - service-specific detail
  - evidence/appendix
- Enforce a controlled severity taxonomy. Standardize labels and definitions, for example:
  - Critical
  - High
  - Medium
  - Low
  - Informational
- Standardize impact language and priority language so different reports do not use inconsistent severity wording.
- Standardize finding presentation. Each finding block should have a defined structure similar to:
  - finding title
  - finding ID
  - severity
  - affected scope
  - issue summary
  - business impact
  - technical impact
  - evidence summary
  - recommendation
  - implementation guidance
  - framework/control mapping
  - owner/priority/effort where supported
- Standardize remediation writing so recommendations are concise, actionable, and implementation-oriented.
- Standardize evidence traceability so report content can link back to findings IDs, evidence references, and service scope.
- Ensure there is clear separation between:
  - executive-friendly reports
  - technical delivery reports
  - governance/compliance reports
- Ensure service-specific reports inherit shared standards but can have service-specific appendix sections.
- Prefer configuration- or template-driven standardization instead of hardcoded string assembly where practical.
- Maintain backward compatibility with existing report execution flow as much as possible.

Safeguards:
- Do not break existing logic.
- Preserve backward compatibility unless impossible, and then document the impact.
- Keep changes scoped to this step only.
- Do not rewrite unrelated analysis modules.
- Do not collapse all report types into one generic template.
- Avoid freeform AI report structure. The structure must be fixed and AI should fill controlled sections later.

Validation to perform:
- Verify all target report types have a defined template/contract.
- Verify severity labels, definitions, and output naming are consistent across report types.
- Verify at least one example finding can be rendered using the new standardized structure without breaking the current engine.
- Verify evidence and framework mapping fields are represented in the template contract, even if some are conditionally populated.
- Verify the standards documentation matches the implemented template logic.

Documentation updates required after implementation:
- Update DEVELOPMENT_HISTORY.md with what was changed and how it was validated.
- Update NEXT_STEP.md to reflect the next recommended step.
- Update README.md if setup, usage, structure, or behavior changed.
- Update CHANGELOG.md for meaningful changes.
- Update TEST_PLAN.md if tests or validation scope changed.
- Update ARCHITECTURE_NOTES.md if architecture, dependencies, or design decisions changed.
- Update IMPLEMENTATION_PLAN.md to reflect the report standardization progress.

Expected output:
- Summary of implemented report standardization changes
- Summary of new standards documents
- Summary of template/report contract assets created or updated
- Validation results
- Summary of documentation updates
