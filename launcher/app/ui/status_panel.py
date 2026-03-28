"""Run summary and status panel."""

from __future__ import annotations

from PySide6.QtWidgets import QLabel, QPlainTextEdit, QVBoxLayout, QWidget

from app.models.launcher_config import LauncherConfig
from app.services.profile_catalog_service import get_profile_by_id
from app.services.runtime_state_service import RuntimeStateService
from app.ui.widgets.section_card import SectionCard


class StatusPanel(QWidget):
    """Summarizes launcher state and stores a lightweight event log."""

    def __init__(
        self,
        config: LauncherConfig,
        runtime_state: RuntimeStateService,
        parent: QWidget | None = None,
    ) -> None:
        super().__init__(parent)
        self._config = config
        self._runtime_state = runtime_state

        card = SectionCard(
            "Run Summary And Status",
            "Track launcher state, prerequisite posture, and the latest backend execution outcome.",
        )
        content = QWidget()
        layout = QVBoxLayout(content)

        self.summary_label = QLabel()
        self.summary_label.setWordWrap(True)
        layout.addWidget(self.summary_label)

        self.validation_label = QLabel()
        self.validation_label.setWordWrap(True)
        self.validation_label.setProperty("role", "caption")
        layout.addWidget(self.validation_label)

        self.log_box = QPlainTextEdit()
        self.log_box.setReadOnly(True)
        layout.addWidget(self.log_box)

        card.add_content_widget(content)
        outer = QVBoxLayout(self)
        outer.setContentsMargins(0, 0, 0, 0)
        outer.addWidget(card)
        self.append_log("Launcher UI initialized.")
        self.refresh()

    def append_log(self, message: str) -> None:
        self.log_box.appendPlainText(f"[Info] {message}")

    def refresh(self) -> None:
        state = self._runtime_state.snapshot()
        profile = get_profile_by_id(self._config.selected_execution_profile)
        modules = ", ".join(self._config.selected_assessment_modules) or "None selected"
        profile_name = profile.display_name if profile else self._config.selected_execution_profile
        self.summary_label.setText(
            f"Profile: {profile_name}\n"
            f"Modules: {modules}\n"
            f"Auth mode: {self._config.auth.authentication_mode}\n"
            f"Auth flow: {self._resolved_auth_flow()}\n"
            f"AI enabled: {'Yes' if self._config.ai.enabled else 'No'}\n"
            f"Output path: {self._config.output_path or 'Not set'}\n"
            f"Validation status: {state.validation_status}\n"
            f"Last run status: {state.last_run_status}\n"
            f"Running now: {'Yes' if state.is_running else 'No'}"
        )

        messages: list[str] = []
        if state.validation_issues:
            messages.append("Issues: " + " ".join(state.validation_issues))
        if state.validation_warnings:
            messages.append("Warnings: " + " ".join(state.validation_warnings))
        if state.last_error_summary:
            messages.append("Last error: " + state.last_error_summary)
        if state.runtime_log_path:
            messages.append("Runtime log: " + state.runtime_log_path)

        if not messages:
            messages.append("Validation: waiting for bridge-driven preflight execution.")

        self.validation_label.setText(" ".join(messages))

    def _resolved_auth_flow(self) -> str:
        auth = self._config.auth
        if auth.authentication_mode == "delegated":
            return "interactive-delegated"
        if auth.authentication_mode == "hybrid-local":
            return "integrated-local"
        if auth.client_secret_path or auth.use_secure_secret_entry:
            return "app-client-secret"
        if auth.certificate and (auth.certificate.thumbprint or auth.certificate.subject or auth.certificate.path):
            return "app-certificate"
        return "app-unspecified"
