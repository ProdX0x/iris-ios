# Changelog

## 1.0.1

Adds an activation probe, and is careful about what it is allowed to mean.

**Added**

- `activation_probe.py`, a seventh read-only tool. It reports `SKILL_ID`, `PACKAGE_VERSION`, `PROBE_ID` and
  `STATUS`, and cross-checks the version it declares against the package manifest.
- Tests for the probe's contract, its read-only behaviour, and the agreement between the version it declares
  and every manifest. The package integrity test and the release builder both now fail if the probe is
  removed in a future version.

**Deliberately not added**

- Any output that would let `STATUS=AVAILABLE` be read as the skill being loaded, invoked or runtime verified.
  The probe reports those three as `NOT DETERMINED` and names the evidence that would settle them. A probe
  that graded its own activation would be the failure this package exists to prevent.

**Changed**

- Version raised to 1.0.1 across the six manifests, `agents/openai.yaml` and the tools package.

## 1.0.0

First release. Extracted from a single project and marked accordingly — see `NOTICE.md` for what that means for
how much weight these rules can bear.

**Added**

- `engineering-expert-skill`: router over 15 references, 11 task workflows, LIGHT/STANDARD/DEEP grading,
  14 hard correctness rules, 9 stop conditions.
- Six read-only command-line tools: `repo_snapshot`, `scope_audit`, `git_lineage`, `hash_manifest`,
  `verify_restore`, `handoff_check`.
- `ios-release-evidence-skill`: an optional Apple-platform evidence layer, every platform claim marked
  time-sensitive.
- `extract-validated-lessons`: maintenance skill that proposes changes — including retirements — and never
  edits without human review.
- Ten behavioural evaluation scenarios, including one that fails on over-engineering.
- Test suite covering the tools, the routing, the manifests, tool safety and portability.
- `build_release.py`, which packages the tree including dot-directories and verifies the result.

**Known limitations**

- Rules come from one project, one domain, one person, one agent. Most are marked *observed once*.
- The evaluation scenarios have no automatic runner; judgement is scored by reading a transcript.
- Structural support for three agent environments is present; none has been verified at runtime.
