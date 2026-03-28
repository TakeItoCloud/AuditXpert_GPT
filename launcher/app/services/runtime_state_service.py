"""Runtime-state tracking for the launcher bridge."""

from __future__ import annotations

from dataclasses import asdict, dataclass, field
from typing import Any


@dataclass(slots=True)
class RuntimeState:
    """Normalized runtime state surfaced to the UI."""

    validation_status: str = "pending"
    selected_profile: str | None = None
    output_path_state: str = "unknown"
    last_run_status: str = "not-run"
    is_running: bool = False
    last_error_summary: str | None = None
    last_stdout: str | None = None
    last_stderr: str | None = None
    last_exit_code: int | None = None
    validation_issues: list[str] = field(default_factory=list)
    validation_warnings: list[str] = field(default_factory=list)
    runtime_config_path: str | None = None
    runtime_log_path: str | None = None
    report_bundle_path: str | None = None
    result_paths: list[str] = field(default_factory=list)


class RuntimeStateService:
    """Owns and updates the launcher's current runtime state."""

    def __init__(self) -> None:
        self._state = RuntimeState()

    def snapshot(self) -> RuntimeState:
        return RuntimeState(**asdict(self._state))

    def as_dict(self) -> dict[str, Any]:
        return asdict(self._state)

    def set_selected_profile(self, profile_id: str | None) -> None:
        self._state.selected_profile = profile_id

    def set_output_path_state(self, state: str) -> None:
        self._state.output_path_state = state

    def mark_validation(
        self,
        status: str,
        *,
        issues: list[str] | None = None,
        warnings: list[str] | None = None,
    ) -> None:
        self._state.validation_status = status
        self._state.validation_issues = list(issues or [])
        self._state.validation_warnings = list(warnings or [])

    def mark_running(self, is_running: bool) -> None:
        self._state.is_running = is_running
        if is_running:
            self._state.last_error_summary = None

    def set_runtime_artifacts(
        self,
        *,
        runtime_config_path: str | None = None,
        runtime_log_path: str | None = None,
        report_bundle_path: str | None = None,
        result_paths: list[str] | None = None,
    ) -> None:
        self._state.runtime_config_path = runtime_config_path
        self._state.runtime_log_path = runtime_log_path
        self._state.report_bundle_path = report_bundle_path
        self._state.result_paths = list(result_paths or [])

    def record_process_result(
        self,
        *,
        status: str,
        exit_code: int | None,
        stdout: str | None = None,
        stderr: str | None = None,
        error_summary: str | None = None,
    ) -> None:
        self._state.last_run_status = status
        self._state.last_exit_code = exit_code
        self._state.last_stdout = stdout
        self._state.last_stderr = stderr
        self._state.last_error_summary = error_summary
        self._state.is_running = False
