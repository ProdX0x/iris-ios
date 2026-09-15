---
name: iris-expansion-baseline
description: The authoritative starting point for future Iris expansion prototypes is branch baseline/iris-expansion-validated (Braises A + audio split kept, Braises B absent), with the calibration-distance hypothesis recorded but unverified
metadata:
  type: project
---

On 2026-09-12 the Braises experiments were consolidated into `baseline/iris-expansion-validated`, built from the clean ancestor `937d549` (phase A docs) plus two transplants: Braises A (from `416feb9`, level `0-1`, chapter "P", DEBUG only, tuning frozen by test `aIsFrozen`) and the audio split (from `aeafc28`: "Effets sonores" default on, "Ambiance sonore" default off, migration that never re-enables sound). Braises B, its texts, launcher, tests and the B1.3 lab readout are absent; the `prototype/*` branches are archives. `Design/BRAISES_VALIDATION_STATUS.md` is the authoritative Braises status; `Design/GAZE_CALIBRATION_DISTANCE_HYPOTHESIS.md` records the user's unverified observation that calibration feels more reliable at about 30 cm.

**Why:** the user wants the next prototypes (Rendez-vous, Phares, Souffles, or a different Braises depth) to start from validated ground only, never from a branch mixing rejected hypotheses.

**How to apply:** start any new prototype branch from the HEAD of `baseline/iris-expansion-validated`; never re-open a B1.x iteration; do not change Braises A's tuning, the audio defaults or the Gaze Engine because of the distance hypothesis without an explicit mission; On 2026-09-12 (S1) the baseline, `main` (fast-forward 6e1b726→52f20b7), `feature/game-expansion`, the four `prototype/braises*` archives and the annotated tag `baseline-expansion-v1` (peeled to d7e3a88) were pushed without force to the private GitHub repo `ProdX0x/iris-ios`, each ref verified with ls-remote; `feature/iris-v2` was left at 6e1b726 remotely as redundant with `main`. Any future push must stay non-forced and the repo must stay private (author e-mail and Claude session links live in the history). See [[iris-expansion-phase-a]] and [[iris-human-validation]].
