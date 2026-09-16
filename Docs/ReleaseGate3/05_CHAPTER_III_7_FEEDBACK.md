# 05 — Chapitre III, niveau 7 : le retour lumineux

## 1. Le besoin

Dans « le fil vivant », une étincelle traverse l'écran et doit être suivie du regard. Le joueur ne savait pas si son
regard était correctement sur elle.

## 2. Le seuil : celui du moteur, pas un nouveau

**Aucun seuil n'a été créé.** `FilStageState` calcule déjà, pour la règle du niveau :

```swift
private(set) var isNear = false      // avec hystérésis : entre à `radius`, sort à `releaseRadius`
```

C'est exactement « le regard accompagne l'étincelle » — la grandeur que le moteur utilise **déjà** pour faire
monter la charge d'accompagnement. Le retour lumineux la reflète, sans rien recalculer.

Mieux : `OculoSnapshot` la transmettait **déjà** à la présentation, depuis la construction du niveau :

```swift
OculoElementSnapshot(role: .spark, …, isActive: true, isLit: state.isNear)
```

Le seul défaut était que le renderer l'ignorait. Le Gate 3 la lit.

**Justification du seuil visuel retenu :** c'est le seuil de jeu lui-même. Un seuil visuel distinct aurait pu
allumer l'étincelle alors que la charge ne monte pas — exactement le contresens qu'il fallait éviter. Un test
compare les deux à chaque frame sur 240 frames et exige qu'ils ne divergent jamais.

## 3. Ce qui est dessiné

Dans `GameSceneRenderer+Oculo`, quand `isLit` :

| | au repos | accompagnée |
|---|---|---|
| Halo | rayon 26, opacité 0,2 + 0,5 × intensité | rayon **×1,35**, opacité **0,34** + 0,5 × intensité |
| Cœur | disque 6 pt | disque **7,5 pt** |
| Anneau de confirmation | absent | anneau de 11 pt, `lueurGlow` à 0,5 |
| Cercle de zone | ambre 0,1 | ambre **0,2** |

Un renforcement lumineux, pas un effet agressif : ni clignotement, ni changement de couleur, ni animation ajoutée.

Le cas `.spark` a été **séparé** de `.lantern`, qui le partageait, pour que la portée du changement soit prouvable :
le chapitre X ne passe jamais `isLit` et n'est pas concerné.

## 4. Ce qui ne change pas

| | |
|---|---|
| Trajectoire de l'étincelle | **inchangée** (`position(at:)` intact) |
| Vitesse, période, amplitudes | **inchangées** |
| Physique | **inchangée** |
| Validation, charge, exigence, hystérésis | **inchangées** |
| Difficulté | **inchangée** |
| `GazeMapper`, `GazeFilter`, calibration | **inchangés** |
| Progression, ordre des événements | **inchangés** |

`GameEngine/Oculo/FilStageState.swift` n'a **pas** été modifié : `git diff` y est vide.

**Preuve que le feedback n'influence pas le jeu.** Un test joue le niveau deux fois, à l'identique, en ne changeant
qu'une chose : construire ou non un `GameSceneSnapshot` à chaque frame. Il compare ensuite, sur plus de 400 frames,
la trajectoire complète, la charge d'accompagnement, le nombre de pertes et l'achèvement. Tout doit être identique
— dessiner n'a aucun effet sur la règle.
