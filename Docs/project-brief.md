# Project Brief

## App
Iris. A native iOS game where the player guides spheres to their arrival points by not looking at them: a direct gaze repels a sphere, indirect attention lets it drift home. Category: utility-style single-purpose game (perception, attention).

## Bundle
Bundle identifier `com.prodx0x.iris`. Minimum iOS 17.0. Swift 6 language mode, strict concurrency complete. Xcode 26.3 (build 17C529), iOS SDK 26.2.

## User
A curious iPhone owner with a Face ID device who wants a short, calm, unusual game session. The frustration removed: every gaze-driven experience they tried needed a clunky calibration or a browser and a webcam. Iris starts in seconds, needs no calibration and runs fully on device.

## Core promise
The only skill is distributing attention without fixing it. Looking at a sphere pushes it away; leaving it alone lets it arrive. Fourteen levels, no timer, no lives, no score.

## Data
No persistence beyond the running session. No account, no server, no analytics. Gaze data is consumed in real time and never stored. No video, no face representation is written anywhere.

## Business model
Free. No StoreKit, no entitlements, no feature gating.

## Dependency policy
Zero third-party. Apple frameworks only: SwiftUI, ARKit, AVFoundation, AVAudioEngine, Observation.

## Reference engine
`attention-indirecte.html` at the project root is the functional source of truth (constants, physics, validation, cascade, audio, rendering intent). It is never modified, moved or replaced. The Swift engine is a native re-implementation, not a WebView.

## Non-goals
- No manual gaze calibration flow.
- No multiplayer, leaderboard or cloud sync.
- No landscape orientation in v1 (portrait only keeps gaze projection deterministic).
