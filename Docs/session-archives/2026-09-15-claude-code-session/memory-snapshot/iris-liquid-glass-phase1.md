---
name: iris-liquid-glass-phase1
description: "Iris Liquid Glass 2026 phase 1 on feature/iris-liquid-glass-2026: DSColor split into Identity/Navigation/State/Chapter with zero visual change, plus the before/after capture harness"
metadata:
  type: project
---

Branch `feature/iris-liquid-glass-2026` starts from `fix/x7-head-only-circling` (b1805a6). Phase 1 (14 Sept 2026) separated colour roles with no visual change: `DSColor.Identity`, `.Navigation`, `.State` dress the interface; `DSColor.Chapter` is the game world only (renderer, `DSThemePalette`, `DSThemeWash`, `GameView`, new `GameFieldBackground`). Each token has its own colour set (`ds.<family>.*`); the world's sets were renamed byte for byte, the interface got identical copies. `AccentColor` and `LaunchBackground` stay system assets. ADR-22 in Docs/architecture.md. Guarded by `ColorRoleBoundaryTests` (A–F) and `GameContentFreezeTests` (G–J hashes of engine, audio, haptics, X·7, level data, mechanics). Commits c3781f7 (refactor) and a4bff43 (tests): 431 tests, 429 passed, the 2 capture-only tests skipped without IRIS_CAPTURE_DIR. Not pushed, no tag; X·7 Option A still lacks a definitive human validation.

**Why:** later phases add Liquid Glass and recolour the interface; chapters I–XII must not move. The user forbade Liquid Glass, TabView, navigation or narration work in phase 1 and asked to stop after it.

**How to apply:** interface code reads Identity/Navigation/State (a chapter's colour only through its palette); world code reads Chapter only. To prove "no visual change", run `VisualCaptureTests` with `TEST_RUNNER_IRIS_CAPTURE_DIR=<dir outside repo>` on the old commit (git worktree + harness copy) and on the new code, then `cmp` the PNGs: 22 screens off screen (ImageRenderer draws no ScrollView or switch), the same 22 hosted in a window (full fidelity), 82 levels. The noise floor between two runs was 0 bytes. Run one xcodebuild and one simulator at a time: see [[iris-project-setup]]. Related: [[iris-x7-ancre-correction]].
