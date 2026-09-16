# 06 — Audit du chemin de rendu

Audit **statique**, sans aucune modification du rendu.

## 1. Primitives graphiques réellement présentes

**MEASUREMENT** — comptage sur les dix répertoires de production :

| Élément | Occurrences |
|---|---|
| `TimelineView` | **0** |
| `drawingGroup` | **0** |
| `compositingGroup` | **0** |
| `.blur(` | **0** |
| `import Metal` / `MTKView` | **0** |
| `import CoreImage` | **0** |
| `.colorEffect(` / `.layerEffect(` / `.distortionEffect(` / `ShaderLibrary` | **0** |
| `Canvas` | 3 sites |
| `.shadow(` | 2, tous deux dans `DSGlow` |
| `glassEffect(` | **1 seul site** : `DSGlassModifier` |
| `GlassEffectContainer` | **1 site, dans un `#Preview` uniquement** |

Les trois `Canvas` : `GameCanvasView` (le champ de jeu, `rendersAsynchronously: false`), `DSIrisFibers` dans
`DSBackground` (80 rayons, entrées statiques), `DSGlyph`.

**FACT.** `GlassEffectContainer` n'est employé que dans une prévisualisation Xcode : **il n'est pas dans le chemin
de rendu de l'application**. Cela confirme l'audit de la mission 8.

## 2. Surfaces Liquid Glass simultanées

**MEASUREMENT** — sites `.dsGlass(` / `DSGlassPanel` par écran :

| Écran | Surfaces |
|---|---|
| **Jeu en cours** (`.playing`) | **2** : le bouton pause (`clearControl`) et la capsule d'indice (`chrome`, seulement quand un indice s'affiche) |
| Jeu, superpositions (pause / résultat / intro) | +1 chacune, et elles remplacent le jeu |
| Réglages | 6 |
| Accès complet, Comment jouer | 2 chacun |
| Chapitres | 1 par carte |

**Avec l'interrupteur « Points de regard (diagnostic) » activé**, les deux badges d'état ajoutent 2 surfaces de
verre (`DSBadge` → `.dsGlass(.chrome, in: .capsule)`) pendant le jeu. Il est **éteint par défaut**.

Ordre de grandeur pendant le jeu : **1 à 2 surfaces de verre**, 4 si les diagnostics sont activés. Aucun écran
n'empile de grandes plaques de verre.

## 3. Animations continues

**MEASUREMENT** — trois `repeatForever` dans tout le projet :

| Fichier | Animation | Portée |
|---|---|---|
| `DSBackground` | `easeInOut(8 s)` sur l'opacité d'un dégradé radial (0,86 ↔ 1) | fond de l'interface |
| `GameFieldBackground` | `easeInOut(8 s)`, même principe | fond du jeu |
| `DSIrisMark` | `easeInOut(4 s)` sur l'ouverture du diaphragme | emblème du Seuil |

Toutes trois sont **désactivées sous Reduce Motion** (`guard !reduceMotion else { return }`). Aucune ne modifie une
couleur globale ; ce sont des oscillations lentes d'opacité ou de forme.

Un seul `CADisplayLink` existe (`DisplayLinkGameClock`), la boucle de jeu, épinglée à 60 Hz. Un seul `Timer`, dans
`SimulatedGazeTrackingService`, **jamais construit sur un appareil** (`environment == .live` choisit ARKit).

## 4. Candidats pouvant changer tout l'écran

| FILE | SYMBOL | TRIGGER | CAN AFFECT WHOLE SCREEN | EVIDENCE CONNECTING TO FLASH |
|---|---|---|---|---|
| `Navigation/RootView.swift` | `.animation(slowAnimation, value: coordinator.route)` + `.transition(.opacity ⊕ .scale(0.985))` | tout changement de route | **YES** | **NO** — fondu délibéré de 0,45 s, pas un éclair |
| `Navigation/RootView.swift` | `.fullScreenCover(isPresented: onboardingBinding)` | l'explication s'ouvre/se ferme quand la route passe d'une destination à une route immersive, **tant que l'onboarding n'a pas été terminé** | **YES** | **NO** — ne concerne qu'un joueur n'ayant jamais fini l'onboarding |
| `Navigation/RootView.swift` | `onChange(of: scenePhase)` | arrière-plan / premier plan | YES (suspend/réveille le jeu) | **NO** |
| `DesignSystem/Components/DSBackground.swift` | `breath` | apparition de la vue | YES (plein écran) | **NO** — 8 s, amplitude 14 % d'opacité |
| `DesignSystem/Components/DSOverlayPanel.swift` | voile `Navigation.veil` à 0,86–0,9 | pause, résultat | YES | **NO** — lié à une action du joueur |
| `Features/Game/Views/GameFieldBackground.swift` | `breath` | écran de jeu | YES | **NO** |
| `DesignSystem/Glass/DSGlassModifier.swift` | `.glassEffect` sous `#available(iOS 26)` | rendu d'une surface | NO (surfaces locales) | **NO** |
| `DesignSystem/Glass/DSGlassRendering.swift` | bascule `native`/`translucent`/`opaque` | changement de **Reduce Transparency** | **YES** — toutes les surfaces changent d'un coup | **NO** — exigerait que le réglage système change pendant la partie |

## 5. Ce que l'audit écarte

**FACT.** `colorScheme` ne peut pas basculer : `Config/Info.plist` fixe `UIUserInterfaceStyle = Dark` **et**
`RootView` applique `.preferredColorScheme(.dark)`. Un changement d'apparence système ne peut pas repeindre Iris.

**FACT.** Aucune boucle graphique non bornée, aucun `TimelineView`, aucun shader, aucun flou, aucun
`drawingGroup`. Rien qui alloue de grandes surfaces en continu.

**FACT.** Un seul écouteur de boucle de rendu (`CADisplayLink`), créé et détruit par l'écran de jeu.

```
CONTINUOUS HEAVY ANIMATION FOUND: NO
UNBOUNDED SURFACE CREATION FOUND: NO
DUPLICATED RENDER LISTENER FOUND: NO
GLOBAL FLASH TRIGGER PROVEN: NO
```

## 6. Conclusion

Aucun mécanisme du rendu d'Iris n'a été relié au flash par une preuve. Le seul mécanisme **capable** de repeindre
tout l'écran instantanément est la bascule de `DSGlassRendering` sur changement de Reduce Transparency, et rien
n'indique que ce réglage ait changé.

À l'inverse, un mécanisme **extérieur à Iris** a été mesuré le jour même : la mort de `SBRendererService`
(`fc-thrashing`) à 16:35, alors qu'Iris ne tournait pas (document 01). **Aucune modification du rendu n'est
justifiée** au vu des preuves disponibles.
