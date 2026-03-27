"""AuditXpert desktop launcher entry point."""

from __future__ import annotations

import sys
from pathlib import Path


def _bootstrap_path() -> None:
    repo_root = Path(__file__).resolve().parent
    if str(repo_root) not in sys.path:
        sys.path.insert(0, str(repo_root))


def main() -> int:
    _bootstrap_path()

    from PySide6.QtWidgets import QApplication

    from app.ui.main_window import AuditXpertMainWindow
    from app.ui.theme import build_application_style

    app = QApplication(sys.argv)
    app.setApplicationName("AuditXpert Launcher")
    app.setOrganizationName("AuditXpert")
    app.setStyleSheet(build_application_style())

    window = AuditXpertMainWindow()
    window.show()
    return app.exec()


if __name__ == "__main__":
    raise SystemExit(main())
