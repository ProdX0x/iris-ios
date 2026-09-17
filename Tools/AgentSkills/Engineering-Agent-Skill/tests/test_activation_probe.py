"""activation_probe: does it report its contract, and refuse to overclaim?

Two halves. The first pins the contract a caller depends on — the four fields,
the exit codes, the JSON shape. The second is the one that matters: the probe
must never, by any path, report that the skill is loaded, invoked or verified at
runtime. A probe that grades its own activation is worse than no probe, because
it produces a confident artefact that looks like evidence.
"""

from __future__ import annotations

import hashlib
import json
import shutil
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

import activation_probe
from support import PACKAGE_ROOT, SCRIPTS, GitRepoCase, git

PROBE = SCRIPTS / "activation_probe.py"
FORBIDDEN_CLAIMS = ("SKILL_LOADED", "SKILL_INVOKED", "RUNTIME_VERIFIED")


def run(*args: str, cwd: Path | None = None) -> subprocess.CompletedProcess:
    """Run the probe in a child process with bytecode writing disabled.

    `-B` matters: without it the interpreter's own cache writes would show up in
    the "writes nothing" test and force it to be weakened into a test that
    ignores directories.
    """
    return subprocess.run(
        [sys.executable, "-B", str(PROBE), *args],
        capture_output=True, text=True, check=False,
        cwd=str(cwd) if cwd else None,
    )


def tree_digest(root: Path) -> dict[str, str]:
    """Every file under `root` and its hash — enough to detect any write."""
    return {
        str(p.relative_to(root)): hashlib.sha256(p.read_bytes()).hexdigest()
        for p in sorted(root.rglob("*")) if p.is_file()
    }


class Contract(unittest.TestCase):
    def test_help_exits_zero_and_describes_usage(self):
        completed = run("--help")
        self.assertEqual(completed.returncode, 0)
        self.assertIn("usage", completed.stdout.lower())

    def test_default_output_carries_the_four_required_fields(self):
        completed = run()
        self.assertEqual(completed.returncode, 0, completed.stderr)
        for expected in (
            "SKILL_ID=engineering-expert-skill",
            "PACKAGE_VERSION=1.0.1",
            "PROBE_ID=ENGINEERING-EXPERT-ACTIVATION-PROBE-1",
            "STATUS=AVAILABLE",
        ):
            with self.subTest(field=expected):
                self.assertIn(expected, completed.stdout)

    def test_json_output_is_valid_and_carries_the_same_values(self):
        completed = run("--json")
        self.assertEqual(completed.returncode, 0, completed.stderr)
        data = json.loads(completed.stdout)
        self.assertEqual(data["skill_id"], "engineering-expert-skill")
        self.assertEqual(data["package_version"], "1.0.1")
        self.assertEqual(data["probe_id"], "ENGINEERING-EXPERT-ACTIVATION-PROBE-1")
        self.assertEqual(data["status"], "AVAILABLE")
        self.assertEqual(data["failed_checks"], [])

    def test_constants_match_the_documented_contract(self):
        self.assertEqual(activation_probe.SKILL_ID, "engineering-expert-skill")
        self.assertEqual(activation_probe.PROBE_ID, "ENGINEERING-EXPERT-ACTIVATION-PROBE-1")
        self.assertEqual(activation_probe.PACKAGE_VERSION, "1.0.1")

    def test_probe_lives_in_the_skill_it_names(self):
        self.assertEqual(PROBE.parent.parent.name, activation_probe.SKILL_ID)

    def test_nonce_is_echoed_for_correlation(self):
        completed = run("--nonce", "RUN-ABC-123")
        self.assertIn("NONCE=RUN-ABC-123", completed.stdout)

    def test_a_nonce_that_looks_like_a_credential_is_redacted(self):
        data = json.loads(run("--nonce", "aws_secret_value", "--json").stdout)
        self.assertIn("redacted", data["nonce"])


class RefusesToOverclaim(unittest.TestCase):
    """The reason this tool exists: an available probe is not an active skill."""

    def test_the_three_claims_are_reported_as_not_determined(self):
        data = json.loads(run("--json").stdout)
        for claim in FORBIDDEN_CLAIMS:
            with self.subTest(claim=claim):
                self.assertEqual(data["does_not_establish"][claim], "NOT DETERMINED")

    def test_no_output_path_ever_asserts_one_of_the_three(self):
        for argv in ([], ["--json"], ["--nonce", "x"]):
            text = run(*argv).stdout
            for claim in FORBIDDEN_CLAIMS:
                with self.subTest(argv=argv, claim=claim):
                    self.assertNotIn(f"{claim}=YES", text)
                    self.assertNotIn(f"{claim}: true", text)
                    self.assertNotIn(f'"{claim}": true', text)

    def test_available_is_never_rendered_as_activated_or_verified(self):
        lowered = run().stdout.lower()
        for word in ("activated", "runtime verified", "skill is active", "confirmed active"):
            with self.subTest(word=word):
                self.assertNotIn(word, lowered)

    def test_it_names_the_evidence_it_cannot_supply(self):
        data = json.loads(run("--json").stdout)
        joined = " ".join(data["required_to_establish_those"]).lower()
        self.assertIn("negative control", joined)
        self.assertIn("outside the agent", joined)

    def test_establishes_never_lists_a_check_that_failed(self):
        """A degraded probe must not keep reciting the intact-package claim."""
        with tempfile.TemporaryDirectory() as tmp:
            stray = Path(tmp) / "scripts"
            shutil.copytree(SCRIPTS, stray, ignore=shutil.ignore_patterns("__pycache__"))
            completed = subprocess.run(
                [sys.executable, "-B", str(stray / "activation_probe.py"), "--json"],
                capture_output=True, text=True, check=False)
        data = json.loads(completed.stdout)
        self.assertEqual(completed.returncode, 1)
        self.assertEqual(data["status"], "DEGRADED")
        self.assertIn("package_root_found", data["failed_checks"])
        joined = " ".join(data["establishes"])
        self.assertNotIn("complete", joined)
        self.assertIn("executed by this interpreter", joined)


class VersionCoherence(unittest.TestCase):
    def test_probe_agrees_with_every_manifest_that_carries_a_version(self):
        declared = activation_probe.PACKAGE_VERSION
        for relative in ("plugin.json", ".claude-plugin/plugin.json",
                         ".claude-plugin/marketplace.json", ".codex-plugin/plugin.json",
                         ".cursor-plugin/plugin.json"):
            data = json.loads((PACKAGE_ROOT / relative).read_text(encoding="utf-8"))
            with self.subTest(manifest=relative):
                self.assertEqual(data["version"], declared)
        nested = json.loads((PACKAGE_ROOT / ".claude-plugin/marketplace.json")
                            .read_text(encoding="utf-8"))["plugins"][0]["version"]
        self.assertEqual(nested, declared)

    def test_probe_agrees_with_the_tools_package_version(self):
        from engineering_tools import __version__
        self.assertEqual(__version__, activation_probe.PACKAGE_VERSION)

    def test_a_version_that_drifts_from_the_manifest_is_caught(self):
        """The check must have teeth: build a package whose manifest disagrees."""
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp) / "package"
            skill = root / "skills" / activation_probe.SKILL_ID
            skill.mkdir(parents=True)
            (root / "plugin.json").write_text('{"version": "9.9.9"}\n', encoding="utf-8")
            (skill / "SKILL.md").write_text("---\nname: x\n---\n", encoding="utf-8")
            shutil.copytree(SCRIPTS, skill / "scripts",
                            ignore=shutil.ignore_patterns("__pycache__"))
            completed = subprocess.run(
                [sys.executable, "-B", str(skill / "scripts" / "activation_probe.py"), "--json"],
                capture_output=True, text=True, check=False)
        data = json.loads(completed.stdout)
        self.assertEqual(completed.returncode, 1)
        self.assertEqual(data["status"], "DEGRADED")
        self.assertEqual(data["manifest_version"], "9.9.9")
        self.assertIn("version_agrees_with_manifest", data["failed_checks"])


class ReadOnly(unittest.TestCase):
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
        run("--json")
        run()
        self.assertEqual(tree_digest(PACKAGE_ROOT), before)


class LeavesAGitRepositoryAlone(GitRepoCase):
    def test_running_inside_a_repository_mutates_nothing(self):
        head_before = self.head
        status_before = git(self.repo, "status", "--porcelain")
        files_before = tree_digest(self.repo)

        completed = run("--json", cwd=self.repo)
        self.assertEqual(completed.returncode, 0, completed.stderr)

        self.assertEqual(self.head, head_before)
        self.assertEqual(git(self.repo, "status", "--porcelain"), status_before)
        self.assertEqual(tree_digest(self.repo), files_before)

    def test_it_does_not_mistake_a_foreign_repository_for_its_package(self):
        data = json.loads(run("--json", cwd=self.repo).stdout)
        self.assertEqual(Path(data["package_root"]), PACKAGE_ROOT)


class SurvivesPackaging(unittest.TestCase):
    def test_the_release_builder_requires_the_probe(self):
        """A future version that drops the probe must fail the build, not ship."""
        sys.path.insert(0, str(PACKAGE_ROOT / "scripts"))
        import build_release
        self.assertIn("skills/engineering-expert-skill/scripts/activation_probe.py",
                      build_release.REQUIRED_FILES)

    def test_the_probe_is_gathered_into_the_archive_file_list(self):
        sys.path.insert(0, str(PACKAGE_ROOT / "scripts"))
        import build_release
        gathered = {p.relative_to(PACKAGE_ROOT).as_posix() for p in build_release.gather()}
        self.assertIn("skills/engineering-expert-skill/scripts/activation_probe.py", gathered)


if __name__ == "__main__":
    unittest.main()
