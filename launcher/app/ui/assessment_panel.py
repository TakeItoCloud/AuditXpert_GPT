"""Assessment and execution profile selection panel."""

from __future__ import annotations

from PySide6.QtCore import Signal
from PySide6.QtWidgets import QCheckBox, QComboBox, QGridLayout, QLabel, QVBoxLayout, QWidget

from app.models.launcher_config import LauncherConfig
from app.models.run_profile import RunProfile
from app.services.profile_catalog_service import get_profile_by_id
from app.ui.widgets.section_card import SectionCard


class AssessmentPanel(QWidget):
    """Profile and assessment-module controls bound to launcher config."""

    config_changed = Signal()
    status_message = Signal(str)

    MODULE_OPTIONS = ["Microsoft365", "Azure", "Hybrid", "Governance", "Reporting"]

    def __init__(self, config: LauncherConfig, profiles: list[RunProfile], parent: QWidget | None = None) -> None:
        super().__init__(parent)
        self._config = config
        self._profiles = profiles
        self._module_checks: dict[str, QCheckBox] = {}

        card = SectionCard(
            "Assessment Tool And Scope",
            "Choose the current PowerShell-backed execution profile and the assessment modules to carry forward into the launcher contract.",
        )
        content = QWidget()
        layout = QVBoxLayout(content)
        layout.setSpacing(10)

        profile_layout = QGridLayout()
        profile_layout.addWidget(QLabel("Execution profile"), 0, 0)
        self.profile_combo = QComboBox()
        for profile in profiles:
            self.profile_combo.addItem(profile.display_name, profile.profile_id)
        profile_layout.addWidget(self.profile_combo, 0, 1)

        self.profile_caption = QLabel()
        self.profile_caption.setWordWrap(True)
        self.profile_caption.setProperty("role", "caption")
        profile_layout.addWidget(self.profile_caption, 1, 0, 1, 2)
        layout.addLayout(profile_layout)

        layout.addWidget(QLabel("Selected modules"))
        self.module_container = QWidget()
        modules_layout = QGridLayout(self.module_container)
        modules_layout.setContentsMargins(0, 0, 0, 0)
        modules_layout.setHorizontalSpacing(16)
        row = 0
        col = 0
        for module_name in self.MODULE_OPTIONS:
            checkbox = QCheckBox(module_name)
            checkbox.toggled.connect(self._on_module_toggled)
            self._module_checks[module_name] = checkbox
            modules_layout.addWidget(checkbox, row, col)
            col += 1
            if col > 1:
                row += 1
                col = 0
        layout.addWidget(self.module_container)

        card.add_content_widget(content)
        outer = QVBoxLayout(self)
        outer.setContentsMargins(0, 0, 0, 0)
        outer.addWidget(card)

        self.profile_combo.currentIndexChanged.connect(self._on_profile_changed)
        self.load_from_config()

    def load_from_config(self) -> None:
        profile_index = self.profile_combo.findData(self._config.selected_execution_profile)
        if profile_index >= 0:
            self.profile_combo.setCurrentIndex(profile_index)

        for module_name, checkbox in self._module_checks.items():
            checkbox.blockSignals(True)
            checkbox.setChecked(module_name in self._config.selected_assessment_modules)
            checkbox.blockSignals(False)

        self._refresh_profile_state()

    def _current_profile(self) -> RunProfile | None:
        profile_id = self.profile_combo.currentData()
        return get_profile_by_id(profile_id)

    def _refresh_profile_state(self) -> None:
        profile = self._current_profile()
        if profile is None:
            self.profile_caption.setText("No execution profile selected.")
            self.module_container.setEnabled(False)
            return

        notes = " ".join(profile.notes[:2])
        self.profile_caption.setText(
            f"{profile.description} Current capability: {profile.current_capability}. {notes}"
        )
        self.module_container.setEnabled(profile.supports_assessment_modules)

    def _on_profile_changed(self) -> None:
        profile = self._current_profile()
        if profile is None:
            return

        self._config.selected_execution_profile = profile.profile_id
        if not profile.supports_assessment_modules:
            self._config.selected_assessment_modules = []
            for checkbox in self._module_checks.values():
                checkbox.blockSignals(True)
                checkbox.setChecked(False)
                checkbox.blockSignals(False)
        elif not self._config.selected_assessment_modules and profile.default_assessment_modules:
            self._config.selected_assessment_modules = list(profile.default_assessment_modules)
            for module_name in profile.default_assessment_modules:
                checkbox = self._module_checks.get(module_name)
                if checkbox:
                    checkbox.blockSignals(True)
                    checkbox.setChecked(True)
                    checkbox.blockSignals(False)

        self._refresh_profile_state()
        self.status_message.emit(f"Execution profile set to {profile.display_name}.")
        self.config_changed.emit()

    def _on_module_toggled(self) -> None:
        self._config.selected_assessment_modules = [
            name for name, checkbox in self._module_checks.items() if checkbox.isChecked()
        ]
        self.status_message.emit("Assessment module selections updated.")
        self.config_changed.emit()
