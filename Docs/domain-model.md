# Domain Model

## Entities

Campaign (Design/GAME_DESIGN.md, Design/LEVEL_DESIGN_SYSTEM.md):
- LevelDefinition (Campaign). chapter, index, title, principle, introduces [GameElement], ordered, zone (fraction of short side), repulsionForce, attraction, noise, hold, lueurs [LueurDefinition], currents, veils, veilleuses, hints [LevelHint], par LevelPar. Id "chapter-index".
- LueurDefinition. start, iris (NormalizedPoint), temperament, irisMotion, route [NormalizedPoint].
- ChapterDefinition. number, name, principle, ambientFrequency, levels.
- CampaignProgress (Progress). records [id: LevelRecord], totalPlayTime, encounteredElements. LevelRecord: completions, bestTime, fewestIntrusions, eclats.

Engine (prototype core):
- Target (Game). id: TargetID(sequence), position: Vector2, velocity: Vector2, arrival: Vector2, attentionZone, repulsionGain, passiveAttraction, noiseAmplitude, requiredHoldTime, holdTime, isValidated. Invariants: holdTime >= 0; isValidated implies holdTime >= requiredHoldTime at validation time; holdTime resets to 0 on loss.
- Level (Game). id: LevelID, number 1...14, targets [TargetBlueprint] ordered by sequence, holdDuration 0.75 s, isSequential = targets.count > 1.
- TargetBlueprint (Game). sequence, start and arrival as NormalizedPoint, attentionZone, repulsionGain, passiveAttraction, noiseAmplitude.
- GameSession (GameEngine, runtime aggregate). level, bounds, targets, gaze cursor (GazeFilter), frameTime, elapsed, isComplete.
- GameProgression (GameEngine). levels, currentIndex, isFinished.

## Value objects
- Vector2: playfield points. No validation, arithmetic operators.
- NormalizedPoint: 0...1 per axis; absolute(in:) resolves against PlayfieldBounds.
- PlayfieldBounds: width and height in points; centre.
- PhysicsConstants: targetRadius 24, arrivalRadius 40, maxSpeed 2.2, friction 0.94, edgeMargin 60, bounceLoss 0.5, referenceFrameRate 60.
- ValidationRules: settleRadius 16, wobbleMargin 20 (tolerance 36), holdEpsilon 1e-6.
- LevelDifficulty: targetCount, baseAttentionZone, repulsionGain, passiveAttraction per band.
- GazeSample, GazeViewport, DisplayGeometry (AR).
- AudioCue (Audio).

## Errors
No thrown domain errors: the engine is total. Failure states are values (GazeTrackingState.unavailable/failed, AudioStatus.unavailable, GamePhase.failed).

## Services (protocols)
- GazeTrackingService (AR): start(viewport:), pause, resume, stop, updateGeometry, state, latestSample, callbacks.
- AudioService (Audio): activate, deactivate, apply(cue), status.
- GameClock (GameEngine): start(onTick), stop.
- CameraAuthorizationService, DeviceCapabilities (AR).
- NoiseSource (GameEngine).

## Business rules
| ID | Rule (plain language) | Inputs | Output | Home | Tests |
|---|---|---|---|---|---|
| R-01 | Outside the attention zone a sphere is pulled toward its arrival by `passiveAttraction` per frame | position, arrival | velocity | TargetPhysics.integrate | TargetPhysicsTests |
| R-02 | Inside the attention zone a sphere is pushed away from the gaze with force `repulsionGain * (zone - distance)` | gaze, position | velocity | TargetPhysics.integrate | TargetPhysicsTests |
| R-03 | Organic noise (amplitude 0.15) applies only while attracted | frameTime | velocity | TargetPhysics.integrate, ValueNoise1D | ValueNoise1DTests, TargetPhysicsTests |
| R-04 | Speed is capped at 2.2 points per reference frame | velocity | velocity | TargetPhysics.integrate | TargetPhysicsTests |
| R-05 | Friction multiplies velocity by 0.94 per reference frame | velocity | velocity | TargetPhysics.integrate | TargetPhysicsTests |
| R-06 | Position integrates velocity | velocity | position | TargetPhysics.integrate | golden tests |
| R-07 | Edges at 60 pt clamp the position and reverse half of the velocity | position | position, velocity | TargetPhysics.bounce | TargetPhysicsTests |
| R-08 | Validation needs 0.75 s of continuous presence strictly inside 16 pt of the arrival; leaving resets | distance, holdTime | isValidated | ValidationRule | ValidationRuleTests |
| R-09 | Presence counts only for the lowest unvalidated sequence (or when already validated, or non sequential) | targets | isTurn | TurnRule | SequenceOrderTests |
| R-10 | A validated sphere loses its place beyond 36 pt from the arrival | distance | isValidated | ValidationRule | ValidationRuleTests |
| R-11 | Losing a validation invalidates every validated sphere of higher rank | targets | invalidated sequences | CascadeRule | CascadeRuleTests |
| R-12 | A level completes when every sphere is validated; fourteen levels; 1, 2, 3 targets per band | targets, progression | levelCompleted, next level | GameSession, GameProgression, LevelCatalog | GameSessionTests, LevelCatalogTests, GameProgressionTests |
| R-13 | Gaze is smoothed with alpha 0.1; isolated jumps over 300 pt are ignored until three consecutive ones | raw samples | cursor | GazeFilter | GazeFilterTests |
| R-14 | deltaTime is clamped to 0.1 s and sub-stepped to at most one reference frame; fractional steps use the exact power of the reference map | deltaTime | events | GameSession.advance, FractionalStep | GameSessionTests, TargetPhysicsTests |
| R-15 | Cascade losses in one tick produce a single loss tone, spaced at least 150 ms | events | cues | AudioCuePolicy | AudioCuePolicyTests |
| R-16 | The gaze ray (eye midpoint to lookAtPoint) hits the device plane only when travelling toward it; no side of the plane is assumed | eye origin, lookAt | plane hit (metres) | GazeRay | GazeMapperTests |
| R-17 | Screen right and up are the dominant in-plane camera axes along the eye line and gravity; majority vote, confidence 0.8 | userRight, deviceUp, faceUp | AxisMapping | AxisResolver, AxisVote | AxisMappingTests, GazeReadinessEvaluatorTests |
| R-18 | Calibration maps nominal normalized gaze to screen by a six-coefficient affine fit (least squares), needing three non-collinear finite points | 9 fixations | AffineTransform2D | AffineTransform2D.fit | AffineTransform2DTests |
| R-19 | A fixation is measured after 0.3 s of settling from at least 12 usable samples over 0.8 s (up to 2.5 s), blinks excluded, outliers beyond 3.5 MAD rejected, one retry per target | raw samples, blink shapes, time | measurement | FixationSequence, RobustAggregator, BlinkDetector | FixationSequenceTests, RobustAggregatorTests |
| R-20 | A calibration is valid when five control targets give a mean error below 18 percent and a max below 30 percent of the short side | validation measurements | verdict | GazeQualityCriteria, ValidationResult | GazeSetupViewModelTests |
| R-21 | A stored profile is reused only for the same model version, orientation, viewport (1 percent) and age under 30 days; the game may use an unvalidated fresh profile | profile, context | usable / compatible | CalibrationProfile | CalibrationProfileTests |
| R-22 | Playing with the face absent for 0.3 s pauses the game; it resumes when the face is back | gaze state, dt | GamePhase.faceLost | GameViewModel | GameViewModelTests |
| R-23 | Gaze off the playfield (tolerance 6 percent of the short side) freezes presence and blocks validation, without resetting it | gaze, bounds | canAccumulate | GameSession.updateAttention, ValidationRule | LevelEnvironmentTests, CampaignSimulationTests |
| R-24 | A current adds a constant impulse inside its band, attracted or repelled | position, bands | velocity | LevelEnvironment.impulse, TargetPhysics | LevelEnvironmentTests |
| R-25 | A veil pushes the lueur out and reflects the inward velocity with 0.5 loss | position, velocity, segment | position, velocity | VeilSegment.resolve | LevelEnvironmentTests |
| R-26 | A veilleuse loses its charge in `decay` s unless looked at (refill in `recharge` s); dark, it closes its irises and costs their validation (cascade follows) | gaze, time | charge, losses | VeilleuseState, GameSession | LevelEnvironmentTests, CampaignSimulationTests |
| R-27 | A moving iris glides between two points with a cosine ease | time | arrival | IrisPath | LevelEnvironmentTests |
| R-28 | Temperaments scale repulsion, attraction and radius (lourde 0.6/0.6/1.2, vive 1.45/1.2/0.8) | temperament | target parameters | Temperament, LevelResolver | LevelEnvironmentTests |
| R-29 | Éclats: atteint always, fluide under par time, serein with no loss and intrusions within par; records keep the union and bests | outcome, par | Set<Eclat> | LevelOutcome, LevelRecord | CampaignProgressTests |
| R-30 | A level unlocks when the previous one in campaign order is completed; the next level is the first unlocked, uncompleted one | records | unlocked, next | CampaignProgress | CampaignProgressTests, AppCoordinatorTests |

## Glossary
- Sphere / target: the moving object the player must let arrive.
- Arrival: the destination point drawn as a flattened ring.
- Attention zone: gaze distance under which repulsion applies.
- Settle radius: 16 pt, where presence counts.
- Wobble tolerance: 36 pt, where a validated sphere keeps its place.
- Hold: the continuous 0.75 s presence.
- Turn: the sphere allowed to validate now (lowest unvalidated sequence).
- Cascade: chain invalidation of higher ranks.
- Reference frame: one 60 Hz frame of attention-indirecte.html.
- Cursor: the smoothed gaze point used by the engine.
- Raw sample: metric gaze geometry of one frame (plane hit, eyes, gravity, blinks), never persisted.
- Nominal frame: rough ppi/camera model used only to normalize metres before calibration.
- Axis mapping: which camera axes are the screen's right and up, resolved from the user.
- Fixation: aggregated gaze measurement on one target.
- Profile: persisted calibration coefficients and their context.
- Lueur: the moving object (formerly "sphere").
- Iris: the arrival, drawn as a closing diaphragm.
- Courant, voile, veilleuse, iris mouvant: the campaign elements (R-24 to R-27).
- Éclat: one of the three mastery marks (atteint, fluide, serein).
- Voie: the designer route shown as help after 45 s.
