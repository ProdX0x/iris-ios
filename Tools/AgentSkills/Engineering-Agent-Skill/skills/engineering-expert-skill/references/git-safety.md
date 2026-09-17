# Git safety

Using version control as a safety net, and proving states rather than assuming them.

## Before acting

Always, on any non-trivial task:

```bash
python3 scripts/repo_snapshot.py --expect-branch <branch> --expect-head <sha> --require-clean
```

A mismatch stops the work. This single check prevents the most expensive failure available to an agent: doing
correct work on the wrong state. **Do not correct a mismatch.** Report it. The user knows why it differs; you
do not.

Distinguish four things, because they mean different things:

| | Meaning |
|---|---|
| staged | deliberately prepared |
| unstaged | in progress |
| untracked | possibly the user's own evidence — never delete |
| ignored | invisible to `git diff`, so a diff proves nothing about it |

## During

- One branch per mission, cut from a **verified** HEAD.
- Commits bounded to one intention. A diff nobody can read is a rollback nobody can perform.
- For an audit-only mission, commit **documentation only** — that makes "no product code changed" checkable
  rather than asserted. `scope_audit.py` proves it.
- Before merging, check containment. Work believed to need integrating is often already an ancestor:
  ```bash
  python3 scripts/git_lineage.py --candidate branch-a --candidate branch-b --base main
  ```

## Proving a restoration

A `git diff` that is empty is **not** proof of restoration. It says nothing about:

- a file listed in `.gitignore`;
- an untracked file;
- anything outside the working tree;
- file modes or metadata, depending on configuration.

Hash before, hash after, compare:

```bash
python3 scripts/hash_manifest.py path/to/file --out /tmp/before.json --label "before experiment"
# ... experiment, then restore ...
python3 scripts/verify_restore.py /tmp/before.json
```

Keeping a pristine copy of the file and restoring by copying it back is better than re-editing it: a copy is
byte-exact by construction, and the hash then confirms it.

## Restoration points

Annotated tags at human-validated points are worth more than tags at arbitrary commits, because they mean
something later. Record what was validated in the tag message — that is the part that survives.

## Never automatic

`reset --hard` · `clean -fd` · destructive `checkout` · history-rewriting `rebase` · `push --force` ·
branch or tag deletion · deleting untracked files. Each needs explicit authorisation naming the operation.

The tools here cannot run any of them.

## Project choices, not universal rules

These worked somewhere; they are not laws. Do not impose them:

- **Linear history without merges.** Readable when one agent works at a time. Meaningless for a parallel team.
- **Never pushing.** A deliberate choice in some projects. Note that a repository never pushed has **no
  redundancy off the machine** — that is a backup question, not a hygiene one.
- **Tagging only after human validation.** Fits products judged by eye; not every product is.

State such a convention as the project's, and follow it. Never present it as good practice in general.

## Failure modes

- **Mistaking discipline for backup.** A tidy local repository is still one disk.
- **Merging without checking containment.** Creates noise and sometimes conflicts, to achieve nothing.
- **Deleting untracked files to "clean up".**
- **Trusting an empty diff** for a file git does not track.
