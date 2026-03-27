# Report Hardening Backlog

## Purpose
This backlog sequences the work needed to move from the current reporting scaffold to a consulting-grade reporting engine while preserving the current flow.

## Priority legend
- `High`: should be addressed before calling the reporting layer consulting-grade
- `Medium`: materially improves quality and consistency
- `Optional`: useful enhancement after the core hardening set

## Sequenced backlog

| Order | Priority | Task | Outcome |
|---|---|---|---|
| 1 | High | Define a normalized report data contract separate from raw findings and raw governance objects | Stable reporting inputs and easier completeness validation |
| 2 | High | Harden the executive summary structure | Scope, key themes, risk posture, business impact, and priority actions become standard |
| 3 | High | Harden the technical findings section model | Findings render with severity, likelihood, impact, risk score, evidence summary, recommendation, and traceability consistently |
| 4 | High | Build a dedicated governance / vCISO report renderer | Governance outputs become a real deliverable instead of a short summary table |
| 5 | High | Add a remediation roadmap report | Technical findings and governance priorities translate into a delivery-focused action plan |
| 6 | High | Replace or substantially improve the HTML renderer | Correct lists, quotes, tables, section styling, and reusable templates |
| 7 | High | Add report completeness and consistency validation | Missing fields, inconsistent severity labels, and weak traceability are caught before export |
| 8 | High | Externalize AI prompt assets and add prompt versioning | Prompt content becomes maintainable and reviewable |
| 9 | Medium | Promote framework mappings into report sections and appendices | Governance context becomes visible in technical and executive outputs |
| 10 | Medium | Expand service appendix structure | Azure, Microsoft 365, and hybrid appendices become more useful to technical readers |
| 11 | Medium | Add service-specific report variants | Azure, Microsoft 365, and hybrid outputs get audience-appropriate structure |
| 12 | Medium | Add optional report metadata such as scope, run date, operator, and methodology | Reports become more delivery-ready for consultant workflows |
| 13 | Optional | Add downstream PDF-ready export path | Improves client-delivery packaging |
| 14 | Optional | Add richer visual layout and branding controls | Improves polish once structure and validation are stable |

## Near-term recommendation
The next implementation phase should focus on items 1 through 4 together:
- normalized report data contract
- executive summary hardening
- technical findings hardening
- dedicated governance report renderer

That sequence improves report quality without requiring immediate redesign of the full export or AI pipeline.

## Out of scope for this backlog
- collector redesign
- prerequisite redesign
- launcher redesign
- assessment-rule redesign unrelated to reportable data quality

## Notes
- Preserve the existing `New-AxReportBundle` and `Export-AxReportBundle` flow as the compatibility baseline during hardening.
- Prefer additive evolution and wrapper contracts over breaking changes to existing report tests until hardened templates are validated.
