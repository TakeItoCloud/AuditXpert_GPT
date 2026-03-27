# Test Plan

## Test objectives
- Verify repository scaffolding is correct
- Verify modules import cleanly
- Verify prerequisite checks behave correctly
- Verify connectors fail safely and report missing permissions clearly
- Verify assessment outputs conform to the normalized findings schema
- Verify report generation uses evidence-backed findings

## Test scope
- Folder structure
- Module manifests
- Logging
- Config loader
- Prerequisite engine
- Connectors
- Assessment packs
- Reporting
- AI prompt rendering

## Test types
- Smoke
- Functional
- Negative
- Integration
- Regression

## Test cases
| ID | Scenario | Preconditions | Action | Expected result | Status |
|---|---|---|---|---|---|
| T-001 | Repo skeleton creation | Empty target folder | Run Phase 01 prompt | Structure created successfully | Completed |
| T-002 | Core module import | Phase 01 complete | Import modules | No syntax errors | Completed |
| T-002A | All module imports | Phase 01 complete | Import all eight module manifests from `src` | All foundation modules load without syntax errors in PowerShell 7 | Completed |
| T-002B | Bootstrap smoke run | Phase 01 complete | Run `./Invoke-AuditXpert.ps1` | Script completes and confirms placeholder module loading | Completed |
| T-003 | Connector metadata model | Phase 03 connector code present | Query connector metadata | Connector catalog exposes auth methods, dependencies, and permission requirements | Completed |
| T-004 | Missing module prereq | Required connector module absent | Run `Test-AxConnectorAccess` | Tool returns operator-friendly unavailable result with dependency detail | Completed |
| T-004A | Stub connector lifecycle | Required connector module mocked as available | Connect, collect stub data, and disconnect | Session initializes cleanly and returns stubbed dataset without live harvesting | Completed |
| T-004B | Transcript-safe connector logging | Connector logging helper available | Emit log with secret-like fields | Secret-like fields are redacted from log output | Completed |
| T-005 | Findings normalization | Phase 04 findings code present | Create normalized finding object | Required fields and transparent risk score are present | Completed |
| T-005A | Findings export coverage | Phase 04 findings code present | Export findings as JSON, CSV, Markdown, and HTML | All formats render successfully from the same finding set | Completed |
| T-005B | Orchestrator stub execution | Phase 04 findings code present | Run orchestrator for stub packs | Unified finding set and export files are produced | Completed |
| T-005C | Microsoft 365 rule coverage | Phase 05 M365 rules present | Run the M365 assessment pack against fixture context | Each Microsoft 365 rule area emits a normalized finding | Completed |
| T-005D | Microsoft 365 export smoke test | Phase 05 M365 rules present | Export M365 findings for a tenant scope | Export files are produced successfully for at least one M365 scope | Completed |
| T-005E | Azure rule coverage | Phase 06 Azure rules present | Run the Azure assessment pack against fixture context | Each Azure rule area emits a normalized finding | Completed |
| T-005F | Azure export smoke test | Phase 06 Azure rules present | Export Azure findings for a sample scope | Export files are produced successfully for at least one Azure scope | Completed |
| T-005G | Hybrid rule coverage | Phase 07 hybrid rules present | Run the hybrid assessment pack against fixture context | Each hybrid rule area emits a normalized finding | Completed |
| T-005H | Hybrid export smoke test | Phase 07 hybrid rules present | Export hybrid findings for a lab-friendly scope | Export files are produced successfully for at least one hybrid scope | Completed |
| T-005I | Governance mapping logic | Phase 08 regulatory module present | Map sample findings into configured frameworks | Findings are linked to transparent, versioned control domains | Completed |
| T-005J | Governance output generation | Phase 08 regulatory module present | Generate risk register and scorecard views from sample findings | Governance outputs retain links back to technical findings and evidence | Completed |
| T-006 | Report rendering without AI | Phase 09 reporting module present | Generate and export report bundle without AI enabled | Technical and executive report outputs are created successfully without AI | Completed |
| T-006A | AI prompt payload construction | Phase 09 AI module present | Build AI prompt package from findings and governance outputs | Prompt payload preserves finding ID traceability and labels AI-assisted content | Completed |
| T-006B | AI disable switch | Phase 09 AI module present | Generate narrative package with AI disabled | Non-AI reporting mode remains available and clearly labeled | Completed |
| T-007 | End-to-end dry-run smoke test | Phase 10 tooling present | Run `tools/Run-SmokeTests.ps1` | Modules import, governance/report flow executes, and smoke validation completes successfully | Completed |
| T-007A | Release package build | Phase 10 tooling present | Run `tools/Build-Release.ps1` | Release package and archive are created in predictable output paths | Completed |
| T-007B | Initialization bootstrap | Phase 10 tooling present | Run `tools/Initialize-AuditXpert.ps1` | Consultant-friendly output folder structure is created predictably | Completed |

## Validation evidence
- Pester output
- Command output
- JSON exports
- HTML/Markdown reports
- Logs per run
- PowerShell 7 smoke-test output for module import and bootstrap execution
- Connector Pester output and readiness smoke-test output
- Assessment Pester output and export smoke-test output
- Microsoft 365 Pester output and fixture-backed export smoke-test output
- Azure Pester output and fixture-backed export smoke-test output
- Hybrid Pester output and lab-friendly export smoke-test output
- Regulatory Pester output and sample-governance smoke-test output
- Reporting Pester output, AI Pester output, and non-AI report generation smoke-test output
- End-to-end smoke-test output and release-package build output
