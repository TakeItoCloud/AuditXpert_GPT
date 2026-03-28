"""Launcher-side prerequisite orchestration over the PowerShell bridge."""

from __future__ import annotations

import json
from dataclasses import dataclass, field
from typing import Any

from app.models.launcher_config import LauncherConfig
from app.services.powershell_bridge_service import PowerShellBridgeService


@dataclass(slots=True)
class PrereqCheck:
    """One prerequisite check returned from PowerShell."""

    category: str
    name: str
    status: str
    message: str
    details: dict[str, Any] = field(default_factory=dict)


@dataclass(slots=True)
class PrereqValidationResult:
    """Parsed prerequisite validation result."""

    is_ready: bool
    overall_status: str
    checks: list[PrereqCheck] = field(default_factory=list)
    missing_modules: list[dict[str, Any]] = field(default_factory=list)
    can_install_missing_modules: bool = False
    raw_output: dict[str, Any] = field(default_factory=dict)

    @property
    def summary(self) -> str:
        missing_count = len(self.missing_modules)
        return (
            f"Prerequisite status: {self.overall_status}. "
            f"Checks: {len(self.checks)}. Missing modules: {missing_count}."
        )


@dataclass(slots=True)
class ModuleInstallResult:
    """Parsed module-install result."""

    status: str
    message: str
    per_module: list[dict[str, Any]] = field(default_factory=list)
    raw_output: dict[str, Any] = field(default_factory=dict)


class PrereqService:
    """Thin launcher service that delegates prerequisite work to PowerShell."""

    def __init__(self, bridge: PowerShellBridgeService) -> None:
        self._bridge = bridge

    def validate(
        self,
        config: LauncherConfig,
        *,
        on_output: callable | None = None,
    ) -> PrereqValidationResult:
        process_result = self._bridge.invoke_prerequisite_validation(config, on_output=on_output)
        payload = self._parse_json_output(process_result.stdout)
        checks = [
            PrereqCheck(
                category=item.get("Category", ""),
                name=item.get("Name", ""),
                status=item.get("Status", ""),
                message=item.get("Message", ""),
                details=item.get("Details") or {},
            )
            for item in self._ensure_list(payload.get("Checks"))
        ]

        return PrereqValidationResult(
            is_ready=bool(payload.get("IsReady", False)),
            overall_status=payload.get("OverallStatus", "Unknown"),
            checks=checks,
            missing_modules=self._ensure_list(payload.get("MissingModules")),
            can_install_missing_modules=bool(payload.get("CanInstallMissingModules", False)),
            raw_output=payload,
        )

    def install_missing_modules(
        self,
        config: LauncherConfig,
        *,
        confirm_install: bool,
        on_output: callable | None = None,
    ) -> ModuleInstallResult:
        process_result = self._bridge.invoke_prerequisite_install(
            config,
            confirm_install=confirm_install,
            on_output=on_output,
        )
        payload = self._parse_json_output(process_result.stdout)
        return ModuleInstallResult(
            status=payload.get("Status", "Unknown"),
            message=payload.get("Message", ""),
            per_module=self._ensure_list(payload.get("PerModule")),
            raw_output=payload,
        )

    @staticmethod
    def build_checklist_items(result: PrereqValidationResult) -> list[str]:
        items = [result.summary]
        items.extend(f"[{check.status}] {check.name}: {check.message}" for check in result.checks)
        return items

    @staticmethod
    def _parse_json_output(stdout: str) -> dict[str, Any]:
        if not stdout.strip():
            return {}
        return json.loads(stdout)

    @staticmethod
    def _ensure_list(value: Any) -> list[Any]:
        if value is None:
            return []
        if isinstance(value, list):
            return value
        return [value]
