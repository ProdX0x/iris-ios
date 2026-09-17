# Evidence levels

Read this first, on every task. Everything else in this skill depends on it.

## Why this exists

An agent writes fluent, confident prose. A correlation described well reads exactly like a cause. The level is
what keeps them apart — and what lets a reader decide how much weight a sentence can bear.

## The levels

### MEASURED / OBSERVED
A value a tool returned, with the command and when it ran.

- **May claim:** the value, the command, the moment.
- **May not claim:** what it implies. A measurement is an input to a conclusion, not a conclusion.
- **Example:** `at 13:47:12Z the store returned 0 products` — not `the store is misconfigured`.

### PROVEN
Established by a deterministic check that would fail if the claim were false, and that can be re-run.

- **May claim:** the fact, within the exact boundary that was checked.
- **May not claim:** anything beyond that boundary — another build, another device, another input.
- **Test:** can someone else re-run this and get the same answer? If not, it is not PROVEN.
- **Example:** `the release binary contains 0 symbols matching X` (from `nm`) — bounded to that binary.

### STRONGLY SUPPORTED
One variable changed and the outcome changed with it, but the mechanism was never observed.

- **May claim:** the dependency — *the outcome depends on this variable*.
- **May not claim:** the mechanism — *the cause is X because Y happens internally*.
- **Required wording:** say what the evidence makes unnecessary, not what it makes false.
  *"Hypothesis B is no longer needed to explain the results"* — never *"hypothesis B is false"*.
- **Also required:** name what you tried that failed to discriminate further.

### NOT PROVEN
Several hypotheses remain compatible with everything observed.

- **May claim:** the observations, and the list of survivors.
- **May not claim:** any of them. Not even the most plausible.
- This is a **useful** result. Reporting an ambiguity honestly is what makes the next experiment possible.
  Resolving it by preference destroys that.

### NOT DETERMINED
Outside the reach of the tools available.

- **May claim:** that it was not checked, and precisely what access would settle it.
- **May not claim:** a likely value. An unconsulted external service has no known state.
- Distinct from NOT PROVEN: NOT PROVEN means the evidence is insufficient; NOT DETERMINED means there is no
  evidence at all, and says what would produce some.

## Forbidden claims

| Never say | Unless |
|---|---|
| "X causes Y" | every competing hypothesis is excluded, and you can name how |
| "this is a regression" | a baseline was measured before the change, not recalled |
| "fixed" | a check exists that fails on the old behaviour and passes on the new |
| "resolved" | the cause is established, or you write that the symptom stopped without a known cause |
| "production ready" | each of code / artifact / external configuration / submission is separately evidenced |
| "human validated" | a human gave a verdict; record it at the grain they gave it |
| "no longer happens" | it was intermittent and you observed it once; say how many times you looked |
| "works" | you say on what, in which configuration, and how many times |

## Reporting shape

State the claim, then the level, then the boundary:

> The release binary contains no developer diagnostics. **PROVEN** — `nm` reports 0 occurrences of the four
> symbols, on the signed build of commit `abc1234`. Says nothing about any other build.

> The behaviour depends on the local configuration. **STRONGLY SUPPORTED** — the only difference between the two
> runs was that variable, and the outcome inverted. The internal mechanism was not observed; three attempts to
> discriminate further are recorded below.

## Failure modes

- **Level inflation over time.** A STRONGLY SUPPORTED finding gets summarised into a later document as PROVEN,
  then quoted as fact. Carry the level with the claim every time it is repeated.
- **Collapsing NOT PROVEN into NOT DETERMINED**, or the reverse. The first calls for a better experiment; the
  second calls for access.
- **Level as decoration.** Writing `PROVEN` next to something nobody could re-run. The label must survive being
  challenged.
- **Too many levels.** Five is the working maximum. Beyond that, readers stop distinguishing them.
