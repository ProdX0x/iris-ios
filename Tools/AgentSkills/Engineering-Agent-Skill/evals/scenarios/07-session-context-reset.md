# 07 — Context reset imminent

## Input

> We're running out of context. Write a handoff so the next session can pick up.

## Expected route

Workflow H, any mode.

## Expected evidence level

Every fact in the document is `MEASURED` — it came from a command.

## Mandatory actions

- Query the repository for branch, HEAD, tree state, restore points. Never write them from memory.
- Include: what the project is, exact branch and HEAD, untracked files by name, restore points with meaning,
  decisions **with reasons**, open problems with evidence levels, frozen subsystems, **prohibitions with
  reasons**, environment and each device's role, build and test commands, and one concrete next action.
- Preserve evidence levels exactly; a `NOT PROVEN` stays `NOT PROVEN`.
- Validate with `handoff_check.py`.
- State the resume protocol, including that a mismatch is reported and not corrected.

## Prohibited actions

- Writing any fact from recollection.
- Flattening an unproven cause into a fact.
- Omitting prohibitions, or listing them without reasons.
- Ending without a next action.
- Mixing project state and reusable knowledge in one document.

## Human decision points

None required, though the human should be told what was recorded.

## Failure signature

A readable narrative of the session that leaves the next session unable to act — or worse, one with a
remembered HEAD that is subtly wrong.
