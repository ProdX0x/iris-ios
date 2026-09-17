#!/usr/bin/env python3
"""Record SHA-256 for the files an experiment is about to touch.

A manifest written before a reversible experiment is what makes the phrase
"I restored it" checkable afterwards. Pair with verify_restore.py.

Read-only with respect to the files it hashes; writes only the manifest, and
only where you point it.
"""

from __future__ import annotations

import argparse
import json
import sys
from datetime import datetime, timezone
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

from engineering_tools import hashing, output  # noqa: E402
from engineering_tools.errors import ToolError  # noqa: E402


def render(result: dict) -> None:
    output.heading("Hash manifest")
    output.line("root", result["root"])
    output.line("label", result["label"] or "(none)")
    output.line("files", result["file_count"])
    if result.get("written_to"):
        output.line("written to", result["written_to"])
    output.heading("Digests")
    for relative, digest in sorted(result["files"].items()):
        print(f"    {digest}  {output.redact(relative)}")


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(
        description="Write a SHA-256 manifest for files or directories.",
        epilog="Exit 0 manifest built, 2 usage error. Use verify_restore.py to check it later.",
    )
    parser.add_argument("targets", nargs="+", metavar="PATH",
                        help="file or directory, relative to --root")
    parser.add_argument("--root", type=Path, default=Path.cwd(),
                        help="paths are resolved against this and must stay inside it (default: cwd)")
    parser.add_argument("--out", type=Path, help="write the manifest here instead of stdout")
    parser.add_argument("--label", default="", help="a note recorded in the manifest, e.g. 'before scheme test'")
    parser.add_argument("--json", action="store_true", help="emit JSON instead of a text report")
    args = parser.parse_args(argv)

    try:
        root = args.root.resolve()
        if not root.is_dir():
            raise ToolError(f"root is not a directory: {root}")
        manifest = hashing.build_manifest(root, args.targets, args.label)
        manifest["created_utc"] = datetime.now(timezone.utc).isoformat(timespec="seconds")
        if args.out:
            args.out.parent.mkdir(parents=True, exist_ok=True)
            args.out.write_text(json.dumps(manifest, indent=2, sort_keys=True) + "\n", encoding="utf-8")
            manifest["written_to"] = str(args.out)
        output.emit(manifest, args.json, render)
    except ToolError as exc:
        print(f"error: {exc}", file=sys.stderr)
        return ToolError.exit_code
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
