---
name: iris-full-expansion
description: "Branch feature/iris-full-expansion (13 Sept 2026): chapters VII–XII built on top of baseline-expansion-v1; how the historical campaign is protected and what still needs a human on device"
metadata: 
  node_type: memory
  type: project
  originSessionId: f88478cc-d512-4210-bc11-758059278995
  modified: 2026-09-13T01:02:47.188Z
---

`feature/iris-full-expansion` (from tag `baseline-expansion-v1` = d7e3a88) carries the shared infrastructure commit `19f2b1c` then one commit per chapter: VII jumelles `6d17731`, VIII souffles `ae0ef43`, IX échos `393a566`, X gouffres `31ed0f7`, XI braises `d90f117`, XII constellation `8282ffd`. Campaign = 12 chapters, 70 levels, 210 éclats; 298 tests green; pushed normally to `origin` (never force, never into `main`). Report: `Design/IRIS_FULL_EXPANSION_REPORT.md`, README section 19.

**Why:** the user asked for direct autonomous production of the sequel (no prototypes, no questions) with chapters 1–6 untouchable; status labels must stay honest ("TECHNIQUEMENT VALIDÉ / À JOUER HUMAINEMENT", never "HUMAINEMENT VALIDÉ").

**How to apply:** the 34 historical levels are frozen by `Tests/IrisTests/Fixtures/historical_campaign.txt` (byte-for-byte dump) and by SHA-256 of `Campaign+*.swift` (I–VI), `AR/`, `GazeFilter.swift`, `TargetPhysics.swift` in `HistoricalCampaignFingerprintTests`; touching any of them means deliberately regenerating the fixture/hashes and saying why. New mechanics live in `LevelEnvironment` + `GameSession` hooks (per-target impulse queue, `BehaviourScale`, `canAccumulate`); the bot (`CampaignBot`) has ferry/twin/sleeper logic gated so historical levels behave as before. Screenshots with `--iris-gaze` never validate irises (the parked sample is not an active gaze), that is tooling, not a bug. The iPhone 14 Pro was unreachable at the end of the mission, so the expansion was never launched on device. See [[iris-expansion-baseline]] and [[iris-human-validation]].

**Human validation (14 Sept 2026):** the user reported the 12-chapter version as tested and validated by a human; annotated tag `iris-expansion-human-validated-v1` (object c6d9581) → 4bdb0ae, pushed to origin. This tag is now the reference point for any further work.
