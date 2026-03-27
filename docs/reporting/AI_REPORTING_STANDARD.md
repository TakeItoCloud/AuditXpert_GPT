# AI Reporting Standard

## Purpose
The AI reporting layer in AuditXpert_GPT must refine narrative inside fixed report sections. It must not invent report structure, new severity terms, or uncontrolled remediation language.

## Core rules
- Report structure comes from the reporting template contracts, not from AI prompts.
- AI may only populate sections marked as AI-controlled in the section plan.
- AI must reference mapped finding IDs in every substantive statement.
- AI must not present generated text as evidence.
- AI must not invent severity labels, remediation priorities, or framework outcomes.

## Prompt asset location
AI prompt assets now live under:
- `src/AuditXpert.AI/Templates/shared/prompt_rules.json`
- `src/AuditXpert.AI/Templates/reports/*.json`

## Supported report-type prompt paths
- `executive-summary`
- `technical-assessment`
- `governance-vciso`
- `azure-assessment`
- `microsoft365-assessment`
- `hybrid-infrastructure`
- `remediation-roadmap`
- `service-specific-appendix`

## Audience-specific prompt intent
- Executive: concise, business-facing, risk-oriented
- Technical: precise, implementation-oriented, evidence-aware
- Governance: ownership and control-oriented, not certification-oriented
- Remediation roadmap: delivery-focused and sequencing-oriented
- Service appendix: service-specific, scoped, and traceable

## Guardrails
- Use the section plan only.
- Use the controlled severity taxonomy only.
- Use normalized business impact, technical impact, recommendation, and control-mapping wording only.
- Warn or fail when required mapped fields are missing.
- Keep AI output reviewable and separate from evidence-bearing content.

## Current implementation
The current AI hardening path now uses:
- `New-AxAiPromptPayload`
- `New-AxAiNarrativePackage`
- `Convert-AxFindingsToAiReportInput`
- `Test-AxAiMappedRecordSet`
- `Test-AxAiSectionPlan`
- `Get-AxAiSectionPlan`
