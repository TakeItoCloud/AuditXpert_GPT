"""Results actions panel."""

from __future__ import annotations

from PySide6.QtCore import Signal
from PySide6.QtWidgets import QLabel, QListWidget, QPushButton, QVBoxLayout, QWidget

from app.ui.widgets.section_card import SectionCard


class ResultsPanel(QWidget):
    """Results actions surfaced by the bridge foundation."""

    status_message = Signal(str)
    open_results_requested = Signal()
    open_report_requested = Signal()
    open_runtime_log_requested = Signal()
    export_config_requested = Signal()

    def __init__(self, parent: QWidget | None = None) -> None:
        super().__init__(parent)

        card = SectionCard(
            "Results Actions",
            "Keep post-run actions visible and predictable while launcher execution wiring expands.",
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

        self.current_path_label = QLabel("Results path: not set")
        self.current_path_label.setWordWrap(True)
        layout.addWidget(self.current_path_label)

        self.report_path_label = QLabel("Report bundle path: not available")
        self.report_path_label.setWordWrap(True)
        layout.addWidget(self.report_path_label)

        self.runtime_log_label = QLabel("Runtime log path: not available")
        self.runtime_log_label.setWordWrap(True)
        layout.addWidget(self.runtime_log_label)

        open_results_button = QPushButton("Open Results Folder")
        open_results_button.clicked.connect(self.open_results_requested.emit)
        self.open_report_button = QPushButton("Open Report Bundle")
        self.open_report_button.setEnabled(False)
        self.open_report_button.clicked.connect(self.open_report_requested.emit)
        self.open_runtime_log_button = QPushButton("Open Runtime Log")
        self.open_runtime_log_button.setEnabled(False)
        self.open_runtime_log_button.clicked.connect(self.open_runtime_log_requested.emit)
        export_button = QPushButton("Export Launcher Config Snapshot")
        export_button.clicked.connect(self.export_config_requested.emit)
        layout.addWidget(open_results_button)
        layout.addWidget(self.open_report_button)
        layout.addWidget(self.open_runtime_log_button)
        layout.addWidget(export_button)

        card.add_content_widget(content)
        outer = QVBoxLayout(self)
        outer.setContentsMargins(0, 0, 0, 0)
        outer.addWidget(card)

    def set_results_path(self, path_value: str | None) -> None:
        self.current_path_label.setText(f"Results path: {path_value or 'not set'}")

    def set_report_path(self, path_value: str | None) -> None:
        self.report_path_label.setText(f"Report bundle path: {path_value or 'not available'}")
        self.open_report_button.setEnabled(bool(path_value))

    def set_runtime_log_path(self, path_value: str | None) -> None:
        self.runtime_log_label.setText(f"Runtime log path: {path_value or 'not available'}")
        self.open_runtime_log_button.setEnabled(bool(path_value))

    def set_result_outputs(self, outputs: list[str]) -> None:
        self.outputs.clear()
        if outputs:
            self.outputs.addItems(outputs)
        else:
            self.outputs.addItem("No result artifacts recorded yet")
