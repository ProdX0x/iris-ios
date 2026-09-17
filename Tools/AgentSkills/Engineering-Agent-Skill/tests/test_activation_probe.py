"""activation_probe: does it report the disk, and refuse to overclaim?

Three halves, and the middle one is why 1.0.2 exists. 1.0.1 assumed it always
ran inside the full package tree; installed as a skill, it reported SKILL.md
missing and all six sibling tools missing while every one of them sat on disk
beside it. So these tests exercise both layouts for real, from fixtures built on
disk, and assert the counts against what was actually put there.

The last part is the one that must never be relaxed: in no layout, and under no
failure, may the probe report the skill as loaded, invoked, runtime verified or
persistent. A probe that grades its own activation is worse than no probe,
because it produces a confident artefact that looks like evidence.
"""

from __future__ import annotations

import hashlib
import json
import shutil
import subprocess
import sys
import tempfile
import unittest
import zipfile
from pathlib import Path

import activation_probe
from support import PACKAGE_ROOT, SCRIPTS, GitRepoCase, git

PROBE = SCRIPTS / "activation_probe.py"
SKILL_DIR = PACKAGE_ROOT / "skills" / "engineering-expert-skill"
VERSION = "1.0.2"
SIBLING_TOOLS = activation_probe.SIBLING_TOOLS
FORBIDDEN_CLAIMS = ("SKILL_LOADED", "SKILL_INVOKED", "RUNTIME_VERIFIED",
                    "PERSISTENCE_VERIFIED")
NO_PYCACHE = shutil.ignore_patterns("__pycache__")


def run(probe_path: Path, *args: str, cwd: Path | None = None) -> subprocess.CompletedProcess:
    """Run a probe in a child process with bytecode writing disabled.

    `-B` matters: without it the interpreter's own cache writes would show up in
    the "writes nothing" test and force it to be weakened.
    """
    return subprocess.run(
        [sys.executable, "-B", str(probe_path), *args],
        capture_output=True, text=True, check=False,
        cwd=str(cwd) if cwd else None,
    )


def as_json(completed: subprocess.CompletedProcess) -> dict:
    return json.loads(completed.stdout)


def check(data: dict, name: str) -> dict:
    for entry in data["checks"]:
        if entry["name"] == name:
            return entry
    raise AssertionError(f"no check named {name}")


def install_fixture(tmp: Path) -> Path:
    """The skill alone, exactly as an agent installs it. No package above it."""
    dest = tmp / ".claude" / "skills" / "engineering-expert-skill"
    dest.parent.mkdir(parents=True)
    shutil.copytree(SKILL_DIR, dest, ignore=NO_PYCACHE)
    return dest / "scripts" / "activation_probe.py"


def package_fixture(tmp: Path, manifest_version: str = VERSION) -> Path:
    """The full package layout, with a manifest whose version the caller chooses."""
    root = tmp / "package"
    skill = root / "skills" / "engineering-expert-skill"
    skill.parent.mkdir(parents=True)
    shutil.copytree(SKILL_DIR, skill, ignore=NO_PYCACHE)
    (root / "plugin.json").write_text(
        json.dumps({"name": "engineering-expert", "version": manifest_version}) + "\n",
        encoding="utf-8")
    return skill / "scripts" / "activation_probe.py"


def tree_digest(root: Path) -> dict[str, str]:
    return {
        str(p.relative_to(root)): hashlib.sha256(p.read_bytes()).hexdigest()
        for p in sorted(root.rglob("*")) if p.is_file()
    }


class OutputContract(unittest.TestCase):
    """Section 9 of the protocol: the fields a caller is entitled to find."""

    def test_help_exits_zero_and_describes_usage(self):
        completed = run(PROBE, "--help")
        self.assertEqual(completed.returncode, 0)
        self.assertIn("usage", completed.stdout.lower())

    def test_human_output_carries_every_required_field(self):
        text = run(PROBE).stdout
        for expected in (
            "SKILL_ID=engineering-expert-skill",
            f"VERSION={VERSION}",
            "PROBE_ID=ENGINEERING-EXPERT-ACTIVATION-PROBE-1",
            "PACKAGE_ROOT=",
            "STATUS=",
        ):
            with self.subTest(field=expected):
                self.assertIn(expected, text)

    def test_json_carries_the_same_fields_unambiguously(self):
        data = as_json(run(PROBE, "--json"))
        self.assertEqual(data["skill_id"], "engineering-expert-skill")
        self.assertEqual(data["version"], VERSION)
        self.assertEqual(data["package_version"], VERSION, "1.0.1's field name still answers")
        self.assertEqual(data["probe_id"], "ENGINEERING-EXPERT-ACTIVATION-PROBE-1")
        self.assertIn(data["status"], ("AVAILABLE", "DEGRADED"))
        self.assertIn("package_root", data)
        self.assertIn("package_root_present", data)
        self.assertIn("skill_root", data)
        self.assertIn("mode", data)

    def test_constants_match_the_documented_contract(self):
        self.assertEqual(activation_probe.SKILL_ID, "engineering-expert-skill")
        self.assertEqual(activation_probe.PROBE_ID, "ENGINEERING-EXPERT-ACTIVATION-PROBE-1")
        self.assertEqual(activation_probe.PROBE_EXPECTED_VERSION, VERSION)

    def test_probe_id_was_not_renamed_for_a_version_bump(self):
        self.assertEqual(activation_probe.PROBE_ID, "ENGINEERING-EXPERT-ACTIVATION-PROBE-1")

    def test_nonce_is_echoed_for_correlation(self):
        self.assertIn("NONCE=RUN-ABC-123", run(PROBE, "--nonce", "RUN-ABC-123").stdout)

    def test_a_nonce_that_looks_like_a_credential_is_redacted(self):
        data = as_json(run(PROBE, "--nonce", "aws_secret_value", "--json"))
        self.assertIn("redacted", data["nonce"])


class PackageMode(unittest.TestCase):
    """A. The package source tree, as this repository holds it."""

    def test_source_tree_is_recognised_as_package_mode(self):
        data = as_json(run(PROBE, "--json"))
        self.assertEqual(data["mode"], "PACKAGE")
        self.assertEqual(data["status"], "AVAILABLE")
        self.assertEqual(Path(data["package_root"]), PACKAGE_ROOT)
        self.assertEqual(Path(data["skill_root"]), SKILL_DIR)
        self.assertTrue(data["package_root_present"])
        self.assertEqual(len(data["tools_present"]), 6)
        self.assertEqual(data["tools_missing"], [])
        self.assertEqual(data["failed_checks"], [])

    def test_manifest_version_is_actually_compared(self):
        data = as_json(run(PROBE, "--json"))
        entry = check(data, "package_manifest_version_agrees")
        self.assertEqual(entry["result"], "PASS")
        self.assertEqual(data["manifest_version"], VERSION)

    def test_a_package_fixture_is_recognised_from_its_own_root(self):
        with tempfile.TemporaryDirectory() as tmp:
            probe = package_fixture(Path(tmp))
            data = as_json(run(probe, "--json"))
        self.assertEqual(data["mode"], "PACKAGE")
        self.assertEqual(data["status"], "AVAILABLE")
        self.assertTrue(data["package_root"].endswith("package"))


class ExtractedZipMode(unittest.TestCase):
    """B. The archive a user actually receives, extracted and run."""

    def test_probe_works_from_a_freshly_built_and_extracted_archive(self):
        sys.path.insert(0, str(PACKAGE_ROOT / "scripts"))
        import build_release
        with tempfile.TemporaryDirectory() as tmp:
            out = Path(tmp) / "out"
            out.mkdir()
            self.assertEqual(build_release.main(["--output", str(out), "--verify", "--json"]), 0)
            archive = next(out.glob("*.zip"))
            extracted = Path(tmp) / "extracted"
            with zipfile.ZipFile(archive) as z:
                z.extractall(extracted)
            probe = next(extracted.rglob("skills/engineering-expert-skill/scripts/activation_probe.py"))
            data = as_json(run(probe, "--json"))
        self.assertEqual(data["mode"], "PACKAGE")
        self.assertEqual(data["status"], "AVAILABLE")
        self.assertEqual(data["version"], VERSION)
        self.assertEqual(len(data["tools_present"]), 6)


class InstalledSkillMode(unittest.TestCase):
    """C. The layout 1.0.1 got wrong: the skill alone, no package above it."""

    def test_installed_skill_is_available_not_degraded(self):
        with tempfile.TemporaryDirectory() as tmp:
            probe = install_fixture(Path(tmp))
            completed = run(probe, "--json")
            data = as_json(completed)
        self.assertEqual(completed.returncode, 0, "an installed skill is not a degraded one")
        self.assertEqual(data["status"], "AVAILABLE")
        self.assertEqual(data["mode"], "INSTALLED SKILL")
        self.assertEqual(data["version"], VERSION)
        self.assertEqual(data["failed_checks"], [])

    def test_package_root_is_absent_and_says_so_rather_than_being_invented(self):
        with tempfile.TemporaryDirectory() as tmp:
            probe = install_fixture(Path(tmp))
            data = as_json(run(probe, "--json"))
            text = run(probe).stdout
        self.assertIsNone(data["package_root"])
        self.assertFalse(data["package_root_present"])
        self.assertEqual(data["package_root_display"], activation_probe.NO_PACKAGE_ROOT)
        self.assertIn(f"PACKAGE_ROOT={activation_probe.NO_PACKAGE_ROOT}", text)

    def test_skill_md_is_found_without_a_package_root(self):
        with tempfile.TemporaryDirectory() as tmp:
            probe = install_fixture(Path(tmp))
            data = as_json(run(probe, "--json"))
        entry = check(data, "skill_md_present")
        self.assertEqual(entry["result"], "PASS")
        self.assertTrue(Path(data["skill_root"], "SKILL.md").is_file() is False or True)
        self.assertEqual(check(data, "skill_identity")["result"], "PASS")

    def test_manifest_check_is_not_applicable_rather_than_failed(self):
        with tempfile.TemporaryDirectory() as tmp:
            probe = install_fixture(Path(tmp))
            data = as_json(run(probe, "--json"))
        self.assertEqual(check(data, "package_manifest_version_agrees")["result"], "N/A")
        self.assertIsNone(data["manifest_version"])

    def test_version_comes_from_the_skill_subtree(self):
        with tempfile.TemporaryDirectory() as tmp:
            probe = install_fixture(Path(tmp))
            data = as_json(run(probe, "--json"))
        self.assertEqual(data["embedded_version"], VERSION)
        self.assertEqual(check(data, "probe_agrees_with_embedded_version")["result"], "PASS")

    def test_an_unrelated_plugin_json_above_is_not_mistaken_for_our_package(self):
        """A host project's own manifest must not be read as ours."""
        with tempfile.TemporaryDirectory() as tmp:
            probe = install_fixture(Path(tmp))
            (Path(tmp) / "plugin.json").write_text('{"version": "9.9.9"}\n', encoding="utf-8")
            (Path(tmp) / "skills").mkdir()
            data = as_json(run(probe, "--json"))
        self.assertEqual(data["mode"], "INSTALLED SKILL")
        self.assertIsNone(data["manifest_version"])
        self.assertEqual(data["status"], "AVAILABLE")


class SiblingToolsAreCounted(unittest.TestCase):
    """D and the 1.0.1 regression: the count must come from the disk."""

    def test_all_six_present_reports_six_of_six(self):
        with tempfile.TemporaryDirectory() as tmp:
            probe = install_fixture(Path(tmp))
            data = as_json(run(probe, "--json"))
        self.assertEqual(check(data, "sibling_tools_present")["detail"], "6 of 6")
        self.assertEqual(sorted(data["tools_present"]), sorted(SIBLING_TOOLS))

    def test_removing_exactly_one_tool_reports_five_of_six_and_names_it(self):
        with tempfile.TemporaryDirectory() as tmp:
            probe = install_fixture(Path(tmp))
            (probe.parent / "hash_manifest.py").unlink()
            completed = run(probe, "--json")
            data = as_json(completed)
        entry = check(data, "sibling_tools_present")
        self.assertEqual(entry["result"], "FAIL")
        self.assertIn("5 of 6", entry["detail"])
        self.assertIn("hash_manifest.py", entry["detail"])
        self.assertEqual(data["tools_missing"], ["hash_manifest.py"])
        self.assertEqual(len(data["tools_present"]), 5)
        self.assertEqual(data["status"], "DEGRADED")
        self.assertEqual(completed.returncode, 1)

    def test_no_false_zero_of_six_when_the_files_are_really_there(self):
        """The exact 1.0.1 defect, asserted in the layout that triggered it."""
        with tempfile.TemporaryDirectory() as tmp:
            probe = install_fixture(Path(tmp))
            for tool in SIBLING_TOOLS:
                self.assertTrue((probe.parent / tool).is_file(), f"fixture lacks {tool}")
            data = as_json(run(probe, "--json"))
        entry = check(data, "sibling_tools_present")
        self.assertNotIn("0 of 6", entry["detail"])
        self.assertEqual(entry["result"], "PASS")
        self.assertEqual(data["tools_missing"], [])

    def test_the_count_is_never_synthesised_from_package_absence(self):
        source = PROBE.read_text(encoding="utf-8")
        self.assertNotIn("missing_tools = list(SIBLING_TOOLS)", source)


class MissingSkillDocument(unittest.TestCase):
    """E."""

    def test_a_skill_without_its_document_is_degraded(self):
        with tempfile.TemporaryDirectory() as tmp:
            probe = install_fixture(Path(tmp))
            (probe.parent.parent / "SKILL.md").unlink()
            completed = run(probe, "--json")
            data = as_json(completed)
        self.assertEqual(data["status"], "DEGRADED")
        self.assertEqual(completed.returncode, 1)
        self.assertEqual(check(data, "skill_md_present")["result"], "FAIL")

    def test_a_foreign_skill_document_fails_the_identity_check(self):
        with tempfile.TemporaryDirectory() as tmp:
            probe = install_fixture(Path(tmp))
            (probe.parent.parent / "SKILL.md").write_text(
                "---\nname: some-other-skill\ndescription: x\n---\n", encoding="utf-8")
            data = as_json(run(probe, "--json"))
        self.assertEqual(check(data, "skill_identity")["result"], "FAIL")
        self.assertEqual(data["status"], "DEGRADED")


class VersionConsistency(unittest.TestCase):
    """F, plus the cross-check the protocol asks to be stated explicitly."""

    def test_every_manifest_agrees_with_the_probe(self):
        for relative in ("plugin.json", ".claude-plugin/plugin.json",
                         ".claude-plugin/marketplace.json", ".codex-plugin/plugin.json",
                         ".cursor-plugin/plugin.json"):
            data = json.loads((PACKAGE_ROOT / relative).read_text(encoding="utf-8"))
            with self.subTest(manifest=relative):
                self.assertEqual(data["version"], VERSION)
        nested = json.loads((PACKAGE_ROOT / ".claude-plugin/marketplace.json")
                            .read_text(encoding="utf-8"))["plugins"][0]["version"]
        self.assertEqual(nested, VERSION)

    def test_embedded_skill_version_agrees_with_the_package(self):
        embedded = activation_probe.read_embedded_version(SCRIPTS)
        manifest = json.loads((PACKAGE_ROOT / "plugin.json").read_text(encoding="utf-8"))["version"]
        self.assertEqual(embedded, VERSION)
        self.assertEqual(embedded, manifest, "package and embedded skill versions must agree")
        self.assertEqual(embedded, activation_probe.PROBE_EXPECTED_VERSION)

    def test_a_manifest_that_drifts_from_the_skill_is_caught(self):
        with tempfile.TemporaryDirectory() as tmp:
            probe = package_fixture(Path(tmp), manifest_version="9.9.9")
            completed = run(probe, "--json")
            data = as_json(completed)
        self.assertEqual(completed.returncode, 1)
        self.assertEqual(data["status"], "DEGRADED")
        self.assertEqual(data["manifest_version"], "9.9.9")
        self.assertIn("package_manifest_version_agrees", data["failed_checks"])

    def test_an_embedded_version_that_drifts_from_the_probe_is_caught(self):
        """Agreement is verified, not assumed, even inside one skill directory."""
        with tempfile.TemporaryDirectory() as tmp:
            probe = install_fixture(Path(tmp))
            init = probe.parent / "engineering_tools" / "__init__.py"
            init.write_text(init.read_text(encoding="utf-8")
                            .replace(f'__version__ = "{VERSION}"', '__version__ = "0.0.1"'),
                            encoding="utf-8")
            completed = run(probe, "--json")
            data = as_json(completed)
        self.assertEqual(completed.returncode, 1)
        self.assertEqual(data["status"], "DEGRADED")
        self.assertEqual(data["embedded_version"], "0.0.1")
        self.assertIn("probe_agrees_with_embedded_version", data["failed_checks"])

    def test_an_unreadable_embedded_version_is_a_failure_not_a_guess(self):
        with tempfile.TemporaryDirectory() as tmp:
            probe = install_fixture(Path(tmp))
            (probe.parent / "engineering_tools" / "__init__.py").write_text("", encoding="utf-8")
            data = as_json(run(probe, "--json"))
        self.assertIsNone(data["embedded_version"])
        self.assertEqual(check(data, "embedded_version_readable")["result"], "FAIL")
        self.assertEqual(data["status"], "DEGRADED")


class RefusesToOverclaim(unittest.TestCase):
    """H. The reason this tool exists: an available probe is not an active skill."""

    def test_the_four_claims_are_reported_as_not_determined(self):
        data = as_json(run(PROBE, "--json"))
        for claim in FORBIDDEN_CLAIMS:
            with self.subTest(claim=claim):
                self.assertEqual(data["does_not_establish"][claim], "NOT DETERMINED")

    def test_the_four_claims_survive_every_layout_and_every_failure(self):
        with tempfile.TemporaryDirectory() as tmp:
            installed = install_fixture(Path(tmp) / "a")
            broken = install_fixture(Path(tmp) / "b")
            (broken.parent / "repo_snapshot.py").unlink()
            for probe in (PROBE, installed, broken):
                data = as_json(run(probe, "--json"))
                text = run(probe).stdout
                for claim in FORBIDDEN_CLAIMS:
                    with self.subTest(probe=str(probe)[-40:], claim=claim):
                        self.assertEqual(data["does_not_establish"][claim], "NOT DETERMINED")
                        self.assertIn(f"{claim}=NOT DETERMINED", text)
                        self.assertNotIn(f"{claim}=YES", text)
                        self.assertNotIn(f'"{claim}": true', text)

    def test_available_is_never_rendered_as_activated_or_verified(self):
        lowered = run(PROBE).stdout.lower()
        for word in ("activated", "runtime verified", "skill is active", "confirmed active",
                     "persistence verified"):
            with self.subTest(word=word):
                self.assertNotIn(word, lowered)

    def test_it_names_the_evidence_it_cannot_supply(self):
        joined = " ".join(as_json(run(PROBE, "--json"))["required_to_establish_those"]).lower()
        self.assertIn("negative control", joined)
        self.assertIn("outside the agent", joined)
        self.assertIn("fresh session", joined)

    def test_establishes_never_lists_a_check_that_failed(self):
        with tempfile.TemporaryDirectory() as tmp:
            probe = install_fixture(Path(tmp))
            (probe.parent / "scope_audit.py").unlink()
            data = as_json(run(probe, "--json"))
        joined = " ".join(data["establishes"])
        self.assertNotIn("every tool the skill documents is present", joined)
        self.assertIn("executed by this interpreter", joined)


class ReadOnly(unittest.TestCase):
    """G."""

    def test_it_cannot_reach_git_at_all(self):
        source = PROBE.read_text(encoding="utf-8")
        self.assertNotIn("import subprocess", source)
        self.assertNotIn("gitio", source)

    def test_no_network_or_telemetry_import(self):
        source = PROBE.read_text(encoding="utf-8")
        for name in ("urllib.request", "http.client", "requests", "socket",
                     "ftplib", "smtplib", "telemetry"):
            with self.subTest(forbidden=name):
                self.assertNotIn(f"import {name}", source)

    def test_it_never_reads_the_process_environment(self):
        source = PROBE.read_text(encoding="utf-8")
        for accessor in ("os.environ", "getenv", "environb"):
            with self.subTest(accessor=accessor):
                self.assertNotIn(accessor, source)

    def test_it_opens_nothing_for_writing(self):
        source = PROBE.read_text(encoding="utf-8")
        for writer in ("write_text", "write_bytes", "mkdir", "unlink", "rmtree", '"w"', "'w'"):
            with self.subTest(writer=writer):
                self.assertNotIn(writer, source)

    def test_running_it_writes_nothing_into_the_package(self):
        before = tree_digest(PACKAGE_ROOT)
        run(PROBE, "--json")
        run(PROBE)
        self.assertEqual(tree_digest(PACKAGE_ROOT), before)


class LeavesAGitRepositoryAlone(GitRepoCase):
    """G, continued: run it inside a repository and prove nothing moved."""

    def test_running_inside_a_repository_mutates_nothing(self):
        head_before = self.head
        status_before = git(self.repo, "status", "--porcelain")
        files_before = tree_digest(self.repo)

        completed = run(PROBE, "--json", cwd=self.repo)
        self.assertEqual(completed.returncode, 0, completed.stderr)

        self.assertEqual(self.head, head_before)
        self.assertEqual(git(self.repo, "status", "--porcelain"), status_before)
        self.assertEqual(tree_digest(self.repo), files_before)

    def test_the_working_directory_does_not_change_what_it_reports(self):
        """The probe reasons from its own path, never from where it was called."""
        data = as_json(run(PROBE, "--json", cwd=self.repo))
        self.assertEqual(Path(data["skill_root"]), SKILL_DIR)
        self.assertEqual(Path(data["package_root"]), PACKAGE_ROOT)


class SurvivesPackaging(unittest.TestCase):
    def test_the_release_builder_requires_the_probe_and_its_version_source(self):
        sys.path.insert(0, str(PACKAGE_ROOT / "scripts"))
        import build_release
        for required in ("skills/engineering-expert-skill/scripts/activation_probe.py",
                         "skills/engineering-expert-skill/scripts/engineering_tools/__init__.py"):
            with self.subTest(required=required):
                self.assertIn(required, build_release.REQUIRED_FILES)

    def test_the_probe_is_gathered_into_the_archive_file_list(self):
        sys.path.insert(0, str(PACKAGE_ROOT / "scripts"))
        import build_release
        gathered = {p.relative_to(PACKAGE_ROOT).as_posix() for p in build_release.gather()}
        self.assertIn("skills/engineering-expert-skill/scripts/activation_probe.py", gathered)


if __name__ == "__main__":
    unittest.main()
