"""Main window for the AuditXpert desktop launcher."""

from __future__ import annotations

import os
import json
from pathlib import Path

from PySide6.QtCore import Qt
from PySide6.QtWidgets import (
    QFrame,
    QHBoxLayout,
    QLabel,
    QMainWindow,
    QPushButton,
    QMessageBox,
    QScrollArea,
    QSplitter,
    QStatusBar,
    QVBoxLayout,
    QWidget,
)

from app.models.launcher_config import LauncherConfig
from app.services.config_service import apply_launcher_defaults, save_launcher_config
from app.services.launcher_validation_service import LauncherValidationService
from app.services.path_service import get_repo_root, resolve_repo_relative_path
from app.services.powershell_bridge_service import PowerShellBridgeService
from app.services.prereq_service import PrereqService
from app.services.profile_catalog_service import get_profile_catalog
from app.services.profile_catalog_service import get_profile_by_id
from app.services.runtime_config_service import RuntimeConfigService
from app.services.runtime_state_service import RuntimeStateService
from app.ui.ai_panel import AiPanel
from app.ui.assessment_panel import AssessmentPanel
from app.ui.auth_panel import AuthPanel
from app.ui.help_window import AppAuthHelpWindow
from app.ui.paths_panel import PathsPanel
from app.ui.prereqs_panel import PrereqsPanel
from app.ui.results_panel import ResultsPanel
from app.ui.status_panel import StatusPanel


class AuditXpertMainWindow(QMainWindow):
    """Enterprise-style launcher with panel-based state management."""

    def __init__(self) -> None:
        super().__init__()
        self._config = apply_launcher_defaults(LauncherConfig())
        self._profiles = get_profile_catalog()
        self._repo_root = get_repo_root()
        self._runtime_state = RuntimeStateService()
        self._validation_service = LauncherValidationService(self._repo_root)
        self._powershell_bridge = PowerShellBridgeService(self._repo_root)
        self._prereq_service = PrereqService(self._powershell_bridge)
        self._runtime_config_service = RuntimeConfigService(self._repo_root)
        self._active_runtime_log_path: Path | None = None
        self._help_window: AppAuthHelpWindow | None = None
        self.setWindowTitle("AuditXpert Desktop Launcher")
        self.resize(1440, 900)
        self._build_ui()
        self._wire_panel_events()
        self._sync_runtime_context()
        self.status_panel.refresh()

    def _build_ui(self) -> None:
        central_widget = QWidget()
        main_layout = QVBoxLayout(central_widget)
        main_layout.setContentsMargins(20, 20, 20, 20)
        main_layout.setSpacing(16)

        main_layout.addWidget(self._build_header())
        splitter = QSplitter(Qt.Orientation.Horizontal)
        splitter.addWidget(self._build_left_column())
        splitter.addWidget(self._build_right_column())
        splitter.setStretchFactor(0, 3)
        splitter.setStretchFactor(1, 2)
        main_layout.addWidget(splitter)

        self.setCentralWidget(central_widget)
        status_bar = QStatusBar()
        status_bar.showMessage("Launcher UI loaded. PowerShell bridge foundation is ready for safe validation calls.")
        self.setStatusBar(status_bar)

    def _build_header(self) -> QWidget:
        frame = QFrame()
        layout = QVBoxLayout(frame)
        title = QLabel("AuditXpert Desktop Launcher")
        title.setProperty("role", "hero")
        subtitle = QLabel(
            "Thin desktop orchestration shell for the PowerShell-first assessment platform. "
            "This phase adds the bridge foundation for safe PowerShell validation calls while keeping execution logic in PowerShell."
        )
        subtitle.setWordWrap(True)
        subtitle.setProperty("role", "caption")

        actions = QHBoxLayout()
        self.validate_button = QPushButton("Validate Launcher State")
        self.validate_button.clicked.connect(self._validate_launcher_state)
        actions.addWidget(self.validate_button)

        self.run_button = QPushButton("Run Assessment")
        self.run_button.setEnabled(False)
        self.run_button.clicked.connect(self._run_assessment)
        actions.addWidget(self.run_button)
        actions.addStretch()

        layout.addWidget(title)
        layout.addWidget(subtitle)
        layout.addLayout(actions)
        return frame

    def _build_left_column(self) -> QWidget:
        panel = QScrollArea()
        panel.setWidgetResizable(True)
        container = QWidget()
        layout = QVBoxLayout(container)
        layout.setSpacing(14)

        self.assessment_panel = AssessmentPanel(self._config, self._profiles)
        self.auth_panel = AuthPanel(self._config)
        self.ai_panel = AiPanel(self._config)
        self.paths_panel = PathsPanel(self._config)

        layout.addWidget(self.assessment_panel)
        layout.addWidget(self.auth_panel)
        layout.addWidget(self.ai_panel)
        layout.addWidget(self.paths_panel)
        layout.addStretch()
        panel.setWidget(container)
        return panel

    def _build_right_column(self) -> QWidget:
        panel = QScrollArea()
        panel.setWidgetResizable(True)
        container = QWidget()
        layout = QVBoxLayout(container)
        layout.setSpacing(14)

        self.prereqs_panel = PrereqsPanel()
        self.status_panel = StatusPanel(self._config, self._runtime_state)
        self.results_panel = ResultsPanel()

        layout.addWidget(self.prereqs_panel)
        layout.addWidget(self.status_panel)
        layout.addWidget(self.results_panel)
        layout.addStretch()
        panel.setWidget(container)
        return panel

    def _wire_panel_events(self) -> None:
        for panel in [self.assessment_panel, self.auth_panel, self.ai_panel, self.paths_panel]:
            panel.config_changed.connect(self._on_config_changed)
            panel.status_message.connect(self._log_status)

        self.auth_panel.open_help_requested.connect(self._open_help_window)
        self.prereqs_panel.status_message.connect(self._log_status)
        self.prereqs_panel.validate_requested.connect(self._validate_launcher_state)
        self.prereqs_panel.install_modules_requested.connect(self._install_missing_modules)
        self.results_panel.status_message.connect(self._log_status)
        self.results_panel.open_results_requested.connect(self._open_results_folder)
        self.results_panel.open_report_requested.connect(self._open_report_bundle)
        self.results_panel.open_runtime_log_requested.connect(self._open_runtime_log)
        self.results_panel.export_config_requested.connect(self._export_config_snapshot)

    def _on_config_changed(self) -> None:
        self._runtime_state.mark_validation("pending", issues=[], warnings=[])
        self._sync_runtime_context()
        self.status_panel.refresh()

    def _log_status(self, message: str) -> None:
        sanitized = self._sanitize_log_message(message)
        self.status_panel.append_log(sanitized)
        self.statusBar().showMessage(sanitized)
        self._append_runtime_log(sanitized)

    def _open_help_window(self) -> None:
        if self._help_window is None:
            self._help_window = AppAuthHelpWindow()
        self._help_window.show()
        self._help_window.raise_()
        self._help_window.activateWindow()
        self._log_status("Opened app-authentication guidance window.")

    def _sync_runtime_context(self) -> None:
        state = self._runtime_state.snapshot()
        validation_status = state.validation_status
        self._runtime_state.set_selected_profile(self._config.selected_execution_profile)
        output_path = resolve_repo_relative_path(self._config.output_path)
        output_state = "ready" if output_path is not None else "missing"
        self._runtime_state.set_output_path_state(output_state)
        self.results_panel.set_results_path(str(output_path) if output_path else None)
        self.results_panel.set_report_path(state.report_bundle_path)
        self.results_panel.set_runtime_log_path(state.runtime_log_path)
        self.results_panel.set_result_outputs(state.result_paths)
        profile = get_profile_by_id(self._config.selected_execution_profile)
        self.run_button.setEnabled(bool(profile and profile.category == "assessment" and validation_status == "passed" and not state.is_running))
        if validation_status == "pending":
            self.prereqs_panel.update_checklist(
                [
                    f"PowerShell bridge executable: {self._powershell_bridge.executable}",
                    f"Selected profile: {self._config.selected_execution_profile}",
                    f"Output path state: {output_state}",
                    f"Validation status: {validation_status}",
                ]
            )
            self.prereqs_panel.set_summary("Prerequisite status pending.")

    def _validate_launcher_state(self) -> bool:
        self._sync_runtime_context()
        self._runtime_state.mark_running(True)
        self.status_panel.refresh()
        self._log_status("Running launcher preflight validation.")

        validation = self._validation_service.validate(self._config)
        self._runtime_state.mark_validation(
            "passed" if validation.is_valid else "failed",
            issues=validation.issues,
            warnings=validation.warnings,
        )

        if not validation.is_valid:
            self._runtime_state.record_process_result(
                status="validation-failed",
                exit_code=None,
                error_summary="Launcher preflight validation failed before PowerShell invocation.",
            )
            for issue in validation.issues:
                self._log_status(f"Validation issue: {issue}")
            for warning in validation.warnings:
                self._log_status(f"Validation warning: {warning}")
            self.prereqs_panel.set_summary("Launcher validation failed before PowerShell prerequisite checks could run.")
            self.prereqs_panel.update_checklist(
                [f"[Failed] {issue}" for issue in validation.issues] +
                [f"[Warning] {warning}" for warning in validation.warnings]
            )
            self.prereqs_panel.set_install_enabled(False)
            self._sync_runtime_context()
            self.status_panel.refresh()
            return False

        prereq_result = self._prereq_service.validate(self._config, on_output=self._on_bridge_output)
        self.prereqs_panel.set_summary(prereq_result.summary)
        self.prereqs_panel.update_checklist(self._prereq_service.build_checklist_items(prereq_result))
        self.prereqs_panel.set_install_enabled(prereq_result.can_install_missing_modules)

        if prereq_result.is_ready:
            self._runtime_state.record_process_result(
                status="validation-succeeded",
                exit_code=0,
                stdout=prereq_result.summary,
                stderr="",
            )
            self._log_status("PowerShell prerequisite validation completed successfully.")
            validation_succeeded = True
        else:
            failed_messages = [
                check.message for check in prereq_result.checks if check.status in {"Failed", "Missing"}
            ]
            self._runtime_state.mark_validation("failed", issues=failed_messages)
            self._runtime_state.record_process_result(
                status="validation-failed",
                exit_code=1,
                stdout=prereq_result.summary,
                stderr="\n".join(failed_messages),
                error_summary="PowerShell prerequisite validation found missing requirements.",
            )
            self._log_status("PowerShell prerequisite validation found missing requirements.")
            validation_succeeded = False

        self._sync_runtime_context()
        self.status_panel.refresh()
        return validation_succeeded

    def _on_bridge_output(self, stream_name: str, text: str) -> None:
        prefix = "PowerShell" if stream_name == "stdout" else "PowerShell Error"
        self._log_status(f"{prefix}: {text}")

    def _open_results_folder(self) -> None:
        output_path = resolve_repo_relative_path(self._config.output_path)
        if output_path is None:
            self._log_status("No results path is currently configured.")
            return

        output_path.mkdir(parents=True, exist_ok=True)
        os.startfile(str(output_path))
        self._log_status(f"Opened results folder: {output_path}")

    def _export_config_snapshot(self) -> None:
        output_path = resolve_repo_relative_path(self._config.output_path)
        if output_path is None:
            self._log_status("Cannot export launcher config because the output path is not set.")
            return

        output_path.mkdir(parents=True, exist_ok=True)
        target_path = output_path / "launcher-config.snapshot.json"
        saved_path = save_launcher_config(self._config, target_path)
        self._log_status(f"Exported launcher config snapshot to {saved_path}")

    def _install_missing_modules(self) -> None:
        prompt = QMessageBox.question(
            self,
            "Install Missing Modules",
            "Install missing PowerShell modules in the CurrentUser scope for the selected launcher scope?",
            QMessageBox.StandardButton.Yes | QMessageBox.StandardButton.No,
            QMessageBox.StandardButton.No,
        )

        if prompt != QMessageBox.StandardButton.Yes:
            self._log_status("Module installation was cancelled by the operator.")
            return

        self._runtime_state.mark_running(True)
        self.status_panel.refresh()
        self._log_status("Running controlled module installation.")

        install_result = self._prereq_service.install_missing_modules(
            self._config,
            confirm_install=True,
            on_output=self._on_bridge_output,
        )
        self.prereqs_panel.set_summary(install_result.message)
        install_lines = [
            f"[{entry.get('Status', 'Unknown')}] {entry.get('Name', 'Module')}: {entry.get('Message', '')}"
            for entry in install_result.per_module
        ] or [install_result.message]
        self.prereqs_panel.update_checklist(install_lines)

        if install_result.status in {"Completed", "NothingToInstall"}:
            self._runtime_state.record_process_result(
                status="installation-succeeded",
                exit_code=0,
                stdout=install_result.message,
                stderr="",
            )
            self._log_status(install_result.message)
        else:
            self._runtime_state.record_process_result(
                status="installation-completed-with-failures",
                exit_code=1,
                stdout=install_result.message,
                stderr="\n".join(install_lines),
                error_summary=install_result.message,
            )
            self._log_status(install_result.message)

        self._runtime_state.mark_running(False)
        self._validate_launcher_state()

    def _run_assessment(self) -> None:
        profile = get_profile_by_id(self._config.selected_execution_profile)
        if profile is None:
            self._log_status("Cannot run assessment because the selected execution profile is not available.")
            return

        if profile.category != "assessment":
            self._log_status("The selected profile is not an assessment execution profile.")
            return

        if not self._validate_launcher_state():
            self._log_status("Assessment run cancelled because launcher validation did not pass.")
            return

        self._runtime_state.mark_running(True)
        self.status_panel.refresh()
        self._log_status("Exporting runtime configuration for backend execution.")
        runtime_export = self._runtime_config_service.export(self._config, profile)
        self._active_runtime_log_path = runtime_export.path.with_suffix(".log")
        self._runtime_state.set_runtime_artifacts(
            runtime_config_path=str(runtime_export.path),
            runtime_log_path=str(self._active_runtime_log_path),
            report_bundle_path=None,
            result_paths=[],
        )
        self._log_status(f"Runtime config exported to {runtime_export.path}")

        self._log_status(f"Starting backend execution through {profile.display_name}.")
        result = self._powershell_bridge.invoke_profile(
            profile,
            self._config,
            runtime_config_path=runtime_export.path,
            on_output=self._on_bridge_output,
        )

        payload: dict | None = None
        if result.stdout.strip():
            try:
                payload = json.loads(result.stdout)
            except json.JSONDecodeError:
                payload = None

        if result.succeeded:
            self._runtime_state.record_process_result(
                status="run-succeeded",
                exit_code=result.exit_code,
                stdout=result.stdout,
                stderr=result.stderr,
            )
            if isinstance(payload, dict):
                finding_count = payload.get("FindingCount", 0)
                export_count = len(payload.get("Exports", []))
                result_paths = [item.get("Path") for item in payload.get("Exports", []) if item.get("Path")]
                report_path = next((path for path in result_paths if path.lower().endswith((".html", ".md"))), None)
                self._runtime_state.set_runtime_artifacts(
                    runtime_config_path=str(runtime_export.path),
                    runtime_log_path=str(self._active_runtime_log_path) if self._active_runtime_log_path else None,
                    report_bundle_path=report_path,
                    result_paths=result_paths,
                )
                self._log_status(
                    f"Assessment run completed successfully. Findings: {finding_count}. Exports: {export_count}."
                )
                runtime_summary = payload.get("Runtime", {})
                if runtime_summary:
                    auth_summary = runtime_summary.get("Authentication", {})
                    ai_summary = runtime_summary.get("Ai", {})
                    self._log_status(
                        "Backend runtime summary: "
                        f"auth={auth_summary.get('ResolvedAuthFlow', 'unknown')}, "
                        f"ai={'enabled' if ai_summary.get('Enabled') else 'disabled'}."
                    )
            else:
                self._log_status("Assessment run completed successfully.")
        else:
            self._runtime_state.record_process_result(
                status="run-failed",
                exit_code=result.exit_code,
                stdout=result.stdout,
                stderr=result.stderr,
                error_summary=result.stderr or "Backend execution returned a non-zero exit code.",
            )
            self._runtime_state.set_runtime_artifacts(
                runtime_config_path=str(runtime_export.path),
                runtime_log_path=str(self._active_runtime_log_path) if self._active_runtime_log_path else None,
                report_bundle_path=None,
                result_paths=[],
            )
            self._log_status("Assessment run failed.")

        if isinstance(payload, dict) and self._config.open_results_after_run:
            self._open_results_folder()

        self._sync_runtime_context()
        self.status_panel.refresh()

    def _open_report_bundle(self) -> None:
        report_path = self._runtime_state.snapshot().report_bundle_path
        if not report_path:
            self._log_status("No report bundle path is currently available.")
            return

        os.startfile(report_path)
        self._log_status(f"Opened report bundle path: {report_path}")

    def _open_runtime_log(self) -> None:
        runtime_log_path = self._runtime_state.snapshot().runtime_log_path
        if not runtime_log_path:
            self._log_status("No runtime log path is currently available.")
            return

        os.startfile(runtime_log_path)
        self._log_status(f"Opened runtime log path: {runtime_log_path}")

    def _append_runtime_log(self, message: str) -> None:
        if self._active_runtime_log_path is None:
            return

        self._active_runtime_log_path.parent.mkdir(parents=True, exist_ok=True)
        with self._active_runtime_log_path.open("a", encoding="utf-8") as handle:
            handle.write(message + "\n")

    @staticmethod
    def _sanitize_log_message(message: str) -> str:
        lowered = message.lower()
        if "client_secret_path" in lowered:
            return "PowerShell: client secret path reference received."
        return message
