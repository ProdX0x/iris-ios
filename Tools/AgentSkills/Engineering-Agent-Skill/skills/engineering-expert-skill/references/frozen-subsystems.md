# Frozen subsystems

A subsystem whose behaviour has been validated and must not change without new evidence.

## Why

An agent sees improvement opportunities continuously. On code that was validated at real cost — human testing,
physical measurement, a long investigation — "improving" is a net risk. The expected gain is aesthetic; the
expected loss is a regression in something that took days to establish.

## A freeze record

A freeze that exists only as a sentence in a document is a wish. A usable record has:

| Field | Why |
|---|---|
| **Scope** | exact files or modules; a vague freeze is unenforceable |
| **Date and reason** | "validated on hardware, 12 March" — not "it works" |
| **Evidence** | what was validated, by whom, at what level |
| **Reopening conditions** | written at freeze time, not argued later |
| **Executable control** | the test that fails if a frozen file changes |

## Make it executable

The strongest form is a digest table in a test: record a hash per frozen file, fail when one changes. Two
properties make this work:

- it catches the change at the moment it happens, not at review;
- re-freezing a hash requires editing the test, which is where you write **why** — so the record is maintained
  by the act of changing it.

`hash_manifest.py` produces such a manifest; `verify_restore.py` checks it.

## What a freeze forbids

- behaviour changes, including "equivalent" ones;
- refactors, renames, reformatting;
- extracting a helper for reuse elsewhere;
- performance work without a measured problem.

## What it does not forbid

- reading, measuring, documenting;
- adding tests **around** it, without touching it;
- changing presentation strictly outside it, if the mandate says so;
- changing it when a reopening condition is met.

## Reopening

Valid: a demonstrated defect · an explicit new requirement · an incompatibility that breaks the build · a
security problem · debt that now blocks work, stated concretely.

Not valid: it would be cleaner · it is inconsistent with newer code · a newer API exists · it is untidy.

**Reproduce the defect before fixing it.** No reproduction, no change — otherwise you are changing validated
code on a hypothesis, which is the exact risk the freeze exists to prevent.

Then re-run the validation that justified the freeze. If that validation cannot be re-run — it needed a human,
or hardware you no longer have — say so explicitly, and let the cost of that be part of the decision.

## Failure modes

- **Freezing too early.** A freeze protects what was *validated*, not what was *finished*. Freezing unvalidated
  code preserves its bugs.
- **Freezing too broadly.** A whole layer frozen because one algorithm in it was validated makes the freeze a
  nuisance, and nuisances get ignored.
- **Prose-only freezing.** Without an executable control, the freeze holds only as long as everyone remembers it.
- **Negotiating by increments.** "It is only a rename." Refuse the same way regardless of size.
