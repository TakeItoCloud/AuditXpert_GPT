"""Path and preference controls for launcher state."""

from __future__ import annotations

from PySide6.QtCore import Signal
from PySide6.QtWidgets import QCheckBox, QGridLayout, QLabel, QLineEdit, QPushButton, QVBoxLayout, QWidget

from app.models.launcher_config import LauncherConfig
from app.services.path_service import get_repo_root
from app.ui.widgets.section_card import SectionCard


class PathsPanel(QWidget):
    """Displays repo and output-path settings with placeholder browse actions."""

    config_changed = Signal()
    status_message = Signal(str)

    def __init__(self, config: LauncherConfig, parent: QWidget | None = None) -> None:
        super().__init__(parent)
        self._config = config

        card = SectionCard(
            "Paths And Preferences",
            "Set result destinations and operator preferences without invoking PowerShell yet.",
        )
        content = QWidget()
        layout = QGridLayout(content)
        layout.addWidget(QLabel("Repository root"), 0, 0)
        self.repo_root_edit = QLineEdit(str(get_repo_root()))
        self.repo_root_edit.setReadOnly(True)
        layout.addWidget(self.repo_root_edit, 0, 1)

        layout.addWidget(QLabel("Output path"), 1, 0)
        self.output_path_edit = QLineEdit()
        layout.addWidget(self.output_path_edit, 1, 1)

        layout.addWidget(QLabel("Evidence path"), 2, 0)
        self.evidence_path_edit = QLineEdit()
        layout.addWidget(self.evidence_path_edit, 2, 1)

        self.install_missing_modules_checkbox = QCheckBox("Prompt to install missing modules")
        self.open_results_checkbox = QCheckBox("Open results after run")
        layout.addWidget(self.install_missing_modules_checkbox, 3, 0, 1, 2)
        layout.addWidget(self.open_results_checkbox, 4, 0, 1, 2)

        self.placeholder_button = QPushButton("Browse Paths")
        self.placeholder_button.clicked.connect(
            lambda: self.status_message.emit("Path browsing will be wired in the process-bridging phase.")
        )
        layout.addWidget(self.placeholder_button, 5, 0, 1, 2)

        card.add_content_widget(content)
        outer = QVBoxLayout(self)
        outer.setContentsMargins(0, 0, 0, 0)
        outer.addWidget(card)

        self.output_path_edit.textChanged.connect(self._sync_fields)
        self.evidence_path_edit.textChanged.connect(self._sync_fields)
        self.install_missing_modules_checkbox.toggled.connect(self._sync_fields)
        self.open_results_checkbox.toggled.connect(self._sync_fields)
        self.load_from_config()

    def load_from_config(self) -> None:
        self.output_path_edit.setText(self._config.output_path or "")
        self.evidence_path_edit.setText(self._config.evidence_path or "")
        self.install_missing_modules_checkbox.setChecked(self._config.install_missing_modules)
        self.open_results_checkbox.setChecked(self._config.open_results_after_run)

    def _sync_fields(self) -> None:
        self._config.output_path = self.output_path_edit.text().strip() or None
        self._config.evidence_path = self.evidence_path_edit.text().strip() or None
        self._config.install_missing_modules = self.install_missing_modules_checkbox.isChecked()
        self._config.open_results_after_run = self.open_results_checkbox.isChecked()
        self.config_changed.emit()
