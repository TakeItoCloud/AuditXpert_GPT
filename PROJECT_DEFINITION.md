# Project Definition

## Project name
AuditXpert_GPT

## Purpose
AuditXpert_GPT is an enterprise-grade PowerShell-first assessment and governance platform for Microsoft 365, Microsoft Entra ID, Intune, Exchange Online, Microsoft Defender, Azure, and hybrid/on-premises Microsoft infrastructure. It is designed to assess configuration quality, security posture, operational health, misconfigurations, and control coverage, then translate those findings into prioritized recommendations and executive-ready reporting.

## Business context
Organizations increasingly need evidence-backed security and configuration assessments that align to external regulatory pressure and internal governance. The platform should support consulting-style delivery first, then potentially become a productized internal platform or SaaS later.

## Objectives
- Build a reusable enterprise-grade assessment platform instead of one-off scripts.
- Support Microsoft 365, Azure, and hybrid/on-prem environments from the same shared architecture.
- Map findings to standards such as NIS2 and ISO/IEC 27001-style control domains through a reusable regulatory layer.
- Produce both technical and executive reports.
- Use AI to accelerate the creation of plain-English findings, impact statements, remediation narratives, and professional report drafts.
- Implement prerequisite validation for modules, permissions, APIs, and PowerShell dependencies before each assessment run.
- Maintain a durable repository skeleton and project-memory files that support phased development across sessions.

## Scope
### In scope
- Shared PowerShell core framework
- Prerequisite and permission validation engine
- Connectors for Microsoft cloud and hybrid data sources
- Technical assessment packs for Microsoft 365, Azure, and hybrid services
- Regulatory mapping layer
- Report generation layer
- AI explanation layer using ChatGPT API
- Export to JSON/CSV/Markdown/HTML
- Run history and evidence storage
- Read-only assessments first

### Out of scope
- Automatic remediation in the first release
- Full multi-tenant SaaS control plane in the first release
- Direct write-back changes to tenant settings in early phases
- Broad Linux assessment coverage in the first release
- Full CMDB integration in the first release

## Stakeholders and users
- Consultant / assessor: runs the tool and interprets results
- Security lead / vCISO / fractional CISO: uses governance and risk outputs
- Infrastructure architect: validates technical recommendations
- Customer executive audience: consumes executive summaries and priorities
- Future product owner: evolves the internal tool into a productized offering

## Assumptions
- The tool will be built primarily in PowerShell.
- Codex in VS Code is the code-generation assistant during development.
- The environment can support Microsoft Graph, Exchange Online, and Azure authentication.
- Some data sources require app-only auth while others may still require delegated/admin connections depending on the API surface.
- The first version is assessment/reporting focused rather than remediation focused.

## Constraints
- Must be maintainable by another engineer later.
- Must preserve evidence and run context.
- Must clearly document required permissions.
- Must avoid over-promising compliance certification; it should support assessment and evidence, not claim automatic certification.
- Must separate raw evidence from AI-generated narrative.

## Success criteria
- A consultant can run a single orchestrator command that validates prerequisites and launches one or more scoped assessments.
- Findings are normalized across Microsoft 365, Azure, and hybrid modules.
- Reports can be generated in executive and technical formats.
- Each finding includes severity, business impact, technical context, recommendation, and optional regulatory/control mapping.
- The repository has durable project-memory markdown files that allow work to continue cleanly across chats and sessions.
- The repository structure remains modular, PowerShell 7-friendly, and maintainable for future engineers extending the platform.

## Risks
- API and permission complexity across workloads
- Overlap between Microsoft-native scoring and custom scoring
- Excessive scope in the first implementation
- Tight coupling between assessment logic and reporting logic
- Over-reliance on AI-generated wording without strong evidence traceability
