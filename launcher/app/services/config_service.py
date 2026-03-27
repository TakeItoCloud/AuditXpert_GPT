"""Config loading and validation helpers for the launcher contract."""

from __future__ import annotations

import json
from pathlib import Path

from app.models.launcher_config import LauncherConfig
from app.services.path_service import (
    get_default_evidence_path,
    get_default_output_path,
    resolve_repo_relative_path,
)
from app.services.profile_catalog_service import get_profile_by_id


def load_launcher_config(path: str | Path) -> LauncherConfig:
    """Load launcher config JSON into the normalized dataclass model."""
    config_path = Path(path)
    with config_path.open("r", encoding="utf-8") as handle:
        payload = json.load(handle)
    return LauncherConfig.from_dict(payload)


def save_launcher_config(config: LauncherConfig, path: str | Path) -> Path:
    """Persist launcher config JSON using the current contract structure."""
    target_path = Path(path)
    target_path.parent.mkdir(parents=True, exist_ok=True)
    with target_path.open("w", encoding="utf-8") as handle:
        json.dump(config.to_dict(), handle, indent=2)
        handle.write("\n")
    return target_path


def apply_launcher_defaults(config: LauncherConfig) -> LauncherConfig:
    """Apply repo-aware defaults without mutating assessment logic."""
    if not config.output_path:
        config.output_path = str(get_default_output_path())
    if not config.evidence_path:
        config.evidence_path = str(get_default_evidence_path())
    return config


def validate_launcher_config(config: LauncherConfig) -> list[str]:
    """Return validation issues for the launcher contract."""
    issues: list[str] = []

    profile = get_profile_by_id(config.selected_execution_profile)
    if profile is None:
        issues.append(f"Unknown execution profile: {config.selected_execution_profile}")
        return issues

    if config.selected_assessment_modules and not profile.supports_assessment_modules:
        issues.append(
            f"Execution profile '{profile.profile_id}' does not currently accept assessment module selections."
        )

    if config.auth.authentication_mode not in {"delegated", "app", "hybrid-local"}:
        issues.append("Authentication mode must be one of: delegated, app, hybrid-local.")

    if config.auth.interactive_login and config.auth.authentication_mode == "app":
        issues.append("App authentication should not be marked as interactive login.")

    if (
        config.auth.authentication_mode == "app"
        and not config.auth.client_id
    ):
        issues.append("App authentication requires a client_id placeholder or configured value.")

    if config.ai.enabled and not (config.ai.provider and config.ai.model):
        issues.append("AI-enabled launcher configs must define both provider and model placeholders.")

    if not resolve_repo_relative_path(config.output_path):
        issues.append("An output_path is required once defaults are applied.")

    if not resolve_repo_relative_path(config.evidence_path):
        issues.append("An evidence_path is required once defaults are applied.")

    return issues
