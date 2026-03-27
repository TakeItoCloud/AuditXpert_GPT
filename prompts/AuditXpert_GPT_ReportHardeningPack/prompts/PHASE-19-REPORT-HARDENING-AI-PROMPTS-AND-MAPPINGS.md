You are working in this project repository/folder:

C:\Scripts\Assessment\AuditXpert_GPT

Objective for this step:
Harden the AI reporting layer so it fills controlled report sections using enterprise-safe prompt templates, consumes normalized findings consistently, and applies compliance/control mappings, severity definitions, and remediation standards without inventing report structure.

Before changing anything, review these project context files and follow them as the source of truth:
- PROJECT_DEFINITION.md
- IMPLEMENTATION_PLAN.md
- DEVELOPMENT_HISTORY.md
- NEXT_STEP.md
- README.md
- CHANGELOG.md
- TEST_PLAN.md
- ARCHITECTURE_NOTES.md

Also review these report-hardening artifacts:
- docs\reporting\REPORT_STANDARDS.md
- docs\reporting\RISK_AND_SEVERITY_STANDARD.md
- docs\reporting\REMEDIATION_WRITING_STANDARD.md
- docs\reporting\EVIDENCE_TRACEABILITY_STANDARD.md
- docs\reporting\REPORT_HARDENING_BACKLOG.md

Files and folders to create or modify in this step:
- inspect the current AI reporting prompt implementation and current findings-to-report mapping logic
- create `docs\reporting\AI_REPORTING_STANDARD.md`
- create `docs\reporting\FINDINGS_TO_REPORT_MAPPING_STANDARD.md`
- create or update AI prompt template assets for each supported report type, adapting to the repo’s existing implementation pattern
- create or update any shared AI prompt fragments/rules that enforce:
  - fixed structure
  - severity wording
  - business impact wording
  - remediation wording
  - evidence handling
  - compliance/control mapping wording
  - audience-specific tone
- create or update mapping logic so the AI layer receives normalized inputs rather than raw uncontrolled blobs where practical
- create or update renderer/preprocessor logic so AI-generated text is inserted into predetermined sections rather than creating ad hoc headings
- create or update validation helpers that detect missing required sections or missing required finding fields before final render
- update the project memory files listed below

Implementation requirements:
- Inspect the actual AI prompt implementation already present in the repo and extend it rather than replacing it blindly.
- Do not allow the AI layer to define report structure. Report structure must come from the standardized templates/contracts.
- AI prompt templates must be separated by audience or report type where appropriate:
  - executive
  - technical
  - governance/compliance
  - remediation roadmap
  - service-specific appendix narrative if supported
- Standardize the narrative instructions for:
  - executive summary tone
  - business impact wording
  - technical issue explanation
  - remediation action wording
  - implementation priority
  - control/framework mapping language
- Create or update a controlled findings-to-report mapping model so report sections consume known fields such as:
  - finding_id
  - title
  - severity
  - service
  - category
  - affected_scope
  - evidence
  - recommendation
  - business_impact
  - technical_impact
  - control_mapping
  - remediation_priority
  - owner
  - effort
- Ensure the AI prompt layer gracefully handles missing optional fields while failing or warning on missing required fields.
- Add validation or guardrail logic so unsupported AI output cannot silently remove mandatory sections.
- Where sample outputs or tests exist, use them to refine prompts for consistency.
- Keep the implementation deterministic where possible: template controls structure, data controls content, AI refines narrative only.

Safeguards:
- Do not break existing logic.
- Preserve backward compatibility unless impossible, and then document the impact.
- Keep changes scoped to this step only.
- Do not rework unrelated collectors or analysis engines.
- Do not allow AI to invent severity labels, priorities, or section headings that conflict with the new standards.
- Avoid vendor-marketing language and keep the wording consulting-grade and evidence-based.

Validation to perform:
- Verify each supported report type has an AI prompt/template path that aligns to the fixed report contract.
- Verify AI instructions enforce audience-specific style without changing report structure.
- Verify missing required sections or missing required finding fields are detected and surfaced.
- Verify at least one sample or test render demonstrates consistent severity, impact, and remediation wording across multiple findings.
- Verify the new AI reporting documentation accurately matches implemented logic.

Documentation updates required after implementation:
- Update DEVELOPMENT_HISTORY.md with what was changed and how it was validated.
- Update NEXT_STEP.md to reflect the next recommended step.
- Update README.md if setup, usage, structure, or behavior changed.
- Update CHANGELOG.md for meaningful changes.
- Update TEST_PLAN.md if tests or validation scope changed.
- Update ARCHITECTURE_NOTES.md if architecture, dependencies, or design decisions changed.
- Update IMPLEMENTATION_PLAN.md to reflect the AI report-hardening progress.

Expected output:
- Summary of AI-reporting hardening changes
- Summary of new standards/mapping documentation
- Summary of prompt assets or prompt logic created or updated
- Validation results
- Summary of documentation updates
