"""Prerequisite view and launcher-bridge actions."""

from __future__ import annotations

from PySide6.QtCore import Signal
from PySide6.QtWidgets import QLabel, QListWidget, QPushButton, QVBoxLayout, QWidget

from app.ui.widgets.section_card import SectionCard


class PrereqsPanel(QWidget):
    """Prerequisite checklist with launcher bridge actions."""

    status_message = Signal(str)
    validate_requested = Signal()
    install_modules_requested = Signal()

    def __init__(self, parent: QWidget | None = None) -> None:
        super().__init__(parent)

        card = SectionCard(
            "Prerequisites",
            "Validate launcher prerequisites and perform guarded module installation through the PowerShell bridge.",
        )
        content = QWidget()
        layout = QVBoxLayout(content)

        self.summary_label = QLabel("Prerequisite status pending.")
        self.summary_label.setWordWrap(True)
        layout.addWidget(self.summary_label)

        self.checklist = QListWidget()
        self.update_checklist(
            [
                "PowerShell bridge validation pending",
                "Launcher config validation pending",
                "Output and evidence paths pending",
                "Module installation remains deferred in this phase",
            ]
        )
        layout.addWidget(self.checklist)

        self.validate_button = QPushButton("Validate Launcher State")
        self.validate_button.clicked.connect(self.validate_requested.emit)
        self.install_button = QPushButton("Install Missing Modules")
        self.install_button.setEnabled(False)
        self.install_button.clicked.connect(self.install_modules_requested.emit)
        layout.addWidget(self.validate_button)
        layout.addWidget(self.install_button)

        card.add_content_widget(content)
        outer = QVBoxLayout(self)
        outer.setContentsMargins(0, 0, 0, 0)
        outer.addWidget(card)

    def update_checklist(self, items: list[str]) -> None:
        self.checklist.clear()
        self.checklist.addItems(items)

    def set_summary(self, message: str) -> None:
        self.summary_label.setText(message)

    def set_install_enabled(self, enabled: bool) -> None:
        self.install_button.setEnabled(enabled)
