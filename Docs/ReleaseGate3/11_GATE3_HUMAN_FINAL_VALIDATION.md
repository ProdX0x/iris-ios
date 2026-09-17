# Iris — Release Gate 3 — Final Human Validation

Document de clôture. Il n'ajoute aucun code : il enregistre ce qu'un humain a réellement vérifié sur appareil,
et ce qu'il a délibérément choisi de ne pas vérifier.

## Repository state

| | |
|---|---|
| Branche | `feature/iris-gaze-assistance-pause-copy` |
| HEAD de départ | `b32bab1a5745b927360c60e354d077c21f717cad` |
| Date | 17 septembre 2026 |
| Push | non |
| Tag | non |
| `main` | inchangé — `52f20b7`, identique à `origin/main` |
| Fusion vers `main` | aucune |

## Human validation

Vérifié physiquement, sur iPhone.

| Domaine | Verdict |
|---|---|
| Aide au regard — mode **Classique** | PASS |
| Aide au regard — mode **Guidé** | PASS |
| Aide au regard — mode **Visible** | PASS |
| Apprentissage **I-1 / I-2 / I-3** | PASS |
| Comportement **après** l'apprentissage (I-4+, rejeu) | PASS |
| Guidage hors écran — **halo directionnel** | PASS |
| Retour lumineux **III-7** | PASS |
| Accès direct aux modes depuis la **pause** | PASS |
| **Microcopie finale** (pause et calibration) | PASS |
| **Texte agrandi** (Dynamic Type), essai humain | PASS |
| Comportement général sur appareil physique | PASS |
| **VoiceOver** | NOT REQUIRED FOR GATE 3 / NOT HUMAN-TESTED |

Aucun problème bloquant n'a été constaté.

### La copie finale, telle que validée

Pause :

```
○ Classique      Sans repère
○ Guidé          Repère ponctuel
○ Visible        Repère permanent
```

Calibration : le pourcentage d'écart moyen est conservé tel quel, suivi de

> Plus l'écart est faible, plus le suivi du regard est précis.

Apprentissage : I-1, I-2 et I-3 protégés en première traversée ; I-4 et au-delà libres ; une fois I-3 terminé, le
rejeu de I-1, I-2 et I-3 obéit au mode choisi par le joueur.

## VoiceOver rationale

VoiceOver n'a volontairement pas fait l'objet d'un test humain final.

Iris est un jeu dont la mécanique repose sur la vision et sur le contrôle du regard : la partie se joue en
regardant l'écran. VoiceOver n'est donc pas un critère de validation bloquant de ce Gate.

Ce que cela ne dit pas :

- Iris **n'est pas** annoncé comme accessible aux personnes aveugles, et aucune promesse d'accessibilité complète
  n'est formulée ;
- VoiceOver **n'est pas** retiré ;
- les bonnes pratiques d'accessibilité déjà en place **ne doivent pas** être dégradées par un travail ultérieur.

Ce que la vérification technique avait établi, et qui reste vrai :

| | |
|---|---|
| Titre et signification exposés par choix | oui — une seule règle sert à dessiner la ligne et à répondre à VoiceOver |
| État sélectionné exposé | oui — trait `.isSelected` |
| Contrôles d'accessibilité dupliqués | aucun — le marqueur rond est masqué, une ligne est un élément |
| État désactivé pendant l'apprentissage | non mesuré humainement |

Ces quatre points restent des mesures techniques. Aucun d'eux n'est converti en PASS humain.

## Frozen systems

Cette mission est une mission de documentation. Son diff ne contient que des fichiers sous `Docs/ReleaseGate3/`.

Aucun système gelé n'a été modifié : Gaze Engine, GazeMapper, GazeFilter, mathématiques ARKit du regard,
mathématiques et seuils de calibration, TargetPhysics, LevelDefinitions, structure de campagne, règles de
progression, X-7, halo périphérique, III-7, StoreKit, audio, haptique, Liquid Glass.

Le dernier état vérifié du produit, au HEAD ci-dessus : 567 tests en 80 suites, 0 échec, 5 ignorés (captures),
17 known issues — toutes la limitation d'environnement StoreKit déjà documentée ; `Tools/audit.py` vert sur
349 fichiers ; builds Debug, Release et appareil signé réussis ; installée et lancée sur iPhone 14 Pro et
iPhone 15 Pro.

## Final Gate 3 decision

```
GATE 3 HUMAN VALIDATION: PASS
GATE 3 DEFINITIVELY CLOSED: YES
```

Le Gate 3 est clos. Cela ne rend pas Iris publiable : la soumission App Store reste conditionnée aux étapes
qui n'appartiennent pas à ce Gate.
