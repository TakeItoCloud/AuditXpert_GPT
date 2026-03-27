# Authentication Model

## Purpose
The connector layer owns authentication abstractions so assessment packs do not embed sign-in logic. This keeps connection handling reusable, testable, and separate from rule execution.

## Supported connector patterns
- Microsoft Graph: delegated and app-only
- Exchange Online: delegated and app-only
- Azure: delegated and service principal
- Hybrid local collectors: integrated and run-as

## Design principles
- Keep authentication and session lifecycle inside `AuditXpert.Connectors`
- Prefer metadata-driven declarations for auth methods, module dependencies, and permissions
- Keep operator failures explicit when required modules or roles are missing
- Do not persist secrets in repository files or sample payloads
- Keep logging transcript-safe by redacting obvious secret-like fields

## Current phase behavior
Phase 03 implements safe connector wrappers and readiness checks only. Live sign-in and broad data collection are intentionally deferred. Connectors initialize into stub sessions that can be validated and disconnected cleanly.

## Session lifecycle
1. Resolve connector metadata
2. Validate supported auth method
3. Check required module availability
4. Return a connected or unavailable session object
5. Use stub collection functions for downstream testing
6. Disconnect cleanly through the matching disconnect function

## Security notes
- Sample files must never contain secrets
- Future app-only implementations should prefer certificates over embedded secrets where practical
- Permission requirements are declarative and should remain reviewable outside runtime code
