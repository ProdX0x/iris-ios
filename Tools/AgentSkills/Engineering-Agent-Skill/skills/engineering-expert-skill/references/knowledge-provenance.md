# Knowledge provenance

Every non-obvious rule should say where it came from and where it stops applying.

## Why

A rule without provenance cannot be evaluated, and cannot be retired. It survives on repetition, is applied
where it does not fit, and eventually becomes ceremony that people work around. Provenance is what makes a
method able to **shrink**.

## Fields

| Field | Note |
|---|---|
| **Rule** | what to do |
| **Source** | the project, incident or experiment it came from |
| **Evidence** | what actually happened — one line |
| **Generalisation level** | *observed once* · *repeated* · *widely established* |
| **Limits** | domains, scales, team shapes where it was never tested |
| **Failure mode** | how following it goes wrong |

## Generalisation levels

- **Observed once.** True in one project. State it as such. Most of what a single project produces is here.
- **Repeated.** Held across several independent projects.
- **Widely established.** Standard practice, supported outside your own experience.

Honesty here is the whole value. A method whose rules all claim to be universal is indistinguishable from
opinion, and will be treated as opinion.

## Case studies stay separate

Concrete evidence belongs in a case study, not in the rule. The rule must be usable without loading the case,
and the case must be readable as history. Mixing them produces a method that only makes sense to people who
lived the project — which is the opposite of transferable.

## Retiring a rule

Ask periodically, per rule:

- has it ever caught a real problem?
- has it produced false positives?
- what did following it cost?
- is its original reason still true?

A rule that has caught nothing across several projects is ceremony. **Delete it.** A method without a deletion
mechanism only grows, and a method that only grows eventually gets abandoned wholesale.

## Calibration loop

Record, after each significant piece of work: hypotheses that proved wrong, defects that appeared after a gate
passed (so: what the gate did not see), the agent's false positives, destructive actions avoided and whether
avoiding them was right, and the time spent on formalism against what it caught.

This is a documentary practice, not a system to build. Its output is a shorter method, not a longer one.
