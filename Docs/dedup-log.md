# Dedup log

## 2026-09-11
Scope: whole project (106 Swift files)

Pass A (exact and near duplicates)
- D-01 `GameViewModel`: `clock.stop()` followed by the crescendo silencing appeared five times (pause, restart, suspend, level completion, teardown) and the failure path twice. Extracted `haltLoop()` and `fail(_:)`. Applied.
- D-02 `GameSceneRenderer`: five hand-built circle paths. Extracted `circle(center:radius:)`. Applied earlier in the session.

Pass B (semantic duplicates)
- Sphere shading colours: the reference engine computes `base +40 / -30` per channel at draw time; Iris stores the four resulting colours as tokens (`ds.scene.sphereLight/Dark`, `ds.scene.sphereValidatedLight/Dark`) so no colour arithmetic is duplicated in Swift. Kept.
- Level difficulty appears once (`LevelDifficulty.band`), constants once (`PhysicsConstants`, `ValidationRules`); tests reference them through the types. Kept.
- Error-to-message mapping exists once (`GameFailure.title/message`). Kept.

Pass C (dead code)
- `Tests/IrisTests/Fixtures/golden_generator.js` is a test fixture (documentation of how the traces were produced), not app code. Kept.
- `GameSession.replaceTargets(_:)` and `placeGaze(at:)` are test and preview hooks, referenced by tests and previews. Kept.
- No unused type found by `Tools/audit.py` cross-reference (every type is referenced outside its own file, except entry points and previews).
- `.gitkeep` placeholders removed once folders got content.

Pass D (layer leaks creating duplication)
- No rule duplicated in Presentation: `GameViewModel` never re-implements validation or ordering; it only consumes `GameEvent`.

Applied: D-01, D-02. Skipped: none. Files touched: 2.

## 2026-09-11 (Gaze Engine v2)
Scope: AR/Calibration, AR/Services, Features/GazeSetup, Features/Game

- D-03 `GameViewModel` and `GazeSetupViewModel` both release the shared gaze tracker: factored into `releaseGaze()` / `teardown()` guarded by an ownership flag (also fixes a transition race). Applied.
- D-04 The pointer-to-raw-sample inversion exists once in `SimulatedGazeTrackingService.makeSample` (app) and once in the test probe `SimulatedGazeTrackingServiceProbe` (tests need it without a main-actor instance). Accepted duplication, documented.
- D-05 Calibration and validation reuse one `FixationSequence` state machine; only the sample transform (nominal vs calibrated) differs. Kept single implementation.
- X-03 Removed `GazeProjector`, `DisplayGeometry` (replaced by `GazeRay`, `NominalDisplayGeometry`, `GazeMapper`) and the manual mirror setting with its test.
