#!/usr/bin/env python3
"""Establish the smallest fact about activation that can actually be established.

An agent that announces "the skill is active" has usually proven nothing.
Loading, invocation and runtime behaviour are three separate claims, and none of
them follows from a confident sentence. This tool settles only what is settleable
from inside the package: the probe shipped with this package executed, in this
interpreter, against this tree, and the package around it is coherent.

It refuses to conclude more. SKILL_LOADED, SKILL_INVOKED and RUNTIME_VERIFIED are
reported as NOT DETERMINED, because settling them needs evidence this process
cannot see: an observation made outside the agent, and a task whose correct answer
only a loaded skill would produce. A probe that reported them would be the failure
this package exists to prevent — a claim dressed as a measurement.

Read-only. Runs no git command, opens no connection, reads nothing outside the
package directory, reads no process configuration, and writes nothing anywhere.
"""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

from engineering_tools import output  # noqa: E402
from engineering_tools.errors import CheckFailed, ToolError  # noqa: E402

SKILL_ID = "engineering-expert-skill"
PROBE_ID = "ENGINEERING-EXPERT-ACTIVATION-PROBE-1"
PACKAGE_VERSION = "1.0.1"

STATUS_AVAILABLE = "AVAILABLE"
STATUS_DEGRADED = "DEGRADED"

# The tools that must sit beside this one for the package to be intact.
SIBLING_TOOLS = ("repo_snapshot.py", "scope_audit.py", "git_lineage.py",
                 "hash_manifest.py", "verify_restore.py", "handoff_check.py")

# Claims this probe must never make on its own, whatever it finds.
WITHHELD_CLAIMS = ("SKILL_LOADED", "SKILL_INVOKED", "RUNTIME_VERIFIED")

# How many levels above this file to look for the package root.
SEARCH_DEPTH = 6


def find_package_root(start: Path) -> Path | None:
    """The package directory containing this probe, or None if it stands alone.

    Identified by the two things every copy of the package has: a root manifest
    and a `skills/` directory. Walking up rather than counting parents means a
    re-homed copy is still recognised.
    """
    for candidate in list(start.resolve().parents)[:SEARCH_DEPTH]:
        if (candidate / "plugin.json").is_file() and (candidate / "skills").is_dir():
            return candidate
    return None


def manifest_version(root: Path) -> str | None:
    """The version the package's root manifest declares, or None if unreadable."""
    try:
        data = json.loads((root / "plugin.json").read_text(encoding="utf-8"))
    except (OSError, ValueError):
        return None
    version = data.get("version")
    return version if isinstance(version, str) else None


def probe(nonce: str | None = None) -> dict:
    here = Path(__file__).resolve()
    root = find_package_root(here)
    checks: list[dict] = []

    def record(name: str, ok: bool, detail: str) -> None:
        checks.append({"name": name, "ok": ok, "detail": detail})

    record("package_root_found", root is not None,
           str(root) if root else "no plugin.json + skills/ above this file")

    if root is None:
        skill_md = None
        declared = None
        missing_tools = list(SIBLING_TOOLS)
        record("skill_md_present", False, "package root unknown")
        record("version_agrees_with_manifest", False, "package root unknown")
    else:
        skill_md = root / "skills" / SKILL_ID / "SKILL.md"
        record("skill_md_present", skill_md.is_file(),
               str(skill_md.relative_to(root)) if skill_md.is_file() else "missing")
        declared = manifest_version(root)
        record("version_agrees_with_manifest", declared == PACKAGE_VERSION,
               f"probe {PACKAGE_VERSION}, manifest {declared or 'unreadable'}")
        missing_tools = [t for t in SIBLING_TOOLS if not (here.parent / t).is_file()]

    record("sibling_tools_present", not missing_tools,
           f"{len(SIBLING_TOOLS) - len(missing_tools)} of {len(SIBLING_TOOLS)}"
           + (f"; missing {', '.join(missing_tools)}" if missing_tools else ""))

    ok = all(c["ok"] for c in checks)
    passed = {c["name"] for c in checks if c["ok"]}

    # Only claim what actually held. A degraded probe that still recited the full
    # list would be making the unearned claim this package exists to refuse.
    establishes = ["the probe file shipped with this package was executed by this interpreter"]
    if {"package_root_found", "skill_md_present", "sibling_tools_present"} <= passed:
        establishes.append("the package tree around the probe is present and complete")
    if "version_agrees_with_manifest" in passed:
        establishes.append("the version the probe declares agrees with the package manifest")

    result = {
        "skill_id": SKILL_ID,
        "package_version": PACKAGE_VERSION,
        "probe_id": PROBE_ID,
        "status": STATUS_AVAILABLE if ok else STATUS_DEGRADED,
        "probe_path": str(here),
        "package_root": str(root) if root else None,
        "manifest_version": declared,
        "python": f"{sys.version_info.major}.{sys.version_info.minor}.{sys.version_info.micro}",
        "checks": checks,
        "establishes": establishes,
        "failed_checks": sorted(c["name"] for c in checks if not c["ok"]),
        "does_not_establish": {claim: "NOT DETERMINED" for claim in WITHHELD_CLAIMS},
        "required_to_establish_those": [
            "a system-level observation made outside the agent that this process ran",
            "a distinctive runtime task whose correct answer only a loaded skill produces",
            "a negative control: the same task with the skill absent, answered differently",
        ],
        "nonce": output.redact(nonce) if nonce is not None else None,
    }
    return result


def render(result: dict) -> None:
    output.heading("Activation probe")
    print(f"  SKILL_ID={result['skill_id']}")
    print(f"  PACKAGE_VERSION={result['package_version']}")
    print(f"  PROBE_ID={result['probe_id']}")
    print(f"  STATUS={result['status']}")
    if result["nonce"] is not None:
        print(f"  NONCE={result['nonce']}")

    output.heading("Checks")
    for check in result["checks"]:
        mark = "ok  " if check["ok"] else "FAIL"
        output.line(f"[{mark}] {check['name']}", check["detail"])

    output.heading("What this establishes")
    for item in result["establishes"]:
        print(f"    - {item}")

    output.heading("What this does NOT establish")
    for claim, verdict in sorted(result["does_not_establish"].items()):
        output.line(claim, verdict)
    print("\n  Settling those requires, in addition to this probe:")
    for item in result["required_to_establish_those"]:
        print(f"    - {item}")


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(
        description="Report whether this package's activation probe is executable here, "
                    "and refuse to conclude that the skill is loaded, invoked or runtime verified.",
        epilog="Exit 0 STATUS=AVAILABLE, 1 STATUS=DEGRADED (a check ran and failed), 2 usage error.",
    )
    parser.add_argument(
        "--nonce",
        help="a caller-supplied token echoed into the output. It authenticates nothing — anything "
             "that can print can print a token. Its only use is to correlate this run with an "
             "independently captured system observation. A token that looks like a credential is redacted.",
    )
    parser.add_argument("--json", action="store_true", help="emit JSON instead of a text report")
    args = parser.parse_args(argv)

    try:
        result = probe(args.nonce)
        output.emit(result, args.json, render)
        if result["status"] != STATUS_AVAILABLE:
            failed = ", ".join(c["name"] for c in result["checks"] if not c["ok"])
            raise CheckFailed(f"probe is present but the package around it is not intact: {failed}")
    except CheckFailed as exc:
        print(f"\nSTOP: {exc}", file=sys.stderr)
        return CheckFailed.exit_code
    except ToolError as exc:
        print(f"error: {exc}", file=sys.stderr)
        return ToolError.exit_code
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
