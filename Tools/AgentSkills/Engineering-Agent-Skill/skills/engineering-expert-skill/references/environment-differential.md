# Environment differential

When the same artifact behaves differently in two places, or when the environment is suspected of producing the
behaviour being investigated.

## The design

Hold everything constant except one environment variable:

| Hold constant | Vary |
|---|---|
| the artifact — the same build, not a rebuild | one environment property |
| the installation path | |
| the launch path | |
| the configuration | |
| the measurement, and its exact command | |

Then measure both, and record the commands. Reproducibility is the point.

**A rebuild is not the same artifact.** If you rebuilt between the two runs, the build is now a second variable.

## What a difference proves, and does not

A measured difference proves **the environments differ in a way that reaches this behaviour**. It does not yet
say:

- which one represents real use;
- what mechanism produces the difference;
- that the difference is the one you changed deliberately — unless you can show nothing else varied.

Most environment investigations over-read the first result. The correct conclusion is usually
`STRONGLY SUPPORTED` for a dependency, `NOT PROVEN` for a mechanism.

## Test environments contaminate

The likeliest confounder is the machinery you used to observe. Watch for:

- a development tool that installs a local configuration alongside the artifact, persisting after the tool is gone;
- a debugger or profiler changing timing;
- a harness that reinstalls or resets state as a side effect of inspecting it;
- a runtime that refuses a capability another runtime supports — the same test can be meaningless in one and
  decisive in another;
- an override left over from an earlier session that nobody remembers setting.

**A reference environment, once contaminated, is no longer a reference.** Note how it was contaminated, because
that is usually how it will happen again.

## Protecting a reference environment

If one environment must stay representative of real use:

- write down what makes it representative;
- write down exactly which operations would break that — the specific tool, the specific path;
- prefer installation and launch paths that carry no tooling configuration;
- re-verify its state before relying on it, rather than assuming it held.

## Caches

Before concluding from a negative result — "I changed it and nothing happened" — ask whether the system read
your change or a cached copy. Tools hold configuration in memory; artifacts get reused; state persists across
what looks like a fresh run. Eliminate the cache, then rerun. Until then the result is `NOT PROVEN`, not
negative.

## Reporting

Give both measurements, both commands, and what was held constant. A differential result without its controls
cannot be re-examined, and will be misquoted.
