#!/usr/bin/env python3
"""Establish the smallest fact about activation that can actually be established.

An agent that announces "the skill is active" has usually proven nothing.
Loading, invocation, runtime behaviour and persistence are four separate claims,
and none of them follows from a confident sentence. This tool settles only what
is settleable from inside the skill: this probe executed, in this interpreter,
against a skill directory that is really on disk, and what it found there.

It refuses to conclude more. SKILL_LOADED, SKILL_INVOKED, RUNTIME_VERIFIED and
PERSISTENCE_VERIFIED are reported as NOT DETERMINED, because settling them needs
evidence this process cannot see: an observation made outside the agent, a task
whose correct answer only a loaded skill produces, and a fresh session. A probe
that reported them would be the failure this package exists to prevent — a claim
dressed as a measurement.

Two layouts are supported, and the probe detects which one it is in rather than
assuming:

  PACKAGE MODE          the full package tree, as shipped or extracted
                        <package>/plugin.json
                        <package>/skills/engineering-expert-skill/SKILL.md

  INSTALLED SKILL MODE  the skill alone, as an agent installs it
                        <somewhere>/.claude/skills/engineering-expert-skill/SKILL.md

In INSTALLED SKILL MODE there is no package manifest above the skill, and that
is correct, not degraded. Version 1.0.1 assumed PACKAGE MODE always held: it
looked for SKILL.md only underneath a package root, and when no package root was
found it reported all six sibling tools missing without ever testing the disk.
Both were wrong, and the second printed a falsehood. Every check below now reads
the filesystem it is describing.

Read-only. Runs no git command, opens no connection, reads nothing outside the
skill directory, reads no process configuration, and changes nothing anywhere.
"""

from __future__ import annotations

import argparse
import json
import re
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

from engineering_tools import output  # noqa: E402
from engineering_tools.errors import CheckFailed, ToolError  # noqa: E402

SKILL_ID = "engineering-expert-skill"
PROBE_ID = "ENGINEERING-EXPERT-ACTIVATION-PROBE-1"

# What this probe was built to be part of. Cross-checked against the version the
# skill carries on disk, and — in PACKAGE MODE only — against the package
# manifest. Agreement is verified, never assumed.
PROBE_EXPECTED_VERSION = "1.0.2"

MODE_PACKAGE = "PACKAGE"
MODE_INSTALLED_SKILL = "INSTALLED SKILL"

STATUS_AVAILABLE = "AVAILABLE"
STATUS_DEGRADED = "DEGRADED"

PASS, FAIL, NOT_APPLICABLE = "PASS", "FAIL", "N/A"

# How PACKAGE_ROOT is rendered when there is legitimately no package above us.
NO_PACKAGE_ROOT = "NOT PRESENT — INSTALLED SKILL MODE"

# The tools that must sit beside this one for the skill to be usable. Each is
# tested individually, on disk, in both modes.
SIBLING_TOOLS = ("repo_snapshot.py", "scope_audit.py", "git_lineage.py",
                 "hash_manifest.py", "verify_restore.py", "handoff_check.py")

# The skill's own version source, inside the skill subtree so that an installed
# skill can verify itself without reaching for a package manifest that is not
# there. One source, read from disk, not a second copy to keep in step by hand.
EMBEDDED_VERSION_FILE = Path("engineering_tools") / "__init__.py"
EMBEDDED_VERSION_PATTERN = re.compile(r'^__version__\s*=\s*["\']([^"\']+)["\']', re.M)

SKILL_NAME_PATTERN = re.compile(r"^name:\s*(\S+)", re.M)

# Claims this probe must never make on its own, whatever it finds.
WITHHELD_CLAIMS = ("SKILL_LOADED", "SKILL_INVOKED", "RUNTIME_VERIFIED",
                   "PERSISTENCE_VERIFIED")

# How many levels above the probe to search. Enough for both layouts.
SEARCH_DEPTH = 8


def find_skill_root(script_dir: Path) -> Path | None:
    """The skill directory this probe belongs to: the nearest one holding SKILL.md.

    Resolved upward from the probe itself, so it is found in either layout and
    never inferred from a package structure that may not exist.
    """
    for candidate in list(script_dir.resolve().parents)[:SEARCH_DEPTH]:
        if (candidate / "SKILL.md").is_file():
            return candidate
    return None


def find_package_root(skill_root: Path) -> Path | None:
    """The package directory wrapping this skill, or None in installed-skill mode.

    A candidate counts only if its `skills/<SKILL_ID>` really is this skill
    directory. Without that, any unrelated project with a plugin.json above the
    install path would be mistaken for our package, and its version compared
    against ours.
    """
    for candidate in list(skill_root.resolve().parents)[:SEARCH_DEPTH]:
        if not (candidate / "plugin.json").is_file():
            continue
        declared = candidate / "skills" / SKILL_ID
        try:
            if declared.is_dir() and declared.resolve() == skill_root.resolve():
                return candidate
        except OSError:  # pragma: no cover - unresolvable path
            continue
    return None


def read_embedded_version(script_dir: Path) -> str | None:
    """The version this copy of the skill carries, read from its own subtree."""
    try:
        text = (script_dir / EMBEDDED_VERSION_FILE).read_text(encoding="utf-8")
    except OSError:
        return None
    found = EMBEDDED_VERSION_PATTERN.search(text)
    return found.group(1) if found else None


def read_manifest_version(package_root: Path) -> str | None:
    """The version the package manifest declares, or None if unreadable."""
    try:
        data = json.loads((package_root / "plugin.json").read_text(encoding="utf-8"))
    except (OSError, ValueError):
        return None
    version = data.get("version")
    return version if isinstance(version, str) else None


def read_skill_name(skill_root: Path) -> str | None:
    """The name declared in SKILL.md's frontmatter."""
    try:
        text = (skill_root / "SKILL.md").read_text(encoding="utf-8")
    except OSError:
        return None
    if not text.startswith("---"):
        return None
    block = text.split("---", 2)[1] if text.count("---") >= 2 else ""
    found = SKILL_NAME_PATTERN.search(block)
    return found.group(1) if found else None


def probe(nonce: str | None = None) -> dict:
    here = Path(__file__).resolve()
    script_dir = here.parent
    skill_root = find_skill_root(script_dir)
    package_root = find_package_root(skill_root) if skill_root else None
    mode = MODE_PACKAGE if package_root else MODE_INSTALLED_SKILL

    checks: list[dict] = []

    def record(name: str, result: str, detail: str) -> None:
        checks.append({"name": name, "result": result, "detail": detail})

    record("skill_root_found", PASS if skill_root else FAIL,
           str(skill_root) if skill_root else "no directory holding SKILL.md above this file")

    if skill_root is None:
        record("skill_md_present", FAIL, "skill root unknown")
        record("skill_identity", FAIL, "skill root unknown")
    else:
        skill_md = skill_root / "SKILL.md"
        record("skill_md_present", PASS if skill_md.is_file() else FAIL, str(skill_md))
        declared_name = read_skill_name(skill_root)
        record("skill_identity", PASS if declared_name == SKILL_ID else FAIL,
               f"SKILL.md declares {declared_name or 'no name'}, expected {SKILL_ID}")

    # Always a real per-file test, in either mode. Never synthesised from an
    # assumption about the surrounding structure: that was the 1.0.1 defect.
    present_tools = [t for t in SIBLING_TOOLS if (script_dir / t).is_file()]
    missing_tools = [t for t in SIBLING_TOOLS if t not in present_tools]
    record("sibling_tools_present", PASS if not missing_tools else FAIL,
           f"{len(present_tools)} of {len(SIBLING_TOOLS)}"
           + (f"; missing {', '.join(missing_tools)}" if missing_tools else ""))

    embedded = read_embedded_version(script_dir)
    record("embedded_version_readable", PASS if embedded else FAIL,
           f"{script_dir.name}/{EMBEDDED_VERSION_FILE.as_posix()}"
           + (f" declares {embedded}" if embedded else " is missing or declares no version"))
    record("probe_agrees_with_embedded_version",
           PASS if embedded == PROBE_EXPECTED_VERSION else FAIL,
           f"probe expects {PROBE_EXPECTED_VERSION}, skill carries {embedded or 'nothing'}")

    manifest = read_manifest_version(package_root) if package_root else None
    if package_root is None:
        record("package_manifest_version_agrees", NOT_APPLICABLE,
               "no package manifest above an installed skill; this is expected, not a fault")
    else:
        record("package_manifest_version_agrees",
               PASS if manifest == embedded else FAIL,
               f"manifest {manifest or 'unreadable'}, skill carries {embedded or 'nothing'}")

    failed = [c["name"] for c in checks if c["result"] == FAIL]
    passed = {c["name"] for c in checks if c["result"] == PASS}

    # Only claim what actually held. A degraded probe that still recited the full
    # list would be making the unearned claim this package exists to refuse.
    establishes = ["the probe file shipped with this skill was executed by this interpreter"]
    if {"skill_root_found", "skill_md_present", "skill_identity"} <= passed:
        establishes.append(f"this probe sits inside a real {SKILL_ID} directory on disk")
    if "sibling_tools_present" in passed:
        establishes.append("every tool the skill documents is present beside the probe")
    if "probe_agrees_with_embedded_version" in passed:
        establishes.append("the version the probe expects is the version the skill carries")
    if "package_manifest_version_agrees" in passed:
        establishes.append("the package manifest declares that same version")

    return {
        "skill_id": SKILL_ID,
        "version": PROBE_EXPECTED_VERSION,
        # Kept under its 1.0.1 name as well, for callers that already read it.
        "package_version": PROBE_EXPECTED_VERSION,
        "probe_id": PROBE_ID,
        "mode": mode,
        "status": STATUS_AVAILABLE if not failed else STATUS_DEGRADED,
        "probe_path": str(here),
        "skill_root": str(skill_root) if skill_root else None,
        "package_root": str(package_root) if package_root else None,
        "package_root_present": package_root is not None,
        "package_root_display": str(package_root) if package_root else NO_PACKAGE_ROOT,
        "embedded_version": embedded,
        "manifest_version": manifest,
        "tools_present": present_tools,
        "tools_missing": missing_tools,
        "python": f"{sys.version_info.major}.{sys.version_info.minor}.{sys.version_info.micro}",
        "checks": checks,
        "failed_checks": sorted(failed),
        "establishes": establishes,
        "does_not_establish": {claim: "NOT DETERMINED" for claim in WITHHELD_CLAIMS},
        "required_to_establish_those": [
            "a system-level observation made outside the agent that the skill was detected",
            "a distinctive runtime task whose correct answer only a loaded skill produces",
            "a negative control: the same task with the skill absent, answered differently",
            "a fresh session, for persistence, since none of the above carries over on its own",
        ],
        "nonce": output.redact(nonce) if nonce is not None else None,
    }


def render(result: dict) -> None:
    output.heading("Activation probe")
    print(f"  SKILL_ID={result['skill_id']}")
    print(f"  VERSION={result['version']}")
    print(f"  PACKAGE_VERSION={result['package_version']}")
    print(f"  PROBE_ID={result['probe_id']}")
    print(f"  MODE={result['mode']}")
    print(f"  SKILL_ROOT={result['skill_root'] or 'NOT FOUND'}")
    print(f"  PACKAGE_ROOT={result['package_root_display']}")
    print(f"  STATUS={result['status']}")
    if result["nonce"] is not None:
        print(f"  NONCE={result['nonce']}")

    output.heading("Checks")
    for check in result["checks"]:
        mark = {"PASS": "ok  ", "FAIL": "FAIL", "N/A": "n/a "}[check["result"]]
        output.line(f"[{mark}] {check['name']}", check["detail"])

    output.heading("What this establishes")
    for item in result["establishes"]:
        print(f"    - {item}")

    output.heading("What this does NOT establish")
    for claim in WITHHELD_CLAIMS:
        print(f"  {claim}=NOT DETERMINED")
    print("\n  Settling those requires, in addition to this probe:")
    for item in result["required_to_establish_those"]:
        print(f"    - {item}")


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(
        description="Report whether this skill's activation probe is executable here, in either "
                    "a full package or an installed-skill layout, and refuse to conclude that the "
                    "skill is loaded, invoked, runtime verified or persistent.",
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
            raise CheckFailed("the skill around this probe is not intact: "
                              + ", ".join(result["failed_checks"]))
    except CheckFailed as exc:
        print(f"\nSTOP: {exc}", file=sys.stderr)
        return CheckFailed.exit_code
    except ToolError as exc:
        print(f"error: {exc}", file=sys.stderr)
        return ToolError.exit_code
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
