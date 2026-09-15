# Design System

Reference: Design/ART_DIRECTION.md (chambre noire) and Design/UX_VISION.md. This file lists what is implemented.

## Direction
Dark only, front view, no perspective. Ink grounds, pearl lueurs, amber for attention, mint for success, coral for trouble, marée blue for currents. New York serif titles in lowercase, SF for reading, tracked uppercase eyebrows.

## Tokens (asset catalogue)
Four colour families in `DSColor`, each token backed by its own colour set, never shared (ADR-22). The interface reads `Identity`, `Navigation` and `State`; the game world (renderer, chapter palettes and wash, `GameFieldBackground`) reads only `Chapter`. Equal values across families are deliberate copies. `AccentColor` (system tint) and `LaunchBackground` (launch screen) are separate system assets.
```
Identity    ds.identity.ground #07080B (encre)   ds.identity.ground.abyss #121620   ds.identity.surface #0D0F14 (abysse)   ds.identity.surface.elevated #161922 (ardoise)
            ds.identity.line #262A35   ds.identity.text.primary #ECE7DC (nacre)   ds.identity.text.secondary #A7A399 (brume)
            ds.identity.text.tertiary #85817A (cendre, ≥ 4.5:1 on encre)   ds.identity.text.warm #D9D2C3
            ds.identity.accent #F2B35A (ambre)   ds.identity.emblem.core #F4EFE4   ds.identity.emblem.glow #F7E6C4
Navigation  ds.navigation.primary #F2B35A   ds.navigation.onPrimary #1A1206   ds.navigation.secondary #161922
            ds.navigation.control #F2B35A (switches, text actions, progress)   ds.navigation.selection #F2B35A   ds.navigation.veil #07080B
State       ds.state.success #7FE0C0 (menthe)   ds.state.danger #FF7A5C (corail)   ds.state.warning #F2B35A   ds.state.info #9CC3E6
Chapter     ds.chapter.ink #07080B   ds.chapter.abyss #121620   ds.chapter.attention #F2B35A (ambre)   ds.chapter.attention.deep #C9812F (braise)
            ds.chapter.lueur.core #F4EFE4   ds.chapter.lueur.glow #F7E6C4   ds.chapter.maree #5E93BF   ds.chapter.veil #ECE7DC
            ds.chapter.nacre #ECE7DC   ds.chapter.cendre #85817A   ds.chapter.line #262A35   ds.chapter.success #7FE0C0   ds.chapter.trouble #FF7A5C
            ds.chapter.rank.1 #E9C98A (sable)   ds.chapter.rank.2 #9CC3E6 (givre)   ds.chapter.rank.3 #DBA3CF (orchidée), always doubled by pips
            ds.chapter.theme.<jumelles|brume|echo|gouffres|braises|constellation>.<accent|glow|wash> (chapters VII to XII)
Typography: display largeTitle serif · title / title2 / title3 serif · numeral title3 serif · body, callout, footnote, caption · eyebrow caption semibold tracked 2 · digits monospaced
Spacing 2 · 4 · 8 · 16 · 24 · 32 · 48 · 72, gutter 24 · Radius 8 · 14 · 22 · pill · Motion 0.15 / 0.28 / 0.45 s, Reduce Motion: cross-fades only
```

## Components
| Component | Purpose | Used by |
|---|---|---|
| DSBackground (+ DSIrisFibers) | Chambre noire ground, fibres, slow breathing, identity tokens | every interface screen (the game draws GameFieldBackground) |
| DSScreen | Scrolling page container with gutters | chapters, carnet, journey end, camera, unavailable |
| DSButton, DSPressableButtonStyle | Primary, secondary, ghost actions, 52 pt; the system's glass button styles on iOS 26, the painted capsule before | everywhere |
| DSCard | flat and elevated content surfaces; it never imitates a material | chapters, carnet, settings, result, unavailability |
| DSGlassPanel | panel of text and controls on the glass of `regularPanel` | pause readout, gaze readiness, gaze verdict |
| DSBadge | status pill (nouveau, diagnostics) | intro, result, HUD diagnostics |
| DSStatusRow | capability row | camera, gaze readiness, unavailable |
| DSIrisMark, DSApertureBlades | six-blade diaphragm emblem and iris shape | home, initialising, journey end, game irises, éclats |
| DSEclats | three mastery arcs | level nodes, journey end |
| DSGlyph | hand-drawn element glyphs (no SF Symbols in the game vocabulary) | intro card, carnet |
| DSOverlayPanel | veil with eyebrow, serif title, subtitle, actions (scrolls) | game overlays |
| DSProgressRing | circular progress | gaze setup |
| dsEyebrowStyle, dsGlow | label style, soft glow | everywhere |

Feature components: LevelIntroCard, LevelResultView (EclatBadge), GameHUDView, ChapterCard, LevelNode, FixationMark (gaze setup), GameSceneRenderer and GameFieldBackground (world, chapter tokens only).

## Liquid Glass (ADR-23, ADR-24)
Apple provides the material, Iris provides identity and content. The production interface uses the system's own components; the roles below dress Iris's own surfaces, and nothing imitates a material anywhere.

| Role | iOS 26, native | iOS 17–25, translucent | Reduce Transparency, opaque | Shape | Used by |
|---|---|---|---|---|---|
| clearControl | `Glass.clear`, interactive | Identity.surface 60 % | Identity.surfaceElevated | circle | pause control, calibration close |
| regularPanel | `Glass.regular` | Identity.surface 88 % | Identity.surface | rounded, DSRadius.l | level intro card, DSGlassPanel |
| chrome | `Glass.regular` | Identity.surfaceElevated 92 % | Identity.surfaceElevated | capsule | the hint above the running level |
| prominentAction | `Glass.regular`, interactive | Navigation.primary | Navigation.primary | capsule | the capsule painted where the system draws no glass button |

System surfaces, never a role: the tab bar (`TabView`, `dsTabBarMinimizesOnScroll()`), navigation toolbars, sheets, `ProgressView`, `Toggle`, `confirmationDialog`. Actions: `DSButton` maps primary to `.glassProminent` tinted with `Navigation.primary`, secondary to `.glass`, ghost to plain text; before iOS 26 and under Reduce Transparency it paints the capsule of `prominentAction` and its own secondary surface. Scroll views soften their edges under the system bars with `dsSoftScrollEdges()`.

API: `.dsGlass(role)` or `.dsGlass(role, in: .capsule)`; `DSGlassPanel { }` for a panel; `.dsGlassButton(role, rendering:)` behind `DSButton`; `DSGlassGroup(spacing:)` around neighbouring glass (`GlassEffectContainer`); `.dsGlassID(_:in:)` to morph, a fade under Reduce Motion. Only `DSGlassRendering`, `DSGlassModifier`, `DSGlassButtonStyle` and `DSGlassBarBehaviour` know the system version; no screen writes `#available`.

Phase 2B history: each role still owns a `DSGlassRecipe` (variant, optional tint, content colour, edge, touch response) so the development gallery (`Tests/IrisTests/DesignSystem/`) can compare candidates through the same fallback. Those candidates — panel airy/balanced, chrome clear/balanced, prominent neutral/spectral — were experiments; production keeps Apple's untinted materials.

## Accessibility
Dynamic Type on every interface text; 44 pt minimum targets; VoiceOver labels on chapters, nodes, éclats and HUD; hints are posted as accessibility announcements; the game canvas is hidden from VoiceOver; rank never relies on colour alone; Reduce Motion removes breathing, filaments motion, shimmer and ripples.
