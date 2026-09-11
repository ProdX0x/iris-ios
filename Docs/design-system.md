# Design System

Reference: Design/ART_DIRECTION.md (chambre noire) and Design/UX_VISION.md. This file lists what is implemented.

## Direction
Dark only, front view, no perspective. Ink grounds, pearl lueurs, amber for attention, mint for success, coral for trouble, marée blue for currents. New York serif titles in lowercase, SF for reading, tracked uppercase eyebrows.

## Tokens (asset catalogue)
```
ds.background.primary #07080B (encre)   ds.background.surface #0D0F14 (abysse)   ds.background.elevated #161922 (ardoise)
ds.line.subtle #262A35
ds.text.primary #ECE7DC (nacre)   ds.text.secondary #A7A399 (brume)   ds.text.tertiary #85817A (cendre, ≥ 4.5:1 on encre)
ds.text.warm #D9D2C3   ds.text.onAccent #1A1206
ds.accent #F2B35A (ambre)   ds.accent.deep #C9812F (braise)
ds.status.success #7FE0C0 (menthe)   ds.status.danger #FF7A5C (corail)   ds.status.info #9CC3E6
ds.field.ink #07080B   ds.field.abyss #121620   ds.lueur.core #F4EFE4   ds.lueur.glow #F7E6C4   ds.maree #5E93BF   ds.veil #ECE7DC
ds.rank.1 #E9C98A (sable)   ds.rank.2 #9CC3E6 (givre)   ds.rank.3 #DBA3CF (orchidée), always doubled by pips
Typography: display largeTitle serif · title / title2 / title3 serif · numeral title3 serif · body, callout, footnote, caption · eyebrow caption semibold tracked 2 · digits monospaced
Spacing 2 · 4 · 8 · 16 · 24 · 32 · 48 · 72, gutter 24 · Radius 8 · 14 · 22 · pill · Motion 0.15 / 0.28 / 0.45 s, Reduce Motion: cross-fades only
```

## Components
| Component | Purpose | Used by |
|---|---|---|
| DSBackground (+ DSIrisFibers) | Chambre noire ground, fibres, slow breathing | every screen |
| DSScreen | Scrolling page container with gutters | chapters, carnet, journey end, camera, unavailable |
| DSButton, DSPressableButtonStyle | Primary, secondary, ghost actions, 52 pt | everywhere |
| DSCard | flat, elevated, glass surfaces | chapters, carnet, settings, result, pause |
| DSBadge | status pill (nouveau, diagnostics) | intro, result, HUD diagnostics |
| DSStatusRow | capability row | camera, gaze readiness, unavailable |
| DSIrisMark, DSApertureBlades | six-blade diaphragm emblem and iris shape | home, initialising, journey end, game irises, éclats |
| DSEclats | three mastery arcs | level nodes, journey end |
| DSGlyph | hand-drawn element glyphs (no SF Symbols in the game vocabulary) | intro card, carnet |
| DSOverlayPanel | veil with eyebrow, serif title, subtitle, actions (scrolls) | game overlays |
| DSProgressRing | circular progress | gaze setup |
| dsEyebrowStyle, dsGlow | label style, soft glow | everywhere |

Feature components: LevelIntroCard, LevelResultView (EclatBadge), GameHUDView, ChapterCard, LevelNode, FixationMark (gaze setup), GameSceneRenderer (world).

## Accessibility
Dynamic Type on every interface text; 44 pt minimum targets; VoiceOver labels on chapters, nodes, éclats and HUD; hints are posted as accessibility announcements; the game canvas is hidden from VoiceOver; rank never relies on colour alone; Reduce Motion removes breathing, filaments motion, shimmer and ripples.
