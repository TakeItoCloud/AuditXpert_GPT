"""Authentication models for the AuditXpert launcher contract."""

from __future__ import annotations

from dataclasses import asdict, dataclass
from typing import Any


@dataclass(slots=True)
class CertificateConfig:
    """Certificate selector metadata without storing certificate material."""

    thumbprint: str | None = None
    subject: str | None = None
    store: str | None = None
    path: str | None = None

    @classmethod
    def from_dict(cls, data: dict[str, Any] | None) -> "CertificateConfig":
        data = data or {}
        return cls(
            thumbprint=data.get("thumbprint"),
            subject=data.get("subject"),
            store=data.get("store"),
            path=data.get("path"),
        )

    def to_dict(self) -> dict[str, Any]:
        return asdict(self)


@dataclass(slots=True)
class AuthConfig:
    """Launcher-side authentication intent for future PowerShell bindings."""

    authentication_mode: str = "delegated"
    interactive_login: bool = True
    tenant_id: str | None = None
    client_id: str | None = None
    client_secret_path: str | None = None
    use_secure_secret_entry: bool = False
    certificate: CertificateConfig | None = None

    @classmethod
    def from_dict(cls, data: dict[str, Any] | None) -> "AuthConfig":
        data = data or {}
        return cls(
            authentication_mode=data.get("authentication_mode", "delegated"),
            interactive_login=bool(data.get("interactive_login", True)),
            tenant_id=data.get("tenant_id"),
            client_id=data.get("client_id"),
            client_secret_path=data.get("client_secret_path"),
            use_secure_secret_entry=bool(data.get("use_secure_secret_entry", False)),
            certificate=CertificateConfig.from_dict(data.get("certificate")),
        )

    def to_dict(self) -> dict[str, Any]:
        payload = asdict(self)
        if self.certificate is None:
            payload["certificate"] = CertificateConfig().to_dict()
        return payload
