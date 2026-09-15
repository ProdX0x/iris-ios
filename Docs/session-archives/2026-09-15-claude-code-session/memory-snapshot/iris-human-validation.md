---
name: iris-human-validation
description: Results of the human TrueDepth validation of Iris on iPhone 14 Pro (2026-09-12) and the design constraints it imposes on future levels
metadata:
  type: project
---

On 2026-09-12 the user played Iris on their iPhone 14 Pro with the real Gaze Engine v2: calibration works (good run 10 % mean / 17 % max error; a poor run at 17 % / 39 % was correctly refused by the 18 % / 30 % thresholds), gameplay felt fluid, the phone is held in its normal orientation. Gaze Engine v2 is considered validated enough to start game design.

Two observations are design constraints, not bugs to fix: hand-held micro-movements of the phone influence the apparent gaze (less on a stand), and the debug gaze point can leave the screen when looking at the extreme edges or diagonals.

**Why:** the user explicitly forbade "repairing" the Gaze Engine, calibration, projection or clamping for these; future levels must not require an unrealistic stillness or prolonged extreme precision.

**How to apply:** do not touch projection, calibration thresholds, axis resolution, smoothing or edge policy without an explicit request; a future debug-only improvement may show an edge indicator or arrow for off-screen points. Haptics were restored the same day (Haptics layer, shared 150 ms loss guard, see README § 15). Next planned phases: game expansion (new chapters) on `feature/game-expansion`, then StoreKit (chapters 1 and 2 free, single purchase for the rest). See [[iris-project-setup]].
