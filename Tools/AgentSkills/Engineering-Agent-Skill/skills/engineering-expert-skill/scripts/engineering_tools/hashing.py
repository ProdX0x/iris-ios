"""SHA-256 manifests over a set of files.

A manifest answers one question later: is this file byte-for-byte what it was?
That is the difference between claiming a restoration and proving one.
"""

from __future__ import annotations

import hashlib
from pathlib import Path

from .errors import ToolError

MANIFEST_VERSION = 1
_CHUNK = 1024 * 1024

# Never hashed, never listed: build noise and editor droppings.
DEFAULT_EXCLUDES = (
    ".git", "__pycache__", ".DS_Store", ".pytest_cache", ".mypy_cache",
    "node_modules", ".venv", "venv",
)


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    try:
        with path.open("rb") as handle:
            for chunk in iter(lambda: handle.read(_CHUNK), b""):
                digest.update(chunk)
    except OSError as exc:
        raise ToolError(f"cannot read {path}: {exc.strerror}") from exc
    return digest.hexdigest()


def _excluded(relative: Path, excludes: tuple[str, ...]) -> bool:
    return any(part in excludes for part in relative.parts)


def collect(root: Path, targets: list[str], excludes: tuple[str, ...] = DEFAULT_EXCLUDES) -> list[Path]:
    """Expand `targets` (files or directories, relative to `root`) into files."""
    root = root.resolve()
    found: list[Path] = []
    for target in targets:
        candidate = (root / target).resolve()
        if root not in candidate.parents and candidate != root:
            raise ToolError(f"refused: {target} is outside {root}")
        if candidate.is_file():
            found.append(candidate)
        elif candidate.is_dir():
            for item in sorted(candidate.rglob("*")):
                if item.is_file() and not _excluded(item.relative_to(root), excludes):
                    found.append(item)
        else:
            raise ToolError(f"path does not exist: {target}")
    unique = sorted({f for f in found})
    return unique


def build_manifest(root: Path, targets: list[str], label: str = "") -> dict:
    files = collect(root, targets)
    return {
        "manifest_version": MANIFEST_VERSION,
        "label": label,
        "root": str(root.resolve()),
        "file_count": len(files),
        "files": {
            str(path.relative_to(root.resolve())): sha256_file(path)
            for path in files
        },
    }


def compare_manifest(root: Path, manifest: dict) -> dict:
    """Compare the manifest against what is on disk now."""
    if manifest.get("manifest_version") != MANIFEST_VERSION:
        raise ToolError(
            f"unsupported manifest version {manifest.get('manifest_version')!r}; "
            f"this tool writes and reads version {MANIFEST_VERSION}"
        )
    recorded = manifest.get("files")
    if not isinstance(recorded, dict):
        raise ToolError("manifest has no 'files' object")

    identical: list[str] = []
    modified: list[dict] = []
    missing: list[str] = []
    for relative, expected in sorted(recorded.items()):
        path = root / relative
        if not path.is_file():
            missing.append(relative)
            continue
        actual = sha256_file(path)
        if actual == expected:
            identical.append(relative)
        else:
            modified.append({"path": relative, "expected": expected, "actual": actual})
    return {
        "identical": identical,
        "modified": modified,
        "missing": missing,
        "restored": not modified and not missing,
    }
