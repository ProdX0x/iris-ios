# Feature: Onboarding

Status: implemented
Priority: P0
Depends on: none

## Job
When I open the app, I want to understand the twist in one screen, so I can start playing immediately.

## Screens
HomeView. Emblem, promise, facts, Commencer, privacy note. View: done.
TutorialView. Five rules, Jouer, Accueil. View: done.

## Acceptance criteria
- AC-1 Given the home screen, when I tap Commencer, then the device and camera checks run before the tutorial.
- AC-2 Given the tutorial, when I tap Jouer, then the game starts at level 1.
- AC-3 Given any onboarding screen, when Dynamic Type is at accessibility sizes, then the content scrolls and stays readable.

## Entities
None.

## Test coverage
AC-1, AC-2: AppCoordinatorTests. AC-3: visual check on simulator (screenshots), not automated.
