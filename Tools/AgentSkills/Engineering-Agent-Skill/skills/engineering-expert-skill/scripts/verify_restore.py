#!/usr/bin/env python3
"""Prove a restoration instead of asserting one.

After a reversible experiment, compare the files against the manifest taken
before it. A clean `git diff` is not enough: it says nothing about a file that
is ignored, untracked, or outside the repository.

Read-only. Modifies nothing.
"""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

from engineering_tools import hashing, output  # noqa: E402
from engineering_tools.errors import CheckFailed, ToolError  # noqa: E402


def load_manifest(path: Path) -> dict:
    try:
        raw = path.read_text(encoding="utf-8")
    except OSError as exc:
        raise ToolError(f"cannot read manifest {path}: {exc.strerror}") from exc
    try:
        manifest = json.loads(raw)
    except json.JSONDecodeError as exc:
        raise ToolError(f"manifest is not valid JSON ({exc.msg} at line {exc.lineno})") from exc
    if not isinstance(manifest, dict):
        raise ToolError("manifest must be a JSON object")
    return manifest


def render(result: dict) -> None:
    output.heading("Restoration check")
    output.line("root", result["root"])
    output.line("manifest", result["manifest"])
    output.line("label", result.get("label") or "(none)")
    output.line("identical", len(result["identical"]))
    output.line("modified", len(result["modified"]))
    output.line("missing", len(result["missing"]))
    output.line("restored", "YES" if result["restored"] else "NO")
    if result["modified"]:
        output.heading("Modified since the manifest")
        for entry in result["modified"]:
            print(f"    {output.redact(entry['path'])}")
            print(f"      expected {entry['expected']}")
            print(f"      actual   {entry['actual']}")
    if result["missing"]:
        output.heading("Missing")
        for relative in result["missing"]:
            print(f"    {output.redact(relative)}")


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(
        description="Compare files on disk against a SHA-256 manifest.",
        epilog="Exit 0 every file matches, 1 something differs or is missing, 2 usage error.",
    )
    parser.add_argument("manifest", type=Path, help="manifest written by hash_manifest.py")
    parser.add_argument("--root", type=Path,
                        help="check against this root instead of the one recorded in the manifest")
    parser.add_argument("--json", action="store_true", help="emit JSON instead of a text report")
    args = parser.parse_args(argv)

    try:
        manifest = load_manifest(args.manifest)
        recorded_root = manifest.get("root")
        root = (args.root or (Path(recorded_root) if recorded_root else None))
        if root is None:
            raise ToolError("manifest has no 'root'; pass --root")
        root = root.resolve()
        if not root.is_dir():
            raise ToolError(f"root is not a directory: {root}")
        comparison = hashing.compare_manifest(root, manifest)
        result = {
            "root": str(root),
            "manifest": str(args.manifest),
            "label": manifest.get("label", ""),
            **comparison,
        }
        output.emit(result, args.json, render)
        if not result["restored"]:
            raise CheckFailed("files do not match the manifest; the state is NOT restored")
    except CheckFailed as exc:
        print(f"\nSTOP: {exc}", file=sys.stderr)
        return CheckFailed.exit_code
    except ToolError as exc:
        print(f"error: {exc}", file=sys.stderr)
        return ToolError.exit_code
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
