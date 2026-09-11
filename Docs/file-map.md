# File Map

Registry of every source file in the project. One row per file. Updated by every skill that creates or deletes a file. Search this table before creating anything.

| Path | Type | Layer | Purpose | Created by |
|---|---|---|---|---|
| AR/Calibration/AffineTransform2D.swift | enum | AR | Six-coefficient affine correction (offset, scale, shear, axis flips) fitted by least squares | Claude (mission Iris) |
| AR/Calibration/AxisMapping.swift | struct | AR | Which in-plane camera axes are the screen's right and up, resolved from the user's eyes and gravity | Claude (mission Iris) |
| AR/Calibration/BlinkDetector.swift | struct | AR | Flags samples taken during a blink (either eye) and shortly after it | Claude (mission Iris) |
| AR/Calibration/CalibrationGrid.swift | enum | AR | Target layouts in normalized viewport coordinates, away from the physical edges | Claude (mission Iris) |
| AR/Calibration/CalibrationProfile.swift | struct | AR | Persisted result of a gaze calibration: coefficients and the context they are valid for. No gaze data. | Claude (mission Iris) |
| AR/Calibration/CalibrationResult.swift | struct | AR | Outcome of a calibration fit and of a validation pass | Claude (mission Iris) |
| AR/Calibration/CalibrationStore.swift | protocol | AR | Local persistence of the calibration profile (UserDefaults JSON) behind a protocol | Claude (mission Iris) |
| AR/Calibration/DeviceAxis.swift | enum | AR | One of the four in-plane directions of the interface-oriented camera frame | Claude (mission Iris) |
| AR/Calibration/FixationSequence.swift | enum | AR | Time-based target sequence: settle, collect usable samples, aggregate robustly, retry once, move on | Claude (mission Iris) |
| AR/Calibration/GazeMapper.swift | struct | AR | Raw metric sample -> axis-resolved plane offsets -> nominal normalized -> affine calibration -> points | Claude (mission Iris) |
| AR/Calibration/GazeReadinessEvaluator.swift | struct | AR | Checks that the gaze signal is usable before calibrating: face, eyes, direction, stability, blinks, axes | Claude (mission Iris) |
| AR/Calibration/GazeReadinessReport.swift | enum | AR | Readiness check kinds, statuses and the report shown before calibration | Claude (mission Iris) |
| AR/Calibration/NominalDisplayGeometry.swift | struct | AR | Rough physical model of the screen used ONLY as a first guess before calibration and for the | Claude (mission Iris) |
| AR/Calibration/NormalizedCoordinates.swift | enum | AR | Conversions between viewport points and resolution-independent 0...1 coordinates | Claude (mission Iris) |
| AR/Calibration/RobustAggregator.swift | enum | AR | Median-based fixation estimate with MAD outlier rejection, so a blink or a glance never skews a point | Claude (mission Iris) |
| AR/Projection/GazeRay.swift | enum | AR | Intersection of the eye-to-lookAtPoint ray with the device plane (z = 0 of the interface-oriented camera | Claude (mission Iris) |
| AR/Services/ARKitGazeTrackingService.swift | class | AR | ARFaceTrackingConfiguration session producing raw metric gaze samples in the interface-oriented | Claude (mission Iris) |
| AR/Services/CameraAuthorizationService.swift | enum | AR | Camera permission status and request, abstracted from AVFoundation | Claude (mission Iris) |
| AR/Services/DeviceCapabilities.swift | protocol | AR | Hardware capability probe (TrueDepth face tracking) behind a protocol for tests and previews | Claude (mission Iris) |
| AR/Services/GazeTrackingService.swift | enum | AR | Abstraction over gaze acquisition. Produces raw, metric samples; calibration and mapping happen downstream. | Claude (mission Iris) |
| AR/Services/InterfaceOrientationProvider.swift | protocol | AR | The interface orientation actually used by the foreground window scene, never a hard-coded value | Claude (mission Iris) |
| AR/Services/SimulatedGazeTrackingService.swift | class | AR | Pointer-driven or scripted gaze for the simulator, previews and tests (no camera involved) | Claude (mission Iris) |
| App/DI/AppContainer.swift | class | App | Composition root. The only place concrete services are chosen. | Claude (mission Iris) |
| App/DI/AppEnvironment.swift | enum | App | Runtime flavour of the composition root | Claude (mission Iris) |
| App/IrisApp.swift | struct | App | Application entry point: builds the composition root and the coordinator once | Claude (mission Iris) |
| App/Platform/DeviceIdiom.swift | enum | App | Device idiom probe used to estimate the display geometry | Claude (mission Iris) |
| App/Platform/DisplayLinkGameClock.swift | class | App | CADisplayLink clock pinned to 60 Hz, the rate the reference engine was validated at | Claude (mission Iris) |
| App/Platform/LaunchOptions.swift | struct | App | Debug-only launch arguments used to reach any screen directly (simulator screenshots, manual QA) | Claude (mission Iris) |
| App/Platform/SystemLinks.swift | enum | App | System URLs the presentation layer may open (app settings) | Claude (mission Iris) |
| Audio/Policy/AudioCue.swift | enum | Audio | Sound intents derived from game events, independent from AVAudioEngine | Claude (mission Iris) |
| Audio/Policy/AudioCuePolicy.swift | struct | Audio | Sound policy: crescendo per target, one chime per validation, one loss tone per tick with a retrigger guard | Claude (mission Iris) |
| Audio/Services/AVAudioEngineAudioService.swift | class | Audio | AVAudioEngine host for the sine synthesizer, with audio session, interruption and reset handling | Claude (mission Iris) |
| Audio/Services/AudioService.swift | enum | Audio | Sound output abstraction: cues in, status out | Claude (mission Iris) |
| Audio/Services/NotificationObserverBag.swift | class | Audio | Owns NotificationCenter observer tokens and removes them when its owner is deallocated | Claude (mission Iris) |
| Audio/Services/SilentAudioService.swift | class | Audio | No-op audio used by previews and by the app when the audio engine cannot start | Claude (mission Iris) |
| Audio/Synth/SineSynth.swift | class | Audio | Allocation-free sine synthesizer reproducing the reference engine's Web Audio graph | Claude (mission Iris) |
| DesignSystem/Components/DSBackground.swift | struct | DesignSystem | The Iris atmosphere: deep ground, amber glow rising from the horizon, hairline horizon | Claude (mission Iris) |
| DesignSystem/Components/DSBadge.swift | struct | DesignSystem | Small status pill (success, danger, info, neutral, accent) | Claude (mission Iris) |
| DesignSystem/Components/DSButton.swift | struct | DesignSystem | Primary, secondary and ghost actions with press feedback, 52 pt minimum height | Claude (mission Iris) |
| DesignSystem/Components/DSCard.swift | struct | DesignSystem | Elevated surface with hairline border for grouped content and overlays | Claude (mission Iris) |
| DesignSystem/Components/DSIrisMark.swift | struct | DesignSystem | The Iris emblem: concentric amber rings around a dark pupil, optionally breathing | Claude (mission Iris) |
| DesignSystem/Components/DSOverlayPanel.swift | struct | DesignSystem | Dimmed full-screen veil with a centred title, subtitle and actions (the reference engine's overlays) | Claude (mission Iris) |
| DesignSystem/Components/DSProgressRing.swift | struct | DesignSystem | Circular progress used for journey completion and hold progress readouts | Claude (mission Iris) |
| DesignSystem/Components/DSScreen.swift | struct | DesignSystem | Page container: atmosphere background, safe-area aware column, consistent gutters | Claude (mission Iris) |
| DesignSystem/Components/DSStatusRow.swift | struct | DesignSystem | Icon, title, detail and a coloured state dot; used for capability and permission lists | Claude (mission Iris) |
| DesignSystem/Modifiers/DSEyebrowStyle.swift | struct | DesignSystem | Small uppercase tracked label style used for section markers and HUD readouts | Claude (mission Iris) |
| DesignSystem/Modifiers/DSGlow.swift | struct | DesignSystem | Soft coloured glow used for the iris mark and validated states | Claude (mission Iris) |
| DesignSystem/Tokens/DSColor.swift | enum | DesignSystem | Semantic colour tokens of the Iris identity (values live in the asset catalogue) | Claude (mission Iris) |
| DesignSystem/Tokens/DSFont.swift | enum | DesignSystem | Typography tokens: serif display for the Iris voice, system text for reading, all Dynamic Type aware | Claude (mission Iris) |
| DesignSystem/Tokens/DSMotion.swift | enum | DesignSystem | Motion tokens; every animation has a Reduce Motion variant (cross-fade only) | Claude (mission Iris) |
| DesignSystem/Tokens/DSRadius.swift | enum | DesignSystem | Corner radius scale | Claude (mission Iris) |
| DesignSystem/Tokens/DSSpacing.swift | enum | DesignSystem | Spacing scale on a 4 pt grid | Claude (mission Iris) |
| Domain/Entities/Level.swift | struct | Domain | One of the fourteen levels: its targets, hold duration and sequencing mode | Claude (mission Iris) |
| Domain/Entities/LevelID.swift | struct | Domain | Typed identity of a level (`level_01` ... `level_14` in the reference engine) | Claude (mission Iris) |
| Domain/Entities/Target.swift | struct | Domain | Runtime state of one sphere: position, velocity, destination, hold progress and validation | Claude (mission Iris) |
| Domain/Entities/TargetBlueprint.swift | struct | Domain | Static description of one target of a level (the reference engine's level target config) | Claude (mission Iris) |
| Domain/Entities/TargetID.swift | struct | Domain | Typed identity of a target inside a level; the sequence number is unique per level | Claude (mission Iris) |
| Domain/Levels/LevelCatalog.swift | enum | Domain | The fourteen levels, generated exactly like the reference engine (same seeds, same order of draws) | Claude (mission Iris) |
| Domain/Levels/LevelDifficulty.swift | struct | Domain | Difficulty band parameters exactly as defined by the reference engine's `buildLevel` | Claude (mission Iris) |
| Domain/Physics/PhysicsConstants.swift | struct | Domain | Physical constants of the reference engine, expressed per 60 Hz reference frame | Claude (mission Iris) |
| Domain/Random/LinearCongruentialGenerator.swift | struct | Domain | Deterministic generator identical to the reference engine's `rngFor` / `makeNoise1D` (9301, 49297, 233280) | Claude (mission Iris) |
| Domain/Validation/CascadeRule.swift | enum | Domain | R-11 cascade: losing a validation invalidates every validated target of higher rank | Claude (mission Iris) |
| Domain/Validation/TurnRule.swift | enum | Domain | R-09 sequence rule: validation only counts for the lowest unvalidated sequence number | Claude (mission Iris) |
| Domain/Validation/ValidationRule.swift | struct | Domain | R-08 continuous 0.75 s presence and R-10 wobble tolerance loss, applied to one target per tick | Claude (mission Iris) |
| Domain/Validation/ValidationRules.swift | struct | Domain | Distances governing validation and its loss (R-08, R-10) | Claude (mission Iris) |
| Domain/Validation/ValidationTransition.swift | enum | Domain | Outcome of applying the validation rule to one target during one tick | Claude (mission Iris) |
| Domain/ValueObjects/NormalizedPoint.swift | struct | Domain | Resolution-independent position (0...1 on both axes), resolved against the playfield at load time | Claude (mission Iris) |
| Domain/ValueObjects/PlayfieldBounds.swift | struct | Domain | Size of the game space in points; the reference engine used the browser window size | Claude (mission Iris) |
| Domain/ValueObjects/Vector2.swift | struct | Domain | Two-dimensional vector in playfield points (the reference engine's canvas pixels) | Claude (mission Iris) |
| Features/CameraAccess/CameraAccessNavigating.swift | protocol | Presentation | Navigation intents emitted by the camera permission screen | Claude (mission Iris) |
| Features/CameraAccess/CameraAccessView.swift | struct | Presentation | Explains why the TrueDepth camera is needed and handles denied and restricted states | Claude (mission Iris) |
| Features/CameraAccess/CameraAccessViewModel.swift | class | Presentation | Camera permission flow: explanation, request, denied and restricted states | Claude (mission Iris) |
| Features/Game/Rendering/GameSceneRenderer.swift | struct | Presentation | Port of the reference engine's `draw()`: horizon, perspective floor, depth-scaled spheres, rings, shadows | Claude (mission Iris) |
| Features/Game/Rendering/GameSceneSnapshot.swift | struct | Presentation | Plain value copied from the session once per frame; the only thing the canvas reads | Claude (mission Iris) |
| Features/Game/ViewModels/GameNavigating.swift | protocol | Presentation | Navigation intents emitted by the game screen | Claude (mission Iris) |
| Features/Game/ViewModels/GamePhase.swift | enum | Presentation | Single state of the game screen; every overlay derives from it | Claude (mission Iris) |
| Features/Game/ViewModels/GameSettingsStore.swift | class | Presentation | Small persisted preferences (diagnostic display, tutorial seen). No gaze data is ever stored. | Claude (mission Iris) |
| Features/Game/ViewModels/GameViewModel.swift | class | Presentation | Owns the game loop: session, progression, gaze mapping, audio, phase transitions | Claude (mission Iris) |
| Features/Game/ViewModels/GazeCalibrationStatus.swift | enum | Presentation | What the game knows about the calibration in use (pause panel readout) | Claude (mission Iris) |
| Features/Game/Views/GameCanvasView.swift | struct | Presentation | Draws one scene snapshot; re-evaluated only when the snapshot changes | Claude (mission Iris) |
| Features/Game/Views/GameHUDView.swift | struct | Presentation | Level readout, pause control, gaze and sound status (the reference engine's HUD texts) | Claude (mission Iris) |
| Features/Game/Views/GameOverlayView.swift | struct | Presentation | One overlay per game phase: ready, pause, level end, interruption, resume, failure | Claude (mission Iris) |
| Features/Game/Views/GameView.swift | struct | Presentation | The game screen: full-screen canvas, HUD and phase overlays | Claude (mission Iris) |
| Features/GazeSetup/ViewModels/GazeSetupIntent.swift | enum | Presentation | Why the gaze setup runs: first launch, quick revalidation of a stored profile, or manual recalibration | Claude (mission Iris) |
| Features/GazeSetup/ViewModels/GazeSetupNavigating.swift | protocol | Presentation | Navigation intents emitted by the gaze setup screen | Claude (mission Iris) |
| Features/GazeSetup/ViewModels/GazeSetupPhase.swift | struct | Presentation | Single state of the gaze setup screen: readiness, calibration, validation, verdicts and failures | Claude (mission Iris) |
| Features/GazeSetup/ViewModels/GazeSetupViewModel.swift | class | Presentation | Runs diagnostic, nine-point calibration, five-point validation and persists the profile | Claude (mission Iris) |
| Features/GazeSetup/Views/FixationTargetView.swift | struct | Presentation | One calibration or validation target positioned in normalized coordinates, with progress and stage label | Claude (mission Iris) |
| Features/GazeSetup/Views/GazeReadinessView.swift | struct | Presentation | Diagnostic checklist with a central fixation mark | Claude (mission Iris) |
| Features/GazeSetup/Views/GazeSetupView.swift | struct | Presentation | Gaze diagnostic, calibration targets, validation and verdict screens | Claude (mission Iris) |
| Features/GazeSetup/Views/GazeVerdictView.swift | struct | Presentation | "Regard prêt" or "La précision peut être améliorée" with measured errors and actions | Claude (mission Iris) |
| Features/Home/HomeView.swift | struct | Presentation | Welcome screen: identity, promise, start action, privacy note | Claude (mission Iris) |
| Features/JourneyComplete/JourneyCompleteView.swift | struct | Presentation | End of the fourteen-level journey | Claude (mission Iris) |
| Features/Tutorial/TutorialView.swift | struct | Presentation | Rules of the game, ported from the reference engine's rules screen | Claude (mission Iris) |
| Features/Unavailable/UnavailableView.swift | struct | Presentation | Shown when the device cannot track faces (no TrueDepth / ARFaceTracking unsupported) | Claude (mission Iris) |
| GameEngine/Clock/GameClock.swift | protocol | GameEngine | Frame source abstraction: delivers deltaTime ticks to the game loop | Claude (mission Iris) |
| GameEngine/Clock/ManualGameClock.swift | class | GameEngine | Deterministic clock driven by tests and previews | Claude (mission Iris) |
| GameEngine/Gaze/GazeFilter.swift | struct | GameEngine | R-13 port of the reference gaze listener: exponential smoothing (alpha 0.1) and sustained-jump gating | Claude (mission Iris) |
| GameEngine/Noise/NoiseSource.swift | protocol | GameEngine | One-dimensional organic noise abstraction so the engine can be driven by deterministic or silent noise | Claude (mission Iris) |
| GameEngine/Noise/SilentNoise.swift | struct | GameEngine | Zero noise, used by tests and previews that need fully predictable motion | Claude (mission Iris) |
| GameEngine/Noise/ValueNoise1D.swift | struct | GameEngine | Port of `makeNoise1D`: 256 random values, smoothstep interpolation (Perlin-like value noise) | Claude (mission Iris) |
| GameEngine/Physics/TargetPhysics.swift | struct | GameEngine | R-01...R-07 frame-rate independent integration of one target, equivalent to the reference engine at 60 Hz | Claude (mission Iris) |
| GameEngine/Session/GameEvent.swift | enum | GameEngine | Facts produced by one engine tick, consumed by audio, haptics and presentation | Claude (mission Iris) |
| GameEngine/Session/GameProgression.swift | struct | GameEngine | R-12 progression through the fourteen levels | Claude (mission Iris) |
| GameEngine/Session/GameSession.swift | struct | GameEngine | Deterministic per-level simulation: physics, validation, cascade and events (port of `step()`) | Claude (mission Iris) |
| Navigation/AppCoordinator.swift | class | Presentation | Deterministic route state machine: home, camera access, gaze setup, tutorial, game, journey end | Claude (mission Iris) |
| Navigation/AppRoute.swift | struct | Presentation | Every top-level screen of Iris as one explicit state | Claude (mission Iris) |
| Navigation/RootView.swift | struct | Presentation | Renders the coordinator's route and forwards scene phase changes to the running game | Claude (mission Iris) |
| Tests/IrisTests/AR/AffineTransform2DTests.swift | struct | Tests | Affine calibration model: identity, offsets, scales, flips, synthetic recovery, residuals, failures | Claude (mission Iris) |
| Tests/IrisTests/AR/AxisMappingTests.swift | struct | Tests | Axis resolution from the eye line and gravity, including the "phone flipped 180 degrees" case | Claude (mission Iris) |
| Tests/IrisTests/AR/CalibrationProfileTests.swift | struct | Tests | Persistence and compatibility rules of the calibration profile | Claude (mission Iris) |
| Tests/IrisTests/AR/FixationSequenceTests.swift | struct | Tests | Time-based fixation protocol: settling, collection, blink exclusion, retry, completion and failure | Claude (mission Iris) |
| Tests/IrisTests/AR/GazeMapperTests.swift | struct | Tests | Raw sample to points pipeline, nominal geometry inverse, ray-plane intersection, blink detector | Claude (mission Iris) |
| Tests/IrisTests/AR/GazeReadinessEvaluatorTests.swift | struct | Tests | Readiness checks pass for a stable signal and flag distance, direction, stability and hardware problems | Claude (mission Iris) |
| Tests/IrisTests/AR/NormalizedCoordinatesTests.swift | struct | Tests | Points to normalized conversions on several viewports | Claude (mission Iris) |
| Tests/IrisTests/AR/RobustAggregatorTests.swift | struct | Tests | Median-based aggregation with outlier rejection | Claude (mission Iris) |
| Tests/IrisTests/Audio/AudioCuePolicyTests.swift | struct | Tests | Sound policy: crescendo per target, chime on validation, one loss tone per cascade | Claude (mission Iris) |
| Tests/IrisTests/Audio/SineSynthTests.swift | struct | Tests | The synthesizer renders the crescendo, chime and loss tones with bounded amplitude and expected pitch | Claude (mission Iris) |
| Tests/IrisTests/Domain/CascadeRuleTests.swift | struct | Tests | R-11 losing a validation invalidates every higher rank, never a lower one | Claude (mission Iris) |
| Tests/IrisTests/Domain/LevelCatalogTests.swift | struct | Tests | R-12 progression data: fourteen levels, target counts, difficulty curve and exact reference geometry | Claude (mission Iris) |
| Tests/IrisTests/Domain/LinearCongruentialGeneratorTests.swift | struct | Tests | The generator reproduces the reference JavaScript sequence exactly | Claude (mission Iris) |
| Tests/IrisTests/Domain/SequenceOrderTests.swift | struct | Tests | R-09 targets validate only in order 1, 2, 3; physical arrival out of turn is allowed but never counts | Claude (mission Iris) |
| Tests/IrisTests/Domain/ValidationRuleTests.swift | struct | Tests | R-08 continuous 0.75 s presence and R-10 wobble tolerance, at rule and session level | Claude (mission Iris) |
| Tests/IrisTests/Fixtures/GoldenTrace.swift | struct | Tests | Decodes the golden traces produced by the reference JavaScript engine (Fixtures/golden_generator.js) | Claude (mission Iris) |
| Tests/IrisTests/Fixtures/SessionFixture.swift | enum | Tests | Helpers to stage deterministic sessions (no noise, explicit positions) | Claude (mission Iris) |
| Tests/IrisTests/GameEngine/GameProgressionTests.swift | struct | Tests | R-12 progression across the fourteen levels | Claude (mission Iris) |
| Tests/IrisTests/GameEngine/GameSessionGoldenTests.swift | struct | Tests | The Swift engine reproduces the reference JavaScript engine frame by frame (golden traces) | Claude (mission Iris) |
| Tests/IrisTests/GameEngine/GameSessionTests.swift | struct | Tests | R-12 and R-14 session behaviour: completion, delta clamping, sub-stepping, gaze handling | Claude (mission Iris) |
| Tests/IrisTests/GameEngine/GazeFilterTests.swift | struct | Tests | R-13 exponential smoothing and sustained-jump gating of the reference gaze listener | Claude (mission Iris) |
| Tests/IrisTests/GameEngine/TargetPhysicsTests.swift | struct | Tests | R-01...R-07 and R-14: attraction, repulsion, friction, cap, bounce and frame-rate independence | Claude (mission Iris) |
| Tests/IrisTests/GameEngine/ValueNoise1DTests.swift | struct | Tests | R-03 organic noise port: table values, smoothstep interpolation, wrap-around, subtle range | Claude (mission Iris) |
| Tests/IrisTests/Mocks/MockAudioService.swift | class | Tests | Recording mock for AudioService | Claude (mission Iris) |
| Tests/IrisTests/Mocks/MockGameNavigating.swift | class | Tests | Recording mock for GameNavigating and CameraAccessNavigating | Claude (mission Iris) |
| Tests/IrisTests/Presentation/AppCoordinatorTests.swift | struct | Tests | Deterministic route transitions of the coordinator | Claude (mission Iris) |
| Tests/IrisTests/Presentation/CameraAccessViewModelTests.swift | struct | Tests | Camera permission phases and navigation | Claude (mission Iris) |
| Tests/IrisTests/Presentation/GameViewModelTests.swift | struct | Tests | Deterministic phase transitions of the game screen with simulated gaze, mock audio and a manual clock | Claude (mission Iris) |
| Tests/IrisTests/Presentation/GazeSetupViewModelTests.swift | struct | Tests | The setup state machine: readiness, calibration, validation, verdicts, persistence, failures | Claude (mission Iris) |
| Tests/IrisTests/Presentation/LaunchOptionsTests.swift | struct | Tests | Debug launch argument parsing | Claude (mission Iris) |
