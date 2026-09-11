# Conventions

Single source of truth for this project. If code disagrees with this file, the code is wrong.

## Targets
- Minimum iOS: 17.0
- Swift: 6.0 language mode, strict concurrency: complete
- Xcode: 26.3
- Observation: `@Observable`

## Architecture
- Pattern: MVVM in the Presentation layer, layered domain core.
- Layers and the only allowed dependency direction:
  - Presentation (Features, Navigation, DesignSystem) depends on Domain and GameEngine, and on the AR and Audio service protocols.
  - AR and Audio implement service protocols consumed by Presentation; they depend on Domain value types only.
  - Domain and GameEngine depend on nothing but Foundation (no UIKit, no SwiftUI, no ARKit, no AVFoundation).
- Navigation: a single `AppCoordinator` owning an `AppRoute` state machine. Views never decide destinations; they call coordinator or ViewModel intents.
- Dependency injection: constructor injection through one `AppContainer` in `App/DI/`. No global singletons except `AppContainer` created once by the app entry point.
- Concurrency: async/await and `@MainActor` for all UI state. ARKit delegate callbacks are delivered on the main queue. The audio render callback touches only a lock-protected value type.

## Folder layout (this project, chosen by the mission brief)
```
App/            IrisApp.swift, DI/
Domain/         entities, value objects, physics constants, levels, validation rules
GameEngine/     noise, physics integrator, session, progression, gaze filter, events
AR/             GazeTrackingService protocol implementations, projector, device capabilities
Audio/          AudioService protocol implementations, synthesizer, cue policy
Navigation/     AppRoute, AppCoordinator, RootView
Features/<Name> Views, ViewModels, Components per screen
DesignSystem/   Tokens/, Components/, Modifiers/
Resources/      Assets.xcassets
Config/         Info.plist
Tests/IrisTests unit tests (Swift Testing), Fixtures/, Mocks/
Docs/           project-brief, conventions, file-map, product, architecture, domain-model, design-system, audits
```
Deviation from the skill default tree: `Core/` is replaced by `App/DI` and `Navigation/`, and `Data/` does not exist because the app has no persistence or network. Recorded as ADR-2 in architecture.md.

## Naming
| Thing | Rule | Example |
|---|---|---|
| Entity | Noun, no suffix | `Target` |
| Value object | Noun, no suffix | `Vector2` |
| Service protocol | `<Noun>Service` | `GazeTrackingService` |
| Service impl | `<Tech><Noun>Service` | `ARKitGazeTrackingService` |
| Rule | `<Noun>Rule` or `<Noun>Rules` | `CascadeRule` |
| ViewModel | `<Screen>ViewModel` | `GameViewModel` |
| View | `<Screen>View` | `HomeView` |
| Coordinator | `AppCoordinator` | |
| Route enum | `AppRoute` | |
| Test | `<TypeUnderTest>Tests` | `CascadeRuleTests` |
| Mock | `Mock<Protocol>` | `MockAudioService` |
| DS component | `DS<Name>` | `DSButton` |

## File rules
- One top-level type per file. File name equals type name. Small private helper types may live next to their only consumer.
- No file over 300 lines. Split by concern.
- No catch-all files.
- Every new file is registered in `Docs/file-map.md`.

## Code style
- Access control: `private` by default, widen only when needed.
- Every external capability (gaze, audio, ticking) is a protocol. Concrete types are injected.
- ViewModels expose state as `private(set)` stored properties and actions as methods. No `import SwiftUI` in ViewModels.
- Views are dumb: read state, call actions, render with tokens and DS components.
- No force unwrap, no `try!`, no `as!`.
- User-facing copy in French, hardcoded (no catalog in v1). Code identifiers and comments in English.
- No `TODO` left in code.

## Testing
- Unit tests: Swift Testing (`@Test`, `#expect`). One test file per type.
- Golden traces generated from the reference JavaScript engine live in `Tests/IrisTests/Fixtures/`.
- Mocks are hand-written in `Tests/IrisTests/Mocks/`.
- No test touches network, disk (beyond bundle fixtures), camera or audio hardware.

## Dependencies
- Policy: zero third-party. Allowed packages: none.

## Localisation
- French only for v1. Base language: fr.
