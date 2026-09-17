# Release gates

A point where you decide, with evidence, whether work may continue — and write down what is still unresolved.

## When a gate is justified

Two or more of:

- irreversible or externally visible effect (publishing, payment, user data);
- specialised hardware or an environment that cannot be fully reproduced;
- high cost of error;
- several subsystems touched at once;
- a decision only a human can take.

**When it is not:** a local change, reversible, covered by tests, invisible outside. Putting that through a gate
is over-engineering, and it teaches people to route around gates — see `scope-control.md`.

## Structure

| Field | Note |
|---|---|
| Objective | the one question this gate answers |
| Preconditions | branch, HEAD, expected state — verified, not assumed |
| Scope | what is in, and explicitly what is out |
| Acceptance criteria | written **before** the work, or they will be written to match the result |
| Automated evidence | real numbers from the runner; never a reconstructed total |
| Human evidence | recorded at the grain the human gave it |
| Exclusions | what this gate does not cover |
| Known issues | with evidence levels |
| Rollback point | the commit or tag to return to |
| Status | PASS · PARTIAL · FAIL · BLOCKED |
| **Reopening conditions** | what would reverse a decision taken without full proof |

## The two fields that carry the weight

**Acceptance criteria written first.** Criteria written afterwards describe what happened. That is a report, not
a gate.

**Reopening conditions.** A gate may close over an unexplained problem — that is often the right call. It is
only legitimate if the decision states the evidence level and what would reopen it. Without that, an unproven
cause silently becomes a settled one.

## Statuses

| | Meaning |
|---|---|
| **PASS** | every criterion met, with evidence |
| **PARTIAL** | some met; the rest named with what is missing |
| **FAIL** | a criterion is not met |
| **BLOCKED** | a criterion cannot be evaluated — missing access, absent hardware |

**PARTIAL is never rounded up to PASS.** A gate that never reports PARTIAL is not measuring anything.

## Four states that are not one state

Never let one imply another:

| State | Evidence needed |
|---|---|
| **Code ready** | builds, tests pass, audits pass |
| **Artifact ready** | the distributable artifact is correctly built and signed for its destination |
| **External services configured** | the accounts, products, agreements — verified, not assumed |
| **Submittable** | all three, plus the assets and metadata the destination requires |

Conflating these produces the most common release failure: a green test suite read as readiness to ship.

## Reporting

Say what is closed, what is open, what is unproven. A gate that reports only successes is not a gate — it is an
announcement.
