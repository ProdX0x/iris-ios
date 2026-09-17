#!/usr/bin/env python3
"""Check whether work is already contained before deciding to merge it.

"Integrate the branches" is a task people believe is necessary. Often the
commits are already ancestors of HEAD and there is nothing to do. This answers
that in one call, and reports merge-base, divergence and whether the lineage
contains merges.

Read-only. Runs no mutating git command.
"""

from __future__ import annotations

import argparse
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

from engineering_tools import gitio, output  # noqa: E402
from engineering_tools.errors import CheckFailed, ToolError  # noqa: E402


def lineage(repo: Path, target: str, candidates: list[str], base: str | None) -> dict:
    target_sha = gitio.resolve(repo, target)
    contained, missing = [], []
    for name in candidates:
        try:
            sha = gitio.resolve(repo, name)
        except ToolError:
            missing.append({"ref": name, "resolved": None, "contained": None,
                            "note": "does not resolve to a commit"})
            continue
        entry = {"ref": name, "resolved": sha,
                 "contained": gitio.is_ancestor(repo, sha, target_sha)}
        (contained if entry["contained"] else missing).append(entry)

    result = {
        "target": target,
        "target_sha": target_sha,
        "contained": contained,
        "not_contained": missing,
        "merge_needed": any(e.get("contained") is False for e in missing),
    }

    if base:
        base_sha = gitio.resolve(repo, base)
        ahead = gitio.run(repo, ["rev-list", "--count", f"{base_sha}..{target_sha}"]).strip()
        behind = gitio.run(repo, ["rev-list", "--count", f"{target_sha}..{base_sha}"]).strip()
        merges = gitio.run(repo, ["rev-list", "--merges", "--count", f"{base_sha}..{target_sha}"]).strip()
        merge_base = gitio.run(repo, ["merge-base", base_sha, target_sha]).strip()
        result["base"] = {
            "ref": base, "sha": base_sha, "merge_base": merge_base,
            "ahead": int(ahead), "behind": int(behind), "merges_in_range": int(merges),
            "linear": int(merges) == 0,
            "base_is_ancestor": gitio.is_ancestor(repo, base_sha, target_sha),
        }
    return result


def render(result: dict) -> None:
    output.heading("Lineage")
    output.line("target", f"{result['target']} = {result['target_sha'][:12]}")
    if "base" in result:
        base = result["base"]
        output.line("base", f"{base['ref']} = {base['sha'][:12]}")
        output.line("merge-base", base["merge_base"][:12])
        output.line("ahead / behind", f"{base['ahead']} / {base['behind']}")
        output.line("merges in range", base["merges_in_range"])
        output.line("linear", "yes" if base["linear"] else "no")
        output.line("base is ancestor", "yes" if base["base_is_ancestor"] else "no")
    if result["contained"]:
        output.heading(f"Already contained in target ({len(result['contained'])})")
        for entry in result["contained"]:
            print(f"    {entry['ref']:<44} {entry['resolved'][:12]}")
    if result["not_contained"]:
        output.heading(f"NOT contained ({len(result['not_contained'])})")
        for entry in result["not_contained"]:
            note = entry.get("note", "would need integrating")
            resolved = entry["resolved"][:12] if entry["resolved"] else "-"
            print(f"    {entry['ref']:<44} {resolved}  {note}")
    if result["contained"] or result["not_contained"]:
        output.heading("Conclusion")
        print("    A merge is needed." if result["merge_needed"]
              else "    Nothing to merge: every ref given is already an ancestor.")


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(
        description="Show whether refs are already contained in a target, plus divergence from a base.",
        epilog="Exit 0 nothing to integrate, 1 with --require-contained when something is missing, 2 usage error.",
    )
    parser.add_argument("--repo", type=Path, default=Path.cwd(), help="path inside the repository (default: cwd)")
    parser.add_argument("--target", default="HEAD", help="revision the work should already be in (default: HEAD)")
    parser.add_argument("--candidate", action="append", default=[], metavar="REV",
                        help="branch, tag or commit to check for containment; repeatable")
    parser.add_argument("--base", metavar="REV", help="compare divergence against this revision")
    parser.add_argument("--require-contained", action="store_true",
                        help="exit non-zero if any candidate is not already contained")
    parser.add_argument("--json", action="store_true", help="emit JSON instead of a text report")
    args = parser.parse_args(argv)

    try:
        repo = gitio.repo_root(args.repo)
        result = lineage(repo, args.target, args.candidate, args.base)
        output.emit(result, args.json, render)
        if args.require_contained and result["merge_needed"]:
            raise CheckFailed("at least one candidate is not contained in the target")
    except CheckFailed as exc:
        print(f"\nSTOP: {exc}", file=sys.stderr)
        return CheckFailed.exit_code
    except ToolError as exc:
        print(f"error: {exc}", file=sys.stderr)
        return ToolError.exit_code
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
