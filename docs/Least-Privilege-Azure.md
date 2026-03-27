# Least Privilege Guidance For Azure Assessments

## Principle
Azure assessments should request only the minimum read-level visibility needed for the selected scope and workload area.

## Guidance
- Use subscription, management group, resource group, or resource type scoping where possible
- Prefer read-only roles such as `Reader` for broad discovery and narrow additional permissions only where specific data sources require them
- Preserve native recommendation identifiers from Defender for Cloud and Azure Advisor rather than relying on portal-only manual review
- Document permission gaps explicitly in findings rather than failing silently

## Operational note
Phase 06 assessment logic is read-only and should not change policy assignments, diagnostic settings, NSGs, backups, Key Vault configuration, or any other Azure resource state.
