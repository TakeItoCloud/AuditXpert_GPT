"""Catalog of current launcher-to-PowerShell execution profiles."""

from __future__ import annotations

from app.models.run_profile import RunProfile


def get_profile_catalog() -> list[RunProfile]:
    """Return the current repository-backed execution profiles."""
    return [
        RunProfile.from_dict(
            {
                "profile_id": "bootstrap-validation",
                "display_name": "Bootstrap Validation",
                "category": "bootstrap",
                "description": "Load all planned module manifests and confirm the repository bootstrap succeeds.",
                "binding": {
                    "binding_type": "script",
                    "path": "Invoke-AuditXpert.ps1",
                    "supported_parameters": ["PassThru"],
                },
                "current_capability": "implemented",
                "notes": [
                    "Validates module-load readiness only.",
                    "Does not run assessments or connector authentication.",
                ],
            }
        ),
        RunProfile.from_dict(
            {
                "profile_id": "workspace-initialize",
                "display_name": "Initialize Workspace",
                "category": "operations",
                "description": "Create the consultant-friendly output directory structure.",
                "binding": {
                    "binding_type": "script",
                    "path": "tools/Initialize-AuditXpert.ps1",
                    "supported_parameters": ["WorkspaceRoot", "PassThru"],
                },
                "current_capability": "implemented",
                "supports_output_path": True,
                "notes": [
                    "Creates predictable output folders.",
                    "Does not consume assessment, auth, or AI selections.",
                ],
            }
        ),
        RunProfile.from_dict(
            {
                "profile_id": "smoke-test",
                "display_name": "Run Smoke Tests",
                "category": "operations",
                "description": "Execute repository smoke validation including imports, governance flow, and report generation.",
                "binding": {
                    "binding_type": "script",
                    "path": "tools/Run-SmokeTests.ps1",
                    "supported_parameters": ["WorkspaceRoot", "SkipPester", "PassThru"],
                },
                "current_capability": "implemented",
                "supports_output_path": True,
                "notes": [
                    "Operational validation profile only.",
                    "Does not accept launcher auth settings or assessment selections.",
                ],
            }
        ),
        RunProfile.from_dict(
            {
                "profile_id": "release-build",
                "display_name": "Build Release Package",
                "category": "operations",
                "description": "Build a zip-packaged release artifact from the current repository state.",
                "binding": {
                    "binding_type": "script",
                    "path": "tools/Build-Release.ps1",
                    "supported_parameters": ["WorkspaceRoot", "Version", "PassThru"],
                },
                "current_capability": "implemented",
                "supports_output_path": True,
                "notes": [
                    "Packaging profile only.",
                    "Current script copies repository content into output/releases.",
                ],
            }
        ),
        RunProfile.from_dict(
            {
                "profile_id": "assessment-orchestrator",
                "display_name": "Assessment Orchestrator",
                "category": "assessment",
                "description": "Invoke the CLI orchestrator function for selected assessment packs and optional exports.",
                "binding": {
                    "binding_type": "module-function",
                    "module_manifest": "src/AuditXpert.Cli/AuditXpert.Cli.psd1",
                    "command_name": "Invoke-AxAssessmentOrchestrator",
                    "supported_parameters": [
                        "AssessmentPack",
                        "Rule",
                        "Context",
                        "OutputPath",
                        "ExportFormat",
                    ],
                },
                "current_capability": "partially-implemented",
                "supports_assessment_modules": True,
                "supports_output_path": True,
                "default_assessment_modules": ["Microsoft365"],
                "notes": [
                    "This is the closest current launcher target for future assessment execution.",
                    "The function currently relies on stub-rule behavior unless rules or context are provided by a later binding phase.",
                    "The current interface does not expose launcher auth settings or AI options directly.",
                ],
            }
        ),
    ]


def get_profile_by_id(profile_id: str) -> RunProfile | None:
    """Return one profile by identifier."""
    for profile in get_profile_catalog():
        if profile.profile_id == profile_id:
            return profile
    return None
