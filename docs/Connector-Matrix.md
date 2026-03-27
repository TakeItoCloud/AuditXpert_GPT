# Connector Matrix

| Connector | Service | Supported auth methods | Required module(s) | Current phase capability |
|---|---|---|---|---|
| MicrosoftGraph | Microsoft 365 | Delegated, AppOnly | `Microsoft.Graph.Authentication` | Stub connectivity validation and sample dataset |
| ExchangeOnline | Microsoft 365 | Delegated, AppOnly | `ExchangeOnlineManagement` | Stub connectivity validation and sample dataset |
| Azure | Azure | Delegated, ServicePrincipal | `Az.Accounts` | Stub connectivity validation and sample dataset |
| HybridLocal | Hybrid / On-Prem | Integrated, RunAs | `ActiveDirectory` optional | Stub local collector session and sample dataset |

## Notes
- Assessment rules must consume connector outputs and not own sign-in behavior.
- Missing modules should produce operator-friendly readiness results rather than hidden failures.
- Permission requirements remain metadata-driven so future phases can map packs to expected scopes and roles.
