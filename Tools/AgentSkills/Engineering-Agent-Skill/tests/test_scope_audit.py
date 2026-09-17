"""scope_audit: does it catch a change outside the boundary?"""

import unittest

import scope_audit
from engineering_tools import gitio
from support import GitRepoCase


class ScopeMatching(unittest.TestCase):
    def test_glob_and_directory_prefix_both_match(self):
        self.assertTrue(scope_audit.matches("docs/a.md", ["docs/**"]))
        self.assertTrue(scope_audit.matches("docs/a.md", ["docs"]))
        self.assertTrue(scope_audit.matches("docs/deep/a.md", ["docs/"]))
        self.assertTrue(scope_audit.matches("README.md", ["README.md"]))

    def test_near_miss_prefix_does_not_match(self):
        self.assertFalse(scope_audit.matches("docsbook/a.md", ["docs"]))
        self.assertFalse(scope_audit.matches("src/a.py", ["docs/**"]))


class ScopeAudit(GitRepoCase):
    def test_in_scope_change_passes(self):
        self.write("docs/note.md", "x\n")
        result = scope_audit.audit(gitio.repo_root(self.repo), ["docs"], None, True)
        self.assertTrue(result["within_scope"])
        self.assertEqual(result["out_of_scope"], [])

    def test_out_of_scope_change_is_reported(self):
        self.write("src/app.py", "x\n")
        result = scope_audit.audit(gitio.repo_root(self.repo), ["docs"], None, True)
        self.assertFalse(result["within_scope"])
        self.assertIn("src/app.py", result["out_of_scope"])

    def test_untracked_can_be_ignored(self):
        self.write("src/app.py", "x\n")
        result = scope_audit.audit(gitio.repo_root(self.repo), ["docs"], None, False)
        self.assertTrue(result["within_scope"])

    def test_committed_changes_are_audited_with_since(self):
        base = self.head
        self.write("src/app.py", "x\n")
        self.commit_all("out of scope commit")
        result = scope_audit.audit(gitio.repo_root(self.repo), ["docs"], base, True)
        self.assertIn("src/app.py", result["out_of_scope"])

    def test_cli_exit_codes(self):
        self.write("src/app.py", "x\n")
        self.assertEqual(scope_audit.main(["--repo", str(self.repo), "--allow", "docs", "--json"]), 1)
        self.assertEqual(scope_audit.main(["--repo", str(self.repo), "--allow", "src", "--json"]), 0)

    def test_bad_since_exits_two(self):
        code = scope_audit.main(["--repo", str(self.repo), "--allow", "docs", "--since", "nope", "--json"])
        self.assertEqual(code, 2)


if __name__ == "__main__":
    unittest.main()
