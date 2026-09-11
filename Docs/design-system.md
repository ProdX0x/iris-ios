# Design System

## Direction
Custom branded, dark only. Iris speaks softly: deep warm blacks, an amber iris as the single accent, a serif voice for titles set in lowercase, mint for validation and coral for loss (both inherited from the reference engine). The game scene keeps the reference palette (sky, floor, sphere greys) so the port stays visually faithful.

## Tokens
```
Colour (single appearance, dark)
  ds.background.primary   #0F1013   ds.background.surface #16171A   ds.background.elevated #1F2126
  ds.text.primary #EEEDFE   ds.text.secondary #B4B2A9   ds.text.tertiary #7E7C74   ds.text.warm #D3D1C7   ds.text.onAccent #14110A
  ds.accent #E7A43B   ds.accent.deep #B8791C
  ds.status.success #5DCAA5 (mint)   ds.status.danger #D85A30 (coral)   ds.status.info #378ADD
  ds.line.subtle #2A2C33
  ds.scene.skyTop #1B1D22   ds.scene.skyHorizon #2A2D33   ds.scene.floorNear #232529   ds.scene.floorFar #121316
  ds.scene.sphere #B4B2A9 (light #DCDAD1, dark #96948B)   ds.scene.sphereValidated #5DCAA5 (light #85F2CD, dark #3FAC87)
  ds.scene.shadow #000000   ds.scene.ring #FFFFFF   ds.scene.label #16171A
  ds.sequence.1..5  #D85A30 #378ADD #639922 #D4537E #BA7517 (SEQ_COLORS of the reference engine)

Typography (Dynamic Type mapped)
  display  largeTitle serif medium      title  title serif      title2 title2 serif
  headline headline   body body   callout callout   footnote footnote   caption caption
  eyebrow  caption semibold, uppercase, tracking 2   mono caption monospaced

Spacing (4 pt grid)  xxs 2 · xs 4 · s 8 · m 16 · l 24 · xl 32 · xxl 48 · xxxl 72 · gutter 24
Radius  s 8 · m 14 · l 22 · pill 999
Motion  fast 0.15 s · standard 0.28 s · slow 0.45 s · breath 2.6 s; Reduce Motion: cross-fade only, no breathing, no scale
```

## Components
| Component | Purpose | Variants | States | Used by | Status |
|---|---|---|---|---|---|
| DSBackground | Iris atmosphere (ground, amber glow, horizon) | calm, vivid | none | every screen | implemented |
| DSScreen | Page container with gutters and safe areas | scrolling, fixed | none | every screen | implemented |
| DSButton | Actions | primary, secondary, ghost | enabled, disabled, pressed | every screen | implemented |
| DSCard | Grouped content | flat, elevated, glass | none | Home, Tutorial, CameraAccess, Journey, Pause | implemented |
| DSBadge | Status pill | neutral, accent, success, danger, info | none | Game HUD | implemented |
| DSStatusRow | Capability or permission row | none | pending, ok, warning, error | CameraAccess, Unavailable | implemented |
| DSIrisMark | Emblem | breathing or static | none | Home, Game initialising | implemented |
| DSProgressRing | Circular progress | tint | none | Journey end | implemented |
| DSOverlayPanel | Dimmed veil with title, subtitle, actions | tint, dim | none | Game overlays | implemented |
| dsEyebrowStyle | Uppercase tracked label | tint | none | everywhere | implemented |
| FixationMark (feature component, GazeSetup) | Calm calibration target: halo, filling ring, core | tint | settling, collecting | GazeReadinessView, FixationTargetView | implemented |
| dsGlow | Soft glow | colour, radius | none | Journey, marks | implemented |

## Wireframes
```
Home                               Game (playing)
┌───────────────────────┐          ┌───────────────────────┐
│        (iris mark)    │          │ NIVEAU 9 / 14   (II)  │  eyebrow + pause
│ ATTENTION INDIRECTE   │          │ 3 sphères             │
│ iris                  │          │        sky            │
│ Regarder une sphère…  │          │ ───── horizon ─────── │
│ ┌ facts card ───────┐ │          │  (1)  ring  ○ sphere  │  depth-scaled
│ └───────────────────┘ │          │       floor lines     │
│ [ Commencer ]         │          │ la validation ne…     │
│ privacy note          │          │ [regard] [son]        │  badges
└───────────────────────┘          └───────────────────────┘
```

```
Gaze setup (readiness)              Gaze setup (calibration 3 / 9)
┌───────────────────────┐          ┌───────────────────────┐
│ DIAGNOSTIC DU REGARD  │          │                    (◎)│  target top-right
│ regard prêt pour…     │          │                       │
│         (◎)           │          │   CALIBRATION 3 / 9   │  label between rows
│ ┌ checklist ────────┐ │          │ suivez le point…      │
│ │ ● Caméra TrueDepth│ │          │                       │
│ │ ● … 10 checks     │ │          │                       │
│ └───────────────────┘ │          │                       │
│ [ Annuler ]           │          │ (x)                   │  cancel bottom-left
└───────────────────────┘          └───────────────────────┘
```

## Interaction rules
- Haptics: none in v1 (audio is the feedback channel; gaze play must not vibrate the device held in front of the face).
- Animation: route transitions cross-fade with a slight scale; overlays fade; the canvas runs at 60 Hz through the game clock.
- Loading: the initialising overlay shows the breathing iris mark.
- Errors: every failure is a full overlay with a title, a plain-language message and at most three actions.
- Empty states: none (the game always has content).

## Accessibility
- Dynamic Type through system text styles everywhere except in-canvas numerals (game world).
- VoiceOver: every button labelled; overlays are modal; HUD readouts combined; canvas hidden (state is conveyed by HUD badges and overlays).
- Contrast: text on #0F1013 is above 4.5:1 for primary and secondary text; amber on dark for eyebrows is decorative emphasis with a text equivalent.
- Reduce Motion honoured in DSIrisMark, DSPressableButtonStyle and route transitions.
- Minimum tap target 44 pt (pause button 44 pt, DSButton 52 pt).

## HIG references
- Onboarding: single column, one primary action per screen.
- Permissions: explain before the system prompt, offer the Settings shortcut after a denial.
- Games: full screen, status bar hidden, home indicator auto-hidden during play.
