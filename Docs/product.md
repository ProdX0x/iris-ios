# Product

## Personas
- Primary. Léa, 34, designer, iPhone 15 Pro. Likes short, calm games with a twist. Frustration: gaze-based experiences she tried needed a webcam, a browser and a long calibration. Success moment: the first time she realises she must look away from the sphere for it to arrive.
- Secondary. Marc, 52, curious about accessibility and perception. Frustration: games that punish with timers and lives. Success moment: finishing the fourteen levels at his own pace.

## Jobs to be done
- When I have five minutes, I want to play something that trains my attention rather than my reflexes, so I can relax while being challenged.
- When I open the app, I want to start playing in seconds, so I can avoid setup and calibration.
- When I lose a validation, I want to understand immediately what happened (sound and colour), so I can adapt without reading anything.

## Feature list
| Name | Job served | Priority | Screens | Data touched | Depends on |
|---|---|---|---|---|---|
| Game | attention training | P0 | GameView (ready, playing, paused, level end, interrupted, resuming, suspended, failed) | Level, Target, GameSession, GameProgression | Gaze, Audio |
| Gaze | start in seconds | P0 | CameraAccessView, UnavailableView | GazeSample, GazeTrackingState | none |
| Audio | understand without reading | P1 | none (feedback inside GameView) | AudioCue | Game |
| Onboarding | start in seconds | P0 | HomeView, TutorialView | none | none |
| JourneyEnd | finish at own pace | P1 | JourneyCompleteView | JourneySummary | Game |

## User flows
Game (P0):
1. Home, tap Commencer.
2. Device check: no face tracking, Unavailable screen. Camera not yet authorised, CameraAccess screen, iOS prompt.
3. Gaze setup: diagnostic checklist, nine-point calibration, five-point verification, Regard prêt (later launches: diagnostic and verification only).
4. Tutorial (first time), tap Jouer.
5. Game initialising, first tracked frame, ready overlay, tap.
6. Playing: spheres drift, repulsion under the gaze, crescendo while validating, chime on validation, loss tone on loss.
7. Level end overlay, tap Continuer, next level (14 in total).
8. Level 14 done, journey end screen, Recommencer or Accueil.
Pause menu: Recalibrer le regard runs the gaze setup again and returns to the same level.

## Out of scope for v1
- Manual gaze calibration.
- Landscape orientation.
- Any persistence of progress across launches.
- Leaderboards, sharing, analytics.

## Open questions
- Exact TrueDepth camera offset per device model (approximated per idiom, see README).
