# Destructive operations

Anything that cannot be undone with the information you hold: deleting data, resetting state, wiping a device,
rewriting history, dropping a table, force-pushing, uninstalling something that owns data.

## Default: refuse and propose

When a destructive operation is proposed — by the user, or by your own first instinct — do not run it. Reply
with:

1. **Exactly what would be lost.** Enumerate it. Do not summarise it as "local data".
2. **Whether a reversible experiment can still discriminate.** If yes, the destructive action is not yet
   justified — see `reversible-experimentation.md`.
3. **What the destructive action would establish** that the reversible one would not. Often: nothing.
4. **What is irreversible even with a backup** — device state, time, an external side effect.

Then stop and wait. Silence is not authorisation. A general "go ahead" from earlier in the conversation is not
authorisation for this specific operation.

## The inventory changes decisions

Listing what would be lost is the highest-value step, and the one most often skipped because it feels like
delay. It routinely reveals either that the loss is trivial — in which case proceed calmly — or that it includes
something nobody had considered.

## If it is authorised

- Back up first. Verify the backup by hash.
- State plainly which parts no backup can restore.
- Do the narrowest version that achieves the goal.
- Verify afterwards that the intended thing was destroyed and nothing else was.
- Record what was lost, so a later reader knows why something is missing.

## Never automatic

These require explicit authorisation naming the operation, every time:

```
git reset --hard          git clean -fd            git checkout -- <path>
git rebase (history)      git push --force         branch or tag deletion
rm / rmdir on anything not created by this task
database drop or truncate    device erase or reset
uninstalling an app that owns user data
```

The tools shipped with this skill cannot perform any of them: `gitio.run` refuses any git verb outside a
read-only allow-list, before a process is spawned.

## Untracked files

Never delete an untracked file to tidy a working tree. Untracked files are frequently the user's own raw
evidence — a crash report, a capture, a reference image. Inventory them, name them in the report, leave them
alone.

## Failure mode

The characteristic failure is not recklessness; it is **plausibility**. The destructive action is proposed
because it is the obvious move, it matches a documented remedy, and it would probably work. It gets run, the
data is gone, and afterwards nobody can tell whether it was necessary — because the experiment that would have
answered that is no longer possible.
