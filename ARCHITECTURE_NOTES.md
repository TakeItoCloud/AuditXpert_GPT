# Architecture Notes

## Current architecture
The recommended architecture is a single repository with modular PowerShell components. The platform should behave like a product with multiple engines sharing the same core.

## Key components
- `AuditXpert.Core`: configuration, logging, run context, error handling, common utilities
- `AuditXpert.Prereqs`: prerequisite checks, module validation, permission validation, install prompts
- `AuditXpert.Connectors`: Microsoft Graph, Exchange Online, Azure, hybrid data collectors
- `AuditXpert.Assessments`: technical rule packs and scoring logic
- `AuditXpert.Regulatory`: control catalog, framework mappings, vCISO outputs
- `AuditXpert.Reporting`: technical and executive report rendering
- `AuditXpert.AI`: AI prompt templates, response handling, narrative generation
- `AuditXpert.Cli`: orchestrator entry points and command UX
- `launcher`: PySide6 desktop shell that coordinates future operator workflows without replacing the PowerShell engine

## Current repository structure
- Root working folders: `config`, `docs`, `output`, `samples`, `src`, `tests`, and `tools`
- Desktop launcher workspace under `launcher` with `app/ui`, `app/services`, `app/models`, and `app/resources`
- Root bootstrap entry point: `Invoke-AuditXpert.ps1`
- Module layout per engine: module manifest, module file, `Public`, and `Private`
- Project-memory markdown files at the repository root to preserve implementation continuity across sessions
- Connector documentation and sample authentication payloads now exist under `docs` and `samples/auth`
- Findings documentation and sample fixtures now exist under `docs` and `samples/findings`
- Microsoft 365 rule-specific documentation and fixtures now exist under `docs` and `samples/findings/m365`
- Azure rule-specific documentation and fixtures now exist under `docs` and `samples/findings/azure`
- Hybrid rule-specific documentation and fixtures now exist under `docs` and `samples/findings/hybrid`
- Governance documentation, mapping configuration, and sample governance inputs now exist under `docs`, `config/framework-mappings`, and `samples/governance`
- Reporting and AI documentation plus sample report outputs now exist under `docs`, `samples/reports`, `tests/Reporting`, and `tests/AI`
- Report-hardening inventory and backlog documentation now exist under `docs/reporting`
- Fixed report-template and shared section-contract assets now exist under `src/AuditXpert.Reporting/Templates`
- AI prompt-template assets and shared prompt rules now exist under `src/AuditXpert.AI/Templates`
- Operational tooling and packaging assets now exist under `tools` with predictable consultant-facing output paths under `output`
- Launcher documentation now exists under `docs/launcher` and the launcher package has its own local `README.md`

## Data or control flow
1. Load configuration
2. Start run context and logging
3. Validate prerequisites and permissions
4. Connect to requested scopes
5. Collect raw evidence
6. Evaluate service-specific assessment rules
7. Normalize findings
8. Map findings to control domains
9. Generate technical and executive reports
10. Optionally generate AI-assisted narratives from normalized findings
11. Optionally coordinate validated execution flows through the desktop launcher without relocating business logic from PowerShell

## External dependencies
- Microsoft Graph PowerShell SDK
- Exchange Online PowerShell module
- Az PowerShell modules
- Optional Windows RSAT / AD module for hybrid checks
- Optional ChatGPT API access for AI report generation
- Python 3.11 or later plus PySide6 for the desktop launcher shell

## Security and compliance notes
- Keep credentials out of code
- Prefer certificate-based app-only auth for unattended cloud collection where supported
- Store raw evidence separately from AI-generated narrative
- Preserve traceability from narrative back to finding ID and evidence source
- Treat compliance mapping as support for assessment, not automatic certification

## Design decisions
- One shared platform, not separate unrelated repos
- Read-only assessment first
- Shared findings schema for all modules
- AI layer consumes normalized findings instead of raw API responses directly
- Regulatory mapping remains configurable and versioned
- Use a consistent PowerShell 7 module pattern across all engines from the first phase, even before feature logic is implemented
- Keep authentication abstractions in the connector layer and out of assessment-rule execution
- Keep export formatting in the findings engine rather than inside rule implementations
- Keep Microsoft 365 rules modular by workload so unsupported API surfaces and partial permission coverage remain explicit
- Keep Azure rules modular by control domain and preserve native recommendation identifiers in normalized findings
- Keep hybrid rules modular by infrastructure area and clearly mark optional or lab-only checks
- Keep governance mappings configurable and versioned so the platform supports assessment interpretation rather than fake certification claims
- Keep AI prompt rendering traceable to finding IDs and ensure non-AI reporting remains a supported path
- Keep output separation explicit across evidence, findings, governance, reports, logs, and release artifacts
- Keep the desktop launcher as a thin orchestration layer that passes versioned configuration into PowerShell entry points instead of re-implementing collection or assessment logic in Python
- Normalize launcher state into typed Python models and map it only to repository-backed PowerShell profiles so unsupported UI intent can be stored without inventing fake script parameters
- Keep the launcher UI panelized around one shared config object with signal-based updates so later process-bridging logic can subscribe to state changes without duplicating widget logic
- Treat the current report engine as a stable baseline and harden it through additive contracts, renderers, and validation rather than risky rewrites
- Keep report standardization template-driven inside the reporting module so the current public report bundle flow stays stable while new report types can reuse shared section contracts
- Keep AI prompt generation deterministic by packaging mapped report records and section plans derived from the reporting contracts instead of letting AI infer structure from raw findings

## Future architecture considerations
- Web UI or API wrapper
- Launcher-to-engine binding contracts and state synchronization
- Richer launcher controls and help surfaces over the normalized config contract
- Launcher-to-PowerShell process bridging and execution-state synchronization
- Consulting-grade report structure, validation, and governed AI narrative assets
- Remediation-roadmap rendering and richer service-specific report variants
- Deterministic AI section-insertion and post-generation validation
- Multi-tenant scheduling
- Evidence repository and client workspace separation
- Controlled remediation workflows
- SaaS packaging for the AI explainer and governance layer
