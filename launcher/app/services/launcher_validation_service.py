"""Python-side preflight validation for launcher execution."""

from __future__ import annotations

from dataclasses import dataclass, field
from pathlib import Path

from app.models.auth_config import CertificateConfig
from app.models.launcher_config import LauncherConfig
from app.services.config_service import validate_launcher_config
from app.services.path_service import get_repo_root, resolve_repo_relative_path
from app.services.profile_catalog_service import get_profile_by_id


@dataclass(slots=True)
class LauncherValidationResult:
    """Structured validation result for launcher preflight checks."""

    is_valid: bool
    issues: list[str] = field(default_factory=list)
    warnings: list[str] = field(default_factory=list)


class LauncherValidationService:
    """Validate launcher config and local runtime prerequisites before bridge calls."""

    def __init__(self, repo_root: Path | None = None) -> None:
        self._repo_root = repo_root or get_repo_root()

    def validate(self, config: LauncherConfig) -> LauncherValidationResult:
        issues = list(validate_launcher_config(config))
        warnings: list[str] = []

        if not self._repo_root.exists():
            issues.append(f"Repository root does not exist: {self._repo_root}")

        profile = get_profile_by_id(config.selected_execution_profile)
        if profile is None:
            issues.append(f"Selected execution profile was not found: {config.selected_execution_profile}")

        output_path = resolve_repo_relative_path(config.output_path)
        evidence_path = resolve_repo_relative_path(config.evidence_path)

        issues.extend(self._validate_target_path(output_path, "output"))
        issues.extend(self._validate_target_path(evidence_path, "evidence"))

        if config.auth.authentication_mode == "app":
            if not config.auth.tenant_id:
                issues.append("App authentication requires a tenant ID.")
            if not config.auth.client_id:
                issues.append("App authentication requires a client ID.")

            certificate = config.auth.certificate or CertificateConfig()
            has_secret_mode = bool(config.auth.client_secret_path or config.auth.use_secure_secret_entry)
            has_certificate_mode = bool(
                certificate.thumbprint or certificate.subject or certificate.path
            )

            if not has_secret_mode and not has_certificate_mode:
                issues.append(
                    "App authentication requires either a client secret placeholder or certificate metadata."
                )

            if config.auth.client_secret_path:
                secret_path = resolve_repo_relative_path(config.auth.client_secret_path)
                if secret_path and secret_path.exists() and secret_path.is_dir():
                    issues.append("Client secret path must point to a file location, not a directory.")
                elif secret_path and not secret_path.exists():
                    warnings.append("Client secret path does not exist yet; runtime secure entry may be required.")

            if certificate.path:
                certificate_path = resolve_repo_relative_path(certificate.path)
                if certificate_path and not certificate_path.exists():
                    warnings.append("Certificate path does not exist yet; certificate store lookup may be required.")

        if config.auth.authentication_mode == "delegated" and not config.auth.interactive_login:
            warnings.append("Delegated authentication is selected without interactive login enabled.")

        return LauncherValidationResult(is_valid=not issues, issues=issues, warnings=warnings)

    def _validate_target_path(self, path_value: Path | None, label: str) -> list[str]:
        issues: list[str] = []
        if path_value is None:
            issues.append(f"{label.capitalize()} path is not set.")
            return issues

        parent = path_value if path_value.suffix == "" else path_value.parent
        if parent.exists() and not parent.is_dir():
            issues.append(f"{label.capitalize()} path parent is not a directory: {parent}")
        return issues
