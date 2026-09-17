# Changelog

## 1.0.2

Fixes the activation probe, which was wrong in the layout it mattered most in.

**Fixed**

- The probe assumed it always ran inside the full package tree. Installed the way an agent actually installs a
  skill — `.claude/skills/engineering-expert-skill/`, with no package above it — 1.0.1 reported `SKILL.md`
  missing while it sat two directories up, and reported **all six sibling tools missing while every one of them
  was on disk beside it**. The second was not a limitation, it was a false statement about the filesystem, and
  it came from `missing_tools = list(SIBLING_TOOLS)` standing in for a check that was never run. Every check now
  reads the thing it describes.
- `SKILL.md` is located relative to the skill directory, found by walking up from the probe, never via a package
  root that may not exist.
- A package root is accepted only if its `skills/engineering-expert-skill` really is this skill directory, so an
  unrelated project's `plugin.json` above the install path cannot be read as ours.

**Added**

- Two declared layouts: `MODE=PACKAGE` and `MODE=INSTALLED SKILL`. The absence of a package manifest in the
  second is reported as `PACKAGE_ROOT=NOT PRESENT — INSTALLED SKILL MODE` and as an `N/A` check, not a failure.
- `VERSION=` in the output, alongside the `PACKAGE_VERSION=` that 1.0.1 emitted, and `SKILL_ROOT=`, `MODE=` and
  an explicit `PACKAGE_ROOT=` line.
- An embedded version source inside the skill subtree — the `__version__` the tools package already carried — so
  an installed skill can verify itself with no manifest. It is cross-checked against the probe's own expected
  version, and in package mode against the manifest too. Drift in either direction is `DEGRADED`, never accepted
  in silence.
- `PERSISTENCE_VERIFIED` joins the claims the probe refuses to make. All four are `NOT DETERMINED`.
- Tests for both layouts built from real fixtures on disk, including one asserting the exact 1.0.1 defect: six
  tools present must never be counted as zero, and removing exactly one must report `5 of 6` and name it.

**Changed**

- Each check now carries `PASS` / `FAIL` / `N/A` rather than a boolean, so "not applicable here" stops being
  indistinguishable from "failed". This changes the JSON shape for callers that read `checks[].ok`.
- Version raised to 1.0.2 across the manifests, `agents/openai.yaml` and the tools package.

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
