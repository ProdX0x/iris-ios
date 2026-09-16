# 04 — Calibration : le texte vu par le joueur

## 1. Avant

```
Calibration validée, erreur moyenne 7 % de la largeur.
Regard non calibré : projection nominale.
```

« Erreur », « de la largeur », « projection nominale » : la donnée est juste, la phrase est destinée à un ingénieur.

## 2. Après

```
Calibration réussie — écart moyen 7 %.
Calibration à refaire — écart moyen 21 %.
Regard non calibré.
```

Et, là où la place le permet (`GazeCalibrationStatus.explanation`) :

```
Plus cette valeur est basse, plus la calibration correspond précisément à votre regard.
Recalibrez pour qu'Iris suive votre regard plus précisément.
```

## 3. Ce qui n'a pas changé

**La valeur est la même, au chiffre près.** `GazeCalibrationStatus` reçoit toujours
`CalibrationProfile.validationMeanError` du moteur, et l'arrondit toujours par
`Int((meanError * 100).rounded())` — l'arrondi d'origine, déplacé dans une fonction nommée, pas modifié.

| | |
|---|---|
| Mathématiques de calibration | **inchangées** |
| Calcul de l'erreur | **inchangé** |
| Seuils de validation (`isValid`) | **inchangés** |
| Note de qualité inventée (« Excellent / Bon / Mauvais ») | **aucune** |

Le mandat interdit de fabriquer une échelle de qualité sans seuil déjà prouvé. Aucun palier n'a été inventé : le
texte ne distingue que ce que le moteur distingue déjà, `isValid` vrai ou faux, et montre le nombre tel quel.

## 4. La référence donnée au joueur

Le troisième écran d'introduction porte la phrase que le mandat demande :

> Plus le pourcentage d'écart de calibration est faible, plus la calibration correspond précisément à votre regard.
> 0 % est une référence idéale : un écart nul n'est pas attendu en usage réel.

Elle dit ce qu'est un bon chiffre **sans promettre une précision parfaite**.

## 5. Vocabulaire

Le mot « diagnostic » disparaît de l'interface joueur. L'interrupteur « Points de regard (diagnostic) » est
remplacé par la section **« aide au regard »** et le terme **« repère »**. Un test vérifie qu'aucun nom ou résumé de
mode ne contient « diagnostic », « debug », « capteur », « pointeur », `VALID`, `YAW` ou `PITCH`.
