# 04 — A validated engine protected from improvement

## Context

The gaze engine — mapping, filtering, calibration mathematics, physics — had been validated by a person, on real
hardware, at real cost. Revalidating it required a human, a device, and time.

## The mechanism

A table of SHA-256 digests in a test suite, one per protected file. Any change to a protected file fails the
test. Re-freezing a digest requires editing the test file, which is where the justification has to be written.

Two properties made it work:

- it fires **at the moment of the change**, not at review time;
- the act of re-freezing forces the record, so the reason is never missing.

## What it caught

While rewriting a rendering snapshot, the agent lost a condition that suppressed a visual marker during a
particular game sequence. No review noticed. An existing test — one that asserted an **absence**, that no marker
is drawn there — failed on the first run.

Three deliberate re-freezes happened over the project, each with its justification written into the test file.

## What it refused

Several opportunistic refactors of validated code. The refusal was not a judgement about the refactors; it was
that their expected gain was aesthetic while their expected loss was a regression in something expensive to
re-establish.

## Lessons

1. A freeze that exists only in prose holds only while everyone remembers it. Make it executable.
2. Tests that assert an **absence** catch what review does not. Absence is invisible to a reader; it is trivial
   for a test.
3. Requiring a written justification at the moment of re-freezing is what keeps the record honest — the
   documentation is produced by the act, not by discipline afterwards.
4. Freeze what was *validated*, not what was *finished*. Freezing unvalidated code preserves its defects.

## What this does not establish

That freezing is always right. A freeze has a cost: it slows legitimate change and can preserve real debt. It
paid here because revalidation needed a human and hardware. Where revalidation is cheap, the balance differs.
