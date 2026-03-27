# AI Explainer Model

## Purpose
The AI layer renders safe prompt payloads from normalized findings, governance outputs, and fixed report contracts. It prepares AI-assisted narrative generation without treating AI output as evidence or allowing AI to define report structure.

## Safety model
- AI can be explicitly disabled
- API keys are resolved from environment variables or secure external config
- Secrets must never be logged
- Prompt payloads require traceability back to finding IDs
- AI-assisted narrative must be labeled as reviewable prose, not evidence
- AI prompt templates are separated by report type and audience
- AI output is limited to predetermined sections from the report contracts

## Current implementation
- AI prompt templates now live under `src/AuditXpert.AI/Templates`
- Shared AI rules are defined in `Templates/shared/prompt_rules.json`
- Report-specific prompt templates now exist for executive, technical, governance, Azure, Microsoft 365, hybrid, remediation roadmap, and service-specific appendix paths
- Prompt payloads now include mapped report records rather than relying only on raw findings
- Validation helpers detect missing required mapped fields and missing AI section coverage before prompt packaging proceeds

## Current phase behavior
The repository still implements prompt rendering and packaging only. It does not perform live outbound model calls in the repository test path.
