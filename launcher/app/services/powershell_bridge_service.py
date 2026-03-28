"""PowerShell bridge service used by the launcher UI."""

from __future__ import annotations

from dataclasses import dataclass
import json
from pathlib import Path

from app.models.launcher_config import LauncherConfig
from app.models.run_profile import RunProfile
from app.services.path_service import get_repo_root, resolve_repo_relative_path
from app.services.process_service import LogCallback, ProcessResult, ProcessService


@dataclass(slots=True)
class BridgeCommand:
    """Normalized PowerShell invocation prepared for ProcessService."""

    arguments: list[str]
    working_directory: Path
    description: str


class PowerShellBridgeService:
    """Thin launcher-facing wrapper for safe PowerShell interactions."""

    def __init__(
        self,
        repo_root: Path | None = None,
        process_service: ProcessService | None = None,
    ) -> None:
        self._repo_root = repo_root or get_repo_root()
        self._process_service = process_service or ProcessService()

    @property
    def executable(self) -> str:
        return self._process_service.executable

    def run_inline_command(
        self,
        command: str,
        *,
        on_output: LogCallback | None = None,
        working_directory: Path | None = None,
    ) -> ProcessResult:
        prepared = BridgeCommand(
            arguments=["-NoLogo", "-NoProfile", "-Command", command],
            working_directory=working_directory or self._repo_root,
            description="inline-command",
        )
        return self._execute(prepared, on_output=on_output)

    def run_environment_probe(self, *, on_output: LogCallback | None = None) -> ProcessResult:
        command = (
            "$payload = [pscustomobject]@{"
            " PowerShellVersion = $PSVersionTable.PSVersion.ToString();"
            " PSEdition = $PSVersionTable.PSEdition;"
            f" RepoRoot = '{self._repo_root.as_posix()}';"
            " WorkingDirectory = (Get-Location).Path"
            " };"
            "$payload | ConvertTo-Json -Compress"
        )
        return self.run_inline_command(command, on_output=on_output)

    def invoke_prerequisite_validation(
        self,
        config: LauncherConfig,
        *,
        on_output: LogCallback | None = None,
    ) -> ProcessResult:
        prereqs_manifest = self._repo_root / "src" / "AuditXpert.Prereqs" / "AuditXpert.Prereqs.psd1"
        config_json = self._build_config_json(config)
        command = (
            "$launcherConfig = @'\n"
            f"{config_json}\n"
            "'@ | ConvertFrom-Json -Depth 10; "
            f"Import-Module '{prereqs_manifest.as_posix()}' -Force; "
            "$result = Test-AxEnvironmentReadiness "
            "-SelectedModule @($launcherConfig.selected_assessment_modules) "
            "-ExecutionProfile $launcherConfig.selected_execution_profile "
            "-AuthenticationMode $launcherConfig.auth.authentication_mode "
            "-InteractiveLogin:$launcherConfig.auth.interactive_login "
            "-TenantId $launcherConfig.auth.tenant_id "
            "-ClientId $launcherConfig.auth.client_id "
            "-ClientSecretPath $launcherConfig.auth.client_secret_path "
            "-UseSecureSecretEntry:$launcherConfig.auth.use_secure_secret_entry "
            "-CertificateThumbprint $launcherConfig.auth.certificate.thumbprint "
            "-CertificateSubject $launcherConfig.auth.certificate.subject "
            "-CertificateStore $launcherConfig.auth.certificate.store "
            "-CertificatePath $launcherConfig.auth.certificate.path "
            "-OutputPath $launcherConfig.output_path "
            "-EvidencePath $launcherConfig.evidence_path; "
            "$result | ConvertTo-Json -Depth 12 -Compress"
        )
        return self.run_inline_command(command, on_output=on_output)

    def invoke_prerequisite_install(
        self,
        config: LauncherConfig,
        *,
        confirm_install: bool,
        on_output: LogCallback | None = None,
    ) -> ProcessResult:
        prereqs_manifest = self._repo_root / "src" / "AuditXpert.Prereqs" / "AuditXpert.Prereqs.psd1"
        config_json = self._build_config_json(config)
        confirm_literal = "$true" if confirm_install else "$false"
        command = (
            "$launcherConfig = @'\n"
            f"{config_json}\n"
            "'@ | ConvertFrom-Json -Depth 10; "
            f"Import-Module '{prereqs_manifest.as_posix()}' -Force; "
            "$result = Install-AxRequiredModule "
            "-SelectedModule @($launcherConfig.selected_assessment_modules) "
            "-ExecutionProfile $launcherConfig.selected_execution_profile "
            "-AuthenticationMode $launcherConfig.auth.authentication_mode "
            f"-ConfirmInstall:{confirm_literal}; "
            "$result | ConvertTo-Json -Depth 10 -Compress"
        )
        return self.run_inline_command(command, on_output=on_output)

    def invoke_profile(
        self,
        profile: RunProfile,
        config: LauncherConfig,
        *,
        runtime_config_path: Path | None = None,
        on_output: LogCallback | None = None,
    ) -> ProcessResult:
        prepared = self._build_profile_command(profile, config, runtime_config_path=runtime_config_path)
        return self._execute(prepared, on_output=on_output)

    def _execute(
        self,
        command: BridgeCommand,
        *,
        on_output: LogCallback | None = None,
    ) -> ProcessResult:
        return self._process_service.run(
            command.arguments,
            working_directory=command.working_directory,
            on_output=on_output,
        )

    def _build_profile_command(
        self,
        profile: RunProfile,
        config: LauncherConfig,
        runtime_config_path: Path | None = None,
    ) -> BridgeCommand:
        binding = profile.binding
        if binding.binding_type == "script" and binding.path:
            script_path = self._repo_root / binding.path
            arguments = ["-NoLogo", "-NoProfile", "-File", str(script_path)]

            if profile.profile_id in {"workspace-initialize", "smoke-test"} and config.output_path:
                workspace_root = resolve_repo_relative_path(config.output_path)
                if workspace_root is not None:
                    arguments.extend(["-WorkspaceRoot", str(workspace_root)])

            if "PassThru" in binding.supported_parameters:
                arguments.append("-PassThru")

            return BridgeCommand(
                arguments=arguments,
                working_directory=self._repo_root,
                description=profile.profile_id,
            )

        if binding.binding_type == "module-function" and binding.module_manifest and binding.command_name:
            manifest_path = self._repo_root / binding.module_manifest
            packs = config.selected_assessment_modules or profile.default_assessment_modules or ["Microsoft365"]
            command_lines = [
                f"Import-Module '{manifest_path.as_posix()}' -Force",
                f"{binding.command_name} -AssessmentPack @({self._format_ps_string_array(packs)})",
            ]

            if runtime_config_path is not None:
                command_lines[-1] += f" -RuntimeConfigPath '{runtime_config_path.as_posix()}'"

            output_path = resolve_repo_relative_path(config.output_path)
            if output_path is not None and profile.supports_output_path:
                command_lines[-1] += f" -OutputPath '{output_path.as_posix()}'"

            export_formats = config.export_formats or ["Json"]
            command_lines[-1] += f" -ExportFormat @({self._format_ps_string_array(export_formats)})"
            command_lines[-1] += " | ConvertTo-Json -Depth 12"

            return BridgeCommand(
                arguments=["-NoLogo", "-NoProfile", "-Command", "; ".join(command_lines)],
                working_directory=self._repo_root,
                description=profile.profile_id,
            )

        raise ValueError(f"Unsupported PowerShell binding for profile {profile.profile_id}.")

    @staticmethod
    def _format_ps_string_array(values: list[str]) -> str:
        return ", ".join(f"'{value}'" for value in values)

    @staticmethod
    def _build_config_json(config: LauncherConfig) -> str:
        return json.dumps(config.to_dict(), separators=(",", ":"))
