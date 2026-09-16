# 08 — Release Gate 3 : rapport

Base : `373a142` → branche `feature/iris-gaze-assistance-gate-3`.
Xcode 26.3 (17C529). Installée sur iPhone 14 Pro (`iPhone15,2`) et iPhone 15 Pro (`iPhone16,1`).

## Ce qui a été construit

| Objectif du mandat | État |
|---|---|
| Le repère devient une fonction produit | **fait** — section « aide au regard », le mot « diagnostic » a disparu de l'interface joueur |
| Trois modes Classique / Guidé / Visible | **fait** — `GazeAssistanceMode`, défaut `classic` |
| Indicateur périphérique de sortie d'écran | **fait** — halo localisé, 8 directions, intensité mesurée |
| Apprentissage I-1 / I-2 / I-3 | **fait** — visible, visible, fondu progressif |
| Introduction avant I-1 | **fait** — trois écrans |
| Calibration reformulée | **fait** — « Calibration réussie — écart moyen N % » |
| Feedback III-7 | **fait** — l'étincelle répond au regard |
| Systèmes gelés préservés | **oui** — `git diff` vide sur le moteur, la campagne, la calibration, StoreKit |

## Les décisions qui méritent d'être connues

**La fin de l'apprentissage n'est pas un nouveau drapeau.** Elle se déduit de `progress.isCompleted("1-3")`, déjà
enregistrée. Un seul drapeau a été ajouté, `hasSeenGazeIntroduction`, parce que lui ne peut pas se déduire : on
peut ouvrir un niveau sans le finir.

**La disparition de I-3 utilise `GameSession.elapsed`**, qui n'avance que pendant `.playing` : c'est du temps de jeu
actif, pause exclue, déjà existant. Aucune horloge ajoutée, aucune logique de niveau modifiée.

**Le seuil du feedback III-7 est celui du moteur.** `FilStageState.isNear` — avec son hystérésis — était déjà
transmis à la présentation sous le nom `isLit` ; seul le renderer l'ignorait. Aucun seuil visuel n'a été inventé, et
un test compare les deux à chaque frame pour qu'ils ne divergent jamais.

**Le halo sature là où le pipeline cesse de mesurer.** Au-delà d'un demi-viewport, l'intensité reste à 1 : Iris ne
sait pas, donc ne dit pas.

## Une régression introduite, puis corrigée

En réécrivant le snapshot, la suppression des marques de regard pendant les cercles à la tête seule du chapitre X a
été perdue. `AncreSceneTests` K l'a détectée aussitôt. La condition a été rétablie pour le repère **et** pour les
diagnostics ; le test est vert.

## Tests et builds

```
541 tests · 78 suites · 0 échec · 5 ignorés (captures) · 17 known issues (runtime StoreKit iOS 26.3)
Debug ✓   Release ✓ (aucun avertissement Iris)   appareil signé ✓
Installée : iPhone 14 Pro ✓   iPhone 15 Pro ✓
Tools/audit.py : C1 C2 C8 C9 C10 C12 — tous verts
```

Aucun diagnostic technique n'atteint Release : 0 symbole pour `drawDiagnostics`, `drawEdgeIndicator`,
`showsDeveloperGazeDiagnostics`, `oculoStatus` ; 0 occurrence de « Corail » et « (diagnostic) ».

## Ce qui n'est pas validé

**Rien n'a été vu par un humain.** Les installations ne sont pas une validation visuelle. Les modes, les fondus, le
halo, le feedback de l'étincelle et la fluidité doivent être jugés physiquement : checklist au document 07.

Les constantes réglables — `guidedPeriod`, `guidedHold`, `guidedFade`, `learningHold`, `learningFade` — sont
réunies dans `GazeAssistancePolicy` précisément pour être ajustées après ce test.

## Contexte de publication, inchangé depuis le Gate 2

```
PERFORMANCE: aucune régression bloquante reproduite
JETSAM HISTORIQUE: non attribuable à Iris — non bloquant
FLASH: cause non déterminée — non bloquant — à surveiller
```
