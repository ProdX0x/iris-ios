#!/usr/bin/env python3
"""Capture the ground truth of a repository before acting on it.

An agent that works from what it remembers works from fiction. This prints the
branch, HEAD, cleanliness and untracked files as facts, and can assert that
they match what a mission expected — so a mismatch stops the work instead of
being discovered halfway through.

Read-only. Runs no mutating git command.
"""

from __future__ import annotations

import argparse
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

from engineering_tools import gitio, output  # noqa: E402
from engineering_tools.errors import CheckFailed, ToolError  # noqa: E402


def snapshot(repo: Path) -> dict:
    entries = gitio.porcelain_status(repo)
    staged = [p for c, p in entries if c[0] not in (" ", "?")]
    unstaged = [p for c, p in entries if len(c) > 1 and c[1] not in (" ", "?")]
    untracked = [p for c, p in entries if c == "??"]
    branch = gitio.current_branch(repo)
    return {
        "root": str(repo),
        "branch": branch or None,
        "detached_head": branch == "",
        "head": gitio.head(repo),
        "clean": not entries,
        "clean_ignoring_untracked": not staged and not unstaged,
        "staged": sorted(staged),
        "unstaged": sorted(unstaged),
        "untracked": sorted(untracked),
        "counts": {
            "staged": len(staged),
            "unstaged": len(unstaged),
            "untracked": len(untracked),
        },
    }


def render(result: dict) -> None:
    output.heading("Repository snapshot")
    output.line("root", result["root"])
    output.line("branch", result["branch"] or "(detached HEAD)")
    output.line("HEAD", result["head"])
    output.line("clean", "yes" if result["clean"] else "no")
    counts = result["counts"]
    output.line("staged / unstaged", f"{counts['staged']} / {counts['unstaged']}")
    output.line("untracked", counts["untracked"])
    for key, title in (("staged", "Staged"), ("unstaged", "Unstaged"), ("untracked", "Untracked")):
        if result[key]:
            output.heading(f"{title} ({len(result[key])})")
            for path in result[key]:
                print(f"    {output.redact(path)}")
    if "expectations" in result:
        output.heading("Expectations")
        for check in result["expectations"]:
            mark = "ok  " if check["ok"] else "FAIL"
            output.line(f"[{mark}] {check['name']}", f"expected {check['expected']}, got {check['actual']}")


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(
        description="Capture branch, HEAD and working-tree state; optionally assert them.",
        epilog="Exit 0 snapshot taken and expectations met, 1 an expectation failed, 2 usage error.",
    )
    parser.add_argument("--repo", type=Path, default=Path.cwd(), help="path inside the repository (default: cwd)")
    parser.add_argument("--expect-branch", help="fail unless the current branch matches")
    parser.add_argument("--expect-head", help="fail unless HEAD matches (full or abbreviated)")
    parser.add_argument("--require-clean", action="store_true",
                        help="fail unless the tree is clean; untracked files alone do not count as dirty")
    parser.add_argument("--json", action="store_true", help="emit JSON instead of a text report")
    args = parser.parse_args(argv)

    try:
        repo = gitio.repo_root(args.repo)
        result = snapshot(repo)
        checks = []
        if args.expect_branch is not None:
            actual = result["branch"] or "(detached)"
            checks.append({"name": "branch", "expected": args.expect_branch,
                           "actual": actual, "ok": actual == args.expect_branch})
        if args.expect_head is not None:
            actual = result["head"]
            ok = actual.startswith(args.expect_head) or args.expect_head.startswith(actual)
            checks.append({"name": "head", "expected": args.expect_head, "actual": actual, "ok": ok})
        if args.require_clean:
            ok = result["clean_ignoring_untracked"]
            checks.append({"name": "clean", "expected": "no staged or unstaged changes",
                           "actual": "clean" if ok else "dirty", "ok": ok})
        if checks:
            result["expectations"] = checks
            result["expectations_met"] = all(c["ok"] for c in checks)
        output.emit(result, args.json, render)
        if checks and not result["expectations_met"]:
            raise CheckFailed("repository state does not match the expected state")
    except CheckFailed as exc:
        print(f"\nSTOP: {exc}", file=sys.stderr)
        return CheckFailed.exit_code
    except ToolError as exc:
        print(f"error: {exc}", file=sys.stderr)
        return ToolError.exit_code
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
