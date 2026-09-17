#!/usr/bin/env python3
"""Answer one question: did this work stay inside the boundary it was given?

A mission that may only touch documentation should be able to prove it. This
compares what actually changed against the paths the mission allowed, and
reports anything outside as an out-of-scope change.

Read-only. Runs no mutating git command.
"""

from __future__ import annotations

import argparse
import fnmatch
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

from engineering_tools import gitio, output  # noqa: E402
from engineering_tools.errors import CheckFailed, ToolError  # noqa: E402


def matches(path: str, patterns: list[str]) -> bool:
    for pattern in patterns:
        if fnmatch.fnmatch(path, pattern):
            return True
        # A bare directory prefix allows everything beneath it.
        prefix = pattern.rstrip("/")
        if prefix and (path == prefix or path.startswith(prefix + "/")):
            return True
    return False


def audit(repo: Path, allow: list[str], since: str | None, include_untracked: bool) -> dict:
    if since:
        base = gitio.resolve(repo, since)
        raw = gitio.run(repo, ["diff", "--name-only", f"{base}..HEAD"])
        committed = [p for p in raw.splitlines() if p]
    else:
        base, committed = None, []
    working = gitio.changed_paths(repo, include_untracked=include_untracked)
    changed = sorted(set(committed) | set(working))
    in_scope = [p for p in changed if matches(p, allow)] if allow else []
    out_of_scope = [p for p in changed if not matches(p, allow)] if allow else changed
    return {
        "root": str(repo),
        "since": base,
        "allow": allow,
        "include_untracked": include_untracked,
        "changed": changed,
        "in_scope": in_scope,
        "out_of_scope": out_of_scope,
        "within_scope": not out_of_scope,
    }


def render(result: dict) -> None:
    output.heading("Scope audit")
    output.line("root", result["root"])
    output.line("since", result["since"] or "(working tree only)")
    output.line("allowed patterns", ", ".join(result["allow"]) or "(none given)")
    output.line("changed paths", len(result["changed"]))
    output.line("within scope", "yes" if result["within_scope"] else "NO")
    if result["in_scope"]:
        output.heading(f"In scope ({len(result['in_scope'])})")
        for path in result["in_scope"]:
            print(f"    {output.redact(path)}")
    if result["out_of_scope"]:
        output.heading(f"OUT OF SCOPE ({len(result['out_of_scope'])})")
        for path in result["out_of_scope"]:
            print(f"    {output.redact(path)}")


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(
        description="Report changes that fall outside an allowed set of paths.",
        epilog="Exit 0 everything in scope, 1 something outside it, 2 usage error. "
               "Patterns accept glob syntax; a directory prefix allows everything under it.",
    )
    parser.add_argument("--repo", type=Path, default=Path.cwd(), help="path inside the repository (default: cwd)")
    parser.add_argument("--allow", action="append", default=[], metavar="PATTERN",
                        help="allowed path or glob; repeatable")
    parser.add_argument("--since", metavar="REV",
                        help="also audit commits between REV and HEAD, not only the working tree")
    parser.add_argument("--ignore-untracked", action="store_true",
                        help="do not treat untracked files as changes")
    parser.add_argument("--json", action="store_true", help="emit JSON instead of a text report")
    args = parser.parse_args(argv)

    try:
        repo = gitio.repo_root(args.repo)
        result = audit(repo, args.allow, args.since, not args.ignore_untracked)
        output.emit(result, args.json, render)
        if not result["within_scope"]:
            raise CheckFailed(f"{len(result['out_of_scope'])} path(s) changed outside the allowed scope")
    except CheckFailed as exc:
        print(f"\nSTOP: {exc}", file=sys.stderr)
        return CheckFailed.exit_code
    except ToolError as exc:
        print(f"error: {exc}", file=sys.stderr)
        return ToolError.exit_code
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
