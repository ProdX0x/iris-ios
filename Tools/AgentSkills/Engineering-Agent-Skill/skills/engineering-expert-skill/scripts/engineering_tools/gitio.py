"""Read-only git access.

Every command this module can run is on an allow-list of inspection verbs. A
mutating verb cannot be issued even by accident, because `run` refuses any
argument vector whose first element is not in READ_ONLY_VERBS.
"""

from __future__ import annotations

import subprocess
from pathlib import Path

from .errors import ToolError

# git subcommands this module may invoke. Anything absent is refused before a
# process is spawned: reset, clean, checkout, rebase, push, branch, tag, rm...
READ_ONLY_VERBS = frozenset({
    "rev-parse", "status", "diff", "log", "for-each-ref", "merge-base",
    "rev-list", "show", "cat-file", "ls-files", "branch", "remote",
    "describe", "config",
})

# `git branch` and `git config` can mutate. Only these exact forms are allowed.
GUARDED = {
    "branch": frozenset({"--show-current", "--contains", "--list", "-a", "--all"}),
    "config": frozenset({"--get"}),
}


def run(repo: Path, args: list[str], check: bool = True) -> str:
    """Run one read-only git command in `repo` and return its stdout."""
    if not args:
        raise ToolError("no git arguments given")
    verb = args[0]
    if verb not in READ_ONLY_VERBS:
        raise ToolError(f"refused: '{verb}' is not a read-only git command")
    if verb in GUARDED:
        allowed = GUARDED[verb]
        if not any(a in allowed for a in args[1:]):
            raise ToolError(f"refused: 'git {verb}' is only allowed with {sorted(allowed)}")
    try:
        completed = subprocess.run(
            ["git", *args],
            cwd=str(repo),
            capture_output=True,
            text=True,
            check=False,
        )
    except FileNotFoundError as exc:  # pragma: no cover - git missing
        raise ToolError("git is not installed or not on PATH") from exc
    if check and completed.returncode != 0:
        detail = (completed.stderr or completed.stdout).strip().splitlines()
        first = detail[0] if detail else f"exit {completed.returncode}"
        raise ToolError(f"git {' '.join(args)}: {first}")
    return completed.stdout


def repo_root(start: Path) -> Path:
    """The working-tree root containing `start`."""
    start = start.resolve()
    if not start.exists():
        raise ToolError(f"path does not exist: {start}")
    directory = start if start.is_dir() else start.parent
    out = run(directory, ["rev-parse", "--show-toplevel"]).strip()
    if not out:
        raise ToolError(f"not inside a git repository: {directory}")
    return Path(out)


def head(repo: Path) -> str:
    return run(repo, ["rev-parse", "HEAD"]).strip()


def current_branch(repo: Path) -> str:
    """Branch name, or an empty string when HEAD is detached."""
    return run(repo, ["branch", "--show-current"]).strip()


def porcelain_status(repo: Path) -> list[tuple[str, str]]:
    """(status code, path) for every entry `git status --porcelain` reports.

    `--untracked-files=all` matters: without it git collapses an untracked
    directory to `src/`, and a scope audit that reports a directory instead of
    the file inside it cannot say what actually changed.
    """
    raw = run(repo, ["status", "--porcelain", "-z", "--untracked-files=all"])
    entries: list[tuple[str, str]] = []
    fields = [f for f in raw.split("\0") if f]
    index = 0
    while index < len(fields):
        field = fields[index]
        code, path = field[:2], field[3:]
        # A rename carries its source in the next NUL-separated field.
        if code and code[0] == "R" and index + 1 < len(fields):
            index += 1
        entries.append((code, path))
        index += 1
    return entries


def changed_paths(repo: Path, include_untracked: bool = True) -> list[str]:
    """Every path git considers changed, staged or not."""
    return [
        path for code, path in porcelain_status(repo)
        if include_untracked or code != "??"
    ]


def is_ancestor(repo: Path, maybe_ancestor: str, descendant: str) -> bool:
    completed = subprocess.run(
        ["git", "merge-base", "--is-ancestor", maybe_ancestor, descendant],
        cwd=str(repo), capture_output=True, text=True, check=False,
    )
    if completed.returncode not in (0, 1):
        detail = (completed.stderr or "").strip().splitlines()
        raise ToolError(detail[0] if detail else "merge-base failed")
    return completed.returncode == 0


def resolve(repo: Path, rev: str) -> str:
    """Full object name for a revision, or raise if it does not exist."""
    return run(repo, ["rev-parse", "--verify", f"{rev}^{{commit}}"]).strip()
