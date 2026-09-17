#!/usr/bin/env python3
"""Check that a handoff document can actually be resumed from.

A handoff is useless if it omits the branch, the commit, or what the next
session must not do. This looks for the fields that make a document
self-sufficient, and reports which are missing.

It checks presence, not truth: only a human or another tool can confirm that
the HEAD written down is the HEAD that exists.

Read-only. Modifies nothing.
"""

from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

from engineering_tools import output  # noqa: E402
from engineering_tools.errors import CheckFailed, ToolError  # noqa: E402

# field -> (human name, patterns that count as present)
REQUIRED = {
    "branch": ("branch name", (r"\bbranch\b", r"\bbranche\b")),
    "commit": ("HEAD or commit", (r"\bHEAD\b", r"\bcommit\b")),
    "repo_state": ("working-tree state", (r"\bclean\b", r"\bdirty\b", r"\buntracked\b",
                                          r"\bpropre\b", r"\bnon suivis?\b", r"git status")),
    "next_action": ("next action", (r"next action", r"first action", r"prochaine action",
                                    r"première action", r"premiere action")),
    "open_problems": ("open problems", (r"\bopen\b", r"\bunresolved\b", r"\bpending\b", r"\bouvert",
                                        r"\bnon r[ée]solu", r"\bNOT PROVEN\b")),
    "prohibitions": ("prohibitions", (r"\bdo not\b", r"\bmust not\b", r"\bforbidden\b", r"\bnever\b",
                                      r"\bne pas\b", r"\binterdit", r"\bne jamais\b")),
}
RECOMMENDED = {
    "restore_points": ("restore points", (r"\btag\b", r"\brestore\b", r"\brollback\b",
                                          r"\brestauration\b", r"\bpoints? de restauration\b")),
    "frozen": ("frozen subsystems", (r"\bfrozen\b", r"\bgel[ée]s?\b", r"\bfreeze\b", r"\bfig[ée]s?\b")),
    "evidence_levels": ("evidence levels", (r"\bPROVEN\b", r"\bNOT PROVEN\b", r"\bSTRONGLY SUPPORTED\b",
                                            r"\bNOT DETERMINED\b", r"\bMEASURED\b")),
    "environment": ("environment or hardware", (r"\bdevice\b", r"\bhardware\b", r"\bsimulator\b",
                                                r"\bappareil\b", r"\bmat[ée]riel\b", r"\benvironment\b")),
    "how_to_build": ("how to build or test", (r"\bbuild\b", r"\btest\b", r"\bcompil")),
}
SHA_RE = re.compile(r"\b[0-9a-f]{7,40}\b")


def check(text: str) -> dict:
    lowered = text.lower()

    def present(patterns: tuple[str, ...]) -> bool:
        return any(re.search(p, lowered, re.IGNORECASE) for p in patterns)

    required = {k: {"name": n, "present": present(p)} for k, (n, p) in REQUIRED.items()}
    recommended = {k: {"name": n, "present": present(p)} for k, (n, p) in RECOMMENDED.items()}
    missing = sorted(k for k, v in required.items() if not v["present"])
    return {
        "required": required,
        "recommended": recommended,
        "missing_required": missing,
        "missing_recommended": sorted(k for k, v in recommended.items() if not v["present"]),
        "contains_commit_sha": bool(SHA_RE.search(text)),
        "complete": not missing,
        "characters": len(text),
    }


def render(result: dict) -> None:
    output.heading("Handoff check")
    output.line("document", result["document"])
    output.line("characters", result["characters"])
    output.line("contains a commit sha", "yes" if result["contains_commit_sha"] else "no")
    output.line("required fields", "all present" if result["complete"]
                else f"{len(result['missing_required'])} missing")
    output.heading("Required")
    for key, field in sorted(result["required"].items()):
        print(f"    [{'ok  ' if field['present'] else 'MISS'}] {field['name']}")
    output.heading("Recommended")
    for key, field in sorted(result["recommended"].items()):
        print(f"    [{'ok  ' if field['present'] else '--  '}] {field['name']}")
    print("\n  Presence is not correctness: verify the branch and HEAD against the repository itself.")


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(
        description="Check a handoff document for the fields a resuming session needs.",
        epilog="Exit 0 all required fields present, 1 something required is missing, 2 usage error.",
    )
    parser.add_argument("document", type=Path, help="the handoff file (Markdown or plain text)")
    parser.add_argument("--json", action="store_true", help="emit JSON instead of a text report")
    args = parser.parse_args(argv)

    try:
        if not args.document.is_file():
            raise ToolError(f"not a file: {args.document}")
        try:
            text = args.document.read_text(encoding="utf-8")
        except (OSError, UnicodeDecodeError) as exc:
            raise ToolError(f"cannot read {args.document}: {exc}") from exc
        result = {"document": str(args.document), **check(text)}
        output.emit(result, args.json, render)
        if not result["complete"]:
            raise CheckFailed("handoff is missing required fields: " + ", ".join(result["missing_required"]))
    except CheckFailed as exc:
        print(f"\nSTOP: {exc}", file=sys.stderr)
        return CheckFailed.exit_code
    except ToolError as exc:
        print(f"error: {exc}", file=sys.stderr)
        return ToolError.exit_code
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
