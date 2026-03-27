"""Results actions panel."""

from __future__ import annotations

from PySide6.QtCore import Signal
from PySide6.QtWidgets import QListWidget, QPushButton, QVBoxLayout, QWidget

from app.ui.widgets.section_card import SectionCard


class ResultsPanel(QWidget):
    """Placeholder results actions for later execution phases."""

    status_message = Signal(str)

    def __init__(self, parent: QWidget | None = None) -> None:
        super().__init__(parent)

        card = SectionCard(
            "Results Actions",
            "Keep post-run actions visible and predictable before full process wiring is implemented.",
        )
        content = QWidget()
        layout = QVBoxLayout(content)

        self.outputs = QListWidget()
        self.outputs.addItems(
            [
                "Evidence artifacts",
                "Normalized findings",
                "Governance outputs",
                "Technical and executive reports",
                "Optional AI narrative package",
            ]
        )
        layout.addWidget(self.outputs)

        open_results_button = QPushButton("Open Results Folder")
        open_results_button.clicked.connect(
            lambda: self.status_message.emit("Results-folder opening will be connected during process bridging.")
        )
        export_button = QPushButton("Export Launcher Config Snapshot")
        export_button.clicked.connect(
            lambda: self.status_message.emit("Launcher config export action is reserved for a later phase.")
        )
        layout.addWidget(open_results_button)
        layout.addWidget(export_button)

        card.add_content_widget(content)
        outer = QVBoxLayout(self)
        outer.setContentsMargins(0, 0, 0, 0)
        outer.addWidget(card)
