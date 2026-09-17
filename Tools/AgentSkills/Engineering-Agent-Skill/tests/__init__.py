"""Test package.

The tools are standalone scripts, not an installed package, so their directory
goes on `sys.path` here — at package import, before any test module runs and
tries to import one. The tests directory joins it so `support` resolves whether
discovery is run from the package root or from `tests/`.
"""

from __future__ import annotations

import sys
from pathlib import Path

_TESTS = Path(__file__).resolve().parent
_SCRIPTS = _TESTS.parent / "skills" / "engineering-expert-skill" / "scripts"

for _path in (_SCRIPTS, _TESTS):
    if str(_path) not in sys.path:
        sys.path.insert(0, str(_path))
