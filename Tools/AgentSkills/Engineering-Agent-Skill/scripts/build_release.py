#!/usr/bin/env python3
"""Package the skill as a zip, including the dot-directories, and verify it.

The dot-directories are the part that goes missing: `.agents`, `.claude-plugin`,
`.codex-plugin`, `.cursor-plugin`. A shell glob skips them silently and the
archive looks fine until an agent cannot find the plugin manifest. This walks
the tree explicitly and then asserts they are present in the finished archive.

Writes only into --output. Reads only the package directory. No network.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import sys
import zipfile
from datetime import datetime, timezone
from pathlib import Path

PACKAGE_ROOT = Path(__file__).resolve().parent.parent
PACKAGE_NAME = "Engineering-Agent-Skill"

# Directories whose presence in the archive is asserted after building.
REQUIRED_DIRS = (".agents", ".claude-plugin", ".codex-plugin", ".cursor-plugin",
                 "agents", "evals", "scripts", "skills", "tests")
REQUIRED_FILES = (
    "README.md", "INSTALLATION.md", "AGENTS.md", "CONTRIBUTING.md", "CHANGELOG.md",
    "NOTICE.md", "plugin.json", "package.json",
    ".claude-plugin/plugin.json", ".codex-plugin/plugin.json", ".cursor-plugin/plugin.json",
    "agents/openai.yaml",
    "skills/engineering-expert-skill/SKILL.md",
    # The activation probe must survive packaging; a release without it silently
    # loses the only tool that reports what the package can and cannot claim.
    "skills/engineering-expert-skill/scripts/activation_probe.py",
    "skills/ios-release-evidence-skill/SKILL.md",
    ".agents/skills/extract-validated-lessons/SKILL.md",
)

EXCLUDED_NAMES = {".DS_Store", "__pycache__", ".pytest_cache", ".mypy_cache",
                  "RELEASE-MANIFEST.json", ".git"}
EXCLUDED_SUFFIXES = {".pyc", ".pyo", ".zip", ".log", ".tmp", ".swp", ".orig", ".rej"}
# Never package anything whose name suggests a credential.
SECRET_HINTS = ("secret", "token", "credential", "private_key", "id_rsa", ".pem", ".p12", ".env")


def version() -> str:
    return json.loads((PACKAGE_ROOT / "plugin.json").read_text(encoding="utf-8"))["version"]


def included(path: Path) -> bool:
    relative = path.relative_to(PACKAGE_ROOT)
    if any(part in EXCLUDED_NAMES for part in relative.parts):
        return False
    if path.suffix in EXCLUDED_SUFFIXES:
        return False
    lowered = str(relative).lower()
    if any(hint in lowered for hint in SECRET_HINTS):
        print(f"  skipped (looks sensitive): {relative}", file=sys.stderr)
        return False
    return True


def gather() -> list[Path]:
    """Every file to package, dot-directories included, in a stable order."""
    return sorted(p for p in PACKAGE_ROOT.rglob("*") if p.is_file() and included(p))


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def build_manifest(files: list[Path], source_commit: str | None) -> dict:
    skills = sorted(p.parent.name for p in PACKAGE_ROOT.rglob("SKILL.md"))
    tools = sorted(p.name for p in
                   (PACKAGE_ROOT / "skills/engineering-expert-skill/scripts").glob("*.py"))
    return {
        "name": PACKAGE_NAME,
        "version": version(),
        "built_utc": datetime.now(timezone.utc).isoformat(timespec="seconds"),
        "source_commit": source_commit,
        "file_count": len(files),
        "files": {str(p.relative_to(PACKAGE_ROOT)): sha256(p) for p in files},
        "skills": skills,
        "tools": tools,
        "test_status": "unknown — run the test suite and record the result",
    }


def write_zip(target: Path, files: list[Path], manifest: dict) -> None:
    root = f"{PACKAGE_NAME}-v{manifest['version']}"
    with zipfile.ZipFile(target, "w", compression=zipfile.ZIP_DEFLATED) as archive:
        for path in files:
            relative = path.relative_to(PACKAGE_ROOT)
            # A fixed timestamp keeps the archive byte-stable for identical inputs.
            info = zipfile.ZipInfo(f"{root}/{relative.as_posix()}", date_time=(1980, 1, 1, 0, 0, 0))
            info.compress_type = zipfile.ZIP_DEFLATED
            info.external_attr = (0o755 if path.suffix == ".py" else 0o644) << 16
            archive.writestr(info, path.read_bytes())
        info = zipfile.ZipInfo(f"{root}/RELEASE-MANIFEST.json", date_time=(1980, 1, 1, 0, 0, 0))
        info.compress_type = zipfile.ZIP_DEFLATED
        info.external_attr = 0o644 << 16
        archive.writestr(info, json.dumps(manifest, indent=2, sort_keys=True) + "\n")


def verify(target: Path, manifest: dict) -> dict:
    root = f"{PACKAGE_NAME}-v{manifest['version']}"
    with zipfile.ZipFile(target) as archive:
        bad = archive.testzip()
        if bad is not None:
            raise SystemExit(f"archive is corrupt at {bad}")
        names = set(archive.namelist())

    missing_dirs = [d for d in REQUIRED_DIRS
                    if not any(n.startswith(f"{root}/{d}/") for n in names)]
    missing_files = [f for f in REQUIRED_FILES if f"{root}/{f}" not in names]
    dotted = sorted({n.split("/")[1] for n in names
                     if len(n.split("/")) > 1 and n.split("/")[1].startswith(".")})
    return {
        "entries": len(names),
        "expected": manifest["file_count"] + 1,
        "missing_dirs": missing_dirs,
        "missing_files": missing_files,
        "dot_directories": dotted,
        "manifest_present": f"{root}/RELEASE-MANIFEST.json" in names,
        "ok": not missing_dirs and not missing_files and len(names) == manifest["file_count"] + 1,
    }


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description="Build and verify the release archive.")
    parser.add_argument("--output", type=Path, default=Path.cwd(), help="directory to write into")
    parser.add_argument("--source-commit", help="commit the archive was built from, recorded in the manifest")
    parser.add_argument("--verify", action="store_true", help="reopen the archive and check it")
    parser.add_argument("--json", action="store_true", help="emit JSON")
    args = parser.parse_args(argv)

    output = args.output.expanduser().resolve()
    if not output.is_dir():
        print(f"error: not a directory: {output}", file=sys.stderr)
        return 2

    files = gather()
    manifest = build_manifest(files, args.source_commit)
    target = output / f"{PACKAGE_NAME}-v{manifest['version']}.zip"
    write_zip(target, files, manifest)
    (output / "RELEASE-MANIFEST.json").write_text(
        json.dumps(manifest, indent=2, sort_keys=True) + "\n", encoding="utf-8")

    result = {"archive": str(target), "bytes": target.stat().st_size,
              "sha256": sha256(target), "file_count": manifest["file_count"],
              "manifest": str(output / "RELEASE-MANIFEST.json")}
    if args.verify:
        result["verification"] = verify(target, manifest)

    if args.json:
        json.dump(result, sys.stdout, indent=2, sort_keys=True)
        sys.stdout.write("\n")
    else:
        print(f"\n  archive     {result['archive']}")
        print(f"  size        {result['bytes']:,} bytes")
        print(f"  files       {result['file_count']}")
        print(f"  sha256      {result['sha256']}")
        if args.verify:
            check = result["verification"]
            print(f"  entries     {check['entries']} (expected {check['expected']})")
            print(f"  dot dirs    {', '.join(check['dot_directories']) or 'NONE'}")
            print(f"  verified    {'yes' if check['ok'] else 'NO'}")
            for missing in check["missing_dirs"]:
                print(f"    MISSING DIRECTORY  {missing}")
            for missing in check["missing_files"]:
                print(f"    MISSING FILE       {missing}")

    if args.verify and not result["verification"]["ok"]:
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
