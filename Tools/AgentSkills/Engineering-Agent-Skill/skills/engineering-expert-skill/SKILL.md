---
name: engineering-expert-skill
description: Use when a software task involves uncertainty, risk, or a claim that needs proof — investigating a bug whose cause is unknown, deciding whether a regression is real, choosing between a destructive fix and a reversible experiment, modifying a subsystem that was already validated, preparing a release, comparing behaviour across devices or environments, handing work over before a context reset, or reporting what is and is not established. Also use when asked to "prove it", "is this a regression", "what is the root cause", "is it safe to change this", "are we ready to ship", "write a handoff", or when another skill's finding cannot be acted on without evidence. Complements domain skills that write code; this one decides what to verify, what to protect, and when to stop.
---

# Engineering Expert Skill

Reasoning, verification, protection and validation for software work. It does not write features — a domain
skill does that. This one decides what must be proven, what must not be touched, and when to stop and ask.

## Operating Rules

- Read `references/evidence-levels.md` at the start of every task. Every conclusion carries a level.
- Establish ground truth by running a tool. What you remember about a repository is not evidence.
- Classify the task's mode (LIGHT / STANDARD / DEEP) before working, and say which you chose. Most tasks are LIGHT.
- Separate **hard rules** (violating one is a defect) from **suggestions** (offer, do not impose).
- Never convert a correlation into a cause. If two hypotheses survive, say so and name both.
- Prefer a reversible experiment to a destructive one whenever a reversible one can still discriminate.
- Never start a destructive operation without explicit human authorisation for that specific operation.
- Never claim a human validated something. Only a human can.
- Stay inside the boundary you were given. Note improvements you will not make; do not make them.
- Do not impose an architecture, a process weight, or a ceremony the task does not need.

## Mode Selection

Run this before anything else. Announce the mode and why.

| Signal | Pushes toward |
|---|---|
| Local change, reversible, covered by existing tests | LIGHT |
| New feature, refactor, several files, visible behaviour change | STANDARD |
| Release · migration · payment · user data · deletion · security · specialised hardware · unknown cause · frozen subsystem | DEEP |

| Mode | Ground truth | References | Evidence | Gate | Human validation | Report |
|---|---|---|---|---|---|---|
| **LIGHT** | branch + clean check | only if a topic applies | test run suffices | no | no | a sentence |
| **STANDARD** | `repo_snapshot.py` | routed topics | levels on conclusions | only if externally visible | if perceptible | short, structured |
| **DEEP** | `repo_snapshot.py` with expectations | routed topics + `release-gates` | levels everywhere, hypotheses named | yes | yes | full, with what is unproven |

**Anti-ceremony rule.** Never put a one-line fix through a Gate. If you cannot name the risk that justifies DEEP,
the mode is not DEEP. Over-process is a failure, not a safety margin — see `references/scope-control.md`.

## Task Workflows

### A. Small / low-risk change (LIGHT)
1. Confirm branch and that the tree is clean enough to tell your change from someone else's.
2. Check the target against `references/frozen-subsystems.md`. If frozen, switch to workflow I.
3. Make the change. Run the existing tests.
4. Report in one or two sentences. No Gate, no document, no evidence table.

### B. Feature implementation (STANDARD)
1. Ground truth, then confirm the boundary: which paths may change.
2. Let the domain skill design and write. This skill does not.
3. Route any topic that applies below.
4. Run tests; report real numbers from the runner, never a reconstructed total.
5. If behaviour is perceptible, list what a human must judge — see `references/human-validation.md`.
6. Verify scope with `scripts/scope_audit.py`.

### C. Refactor (STANDARD, DEEP if the subsystem is validated)
1. Check `references/frozen-subsystems.md` first. A validated subsystem is not refactored on aesthetic grounds.
2. Establish what currently passes. That is the baseline; without it there is no "no regression".
3. Refactor, keeping behaviour. Do not mix a refactor with a behaviour change.
4. Re-run the same tests. Compare against the baseline, not against expectation.

### D. Uncertain bug / root-cause investigation (DEEP)
Full procedure in `references/causal-debugging.md`. Never skip step 2.
1. Record the observation exactly: what, where, when, on what.
2. Write **at least two competing hypotheses**. One hypothesis is a belief, not an investigation.
3. For each, write what it predicts that the others do not.
4. Pick the discriminating variable and the least invasive test that moves it —
   `references/reversible-experimentation.md`.
5. Measure. Restore. Prove the restoration with `scripts/verify_restore.py`.
6. Classify the result. If it does not discriminate, say `NOT PROVEN` and name the survivors.
7. Record what was ruled out in `references/negative-knowledge.md` form.

### E. Release preparation (DEEP)
1. `scripts/repo_snapshot.py --expect-branch … --expect-head …`. A mismatch stops the work.
2. `scripts/git_lineage.py --candidate …` before merging anything. Often nothing needs merging.
3. Build the Gate from `references/release-gates.md`. Criteria are written **before** the work.
4. Separate four states and never let one imply another:
   **code ready** · **artifact ready** · **external services configured** · **submittable**.
5. Anything unverifiable is `NOT DETERMINED`, never an assumption.
6. `PARTIAL` is a real outcome. Do not round it up to `PASS`.

### F. Critical migration (DEEP)
1. Record a restoration point and hash whatever the migration could destroy (`scripts/hash_manifest.py`).
2. Migrate in steps that can each be verified, not in one leap.
3. After each step, compare against the baseline captured before step 1.
4. Keep the rollback route open until the last verification passes.

### G. Hardware / environment differential (DEEP)
Full procedure in `references/environment-differential.md`.
1. Hold everything constant except one environment variable: same artifact, same install path, same launch path.
2. Measure on both. Record the exact commands.
3. A difference proves the environments differ. It does not yet say which is the real one.
4. Beware the observing environment changing what it observes — a test harness can create the very state you are
   attributing to the system.

### H. Session handoff / context reset (any mode)
Full procedure in `references/session-handoff.md`.
1. Query the repository for every fact. Never write a handoff from memory.
2. Cover: branch · HEAD · tree state · restore points · decisions and why · open problems with levels ·
   frozen areas · prohibitions · environment · how to build and test · **the next action**.
3. Validate with `scripts/handoff_check.py`.
4. Separate project state from reusable knowledge; they expire at different rates.
5. On resume: READ → VERIFY → COMPARE → CONFIRM ENVIRONMENT → WAIT FOR MISSION. Never READ → EDIT.

### I. Modifying a validated subsystem (DEEP)
1. Read its freeze record: why, when, what evidence, what would reopen it.
2. Demand a demonstrated defect or an explicit requirement. An intuition of elegance is neither.
3. Reproduce the defect **before** fixing it. No reproduction, no change.
4. Re-run the validation that justified the freeze. If it cannot be re-run, say so, and say what that costs.

### J. Destructive operation requested (DEEP — stop first)
1. Inventory exactly what would be lost. Inventorying often shrinks the stakes, or removes the need.
2. Ask: can a reversible experiment still discriminate? If yes, the destructive action is not yet justified —
   `references/destructive-operations.md`.
3. If it is genuinely necessary: back up, verify the backup, state what is irreversible, **then ask**.
4. Proceed only on explicit authorisation naming that operation. Silence is not consent.

### K. Human UX / physical validation (any mode)
1. List what the machine already established, so the human is not asked to re-verify it.
2. List only what a human can settle: perception, comfort, feel, real hardware, whether wording is understood.
3. Leave every item unchecked. Record the verdict at the grain it was given.
4. A point may be **out of criterion** — neither passed nor failed — if the reason is written down.

## Topic Router

Load a reference only when its topic is in play.

| Topic | Reference |
|---|---|
| Evidence levels and what may be claimed | `references/evidence-levels.md` |
| Choosing LIGHT / STANDARD / DEEP | `references/risk-classification.md` |
| Unknown cause, competing hypotheses, bias | `references/causal-debugging.md` |
| Experimenting without destroying | `references/reversible-experimentation.md` |
| A destructive operation was proposed | `references/destructive-operations.md` |
| Protecting a validated subsystem | `references/frozen-subsystems.md` |
| Repository state, lineage, restoration | `references/git-safety.md` |
| Deciding a release step is closed | `references/release-gates.md` |
| What only a human can judge | `references/human-validation.md` |
| Surviving a context reset | `references/session-handoff.md` |
| Recording what must not be concluded | `references/negative-knowledge.md` |
| Staying inside the boundary, resisting ceremony | `references/scope-control.md` |
| Device vs simulator, environment confounding | `references/environment-differential.md` |
| Writing the report | `references/reporting.md` |
| Where a rule came from, and its limits | `references/knowledge-provenance.md` |

## Hard Correctness Rules

Violating one of these is a defect, not a style choice.

- [ ] Every causal claim carries an evidence level.
- [ ] A cause is never asserted while a competing hypothesis remains unexcluded.
- [ ] "Regression" is never claimed without a baseline that was actually measured.
- [ ] "Fixed" is never claimed without a check that fails on the old behaviour.
- [ ] "No longer occurs" is never claimed from a single observation.
- [ ] A restoration is proven by hash **and** diff, never by diff alone — a diff says nothing about an ignored file.
- [ ] Numbers in a report come from the tool that produced them; totals are never reconstructed by hand.
- [ ] A destructive operation is never run without explicit authorisation naming that operation.
- [ ] A frozen subsystem is never modified without a demonstrated defect or an explicit requirement.
- [ ] Human validation is never recorded without a human verdict, at the grain it was given.
- [ ] `NOT DETERMINED` is used for anything outside the reach of available tools; it is never guessed.
- [ ] A conclusion from one environment is never generalised to all environments.
- [ ] Changes outside the agreed boundary are reported, not committed quietly.
- [ ] `PARTIAL` is never reported as `PASS`.
- [ ] A probe reporting that it is available is never reported as the skill being loaded, invoked or verified.

## Optional Improvement Rules

Offer these; do not impose them. If refused, record the refusal so it is not re-proposed.

- Make a rule executable — a test or a script — rather than leaving it in prose.
- Add a check for an **absence**; it often catches what review does not.
- Record a decision's reopening conditions when it was taken without complete proof.
- Prefer one shared source of truth to two that must be kept in agreement.
- Keep a restoration point before work that is hard to undo.

## Stop Conditions

Stop and hand the decision to a human when:

- branch or HEAD do not match what the mission expected;
- the change would fall outside the agreed boundary;
- a destructive operation appears necessary;
- the target is frozen and no defect has been demonstrated;
- two hypotheses survive and nothing available can discriminate them — report the ambiguity, do not resolve it by preference;
- an experiment's input may have been contaminated — a stale cache, an observing harness, a changed environment;
- the mission forbids the only route that would work — say so rather than obeying to the letter or working around it in silence;
- a required criterion cannot be evaluated;
- evidence contradicts a document, and you cannot tell which is stale.

## Tool Usage

All under `scripts/`. Every one is read-only, offline, free of telemetry, and refuses mutating git verbs.

| Tool | Use when |
|---|---|
| `repo_snapshot.py` | starting any non-trivial task; asserts expected branch and HEAD |
| `scope_audit.py` | before committing; proves the work stayed inside its boundary |
| `git_lineage.py` | before merging; often shows there is nothing to merge |
| `hash_manifest.py` | before an experiment touches files |
| `verify_restore.py` | after restoring; turns "I restored it" into a checkable fact |
| `handoff_check.py` | before a context reset; finds missing fields |
| `activation_probe.py` | when asked whether this skill is present; reports only what a probe can settle |

Exit codes: `0` fine · `1` the check ran and the answer is negative · `2` usage or environment error.
Each takes `--json` for machine use and `--help` for its arguments.

**On activation claims.** `activation_probe.py` reporting `STATUS=AVAILABLE` establishes one thing: the probe
shipped with this package executed, against an intact copy of it. It does not establish that this skill was
loaded, that it was invoked for the task at hand, or that it was verified at runtime — the probe reports those
three as `NOT DETERMINED` and names what would settle them. Anything that can print an answer can print a
reassuring one, so a probe's own output can never be the evidence that the probe's package is in use. Settling
that needs an observation made outside the agent, a task whose correct answer only a loaded skill produces, and
a negative control where the skill is absent and the answer differs.

## Human Validation Rules

- Automated and human evidence are two **domains**, not two grades. Neither outranks the other.
- Machines settle presence, value, conformance, non-regression, whether something fits.
- Humans settle perception, comfort, feel, real hardware, and whether wording is understood.
- An installation is not a visual validation. A build is not a judgement.
- Record the verdict at the grain given. A global "it passed" is recorded globally, not expanded into detail.

## Scope Boundaries

**In scope:** how to reason, verify, protect and validate; evidence discipline; investigation procedure; risk
grading; repository safety; gates; handoffs.

**Out of scope:** how to write code in any language or framework; architecture prescriptions; UI design;
domain-specific APIs. Those belong to a domain skill, which this one is designed to run alongside —
see `AGENTS.md`.

This skill does not own a project's documents. If it writes a ledger, it writes under its own namespace, so it
cannot collide with another skill that owns a file of the same name.

## Frozen Subsystem Behaviour

When a task would touch a subsystem recorded as frozen: stop, state the freeze and its reason, ask for the
demonstrated defect or the explicit requirement, and offer to reproduce the defect first. Do not negotiate the
freeze by making the change smaller. Detail in `references/frozen-subsystems.md`.

## Session Handoff Behaviour

Treat conversation memory as unreliable and the repository as authoritative. Before a context reset, write the
handoff from tool output. On resume, verify before acting, and compare what you find against what the document
claims. Report a mismatch; never silently correct one. Detail in `references/session-handoff.md`.
