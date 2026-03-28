"""Runtime-config export for launcher-driven PowerShell execution."""

from __future__ import annotations

from dataclasses import dataclass
from datetime import datetime, timezone
import json
from pathlib import Path
import re
import uuid

from app.models.launcher_config import LauncherConfig
from app.models.run_profile import RunProfile
from app.services.path_service import get_repo_root, resolve_repo_relative_path


@dataclass(slots=True)
class RuntimeConfigExport:
    """Result of writing a launcher runtime contract."""

    path: Path
    payload: dict


class RuntimeConfigService:
    """Writes runtime configuration contracts for PowerShell orchestration."""

    def __init__(self, repo_root: Path | None = None) -> None:
        self._repo_root = repo_root or get_repo_root()

    def export(self, config: LauncherConfig, profile: RunProfile) -> RuntimeConfigExport:
        payload = self.build_payload(config, profile)
        target_path = self._build_target_path(profile.profile_id)
        target_path.parent.mkdir(parents=True, exist_ok=True)
        target_path.write_text(json.dumps(payload, indent=2) + "\n", encoding="utf-8")
        return RuntimeConfigExport(path=target_path, payload=payload)

    def build_payload(self, config: LauncherConfig, profile: RunProfile) -> dict:
        output_path = resolve_repo_relative_path(config.output_path)
        evidence_path = resolve_repo_relative_path(config.evidence_path)
        auth_payload = config.auth.to_dict()
        ai_payload = config.ai.to_dict()

        auth_payload["resolved_auth_flow"] = self._resolve_auth_flow(config)
        auth_payload["connector_auth"] = self._build_connector_auth_map(config)
        ai_payload["requested"] = bool(config.ai.enabled)

        return {
            "contract_version": "1.0",
            "generated_at_utc": datetime.now(timezone.utc).isoformat(),
            "launcher_profile": {
                "profile_id": profile.profile_id,
                "display_name": profile.display_name,
                "category": profile.category,
                "current_capability": profile.current_capability,
            },
            "assessment": {
                "selected_modules": list(config.selected_assessment_modules),
                "export_formats": list(config.export_formats or ["Json"]),
                "output_path": str(output_path) if output_path else None,
                "evidence_path": str(evidence_path) if evidence_path else None,
            },
            "authentication": auth_payload,
            "ai": ai_payload,
            "runtime_options": {
                "install_missing_modules": config.install_missing_modules,
                "open_results_after_run": config.open_results_after_run,
            },
        }

    def get_runtime_root(self) -> Path:
        return self._repo_root / "runtime" / "launcher"

    def _build_target_path(self, profile_id: str) -> Path:
        safe_profile = re.sub(r"[^a-zA-Z0-9_-]+", "-", profile_id).strip("-") or "profile"
        timestamp = datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%SZ")
        return self.get_runtime_root() / f"{timestamp}-{safe_profile}-{uuid.uuid4().hex[:8]}.json"

    @staticmethod
    def _resolve_auth_flow(config: LauncherConfig) -> str:
        auth = config.auth
        if auth.authentication_mode == "delegated":
            return "interactive-delegated"
        if auth.authentication_mode == "hybrid-local":
            return "integrated-local"
        if auth.client_secret_path or auth.use_secure_secret_entry:
            return "app-client-secret"
        if auth.certificate and (auth.certificate.thumbprint or auth.certificate.subject or auth.certificate.path):
            return "app-certificate"
        return "app-unspecified"

    @staticmethod
    def _build_connector_auth_map(config: LauncherConfig) -> dict[str, str]:
        selected = set(config.selected_assessment_modules)
        auth_mode = config.auth.authentication_mode
        mapping: dict[str, str] = {}

        if "Microsoft365" in selected:
            mapping["MicrosoftGraph"] = "AppOnly" if auth_mode == "app" else "Delegated"
            mapping["ExchangeOnline"] = "AppOnly" if auth_mode == "app" else "Delegated"
        if "Azure" in selected:
            mapping["Azure"] = "ServicePrincipal" if auth_mode == "app" else "Delegated"
        if "Hybrid" in selected:
            mapping["HybridLocal"] = "Integrated"

        return mapping
