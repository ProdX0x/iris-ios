"""hash_manifest and the hashing library."""

import json
import tempfile
import unittest
from pathlib import Path

import hash_manifest
from engineering_tools import hashing
from engineering_tools.errors import ToolError


class Hashing(unittest.TestCase):
    def setUp(self):
        self._tmp = tempfile.TemporaryDirectory()
        self.root = Path(self._tmp.name)
        (self.root / "a.txt").write_text("alpha\n", encoding="utf-8")
        (self.root / "sub").mkdir()
        (self.root / "sub" / "b.txt").write_text("beta\n", encoding="utf-8")
        self.addCleanup(self._tmp.cleanup)

    def test_digest_is_stable_and_content_dependent(self):
        first = hashing.sha256_file(self.root / "a.txt")
        self.assertEqual(first, hashing.sha256_file(self.root / "a.txt"))
        (self.root / "a.txt").write_text("changed\n", encoding="utf-8")
        self.assertNotEqual(first, hashing.sha256_file(self.root / "a.txt"))

    def test_directory_expands_recursively(self):
        manifest = hashing.build_manifest(self.root, ["."], "all")
        self.assertEqual(manifest["file_count"], 2)
        self.assertIn("a.txt", manifest["files"])
        self.assertIn("sub/b.txt", manifest["files"])

    def test_noise_directories_are_excluded(self):
        (self.root / "__pycache__").mkdir()
        (self.root / "__pycache__" / "x.pyc").write_text("x", encoding="utf-8")
        manifest = hashing.build_manifest(self.root, ["."], "")
        self.assertEqual(manifest["file_count"], 2)

    def test_a_path_outside_the_root_is_refused(self):
        with self.assertRaises(ToolError):
            hashing.build_manifest(self.root, ["../escape"], "")

    def test_a_missing_path_is_an_error(self):
        with self.assertRaises(ToolError):
            hashing.build_manifest(self.root, ["nope.txt"], "")

    def test_cli_writes_a_manifest_that_round_trips(self):
        out = self.root / "m.json"
        code = hash_manifest.main(["a.txt", "--root", str(self.root), "--out", str(out),
                                   "--label", "before", "--json"])
        self.assertEqual(code, 0)
        manifest = json.loads(out.read_text(encoding="utf-8"))
        self.assertEqual(manifest["label"], "before")
        self.assertEqual(manifest["manifest_version"], hashing.MANIFEST_VERSION)
        self.assertIn("a.txt", manifest["files"])

    def test_cli_bad_root_exits_two(self):
        self.assertEqual(hash_manifest.main(["a.txt", "--root", str(self.root / "nope"), "--json"]), 2)


if __name__ == "__main__":
    unittest.main()
