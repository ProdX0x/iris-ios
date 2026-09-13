# Architecture

## Overview
MVVM in the Presentation layer over a pure deterministic core (Domain and GameEngine) that knows nothing about ARKit, AVFoundation or SwiftUI. Platform capabilities (gaze, audio, haptics, frame clock) are protocols implemented in the AR, Audio, Haptics and App layers and injected by a single composition root. Single app target, layers enforced by folders, imports and the layer audit.

## Layer diagram
```
┌──────────────────────────────────────────────────────────────┐
│  App            IrisApp · AppContainer (composition root)    │
│                 Platform adapters: DisplayLinkGameClock,     │
│                 SystemLinks, DeviceIdiom, LaunchOptions      │
└───────────────────────────┬──────────────────────────────────┘
                            │ builds
┌───────────────────────────▼──────────────────────────────────┐
│  Presentation   Navigation (AppCoordinator, AppRoute, Root)  │
│                 Features/* (Views, ViewModels, Rendering)    │
│                 DesignSystem (Tokens, Components, Modifiers) │
└──────┬─────────────────────────────┬─────────────────────────┘
       │ uses protocols              │ depends on
┌──────▼──────────┐   ┌──────────────▼───────────────────────┐
│  AR             │   │  GameEngine (pure Swift)             │
│  GazeTracking-  │   │  GameSession · TargetPhysics · Noise │
│  Service impls, │   │  GazeFilter · GameProgression · Clock│
│  GazeProjector  │   └──────────────┬───────────────────────┘
├─────────────────┤                  │ depends on
│  Audio          │   ┌──────────────▼───────────────────────┐
│  AudioService   │   │  Domain (pure Swift)                 │
│  impls, Synth,  │   │  Target · Level · Vector2 · Rules    │
│  AudioCuePolicy │   │  PhysicsConstants · FeedbackTiming   │
├─────────────────┤   └──────────────────────────────────────┘
│  Haptics        │
│  HapticFeedback-│
│  Service impls, │
│  HapticCuePolicy│
└─────────────────┘
```
Allowed arrows: Presentation -> GameEngine, Domain, AR protocols, Audio protocols, Haptics protocols. AR, Audio and Haptics -> Domain value types and GameEngine events only. GameEngine -> Domain. Domain -> Foundation only. Haptics may import UIKit (feedback generators); it never imports SwiftUI or ARKit.

## Feature map
```
Campaign (Domain/Campaign, Domain/Progress, GameEngine/Campaign, GameEngine/Environment)
  Data:           Campaign (6 chapters, 34 LevelDefinition), GameElement, CampaignProgress, LevelRecord, LevelOutcome, Eclat
  Engine:         LevelResolver -> ResolvedLevel -> GameSession(environment), HintTracker
  Persistence:    ProgressStore (UserDefaultsProgressStore, InMemoryProgressStore)
Feature: Home        HomeView (HomeSummary from AppCoordinator)
Feature: Chapters    ChaptersView, ChapterCard, LevelNode
Feature: Carnet      CarnetView
Feature: Settings    SettingsView (sheet)
Feature: Game
  Screens:        GameView (GameCanvasView, GameHUDView, GameOverlayView)
  ViewModels:     GameViewModel (GamePhase)
  Navigation:     GameNavigating -> AppCoordinator
  Engine:         GameSession, AudioCuePolicy, HapticCuePolicy
  Services:       GazeTrackingService, AudioService, HapticFeedbackService, GameClock, GameSettingsStore
Feature: CameraAccess
  Screens:        CameraAccessView
  ViewModels:     CameraAccessViewModel
  Navigation:     CameraAccessNavigating -> AppCoordinator
  Services:       CameraAuthorizationService
Feature: GazeSetup (Gaze Engine v2)
  Screens:        GazeSetupView (GazeReadinessView, FixationTargetView, GazeVerdictView)
  ViewModels:     GazeSetupViewModel (GazeSetupPhase, GazeSetupIntent)
  Navigation:     GazeSetupNavigating -> AppCoordinator
  Engine:         GazeReadinessEvaluator, FixationSequence, RobustAggregator, AffineTransform2D, CalibrationResult,
                  ValidationResult, GazeQualityCriteria, CalibrationProfile
  Services:       GazeTrackingService (shared), CalibrationStore, InterfaceOrientationProvider
Feature: Onboarding
  Screens:        HomeView, TutorialView (no ViewModel: static content, coordinator intents only, ADR-4)
Feature: JourneyEnd
  Screens:        JourneyCompleteView (JourneySummary value)
Feature: Unavailable
  Screens:        UnavailableView (DeviceUnavailability value)
```

## Navigation topology
```
AppCoordinator.route
├── .home                      HomeView
├── .cameraAccess              CameraAccessView (explain, requesting, denied, restricted)
├── .gazeSetup(intent)         GazeSetupView: starting, readiness, calibrating, validating, insufficient, ready, failed
│                                intent firstRun (no valid profile), revalidate (stored profile), recalibrate (from pause)
├── .chapters                  ChaptersView (map, play a level)
├── .carnet                    CarnetView
├── .game                      GameView, overlays by GamePhase:
│                                initializing, ready (level intro), playing, paused, levelComplete(result),
│                                interrupted, faceLost, resuming, suspended, failed
├── sheet .settings            SettingsView
├── .journeyComplete(summary)  JourneyCompleteView
└── .unavailable(reason)       UnavailableView
```
Transitions are methods of AppCoordinator (beginJourney, cameraAccessGranted, gazeSetupCompleted, gazeSetupCancelled, startGame, gameDidRequestRecalibration, gameDidFinishJourney, gameDidRequestExit, returnHome, replayJourney). The game only starts once the gaze was validated in this process (`isGazeReady`); first launch: home, camera, gaze setup, tutorial, game; later launches: home, gaze setup (revalidation), game. GamePhase transitions are methods of GameViewModel (primaryAction, pause, restartLevel, suspend, wake, exit) plus service callbacks.

## Reference data flow
```
CADisplayLink tick (60 Hz)
 -> DisplayLinkGameClock calls GameViewModel.tick(deltaTime)
 -> GameSession.advance(by:) clamps and sub-steps, integrates targets (TargetPhysics),
    applies TurnRule, ValidationRule, CascadeRule, returns [GameEvent]
 -> AudioCuePolicy turns events into [AudioCue] (one loss tone per tick)
 -> AudioService.apply(cue) updates the lock-protected synth commands
 -> GameSceneSnapshot copied from the session, GameCanvasView redraws
 -> .levelCompleted stops the clock, GameProgression moves on, phase = .levelComplete
ARSession frame (main queue)
 -> ARKitGazeTrackingService: viewMatrix(for: real interface orientation), eyes and lookAtPoint in the view frame,
    GazeRay.planeHit (metres), eye line, gravity up, blink shapes -> RawGazeSample
 -> GameViewModel.handleGazeSample -> GazeMapper (AxisMapping, nominal frame, AffineTransform2D from the profile)
 -> GameSession.ingestGaze (GazeFilter, alpha 0.1) in points
```

## Dependency graph
```
AppContainer.live()
  capabilities        = ARKitDeviceCapabilities (simulator: StaticDeviceCapabilities(true))
  cameraAuthorization = AVCaptureCameraAuthorizationService (simulator: StubCameraAuthorizationService)
  settings            = GameSettingsStore (UserDefaults)
  gazeTracking (lazy, shared)   = ARKitGazeTrackingService (simulator/preview: SimulatedGazeTrackingService, oracle mode optional)
  calibrationStore              = UserDefaultsCalibrationStore (preview/tests: InMemoryCalibrationStore)
  orientationProvider           = WindowSceneOrientationProvider (preview/tests: FixedOrientationProvider)
  makeGazeSetupViewModel(intent:navigator:) = GazeSetupViewModel(gaze, store, capabilities, authorization, orientation, settings)
  makeAudioService()        = AVAudioEngineAudioService (preview: SilentAudioService)
  makeGameClock()           = DisplayLinkGameClock (preview: ManualGameClock)
  makeGameViewModel(navigator:) = GameViewModel(progression, gaze, audio, clock, settings, isPad, autoplay, navigator)
  makeCameraAccessViewModel(navigator:) = CameraAccessViewModel(authorization, navigator)
  makeAppCoordinator() = AppCoordinator(container)
```

## Decisions

### ADR-1: Native re-implementation, no WebView
Status: accepted
Context: attention-indirecte.html is a validated engine.
Decision: port the engine to Swift value types; the HTML is a specification, never executed.
Consequences: golden traces generated from the JavaScript keep the port honest; any behaviour change must be deliberate and documented.

### ADR-2: Folder layout follows the mission brief
Status: accepted
Context: the skills' default tree has Core and Data layers.
Decision: App, Domain, GameEngine, AR, Audio, Navigation, Features, DesignSystem, Resources, Config, Tests, Docs at the project root. No Data layer (nothing is persisted or fetched).
Consequences: DI lives in App/DI, navigation in Navigation.

### ADR-3: Frame-rate independence by fractional reference frames
Status: accepted
Context: the reference engine is defined per 60 Hz frame.
Decision: GameSession clamps deltaTime to 0.1 s and sub-steps to at most one reference frame; TargetPhysics uses the exact fractional power of the per-frame affine map (friction^f, impulse scale, raised cap). At f = 1 the step is bit-identical to the reference.
Consequences: 30 Hz equals two reference frames exactly; 120 Hz shares the cruise speed exactly.

### ADR-4: ViewModels only where there is state
Status: accepted
Context: Home, Tutorial, JourneyComplete and Unavailable are static.
Decision: those views call coordinator intents directly; Game and CameraAccess have ViewModels.
Consequences: fewer layers, all state machines remain testable.

### ADR-5: Main-actor services, lock-free audio render
Status: accepted
Context: Swift 6 strict concurrency.
Decision: ARSession delegate on the main queue (assumeIsolated), all ViewModels and services @MainActor; the audio render block is @Sendable and reads commands through a try-lock, never blocking.
Consequences: no data races by construction; the render thread reuses the previous commands when the lock is busy.

### ADR-6: Level end overlay and journey screen
Status: accepted
Context: the reference engine jumps to the next level immediately with a 1.5 s flash; the brief requires a level end and a journey end screen.
Decision: level completion stops the loop and shows an overlay; the last level leads to a dedicated journey screen.
Consequences: documented deliberate difference from the HTML.

### ADR-7: One loss tone per tick, 150 ms retrigger guard
Status: accepted
Context: the HTML plays one buzz per invalidated sphere in a cascade.
Decision: AudioCuePolicy coalesces losses per tick and spaces tones by at least 150 ms.
Consequences: no stacked buzzes during cascades.

### ADR-8: Portrait only, full screen
Status: accepted
Context: gaze projection depends on the camera position relative to the screen.
Decision: UISupportedInterfaceOrientations = portrait, UIRequiresFullScreen = YES.
Consequences: deterministic projection, no iPad multitasking.

### ADR-9: Zero persistence of gaze data
Status: accepted
Context: privacy requirement.
Decision: only two booleans (gaze indicator, mirror) are stored in UserDefaults; no frame, image or face representation is retained.
Consequences: nothing to erase, nothing to sync.

### ADR-10: Screen axes resolved from the user, not from ARKit conventions
Status: accepted
Context: Gaze Engine v1 assumed the sign of both in-plane axes and forced `.portrait`; on a device the mapping was wrong (better when the phone was upside down).
Decision: the interface orientation comes from the window scene; the screen's right and up directions are resolved at runtime among the four in-plane camera axes using the eye line (left eye to right eye) and gravity (world up in the view frame), by majority vote during the diagnostic, and stored with the profile.
Consequences: no hard-coded mirror or sign; a flipped or mirrored frame still maps correctly; the handedness is logged for diagnostics.

### ADR-11: Affine calibration on a nominal frame, validated by five control targets
Status: accepted
Context: `lookAtPoint` carries per-user and per-device bias; the physical screen scale and camera position are not exposed by public API.
Decision: nine fixations aggregated robustly (median, MAD rejection, blinks excluded) fit a six-coefficient affine map from the nominal normalized frame to the screen; five control targets measure the error; acceptance at mean 18 percent and max 30 percent of the short side; the nominal ppi/camera estimates survive only as the frame the affine map is fitted against.
Consequences: offset, scale, shear and axis flips are learned; a broken projection is detected instead of played with; no neural or higher-order model until data proves it necessary.

### ADR-12: Profile persistence and invalidation
Status: accepted
Context: recalibrating at every launch would be tedious; using a stale profile blindly would be wrong.
Decision: the profile (coefficients, axes, orientation, viewport, nominal frame, date, errors, validity) is stored as JSON in UserDefaults; it is reused only for the same model version, orientation, viewport (1 percent) and age under 30 days, after a five-point revalidation at launch; recalibration is available from the pause menu.
Consequences: no gaze data is ever stored; a mediocre profile kept on purpose is marked invalid and triggers a full calibration next time.

### ADR-13: Levels are authored data resolved per screen
Status: accepted
Context: the prototype generated 14 levels from seeds; their difficulty was random (see Design/PRODUCT_AUDIT.md).
Decision: `LevelDefinition` values in normalized coordinates, with the zone as a fraction of the short side and forces at scale 1; `LevelResolver` scales everything by short side / 393 pt and builds the engine environment; the prototype catalog survives only for the golden traces.
Consequences: identical play on every Face ID iPhone; levels are reviewable data; every level is proven feasible and every element necessary by simulated players (CampaignSimulationTests).

### ADR-14: The environment extends the session without touching the historical step
Status: accepted
Context: currents, veils, veilleuses, moving irises and the on-screen rule must not alter the validated engine.
Decision: `LevelEnvironment` (empty for prototype levels) adds an external impulse inside the same fractional step, a collision pass after the edge bounce, a presence freeze in `ValidationRule`, and veilleuse and attention updates before the targets.
Consequences: golden traces unchanged; campaign rules R-23 to R-28 testable in isolation.

### ADR-15: Progress, éclats and the Carnet belong to the coordinator
Status: accepted
Context: the game screen should not own persistence.
Decision: `GameNavigating.gameDidComplete` hands the outcome to `AppCoordinator`, which updates `CampaignProgress` through `ProgressStore` and returns the previous record so the result can show what is new.
Consequences: one source of truth for unlocks; the game ViewModel stays testable with a mock navigator.

### ADR-16: A world without perspective, drawn in one Canvas
Status: accepted
Context: the prototype's horizon suggested depth that the 2D physics did not have.
Decision: front view "chambre noire" (Design/ART_DIRECTION.md); a static background view and one per-frame Canvas fed by an immutable snapshot; additive glows as radial gradients, no blur filters.
Consequences: readable physics, cheap rendering next to ARKit.

### ADR-17: project.yml is the single source of truth for the Xcode project and the Apple identity
Status: accepted
Context: the bundle identifier and the team had been fixed by hand in Xcode while `project.yml` still carried `com.prodx0x.iris` and `NKN63DTRM4`, a value read from a certificate's common name instead of its OU (the team); every `xcodegen generate` silently restored the wrong identity and Xcode lost the team.
Decision: `project.yml` carries `net.steve-s.iris` / `net.steve-s.iris.tests`, `DEVELOPMENT_TEAM = G4U9RG5GL7`, `CODE_SIGN_STYLE = Automatic` with no pinned profile or certificate; `Iris.xcodeproj` is a generated artefact; `Tools/audit.py` check C12 fails on any divergence between the spec, the generated project and the sources.
Consequences: a signing fix made only in Xcode is a bug, not a fix; the identity is stable before StoreKit; no personal Apple credential is ever versioned.

### ADR-18: One feedback guard, one haptic pulse per logical event
Status: accepted
Context: the haptics preference existed but only the éclats reveal vibrated, through a SwiftUI modifier outside any policy; gameplay events never reached the Taptic Engine, and nothing prevented a cascade from becoming a burst of pulses.
Decision: a `Haptics` layer mirrors `Audio`: `HapticCuePolicy` (Foundation only, deterministic) turns tick events into at most one pulse, completion over loss over validation, with the loss guard shared with the audio policy through `Domain/Feedback/FeedbackTiming`; `HapticFeedbackService` is a protocol implemented by UIKit generators (kept alive, prepared when a hold starts) and a silent variant; the ViewModel plays cues only when the persisted preference is on. The reveal-time vibration is removed so that one source of truth remains.
Consequences: audio and touch agree on validation, loss, cascade and completion; the loop "loss, pulse, phone jitter, loss" is bounded by the guard and by the 0.75 s hold; the game is fully playable with haptics off; the physical sensation still needs a human on device.

### ADR-19: Expansion chapters extend the environment; the historical campaign is frozen by fingerprint
Status: accepted
Context: chapters VII to XII add six mechanics (twins, gusts, echoes and sleepers, wells, campaign braises, their synthesis) to a campaign whose first 34 levels are human-validated and must not change in any observable way.
Decision: `Campaign` is split into `historicalChapters` (six, frozen) and `expansionChapters`; every mechanic lives in `LevelEnvironment` as resolved state (`TwinState`, `SouffleField`, `EchoField`/`EchoWave`/`SleeperState`, `GouffreField`) updated by `GameSession` before or after the historical per-target step, feeding the integrator only through `externalImpulse`, `BehaviourScale` and `canAccumulate`, so that a level without these elements runs the bit-identical reference step; each chapter names a `ChapterTheme` mapped in the presentation to a `DSThemePalette` (wash, accent, glow) with `chambreNoire` drawing exactly the historical tokens; `HistoricalCampaignFingerprintTests` compares a canonical dump of the 34 levels (fields, resolution, scripted trace) to a fixture byte for byte and checks the SHA-256 of the historical chapter sources, the Gaze Engine, the gaze filter and the physics integrator; every chapter is one atomic commit after the shared infrastructure commit.
Consequences: a change to a historical level or to the gaze path fails the suite; new chapters are plain data plus environment code; the simulated player (`CampaignBot`) learned each mechanic without changing its behaviour on historical levels; the human feel of chapters VII to XII is still to be judged on device.

## Forbidden
- Editing a historical chapter file, the Gaze Engine, `GazeFilter` or `TargetPhysics` without deliberately updating `HistoricalCampaignFingerprintTests` and its fixture, with a reason recorded in the README.
- An expansion mechanic that changes the step of a level that does not use it.
- A haptic call outside `HapticFeedbackService`, or a second loss-spacing constant next to `FeedbackTiming.lossRetriggerInterval`.
- Changing the bundle identifier, the development team or the signing style anywhere but in `project.yml` (README, « Apple Signing »).
- Views deciding destinations; navigation only through AppCoordinator or a Navigating protocol.
- Domain or GameEngine importing SwiftUI, UIKit, ARKit, AVFoundation, Combine.
- ViewModels importing SwiftUI or holding ARKit types.
- Singletons other than the container instance created by IrisApp.
- Allocations or locks that block inside SineSynth.render.
- Any WebView.
- A hard-coded interface orientation, axis sign, mirror, ppi or camera position on the calibrated gaze path.
- A campaign level that is not covered by CampaignSimulationTests, or a timer, score or failure state visible during play.
