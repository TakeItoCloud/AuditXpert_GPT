# Report Standards

## Purpose
This document defines the fixed reporting standards now introduced into AuditXpert_GPT. The standards are implemented through template assets under `src/AuditXpert.Reporting/Templates` and applied by the reporting renderers.

## Template location
The repository uses the reporting-module pattern rather than a top-level `reporting/templates` folder. The active template assets now live in:
- `src/AuditXpert.Reporting/Templates/shared/report_schema.json`
- `src/AuditXpert.Reporting/Templates/shared/section_contracts.json`
- `src/AuditXpert.Reporting/Templates/reports/*.json`

## Standard report types with fixed contracts
- Executive Summary Report
- Technical Assessment Report
- Governance / vCISO Report
- Azure Assessment Report
- Microsoft 365 Assessment Report
- Hybrid Infrastructure Report
- Remediation Roadmap Report

## Mandatory section families
Where applicable, report contracts use these fixed section families:
- report title and metadata
- scope
- methodology
- executive summary
- risk overview
- key findings
- recommendations
- remediation roadmap
- compliance / control mapping
- service-specific detail
- evidence / appendix

## Current implementation scope
The current renderer path now directly standardizes:
- Executive Summary Report
- Technical Assessment Report
- Governance / vCISO Report content inside `Risk-Register-Summary.md`
- Service-Specific Appendix structure

The remaining service-specific and remediation roadmap report types are defined as contracts in template assets and are ready for later rendering phases.

## Fixed standards now applied
- Report titles and output names are defined by template assets.
- Section headings are controlled through shared section contracts.
- Severity presentation uses the controlled severity taxonomy.
- Technical finding blocks follow a fixed field order.
- Recommendation and implementation guidance wording is standardized.
- Evidence and framework mapping fields are represented consistently, even when the source data is sparse.

## Backward compatibility rule
The existing public entry points remain the compatibility surface:
- `New-AxReportBundle`
- `Export-AxReportBundle`

Current export filenames are preserved while internal section structure is hardened.
