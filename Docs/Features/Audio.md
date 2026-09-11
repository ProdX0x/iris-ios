# Feature: Audio

Status: implemented
Priority: P1
Depends on: Game

## Job
When I lose a validation, I want to understand immediately what happened, so I can adapt without reading anything.

## Screens
None. Feedback inside GameView.

## Acceptance criteria
- AC-1 Given a sphere accumulating presence, when progress rises, then a sine voice rises from 220 Hz to 560 Hz and from gain 0.02 to 0.045.
- AC-2 Given a validation, when it happens, then a three-note chime (660, 880, 1100 Hz, 0.12 s each) plays.
- AC-3 Given a loss, when it happens, then a 220 to 120 Hz sweep over 0.25 s plays; a cascade produces one tone only.
- AC-4 Given an audio interruption or route change, when it ends, then the engine restarts without crashing.

## Entities
AudioCue, AudioStatus.

## Test coverage
AC-1 to AC-3: SineSynthTests, AudioCuePolicyTests. AC-4: compiled, not exercised automatically.
