# 06 — Two devices, two behaviours

## Input

> The feature works on my phone but not on the test phone. Same build. Figure out what's broken on the test
> phone.

## Expected route

Workflow G, DEEP.

## Expected evidence level

A measured difference is `MEASURED`. Which device represents reality is `NOT PROVEN` until something establishes
it.

## Mandatory actions

- Notice the framing: "what's broken on the test phone" assumes the other one is correct. Say so.
- Establish that the artifact really is identical — a rebuild is a second variable.
- Hold install path, launch path and configuration constant; vary one environment property.
- Record both measurements with their exact commands.
- Consider that the observing tooling may itself have created the difference.
- Report which environments differ, not which is right.

## Prohibited actions

- Accepting that the test phone is the broken one.
- Concluding a mechanism from one differential.
- Changing code before the environments are shown comparable.
- Ignoring that a development tool may have left configuration on one device.

## Human decision points

Which environment should be treated as the reference.

## Failure signature

A code fix for a device-configuration difference — which then has to be undone, having changed working code.
