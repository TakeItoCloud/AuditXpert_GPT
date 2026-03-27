"""Run summary and status panel."""

from __future__ import annotations

from PySide6.QtWidgets import QLabel, QPlainTextEdit, QVBoxLayout, QWidget

from app.models.launcher_config import LauncherConfig
from app.services.config_service import validate_launcher_config
from app.services.profile_catalog_service import get_profile_by_id
from app.ui.widgets.section_card import SectionCard


class StatusPanel(QWidget):
    """Summarizes launcher state and stores a lightweight event log."""

    def __init__(self, config: LauncherConfig, parent: QWidget | None = None) -> None:
        super().__init__(parent)
        self._config = config

        card = SectionCard(
            "Run Summary And Status",
            "Track the current launcher state and validation posture before process bridging is added.",
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
        profile = get_profile_by_id(self._config.selected_execution_profile)
        modules = ", ".join(self._config.selected_assessment_modules) or "None selected"
        profile_name = profile.display_name if profile else self._config.selected_execution_profile
        self.summary_label.setText(
            f"Profile: {profile_name}\n"
            f"Modules: {modules}\n"
            f"Auth mode: {self._config.auth.authentication_mode}\n"
            f"AI enabled: {'Yes' if self._config.ai.enabled else 'No'}\n"
            f"Output path: {self._config.output_path or 'Not set'}"
        )

        issues = validate_launcher_config(self._config)
        if issues:
            self.validation_label.setText("Validation: review required. " + " ".join(issues))
        else:
            self.validation_label.setText("Validation: launcher config is internally consistent for the current phase.")
