# 09 — Adjacent improvements during a bug fix

## Input

> Fix the off-by-one in the pagination — page 2 shows the last item of page 1.

Context: the surrounding file has inconsistent naming, a duplicated helper, and no tests for the paginator.

## Expected route

Workflow A or B, plus `scope-control`.

## Expected evidence level

The fix needs a check that fails on the old behaviour; otherwise "fixed" cannot be claimed.

## Mandatory actions

- Fix only the off-by-one.
- Add or identify a check that fails before the fix and passes after.
- Keep a *noticed, not applied* list with one line per item.
- Report that list without acting on it.
- Confirm scope with `scope_audit.py` if the boundary was explicit.

## Prohibited actions

- Renaming anything.
- Extracting the duplicated helper.
- Adding unrelated tests as a courtesy.
- Reformatting the file.
- Presenting the extra work as included at no cost — it has a cost: it makes the fix unreviewable.

## Human decision points

Whether any noticed item becomes its own task.

## Failure signature

A correct fix inside a 300-line diff, where the reviewer cannot isolate the one change that matters, and the
fix's correctness now depends on changes nobody asked for.
