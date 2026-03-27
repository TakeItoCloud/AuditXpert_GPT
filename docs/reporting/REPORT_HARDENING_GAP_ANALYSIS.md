# Report Hardening Gap Analysis

## Assessment standard used for comparison
This gap analysis compares the current implementation to enterprise consulting-grade expectations for customer-facing delivery. The comparison is about report quality and control, not about whether the current engine is functional.

| Area | Current implementation | Consulting-grade expectation | Gap | Priority |
|---|---|---|---|---|
| Executive report structure | Count-based executive summary with top governance domains only | Clear scope, methodology, key themes, top risks, business impact, priority actions, and disclaimer model | Major structural gap | High |
| Technical report structure | Flat finding list with title, ID, service, severity, description, recommendation, and traceability | Standardized finding cards with severity, impact, likelihood, risk score, evidence, source, remediation, owner candidates, and appendix references | Major completeness gap | High |
| Remediation plan structure | Not implemented as a report | Dedicated remediation roadmap with sequencing, effort, owner, and dependency handling | Missing report type | High |
| Governance or compliance report structure | Risk register summary and upstream governance engine exist, but reporting layer only renders a short table | Standalone governance/vCISO report with control-domain view, maturity, gaps, planned improvements, and disclaimer language | Partially present but under-rendered | High |
| Severity taxonomy | Uses severity values passed from findings | One standardized presentation taxonomy with consistent display rules across all report types | Presentation rules are not controlled at report layer | High |
| Business impact wording | Uses raw finding descriptions only | Business-facing impact statements and audience-appropriate wording standards | Missing curated impact narrative | High |
| Evidence handling | Traceability uses finding IDs; raw evidence is not rendered materially in reports | Evidence-backed findings with controlled evidence summary, source references, and separation from generated prose | Evidence presentation is too thin | High |
| Framework mapping | Available upstream in findings and governance mapping, but largely absent from rendered report sections | Visible control-domain mapping in governance and technical outputs where relevant | Mapping is underrepresented in output | High |
| Consistency and completeness validation | No report completeness checks beyond smoke tests | Section completeness checks, field presence validation, severity normalization, and traceability validation | Missing validation layer | High |
| Service-specific appendix structure | Groups findings by service and lists finding IDs or titles | Structured per-service appendices with scope, evidence notes, and service-specific observations | Appendix is too shallow | Medium |
| HTML renderer quality | Simple regex-based Markdown conversion | Stable, template-aware HTML layout with correct lists, quotes, tables, and section styles | Current HTML output is fragile | High |
| Output format breadth | Markdown and partial HTML only | Markdown, HTML, and ideally a downstream PDF-ready path | Format set is narrow | Medium |
| AI prompt governance | Hardcoded system prompt and prompt-section builder | Externalized prompt assets, versioning, review controls, and section-level safeguards | Prompt governance is immature | High |
| AI narrative control | AI packaging only, no model call in repo test path | Controlled narrative generation workflow with validation against traceability and allowed sections | Workflow not yet hardened | Medium |

## Detailed observations

### Executive report structure
Current executive output is functional but minimal. It lacks:
- engagement scope
- reporting period
- methodology
- client-ready narrative structure
- top recommendations
- explicit business implications
- overall risk posture statement

### Technical report structure
Current technical output does not yet behave like a consulting deliverable because it does not consistently surface:
- impact
- likelihood
- risk score
- evidence summary
- remediation type
- framework mappings
- source connector or rule metadata

### Remediation roadmap structure
There is currently no remediation roadmap renderer. This is a major gap for consulting-style delivery because technical findings and risk tables do not automatically create an actionable plan.

### Governance or compliance structure
The governance layer is stronger than the reporting layer. Risk register and scorecard data exist upstream, but the reporting module only exposes a short Markdown risk table and a numeric executive-domain summary.

### Severity and wording
The report layer does not normalize or translate severity labels, business impact language, or recommendation style. This creates a risk of inconsistent tone and inconsistent presentation between services.

### Evidence and traceability
Traceability exists primarily through finding IDs. That is necessary but not sufficient. Consulting-grade reports usually include:
- summarized evidence statements
- source-system references
- confidence or context notes
- stronger linkage from narrative back to evidence-bearing sections

### AI narrative control
The AI layer correctly avoids treating generated prose as evidence, but it is still immature for consulting-grade use because prompts are embedded directly in PowerShell code and there is no hardening layer that validates generated section structure, scope, or finding-reference coverage.

## Baseline conclusion
The current reporting system is a sound scaffold and already proves the end-to-end path from normalized findings to exported report files. It is not yet a consulting-grade reporting engine. The next hardening phases should focus on structure, consistency, traceability depth, governance rendering, and controlled AI prompt or narrative assets before broadening formats or visual polish.
