---
name: ios-release-evidence-skill
description: Use when establishing evidence about an Apple platform build or device rather than writing code — proving what a Release binary does or does not contain, telling a device measurement apart from a simulator one, distinguishing a local StoreKit test environment from sandbox or production, inspecting signing and provisioning before claiming a build is distributable, auditing privacy claims against the code, or deciding whether a device is still a valid reference. Also use when asked "is this Release-safe", "why does this device behave differently", "is this signed for distribution", "can we claim we collect no data", or "is this ready to submit". Requires macOS with Xcode command line tools. Does not write SwiftUI or app code — pair it with a domain skill for that.
---

# iOS Release Evidence Skill

An Apple-platform layer over `engineering-expert-skill`. It does not teach how to build an app; it establishes
what is **true** about a build, a device, or a claim — before someone says it in a release note.

> **TIME-SENSITIVE.** Apple's tooling, requirements and identifiers change with each release. Treat every
> specific below as a pattern to re-verify against current official documentation, not as a fact with a shelf
> life. What does not change is the shape of the question.

## Operating Rules

- Load `references/` in `engineering-expert-skill` for evidence levels. The levels used here are the same.
- Inspect the **built artifact**, not the project settings. Settings state intent; the artifact states outcome.
- Never conclude from one device that a behaviour is general. Two devices are a differential, not a population.
- Never claim submittability from a green test suite. See the four-state rule below.
- Prefer non-mutating device inspection. Reading a container file changes nothing; reinstalling changes a lot.

## Four states, never one

| State | Evidence |
|---|---|
| **Code ready** | builds, tests pass, layer audits pass |
| **Artifact ready** | the built bundle is signed for its destination, with the right entitlements |
| **Store configured** | products, agreements, accounts — verified in the store console, not assumed |
| **Submittable** | all three, plus required assets and metadata |

A green suite evidences the first only. Conflating these is the most common release overclaim.

## Task Workflows

### Prove what a Release build contains
1. Build the real Release artifact; do not reason from a Debug one.
2. Inspect the bundle: what is at its root, what frameworks are linked, what is embedded.
3. For a symbol, `nm` gives a usable presence/absence answer.
4. **For a short string, absence is not provable this way.** Compiled languages inline short literals into
   instructions — Swift stores small strings inside the structure itself. A symbol at zero occurrences is
   evidence; a short string not found is not.
5. Distinguish **compiled** from **reachable**. A type whose call sites are all compiled out still ships its
   symbols. Say "present but unreachable" — it is the honest description, and it is different from "absent".

### Tell a device measurement from a simulator one
1. Simulator runtimes differ from each other, not only from devices. A capability refused by one runtime may
   work on another — a test that degrades to a known issue on one can pass for real on another.
2. Keep an older runtime available as an instrument when a newer one refuses something.
3. A behaviour observed only in a simulator is `NOT PROVEN` for devices, and the reverse.

### Identify the store environment on a device
1. The transaction environment distinguishes a local test configuration from sandbox and from production. Read
   it; do not infer it from whether products appeared.
2. **Zero products with no error is a valid state**, not a failure — it is what a real customer sees before the
   store back end is configured.
3. A configuration attached to the development tool's run action changes what a physical device sees, and
   persists beyond that launch. A device that has received one is no longer a reference for real behaviour.
4. Installing and launching outside the development tool avoids attaching one. That is how a reference device
   stays a reference.
5. See `references/device-evidence.md`, and case study 01 in `engineering-expert-skill`.

### Inspect signing before claiming distributability
1. Read the signature of the **built bundle**, not the project configuration.
2. Check three things independently: the signing authority, the provisioning profile's application identifier,
   and the debug entitlement.
3. A development authority, a wildcard application identifier, or a debug entitlement each independently block
   store distribution — and a wildcard identifier also prevents in-app purchase from working at all.
4. Report each separately. "Signed successfully" is not "signed for distribution".

### Audit a privacy claim against the code
1. Never write "no data is collected" without saying what you searched for.
2. Search for the network surface by name — every client type, every connection API, every URL literal — and
   classify each hit rather than counting them.
3. Distinguish what is **retained** from what is **processed**. A sensor frame consumed and discarded is not
   collected; the distinction has to be demonstrated in the code path.
4. Separate what only exists in debug builds, and prove the separation in the artifact.
5. Verify a privacy manifest is **in the built bundle**, not merely in the project — especially when the project
   file is generated.
6. See `references/privacy-audit.md`.

### Validate on a physical device without destroying its state
1. Reading a file from an application's container is non-destructive. Prefer it to reinstalling.
2. A locked device refuses a launch. That is an environment fact, not a failure of the build.
3. Uninstalling removes the container — inventory what that holds before proposing it.
4. See `engineering-expert-skill/references/destructive-operations.md`.

## Topic Router

| Topic | Reference |
|---|---|
| Device vs simulator, store environments, reference devices | `references/device-evidence.md` |
| Signing, provisioning, distribution readiness | `references/signing-and-distribution.md` |
| What a built artifact does and does not prove | `references/release-artifact-evidence.md` |
| Auditing privacy claims against code | `references/privacy-audit.md` |

## Hard Correctness Rules

- [ ] Claims about a build come from the built artifact, never from project settings.
- [ ] "Absent from the binary" is claimed only where the instrument can prove absence.
- [ ] "Compiled but unreachable" is never reported as "absent".
- [ ] A store environment is read, never inferred from whether products appeared.
- [ ] Zero products is reported as a state, not a failure.
- [ ] Signing authority, application identifier and debug entitlement are reported separately.
- [ ] A privacy claim names what was searched for.
- [ ] A one-device observation is never generalised.
- [ ] Store console state is `NOT DETERMINED` unless the console was actually consulted.

## Stop Conditions

- a device would have to be reinstalled or reset to obtain the evidence — propose it, do not do it;
- the only available device is known to be contaminated — say so rather than measuring it anyway;
- a conclusion would require store console access that you do not have;
- the instrument cannot distinguish the two answers — for example proving a short string absent.

## Scope Boundaries

**In scope:** evidence about Apple builds, devices, signing, store environments and privacy claims.

**Out of scope:** writing UI or app code, framework guidance, architecture. Those belong to a domain skill such
as a SwiftUI expert skill, which this is designed to sit alongside.
