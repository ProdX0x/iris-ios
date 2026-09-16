# 08 — Release Gate 2 : rapport

Base : `565d2ca` → branche `audit/iris-release-gate-2-stability`. Mesures du 16 septembre 2026, 20:13 à 21:22 CEST.
Xcode 26.3 (17C529). Appareil mesuré : iPhone 14 Pro (`iPhone15,2`, iOS 26.5.2 / 23F84).

Étiquettes : **PROVEN** · **MEASURED** · **INFERRED** · **NOT DETERMINED** · **NOT REPRODUCED**.

---

## Validation humaine

| | 14 Pro | 15 Pro |
|---|---|---|
| Gameplay | **PASS** | **PASS** |
| Latence ressentie | **non** | **non** |

## Flash

| | |
|---|---|
| Flash A | ~10:30 heure française, 16 septembre |
| Flash B | heure **inconnue** |
| Reproduit pendant les tests contrôlés | **NON** → NOT REPRODUCED |
| Crash associé | **NON** (MEASURED) |
| Nouveau Jetsam associé | **NON** (MEASURED) |
| Redémarrage système associé | **NOT DETERMINED** |
| Impact fonctionnel | **AUCUN** (FACT) |
| Cause | **NOT DETERMINED** |
| Blocker de publication | **NON** |

Aucun diagnostic n'existe sur l'appareil autour de 10:30 : le magasin complet (151 fichiers) ne contient que deux
rapports datés du 16 septembre, à 04:54:47 et 16:35:02. **Un `.ips` n'existe que si le système tue un processus :
cette absence n'est pas une preuve que rien n'a eu lieu.**

## Performance — iPhone 14 Pro

| | |
|---|---|
| Durée de session | **661 s** (11 min 1 s), 644 échantillons, fin par expiration du délai |
| Empreinte initiale | 36,3 Mo |
| Empreinte finale | 93,8 Mo |
| Empreinte maximale | 190,7 Mo (transitoire) |
| **Mémoire résidente** | 84,9 → **119,2 Mo**, **plate à 0,1 Mo près de t=90 s à la fin** |
| **Croissance monotone** | **NON** |
| CPU | 47,4 % moyen, 59,7 % max |
| Frame pacing | **NOT MEASURED** |
| Thermique | `Fair` 125 s puis `Serious` 536 s — **non attribué à Iris** |
| Hitches | **NOT MEASURED** |

Deux enregistrements antérieurs ont été **écartés** : le premier ne contenait aucun jeu (empreinte constante à
24,6 Mo, 6 threads), le second seulement 64 s. Le critère de rejet est mesuré, pas supposé : un run de contrôle
avec ARKit actif donne ≥ 10 threads et une empreinte > 36 Mo.

## Performance — iPhone 15 Pro

**NOT MEASURED** — appareil déconnecté pendant toute la fenêtre de mesure. Protocole et commandes prêts (document 04).

## backboardd

| | 14 Pro |
|---|---|
| Échantillonnage direct | **impossible** : `xctrace` refuse `--all-processes` et l'attache à `backboardd` |
| Mémoire système pendant le jeu | libre 409 → 76 Mo, filaire 1150 → 1808 Mo, **oscillantes, non monotones** |
| Croissance monotone | **NON** (MEASURED, au niveau système) |
| Tué pendant une session de Gate 2 | **NON** |
| Croissance attribuable à Iris | **NOT PROVEN** |

Pic de `backboardd` relevé dans les 16 Jetsam : 474 à 1563 Mo **sans Iris**, dont **1342 Mo aujourd'hui à 16:35**
alors qu'Iris ne tournait pas. Le 3072 Mo du 04:54 est le seul point aberrant.

## Jetsam historique

| | |
|---|---|
| Incident | `JetsamEvent-2026-09-16-045447.ips` |
| **Iris tuée** | **NON** |
| **backboardd tué** | **OUI** (`highwater`, 3072 Mo) |
| Cause attribuable à Iris | **NOT PROVEN** |
| Reproduit en conditions contrôlées | **NON** → NOT REPRODUCED |

Iris apparaît dans **1 des 16** Jetsam de l'appareil. `backboardd` est le processus dominant dans **6 des 16**,
tous sans Iris. Le facteur de confusion reste celui du Gate 1 : deux instances d'Iris coexistaient, après
l'installation de trois variantes dans l'heure.

## Rendu

| | |
|---|---|
| Animation lourde continue | **NON** — 3 `repeatForever`, lentes, désactivées sous Reduce Motion |
| Création de surfaces non bornée | **NON** — 0 `TimelineView`, 0 `drawingGroup`, 0 `blur`, 0 shader, 0 Metal |
| Écouteur de rendu dupliqué | **NON** — un seul `CADisplayLink` |
| Déclencheur global de flash prouvé | **NON** |

`GlassEffectContainer` n'existe que dans une prévisualisation : hors du chemin de rendu. Pendant le jeu : **1 à 2
surfaces de verre** (4 si les diagnostics de regard sont activés, éteints par défaut). `colorScheme` ne peut pas
basculer : `UIUserInterfaceStyle = Dark` dans l'Info.plist **et** `.preferredColorScheme(.dark)` au niveau racine.

Le seul mécanisme capable de repeindre tout l'écran d'un coup est la bascule de `DSGlassRendering` sur changement de
Reduce Transparency ; rien n'indique que ce réglage ait changé. À l'inverse, un mécanisme **extérieur** à Iris a été
mesuré le jour même : `SBRendererService` tué en `fc-thrashing` à 16:35, Iris absente.

## Décision sur les blockers

```
KNOWN UNRESOLVED PERFORMANCE REGRESSION:            NON   → RESOLVED
KNOWN UNRESOLVED JETSAM INCIDENT AS RELEASE BLOCKER: NON  → RESOLVED FOR RELEASE
FLASH AS RELEASE BLOCKER:                           NON   → NON-BLOCKING
```

« Resolved for release » ne signifie pas « impossible ». Cela signifie : aucune défaillance attribuable à Iris,
dans des tests représentatifs, ne justifie de bloquer la publication. Les conditions de réouverture sont listées au
document 07 §4.

## Systèmes gelés

`git diff` contre `565d2ca` est **vide** pour `GameEngine`, `AR`, `Audio`, `Haptics`, `Domain`, `Features/Game`,
`Features/GazeSetup`, `DesignSystem`, `Navigation`, `Resources`, `Commerce`. Chapitres I-1 à I-3 et III-7 non
ouverts. Aucun mode d'aide, viseur, halo ni refonte Liquid Glass.

Seuls ajouts : `App/Diagnostics/LifecycleTrace.swift` (fichier entier sous `#if DEBUG`), une ligne d'appel dans le
bloc `#if DEBUG` de `AppContainer.live()`, et une assertion de test resserrée.

## Tests et builds

| | |
|---|---|
| Suite historique complète | **505 tests, 74 suites, 0 échec**, 17 *known issues* (runtime iOS 26.3 refusant les sessions StoreKit), 5 ignorés (captures) |
| Build Debug | **OK** |
| Build Release | **OK**, aucun avertissement Iris |
| Build appareil signé | **OK**, installée |
| Fuite DEBUG en Release | **aucune** : 0 symbole pour `LifecycleTrace`, `StoreDiagnostics`, `BraisesPrototype`, `AncreCapture`, `oculoStatus`, `playPrototype` |
