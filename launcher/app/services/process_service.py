"""Process execution helpers for the launcher bridge."""

from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path
import shutil
import subprocess
import threading
from typing import Callable


LogCallback = Callable[[str, str], None]


@dataclass(slots=True)
class ProcessResult:
    """Normalized process result returned to launcher services."""

    executable: str
    arguments: list[str]
    working_directory: str
    exit_code: int
    stdout: str
    stderr: str

    @property
    def succeeded(self) -> bool:
        return self.exit_code == 0


class ProcessService:
    """Thin subprocess wrapper with optional streaming callbacks."""

    def __init__(self, executable: str | None = None) -> None:
        self._executable = executable or shutil.which("pwsh.exe") or "pwsh.exe"

    @property
    def executable(self) -> str:
        return self._executable

    def run(
        self,
        arguments: list[str],
        *,
        working_directory: str | Path | None = None,
        on_output: LogCallback | None = None,
        timeout_seconds: int | None = None,
    ) -> ProcessResult:
        """Run a process, capture output, and emit incremental log callbacks."""

        cwd = str(Path(working_directory).resolve()) if working_directory else str(Path.cwd())
        stdout_lines: list[str] = []
        stderr_lines: list[str] = []

        process = subprocess.Popen(
            [self._executable, *arguments],
            cwd=cwd,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
            encoding="utf-8",
        )

        def _consume(stream: subprocess.PIPE, sink: list[str], stream_name: str) -> None:
            if stream is None:
                return

            for line in iter(stream.readline, ""):
                text = line.rstrip()
                if not text:
                    continue
                sink.append(text)
                if on_output is not None:
                    on_output(stream_name, text)
            stream.close()

        stdout_thread = threading.Thread(
            target=_consume,
            args=(process.stdout, stdout_lines, "stdout"),
            daemon=True,
        )
        stderr_thread = threading.Thread(
            target=_consume,
            args=(process.stderr, stderr_lines, "stderr"),
            daemon=True,
        )
        stdout_thread.start()
        stderr_thread.start()

        try:
            exit_code = process.wait(timeout=timeout_seconds)
        except subprocess.TimeoutExpired:
            process.kill()
            stdout_thread.join()
            stderr_thread.join()
            raise

        stdout_thread.join()
        stderr_thread.join()

        return ProcessResult(
            executable=self._executable,
            arguments=list(arguments),
            working_directory=cwd,
            exit_code=exit_code,
            stdout="\n".join(stdout_lines),
            stderr="\n".join(stderr_lines),
        )
