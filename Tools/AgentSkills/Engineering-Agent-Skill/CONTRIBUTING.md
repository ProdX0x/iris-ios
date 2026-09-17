# Contributing

## The bar for a new rule

A rule enters only if it passes all four:

1. **Proper-noun test.** Delete every product, tool and person from it. If it stops making sense, it belongs in
   a case study.
2. **Recurrence.** Seen once is a case study. Seen twice independently is a candidate. Repeatedly across
   projects is a hard rule.
3. **Cost.** What it costs every time, forever, against the error it prevents times how often that error occurs.
4. **Falsifiability.** State what would show it is wrong. If nothing would, it is a preference — label it as a
   suggestion.

Use `extract-validated-lessons` rather than editing by hand; it enforces the classification and produces the
provenance fields.

## The bar for removing one

Lower, deliberately. Propose a retirement when a rule has caught nothing across several projects, produces false
positives, or its original reason has expired.

**A method that cannot shrink will be abandoned wholesale.** Every maintenance round should propose at least one
retirement, or state that it looked and found none.

## Adding a reference

- Route it from the skill's topic router, or it is unreachable — and the integrity tests will fail it as an
  orphan.
- Structure: what it is for, the procedure, exceptions, failure modes.
- Keep case-study detail out. The reference must be usable without loading the case.
- No absolute paths, no commit identifiers, no name of the project it came from. Those tests exist and will fail.

## Adding a tool

- Read-only by default. No network, no telemetry, no environment variables.
- Any git access goes through `engineering_tools.gitio`, whose allow-list refuses mutating verbs before a
  process is spawned.
- Exit codes: `0` fine, `1` the check ran and the answer is negative, `2` usage or environment error.
- Support `--json` and `--help`.
- Tests build their own temporary repository. **Never test against the repository you are working in.**

## Adding an evaluation scenario

Every scenario needs input, expected route, expected evidence level, mandatory actions, prohibited actions and
human decision points. A scenario without prohibited actions tests nothing — the failure mode is what matters.

Keep at least one scenario whose failure condition is **over-engineering**. Without it, every change makes the
method heavier.

## Running everything

```bash
cd Engineering-Agent-Skill
python3 -m unittest discover -s tests -t . -v
python3 scripts/build_release.py --output /tmp --verify
```

No third-party dependencies. If a change needs one, it probably belongs elsewhere.
