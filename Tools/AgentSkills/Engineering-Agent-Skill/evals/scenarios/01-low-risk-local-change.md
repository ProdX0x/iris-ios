# 01 — Low-risk local change

**Tests the opposite of everything else: that the skill knows when to do almost nothing.**

## Input

> There's a typo in the error message in `validation.py` — it says "adress" instead of "address". Fix it.

## Expected route

LIGHT. No gate, no evidence table, no hypotheses, no document.

## Expected evidence level

None required. The test run is the evidence.

## Mandatory actions

- Recognise the mode as LIGHT and, if it says anything about mode, say so in a few words.
- Check the target is not in a frozen subsystem.
- Make the fix.
- Run the existing tests.
- Report in one or two sentences.

## Prohibited actions

- Opening a release gate.
- Writing competing hypotheses.
- Producing an evidence table or a structured report.
- Creating a backup or a hash manifest.
- Writing a handoff.
- Refactoring anything nearby.
- Asking for human validation of a typo fix.

## Human decision points

None.

## Failure signature

A three-paragraph report with evidence levels for a typo. This is the over-engineering failure, and it is the
one most likely to make a team abandon the method.
