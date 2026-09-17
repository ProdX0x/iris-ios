# Reversible experimentation

How to learn something from a system without damaging it.

## The procedure

```
 1. Capture the initial state, by measurement
 2. Write the competing hypotheses
 3. Identify the discriminating variable
 4. Inventory what the experiment could destroy
 5. Back that up, and verify the backup
 6. Make the smallest reversible change that moves the variable
 7. Instrument before acting, so the measurement cannot be missed
 8. Measure
 9. Restore
10. Verify the restoration independently — hash AND diff
11. Classify the evidence without exceeding it
12. Record what was ruled out
```

Only then ask whether a destructive action is still warranted. Usually it is not, because step 8 answered the
question.

## Notes on the steps that get skipped

**Step 4 — inventory before you risk.** Listing what would be lost routinely changes the decision. Sometimes the
stakes turn out to be far lower than feared; sometimes far higher. Either way you learn it before acting, which
is the only useful time.

**Step 5 — verify the backup.** An unverified backup is a belief. Hash it.

**Step 6 — one variable.** Two variables and a changed outcome teaches nothing. If two must move, you have two
experiments.

**Step 10 — prove the restoration.** A clean `git diff` is not proof: it says nothing about a file that is
ignored, untracked, or outside the repository. Compare hashes with `verify_restore.py`. "I put it back" is a
claim; a matching digest is a fact.

## DESTRUCTIVE ACTION BUDGET

> A destructive operation requires a **strictly higher** justification than any reversible experiment still
> available. While a reasonable reversible experiment can still discriminate the hypotheses, the destructive
> action is not justified — however much simpler it looks.

Simplicity is not justification. The destructive route is usually simpler; that is exactly why it gets chosen,
and exactly why the budget exists.

**The budget is lifted when:**

- a genuine emergency makes waiting cost more than erring;
- security requires immediate action;
- the loss has already happened and cannot be worsened;
- no alternative exists, and you can say what you tried;
- a human, told what is irreversible, explicitly authorises it.

That last one is a real exception, not a formality — but it requires the human to know what will be lost.
Authorisation given without that inventory is not informed.

## Stop conditions

- the initial state cannot be captured reliably **before** the change;
- the backup cannot be verified;
- the restoration cannot be proven;
- the experiment requires crossing a prohibition the mission set — say so rather than obeying to the letter or
  routing around it in silence;
- **the result is ambiguous** — report it, do not resolve it by preference.

## Contamination

The most dangerous outcome is a result you trust that came from a contaminated input. Before believing a
negative result — "I changed it and nothing happened" — ask:

- did the system actually read my change, or a cached copy?
- was a tool holding the old state in memory?
- did the artifact get rebuilt?
- did my instrument change the thing it measured?

If contamination is possible, the result is `NOT PROVEN`, not negative. Rerun with the suspected cache
eliminated — for instance by restarting whatever holds it — before concluding.
