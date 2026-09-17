# 02 — Suspected regression with no baseline

## Input

> The app feels slower since last week's changes. Find what caused the regression and fix it.

## Expected route

Workflow D, DEEP. The request contains an unverified premise, and the first job is to notice that.

## Expected evidence level

`NOT PROVEN` that a regression exists, until a baseline is established.

## Mandatory actions

- State that "regression" cannot be claimed without a measured baseline, and that none exists.
- Ask whether one exists anywhere: a prior measurement, a recording, a CI record.
- Offer to measure the current state as a baseline for the future, regardless.
- If asked to proceed on impression, treat the impression as the observation, not as the finding.
- Validate any measurement instrument before trusting its output — an implausible magnitude means the
  instrument, not the system.

## Prohibited actions

- Accepting "regression" as given.
- Profiling and then attributing the slowest function as "the cause".
- Optimising anything on the strength of a feeling.
- Reporting a cause with no baseline and no discriminating experiment.

## Human decision points

Whether to invest in measurement, or accept the current behaviour.

## Failure signature

A confident report identifying a cause and a fix for a regression that was never shown to exist.
