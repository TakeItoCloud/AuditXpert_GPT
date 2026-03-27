# Desktop Launcher Overview

## Purpose
The desktop launcher provides an operator-friendly shell for AuditXpert_GPT without changing the PowerShell-first architecture. It exists to coordinate configuration, readiness checks, execution intent, and report navigation while leaving collection and assessment logic inside the existing modules.

## Current phase scope
- PySide6 desktop application foundation
- Enterprise-style main window shell
- Package structure for UI, models, services, and resources
- Local theme and branding placeholders

## Architectural position
- The launcher is a thin orchestration layer.
- The PowerShell modules remain the execution engine and source of truth.
- Python should call explicit PowerShell entry points or scripts in later phases instead of reimplementing business rules.

## Placeholder sections in the shell
- Assessment selection
- Authentication
- AI options
- Paths
- Prerequisites
- Help
- Execution status
- Results

## Non-goals for this phase
- No live tenant authentication
- No real assessment execution
- No duplication of prerequisite or findings logic in Python
- No embedded secrets, tokens, or tenant-specific defaults

## Planned next phase direction
The next launcher phase should define a configuration contract between the UI and the PowerShell engine, then bind shell actions to explicit, versioned execution calls with predictable output handling.
