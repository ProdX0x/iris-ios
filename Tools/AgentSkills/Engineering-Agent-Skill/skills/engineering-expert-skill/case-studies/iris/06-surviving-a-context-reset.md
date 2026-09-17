# 06 — Surviving a context reset

## The problem

A long working session with an agent accumulates state: decisions and their reasons, what is proven and what is
merely likely, which areas are frozen, which prohibitions apply, which device plays which role. All of it lives
in a conversation that will end.

## What was done

Before each reset, a handoff document was written **from tool output**, never from recall: branch and HEAD from
`rev-parse`, restore points from the tag list, the working tree from `status`, containment from
`merge-base --is-ancestor`.

It contained what the project is, exact branch and commit, working-tree state with untracked files listed by
name, restore points with what each meant, decisions with their reasons, gate statuses including the partial
ones, evidence with levels preserved, open problems, frozen subsystems, **prohibitions with their reasons**,
which hardware was available and its role, build and test commands, pointers to fuller documents, and one
concrete next action.

A separate document held the **reusable knowledge**. The two expire at different rates: project state is stale
after one commit; what was learned is not.

## The resume protocol

```
READ → VERIFY → COMPARE → CONFIRM ENVIRONMENT → WAIT FOR MISSION
```

with one rule that matters more than the rest: **on a mismatch, report it and correct nothing.** The difference
has a cause the resuming session does not know.

## What made it work

The **prohibitions** section. Rules that live only in conversation die with it, and the next session cheerfully
undoes expensive work. Each prohibition carried its reason — a rule whose reason is unknown gets discarded the
first time it is inconvenient.

And writing every number from a command. The temptation to write "HEAD is roughly…" is strong and always wrong.

## Lessons

1. Conversation memory is not a source of truth. The repository is.
2. Separate project state from durable knowledge, or the durable half gets thrown out with the stale half.
3. Prohibitions need reasons attached.
4. The last line of a handoff should be one concrete next action — otherwise the resuming session invents one.
5. Test a handoff by asking whether a reader who lived none of it could act.

## What this does not establish

That the format generalises. It suited one person, one agent, one project. A team handoff has different
requirements — notably, who is doing what.
