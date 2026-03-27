"""Main window for the AuditXpert desktop launcher."""

from __future__ import annotations

from PySide6.QtCore import Qt
from PySide6.QtWidgets import (
    QFrame,
    QHBoxLayout,
    QLabel,
    QMainWindow,
    QPushButton,
    QScrollArea,
    QSplitter,
    QStatusBar,
    QVBoxLayout,
    QWidget,
)

from app.models.launcher_config import LauncherConfig
from app.services.config_service import apply_launcher_defaults
from app.services.profile_catalog_service import get_profile_catalog
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
        self._help_window: AppAuthHelpWindow | None = None
        self.setWindowTitle("AuditXpert Desktop Launcher")
        self.resize(1440, 900)
        self._build_ui()
        self._wire_panel_events()
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
        status_bar.showMessage("Launcher UI loaded. PowerShell execution wiring is intentionally deferred.")
        self.setStatusBar(status_bar)

    def _build_header(self) -> QWidget:
        frame = QFrame()
        layout = QVBoxLayout(frame)
        title = QLabel("AuditXpert Desktop Launcher")
        title.setProperty("role", "hero")
        subtitle = QLabel(
            "Thin desktop orchestration shell for the PowerShell-first assessment platform. "
            "This phase adds dynamic launcher controls and help guidance while keeping execution logic in PowerShell."
        )
        subtitle.setWordWrap(True)
        subtitle.setProperty("role", "caption")

        actions = QHBoxLayout()
        validate_button = QPushButton("Validate Launcher State")
        validate_button.clicked.connect(lambda: self._log_status("Launcher state validation placeholder invoked."))
        actions.addWidget(validate_button)

        run_button = QPushButton("Run Assessment")
        run_button.setEnabled(False)
        run_button.clicked.connect(lambda: self._log_status("PowerShell execution wiring is not implemented in this phase."))
        actions.addWidget(run_button)
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
        self.status_panel = StatusPanel(self._config)
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
        self.results_panel.status_message.connect(self._log_status)

    def _on_config_changed(self) -> None:
        self.status_panel.refresh()

    def _log_status(self, message: str) -> None:
        self.status_panel.append_log(message)
        self.statusBar().showMessage(message)

    def _open_help_window(self) -> None:
        if self._help_window is None:
            self._help_window = AppAuthHelpWindow()
        self._help_window.show()
        self._help_window.raise_()
        self._help_window.activateWindow()
        self._log_status("Opened app-authentication guidance window.")
