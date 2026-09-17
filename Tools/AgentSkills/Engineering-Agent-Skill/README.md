# Engineering Agent Skill

**Decide what to prove, what to protect, and when to stop.**

A skill package for AI agents working on software. It does not write features — a domain skill does that. It
handles the part that goes wrong quietly: claiming a cause that was never established, destroying something a
reversible experiment could still have tested, refactoring code that took a human day to validate, or shipping
on the strength of a green test suite.

## What it is

| | |
|---|---|
| `skills/engineering-expert-skill` | the main skill: a router over 15 references, 11 workflows, 6 tools |
| `skills/ios-release-evidence-skill` | optional Apple-platform evidence layer |
| `.agents/skills/extract-validated-lessons` | maintenance: turns experience into rules, and retires rules |
| `evals/scenarios` | 10 behavioural scenarios, including one that fails on over-engineering |
| `tests` | the tools, the routing, the manifests, tool safety, portability |

## What it is not

- Not an architecture opinion. It takes no position on MVVM, layering or folder shape.
- Not a code generator. Pair it with a domain skill.
- Not a universal method. It comes from one project — see `NOTICE.md`, and believe the caveats.
- Not a process to apply uniformly. Applying it to a typo is the failure it warns about.

## Why it exists

An agent writes fluent, confident prose. A correlation described well reads exactly like a cause. Over one
project, five real agent errors were caught — none by the agent's own caution, all by an external control: a
test, a human adding up two numbers, an implausible order of magnitude. That is the argument for executable
checks and named evidence levels, and it is the argument this package is built on.

## Architecture

```
                         a task arrives
                               │
                    ┌──────────▼──────────┐
                    │  classify the risk  │   LIGHT · STANDARD · DEEP
                    └──────────┬──────────┘
                               │
                    ┌──────────▼──────────┐
                    │ establish ground    │   repo_snapshot.py
                    │ truth with a tool   │   (never from memory)
                    └──────────┬──────────┘
                               │
                    ┌──────────▼──────────┐
                    │  check frozen areas │   refuse, or demand a defect
                    └──────────┬──────────┘
                               │
                    ┌──────────▼──────────┐
                    │  route the topic    │──►  references/*.md  (loaded on demand)
                    └──────────┬──────────┘
                               │
                    ┌──────────▼──────────┐
                    │ competing hypotheses│   at least two, or it is a belief
                    └──────────┬──────────┘
                               │
                    ┌──────────▼──────────┐
                    │ least destructive   │   hash_manifest → measure → restore
                    │ discriminating test │   → verify_restore
                    └──────────┬──────────┘
                               │
                    ┌──────────▼──────────┐
                    │ classify the evidence│  PROVEN · STRONGLY SUPPORTED
                    └──────────┬──────────┘  · NOT PROVEN · NOT DETERMINED
                               │
                 ┌─────────────┼─────────────┐
                 ▼             ▼             ▼
              decide         STOP        escalate to
                             (9 named     a human
                              conditions)
                               │
                    ┌──────────▼──────────┐
                    │ report + scope_audit│
                    └─────────────────────┘
```

## How routing works

`SKILL.md` stays small: operating rules, a mode selector, 11 task workflows, a topic router, hard rules, stop
conditions. Everything else lives in `references/` and is loaded **only when its topic is in play**.

One reference is read every time — `references/evidence-levels.md` — because everything else depends on it.

The integrity tests fail if the router points at a file that does not exist, or if a reference exists that
nothing routes to.

## How references work

Each answers one question, in the same shape: what it is for, the procedure, exceptions, failure modes. They
name no product and contain no absolute paths — a portability test enforces that, so the skill can move to
another project unchanged.

Concrete evidence lives in `case-studies/`, which the main skill never loads. Read a case when you want to know
why a rule exists, or whether it applies to you.

## How the tools work

Seven read-only command-line tools under `skills/engineering-expert-skill/scripts/`:

| Tool | Answers |
|---|---|
| `repo_snapshot.py` | what state am I actually in — and is it the state I was told to expect? |
| `scope_audit.py` | did this work stay inside its boundary? |
| `git_lineage.py` | is this already contained, or does it really need merging? |
| `hash_manifest.py` | what exactly is here, before I touch it? |
| `verify_restore.py` | did I really put it back? |
| `handoff_check.py` | could someone resume from this document? |
| `activation_probe.py` | is this package's probe executable here — and what does that *not* prove? |

```
exit 0  fine
exit 1  the check ran and the answer is negative   ← a finding, not a crash
exit 2  usage or environment error
```

All take `--json` and `--help`. None writes to a repository, opens a network connection, reads an environment
variable, or can run a mutating git verb — `gitio` refuses anything outside a read-only allow-list before a
process is spawned.

## How evidence works

Five levels, and what each licenses:

| Level | May claim | May not claim |
|---|---|---|
| `MEASURED` | the value, the command, the moment | what it implies |
| `PROVEN` | the fact, inside the boundary checked | anything outside it |
| `STRONGLY SUPPORTED` | the dependency | the mechanism |
| `NOT PROVEN` | the observations and the surviving hypotheses | any of them |
| `NOT DETERMINED` | that it was not checked, and what would settle it | a likely value |

The rule that does the work: *"hypothesis B is no longer needed to explain the results"* is a different claim
from *"hypothesis B is false"*, and only the first is usually earned.

## How activation is proven

`activation_probe.py` exists because "the skill is active" is the easiest false claim an agent can make, and the
hardest to catch: it costs nothing to say and looks like a status report.

```bash
python3 skills/engineering-expert-skill/scripts/activation_probe.py --json
```

```
SKILL_ID=engineering-expert-skill
PACKAGE_VERSION=1.0.1
PROBE_ID=ENGINEERING-EXPERT-ACTIVATION-PROBE-1
STATUS=AVAILABLE
```

**What `STATUS=AVAILABLE` proves.** The probe file that ships with this package was executed by this
interpreter, the tree around it is complete, and the version it declares agrees with the package manifest.
`STATUS=DEGRADED` (exit 1) means the probe ran and one of those failed — which is a finding, not a crash.

**What it does not prove.** Three things, and the probe prints them as `NOT DETERMINED` rather than leaving
them to be assumed:

| Claim | Why the probe cannot settle it |
|---|---|
| `SKILL_LOADED` | a file being readable says nothing about an agent having read it |
| `SKILL_INVOKED` | the probe cannot see whether the skill shaped the answer to your task |
| `RUNTIME_VERIFIED` | that needs behaviour observed under real use, not a manifest check |

There is a deeper limit, and it is the point: **a probe's own output can never be the evidence that the probe's
package is in use.** Anything that can print an answer can print a reassuring one. The probe is therefore a
necessary piece of evidence, never a sufficient one.

**What a full activation verdict needs**, of which the probe is one part:

1. **The probe** — this package's own tool, run against this copy.
2. **A system-level observation** — the run captured outside the agent, so its having happened is not taken on
   the agent's word. `--nonce` echoes a token into the output for correlating the two; it authenticates
   nothing on its own.
3. **A distinctive runtime task** — a question whose correct answer only a loaded skill produces. Asking "is
   this a regression?" without a baseline is one: the skill's answer refuses the premise and offers to measure
   a baseline first.
4. **A negative control** — the same task with the skill absent. If the answer does not change, the first three
   proved the file exists, not that it was used.

Steps 1 and 2 without 3 and 4 establish presence, not activation. Report it that way.

## Install

See `INSTALLATION.md`. Structural support exists for Claude, Codex/OpenAI and Cursor; none has been verified at
runtime, and the document says so per environment.

## Test

```bash
python3 -m unittest discover -s tests -t . -v
```

No third-party dependencies. The tests build their own throwaway git repositories and never touch yours.

## Update

Use `extract-validated-lessons` after a project, an incident or a gate. It classifies candidates before they
become rules, keeps single occurrences out of the hard rules, proposes retirements as well as additions, and
never edits without human review.

## Build the package

```bash
python3 scripts/build_release.py --output ~/Desktop --verify
```

Produces a zip including the dot-directories, plus `RELEASE-MANIFEST.json` with a SHA-256 per file, and reopens
the archive to check it.

## Combining with a domain skill

Load both. A SwiftUI expert skill says how to write the view; this one asks whether the file it sits in is
frozen, whether the regression is real, and what a passing build entitles you to claim.

This package writes under its own namespace and claims no project document, so it cannot collide with a skill
that owns files of its own.
