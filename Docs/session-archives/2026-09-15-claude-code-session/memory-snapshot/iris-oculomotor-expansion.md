---
name: iris-oculomotor-expansion
description: "Branch feature/iris-oculomotor-expansion (Sept 2026): one optional oculomotor final per chapter II–XII built on the gaze-stage mechanism; how it is protected; played by the user, one level still to review for gameplay"
metadata: 
  node_type: memory
  type: project
  originSessionId: f88478cc-d512-4210-bc11-758059278995
  modified: 2026-09-14T07:52:35.191Z
---

Chapter I level 6 was reported human-validated by the user and tagged `iris-ch1-oculomotor-human-validated-v1` (→ c452c01, pushed). `feature/iris-oculomotor-expansion` starts from that tag and adds eleven optional finals: 2-6 cœur de verre (fixation), 3-7 fil vivant (pursuit), 4-7 miroir menteur (anti-saccade), 5-7 étoiles absentes (memory-guided), 6-7 jardin caché (search), 7-7 danse croisée (diagonals), 8-7 lanterne du courant (predictive pursuit), 9-7 absence (gap/overlap), 10-7 ancre (gaze stabilisation, uses head yaw/pitch), 11-7 d'abord les yeux (eye-head), 12-7 orchestre du regard (7-stage synthesis with constellation). Commits: infra `77e86c2`, one per chapter, stage clock `27c2fac`, docs `93326de`. 385 tests green at the end. Report `Design/OCULOMOTOR_EXPANSION_REPORT.md`, README §21, ADR-20.

**Why:** the user wants gaze patterns hidden in real Iris gameplay, no medical claims, Gaze Engine and tracking-loss warning frozen, and will judge the eleven levels on device afterwards; Liquid Glass is a later, separate mission.

**How to apply:** validated levels are frozen by two byte-for-byte fixtures (`historical_campaign.txt` for I–VI, `expansion_campaign.txt` for VII–XII + 1-6) and source SHA-256s; `Campaign.baseChapters` is the validated campaign and `Campaign.chapters` appends at most one optional final (`gatesProgression = false`). New paradigms go in `GameEngine/Oculo/*StageState.swift` as cases of `OculoStageState` (each on its own clock, with a gaze/head oracle for `CampaignBot`), plus a scene case in `OculoSnapshot`. Head-based stages (X, XI, XII's last passage) learn axis direction from the player and degrade gracefully without head data. Status stays "TECHNIQUEMENT VALIDÉ / À JOUER HUMAINEMENT" until the user plays them. See [[iris-oculomotor-prototype]] and [[iris-full-expansion]].

**Human play (14 Sept 2026):** the user played all eleven finals and judged them « excellents ». The level to review was 10-7 « l'ancre », reworked on its own branch (see [[iris-x7-ancre-correction]]); the chapter-card layout fix was done without touching gameplay. See [[iris-chapter-card-layout]].
