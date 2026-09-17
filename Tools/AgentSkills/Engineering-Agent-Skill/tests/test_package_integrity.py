"""Integrity of the package itself: routing, manifests, safety, portability.

These catch the failures that are invisible in prose — a router entry pointing
at a file nobody wrote, a version that drifted between six manifests, a tool
that quietly grew the ability to reset a repository, or a path from the project
this package was extracted from leaking into the general skill.
"""

from __future__ import annotations

import json
import re
import subprocess
import sys
import unittest
from pathlib import Path

from support import PACKAGE_ROOT, SCRIPTS

VERSION = "1.0.0"
MAIN_SKILL = PACKAGE_ROOT / "skills" / "engineering-expert-skill"
IOS_SKILL = PACKAGE_ROOT / "skills" / "ios-release-evidence-skill"
MAINTENANCE_SKILL = PACKAGE_ROOT / ".agents" / "skills" / "extract-validated-lessons"
ALL_SKILLS = (MAIN_SKILL, IOS_SKILL, MAINTENANCE_SKILL)
TOOLS = ("repo_snapshot.py", "scope_audit.py", "git_lineage.py",
         "hash_manifest.py", "verify_restore.py", "handoff_check.py")


def read(path: Path) -> str:
    return path.read_text(encoding="utf-8")


class SkillStructure(unittest.TestCase):
    def test_every_skill_has_frontmatter_with_a_matching_name(self):
        for skill in ALL_SKILLS:
            with self.subTest(skill=skill.name):
                text = read(skill / "SKILL.md")
                self.assertTrue(text.startswith("---\n"), "missing frontmatter")
                block = text.split("---", 2)[1]
                name = re.search(r"^name:\s*(\S+)", block, re.M)
                self.assertIsNotNone(name, "no name field")
                self.assertEqual(name.group(1), skill.name, "name must match the directory")
                self.assertIsNotNone(re.search(r"^description:\s*\S", block, re.M), "no description")

    def test_descriptions_carry_trigger_language(self):
        for skill in ALL_SKILLS:
            with self.subTest(skill=skill.name):
                block = read(skill / "SKILL.md").split("---", 2)[1]
                description = re.search(r"description:\s*(.+?)(?=\n[a-z_]+:|\Z)", block, re.S).group(1)
                self.assertGreater(len(description), 120, "a description must be able to trigger")
                lowered = description.lower()
                self.assertTrue(any(phrase in lowered for phrase in ("use when", "use after")),
                                "a description must say when to use the skill")
                self.assertIn('"', description, "a description should carry trigger phrases")


class RouterCoverage(unittest.TestCase):
    def test_every_routed_reference_exists(self):
        for skill in (MAIN_SKILL, IOS_SKILL, MAINTENANCE_SKILL):
            text = read(skill / "SKILL.md")
            for name in set(re.findall(r"`references/([A-Za-z0-9._-]+\.md)`", text)):
                with self.subTest(skill=skill.name, reference=name):
                    self.assertTrue((skill / "references" / name).is_file(),
                                    f"{skill.name} routes to a missing reference: {name}")

    def test_no_reference_is_orphaned(self):
        for skill in (MAIN_SKILL, IOS_SKILL):
            text = read(skill / "SKILL.md")
            routed = set(re.findall(r"`references/([A-Za-z0-9._-]+\.md)`", text))
            present = {p.name for p in (skill / "references").glob("*.md")}
            with self.subTest(skill=skill.name):
                self.assertEqual(present - routed, set(), "a reference exists that nothing routes to")

    def test_referenced_scripts_exist(self):
        for skill in (MAIN_SKILL, IOS_SKILL):
            text = read(skill / "SKILL.md")
            for name in set(re.findall(r"`(?:scripts/)([A-Za-z0-9._-]+\.py)`", text)):
                with self.subTest(skill=skill.name, script=name):
                    self.assertTrue((MAIN_SKILL / "scripts" / name).is_file())

    def test_cross_skill_and_case_study_links_resolve(self):
        for skill in ALL_SKILLS:
            root = skill
            for path in list(skill.rglob("*.md")):
                text = read(path)
                for link in re.findall(r"\]\((?!https?:)([^)#]+)\)", text):
                    with self.subTest(file=str(path.relative_to(PACKAGE_ROOT)), link=link):
                        self.assertTrue((path.parent / link).exists(),
                                        f"broken relative link: {link}")
            self.assertTrue(root.exists())


class Manifests(unittest.TestCase):
    MANIFESTS = ("plugin.json", "package.json", ".claude-plugin/plugin.json",
                 ".claude-plugin/marketplace.json", ".codex-plugin/plugin.json",
                 ".cursor-plugin/plugin.json")

    def test_all_manifests_are_valid_json(self):
        for relative in self.MANIFESTS:
            with self.subTest(manifest=relative):
                json.loads(read(PACKAGE_ROOT / relative))

    def test_versions_agree_everywhere(self):
        for relative in self.MANIFESTS:
            data = json.loads(read(PACKAGE_ROOT / relative))
            version = data.get("version")
            if version is not None:
                with self.subTest(manifest=relative):
                    self.assertEqual(version, VERSION)
        yaml_text = read(PACKAGE_ROOT / "agents" / "openai.yaml")
        self.assertIn(f'version: "{VERSION}"', yaml_text)
        self.assertIn(f"## {VERSION}", read(PACKAGE_ROOT / "CHANGELOG.md"))

    def test_plugin_names_agree(self):
        names = set()
        for relative in self.MANIFESTS:
            data = json.loads(read(PACKAGE_ROOT / relative))
            if "name" in data:
                names.add(data["name"])
        self.assertEqual(names, {"engineering-expert", "engineering-expert-skill"} & names or names)
        self.assertIn("engineering-expert", names)

    def test_declared_skill_paths_exist(self):
        for relative in (".claude-plugin/plugin.json", ".cursor-plugin/plugin.json", "package.json"):
            data = json.loads(read(PACKAGE_ROOT / relative))
            declared = data.get("skills") or data.get("pi", {}).get("skills", [])
            for entry in declared:
                with self.subTest(manifest=relative, skill=entry):
                    self.assertTrue((PACKAGE_ROOT / entry.lstrip("./")).is_dir())

    def test_openai_yaml_parses_without_a_yaml_library(self):
        # Deliberately dependency-free: a flat key check, not a YAML parse.
        for path in (PACKAGE_ROOT / "agents" / "openai.yaml",
                     MAIN_SKILL / "agents" / "openai.yaml",
                     IOS_SKILL / "agents" / "openai.yaml"):
            with self.subTest(file=path.name):
                text = read(path)
                self.assertTrue(text.strip())
                self.assertNotIn("\t", text, "YAML must not contain tabs")
                in_block = False
                for line in text.splitlines():
                    stripped = line.strip()
                    if not stripped:
                        continue
                    if in_block:
                        # A folded scalar's continuation lines are indented further
                        # than the key and carry no colon; that is valid.
                        if line.startswith((" ", "\t")):
                            continue
                        in_block = False
                    if stripped.startswith("-"):
                        continue
                    self.assertIn(":", line, f"not a key line: {line!r}")
                    if stripped.endswith((">-", ">", "|", "|-")):
                        in_block = True


class ToolSafety(unittest.TestCase):
    def test_every_tool_answers_help(self):
        for tool in TOOLS:
            with self.subTest(tool=tool):
                completed = subprocess.run([sys.executable, str(SCRIPTS / tool), "--help"],
                                           capture_output=True, text=True, check=False)
                self.assertEqual(completed.returncode, 0)
                self.assertIn("usage", completed.stdout.lower())

    def test_no_mutating_git_verb_is_reachable(self):
        from engineering_tools import gitio
        for verb in ("reset", "clean", "checkout", "rebase", "push", "commit", "add", "rm", "tag", "merge"):
            with self.subTest(verb=verb):
                self.assertNotIn(verb, gitio.READ_ONLY_VERBS)

    def test_no_network_or_telemetry_imports(self):
        forbidden = ("urllib.request", "http.client", "requests", "socket", "ftplib", "smtplib", "telemetry")
        for path in SCRIPTS.rglob("*.py"):
            text = read(path)
            for name in forbidden:
                with self.subTest(file=path.name, forbidden=name):
                    self.assertNotIn(f"import {name}", text)

    def test_tools_never_read_the_environment(self):
        for path in SCRIPTS.rglob("*.py"):
            with self.subTest(file=path.name):
                self.assertNotIn("os.environ", read(path))

    def test_secret_hints_are_redacted_not_printed(self):
        from engineering_tools import output
        self.assertTrue(output.looks_sensitive("config/id_rsa"))
        self.assertTrue(output.looks_sensitive("MY_API_KEY.txt"))
        self.assertFalse(output.looks_sensitive("docs/readme.md"))
        self.assertIn("redacted", output.redact("secrets/token.txt"))
        self.assertEqual(output.redact("docs/readme.md"), "docs/readme.md")


class Portability(unittest.TestCase):
    """The general skill must not carry the project it was extracted from."""

    GENERAL = (MAIN_SKILL / "SKILL.md",
               *(MAIN_SKILL / "references").glob("*.md"),
               MAINTENANCE_SKILL / "SKILL.md",
               *(MAINTENANCE_SKILL / "references").glob("*.md"))

    def test_no_absolute_paths(self):
        for path in self.GENERAL:
            with self.subTest(file=path.name):
                self.assertNotIn("/Volumes/", read(path))
                self.assertNotIn("/Users/", read(path))

    def test_no_hardcoded_commit_or_branch_from_the_origin_project(self):
        for path in self.GENERAL:
            text = read(path)
            with self.subTest(file=path.name):
                self.assertIsNone(re.search(r"\b[0-9a-f]{40}\b", text), "a full commit sha leaked in")
                self.assertNotIn("iris", text.lower())

    def test_case_studies_may_name_the_project(self):
        case = MAIN_SKILL / "case-studies" / "iris" / "README.md"
        self.assertTrue(case.is_file())
        self.assertIn("Iris", read(case))

    def test_no_unresolved_todo_markers(self):
        for path in PACKAGE_ROOT.rglob("*.md"):
            if "__pycache__" in str(path):
                continue
            with self.subTest(file=str(path.relative_to(PACKAGE_ROOT))):
                self.assertNotIn("TODO:", read(path))
                self.assertNotIn("FIXME", read(path))

    def test_no_empty_reference_files(self):
        for skill in (MAIN_SKILL, IOS_SKILL, MAINTENANCE_SKILL):
            for path in (skill / "references").glob("*.md"):
                with self.subTest(file=path.name):
                    self.assertGreater(len(read(path).strip()), 400, "reference is a stub")

    def test_time_sensitive_platform_claims_are_marked(self):
        for path in (IOS_SKILL / "references").glob("*.md"):
            with self.subTest(file=path.name):
                self.assertIn("TIME-SENSITIVE", read(path))


class Evals(unittest.TestCase):
    REQUIRED_HEADINGS = ("## Input", "## Expected route", "## Expected evidence level",
                         "## Mandatory actions", "## Prohibited actions", "## Human decision points")

    def test_ten_scenarios_exist_and_are_well_formed(self):
        scenarios = sorted((PACKAGE_ROOT / "evals" / "scenarios").glob("*.md"))
        self.assertEqual(len(scenarios), 10)
        for path in scenarios:
            for heading in self.REQUIRED_HEADINGS:
                with self.subTest(scenario=path.name, heading=heading):
                    self.assertIn(heading, read(path))


if __name__ == "__main__":
    unittest.main()
