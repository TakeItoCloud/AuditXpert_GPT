# Implementation Plan

## Delivery strategy
Deliver the platform in phases. Build the shared framework first, then connectors, then assessment packs, then reporting, then AI explanation, then packaging.

## Phases
### Phase 1 - Foundation and repository skeleton
- Create repo structure
- Create shared project files
- Create core module scaffolding
- Create logging and configuration model

### Phase 2 - Shared core and prerequisite engine
- Build configuration loader
- Build logging and run context framework
- Build prerequisite checks for modules, PowerShell version, internet connectivity, auth context, and output paths
- Build permissions manifest model per connector

### Phase 3 - Connectors and authentication
- Graph connector
- Exchange Online connector
- Azure connector
- Hybrid data collector connector set
- Connection abstraction and safe session lifecycle

### Phase 4 - Findings schema and assessment engine
- Normalized findings model
- Assessment rule model
- Orchestrator pipeline
- Export framework

### Phase 5 - Microsoft 365 assessment packs
- Entra ID checks
- Secure Score ingestion
- Intune checks
- Exchange Online checks
- Defender checks

### Phase 6 - Azure assessment packs
- Subscriptions and management groups
- Azure Policy and initiative checks
- Defender for Cloud checks
- Advisor checks
- VM, networking, storage, identity, monitoring, and resilience checks

### Phase 7 - Hybrid/on-prem assessment packs
- Active Directory checks
- Domain Controller posture checks
- GPO baseline checks
- Hybrid identity checks
- Optional Exchange hybrid/on-prem checks
- Optional AD CS checks

### Phase 8 - Regulatory and governance module
- Control catalog
- Framework mapping model
- NIS2 and ISO control-domain mapping
- vCISO scorecards
- Executive risk register

### Phase 9 - Reporting and AI explainer
- Technical report templates
- Executive report templates
- AI explanation pipeline with prompt templates
- Protected handling of raw evidence versus narrative output

### Phase 10 - Packaging, testing, and hardening
- Pester tests
- Sample configuration files
- Installer/bootstrap script
- Release packaging
- Documentation hardening

## Detailed steps
| Step ID | Title | Goal | Inputs | Outputs | Dependencies | Status |
|---|---|---|---|---|---|---|
| 1 | Repo skeleton | Create baseline structure | Project scope | Folders, bootstrap script, and initial module files | None | Completed |
| 2 | Core config and logging | Centralize config and telemetry | Repo skeleton | Core module | Step 1 | Planned |
| 3 | Prerequisite engine | Validate readiness before assessment | Core module | Readiness framework | Step 2 | Planned |
| 4 | Connector framework | Standardize connection handling | Core + prereq | Connector abstractions | Step 2-3 | Planned |
| 5 | Findings schema | Normalize outputs | Connector framework | Shared findings model | Step 4 | Planned |
| 6 | M365 packs | Assess Microsoft 365 services | Findings schema | M365 rules | Step 5 | Planned |
| 7 | Azure packs | Assess Azure resources and governance | Findings schema | Azure rules | Step 5 | Planned |
| 8 | Hybrid packs | Assess on-prem and hybrid dependencies | Findings schema | Hybrid rules | Step 5 | Planned |
| 9 | Governance layer | Map findings to control domains | Findings outputs | Governance engine | Step 6-8 | Planned |
| 10 | AI reporting | Generate enterprise narrative | Findings + governance | AI explainer | Step 9 | Planned |
| 11 | Hardening | Make solution production-ready | Full repo | Tests and packaging | Step 1-10 | Planned |

## Validation strategy
- Pester tests for PowerShell modules
- Foundation smoke validation for folder structure, manifests, module imports, and bootstrap execution
- Smoke tests for each connector
- Dry-run mode for orchestrator
- Fixture-based tests for finding normalization
- Sample export validation
- Manual validation for at least one lab tenant and one hybrid lab

## Rollback or recovery considerations
- Keep assessment mode read-only in early releases
- Separate connector logic from assessment rules
- Use small, reversible commits/changes per phase
- Preserve run artifacts by timestamped output folders
