# Architecture

## Overview
MVVM in the Presentation layer over a pure deterministic core (Domain and GameEngine) that knows nothing about ARKit, AVFoundation or SwiftUI. Platform capabilities (gaze, audio, frame clock) are protocols implemented in the AR, Audio and App layers and injected by a single composition root. Single app target, layers enforced by folders, imports and the layer audit.

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
│  AudioCuePolicy │   │  PhysicsConstants · LevelCatalog     │
└─────────────────┘   └──────────────────────────────────────┘
```
Allowed arrows: Presentation -> GameEngine, Domain, AR protocols, Audio protocols. AR and Audio -> Domain value types only. GameEngine -> Domain. Domain -> Foundation only.

## Feature map
```
Feature: Game
  Screens:        GameView (GameCanvasView, GameHUDView, GameOverlayView)
  ViewModels:     GameViewModel (GamePhase)
  Navigation:     GameNavigating -> AppCoordinator
  Engine:         GameSession, GameProgression, AudioCuePolicy
  Services:       GazeTrackingService, AudioService, GameClock, GameSettingsStore
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
├── .tutorial                  TutorialView
├── .game                      GameView, overlays by GamePhase:
│                                initializing, ready, playing, paused, levelComplete,
│                                interrupted, resuming, suspended, failed
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

## Forbidden
- Views deciding destinations; navigation only through AppCoordinator or a Navigating protocol.
- Domain or GameEngine importing SwiftUI, UIKit, ARKit, AVFoundation, Combine.
- ViewModels importing SwiftUI or holding ARKit types.
- Singletons other than the container instance created by IrisApp.
- Allocations or locks that block inside SineSynth.render.
- Any WebView.
- A hard-coded interface orientation, axis sign, mirror, ppi or camera position on the calibrated gaze path.
