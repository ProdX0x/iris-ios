"""Test helpers: throwaway git repositories, and the import path for the tools.

Every test builds its own repository under a temporary directory. No test ever
touches the repository this package happens to live in.
"""

from __future__ import annotations

import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

PACKAGE_ROOT = Path(__file__).resolve().parent.parent
SCRIPTS = PACKAGE_ROOT / "skills" / "engineering-expert-skill" / "scripts"

if str(SCRIPTS) not in sys.path:
    sys.path.insert(0, str(SCRIPTS))


def git(repo: Path, *args: str) -> str:
    completed = subprocess.run(
        ["git", *args], cwd=str(repo), capture_output=True, text=True, check=True,
    )
    return completed.stdout


class GitRepoCase(unittest.TestCase):
    """A test case with a fresh, isolated git repository."""

    def setUp(self) -> None:
        self._tmp = tempfile.TemporaryDirectory()
        self.repo = Path(self._tmp.name) / "repo"
        self.repo.mkdir()
        git(self.repo, "init", "-q", "-b", "main")
        git(self.repo, "config", "user.email", "test@example.invalid")
        git(self.repo, "config", "user.name", "Test")
        git(self.repo, "config", "commit.gpgsign", "false")
        self.write("README.md", "first\n")
        git(self.repo, "add", "README.md")
        git(self.repo, "commit", "-q", "-m", "initial")
        self.addCleanup(self._tmp.cleanup)

    def write(self, relative: str, content: str) -> Path:
        path = self.repo / relative
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(content, encoding="utf-8")
        return path

    def commit_all(self, message: str) -> str:
        git(self.repo, "add", "-A")
        git(self.repo, "commit", "-q", "-m", message)
        return git(self.repo, "rev-parse", "HEAD").strip()

    @property
    def head(self) -> str:
        return git(self.repo, "rev-parse", "HEAD").strip()
