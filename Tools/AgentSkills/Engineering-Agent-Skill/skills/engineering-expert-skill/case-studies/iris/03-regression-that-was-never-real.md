# 03 — A regression that was never real

## Observation

The application was reported as feeling slower, and a physics behaviour was suspected of having regressed. Both
came from impression, after a period of heavy change.

## What was missing

A baseline. Nobody had measured the earlier behaviour. "Slower" had no *before*, and the physics suspicion had
no recorded reference run.

## What was done

Instead of tuning the suspected code, the investigation measured the current state: CPU, memory, frame pacing
and thermal behaviour across real sessions on two devices, with the parsing of the traces treated as its own
problem.

**That step mattered more than it looks.** The first trace parser, written with regular expressions, read 7 rows
out of 342. Used as-is, it would have produced the opposite conclusion about memory. It was caught by an
implausible order of magnitude, not by review, and replaced with a real parser.

## Result

No performance regression was reproduced. The suspected physics behaviour showed no measured deviation. The
frozen subsystem was left alone.

## Lessons

1. **No baseline, no regression claim.** At most, a report of the current value. A remembered baseline is not a
   baseline.
2. An instrument needs its own validation. A measurement tool is code, and it can be wrong in the direction that
   confirms you.
3. An implausible order of magnitude is the cheapest error detector available. Use it before trusting a number.
4. The correct outcome of a suspicion is often "nothing was wrong" — and that outcome must be recorded, or the
   suspicion returns.

## What this does not establish

That there was no regression — only that none was reproduced under the conditions measured. An intermittent or
condition-specific one remains possible, and the report said so.
