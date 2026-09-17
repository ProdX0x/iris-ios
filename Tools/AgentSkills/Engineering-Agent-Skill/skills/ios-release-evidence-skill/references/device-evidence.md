# Device evidence

> **TIME-SENSITIVE.** Tool names and flags change. Re-verify against current official documentation.

## Devices, simulators and runtimes are three things

A simulator is not a device: different processor, different camera, different sensors, different store
behaviour. A simulator **runtime version** is also not another runtime version — a capability refused by one can
work in another. Treat "it passed in the simulator" as bounded to that runtime.

Practical consequence: when a test degrades into a known issue because a runtime refuses a facility, the test has
asserted **nothing**. Keep an older runtime available as an instrument, and re-run there before believing the
suite is green.

## Store environments

The transaction environment is the reliable discriminator between a local test configuration, a sandbox account,
and production. **Read it.** Do not infer it from whether products appeared, because both a working local
configuration and a working production account produce products.

| Symptom | What it means |
|---|---|
| products returned, environment says local test | a test configuration is active — not real behaviour |
| zero products, no error | a valid state: nothing configured on the back end yet |
| zero products, an error | a failure — report the error, do not merge it with the case above |

**Zero products is not a bug.** It is what a customer sees before a store back end exists. Reporting it as a
failure sends people to fix something that is not broken.

## Reference devices

A reference device is one whose behaviour still represents real use. It is fragile.

A store configuration attached to the development tool's *run* action applies to a physical device and persists
past that launch. One run is enough to make a device stop being a reference — and the effect can outlive the
obvious causes, so do not assume a reinstall clears it.

To preserve one:

- install and launch it with the command-line device tooling, never the development tool's run action;
- or set the configuration to none before any run that targets it;
- keep a **second** device as the development device, and never confuse the two;
- re-read the environment before relying on the device, instead of assuming it held.

Write down which device plays which role, and what specific operation would break it. "Be careful with the test
phone" is not a usable instruction.

## Non-destructive device inspection

Prefer reading to reinstalling. Copying a file out of an application's container changes nothing about the
device; reinstalling can wipe the container, and the container is where calibration, preferences and any local
diagnostic log live.

A locked device refuses to launch an application. That is an environment condition, not a defect — report it
and ask for the screen to be unlocked rather than concluding anything about the build.

## Reporting a differential

Give both measurements, both exact commands, and what was held constant. A difference proves the environments
differ in a way that reaches the behaviour. It does not say which one is real, and it does not give a mechanism.
