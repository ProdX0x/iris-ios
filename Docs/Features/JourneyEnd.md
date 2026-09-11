# Feature: JourneyEnd

Status: implemented
Priority: P1
Depends on: Game

## Job
When I finish the fourteen levels, I want a quiet closing screen, so I can replay or leave.

## Screens
JourneyCompleteView. Ring 14/14, play time, Recommencer, Accueil. View: done.

## Acceptance criteria
- AC-1 Given level 14 completed, when I tap Voir le parcours, then the journey screen shows 14 levels and the play time.
- AC-2 Given the journey screen, when I tap Recommencer, then a new game starts at level 1.

## Entities
JourneySummary.

## Test coverage
AC-1, AC-2: GameViewModelTests (journeyEnd), AppCoordinatorTests (gameLifecycle).
