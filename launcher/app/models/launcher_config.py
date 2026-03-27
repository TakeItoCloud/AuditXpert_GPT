"""Launcher configuration contract for AuditXpert."""

from __future__ import annotations

from dataclasses import asdict, dataclass, field
from typing import Any

from app.models.auth_config import AuthConfig


@dataclass(slots=True)
class AiConfig:
    """AI settings stored by the launcher without embedding secrets."""

    enabled: bool = False
    provider: str | None = None
    model: str | None = None
    api_key_env_var: str | None = None
    external_config_path: str | None = None

    @classmethod
    def from_dict(cls, data: dict[str, Any] | None) -> "AiConfig":
        data = data or {}
        return cls(
            enabled=bool(data.get("enabled", False)),
            provider=data.get("provider"),
            model=data.get("model"),
            api_key_env_var=data.get("api_key_env_var"),
            external_config_path=data.get("external_config_path"),
        )

    def to_dict(self) -> dict[str, Any]:
        return asdict(self)


@dataclass(slots=True)
class LauncherConfig:
    """Operator-selected launcher state normalized for future PS binding."""

    contract_version: str = "1.0"
    selected_assessment_modules: list[str] = field(default_factory=list)
    selected_execution_profile: str = "bootstrap-validation"
    output_path: str | None = None
    evidence_path: str | None = None
    export_formats: list[str] = field(default_factory=list)
    install_missing_modules: bool = False
    open_results_after_run: bool = False
    auth: AuthConfig = field(default_factory=AuthConfig)
    ai: AiConfig = field(default_factory=AiConfig)

    @classmethod
    def from_dict(cls, data: dict[str, Any]) -> "LauncherConfig":
        return cls(
            contract_version=data.get("contract_version", "1.0"),
            selected_assessment_modules=list(data.get("selected_assessment_modules", [])),
            selected_execution_profile=data.get("selected_execution_profile", "bootstrap-validation"),
            output_path=data.get("output_path"),
            evidence_path=data.get("evidence_path"),
            export_formats=list(data.get("export_formats", [])),
            install_missing_modules=bool(data.get("install_missing_modules", False)),
            open_results_after_run=bool(data.get("open_results_after_run", False)),
            auth=AuthConfig.from_dict(data.get("auth")),
            ai=AiConfig.from_dict(data.get("ai")),
        )

    def to_dict(self) -> dict[str, Any]:
        return asdict(self)
