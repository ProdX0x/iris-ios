# Causal debugging

For a defect whose cause is unknown. Not for a defect you already understand.

## Procedure

**1. Record the observation, exactly.** What happened, where, when, on what build, on what device, how often.
Distinguish what was *seen* from what was *inferred* — most bad investigations start with an inference recorded
as an observation.

**2. Write at least two competing hypotheses.** This is not optional and not a formality. One hypothesis is a
belief you will now look for support for. Two hypotheses is an investigation, because you must now find
something that separates them. Include the boring ones: measurement error, environment, a stale artifact, an
observer effect.

**3. For each, write what it predicts that the others do not.** A hypothesis that predicts nothing distinctive
cannot be tested and should be dropped or sharpened.

**4. Identify the discriminating variable** — the one whose change produces different outcomes under different
hypotheses.

**5. Choose the least invasive experiment that moves it.** See `reversible-experimentation.md`.

**6. Measure. Restore. Prove the restoration.**

**7. Interpret without exceeding the evidence.** If the result rules one out, say so. If it rules out none, say
`NOT PROVEN` and name the survivors. Then find another discriminator.

**8. Record what was excluded** in `negative-knowledge.md` form. An excluded hypothesis is expensive; losing it
means paying again.

## Biases to check yourself against

**Confirmation.** You designed an experiment that your favourite hypothesis passes. Ask instead: what result
would make me abandon it? If no result would, the experiment is decorative.

**Post hoc.** It broke after the change, so the change broke it. Sometimes true. But what else changed —
an OS update, a cache, a rebuilt artifact, a different machine, a different time of day?

**Baseline error.** "It got slower" needs a measurement of *before*. A remembered before is not a baseline. No
baseline, no regression claim — at most a report of the current value.

**Environment confounding.** The behaviour belongs to the environment, not the system. Two devices, two
simulator runtimes, a debugger attached, a test harness active, a local override left in place. Suspect this
first when two supposedly identical setups disagree.

**Observer effect.** Your instrument changed the thing. A debug build, a profiler, a tool that reinstalls the
app to inspect it, a harness that establishes the very state you are attributing to the system.

**Multiple variables.** You changed two things and it worked. You have learned nothing about either.

**Absence of evidence.** Not finding a symbol, a string, or a log line may mean it is absent — or that your
search cannot see it. Know your instrument's blind spots before reading a null result as proof. A tool that
cannot detect X tells you nothing about X.

**Negative evidence is evidence.** An experiment that changes nothing constrains the space. Record it.

## When the result is ambiguous

Say so. Name the survivors. List what you tried that failed to separate them, and why each failed. This is not a
weak outcome — a recorded ambiguity is what lets the next experiment be designed. A resolved-by-preference
ambiguity poisons everything downstream.

## When to stop

Stop when the cause is established, or when the remaining hypotheses cannot be separated by anything available.
In the second case, report `NOT PROVEN`, state what access or instrument would settle it, and let the decision
be made on risk instead — see `release-gates.md`. **Deciding without a proven cause is legitimate, as long as
the decision says so and records what would reopen it.**
