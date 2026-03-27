"""AI settings panel with dependent field visibility."""

from __future__ import annotations

from PySide6.QtCore import Signal
from PySide6.QtWidgets import QCheckBox, QGridLayout, QLabel, QLineEdit, QVBoxLayout, QWidget

from app.models.launcher_config import LauncherConfig
from app.ui.widgets.section_card import SectionCard


class AiPanel(QWidget):
    """AI explainer controls bound to launcher config."""

    config_changed = Signal()
    status_message = Signal(str)

    def __init__(self, config: LauncherConfig, parent: QWidget | None = None) -> None:
        super().__init__(parent)
        self._config = config

        card = SectionCard(
            "AI Explainer",
            "Keep AI optional and clearly separate generated narrative settings from raw evidence collection.",
        )
        content = QWidget()
        layout = QVBoxLayout(content)
        self.enable_checkbox = QCheckBox("Enable AI-assisted narrative")
        layout.addWidget(self.enable_checkbox)

        self.fields_container = QWidget()
        fields_layout = QGridLayout(self.fields_container)
        fields_layout.addWidget(QLabel("Provider"), 0, 0)
        self.provider_edit = QLineEdit()
        fields_layout.addWidget(self.provider_edit, 0, 1)
        fields_layout.addWidget(QLabel("Model"), 1, 0)
        self.model_edit = QLineEdit()
        fields_layout.addWidget(self.model_edit, 1, 1)
        fields_layout.addWidget(QLabel("API key env var"), 2, 0)
        self.key_env_edit = QLineEdit()
        fields_layout.addWidget(self.key_env_edit, 2, 1)
        fields_layout.addWidget(QLabel("External config path"), 3, 0)
        self.external_config_edit = QLineEdit()
        fields_layout.addWidget(self.external_config_edit, 3, 1)
        layout.addWidget(self.fields_container)

        note = QLabel("AI content stays optional, labeled, and traceable to finding IDs.")
        note.setProperty("role", "caption")
        note.setWordWrap(True)
        layout.addWidget(note)

        card.add_content_widget(content)
        outer = QVBoxLayout(self)
        outer.setContentsMargins(0, 0, 0, 0)
        outer.addWidget(card)

        self.enable_checkbox.toggled.connect(self._on_enable_changed)
        for edit in [self.provider_edit, self.model_edit, self.key_env_edit, self.external_config_edit]:
            edit.textChanged.connect(self._sync_fields)

        self.load_from_config()

    def load_from_config(self) -> None:
        ai = self._config.ai
        self.enable_checkbox.setChecked(ai.enabled)
        self.provider_edit.setText(ai.provider or "")
        self.model_edit.setText(ai.model or "")
        self.key_env_edit.setText(ai.api_key_env_var or "")
        self.external_config_edit.setText(ai.external_config_path or "")
        self._refresh_visibility()

    def _refresh_visibility(self) -> None:
        self.fields_container.setVisible(self.enable_checkbox.isChecked())

    def _on_enable_changed(self) -> None:
        self._config.ai.enabled = self.enable_checkbox.isChecked()
        self._refresh_visibility()
        self.status_message.emit(
            "AI explainer enabled." if self._config.ai.enabled else "AI explainer disabled."
        )
        self.config_changed.emit()

    def _sync_fields(self) -> None:
        self._config.ai.provider = self.provider_edit.text().strip() or None
        self._config.ai.model = self.model_edit.text().strip() or None
        self._config.ai.api_key_env_var = self.key_env_edit.text().strip() or None
        self._config.ai.external_config_path = self.external_config_edit.text().strip() or None
        self.config_changed.emit()
