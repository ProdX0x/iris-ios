# Session handoff

Making a project resumable when the conversation that held its state is gone.

## The principle

> Conversation memory is not a source of truth. The repository is.

Everything that must survive the session belongs in a file. Everything written into a handoff must come from a
tool, not from recall — including facts you are sure of, because certainty is exactly what memory counterfeits.

## Writing one

Query first, write second:

```bash
python3 scripts/repo_snapshot.py --json
python3 scripts/git_lineage.py --base main --json
```

Contents:

| Section | Notes |
|---|---|
| What the project is | two or three sentences; the reader may know nothing |
| Branch, HEAD | exact, from `rev-parse` |
| Working-tree state | clean? untracked files, listed by name |
| Restore points | tags or commits, with what each meant |
| Decisions | and **why** — a decision without its reason will be re-litigated |
| Gate or phase status | including PARTIAL and BLOCKED |
| Evidence | each with its level; keep NOT PROVEN as NOT PROVEN |
| Open problems | and what would resolve each |
| Frozen subsystems | and what would reopen them |
| **Prohibitions** | what the next session must not do, and why |
| Environment | devices, accounts, services, and each one's role |
| How to build and test | exact commands |
| Where to read more | pointers, not copies |
| **The next action** | one concrete thing |

Validate it:

```bash
python3 scripts/handoff_check.py path/to/handoff.md
```

The tool checks presence, not truth. It cannot know whether the HEAD you wrote is the HEAD that exists.

## Resuming

```
READ → VERIFY → COMPARE → CONFIRM ENVIRONMENT → WAIT FOR MISSION
```

1. **Read** the handoff completely before touching anything.
2. **Verify** the real state: working directory, repository root, branch, HEAD, status, diff.
3. **Compare** with the document. On a mismatch: **report it, correct nothing.** The difference has a cause you
   do not know.
4. **Confirm the environment** before any hardware or external step. A device that was available may not be.
5. **Wait** for the mission. Do not infer one from the document.

Never `READ → EDIT`. A handoff describes a state; it does not authorise work.

## Separate state from knowledge

| | Where | Expires |
|---|---|---|
| Project state — branch, HEAD, gates, open problems | the handoff | every commit |
| Reusable knowledge — how to work, what was learned | a separate, durable document | slowly, with evidence |

Mixing them means the durable half gets thrown away with the stale half.

## The prohibitions section

The most valuable and most often omitted. A prohibition that survives only in conversation dies with it, and the
next session cheerfully undoes expensive work. Write the reason next to each: a rule whose reason is unknown
gets discarded the first time it is inconvenient.

## Failure modes

- **A narrative instead of a state.** Test: could a reader who lived none of it act?
- **Written from memory.** Every number must come from a command.
- **No next action.** The resuming session invents one.
- **Levels flattened.** NOT PROVEN written as fact is how an unproven cause becomes folklore.
- **Silently corrected mismatch.** The one thing a resuming session must never do.
