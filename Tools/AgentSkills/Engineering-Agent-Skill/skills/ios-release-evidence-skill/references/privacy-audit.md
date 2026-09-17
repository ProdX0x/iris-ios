# Auditing a privacy claim against code

> **TIME-SENSITIVE.** Platform declaration formats and required-reason categories change. Re-verify.

## The rule

Never write "no data is collected" without saying **what you searched for**. An unqualified absence claim is
unfalsifiable, and it is the claim most likely to be quoted back at you.

Write instead: *searched for X, Y, Z across these directories; found N hits, each classified below.*

## Search by surface, not by intention

For network access, enumerate the surface by name: every client type, every request type, every connection API,
every low-level socket path, embedded web views, and literal URLs. Then **classify every hit** rather than
counting them:

- real input/output;
- a URL inside a comment or a document;
- a string intended for store metadata;
- a link that opens the system settings.

A raw count is meaningless; the classification is the evidence.

Do the same for analytics, crash reporting, advertising identifiers, tracking frameworks, and third-party
dependencies. For dependencies, inspect the built artifact's linked libraries as well as the manifests — that
answers the question directly.

## Retained versus processed

The distinction that matters for a sensor-driven application: data that is **processed and discarded** is not
collected.

Demonstrate it in the code path: show that the frame or sample is consumed inside the callback, that no property
holds it, and that nothing writes it. Then say what **is** derived and stored, exactly — a handful of
coefficients is a very different statement from "gaze data".

## Debug-only code

Instrumentation that writes files or logs personal-adjacent data must be proven absent from Release, not assumed
absent because of a conditional in the source. See `release-artifact-evidence.md` — including the
compiled-but-unreachable case.

## Logging

List what remains in Release and what each line can contain. "No sensitive data is logged" needs the inventory
behind it. Aggregate accuracy figures are not the same as coordinates, and that difference is worth stating.

## Declarations

Verify a privacy declaration is present **in the built bundle**, not merely in the project — especially where
the project file is generated and a resource can quietly stop being copied.

Then check each declared category against actual use, and confirm the undeclared ones really are unused by
searching for their APIs. A declaration that does not match the code is worse than none.

## Local persistence

Inventory every key and every file the application writes, and state what each contains. "It stores settings" is
not an audit. Note also where that storage ends up — device backups, for instance — so a claim can be made
precisely rather than defensively.
