"""git_lineage: is this work already contained, or does it really need merging?"""

import unittest

import git_lineage
from engineering_tools import gitio
from support import GitRepoCase, git


class Lineage(GitRepoCase):
    def test_an_ancestor_is_reported_as_contained(self):
        first = self.head
        self.write("b.txt", "b\n")
        self.commit_all("second")
        result = git_lineage.lineage(gitio.repo_root(self.repo), "HEAD", [first], None)
        self.assertTrue(result["contained"][0]["contained"])
        self.assertFalse(result["merge_needed"])

    def test_a_divergent_branch_is_reported_as_not_contained(self):
        base = self.head
        git(self.repo, "checkout", "-q", "-b", "side")
        self.write("side.txt", "s\n")
        self.commit_all("side work")
        git(self.repo, "checkout", "-q", "main")
        self.write("main.txt", "m\n")
        self.commit_all("main work")
        result = git_lineage.lineage(gitio.repo_root(self.repo), "HEAD", ["side"], base)
        self.assertTrue(result["merge_needed"])
        self.assertEqual(result["not_contained"][0]["ref"], "side")

    def test_base_divergence_counts_are_reported(self):
        base = self.head
        self.write("b.txt", "b\n")
        self.commit_all("second")
        result = git_lineage.lineage(gitio.repo_root(self.repo), "HEAD", [], base)
        self.assertEqual(result["base"]["ahead"], 1)
        self.assertEqual(result["base"]["behind"], 0)
        self.assertTrue(result["base"]["linear"])
        self.assertTrue(result["base"]["base_is_ancestor"])

    def test_a_merge_is_detected_in_the_range(self):
        base = self.head
        git(self.repo, "checkout", "-q", "-b", "side")
        self.write("side.txt", "s\n")
        self.commit_all("side work")
        git(self.repo, "checkout", "-q", "main")
        self.write("main.txt", "m\n")
        self.commit_all("main work")
        git(self.repo, "merge", "-q", "--no-ff", "-m", "merge side", "side")
        result = git_lineage.lineage(gitio.repo_root(self.repo), "HEAD", [], base)
        self.assertGreaterEqual(result["base"]["merges_in_range"], 1)
        self.assertFalse(result["base"]["linear"])

    def test_unknown_ref_is_a_finding_not_a_crash(self):
        result = git_lineage.lineage(gitio.repo_root(self.repo), "HEAD", ["no-such-ref"], None)
        entry = result["not_contained"][0]
        self.assertIsNone(entry["resolved"])
        self.assertIn("does not resolve", entry["note"])

    def test_cli_require_contained_exit_codes(self):
        first = self.head
        self.write("b.txt", "b\n")
        self.commit_all("second")
        self.assertEqual(git_lineage.main(
            ["--repo", str(self.repo), "--candidate", first, "--require-contained", "--json"]), 0)
        git(self.repo, "checkout", "-q", "-b", "side")
        self.write("s.txt", "s\n")
        self.commit_all("side")
        git(self.repo, "checkout", "-q", "main")
        self.assertEqual(git_lineage.main(
            ["--repo", str(self.repo), "--candidate", "side", "--require-contained", "--json"]), 1)


if __name__ == "__main__":
    unittest.main()
