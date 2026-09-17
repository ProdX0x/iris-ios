# 01 — A destructive fix replaced by a reversible experiment

## Observation

A physical test device had previously returned **zero** purchasable products — the correct behaviour for a
product whose store back end was not yet configured, and the reason that device was valuable: it showed what a
real customer would see. Three weeks later the same device returned **two** products at a price, and reported
its transaction environment as a local test environment. The reference device had been contaminated.

## Hypotheses

- **A** — a local store configuration attached to the development tool's *run* action, applied at launch.
- **B** — a persistent test environment stored on the device itself, surviving reinstallation.
- **C** — something tied to the installed build.

C was excluded by an existing measurement: the same build, installed by a command-line tool, had produced the
clean result earlier.

## The first instinct, and why it was wrong

The obvious remedy — documented by the platform vendor — was to **uninstall the application**, which would
remove its local data. That data included a calibration profile the user had produced by hand.

Inventorying it first produced a surprise in the other direction: there was no game progress stored at all. The
stakes were smaller than feared. But the inventory also made the real question visible — *would uninstalling
even help?* Under hypothesis A it would not.

## The experiment

Discriminating variable: the store configuration attached to the run action. Least invasive test: set it to
none, launch, measure, restore.

Controls: a hash of the configuration file before, during and after; a targeted diff showing **only** the
expected removal; a backup of the device's three data files, hashed, outside the repository; a pristine copy of
the file for byte-exact restoration; the launch destination pinned explicitly so it could not land elsewhere.

**Result: unchanged.** Still the local test environment.

## Why that result was not believed

The development tool had been **open** while the file was edited, and could have served a copy held in memory.
Two readings survived:

- **B1** — the setting was applied and the environment survived it;
- **B2** — a cached setting was used, so the run re-asserted the environment and the test showed nothing.

Three attempts to separate them failed, and were recorded: the tool's own run record mentioned the store in
neither run — *including the one that definitely used it*, which invalidated that check as evidence; the build
logs contained one identical, unrelated occurrence; and no command-line tool on the platform could read or write
that state.

Reported conclusion: **NOT PROVEN**, with both readings named.

## The second experiment

One change: **close the tool before editing the file**, reopen it afterwards.

```
tool open while editing   → local test environment, 2 products, a price
tool closed while editing → no environment, 0 products, no price
```

A third reading, from the application launched with the tool closed entirely, confirmed it.

## Conclusion, at its real level

```
Effect of the run configuration     STRONGLY SUPPORTED
Historical cause of the activation  NOT PROVEN
```

The wording kept: *the observed behaviour is explained by the run configuration, and the persistent-device-state
hypothesis is no longer needed to account for the results.* Not: *the state was in the configuration and not in
the device.* The mechanism was never observed.

Nothing was uninstalled. No device was restarted. No data was lost. The configuration was restored byte for
byte, confirmed by hash and by an empty diff.

## Lessons

1. A plausible hypothesis that recommends a destructive action mostly recommends **destroying your ability to
   test it**.
2. Inventorying what would be lost changes decisions — in both directions — and only helps before the fact.
3. An ambiguous result reported as ambiguous is what makes the next experiment possible. The first experiment
   here produced nothing; reporting it as nothing produced everything.
4. Your tools cache. A negative result from a possibly-cached input is `NOT PROVEN`, not negative.

## What this does not establish

It does not prove the method is generally better — there was no control. It does not prove the device state was
irrelevant; it proves it was unnecessary as an explanation. And the reversible route was available and cheap
here, which is not universal: sometimes there is no reversible experiment, and the case says nothing about that.
