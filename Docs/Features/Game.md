# Feature: Game

Status: implemented
Priority: P0
Depends on: Gaze, Audio

## Job
When I have five minutes, I want to guide spheres home by not looking at them, so I can train my attention calmly.

## Screens
GameView. Full-screen scene (canvas), HUD (level, spheres, pause, gaze and sound badges), overlays per phase. ViewModel: done. View: done.

## Acceptance criteria
- AC-1 Given the gaze is farther than the attention zone, when frames advance, then the sphere drifts toward its arrival (R-01).
- AC-2 Given the gaze is inside the attention zone, when frames advance, then the sphere moves away from the gaze with a force proportional to the intrusion (R-02).
- AC-3 Given a sphere inside 16 pt of its arrival on its turn, when 0.75 s elapse continuously, then it is validated and the chime plays (R-08).
- AC-4 Given a validated sphere, when it drifts beyond 36 pt, then it loses its validation, higher ranks cascade, and one loss tone plays (R-10, R-11, R-15).
- AC-5 Given several spheres, when a higher-ranked sphere reaches its arrival first, then it never validates before the lower ranks (R-09).
- AC-6 Given all spheres validated, when the tick ends, then the level end overlay appears and the next level loads on tap; after level 14 the journey screen appears (R-12).
- AC-7 Given an AR interruption, background trip or failure, when it happens, then the loop stops and a dedicated overlay explains the state; no crash, no blank screen.

## Entities
Target, Level, GameSession, GameProgression, GazeSample, AudioCue.

## Notes
Portrait only. The reference engine's cursor starts at the screen centre; Iris seeds it on the latest gaze sample at the first tap.

## Test coverage
R-01 to R-15, AC-1 to AC-7: TargetPhysicsTests, ValidationRuleTests, SequenceOrderTests, CascadeRuleTests, GameSessionTests, GameSessionGoldenTests, GameProgressionTests, AudioCuePolicyTests, GameViewModelTests.
