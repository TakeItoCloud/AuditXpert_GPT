"""Path helpers for launcher configuration and repo-relative storage."""

from __future__ import annotations

from pathlib import Path


def get_repo_root() -> Path:
    """Return the repository root based on the launcher package location."""
    return Path(__file__).resolve().parents[3]


def resolve_repo_relative_path(path_value: str | None) -> Path | None:
    """Resolve a path relative to the repository root when not already absolute."""
    if not path_value:
        return None

    candidate = Path(path_value)
    if candidate.is_absolute():
        return candidate
    return get_repo_root() / candidate


def get_default_output_path() -> Path:
    """Return the default findings output path used by the launcher contract."""
    return get_repo_root() / "output" / "findings"


def get_default_evidence_path() -> Path:
    """Return the default evidence path used by the launcher contract."""
    return get_repo_root() / "output" / "evidence"
