"""Two renderings of the same result: one for a human, one for a program.

Tools take `--json` and otherwise print an indented text report. The JSON is
the stable interface; the text is allowed to change.
"""

from __future__ import annotations

import json
import sys
from typing import Any


def emit(result: dict[str, Any], as_json: bool, renderer) -> None:
    """Print `result` as JSON, or hand it to `renderer` for a text report."""
    if as_json:
        json.dump(result, sys.stdout, indent=2, sort_keys=True, ensure_ascii=False)
        sys.stdout.write("\n")
    else:
        renderer(result)


def line(label: str, value: Any, width: int = 26) -> None:
    print(f"  {label:<{width}} {value}")


def heading(text: str) -> None:
    print(f"\n{text}")
    print("  " + "-" * (len(text) + 2))


# Substrings that must never be echoed back, whatever a caller passes in.
# The tools never read environment variables or credential files; this is a
# second line of defence for paths and branch names that happen to look like
# secrets.
SENSITIVE_HINTS = (
    "password", "passwd", "secret", "token", "api_key", "apikey",
    "private_key", "id_rsa", "credential", "bearer", ".pem", ".p12",
    ".mobileprovision", "keychain",
)


def looks_sensitive(text: str) -> bool:
    lowered = text.lower()
    return any(hint in lowered for hint in SENSITIVE_HINTS)


def redact(text: str) -> str:
    """Replace a value that looks like a secret with a marker.

    Applied to values the tools echo back, never to their own findings.
    """
    return "<redacted: looks sensitive>" if looks_sensitive(text) else text
