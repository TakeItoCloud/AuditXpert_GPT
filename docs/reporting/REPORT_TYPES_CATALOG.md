# Report Types Catalog

## Purpose
This catalog defines the report set that AuditXpert_GPT should support after report hardening. It distinguishes what exists now from what should exist next.

| Report type | Target audience | Current status | Current source path | Notes |
|---|---|---|---|---|
| Executive Summary Report | Executives, sponsors, vCISO, client leadership | Implemented in lightweight form | `Get-AxExecutiveSummaryMarkdown` | Needs consulting-grade structure and stronger business framing |
| Technical Assessment Report | Engineers, architects, technical assessors | Implemented in lightweight form | `Get-AxTechnicalFindingsMarkdown` | Needs stronger finding-card structure and evidence presentation |
| Governance / vCISO Report | vCISO, risk owners, governance audience | Partially implemented | `Get-AxRiskRegisterMarkdown` plus upstream governance data | Needs dedicated governance-focused report renderer |
| Azure Assessment Report | Cloud platform and security teams | Not implemented as a distinct report | Uses shared technical findings path only | Should become a service-specific report variant |
| Microsoft 365 Assessment Report | Identity, messaging, endpoint, and tenant admins | Not implemented as a distinct report | Uses shared technical findings path only | Should become a service-specific report variant |
| Hybrid Infrastructure Report | AD, platform, and hybrid operations teams | Not implemented as a distinct report | Uses shared technical findings path only | Should become a service-specific report variant |
| Remediation Roadmap Report | Program managers, service owners, consultants | Not implemented | None | High-priority hardening target |
| Service-specific appendices | Technical readers and evidence reviewers | Implemented in lightweight form | `Get-AxServiceAppendixMarkdown` | Current appendix is a grouped list, not a full appendix pack |

## Current implemented bundle
The current report bundle exports:
- `Executive-Summary.md`
- `Technical-Findings.md`
- `Risk-Register-Summary.md`
- `Service-Appendix.md`
- `Executive-Summary.html`
- `Technical-Findings.html`

## Recommended hardened report set

### Core reports
- Executive Summary Report
- Technical Assessment Report
- Governance / vCISO Report
- Remediation Roadmap Report

### Scope-specific reports
- Azure Assessment Report
- Microsoft 365 Assessment Report
- Hybrid Infrastructure Report

### Supporting appendices
- Service-specific appendix pack
- Methodology appendix
- Evidence-source appendix
- Framework mapping appendix when governance mapping is enabled

## Recommended design rule
Scope-specific reports should be variants of a shared reporting model rather than isolated report engines. The current shared findings schema and governance layer already support that direction.
