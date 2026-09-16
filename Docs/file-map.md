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
| AR/Services/ARKitGazeTrackingService+Observation.swift | - | AR | PROTOTYPE observation only: derives head yaw, pitch and roll from the face anchor's rotation in the view | Claude (mission Iris) |
| AR/Services/ARKitGazeTrackingService.swift | class | AR | ARFaceTrackingConfiguration session producing raw metric gaze samples in the interface-oriented | Claude (mission Iris) |
| AR/Services/CameraAuthorizationService.swift | enum | AR | Camera permission status and request, abstracted from AVFoundation | Claude (mission Iris) |
| AR/Services/DeviceCapabilities.swift | protocol | AR | Hardware capability probe (TrueDepth face tracking) behind a protocol for tests and previews | Claude (mission Iris) |
| AR/Services/GazeObservation.swift | struct | AR | PROTOTYPE observation only: head orientation and eye geometry ARKit already provides for every frame, | Claude (mission Iris) |
| AR/Services/GazeTrackingService.swift | enum | AR | Abstraction over gaze acquisition. Produces raw, metric samples; calibration and mapping happen downstream. | Claude (mission Iris) |
| AR/Services/InterfaceOrientationProvider.swift | protocol | AR | The interface orientation actually used by the foreground window scene, never a hard-coded value | Claude (mission Iris) |
| AR/Services/SimulatedGazeTrackingService.swift | class | AR | Pointer-driven or scripted gaze for the simulator, previews and tests (no camera involved) | Claude (mission Iris) |
| App/DI/AppContainer.swift | class | App | Composition root. The only place concrete services are chosen. | Claude (mission Iris) |
| App/DI/AppEnvironment.swift | enum | App | Runtime flavour of the composition root | Claude (mission Iris) |
| App/IrisApp.swift | struct | App | Application entry point: builds the composition root and the coordinator once | Claude (mission Iris) |
| App/Persistence/InMemoryProgressStore.swift | class | App | Volatile progress for previews, tests and debug launches | Claude (mission Iris) |
| App/Persistence/UserDefaultsProgressStore.swift | class | App | Campaign progress stored as JSON in UserDefaults (records and éclats only, no gaze data) | Claude (mission Iris) |
| App/Platform/DeviceIdiom.swift | enum | App | Device idiom probe used to estimate the display geometry | Claude (mission Iris) |
| App/Platform/DisplayLinkGameClock.swift | class | App | CADisplayLink clock pinned to 60 Hz, the rate the reference engine was validated at | Claude (mission Iris) |
| App/Platform/LaunchOptions.swift | struct | App | Debug-only launch arguments used to reach any screen directly (simulator screenshots, manual QA) | Claude (mission Iris) |
| App/Platform/SystemLinks.swift | enum | App | System URLs the presentation layer may open (app settings) | Claude (mission Iris) |
| Audio/Policy/AudioCue.swift | enum | Audio | Sound intents derived from game events, independent from AVAudioEngine | Claude (mission Iris) |
| Audio/Policy/AudioCuePolicy.swift | struct | Audio | Sound policy: crescendo per target, one chime per validation (arpeggio for the last one), | Claude (mission Iris) |
| Audio/Services/AVAudioEngineAudioService.swift | class | Audio | AVAudioEngine host for the sine synthesizer, with audio session, interruption and reset handling | Claude (mission Iris) |
| Audio/Services/AudioService.swift | enum | Audio | Sound output abstraction: cues in, status out | Claude (mission Iris) |
| Audio/Services/NotificationObserverBag.swift | class | Audio | Owns NotificationCenter observer tokens and removes them when its owner is deallocated | Claude (mission Iris) |
| Audio/Services/SilentAudioService.swift | class | Audio | No-op audio used by previews and by the app when the audio engine cannot start | Claude (mission Iris) |
| Audio/Synth/SineSynth.swift | class | Audio | Allocation-free sine synthesizer reproducing the reference engine's Web Audio graph | Claude (mission Iris) |
| Commerce/Products/StoreProductID.swift | enum | Commerce | The App Store product identifiers of Iris, written once and nowhere else, and the right each one grants | Claude (mission Iris) |
| Commerce/Services/StaticEntitlementService.swift | class | Commerce | A store that answers from a fixed right: previews and tests exercise the interface and the access rules | Claude (mission Iris) |
| Commerce/Services/StoreKitEntitlementService.swift | class | Commerce | The only place in Iris that talks to StoreKit. It reads the rights the player holds (verified | Claude (mission Iris) |
| Commerce/Services/StorePurchaseOutcome.swift | enum | Commerce | How the last store call ended, in words the interface can show without knowing StoreKit | Claude (mission Iris) |
| Commerce/Services/StorePurchasing.swift | protocol | Commerce | What the paywall may ask of the store: the price as the store formats it, buy, restore, re-read the | Claude (mission Iris) |
| DesignSystem/Components/DSBackground.swift | struct | DesignSystem | The interface's chambre noire (identity tokens): ink ground, abyss centre, the spectral environment that | Claude (mission Iris) |
| DesignSystem/Components/DSBadge.swift | struct | DesignSystem | Small status pill (success, danger, info, neutral, accent): the system's glass carries it on iOS 26, its | Claude (mission Iris) |
| DesignSystem/Components/DSButton.swift | struct | DesignSystem | Primary, secondary and ghost actions, 52 pt minimum height: on the system's Liquid Glass the material is | Claude (mission Iris) |
| DesignSystem/Components/DSEclats.swift | struct | DesignSystem | Three arcs around a circle, lit or unlit: the mastery marks of a level | Claude (mission Iris) |
| DesignSystem/Components/DSGlyph.swift | struct | DesignSystem | Hand-drawn glyphs of the game's ideas (no SF Symbols in the game vocabulary) | Claude (mission Iris) |
| DesignSystem/Components/DSIrisMark.swift | struct | DesignSystem | The Iris emblem: a six-blade amber diaphragm around a pearl lueur, optionally breathing | Claude (mission Iris) |
| DesignSystem/Components/DSOverlayPanel.swift | struct | DesignSystem | Veil over the game, lit by the spectral environment, with a centred title, subtitle and actions | Claude (mission Iris) |
| DesignSystem/Components/DSProgressRing.swift | struct | DesignSystem | Circular progress used for journey completion and hold progress readouts | Claude (mission Iris) |
| DesignSystem/Components/DSScreen.swift | struct | DesignSystem | Page container: atmosphere background, safe-area aware column, consistent gutters, and content softened | Claude (mission Iris) |
| DesignSystem/Components/DSSpectralEnvironment.swift | struct | DesignSystem | The light Iris puts behind Apple's glass. A few very dark spectral fields — indigo low on the screen, | Claude (mission Iris) |
| DesignSystem/Components/DSStatusRow.swift | struct | DesignSystem | Icon, title, detail and a coloured state dot; used for capability and permission lists | Claude (mission Iris) |
| DesignSystem/Components/DSThemeWash.swift | struct | DesignSystem | Tints the chambre noire with a chapter's wash and a soft glow at the top; draws nothing for the historical palette | Claude (mission Iris) |
| DesignSystem/Glass/DSGlassBarBehaviour.swift | struct | DesignSystem | The behaviours the system's own bars offer (a tab bar that steps aside while scrolling, softened edges | Claude (mission Iris) |
| DesignSystem/Glass/DSGlassButtonStyle.swift | struct | DesignSystem | Actions on Apple's own glass: the system's `.glass` button style on iOS 26, the historical painted | Claude (mission Iris) |
| DesignSystem/Glass/DSGlassGroup.swift | struct | DesignSystem | Neighbouring glass elements share one glass layer on iOS 26 (no glass on glass, coherent morphing, fewer | Claude (mission Iris) |
| DesignSystem/Glass/DSGlassModifier.swift | struct | DesignSystem | `.dsGlass(role)`: draws a view on the glass of its role (its recipe), native Liquid Glass on iOS 26 and | Claude (mission Iris) |
| DesignSystem/Glass/DSGlassPanel.swift | struct | DesignSystem | A panel of text and controls laid on the glass of its role: native Liquid Glass on iOS 26, the role's | Claude (mission Iris) |
| DesignSystem/Glass/DSGlassRecipe.swift | struct | DesignSystem | The native Liquid Glass a surface uses: the system variant (clear or regular), an optional tint laid in | Claude (mission Iris) |
| DesignSystem/Glass/DSGlassRendering.swift | enum | DesignSystem | The one place deciding how glass is drawn: native Liquid Glass on iOS 26, a light plain surface before, | Claude (mission Iris) |
| DesignSystem/Glass/DSGlassRole.swift | enum | DesignSystem | The four intentions of glass in Iris (clear control, regular panel, chrome, prominent action): each role | Claude (mission Iris) |
| DesignSystem/Glass/DSGlassShape.swift | enum | DesignSystem | The few shapes glass may take: a circle for icons, a capsule where it means something, a moderately | Claude (mission Iris) |
| DesignSystem/Glass/DSGlassSurface.swift | struct | DesignSystem | The plain surface standing in for glass: translucent where Liquid Glass is unavailable, opaque under | Claude (mission Iris) |
| DesignSystem/Modifiers/DSEyebrowStyle.swift | struct | DesignSystem | Small uppercase tracked label style used for section markers and HUD readouts | Claude (mission Iris) |
| DesignSystem/Modifiers/DSGlow.swift | struct | DesignSystem | Soft coloured glow used for the iris mark and validated states | Claude (mission Iris) |
| DesignSystem/Tokens/DSColor.swift | enum | DesignSystem | Colour tokens by role: interface identity, navigation, states, and the chapters' game world (values live | Claude (mission Iris) |
| DesignSystem/Tokens/DSFont.swift | enum | DesignSystem | Typography tokens: New York serif titles in lowercase, SF for reading, all Dynamic Type aware | Claude (mission Iris) |
| DesignSystem/Tokens/DSMotion.swift | enum | DesignSystem | Motion tokens; every animation has a Reduce Motion variant (cross-fade only) | Claude (mission Iris) |
| DesignSystem/Tokens/DSRadius.swift | enum | DesignSystem | Corner radius scale | Claude (mission Iris) |
| DesignSystem/Tokens/DSSpacing.swift | enum | DesignSystem | Spacing scale on a 4 pt grid | Claude (mission Iris) |
| DesignSystem/Tokens/DSThemePalette.swift | struct | DesignSystem | The few colours a chapter identity adds to the chambre noire: its attention accent, its glow, and the | Claude (mission Iris) |
| Domain/Access/AccessEntitlement.swift | enum | Domain | What the player is entitled to play: the free chapters only, a temporary promotional access, or the | Claude (mission Iris) |
| Domain/Access/AccessPolicy.swift | enum | Domain | The one business rule of the commercial model: how many chapters are free, and whether a chapter or a | Claude (mission Iris) |
| Domain/Access/EntitlementProviding.swift | protocol | Domain | All the rest of Iris may ask about the player's commercial rights: one value. Never a product, never a | Claude (mission Iris) |
| Domain/Campaign/BaliseSequenceDefinition.swift | struct | Domain | PROTOTYPE (chapter I level 6): balises wake under a brief, steady gaze, one after the other along a | Claude (mission Iris) |
| Domain/Campaign/BraiseDefinition.swift | struct | Domain | EXPERIMENTAL (prototype B1, not in the campaign): tuning of a braise, a cold lueur that the gaze warms and | Claude (mission Iris) |
| Domain/Campaign/BraisesPrototype.swift | enum | Domain | EXPERIMENTAL, human-validated prototype Braises A: one level testing the braise idea, outside the campaign (chapter 0, DEBUG only) | Claude (mission Iris) |
| Domain/Campaign/Campaign+Braises.swift | - | Domain | Chapter XI, Braises: the cold lueur that a brief gaze wakes (tuning A, human-validated and frozen), met | Claude (mission Iris) |
| Domain/Campaign/Campaign+Clairvoyance.swift | - | Domain | Chapter VI, Clairvoyance: gliding irises, then every idea combined | Claude (mission Iris) |
| Domain/Campaign/Campaign+Constellation.swift | - | Domain | Chapter XII, Constellation: the finale weaves the ideas of chapters VII to XI together, up to the last iris, | Claude (mission Iris) |
| Domain/Campaign/Campaign+Courants.swift | - | Domain | Chapter III, Courants: the gaze becomes a force that pushes | Claude (mission Iris) |
| Domain/Campaign/Campaign+Echos.swift | - | Domain | Chapter IX, Échos: sleeping lueurs wake only when the echo of a closing iris reaches them; bring them within | Claude (mission Iris) |
| Domain/Campaign/Campaign+Eveil.swift | - | Domain | Chapter I, Éveil: the gaze repels; hold; stay on the screen; two lueurs; temperaments | Claude (mission Iris) |
| Domain/Campaign/Campaign+FinalBraises.swift | - | Domain | OCULOMOTOR EXPANSION, chapter XI final « d'abord les yeux » (eye-head coordination, saccade-first gaze | Claude (mission Iris) |
| Domain/Campaign/Campaign+FinalClairvoyance.swift | - | Domain | OCULOMOTOR EXPANSION, chapter VI final « le jardin caché » (visual search, systematic scanning): among | Claude (mission Iris) |
| Domain/Campaign/Campaign+FinalConstellation.swift | - | Domain | OCULOMOTOR EXPANSION, chapter XII final « l'orchestre du regard » (multi-modal oculomotor sequencing): | Claude (mission Iris) |
| Domain/Campaign/Campaign+FinalCourants.swift | - | Domain | OCULOMOTOR EXPANSION, chapter III final « le fil vivant » (smooth pursuit): a spark glides along a smooth | Claude (mission Iris) |
| Domain/Campaign/Campaign+FinalEchos.swift | - | Domain | OCULOMOTOR EXPANSION, chapter IX final « l'absence » (fixation disengagement, gap and overlap shifts): a | Claude (mission Iris) |
| Domain/Campaign/Campaign+FinalGouffres.swift | - | Domain | OCULOMOTOR EXPANSION, chapter X final « l'ancre » (gaze stabilisation while the head moves, VOR-inspired): a | Claude (mission Iris) |
| Domain/Campaign/Campaign+FinalJumelles.swift | - | Domain | OCULOMOTOR EXPANSION, chapter VII final « croisement » (diagonal saccades, variable amplitude): the twins | Claude (mission Iris) |
| Domain/Campaign/Campaign+FinalPartage.swift | - | Domain | OCULOMOTOR EXPANSION, chapter II final « le cœur de verre » (fixation stability, distractor inhibition): | Claude (mission Iris) |
| Domain/Campaign/Campaign+FinalSouffles.swift | - | Domain | OCULOMOTOR EXPANSION, chapter VIII final « la lanterne du courant » (predictive pursuit, anticipation): a | Claude (mission Iris) |
| Domain/Campaign/Campaign+FinalVeilleuses.swift | - | Domain | OCULOMOTOR EXPANSION, chapter V final « les étoiles absentes » (memory-guided saccades): stars shine | Claude (mission Iris) |
| Domain/Campaign/Campaign+FinalVoiles.swift | - | Domain | OCULOMOTOR EXPANSION, chapter IV final « le miroir menteur » (anti-saccade): a lure flashes on one side, | Claude (mission Iris) |
| Domain/Campaign/Campaign+Gouffres.swift | - | Domain | Chapter X, Gouffres: wells pull what comes near and send what they swallow back to its start; | Claude (mission Iris) |
| Domain/Campaign/Campaign+Jumelles.swift | - | Domain | Chapter VII, Jumelles: twin lueurs have no iris, each is the iris of the other; bring them within reach | Claude (mission Iris) |
| Domain/Campaign/Campaign+Oculomoteur.swift | - | Domain | PROTOTYPE, branch prototype/ch1-oculomotor-level6 only: chapter I level 6, a thread of balises around a | Claude (mission Iris) |
| Domain/Campaign/Campaign+OculomotorFinals.swift | - | Domain | OCULOMOTOR EXPANSION: the optional final level of each chapter II to XII, one gaze paradigm each, | Claude (mission Iris) |
| Domain/Campaign/Campaign+Partage.swift | - | Domain | Chapter II, Partage: order, crossing, guard, cascade, three lueurs | Claude (mission Iris) |
| Domain/Campaign/Campaign+Souffles.swift | - | Domain | Chapter VIII, Souffles: a gust travels its track periodically and carries what it crosses over the veils; | Claude (mission Iris) |
| Domain/Campaign/Campaign+Veilleuses.swift | - | Domain | Chapter V, Veilleuses: look at something without disturbing the rest | Claude (mission Iris) |
| Domain/Campaign/Campaign+Voiles.swift | - | Domain | Chapter IV, Voiles: push around what the lueur cannot cross | Claude (mission Iris) |
| Domain/Campaign/Campaign.swift | enum | Domain | The authored campaign: the six historical chapters (34 levels, frozen; see Design/LEVEL_DESIGN_SYSTEM.md) | Claude (mission Iris) |
| Domain/Campaign/ChapterDefinition.swift | struct | Domain | A campaign chapter: numeral, name, principle, ambient tone, visual theme and its levels | Claude (mission Iris) |
| Domain/Campaign/ChapterTheme.swift | enum | Domain | The visual identity a chapter asks for: the historical chapters keep the chambre noire untouched, | Claude (mission Iris) |
| Domain/Campaign/CurrentDefinition.swift | struct | Domain | R-24 a band where lueurs are carried in one direction | Claude (mission Iris) |
| Domain/Campaign/EchoDefinition.swift | struct | Domain | Chapter IX: the echo of a closing iris, a ring that wakes the sleeping lueurs it reaches and launches them; | Claude (mission Iris) |
| Domain/Campaign/GameElement.swift | enum | Domain | The ideas a player meets along the campaign (level intro "nouveau" chip and the Carnet) | Claude (mission Iris) |
| Domain/Campaign/GouffreDefinition.swift | struct | Domain | Chapter X: a well in the field; it pulls the lueurs that come near and sends what it swallows back to its start | Claude (mission Iris) |
| Domain/Campaign/IrisMotion.swift | enum | Domain | R-27 whether an iris stays still or glides back and forth | Claude (mission Iris) |
| Domain/Campaign/LevelDefinition.swift | struct | Domain | One authored campaign level: intention, lueurs, elements, tuning, hints and par | Claude (mission Iris) |
| Domain/Campaign/LevelHint.swift | enum | Domain | Contextual instruction shown once when the player does (or fails to do) something | Claude (mission Iris) |
| Domain/Campaign/LevelPar.swift | struct | Domain | Reference time and intrusion count behind the "fluide" and "serein" éclats | Claude (mission Iris) |
| Domain/Campaign/LueurDefinition.swift | struct | Domain | One authored lueur: start, iris, temperament, iris motion, the designer's intended route, an | Claude (mission Iris) |
| Domain/Campaign/OculoDefinition.swift | enum | Domain | OCULOMOTOR EXPANSION: a level may open with a sequence of gaze-contingent stages (one per paradigm), | Claude (mission Iris) |
| Domain/Campaign/SouffleDefinition.swift | struct | Domain | Chapter VIII: a gust that travels a track periodically and carries the lueurs it crosses, over veils | Claude (mission Iris) |
| Domain/Campaign/Temperament.swift | enum | Domain | R-28 how strongly a lueur reacts to the gaze and to its iris | Claude (mission Iris) |
| Domain/Campaign/VeilDefinition.swift | struct | Domain | R-25 an impenetrable segment | Claude (mission Iris) |
| Domain/Campaign/VeilleuseDefinition.swift | struct | Domain | R-26 a flame that dies unless looked at; while dark it closes the irises it lights | Claude (mission Iris) |
| Domain/Entities/Level.swift | struct | Domain | One of the fourteen levels: its targets, hold duration and sequencing mode | Claude (mission Iris) |
| Domain/Entities/LevelID.swift | struct | Domain | Typed identity of a level (`level_01` ... `level_14` in the reference engine) | Claude (mission Iris) |
| Domain/Entities/Target.swift | struct | Domain | Runtime state of one sphere: position, velocity, destination, hold progress and validation | Claude (mission Iris) |
| Domain/Entities/TargetBlueprint.swift | struct | Domain | Static description of one target of a level (the reference engine's level target config) | Claude (mission Iris) |
| Domain/Entities/TargetID.swift | struct | Domain | Typed identity of a target inside a level; the sequence number is unique per level | Claude (mission Iris) |
| Domain/Feedback/FeedbackTiming.swift | enum | Domain | Spacing shared by every loss feedback (tone and pulse): one perceptible loss event, never a burst (R-15) | Claude (mission Iris) |
| Domain/Levels/LevelDifficulty.swift | struct | Domain | Difficulty band parameters exactly as defined by the reference engine's `buildLevel` | Claude (mission Iris) |
| Domain/Levels/PrototypeLevelCatalog.swift | enum | Domain | The prototype's fourteen levels (historical reference for golden traces), generated exactly like the reference engine (same seeds, same order of draws) | Claude (mission Iris) |
| Domain/Physics/PhysicsConstants.swift | struct | Domain | Physical constants of the reference engine, expressed per 60 Hz reference frame | Claude (mission Iris) |
| Domain/Progress/CampaignProgress.swift | struct | Domain | Unlock rules and records of the campaign | Claude (mission Iris) |
| Domain/Progress/Eclat.swift | enum | Domain | The three mastery marks of a level | Claude (mission Iris) |
| Domain/Progress/LevelOutcome.swift | struct | Domain | Measurements of one completed attempt and the éclats they earn | Claude (mission Iris) |
| Domain/Progress/LevelRecord.swift | struct | Domain | Best results kept for one level (no gaze data) | Claude (mission Iris) |
| Domain/Progress/ProgressStore.swift | protocol | Domain | Persistence contract of the campaign progress | Claude (mission Iris) |
| Domain/Random/LinearCongruentialGenerator.swift | struct | Domain | Deterministic generator identical to the reference engine's `rngFor` / `makeNoise1D` (9301, 49297, 233280) | Claude (mission Iris) |
| Domain/Validation/CascadeRule.swift | enum | Domain | R-11 cascade: losing a validation invalidates every validated target of higher rank | Claude (mission Iris) |
| Domain/Validation/TurnRule.swift | enum | Domain | R-09 sequence rule: validation only counts for the lowest unvalidated sequence number | Claude (mission Iris) |
| Domain/Validation/ValidationRule.swift | struct | Domain | R-08 continuous 0.75 s presence and R-10 wobble tolerance loss, applied to one target per tick | Claude (mission Iris) |
| Domain/Validation/ValidationRules.swift | struct | Domain | Distances governing validation and its loss (R-08, R-10) | Claude (mission Iris) |
| Domain/Validation/ValidationTransition.swift | enum | Domain | Outcome of applying the validation rule to one target during one tick | Claude (mission Iris) |
| Domain/ValueObjects/HeadPose.swift | struct | Domain | Head orientation the game may read (degrees, deltas only make sense within a session); provided by the | Claude (mission Iris) |
| Domain/ValueObjects/NormalizedPoint.swift | struct | Domain | Resolution-independent position (0...1 on both axes), resolved against the playfield at load time | Claude (mission Iris) |
| Domain/ValueObjects/NormalizedRect.swift | struct | Domain | Resolution-independent rectangle (0...1 on both axes), resolved against the playfield at load time | Claude (mission Iris) |
| Domain/ValueObjects/PlayfieldBounds.swift | struct | Domain | Size of the game space in points; the reference engine used the browser window size | Claude (mission Iris) |
| Domain/ValueObjects/Vector2.swift | struct | Domain | Two-dimensional vector in playfield points (the reference engine's canvas pixels) | Claude (mission Iris) |
| Features/CameraAccess/CameraAccessNavigating.swift | protocol | Presentation | Navigation intents emitted by the camera permission screen | Claude (mission Iris) |
| Features/CameraAccess/CameraAccessView.swift | struct | Presentation | Explains why the TrueDepth camera is needed and handles denied and restricted states | Claude (mission Iris) |
| Features/CameraAccess/CameraAccessViewModel.swift | class | Presentation | Camera permission flow: explanation, request, denied and restricted states | Claude (mission Iris) |
| Features/Carnet/CarnetView.swift | struct | Presentation | The ideas met so far, one glyph and one sentence each; the others stay unknown | Claude (mission Iris) |
| Features/Chapters/AdaptiveLevelRow.swift | struct | Presentation | Lays a chapter's level buttons out inside exactly the width it is offered (see AdaptiveLevelRowMetrics): | Claude (mission Iris) |
| Features/Chapters/AdaptiveLevelRowMetrics.swift | struct | Presentation | Geometry of a chapter's level buttons inside the width the card gives them: as many per row as fit with | Claude (mission Iris) |
| Features/Chapters/ChapterCard.swift | struct | Presentation | One chapter on the map: numeral, name, principle, level nodes, progress; locked state. Everything inside | Claude (mission Iris) |
| Features/Chapters/ChapterLockNotice.swift | struct | Presentation | What a chapter says when it belongs to the full access: it stays visible and named, states its condition | Claude (mission Iris) |
| Features/Chapters/ChaptersView.swift | struct | Presentation | The map: every chapter, its levels and éclats; choose a level to play | Claude (mission Iris) |
| Features/Chapters/LevelNode.swift | struct | Presentation | One level on the chapter map: number, éclats arcs, locked / available / next / completed; a square touch | Claude (mission Iris) |
| Features/Game/Diagnostics/AncreCapture.swift | class | Presentation | Chapter X final « l'ancre »: a short local JSON Lines capture, started only by the `--iris-capture` launch | Claude (mission Iris) |
| Features/Game/Diagnostics/OculomotorTrace.swift | class | Presentation | PROTOTYPE (chapter I level 6): observes, never steers. Classifies every gaze sample (VALID_INSIDE, | Claude (mission Iris) |
| Features/Game/Rendering/AncreSceneSnapshot.swift | struct | Presentation | Chapter X final « l'ancre »: plain description of the loop scene (silhouette, segmented ring, checkpoints, | Claude (mission Iris) |
| Features/Game/Rendering/AncreSilhouette.swift | enum | Presentation | Chapter X final « l'ancre »: the head-and-shoulders silhouette that frames the anchor, traced from the | Claude (mission Iris) |
| Features/Game/Rendering/GameSceneRenderer+Ancre.swift | - | Presentation | Chapter X final « l'ancre »: draws the silhouette traced from the reference image, the segmented ring that | Claude (mission Iris) |
| Features/Game/Rendering/GameSceneRenderer+Oculo.swift | - | Presentation | OCULOMOTOR EXPANSION: draws the current gaze stage from its scene description, by role, in the chapter | Claude (mission Iris) |
| Features/Game/Rendering/GameSceneRenderer.swift | struct | Presentation | Draws the chambre noire world: currents, veils, route help, irises, veilleuses, lueurs, trouble, diagnostics, | Claude (mission Iris) |
| Features/Game/Rendering/GameSceneSnapshot.swift | struct | Presentation | Plain values copied from the session once per frame; the only thing the canvas reads | Claude (mission Iris) |
| Features/Game/Rendering/OculoSnapshot.swift | enum | Presentation | OCULOMOTOR EXPANSION: plain scene description of the current gaze stage, built from the engine state once | Claude (mission Iris) |
| Features/Game/ViewModels/GameNavigating.swift | protocol | Presentation | Intents and progress reports emitted by the game screen | Claude (mission Iris) |
| Features/Game/ViewModels/GamePhase.swift | enum | Presentation | Single state of the game screen; every overlay derives from it | Claude (mission Iris) |
| Features/Game/ViewModels/GameSettingsStore.swift | class | Presentation | Small persisted preferences (sound effects, ambience, haptics, gaze diagnostics). No gaze data is ever stored. | Claude (mission Iris) |
| Features/Game/ViewModels/GameViewModel.swift | class | Presentation | Owns one play session: campaign level, engine loop, gaze mapping, hints, audio, haptics, results and phases | Claude (mission Iris) |
| Features/Game/ViewModels/GazeCalibrationStatus.swift | enum | Presentation | What the game knows about the calibration in use (pause panel readout) | Claude (mission Iris) |
| Features/Game/ViewModels/LevelResult.swift | struct | Presentation | What the result screen shows after a level: measurements, éclats and what comes next | Claude (mission Iris) |
| Features/Game/Views/GameCanvasView.swift | struct | Presentation | Draws one scene snapshot; re-evaluated only when the snapshot changes | Claude (mission Iris) |
| Features/Game/Views/GameFieldBackground.swift | struct | Presentation | The field behind a level: the chambre noire drawn from chapter tokens only, so a new interface background | Claude (mission Iris) |
| Features/Game/Views/GameHUDView.swift | struct | Presentation | Peripheral HUD over the running level: level mark, the pause control and the contextual hint on the | Claude (mission Iris) |
| Features/Game/Views/GameOverlayView.swift | struct | Presentation | One overlay per game phase: intro, pause, result, interruption, face lost, resume, suspension, failure | Claude (mission Iris) |
| Features/Game/Views/GameView.swift | struct | Presentation | The game screen: chambre noire background, chapter wash, world canvas, peripheral HUD and phase overlays | Claude (mission Iris) |
| Features/Game/Views/LevelIntroCard.swift | struct | Presentation | What the level asks, in three seconds; a compact panel on the system's glass so the level stays readable | Claude (mission Iris) |
| Features/Game/Views/LevelResultView.swift | struct | Presentation | "atteint": three éclats lighting one after the other, measurements, next / replay / chapters | Claude (mission Iris) |
| Features/GazeSetup/ViewModels/GazeSetupIntent.swift | enum | Presentation | Why the gaze setup runs: first launch, quick revalidation of a stored profile, or manual recalibration | Claude (mission Iris) |
| Features/GazeSetup/ViewModels/GazeSetupNavigating.swift | protocol | Presentation | Navigation intents emitted by the gaze setup screen | Claude (mission Iris) |
| Features/GazeSetup/ViewModels/GazeSetupPhase.swift | struct | Presentation | Single state of the gaze setup screen: readiness, calibration, validation, verdicts and failures | Claude (mission Iris) |
| Features/GazeSetup/ViewModels/GazeSetupViewModel.swift | class | Presentation | Runs diagnostic, nine-point calibration, five-point validation and persists the profile | Claude (mission Iris) |
| Features/GazeSetup/Views/FixationTargetView.swift | struct | Presentation | One calibration or validation target positioned in normalized coordinates, with progress, stage label and | Claude (mission Iris) |
| Features/GazeSetup/Views/GazeReadinessView.swift | struct | Presentation | Diagnostic checklist with a central fixation mark | Claude (mission Iris) |
| Features/GazeSetup/Views/GazeSetupView.swift | struct | Presentation | Gaze diagnostic, calibration targets, validation and verdict screens | Claude (mission Iris) |
| Features/GazeSetup/Views/GazeVerdictView.swift | struct | Presentation | "Regard prêt" or "La précision peut être améliorée" with measured errors and actions | Claude (mission Iris) |
| Features/Home/HomeView.swift | struct | Presentation | The threshold: emblem, promise, one main action (begin or continue). Settings live in the navigation | Claude (mission Iris) |
| Features/HowToPlay/HowToPlayView.swift | struct | Presentation | The same four explanations, available for good from the threshold and the settings; the sheet's title and | Claude (mission Iris) |
| Features/JourneyComplete/JourneyCompleteView.swift | struct | Presentation | The end of the campaign: the last iris closed, éclats and play time, replay a chapter | Claude (mission Iris) |
| Features/Onboarding/OnboardingFigure.swift | struct | Presentation | The drawing that explains one rule of Iris: a gaze, its attention zone, a sphere and the iris waiting for | Claude (mission Iris) |
| Features/Onboarding/OnboardingPage.swift | struct | Presentation | The four things a new player must understand before the first level, each one a figure and two lines. | Claude (mission Iris) |
| Features/Onboarding/OnboardingStore.swift | class | Presentation | Whether the four explanation screens have already been shown. One flag on the device, nothing else | Claude (mission Iris) |
| Features/Onboarding/OnboardingView.swift | struct | Presentation | The four screens shown once, at the first launch: how the gaze moves a sphere, and where it must go. | Claude (mission Iris) |
| Features/Paywall/OfferCodeRedemption.swift | struct | Presentation | Apple's own code redemption sheet, and the ONLY place in the interface that reaches StoreKit. Iris has no | Claude (mission Iris) |
| Features/Paywall/PaywallCopy.swift | enum | Presentation | The sentences of the commercial screens, every one of them derived from the access policy and from the | Claude (mission Iris) |
| Features/Paywall/PaywallView.swift | struct | Presentation | What the full access is, what it costs according to the store, and the three ways in: buy once, restore, | Claude (mission Iris) |
| Features/Settings/SettingsView.swift | struct | Presentation | Sound effects, ambience, haptics, gaze diagnostics, recalibration, progress reset, privacy note; the | Claude (mission Iris) |
| Features/Shared/ChapterTheme+Palette.swift | - | Presentation | Maps each chapter theme of the domain to its design-system palette | Claude (mission Iris) |
| Features/Shared/GameElement+Glyph.swift | - | Presentation | Maps the domain's game elements to design-system glyphs | Claude (mission Iris) |
| Features/Unavailable/UnavailableView.swift | struct | Presentation | Shown when the device cannot track faces (no TrueDepth / ARFaceTracking unsupported) | Claude (mission Iris) |
| GameEngine/Campaign/HintTracker.swift | struct | GameEngine | Decides which contextual instruction is visible, from engine events and elapsed time | Claude (mission Iris) |
| GameEngine/Campaign/LevelResolver.swift | enum | GameEngine | Resolves a LevelDefinition against the playfield: scale, zone, forces, elements, routes | Claude (mission Iris) |
| GameEngine/Campaign/ResolvedLevel.swift | struct | GameEngine | A campaign level turned into engine values for one playfield size | Claude (mission Iris) |
| GameEngine/Clock/GameClock.swift | protocol | GameEngine | Frame source abstraction: delivers deltaTime ticks to the game loop | Claude (mission Iris) |
| GameEngine/Clock/ManualGameClock.swift | class | GameEngine | Deterministic clock driven by tests and previews | Claude (mission Iris) |
| GameEngine/Environment/BaliseSequenceState.swift | struct | GameEngine | PROTOTYPE (chapter I level 6) resolved thread of balises: only the balise the thread designates can wake, | Claude (mission Iris) |
| GameEngine/Environment/BraiseState.swift | struct | GameEngine | EXPERIMENTAL (prototype B1): resolved braise and its heat; lit with hysteresis, flaring above a threshold | Claude (mission Iris) |
| GameEngine/Environment/CurrentField.swift | struct | GameEngine | R-24 resolved current: an axis-aligned band applying a constant impulse | Claude (mission Iris) |
| GameEngine/Environment/EchoField.swift | struct | GameEngine | Chapter IX resolved echo: the reach, speed, breathing interval and launch of the rings that closing irises | Claude (mission Iris) |
| GameEngine/Environment/GouffreField.swift | struct | GameEngine | Chapter X resolved well: mouth, pull and the swallow it inflicts (a hold, then the return to the start) | Claude (mission Iris) |
| GameEngine/Environment/IrisPath.swift | struct | GameEngine | R-27 resolved gliding iris: cosine ease between two points | Claude (mission Iris) |
| GameEngine/Environment/LevelEnvironment.swift | struct | GameEngine | Everything a campaign level adds around the historical engine (empty for prototype levels) | Claude (mission Iris) |
| GameEngine/Environment/SouffleField.swift | struct | GameEngine | Chapter VIII resolved gust: a disc travelling its track at constant speed, present during the duty share of | Claude (mission Iris) |
| GameEngine/Environment/TwinState.swift | struct | GameEngine | Chapter VII resolved twin: its partner, the poste where it waits, and the reach hysteresis of the link | Claude (mission Iris) |
| GameEngine/Environment/VeilSegment.swift | struct | GameEngine | R-25 resolved veil and its circle-segment collision response | Claude (mission Iris) |
| GameEngine/Environment/VeilleuseState.swift | struct | GameEngine | R-26 resolved veilleuse and its charge | Claude (mission Iris) |
| GameEngine/Gaze/GazeFilter.swift | struct | GameEngine | R-13 port of the reference gaze listener: exponential smoothing (alpha 0.1) and sustained-jump gating | Claude (mission Iris) |
| GameEngine/Noise/NoiseSource.swift | protocol | GameEngine | One-dimensional organic noise abstraction so the engine can be driven by deterministic or silent noise | Claude (mission Iris) |
| GameEngine/Noise/SilentNoise.swift | struct | GameEngine | Zero noise, used by tests and previews that need fully predictable motion | Claude (mission Iris) |
| GameEngine/Noise/ValueNoise1D.swift | struct | GameEngine | Port of `makeNoise1D`: 256 random values, smoothstep interpolation (Perlin-like value noise) | Claude (mission Iris) |
| GameEngine/Oculo/AbsenceStageState.swift | struct | GameEngine | Chapter IX final: trials of a presence held by the gaze, then an answer elsewhere; in a gap trial the | Claude (mission Iris) |
| GameEngine/Oculo/AncreStageState.swift | struct | GameEngine | Chapter X final: one loop of « l'ancre ». The eyes are the criterion only around the circle: the loop begins | Claude (mission Iris) |
| GameEngine/Oculo/CoeurStageState.swift | struct | GameEngine | Chapter II final: the heart warms while the gaze rests on it (hysteresis), cools while it is away; sparks | Claude (mission Iris) |
| GameEngine/Oculo/CourantStageState.swift | struct | GameEngine | Chapter VIII final: a lantern carried along a smooth closed loop with a gentle drift of pace; once the first | Claude (mission Iris) |
| GameEngine/Oculo/CroisementStageState.swift | struct | GameEngine | Chapter VII final: two twins on a diagonal; the breathing one is acquired by a dwell and hands over to her | Claude (mission Iris) |
| GameEngine/Oculo/EtoilesStageState.swift | struct | GameEngine | Chapter V final: rounds of stars shown, hidden, then recalled by dwelling where they were; a wrong place | Claude (mission Iris) |
| GameEngine/Oculo/FilStageState.swift | struct | GameEngine | Chapter III final: the spark's smooth loop (two harmonics), the accompaniment account that grows while | Claude (mission Iris) |
| GameEngine/Oculo/JardinStageState.swift | struct | GameEngine | Chapter VI final: batches of breathing seeds among twinkling ones; a rest on a breathing seed sprouts it, | Claude (mission Iris) |
| GameEngine/Oculo/MiroirStageState.swift | struct | GameEngine | Chapter IV final: cycles of a lure flashing on one side and a door open on the opposite side; a gaze that | Claude (mission Iris) |
| GameEngine/Oculo/OculoStageState.swift | struct | GameEngine | OCULOMOTOR EXPANSION: the resolved gaze-contingent stages of a level and their sequence. Every stage is a | Claude (mission Iris) |
| GameEngine/Oculo/TournerStageState.swift | struct | GameEngine | Chapter XI final: braises light up at the edge of the field one after another; the gaze reaches each one, | Claude (mission Iris) |
| GameEngine/Physics/TargetPhysics.swift | struct | GameEngine | R-01...R-07 frame-rate independent integration of one target, equivalent to the reference engine at 60 Hz | Claude (mission Iris) |
| GameEngine/Session/GameEvent.swift | enum | GameEngine | Facts produced by one engine tick, consumed by audio, haptics, hints and presentation | Claude (mission Iris) |
| GameEngine/Session/GameSession.swift | struct | GameEngine | Deterministic per-level simulation: physics, environment, validation, cascade, metrics and events | Claude (mission Iris) |
| GameEngine/Session/SessionMetrics.swift | struct | GameEngine | What the session measured for the mastery éclats (counts only, no gaze trace) | Claude (mission Iris) |
| Haptics/Policy/HapticCue.swift | enum | Haptics | Touch intents derived from game events, independent from UIKit | Claude (mission Iris) |
| Haptics/Policy/HapticCuePolicy.swift | struct | Haptics | Touch policy: at most one pulse per tick (completion over loss over validation), one loss per cascade, | Claude (mission Iris) |
| Haptics/Services/HapticFeedbackService.swift | protocol | Haptics | Touch output abstraction: cues in, nothing out | Claude (mission Iris) |
| Haptics/Services/SilentHapticFeedbackService.swift | class | Haptics | No-op touch feedback used by previews | Claude (mission Iris) |
| Haptics/Services/UIKitHapticFeedbackService.swift | class | Haptics | UIKit feedback generators kept alive for the session: medium impact for a validation, soft impact for a loss, | Claude (mission Iris) |
| Navigation/AppCoordinator.swift | class | Presentation | Deterministic route state machine and owner of the campaign progress | Claude (mission Iris) |
| Navigation/AppDestination.swift | enum | Presentation | The three permanent destinations of the tab bar and the routes they stand for; every other route is | Claude (mission Iris) |
| Navigation/AppRoute.swift | struct | Presentation | Every top-level screen of Iris as one explicit state | Claude (mission Iris) |
| Navigation/AppSheet.swift | enum | Presentation | Modal sheets presented above the current route | Claude (mission Iris) |
| Navigation/HomeSummary.swift | struct | Presentation | What the threshold screen proposes: begin, continue with the next level, or replay | Claude (mission Iris) |
| Navigation/RootView.swift | struct | Presentation | Renders the coordinator's route: the three destinations inside the system's tab bar, every immersive | Claude (mission Iris) |
| Tests/IrisTests/AR/AffineTransform2DTests.swift | struct | Tests | Affine calibration model: identity, offsets, scales, flips, synthetic recovery, residuals, failures | Claude (mission Iris) |
| Tests/IrisTests/AR/AxisMappingTests.swift | struct | Tests | Axis resolution from the eye line and gravity, including the "phone flipped 180 degrees" case | Claude (mission Iris) |
| Tests/IrisTests/AR/CalibrationProfileTests.swift | struct | Tests | Persistence and compatibility rules of the calibration profile | Claude (mission Iris) |
| Tests/IrisTests/AR/FixationSequenceTests.swift | struct | Tests | Time-based fixation protocol: settling, collection, blink exclusion, retry, completion and failure | Claude (mission Iris) |
| Tests/IrisTests/AR/GazeMapperTests.swift | struct | Tests | Raw sample to points pipeline, nominal geometry inverse, ray-plane intersection, blink detector | Claude (mission Iris) |
| Tests/IrisTests/AR/GazeReadinessEvaluatorTests.swift | struct | Tests | Readiness checks pass for a stable signal and flag distance, direction, stability and hardware problems | Claude (mission Iris) |
| Tests/IrisTests/AR/NormalizedCoordinatesTests.swift | struct | Tests | Points to normalized conversions on several viewports | Claude (mission Iris) |
| Tests/IrisTests/AR/RobustAggregatorTests.swift | struct | Tests | Median-based aggregation with outlier rejection | Claude (mission Iris) |
| Tests/IrisTests/Access/AccessGatingTests.swift | struct | Tests | The eight journeys of the commercial model as the coordinator plays them out: the free chapters open, a | Claude (mission Iris) |
| Tests/IrisTests/Access/AccessPolicyTests.swift | struct | Tests | The commercial model as a rule, not as an interface: three free chapters, everything else behind the full | Claude (mission Iris) |
| Tests/IrisTests/Audio/AudioCuePolicyTests.swift | struct | Tests | Sound policy: crescendo per target, chime on validation, one loss tone per cascade | Claude (mission Iris) |
| Tests/IrisTests/Audio/SineSynthTests.swift | struct | Tests | The synthesizer renders the crescendo, chime and loss tones with bounded amplitude and expected pitch | Claude (mission Iris) |
| Tests/IrisTests/Campaign/BraisesChapterTests.swift | struct | Tests | Chapter XI, braises: every braise of the campaign carries the frozen, human-validated tuning A; the chapter's | Claude (mission Iris) |
| Tests/IrisTests/Campaign/BraisesPrototypeTests.swift | struct | Tests | EXPERIMENTAL Braises A (human-validated, frozen): the braise level behaves as designed, is feasible when fed | Claude (mission Iris) |
| Tests/IrisTests/Campaign/CampaignBot.swift | struct | Tests | Simulated players used to prove each level feasible (guided) and each element necessary (limited policies); | Claude (mission Iris) |
| Tests/IrisTests/Campaign/CampaignMeasurements.swift | struct | Tests | One shared, lazily computed simulation of every level (reused by all campaign validation tests) | Claude (mission Iris) |
| Tests/IrisTests/Campaign/CampaignValidationTests.swift | struct | Tests | LEVEL_DESIGN_SYSTEM.md section 6: structure, validity, feasibility, necessity, par, difference, mastery | Claude (mission Iris) |
| Tests/IrisTests/Campaign/ConstellationTests.swift | struct | Tests | Chapter XII, constellation: the finale combines at least two expansion ideas per level, ends the campaign on | Claude (mission Iris) |
| Tests/IrisTests/Campaign/EchosTests.swift | struct | Tests | Chapter IX, échos: sleepers stay still with a closed iris, the ring of a closing iris wakes and launches them | Claude (mission Iris) |
| Tests/IrisTests/Campaign/ExpansionCampaignDump.swift | enum | Tests | Canonical text of the human-validated chapters VII to XII and of chapter I level 6 (every authored field, | Claude (mission Iris) |
| Tests/IrisTests/Campaign/ExpansionCampaignFingerprintTests.swift | struct | Tests | Protection of the human-validated chapters VII to XII and of chapter I level 6: their canonical dump must | Claude (mission Iris) |
| Tests/IrisTests/Campaign/GameContentFreezeTests.swift | struct | Tests | What the interface phases must never touch keeps its exact sources and values: the engine, game loop, | Claude (mission Iris) |
| Tests/IrisTests/Campaign/GouffresTests.swift | struct | Tests | Chapter X, gouffres: the pull, the swallow (held, then sent back to the start), the loss of a validated lueur, | Claude (mission Iris) |
| Tests/IrisTests/Campaign/HistoricalCampaignDump.swift | enum | Tests | Canonical text of the 34 historical levels: every authored field, their resolution on the reference phone, | Claude (mission Iris) |
| Tests/IrisTests/Campaign/HistoricalCampaignFingerprintTests.swift | struct | Tests | Protection of the historical campaign (chapters I to VI, 34 levels) and of the frozen engine: the canonical | Claude (mission Iris) |
| Tests/IrisTests/Campaign/JumellesTests.swift | struct | Tests | Chapter VII, jumelles: twin rules in the engine (reach hysteresis, mutual iris, poste, validation), | Claude (mission Iris) |
| Tests/IrisTests/Campaign/LevelAnalysis.swift | struct | Tests | Static metrics of a level (free area, crossings, guard pressure) and the difficulty estimate | Claude (mission Iris) |
| Tests/IrisTests/Campaign/LevelLabTests.swift | struct | Tests | Prints the measured table of every campaign level (design tool; always passes) | Claude (mission Iris) |
| Tests/IrisTests/Campaign/OculoAbsenceTests.swift | struct | Tests | Chapter IX final « l'absence »: a held presence, an answer after a gap or during an overlap; leaving for | Claude (mission Iris) |
| Tests/IrisTests/Campaign/OculoAncreTests.swift | struct | Tests | Chapter X final « l'ancre », option A: the eyes are checked before each circle and after the last one, the | Claude (mission Iris) |
| Tests/IrisTests/Campaign/OculoCoeurTests.swift | struct | Tests | Chapter II final « le cœur de verre »: the heart warms only under a gaze that stays, cools when it leaves, | Claude (mission Iris) |
| Tests/IrisTests/Campaign/OculoCourantTests.swift | struct | Tests | Chapter VIII final « la lanterne du courant »: the lantern's loop is smooth and learnable; from the second | Claude (mission Iris) |
| Tests/IrisTests/Campaign/OculoCroisementTests.swift | struct | Tests | Chapter VII final « croisement »: the breathing twin is acquired then hands over across the diagonal; legs | Claude (mission Iris) |
| Tests/IrisTests/Campaign/OculoEtoilesTests.swift | struct | Tests | Chapter V final « les étoiles absentes »: stars shown then hidden come back only where the gaze dwells at | Claude (mission Iris) |
| Tests/IrisTests/Campaign/OculoFilTests.swift | struct | Tests | Chapter III final « le fil vivant »: the spark never stops, the account grows only while the gaze accompanies | Claude (mission Iris) |
| Tests/IrisTests/Campaign/OculoJardinTests.swift | struct | Tests | Chapter VI final « le jardin caché »: breathing seeds sprout under a rest, lingering on a twinkling seed | Claude (mission Iris) |
| Tests/IrisTests/Campaign/OculoMiroirTests.swift | struct | Tests | Chapter IV final « le miroir menteur »: the door opens opposite the lure; going to the lure or letting the | Claude (mission Iris) |
| Tests/IrisTests/Campaign/OculoOrchestreTests.swift | struct | Tests | Chapter XII final « l'orchestre du regard »: seven short passages of seven different gaze ideas, each | Claude (mission Iris) |
| Tests/IrisTests/Campaign/OculoStageTestSupport.swift | enum | Tests | OCULOMOTOR EXPANSION: scripted gaze runs over a level's session (a policy chooses the gaze, and the head, | Claude (mission Iris) |
| Tests/IrisTests/Campaign/OculoTournerTests.swift | struct | Tests | Chapter XI final « d'abord les yeux »: eyes first then the head gives full warmth, the head first half, | Claude (mission Iris) |
| Tests/IrisTests/Campaign/OculomotorLevelTests.swift | struct | Tests | PROTOTYPE chapter I level 6: the thread of balises (order, dwell, brevity, hysteresis, release of the latent | Claude (mission Iris) |
| Tests/IrisTests/Campaign/SoufflesTests.swift | struct | Tests | Chapter VIII, souffles: the gust's motion and presence, carrying and lifting over veils, spilling by the | Claude (mission Iris) |
| Tests/IrisTests/Commerce/CommerceBoundaryTests.swift | struct | Tests | Commerce stays where it belongs: the gameplay, the gaze engine, the calibration, the levels and the | Claude (mission Iris) |
| Tests/IrisTests/Commerce/StoreKitEntitlementTests.swift | struct | Tests | The store layer against a real StoreKit test session: products and their price, a verified purchase, an | Claude (mission Iris) |
| Tests/IrisTests/DesignSystem/DSGlassAdoptionTests.swift | struct | Tests | The production interface really stands on Apple's glass: each migrated surface asks the design system for | Claude (mission Iris) |
| Tests/IrisTests/DesignSystem/DSGlassGallery.swift | struct | Tests | Development gallery of the Liquid Glass roles over a plain ground and a richer demonstration ground, shown | Claude (mission Iris) |
| Tests/IrisTests/DesignSystem/DSGlassGalleryCaptureTests.swift | struct | Tests | Shows the Liquid Glass gallery pages one by one in a window of the test host, so that screenshots of the | Claude (mission Iris) |
| Tests/IrisTests/DesignSystem/DSGlassSelectionGallery.swift | struct | Tests | « Sélection Iris Liquid Glass »: the validated clear control beside candidate panels, chrome and prominent | Claude (mission Iris) |
| Tests/IrisTests/DesignSystem/DSGlassTests.swift | struct | Tests | The Liquid Glass roles: native glass where the system has it, the plain fallback elsewhere, opaque under | Claude (mission Iris) |
| Tests/IrisTests/DesignSystem/GalleryDemoGround.swift | struct | Tests | Demonstration grounds behind the Liquid Glass galleries: a rich one (blue-black and indigo areas, diffuse | Claude (mission Iris) |
| Tests/IrisTests/Domain/CampaignProgressTests.swift | struct | Tests | Éclats, records and unlock rules of the campaign | Claude (mission Iris) |
| Tests/IrisTests/Domain/CascadeRuleTests.swift | struct | Tests | R-11 losing a validation invalidates every higher rank, never a lower one | Claude (mission Iris) |
| Tests/IrisTests/Domain/LinearCongruentialGeneratorTests.swift | struct | Tests | The generator reproduces the reference JavaScript sequence exactly | Claude (mission Iris) |
| Tests/IrisTests/Domain/PrototypeLevelCatalogTests.swift | struct | Tests | R-12 progression data: fourteen levels, target counts, difficulty curve and exact reference geometry | Claude (mission Iris) |
| Tests/IrisTests/Domain/SequenceOrderTests.swift | struct | Tests | R-09 targets validate only in order 1, 2, 3; physical arrival out of turn is allowed but never counts | Claude (mission Iris) |
| Tests/IrisTests/Domain/ValidationRuleTests.swift | struct | Tests | R-08 continuous 0.75 s presence and R-10 wobble tolerance, at rule and session level | Claude (mission Iris) |
| Tests/IrisTests/Fixtures/GoldenTrace.swift | struct | Tests | Decodes the golden traces produced by the reference JavaScript engine (Fixtures/golden_generator.js) | Claude (mission Iris) |
| Tests/IrisTests/Fixtures/SessionFixture.swift | enum | Tests | Helpers to stage deterministic sessions (no noise, explicit positions) | Claude (mission Iris) |
| Tests/IrisTests/GameEngine/BraiseStateTests.swift | struct | Tests | EXPERIMENTAL prototype B1: heat, hysteresis of charging and lighting, flare, behaviour scale, determinism | Claude (mission Iris) |
| Tests/IrisTests/GameEngine/GameSessionGoldenTests.swift | struct | Tests | The Swift engine reproduces the reference JavaScript engine frame by frame (golden traces) | Claude (mission Iris) |
| Tests/IrisTests/GameEngine/GameSessionTests.swift | struct | Tests | R-12 and R-14 session behaviour: completion, delta clamping, sub-stepping, gaze handling | Claude (mission Iris) |
| Tests/IrisTests/GameEngine/GazeFilterTests.swift | struct | Tests | R-13 exponential smoothing and sustained-jump gating of the reference gaze listener | Claude (mission Iris) |
| Tests/IrisTests/GameEngine/HintTrackerTests.swift | struct | Tests | Contextual instructions appear once, when the player does the thing, and fade after 4.5 s | Claude (mission Iris) |
| Tests/IrisTests/GameEngine/LevelEnvironmentTests.swift | struct | Tests | R-23 to R-28: attention on field, currents, veils, veilleuses, gliding irises, temperaments, metrics | Claude (mission Iris) |
| Tests/IrisTests/GameEngine/OculoSequenceClockTests.swift | struct | Tests | OCULOMOTOR EXPANSION: a stage placed after others starts on its own clock, after the breath, and behaves | Claude (mission Iris) |
| Tests/IrisTests/GameEngine/TargetPhysicsTests.swift | struct | Tests | R-01...R-07 and R-14: attraction, repulsion, friction, cap, bounce and frame-rate independence | Claude (mission Iris) |
| Tests/IrisTests/GameEngine/ValueNoise1DTests.swift | struct | Tests | R-03 organic noise port: table values, smoothstep interpolation, wrap-around, subtle range | Claude (mission Iris) |
| Tests/IrisTests/Haptics/HapticCuePolicyTests.swift | struct | Tests | Touch policy: one pulse per logical event, one loss per cascade, shared retrigger guard, prepare hint | Claude (mission Iris) |
| Tests/IrisTests/Mocks/MockAudioService.swift | class | Tests | Recording mock for AudioService | Claude (mission Iris) |
| Tests/IrisTests/Mocks/MockGameNavigating.swift | class | Tests | Recording mock for GameNavigating, CameraAccessNavigating and GazeSetupNavigating | Claude (mission Iris) |
| Tests/IrisTests/Mocks/MockHapticFeedbackService.swift | class | Tests | Recording mock for HapticFeedbackService | Claude (mission Iris) |
| Tests/IrisTests/Presentation/AdaptiveLevelRowMetricsTests.swift | struct | Tests | The level row geometry for 1 to 10 levels on every supported width: inside its width, full touch targets, | Claude (mission Iris) |
| Tests/IrisTests/Presentation/AncreSceneTests.swift | struct | Tests | Chapter X final « l'ancre », the scene: the silhouette traced from the reference image is framed around the | Claude (mission Iris) |
| Tests/IrisTests/Presentation/AppCoordinatorTests.swift | struct | Tests | Deterministic routes, gaze gating, progress recording and debug launch options | Claude (mission Iris) |
| Tests/IrisTests/Presentation/CameraAccessViewModelTests.swift | struct | Tests | Camera permission phases and navigation | Claude (mission Iris) |
| Tests/IrisTests/Presentation/ChapterCardLayoutTests.swift | struct | Tests | Every chapter card of the campaign, on every supported phone width and with larger text, fits the width it | Claude (mission Iris) |
| Tests/IrisTests/Presentation/ColorRoleBoundaryTests.swift | struct | Tests | The colour roles stay apart and keep their values: chapters I to XII and the game's states are unchanged, | Claude (mission Iris) |
| Tests/IrisTests/Presentation/GameSettingsStoreTests.swift | struct | Tests | Preferences defaults, persistence, and the migration of the single "Son" switch into effects and ambience | Claude (mission Iris) |
| Tests/IrisTests/Presentation/GameViewModelTests.swift | struct | Tests | Campaign game screen: intro, play, hints, result and éclats, next level, help, lifecycle, gaze, audio and haptics | Claude (mission Iris) |
| Tests/IrisTests/Presentation/GazeSetupViewModelTests.swift | struct | Tests | The setup state machine: readiness, calibration, validation, verdicts, persistence, failures | Claude (mission Iris) |
| Tests/IrisTests/Presentation/LaunchOptionsTests.swift | struct | Tests | Debug launch argument parsing and seeded progress | Claude (mission Iris) |
| Tests/IrisTests/Presentation/OculomotorTraceTests.swift | struct | Tests | PROTOTYPE instrumentation: gaze states as the mapper really provides them, viewport exits without any | Claude (mission Iris) |
| Tests/IrisTests/Presentation/OnboardingTests.swift | struct | Tests | The four explanation screens: what they say, that they say it about a game and nothing else, that they | Claude (mission Iris) |
| Tests/IrisTests/Presentation/VisualCaptureTests.swift | struct | Tests | Deterministic images of representative screens (off screen and hosted in a window) and of every level, to | Claude (mission Iris) |
