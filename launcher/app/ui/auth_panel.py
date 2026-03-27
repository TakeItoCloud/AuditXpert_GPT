"""Authentication settings panel with dynamic auth sub-sections."""

from __future__ import annotations

from PySide6.QtCore import Qt, Signal
from PySide6.QtWidgets import (
    QButtonGroup,
    QCheckBox,
    QFrame,
    QGridLayout,
    QHBoxLayout,
    QLabel,
    QLineEdit,
    QPushButton,
    QRadioButton,
    QVBoxLayout,
    QWidget,
)

from app.models.auth_config import CertificateConfig
from app.models.launcher_config import LauncherConfig
from app.ui.widgets.section_card import SectionCard


class AuthPanel(QWidget):
    """Authentication controls bound to auth intent in launcher config."""

    config_changed = Signal()
    status_message = Signal(str)
    open_help_requested = Signal()

    def __init__(self, config: LauncherConfig, parent: QWidget | None = None) -> None:
        super().__init__(parent)
        self._config = config

        card = SectionCard(
            "Authentication Settings",
            "Capture delegated or app-authentication intent for later PowerShell binding without storing live secrets in the launcher.",
        )
        content = QWidget()
        layout = QVBoxLayout(content)
        layout.setSpacing(10)

        mode_layout = QHBoxLayout()
        mode_layout.addWidget(QLabel("Authentication mode"))
        self.mode_display = QLineEdit()
        self.mode_display.setReadOnly(True)
        mode_layout.addWidget(self.mode_display)
        layout.addLayout(mode_layout)

        radio_row = QHBoxLayout()
        self.delegated_radio = QRadioButton("Interactive delegated login")
        self.app_radio = QRadioButton("App authentication")
        self.hybrid_radio = QRadioButton("Hybrid local collector")
        self.mode_group = QButtonGroup(self)
        for index, button in enumerate([self.delegated_radio, self.app_radio, self.hybrid_radio]):
            self.mode_group.addButton(button, index)
            radio_row.addWidget(button)
        layout.addLayout(radio_row)

        self.app_help_button = QPushButton("How to setup App Auth")
        self.app_help_button.setFlat(True)
        self.app_help_button.clicked.connect(self.open_help_requested.emit)
        layout.addWidget(self.app_help_button, alignment=Qt.AlignmentFlag.AlignLeft)

        identity_grid = QGridLayout()
        identity_grid.addWidget(QLabel("Tenant ID"), 0, 0)
        self.tenant_id_edit = QLineEdit()
        identity_grid.addWidget(self.tenant_id_edit, 0, 1)
        identity_grid.addWidget(QLabel("Client ID"), 1, 0)
        self.client_id_edit = QLineEdit()
        identity_grid.addWidget(self.client_id_edit, 1, 1)
        layout.addLayout(identity_grid)

        self.app_method_frame = QFrame()
        app_method_layout = QVBoxLayout(self.app_method_frame)
        method_row = QHBoxLayout()
        self.client_secret_radio = QRadioButton("Client secret")
        self.certificate_radio = QRadioButton("Certificate")
        self.app_method_group = QButtonGroup(self)
        self.app_method_group.addButton(self.client_secret_radio)
        self.app_method_group.addButton(self.certificate_radio)
        method_row.addWidget(self.client_secret_radio)
        method_row.addWidget(self.certificate_radio)
        app_method_layout.addLayout(method_row)

        self.client_secret_frame = QFrame()
        secret_layout = QGridLayout(self.client_secret_frame)
        secret_layout.addWidget(QLabel("Secret path"), 0, 0)
        self.client_secret_path_edit = QLineEdit()
        secret_layout.addWidget(self.client_secret_path_edit, 0, 1)
        self.secure_secret_checkbox = QCheckBox("Use secure entry at runtime")
        secret_layout.addWidget(self.secure_secret_checkbox, 1, 0, 1, 2)
        app_method_layout.addWidget(self.client_secret_frame)

        self.certificate_frame = QFrame()
        certificate_layout = QGridLayout(self.certificate_frame)
        certificate_layout.addWidget(QLabel("Thumbprint"), 0, 0)
        self.thumbprint_edit = QLineEdit()
        certificate_layout.addWidget(self.thumbprint_edit, 0, 1)
        certificate_layout.addWidget(QLabel("Subject"), 1, 0)
        self.subject_edit = QLineEdit()
        certificate_layout.addWidget(self.subject_edit, 1, 1)
        certificate_layout.addWidget(QLabel("Store"), 2, 0)
        self.store_edit = QLineEdit()
        certificate_layout.addWidget(self.store_edit, 2, 1)
        certificate_layout.addWidget(QLabel("Certificate path"), 3, 0)
        self.certificate_path_edit = QLineEdit()
        certificate_layout.addWidget(self.certificate_path_edit, 3, 1)
        app_method_layout.addWidget(self.certificate_frame)

        layout.addWidget(self.app_method_frame)
        card.add_content_widget(content)

        outer = QVBoxLayout(self)
        outer.setContentsMargins(0, 0, 0, 0)
        outer.addWidget(card)

        self._wire_events()
        self.load_from_config()

    def _wire_events(self) -> None:
        self.delegated_radio.toggled.connect(self._on_auth_mode_changed)
        self.app_radio.toggled.connect(self._on_auth_mode_changed)
        self.hybrid_radio.toggled.connect(self._on_auth_mode_changed)
        self.client_secret_radio.toggled.connect(self._on_app_method_changed)
        self.certificate_radio.toggled.connect(self._on_app_method_changed)
        self.tenant_id_edit.textChanged.connect(self._sync_text_fields)
        self.client_id_edit.textChanged.connect(self._sync_text_fields)
        self.client_secret_path_edit.textChanged.connect(self._sync_text_fields)
        self.secure_secret_checkbox.toggled.connect(self._sync_text_fields)
        self.thumbprint_edit.textChanged.connect(self._sync_text_fields)
        self.subject_edit.textChanged.connect(self._sync_text_fields)
        self.store_edit.textChanged.connect(self._sync_text_fields)
        self.certificate_path_edit.textChanged.connect(self._sync_text_fields)

    def load_from_config(self) -> None:
        auth = self._config.auth
        if auth.authentication_mode == "app":
            self.app_radio.setChecked(True)
        elif auth.authentication_mode == "hybrid-local":
            self.hybrid_radio.setChecked(True)
        else:
            self.delegated_radio.setChecked(True)

        self.tenant_id_edit.setText(auth.tenant_id or "")
        self.client_id_edit.setText(auth.client_id or "")
        self.client_secret_path_edit.setText(auth.client_secret_path or "")
        self.secure_secret_checkbox.setChecked(auth.use_secure_secret_entry)
        certificate = auth.certificate or CertificateConfig()
        self.thumbprint_edit.setText(certificate.thumbprint or "")
        self.subject_edit.setText(certificate.subject or "")
        self.store_edit.setText(certificate.store or "CurrentUser\\My")
        self.certificate_path_edit.setText(certificate.path or "")

        if auth.client_secret_path or auth.use_secure_secret_entry:
            self.client_secret_radio.setChecked(True)
        else:
            self.certificate_radio.setChecked(True)

        self._refresh_visibility()
        self._update_mode_text()

    def _update_mode_text(self) -> None:
        label = {
            "delegated": "Delegated interactive login",
            "app": "Application authentication",
            "hybrid-local": "Hybrid local collector",
        }.get(self._config.auth.authentication_mode, "Delegated interactive login")
        self.mode_display.setText(label)

    def _refresh_visibility(self) -> None:
        app_mode = self._config.auth.authentication_mode == "app"
        self.app_method_frame.setVisible(app_mode)
        self.client_secret_frame.setVisible(app_mode and self.client_secret_radio.isChecked())
        self.certificate_frame.setVisible(app_mode and self.certificate_radio.isChecked())
        self.tenant_id_edit.setEnabled(self._config.auth.authentication_mode != "hybrid-local")
        self.client_id_edit.setEnabled(app_mode or self.delegated_radio.isChecked())

    def _on_auth_mode_changed(self) -> None:
        if self.app_radio.isChecked():
            self._config.auth.authentication_mode = "app"
            self._config.auth.interactive_login = False
        elif self.hybrid_radio.isChecked():
            self._config.auth.authentication_mode = "hybrid-local"
            self._config.auth.interactive_login = False
        else:
            self._config.auth.authentication_mode = "delegated"
            self._config.auth.interactive_login = True

        self._update_mode_text()
        self._refresh_visibility()
        self.status_message.emit(f"Authentication mode set to {self._config.auth.authentication_mode}.")
        self.config_changed.emit()

    def _on_app_method_changed(self) -> None:
        self._refresh_visibility()
        self._sync_text_fields()

    def _sync_text_fields(self) -> None:
        self._config.auth.tenant_id = self.tenant_id_edit.text().strip() or None
        self._config.auth.client_id = self.client_id_edit.text().strip() or None
        self._config.auth.client_secret_path = self.client_secret_path_edit.text().strip() or None
        self._config.auth.use_secure_secret_entry = self.secure_secret_checkbox.isChecked()
        self._config.auth.certificate = CertificateConfig(
            thumbprint=self.thumbprint_edit.text().strip() or None,
            subject=self.subject_edit.text().strip() or None,
            store=self.store_edit.text().strip() or None,
            path=self.certificate_path_edit.text().strip() or None,
        )

        if self.client_secret_radio.isChecked():
            self._config.auth.certificate = CertificateConfig()
        elif self.certificate_radio.isChecked():
            self._config.auth.client_secret_path = None
            self._config.auth.use_secure_secret_entry = False
            self.client_secret_path_edit.blockSignals(True)
            self.client_secret_path_edit.setText("")
            self.client_secret_path_edit.blockSignals(False)
            self.secure_secret_checkbox.blockSignals(True)
            self.secure_secret_checkbox.setChecked(False)
            self.secure_secret_checkbox.blockSignals(False)

        self._refresh_visibility()
        self.config_changed.emit()
