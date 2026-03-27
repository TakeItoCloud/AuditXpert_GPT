# Microsoft 365 Assessment Coverage

## Current Phase 05 coverage
- Entra ID identity posture indicators
- Conditional Access and MFA coverage indicators
- Legacy authentication exposure indicators where currently available
- Administrative role hygiene indicators
- Intune baseline and policy conflict indicators
- Exchange Online mail flow and protection posture indicators
- Defender-related posture indicators from approved connector feeds
- Microsoft Secure Score collection and finding translation

## Current limitations
- Some legacy authentication and Defender surfaces remain partially available through approved connectors in the current phase
- Rules operate from fixture-backed or connector-provided datasets and do not perform tenant modifications
- Service-specific rules are intentionally modular so future API expansion can add checks without rewriting the findings engine

## Output model
Every Phase 05 rule emits normalized findings through the shared `New-AxFinding` contract. Evidence references are preserved as structured objects for later reporting and traceability.
