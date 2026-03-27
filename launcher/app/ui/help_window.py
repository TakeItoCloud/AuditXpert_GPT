"""Help window for launcher guidance content."""

from __future__ import annotations

from pathlib import Path

from PySide6.QtWidgets import QMainWindow, QTextBrowser

from app.services.path_service import get_repo_root


class AppAuthHelpWindow(QMainWindow):
    """Window that renders app-auth guidance from maintained docs."""

    def __init__(self) -> None:
        super().__init__()
        self.setWindowTitle("How To Setup App Auth")
        self.resize(900, 700)

        browser = QTextBrowser()
        browser.setOpenExternalLinks(True)
        browser.setMarkdown(self._load_markdown())
        self.setCentralWidget(browser)

    def _load_markdown(self) -> str:
        guide_path = get_repo_root() / "docs" / "launcher" / "app-auth-setup-guide.md"
        return Path(guide_path).read_text(encoding="utf-8")
