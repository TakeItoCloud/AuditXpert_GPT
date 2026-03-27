"""Reusable section container for launcher panels."""

from __future__ import annotations

from PySide6.QtWidgets import QFrame, QLabel, QVBoxLayout, QWidget


class SectionCard(QFrame):
    """Styled container with a title, description, and content widget."""

    def __init__(self, title: str, description: str | None = None, parent: QWidget | None = None) -> None:
        super().__init__(parent)
        self.setObjectName("sectionCard")
        self._layout = QVBoxLayout(self)
        self._layout.setContentsMargins(16, 16, 16, 16)
        self._layout.setSpacing(10)

        title_label = QLabel(title)
        title_label.setProperty("role", "section-title")
        self._layout.addWidget(title_label)

        if description:
            description_label = QLabel(description)
            description_label.setWordWrap(True)
            description_label.setProperty("role", "caption")
            self._layout.addWidget(description_label)

    def add_content_widget(self, widget: QWidget) -> None:
        """Attach the primary content widget to the section card."""
        self._layout.addWidget(widget)
