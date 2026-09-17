# 02 — An incident closed without a proven cause

## Observation

A serious incident: illuminated spheres and buttons, abrupt visual changes, behaviour resembling a restart. A
system report showed a memory kill around a high-water threshold, mostly attributable to shared graphics
surfaces. Later, a second, brief visual flash occurred with no crash and no impact.

## What the investigation could and could not establish

It established that the process killed was **not the application** but a system compositor, and it measured
memory and thermal behaviour across sessions on two devices.

It did not establish what produced the flashes. A recently completed visual-system migration was the obvious
suspect and was never demonstrated to be the cause — obviousness is not evidence.

## The decision

The release gate declared the incident **non-blocking**, while recording:

```
CAUSE: NOT PROVEN
```

and — in the same document — a section titled *what would reopen this decision*.

## Why this was correct rather than negligent

Waiting for a proven cause would have blocked indefinitely on something that had occurred twice, had no
reproduction, and had no measured user impact. The alternative — quietly attributing it to the recent migration
— would have created a false certainty, and probably a pointless rewrite of a validated subsystem.

The decision is legitimate **only because of the two recorded items**: the evidence level, and the reopening
conditions. Without them, `NOT PROVEN` degrades into folklore: within two documents it becomes "the flash issue
we fixed", and nobody can reconstruct what was actually known.

## Lessons

1. A decision does not require a proven cause. It requires an honest statement of what is known and what would
   reverse it.
2. `NOT PROVEN` must be carried forward verbatim. Every restatement is an opportunity for it to harden.
3. "Reopening conditions" is the field that makes deciding-without-proof responsible rather than reckless.
4. The most likely suspect being unproven is a result worth writing down — it stops the next person from
   assuming.

## What this does not establish

That the cause was not the migration. Only that it was never shown to be. The incident remained open at the end
of the project.
