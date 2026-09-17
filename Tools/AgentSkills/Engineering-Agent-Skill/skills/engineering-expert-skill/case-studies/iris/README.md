# Case studies — Iris

Six episodes from one project: a gaze-controlled iOS game built by one person working with an AI agent, over
about three months in 2026. They are the evidence behind the rules in `../../references/`.

**The main skill does not load these.** It works without them. Read one when you want to know why a rule exists,
or when you are arguing about whether it applies to you.

**One project is not a proof.** These show that a rule helped once, in a domain with specialised hardware, real
money and a public release — so error costs were high. On a disposable internal tool, several of these rules are
luxuries. Each case ends with what it does not establish.

| | Case | Rule it supports |
|---|---|---|
| 01 | A destructive fix replaced by a reversible experiment | `reversible-experimentation`, `destructive-operations` |
| 02 | An incident closed without a proven cause | `evidence-levels`, `release-gates` |
| 03 | A regression that was never real | `causal-debugging` |
| 04 | A validated engine protected from improvement | `frozen-subsystems` |
| 05 | Machine evidence and human evidence kept apart | `human-validation` |
| 06 | Surviving a context reset | `session-handoff` |
