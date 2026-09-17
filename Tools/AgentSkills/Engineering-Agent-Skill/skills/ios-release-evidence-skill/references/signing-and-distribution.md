# Signing and distribution

> **TIME-SENSITIVE.** Requirements and names change with each platform release. Re-verify before quoting.

## Inspect the artifact

Project settings state intent. The built bundle states outcome. They diverge — a generated project, a stale
derived artifact, a profile chosen automatically. **Read the signature of the bundle you would actually ship.**

## Three independent blockers

Check each separately and report each separately.

| Property | Development | Store distribution |
|---|---|---|
| Signing authority | a development identity | a distribution identity |
| Application identifier in the profile | often a wildcard | must be explicit |
| Debug entitlement (task access) | present | must be absent |

Any one of them alone prevents store distribution. A wildcard identifier has a second consequence: **in-app
purchase cannot work at all**, so a purchase that "fails on device" may be a provisioning fact rather than a
code defect.

"Signed successfully" means the build was signed. It does not mean signed for distribution. Never let the first
stand in for the second.

## What a successful build proves

That the code compiles and links for the target. Nothing about:

- whether the artifact may be distributed;
- whether the store knows the product identifiers;
- whether the required agreements exist;
- whether the assets required for submission exist.

## Store console state

If the console was not consulted, its state is `NOT DETERMINED`. Not "probably configured". An unconsulted
external service has no known state, and the failure mode of guessing is that a device reporting zero products
gets diagnosed as a code defect.

## Reporting

Report signing as a set of facts with their sources:

```
authority            <what the bundle is signed with>
team identifier      <value>
profile identifier   <explicit or wildcard>
debug entitlement    <present or absent>
```

Then state which of the four release states (code / artifact / store / submittable) each fact supports. Do not
compress them into a single verdict.
