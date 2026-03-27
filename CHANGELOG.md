# Changelog

## Unreleased
### Added
- Initial AuditXpert_GPT build pack
- Project context markdown files
- Phase-based Codex prompt sequence
- Foundation repository skeleton with top-level working folders
- PowerShell 7-compatible manifests and module entry points for all planned module areas
- `Invoke-AuditXpert.ps1` bootstrap script for module-load smoke validation
- Tracked placeholder files for empty folders and module `Public`/`Private` scaffolding
- Connector metadata model for Microsoft Graph, Exchange Online, Azure, and hybrid local collectors
- Safe connect/disconnect wrapper functions and stub collection datasets for all Phase 03 connectors
- Connector authentication and matrix documentation
- Authentication sample payloads and connector-focused Pester coverage
- Normalized findings schema and assessment-rule contract
- Assessment orchestrator and common JSON, CSV, Markdown, and HTML export functions
- Findings schema, rule model, and export format documentation
- Sample findings fixture and assessment-focused Pester coverage
- Initial Microsoft 365 assessment packs for Entra ID, Conditional Access, legacy authentication, administrative role hygiene, Intune, Exchange Online, Defender posture, and Secure Score
- Microsoft 365 coverage and least-privilege documentation
- Microsoft 365 fixture data and assessment-focused Pester coverage
- Initial Azure assessment packs for inventory, policy, Defender for Cloud, Advisor, compute, networking, monitoring, and resilience
- Azure coverage and least-privilege documentation
- Azure fixture data and assessment-focused Pester coverage
- Initial hybrid and on-prem assessment packs for AD hygiene, privileged groups, stale accounts, domain controllers, GPO baselines, hybrid identity, and optional AD CS or Exchange hybrid checks
- Hybrid coverage and least-privilege documentation
- Hybrid fixture data and assessment-focused Pester coverage
- Configurable governance and regulatory mapping module
- Versioned framework mapping JSON for NIS2-oriented domains, ISO/IEC 27001-style mappings, and internal security baselines
- Governance documentation, sample inputs, and regulatory Pester coverage
- Report bundle rendering for executive summaries, technical findings, risk-register summaries, and service appendices
- AI prompt-rendering and narrative package scaffolding with optional AI disablement
- Reporting and AI documentation, sample outputs, and dedicated test coverage
- Consultant-facing initialization, smoke-test, and release-build scripts
- Installation, operations, and release-checklist documentation
- Top-level smoke-test coverage and predictable output folder guidance
- PySide6 desktop launcher foundation with enterprise-style shell structure
- Launcher-specific documentation and architecture notes for thin-client orchestration
- Typed launcher configuration models, PowerShell profile catalog, and sample launcher config JSON
- Panel-based launcher UI with dynamic auth and AI controls plus a doc-backed app-auth help window

### Changed
- README now reflects the actual repository skeleton and bootstrap usage
- README now reflects the launcher component and repository structure updates
- README now reflects the launcher configuration contract and profile-mapping layer
- README now reflects the launcher UI behavior and app-auth guidance
- Next-step guidance now advances to PowerShell process bridging and execution wiring
- Test plan expanded with launcher UI smoke and control-behavior validation scenarios

### Fixed
- N/A
