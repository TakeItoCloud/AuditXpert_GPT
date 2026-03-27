"""Run-profile metadata for mapping launcher selections to PowerShell entry points."""

from __future__ import annotations

from dataclasses import asdict, dataclass, field
from typing import Any


@dataclass(slots=True)
class PowerShellBinding:
    """Describes one PowerShell invocation target."""

    binding_type: str
    path: str | None = None
    module_manifest: str | None = None
    command_name: str | None = None
    supported_parameters: list[str] = field(default_factory=list)

    @classmethod
    def from_dict(cls, data: dict[str, Any]) -> "PowerShellBinding":
        return cls(
            binding_type=data["binding_type"],
            path=data.get("path"),
            module_manifest=data.get("module_manifest"),
            command_name=data.get("command_name"),
            supported_parameters=list(data.get("supported_parameters", [])),
        )

    def to_dict(self) -> dict[str, Any]:
        return asdict(self)


@dataclass(slots=True)
class RunProfile:
    """Normalized execution-profile descriptor used by the launcher."""

    profile_id: str
    display_name: str
    category: str
    description: str
    binding: PowerShellBinding
    current_capability: str
    supports_assessment_modules: bool = False
    supports_auth_config: bool = False
    supports_ai_options: bool = False
    supports_output_path: bool = False
    default_assessment_modules: list[str] = field(default_factory=list)
    notes: list[str] = field(default_factory=list)

    @classmethod
    def from_dict(cls, data: dict[str, Any]) -> "RunProfile":
        return cls(
            profile_id=data["profile_id"],
            display_name=data["display_name"],
            category=data["category"],
            description=data["description"],
            binding=PowerShellBinding.from_dict(data["binding"]),
            current_capability=data["current_capability"],
            supports_assessment_modules=bool(data.get("supports_assessment_modules", False)),
            supports_auth_config=bool(data.get("supports_auth_config", False)),
            supports_ai_options=bool(data.get("supports_ai_options", False)),
            supports_output_path=bool(data.get("supports_output_path", False)),
            default_assessment_modules=list(data.get("default_assessment_modules", [])),
            notes=list(data.get("notes", [])),
        )

    def to_dict(self) -> dict[str, Any]:
        return asdict(self)
