# Least Privilege Guidance For M365 Assessments

## Principle
Assessment runs should request only the minimum delegated roles, app permissions, and workload-specific visibility required for the selected scope.

## Service areas
- Entra ID and Conditional Access: prefer read-only identity and policy scopes where available
- Intune: prefer read-only device management and policy visibility
- Exchange Online: prefer view-only configuration and mail protection visibility
- Defender-related posture: use approved read-only posture feeds and document unsupported surfaces
- Secure Score: collect read-only score and improvement action data

## Assessment behavior
- Partial permission coverage must not fail silently
- Rules should emit evidence that identifies permission limitations
- Unsupported API surfaces should be documented explicitly in findings and assessment notes

## Operational note
This repository phase remains read-only. No rule should create, update, or delete tenant configuration.
