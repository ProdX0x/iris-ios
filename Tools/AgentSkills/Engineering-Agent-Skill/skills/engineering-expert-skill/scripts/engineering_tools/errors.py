"""Error types shared by the tools.

The tools distinguish two failure kinds so a caller can tell "you asked me
something impossible" from "the thing you asked about is not in the state you
expected". The first is a usage problem, the second is a finding.
"""


class ToolError(Exception):
    """A usage or environment problem: bad path, not a repository, bad JSON."""

    exit_code = 2


class CheckFailed(Exception):
    """The inspection ran and the answer is negative.

    This is not a crash. `verify_restore` raising this means the files really
    do differ from the manifest, which is a useful, correct answer.
    """

    exit_code = 1
