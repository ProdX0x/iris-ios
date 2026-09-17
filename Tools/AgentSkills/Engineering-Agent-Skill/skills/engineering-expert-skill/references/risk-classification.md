# Risk classification: LIGHT, STANDARD, DEEP

Choose the mode before working, and say which you chose. The default is LIGHT.

## The question

Not "how important is this project" but **"what does an error here cost, and can I undo it?"**

## Signals

| | LIGHT | STANDARD | DEEP |
|---|---|---|---|
| Reversibility | trivially undone | undone with a revert | partly irreversible |
| Surface | one file or function | several files, one subsystem | crosses subsystems, or leaves the machine |
| Existing cover | tests already cover it | tests need extending | cover is unknown or impossible |
| Visibility | internal | user-visible | external: published, paid, shipped |
| Certainty | the cause is known | the design is known | the cause or the outcome is unknown |
| Data | none touched | app state | user data, money, credentials |
| Environment | one, reproducible | one, reproducible | specialised hardware, or environment-dependent |

**Any single DEEP signal makes the task DEEP.** Risk does not average out.

## What each mode costs

| | LIGHT | STANDARD | DEEP |
|---|---|---|---|
| Ground truth | branch + clean check | `repo_snapshot.py` | snapshot with asserted expectations |
| References | only if a topic applies | routed topics | routed topics, plus gates |
| Evidence | the test run | levels on conclusions | levels everywhere, hypotheses named |
| Backup | none | none unless deleting | manifest before touching anything |
| Gate | no | only if externally visible | yes |
| Human validation | no | if perceptible | yes |
| Report | a sentence | short, structured | full, including what is unproven |

## Escalate mid-task when

- the change is bigger than it looked;
- a test fails for a reason you cannot explain;
- the target turns out to be frozen;
- a destructive step appears necessary;
- the same symptom shows up somewhere unrelated.

Say you are escalating, and why. Silent escalation looks like scope creep.

## De-escalate when

The investigation established the cause and the fix is now a one-line change: finish in LIGHT. Keep the DEEP
evidence; drop the DEEP ceremony. **A mode is for the work remaining, not for the work already done.**

## Failure modes

- **DEEP everywhere.** The commonest failure. The method becomes the over-engineering it was meant to prevent,
  and people route around it.
- **LIGHT because it is small.** Size is not the criterion; cost of error is. Deleting one line of a payment
  path is DEEP.
- **Mode by anxiety.** If you cannot name the DEEP signal, it is not DEEP.
