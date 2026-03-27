# Release Checklist

## Pre-release
- Run `./tools/Initialize-AuditXpert.ps1`
- Run `./tools/Run-SmokeTests.ps1`
- Review `CHANGELOG.md`, `README.md`, and `TEST_PLAN.md`
- Confirm unsupported scenarios are documented

## Packaging
- Run `./tools/Build-Release.ps1`
- Confirm the release archive exists under `output/releases`
- Confirm `release-manifest.json` is present in the package

## Delivery review
- Confirm evidence, findings, governance, and report paths are distinct
- Confirm AI can be disabled without breaking report generation
- Confirm no secrets or tenant-specific values are present in shipped samples
