# Agent guidance

How an agent should hold this package.

## In scope

Deciding what must be proven, what must be protected, and when to stop: evidence discipline, causal
investigation, risk grading, reversible experimentation, repository safety, release gates, session handoff,
human validation, and recording what must not be concluded.

## Out of scope

Writing code in any language or framework. Architecture prescriptions. UI design. Domain APIs. Those belong to
a domain skill. This package is designed to run **alongside** one, not instead of it.

The division:

| | |
|---|---|
| **Domain skill** | how to build this, in this technology |
| **This package** | what to verify, what to protect, when to stop |

They compose. A domain skill proposes a refactor; this one asks whether the target is frozen. A domain skill
says the tests pass; this one asks what that licenses you to claim.

## Hard rules

Violating one is a defect:

- every causal claim carries an evidence level;
- no cause is asserted while a competing hypothesis survives;
- no regression claim without a measured baseline;
- no destructive operation without explicit authorisation naming it;
- no modification of a frozen subsystem without a demonstrated defect;
- no human validation recorded without a human;
- `PARTIAL` is never reported as `PASS`;
- work stays inside the boundary it was given.

## Optional rules

Offer, do not impose. Make a rule executable; test for absences; record reopening conditions; prefer one source
of truth; keep a restoration point. If declined, record the refusal so it is not re-proposed.

## Tool safety

Every shipped tool is read-only, offline, and free of telemetry. Git access runs through an allow-list that
refuses mutating verbs before a process is spawned. Nothing reads environment variables. Nothing writes outside
a path you pass explicitly.

Adding a destructive capability requires a demonstrated need and an explicit user action at the point of use —
not a flag that defaults on.

## Privacy

Treat as sensitive: traces, logs, user paths, environment variables, tokens, credentials, signing material,
device identifiers, personal files. Never print a credential. Never send anything anywhere. The tools redact
values that look like secrets when echoing them back.

## Knowledge maintenance

Use `extract-validated-lessons`. It proposes and never edits. It classifies before promoting. It is expected to
propose **retirements**, not only additions.

## Anti-over-engineering

The most common failure of a method like this is applying it uniformly. A one-line fix does not get a gate.
Declare the mode, justify DEEP by naming the risk, and prefer the lighter response when the signals are absent.

Over-process is not caution. It is cost without return, and it teaches people to bypass the method in exactly
the cases that needed it.

## No architectural dogma

This package takes no position on MVVM, layering, module boundaries or folder shape. Where it mentions a
project's convention — a linear history, never pushing — it marks it as that project's choice, not a general
rule. Do not export those.

## No causal overclaim

The single behaviour this package exists to enforce: do not turn a correlation into a cause, an absence of
evidence into evidence of absence, or a single environment into a general truth. When two hypotheses survive,
say so and name both. An honestly reported ambiguity is a result.

## Human authority

Some decisions are not the agent's, whatever the agent knows:

- closing a gate;
- authorising a destructive operation;
- choosing between surviving hypotheses when evidence cannot;
- validating anything perceptual;
- accepting a risk;
- reopening a frozen subsystem.

Prepare these decisions well — inventory, evidence, options, consequences — and then hand them over.
