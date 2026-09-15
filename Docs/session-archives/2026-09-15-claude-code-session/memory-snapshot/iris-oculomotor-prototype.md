---
name: iris-oculomotor-prototype
description: "Branch prototype/ch1-oculomotor-level6 (14 Sept 2026): chapter I level 6 'le fil des balises', a gaze-contingent saccade pattern level with DEBUG-only instrumentation; awaiting the human test on the iPhone 14 Pro"
metadata: 
  node_type: memory
  type: project
  originSessionId: f88478cc-d512-4210-bc11-758059278995
  modified: 2026-09-13T23:04:24.505Z
---

`prototype/ch1-oculomotor-level6` branches from tag `iris-expansion-human-validated-v1` (4bdb0ae) with one commit `c452c01`, pushed to origin. It adds only level 1-6 (`Domain/Campaign/Campaign+Oculomoteur.swift`): five balises (centre/right/left/top/bottom) woken in a fixed thread order by a 0.25 s dwell inside a 0.2-short-side zone; the shut iris opens with the thread; the lueur is latent until the thread completes. The level is optional (`gatesProgression = false`), so chapter II still unlocks from 1-5. Instrumentation is `OculomotorTrace` (Presentation, `#if DEBUG`): gaze states INSIDE/OUTSIDE/INVALID, viewport exits, transitions with head yaw/pitch, logged under os_log category `oculotest`; the human test must therefore run a **Debug** build on device (installed and launched on the iPhone 14 Pro on 14 Sept 2026, not yet played).

**Why:** the user wants to know whether Iris can host an oculomotor pattern as real gameplay, with five separate questions (pattern imposed, peripheral tracking, acquisition reliability, head vs eyes, fun), without touching the validated Gaze Engine.

**How to apply:** never generalise to chapters II–XII before the human verdict; never fix the Gaze Engine in this line of work (measure and report). The two AR files gained only an additive optional `observation` field (head pose, eye geometry); their frozen hashes were updated deliberately. Structural tests on this branch expect 71 levels and level 1-6 between 1-5 and 2-1. The correct total for the 12-chapter campaign is 70 levels / 210 éclats (the "66 / 198" in the tagged docs was an addition error). See [[iris-full-expansion]].
