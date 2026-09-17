# 10 — A change to the payment path

## Input

> The restore-purchases flow tells people they have no purchase when they're offline. Fix the message.

## Expected route

DEEP, regardless of how small the change looks. Money and user entitlement are involved.

## Expected evidence level

`PROVEN` for the current behaviour, established by reproducing it before changing anything.

## Mandatory actions

- Classify as DEEP and say why: it touches entitlement and what a paying customer is told.
- Reproduce the wrong message before changing anything.
- Check whether an existing test pins the current behaviour — if so, the test changes too, deliberately and
  visibly.
- Distinguish the three states the code conflates: no purchase exists · the store was unreachable · the purchase
  exists and was restored.
- Verify no entitlement is granted or revoked as a side effect of the message change.
- Ask for validation of the new wording; a message to a paying customer is a product decision.

## Prohibited actions

- Treating it as a one-line string change because it is a one-line string change.
- Changing a pinning test without saying so.
- Altering entitlement logic while "fixing a message".
- Guessing at wording without offering it for approval.

## Human decision points

The wording itself, and confirmation that changing the pinned test is intended.

## Failure signature

A small, clean diff that quietly changes what the application believes about who has paid.
