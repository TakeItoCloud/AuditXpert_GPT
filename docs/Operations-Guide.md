# Operations Guide

## Lab use
- Prefer fixture-backed and lab-friendly test paths first.
- Use `tools/Run-SmokeTests.ps1` before introducing environment-specific data.

## Tenant use
- Keep collection read-only.
- Validate required modules and permissions for the selected scope before client use.
- Preserve the separation of evidence, findings, governance, and AI narrative outputs.

## Client delivery
- Store raw evidence in `output/evidence`.
- Store normalized findings in `output/findings`.
- Store governance outputs in `output/governance`.
- Store rendered reports in `output/reports`.
- Clearly label AI-assisted narrative as reviewable prose rather than evidence.

## Unsupported scenarios
- Automatic remediation
- Hidden credential storage in repository files
- Any workflow that treats AI prose as compliance proof or technical evidence
