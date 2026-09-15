---
name: iris-liquid-glass-phase2b
description: "Iris Liquid Glass phase 2B: human review of the phase 2 gallery, DSGlassRecipe, « Sélection Iris Liquid Glass » gallery comparing panel/chrome/prominent candidates; roles unchanged, awaiting the user's visual choice"
metadata:
  type: project
---

Human review of the phase 2 captures (15 Sept 2026): clearControl (`Glass.clear`, circle) VALIDATED and must not be redesigned; regularPanel too opaque (a blue-black card); chrome too opaque and massive; prominentAction (bronze tinted regular capsule) REJECTED; large Dynamic Type validated; opaque looks under Increase Contrast / Reduce Transparency are expected and are not the aesthetic reference.

Phase 2B (commits 65bae13 feat, 4e8283d test, branch `feature/iris-liquid-glass-2026`, not pushed, no tag): each role owns a `DSGlassRecipe` (variant, tint, foreground, edge, interactive); `DSGlassModifier(role:shape:recipe:)` renders candidates with the role's own fallback/accessibility surfaces. Production recipes are still the phase 2 ones (proved: phase 2 pages redrawn byte-identical 5/5, production screens 126/126). Candidates live only in `Tests/IrisTests/DesignSystem/DSGlassSelectionGallery.swift`: panels current / airy (`.clear` + Identity.ground tint 12 %) / balanced (`.clear` + ground 32 %); chrome current / clear / balanced (`.clear` + ground 20 %); prominent current / neutral (`.clear`, amber text and 50 % amber edge) / spectral (`.clear` + exploratory violet 20 %, gallery only) / system `glassProminent`; radii 22 vs 16 pt. Captures in `.iris-derived-data/phase2b/galerie/` (selection-iris-rich-normal, -calm-normal, -rich-large-text, -rich-high-contrast, -rich-reduce-transparency, panels-, chrome-, prominent-comparison).

**Why:** the user wants to pick the definitive Iris glass language from normal-mode captures before any screen migration, palette or navigation.

**How to apply:** do not change a role's recipe until the user chooses; the chosen candidate then replaces `DSGlassRole.recipe` and test I. Capture set "phase2" redraws the phase 2 pages under their original names for byte comparison. `DSGlassTests` K freezes Navigation/*.swift hashes until the navigation phase. See [[iris-liquid-glass-phase2]].
