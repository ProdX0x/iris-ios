"""verify_restore: does it actually detect that something was not put back?"""

import json
import tempfile
import unittest
from pathlib import Path

import verify_restore
from engineering_tools import hashing


class VerifyRestore(unittest.TestCase):
    def setUp(self):
        self._tmp = tempfile.TemporaryDirectory()
        self.root = Path(self._tmp.name)
        self.target = self.root / "config.txt"
        self.target.write_text("original\n", encoding="utf-8")
        self.manifest_path = self.root / "manifest.json"
        manifest = hashing.build_manifest(self.root, ["config.txt"], "before")
        self.manifest_path.write_text(json.dumps(manifest), encoding="utf-8")
        self.addCleanup(self._tmp.cleanup)

    def test_untouched_file_verifies(self):
        self.assertEqual(verify_restore.main([str(self.manifest_path), "--json"]), 0)

    def test_modified_file_fails(self):
        self.target.write_text("tampered\n", encoding="utf-8")
        self.assertEqual(verify_restore.main([str(self.manifest_path), "--json"]), 1)

    def test_restoring_the_exact_bytes_verifies_again(self):
        self.target.write_text("tampered\n", encoding="utf-8")
        self.assertEqual(verify_restore.main([str(self.manifest_path), "--json"]), 1)
        self.target.write_text("original\n", encoding="utf-8")
        self.assertEqual(verify_restore.main([str(self.manifest_path), "--json"]), 0)

    def test_missing_file_fails_and_is_named(self):
        self.target.unlink()
        comparison = hashing.compare_manifest(self.root, json.loads(self.manifest_path.read_text()))
        self.assertEqual(comparison["missing"], ["config.txt"])
        self.assertFalse(comparison["restored"])

    def test_corrupt_manifest_exits_two(self):
        self.manifest_path.write_text("{not json", encoding="utf-8")
        self.assertEqual(verify_restore.main([str(self.manifest_path), "--json"]), 2)

    def test_manifest_that_is_not_an_object_exits_two(self):
        self.manifest_path.write_text("[1, 2, 3]", encoding="utf-8")
        self.assertEqual(verify_restore.main([str(self.manifest_path), "--json"]), 2)

    def test_unknown_manifest_version_exits_two(self):
        manifest = json.loads(self.manifest_path.read_text())
        manifest["manifest_version"] = 999
        self.manifest_path.write_text(json.dumps(manifest), encoding="utf-8")
        self.assertEqual(verify_restore.main([str(self.manifest_path), "--json"]), 2)

    def test_absent_manifest_exits_two(self):
        self.assertEqual(verify_restore.main([str(self.root / "nope.json"), "--json"]), 2)


if __name__ == "__main__":
    unittest.main()
