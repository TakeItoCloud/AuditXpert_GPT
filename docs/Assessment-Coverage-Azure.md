# Azure Assessment Coverage

## Current Phase 06 coverage
- Subscription and management group inventory
- Azure Policy and initiative compliance indicators
- Defender for Cloud recommendation ingestion
- Azure Advisor recommendation ingestion
- Virtual machine posture indicators
- Virtual network and NSG exposure indicators
- Diagnostic settings and logging coverage indicators
- Key Vault, storage, backup, and resilience indicators

## Scope handling
The current Azure rules allow scope metadata to be passed as management group, subscription, resource group, or resource type selectors. Findings preserve the selected scope in normalized output.

## Native source preservation
Defender for Cloud and Azure Advisor ingestion rules preserve native recommendation identifiers and source links in finding evidence and source metadata so downstream reporting can trace findings back to Azure-native recommendations.

## Current limitations
- Phase 06 remains read-only
- Pagination and batching are represented as rule design patterns and evidence notes in the fixture-backed implementation
- Future connector work can replace fixture datasets with live API paging without changing the normalized output contract
