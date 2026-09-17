---
name: extract-validated-lessons
description: Use after a project, release, incident or investigation to turn what happened into knowledge, and to propose updates to the engineering skill. Triggers on "extract the lessons", "what did we learn", "post-mortem", "update the engineering skill", "retrospective", or after any gate closes with unresolved items. Distinguishes a one-off from a general rule, captures what must not be concluded, and never edits the skill without human review. Also use to retire a rule that has stopped earning its place.
---

# Extract Validated Lessons

Maintenance for `engineering-expert-skill`. Its purpose is as much to **prevent** rules as to add them: without
a filter, every experience becomes a rule, and a method that only grows gets abandoned wholesale.

## Prerequisites

- The evidence exists: reports, measurements, commits, incident records. Recollection is not evidence.
- A human is available to review. This skill proposes; it does not merge.

## Workflow

### 1. Read the evidence
Work from the artifacts, not from the story. Where a report states an evidence level, keep it — a `NOT PROVEN`
that quietly becomes a fact is the failure this whole discipline exists to prevent.

### 2. List candidate lessons
Anything that changed how the work went. Include the uncomfortable ones: what the agent got wrong, what caught
it, and what almost happened.

### 3. Classify each candidate
See `references/lesson-intake.md` for the full test. Summary:

| Class | Test | Destination |
|---|---|---|
| **One-off** | depends on this project, this stack, this person | case study only |
| **Domain rule** | holds for this platform or problem class | a domain skill |
| **General rule** | survives deleting every proper noun | `engineering-expert-skill` |
| **Negative knowledge** | says what must not be concluded or done | `negative-knowledge.md` form |
| **Not a lesson** | happened once, changed nothing | discard, and say so |

**Deleting the proper nouns is the test.** If the rule stops making sense without the product name, it is not
general. Most candidates fail here, and that is the correct outcome.

### 4. Check what already exists
A near-duplicate of an existing rule means the rule needs **sharpening**, not a sibling. Two rules that overlap
will eventually contradict each other.

### 5. Look for rules to retire
The half of the job that never happens by itself. For each existing rule, ask:

- has it caught a real problem, ever?
- has it produced false positives?
- what did following it cost?
- is its original reason still true?

Propose deletions alongside additions. **A round that proposes only additions has not done step 5.**

### 6. Draft the proposal
For each proposed change:

```
CHANGE          add / sharpen / retire
RULE            one sentence
SOURCE          the artifact it comes from
EVIDENCE        what actually happened
GENERALISATION  observed once / repeated / widely established
LIMITS          where it was never tested
FAILURE MODE    how following it goes wrong
DESTINATION     which file
```

Nothing with `GENERALISATION: observed once` may become a hard rule. It may become a case study, or a
suggestion.

### 7. Stop and ask
Present the proposal. **Do not edit the skill.** Wait for a decision on each item.

### 8. Apply what was accepted
Update the files, and add a `CHANGELOG.md` entry per accepted change with the reason. Record the rejections too,
in the proposal record — otherwise the same suggestion returns every cycle and has to be refused again.

## What this skill produces

1. A classified list of candidate lessons.
2. A change proposal in the format above, including retirements.
3. After human approval: edits to the skill and a changelog entry per change.
4. A record of what was rejected, and why.

## Rules

- Always work from artifacts. Never from recollection.
- Always propose at least one retirement, or state that you looked and found none.
- Never let a single occurrence become a hard rule.
- Never edit the skill before a human decides.
- Never silently drop a rejected proposal; record it so it is not re-proposed.
- Never remove an evidence level when moving a statement between documents.
- Keep case-study detail in the case study. A rule must be usable without loading the case.

## Calibration input

Record each cycle, for the next one: hypotheses that proved wrong, defects that appeared after a gate passed,
false positives from the agent, destructive actions avoided and whether avoiding them was right, and the time
spent on formalism against what it caught.

The purpose of that record is to make the method **smaller** where it has not earned its weight.
