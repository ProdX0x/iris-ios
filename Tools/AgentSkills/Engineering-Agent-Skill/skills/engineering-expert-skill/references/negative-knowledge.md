# Negative knowledge

What a project has learned **not** to conclude, do, or assume. It is expensive to acquire and trivially lost.

## Why keep it

An excluded hypothesis costs an experiment. A destructive action avoided cost an investigation. None of it is
visible in the code, so the next session — or the next agent — pays for it again, and often reaches the same
wrong first instinct. Positive knowledge lives in the code; negative knowledge lives nowhere unless written.

## What qualifies

| Kind | Example shape |
|---|---|
| Invalidated hypothesis | "we believed X caused Y; the experiment excluded it" |
| Avoided operation | "deleting Z was proposed; it would not have helped, and here is why" |
| False regression | "a slowdown was suspected; no baseline supported it, and it never reproduced" |
| Unproven cause | "the incident was closed without an established cause; the evidence was …" |
| Non-discriminating method | "this measurement cannot separate the hypotheses, because …" |
| Misleading environment | "this setup produces results that do not reflect real use" |
| Instrument blind spot | "this tool cannot prove absence for that class of thing" |

## The form

Four lines is enough:

```
CLAIM       what must not be concluded or done
FACT        the observation that forbids it
DATE/SCOPE  when, and where it applies
STILL TRUE IF   the condition under which it stops applying
```

The last line matters: negative knowledge can expire. A tool gains a capability; an environment is fixed. An
entry with no expiry condition eventually becomes superstition.

## Where it goes

In the durable knowledge document, not the state handoff. It outlives branches.

## In reports

When a report concludes `NOT PROVEN`, list what was ruled out and what failed to discriminate. That list is the
next investigator's starting point, and without it they begin where you began.

## Failure mode

**Keeping only the successes.** A report that records what worked and drops the three approaches that did not
looks cleaner and is worth less. The failures are what stop the next person repeating them.

Second failure mode: **turning negative knowledge into a rule that outlives its reason.** "We never touch that
module" survives long after the reason expired, because nobody wrote the reason down. Hence the fourth line.
