---
name: iris-liquid-glass-phase2
description: "Iris Liquid Glass phase 2: DesignSystem/Glass roles (.dsGlass), native glass on iOS 26 with one fallback, gallery in the test target with real simulator screenshots; no screen migrated"
metadata:
  type: project
---

Phase 2 (15 Sept 2026, branch `feature/iris-liquid-glass-2026`) added the Liquid Glass foundation without touching any screen. `DesignSystem/Glass`: `DSGlassRole` (clearControl → `Glass.clear` interactive, circle; regularPanel → `Glass.regular`, rounded DSRadius.l; chrome → `Glass.regular`, capsule; prominentAction → `Glass.regular` tinted Navigation.primary 40 %, capsule), `DSGlassRendering` (native on iOS 26, translucent Identity surface before, opaque under Reduce Transparency), `DSGlassSurface`, `.dsGlass(role, in:)`, `DSGlassGroup` (GlassEffectContainer), `.dsGlassID` (morph, or `.materialize` fade under Reduce Motion). ADR-23. Production screens stayed byte-identical to the phase 1 reference (126/126). Commits b740654 (feat) and 25135a3 (tests): 440 tests, 437 passed, 3 capture-only skipped. Nothing pushed, no tag.

**Why:** the user wants to judge the real glass visually before any screen, navigation, palette or narration work; they fear a UI of heavy capsules and a violet-painted glass.

**How to apply:** the gallery is `Tests/IrisTests/DesignSystem/DSGlassGallery.swift`, shown by `DSGlassGalleryCaptureTests` when `TEST_RUNNER_IRIS_GLASS_CAPTURE_DIR` (and `..._SET` normal/contraste/transparence) is set; a shell watcher takes `simctl io screenshot` when the test writes `ready-<name>`. Reduce Transparency is enabled with `simctl spawn <udid> defaults write com.apple.Accessibility EnhancedBackgroundContrastEnabled -bool true` plus a simulator reboot (no `simctl ui` option); Increase Contrast with `simctl ui <udid> increase_contrast enabled`. The test manifest records the real UIAccessibility state. No iOS 17–25 simulator exists on the Mac (iOS 18 runtimes only). See [[iris-liquid-glass-phase1]], [[iris-project-setup]].
