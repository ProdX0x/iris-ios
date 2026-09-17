"""repo_snapshot: does it report the truth, and refuse a mismatch?"""

import unittest

import repo_snapshot
from engineering_tools import gitio
from support import GitRepoCase, git


class SnapshotState(GitRepoCase):
    def test_clean_repository_reports_clean(self):
        result = repo_snapshot.snapshot(gitio.repo_root(self.repo))
        self.assertTrue(result["clean"])
        self.assertEqual(result["branch"], "main")
        self.assertEqual(result["head"], self.head)
        self.assertEqual(result["counts"], {"staged": 0, "unstaged": 0, "untracked": 0})

    def test_unstaged_change_is_seen(self):
        self.write("README.md", "changed\n")
        result = repo_snapshot.snapshot(gitio.repo_root(self.repo))
        self.assertFalse(result["clean"])
        self.assertIn("README.md", result["unstaged"])
        self.assertEqual(result["staged"], [])

    def test_staged_change_is_seen_separately(self):
        self.write("new.txt", "x\n")
        git(self.repo, "add", "new.txt")
        result = repo_snapshot.snapshot(gitio.repo_root(self.repo))
        self.assertIn("new.txt", result["staged"])
        self.assertEqual(result["untracked"], [])

    def test_untracked_is_not_dirty_for_the_clean_check(self):
        self.write("stray.txt", "x\n")
        result = repo_snapshot.snapshot(gitio.repo_root(self.repo))
        self.assertFalse(result["clean"])
        self.assertTrue(result["clean_ignoring_untracked"])
        self.assertIn("stray.txt", result["untracked"])

    def test_detached_head_is_reported_not_crashed(self):
        git(self.repo, "checkout", "-q", "--detach")
        result = repo_snapshot.snapshot(gitio.repo_root(self.repo))
        self.assertTrue(result["detached_head"])
        self.assertIsNone(result["branch"])


class SnapshotExpectations(GitRepoCase):
    def test_matching_expectations_exit_zero(self):
        code = repo_snapshot.main(["--repo", str(self.repo), "--expect-branch", "main",
                                   "--expect-head", self.head, "--require-clean", "--json"])
        self.assertEqual(code, 0)

    def test_wrong_branch_exits_one(self):
        code = repo_snapshot.main(["--repo", str(self.repo), "--expect-branch", "release", "--json"])
        self.assertEqual(code, 1)

    def test_wrong_head_exits_one(self):
        code = repo_snapshot.main(["--repo", str(self.repo), "--expect-head", "0" * 40, "--json"])
        self.assertEqual(code, 1)

    def test_abbreviated_head_is_accepted(self):
        code = repo_snapshot.main(["--repo", str(self.repo), "--expect-head", self.head[:8], "--json"])
        self.assertEqual(code, 0)

    def test_require_clean_fails_on_a_dirty_tree(self):
        self.write("README.md", "dirty\n")
        code = repo_snapshot.main(["--repo", str(self.repo), "--require-clean", "--json"])
        self.assertEqual(code, 1)

    def test_not_a_repository_exits_two(self):
        code = repo_snapshot.main(["--repo", str(self.repo.parent), "--json"])
        self.assertEqual(code, 2)

    def test_missing_path_exits_two(self):
        code = repo_snapshot.main(["--repo", str(self.repo / "nope"), "--json"])
        self.assertEqual(code, 2)


if __name__ == "__main__":
    unittest.main()
