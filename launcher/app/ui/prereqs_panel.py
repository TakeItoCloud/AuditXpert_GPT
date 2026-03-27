"""Prerequisite view and placeholder actions."""

from __future__ import annotations

from PySide6.QtCore import Signal
from PySide6.QtWidgets import QListWidget, QPushButton, QVBoxLayout, QWidget

from app.ui.widgets.section_card import SectionCard


class PrereqsPanel(QWidget):
    """Prerequisite checklist with safe placeholder actions."""

    status_message = Signal(str)

    def __init__(self, parent: QWidget | None = None) -> None:
        super().__init__(parent)

        card = SectionCard(
            "Prerequisites",
            "Surface readiness actions without executing module installation or PowerShell bridging in this phase.",
        )
        content = QWidget()
        layout = QVBoxLayout(content)

        self.checklist = QListWidget()
        self.checklist.addItems(
            [
                "PowerShell 7 runtime check pending",
                "Module availability check pending",
                "Launcher config validation pending",
                "Output and evidence paths pending",
            ]
        )
        layout.addWidget(self.checklist)

        validate_button = QPushButton("Validate Launcher State")
        validate_button.clicked.connect(
            lambda: self.status_message.emit("Launcher state validation placeholder invoked.")
        )
        install_button = QPushButton("Install Missing Modules")
        install_button.clicked.connect(
            lambda: self.status_message.emit("Module-install action is intentionally deferred to a later phase.")
        )
        layout.addWidget(validate_button)
        layout.addWidget(install_button)

        card.add_content_widget(content)
        outer = QVBoxLayout(self)
        outer.setContentsMargins(0, 0, 0, 0)
        outer.addWidget(card)
