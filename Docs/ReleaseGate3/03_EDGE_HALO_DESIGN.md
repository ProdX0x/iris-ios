# 03 — Indicateur de sortie d'écran

## 1. D'où vient la donnée

Le Gate 1 a établi, et mesuré :

```
OUT-OF-BOUNDS DIRECTION AVAILABLE: YES
OUT-OF-BOUNDS MAGNITUDE AVAILABLE: PARTIAL
CLAMP: AR/Calibration/GazeMapper.swift → screenPoint(normalized:), overshoot = 0.5
```

Le seul écrêtage du pipeline borne au viewport **élargi de 50 % de chaque côté**. Les coordonnées hors écran
existent donc réellement, et traversent l'aval intactes.

`GazeEdgeGuidance.from(point:in:)` les lit — **rien n'est inventé, rien n'est extrapolé.**

## 2. Direction

Huit directions : quatre côtés et quatre coins. Un dépassement sur les deux axes donne un coin ; sur un seul, un
côté. Chacune a sa position à l'écran (`GameSceneRenderer.haloAnchor`), et un test vérifie que les huit sont
distinctes.

## 3. Intensité, et sa saturation honnête

```
intensité = dépassement / (0,5 × dimension du viewport), borné à 1
```

`GazeEdgeGuidance.measurableOvershoot = 0.5` **doit rester égal à `GazeMapper.overshoot`** ; un test l'affirme.

Conséquence assumée : à mi-viewport au-delà du bord, l'intensité vaut 1 — et elle **reste 1** au-delà, parce que le
pipeline ne mesure plus rien. Le halo dit un **côté** et une **force jusqu'à la limite de la mesure** ; il ne dit
jamais une distance qu'Iris ignore. Un test vérifie précisément ce plafond.

Pour un coin, l'intensité est la **plus forte** des deux.

## 4. Le rendu

Un dégradé radial ancré sur le bord ou le coin concerné, dans l'ambre du chapitre :

- rayon : 42 % du petit côté ;
- opacité : `0,16 + 0,34 × intensité`, soit 0,16 à 0,50 ;
- **une seule passe de remplissage**, pas de cadre permanent, pas de clignotement.

Localisé, comme le mandat le demande : une sortie en haut à droite allume le coin haut droit, pas tout le pourtour.

## 5. Quand il apparaît

Dans **les trois modes** — c'est une aide périphérique, pas un repère. En Classique, où le repère reste masqué, le
halo est la seule aide : un test le vérifie explicitement (repère nul, halo présent).

Il exige un curseur **réellement placé** : `session.gaze.isActive`. Sans suivi, aucune direction n'est affirmée —
le mandat l'exige, et un test le vérifie sur une session fraîche.

Il se tait aussi pendant les cercles à la tête seule du chapitre X, comme le repère : la projection y dérive avec
la tête, et le Gate 3 n'a rien changé à cette règle.

## 6. Portée

Le halo n'existe **que dans l'écran de jeu**, où le suivi du regard est déjà actif. Aucune session ARKit n'est
ouverte ailleurs : ni au Seuil, ni dans les Réglages, ni aux Chapitres, ni au Carnet. Il est calculé dans le
`GameSceneSnapshot`, c'est-à-dire là où le regard alimente déjà la physique.

## 7. Coût

| Interdit par le mandat | Ajouté ? |
|---|---|
| `TimelineView` permanent | non |
| timer 60 Hz supplémentaire | non |
| nouveau `CADisplayLink` | non |
| `drawingGroup` | non |
| flou plein écran | non |
| Metal, shader | non |
| surface recréée en boucle | non |
| invalidation SwiftUI de la racine à chaque échantillon | non |

Le halo est dessiné **dans le `Canvas` de jeu déjà existant**, à partir du snapshot déjà reconstruit à chaque
frame. Il n'ajoute aucune vue, aucun état observable et aucune source d'invalidation.

Hors jeu, la reconstruction entre les ticks a même été **resserrée** : elle n'a désormais lieu que si le repère est
réellement à l'écran, alors qu'elle suivait auparavant l'interrupteur de diagnostic.

## 8. Reduce Motion

Le halo **n'a aucune animation** : ni pulsation, ni déplacement, ni dépendance au temps. Son intensité ne dépend que
du dépassement mesuré. Il n'y a donc rien à désactiver, et **l'information reste entière** sous Reduce Motion — un
test relit le corps de la fonction pour s'assurer qu'aucun `sin`, `phase`, `time` ou `repeatForever` n'y entre.
