---
name: iris-chapter-card-layout
description: "Branch fix/chapter-card-adaptive-layout (14 Sept 2026): chapter cards clipped with 7 levels, fixed by an adaptive level row; installed on the iPhone 14 Pro, awaiting the user's visual check, not merged"
metadata:
  type: project
---

`fix/chapter-card-adaptive-layout` starts from `feature/iris-oculomotor-expansion` at 93326de with one commit "fix: make chapter cards adaptive to level count", pushed, not merged. The user saw cards clipped left and right on the iPhone 14 Pro once chapters had 7 levels: rigid 48 pt level nodes made a row wider than the 297 pt a card leaves on a 393 pt phone, and the widest card widened every card. The row is now `AdaptiveLevelRow` (a SwiftUI `Layout`): one row, then tighter spacing, then 44 pt targets, then balanced rows. On the 14 Pro chapters I–II show one row of 6, III–XII two rows 4+3; a Pro Max shows 7 in one row.

**Why:** the user's rule, verbatim: « LE CONTENU S'ADAPTE AU CONTENEUR », never the container growing for the content; no per-chapter magic widths, no horizontal scroll, touch targets stay at least 44 pt, visual identity unchanged, Liquid Glass is a later separate mission.

**How to apply:** any future row of level nodes should go through `AdaptiveLevelRow`, not fixed frames. `ChapterCardLayoutTests` renders cards at 375/393/402/440 pt with standard and large text and fails if a render is wider than the phone; it dumps PNGs when `TEST_RUNNER_IRIS_SNAPSHOT_DIR` is set. Status stays "prêt pour validation humaine" until the user confirms on device. See [[iris-oculomotor-expansion]] and [[iris-project-setup]].
