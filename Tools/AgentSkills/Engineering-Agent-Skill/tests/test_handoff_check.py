"""handoff_check: does it notice what a resuming session would be missing?"""

import tempfile
import unittest
from pathlib import Path

import handoff_check

COMPLETE = """
# Handoff

Branch: release/x
HEAD: 6957a775277d42fce7cec0f8aca0d6a4377ca6b4
Working tree is clean apart from three untracked files.
Restore points: tag v1 at abc1234.
Frozen: the calibration module.
Do not run the app from the development tool on the reference device.
Open problems: the flash cause is NOT PROVEN.
Devices: one phone available, one unavailable.
Build: run the test command below.
Next action: read this, verify git state, then wait.
"""

NARRATIVE = """
# What we did today

We looked at a few things and made some progress. It was interesting.
Then we stopped for lunch and came back to it later.
"""


class HandoffCheck(unittest.TestCase):
    def test_a_complete_handoff_passes(self):
        result = handoff_check.check(COMPLETE)
        self.assertTrue(result["complete"], result["missing_required"])
        self.assertTrue(result["contains_commit_sha"])

    def test_a_narrative_fails_and_names_what_is_missing(self):
        result = handoff_check.check(NARRATIVE)
        self.assertFalse(result["complete"])
        self.assertIn("branch", result["missing_required"])
        self.assertIn("next_action", result["missing_required"])

    def test_french_wording_is_recognised(self):
        french = ("Branche : release/x\nHEAD : abc1234\nArbre propre, trois fichiers non suivis.\n"
                  "Interdit : lancer depuis l'outil.\nProblème ouvert : cause NOT PROVEN.\n"
                  "Prochaine action : vérifier l'état git.\n")
        result = handoff_check.check(french)
        self.assertTrue(result["complete"], result["missing_required"])

    def test_recommended_fields_are_reported_without_failing(self):
        minimal = ("branch: x\nHEAD: abc1234\nclean tree\nnext action: wait\n"
                   "open: nothing\ndo not push\n")
        result = handoff_check.check(minimal)
        self.assertTrue(result["complete"])
        self.assertIn("frozen", result["missing_recommended"])

    def test_cli_exit_codes(self):
        with tempfile.TemporaryDirectory() as tmp:
            good = Path(tmp) / "good.md"
            good.write_text(COMPLETE, encoding="utf-8")
            bad = Path(tmp) / "bad.md"
            bad.write_text(NARRATIVE, encoding="utf-8")
            self.assertEqual(handoff_check.main([str(good), "--json"]), 0)
            self.assertEqual(handoff_check.main([str(bad), "--json"]), 1)
            self.assertEqual(handoff_check.main([str(Path(tmp) / "nope.md"), "--json"]), 2)


if __name__ == "__main__":
    unittest.main()
