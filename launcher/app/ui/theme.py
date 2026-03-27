"""Theme helpers for the AuditXpert desktop launcher."""

from __future__ import annotations


def build_application_style() -> str:
    """Return a maintainable application stylesheet for the shell UI."""
    return """
    QWidget {
        background-color: #f3f5f8;
        color: #1f2933;
        font-family: "Segoe UI";
        font-size: 10pt;
    }
    QMainWindow {
        background-color: #eef2f7;
    }
    QGroupBox {
        background-color: #ffffff;
        border: 1px solid #d8e0ea;
        border-radius: 10px;
        font-weight: 600;
        margin-top: 14px;
        padding-top: 12px;
    }
    QGroupBox::title {
        color: #274c77;
        left: 12px;
        padding: 0 4px 0 4px;
        subcontrol-origin: margin;
    }
    QLabel[role="caption"] {
        color: #52606d;
        font-size: 9pt;
    }
    QLabel[role="hero"] {
        color: #102a43;
        font-size: 18pt;
        font-weight: 700;
    }
    QPushButton {
        background-color: #274c77;
        border: none;
        border-radius: 8px;
        color: #ffffff;
        min-height: 34px;
        padding: 6px 14px;
    }
    QPushButton:hover {
        background-color: #1f3d61;
    }
    QPushButton:disabled {
        background-color: #9fb3c8;
        color: #f0f4f8;
    }
    QLineEdit, QComboBox, QTextEdit, QListWidget, QPlainTextEdit {
        background-color: #fbfcfe;
        border: 1px solid #c7d2de;
        border-radius: 8px;
        padding: 6px;
    }
    QCheckBox, QRadioButton {
        spacing: 8px;
    }
    QStatusBar {
        background-color: #d9e2ec;
        color: #243b53;
    }
    """
