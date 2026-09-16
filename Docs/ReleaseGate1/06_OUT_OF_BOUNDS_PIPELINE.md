# 06 — Le regard hors écran : où le pipeline le traite

Question : Iris dispose-t-il d'une information **directionnelle** quand le point de regard sort de la zone utile ?

Ce document est un audit de lecture. **Aucune ligne de code n'a été modifiée.**

---

## 1. Le pipeline, dans l'ordre

| Étape | Fichier | Ce qui s'y passe | Borne ? |
|---|---|---|---|
| 1. ARKit | `AR/Services/ARKitGazeTrackingService.swift` | `ARFaceAnchor` → `RawGazeSample` (`planeHit`, `observation`, `timestamp`) | non |
| 2. Axes | `AR/Calibration/AxisMapping.swift` | `screenCoordinates(of:)` : échange/inverse les deux axes du plan | non |
| 3. Normalisation nominale | `AR/Calibration/GazeMapper.nominalNormalized` + `NominalDisplayGeometry.normalized` | offsets métriques → coordonnées 0…1 ; rejette le non-fini | **non** (seul un filtre `isFinite`) |
| 4. Calibration | `GazeMapper.calibratedNormalized` → `AffineTransform2D.apply` | transformation affine 2D ; rejette le non-fini | **non** |
| 5. Conversion en points | `NormalizedCoordinates.points(_:in:)` | multiplication par la largeur et la hauteur | **non** |
| 6. **Écrêtage** | **`GazeMapper.screenPoint(normalized:)`** | **borne au viewport élargi de 50 % de chaque côté** | **OUI — le seul du pipeline** |
| 7. Lissage | `GameEngine/Gaze/GazeFilter.ingest` | lissage exponentiel α = 0,1, porte anti-saut (300 pt, 3 sauts consécutifs) | **non** |
| 8. Jeu | `GameSession.ingestGaze` → `TargetPhysics` | la position sert de centre à la zone d'attention | **non** |

**FACT — vérifié par recherche :** hors de l'étape 6, aucune borne n'est appliquée à la position du regard.
`grep -rn "min(max"` sur `GameEngine`, `Domain`, `AR`, `Features/Game/ViewModels`, `Features/Game/Rendering` ne
renvoie que des écrêtages sans rapport (pas de temps, charges de veilleuses, fractions de trajectoire, paramètres
de définition de niveau).

## 2. L'écrêtage, exactement

**Fichier :** `AR/Calibration/GazeMapper.swift`
**Fonction :** `screenPoint(normalized:)`
**Lignes :** 47 à 53 — marges calculées lignes 49–50, borne lignes 51–52
**Paramètre :** `overshoot`, ligne 14, valeur par défaut **0,5**, documenté : « Points farther than this fraction of
the viewport outside its edges are clamped. »

```swift
func screenPoint(normalized: SIMD2<Double>) -> Vector2 {
    let point = NormalizedCoordinates.points(normalized, in: viewport)
    let marginX = viewport.width * overshoot
    let marginY = viewport.height * overshoot
    return Vector2(x: min(max(point.x, -marginX), viewport.width + marginX),
                   y: min(max(point.y, -marginY), viewport.height + marginY))
}
```

**Conséquence, et c'est le point central :** la borne **n'est pas le viewport**. Le point rendu vit dans

```
x ∈ [ −0,5·largeur , 1,5·largeur ]        y ∈ [ −0,5·hauteur , 1,5·hauteur ]
```

Donc `x < 0`, `x > largeur`, `y < 0`, `y > hauteur` **existent réellement** et traversent tout l'aval sans être
retouchés.

## 3. Deux sorties différentes, à ne pas confondre

| Cas | Ce qu'Iris possède |
|---|---|
| **Le regard sort du viewport mais le plan est encore touché** (`VALID_OUTSIDE`) | un point réel, hors bornes : **direction complète** (quel axe, quel signe) et **amplitude**, jusqu'à saturation à 0,5 × la dimension |
| **Aucune projection** (`INVALID` — plus de `planeHit`, ou résultat non fini) | `screenPoint` rend `nil` ; `GameViewModel.handleGazeSample` n'appelle alors pas `session.ingestGaze`. **Seule la dernière position valide subsiste** |

**FACT.** Cette distinction est déjà nommée et implémentée dans `Features/Game/Diagnostics/OculomotorTrace.swift` :
l'état vaut `VALID_INSIDE`, `VALID_OUTSIDE` ou `INVALID`, et `lastEdge` (ligne 84) est documenté ainsi :
« the projected side while VALID_OUTSIDE, the last observed direction while INVALID, nil while inside ».

**FACT.** Ce fichier sait déjà reconnaître la saturation de l'écrêtage — lignes 179 à 182, il recalcule la marge de
0,5 et lève un drapeau `capped` quand le point touche la borne. L'information « on ne sait plus jusqu'où » est donc
déjà disponible, et distincte de « on sait de quel côté ».

## 4. Ce qui existe déjà côté rendu

**FACT.** `Features/Game/Rendering/GameSceneSnapshot.swift` lignes 139–153 définit
`GazeDiagnostics { raw, calibrated, edge }` avec `enum Edge { left, right, top, bottom }`.

**FACT.** `Features/Game/Rendering/GameSceneRenderer.swift` lignes 588+ contient déjà `drawEdgeIndicator(_:in:)`,
qui dessine un chevron sur le bord concerné.

**FACT.** Ce chevron **ne s'affiche jamais en Release** : le seul endroit qui renseigne `edge` est dans un bloc
`#if DEBUG` de `GameViewModel.handleGazeSample`, et il dépend en plus de `OculomotorTrace`, dont la propriété
porteuse est elle-même en DEBUG (voir document 01, §3.2).

## 5. Réponses demandées

```
OUT-OF-BOUNDS DIRECTION AVAILABLE:   YES
OUT-OF-BOUNDS MAGNITUDE AVAILABLE:   PARTIAL
CLAMP LOCATION:
  SOURCE FILE: AR/Calibration/GazeMapper.swift
  FUNCTION:    screenPoint(normalized:)
  LINES:       47–53  (marges 49–50, borne 51–52 ; paramètre `overshoot` ligne 14, défaut 0.5)
```

**DIRECTION : YES.** Le point rendu porte le signe et l'axe du dépassement, sans ambiguïté, tant que la projection
existe. Quand elle n'existe plus, la dernière direction observée reste disponible — c'est déjà ce que fait
`OculomotorTrace.nearEdge`.

**AMPLITUDE : PARTIAL.** Proportionnelle et fidèle jusqu'à un demi-viewport au-delà du bord ; **saturée ensuite**.
Iris peut donc dire « loin à gauche », jamais « à 2,3 largeurs d'écran à gauche ». La saturation est détectable
(`capped`), ce qui permet de distinguer honnêtement les deux situations.

## 6. Faisabilité du futur halo de bord — **sans toucher au Gaze Engine**

**FUTURE EDGE HALO FEASIBLE WITHOUT CHANGING GAZE ENGINE : YES.**

Fondement — trois briques existent déjà, et aucune n'est dans le moteur du regard :

1. la **donnée** : le point hors bornes arrive intact jusqu'à la présentation (§2) ;
2. le **modèle** : `GazeDiagnostics.edge` et `enum Edge` existent dans le snapshot (§4) ;
3. le **rendu** : `drawEdgeIndicator` existe déjà (§4).

Le travail du Gate 2 serait donc de *présentation* : calculer le bord depuis le point déjà disponible, hors
`#if DEBUG`, sous contrôle du futur mode d'aide, et dessiner un halo au lieu d'un chevron de diagnostic.

**Ce qu'il ne faudra pas faire, et que ce document interdit d'avance :** inventer une position hors écran au-delà de
la saturation. Iris ne la connaît pas. Un halo peut indiquer un **côté** ; il ne peut pas indiquer une **distance**
au-delà d'un demi-viewport sans mentir.

**Aucune implémentation n'est faite dans cette mission**, conformément au §14 du mandat.
