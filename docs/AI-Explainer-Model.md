# AI Explainer Model

## Purpose
The AI layer renders safe prompt payloads from normalized findings and governance outputs. It prepares AI-assisted narrative generation without treating AI output as evidence.

## Safety model
- AI can be explicitly disabled
- API keys are resolved from environment variables or secure external config
- Secrets must never be logged
- Prompt payloads require traceability back to finding IDs
- AI-assisted narrative must be labeled as reviewable prose, not evidence

## Current phase behavior
Phase 09 implements prompt rendering and packaging only. It does not perform live outbound model calls in the repository test path.
