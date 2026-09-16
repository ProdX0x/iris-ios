# 09 — Passation au Release Gate 3

Rien de ce document n'est implémenté. Il consigne ce qui a été décidé, pour que le Gate 3 le traite comme un tout.

## 1. Aide au regard — trois modes

| Mode | Viseur | Aide périphérique |
|---|---|---|
| **Classique** | aucun viseur permanent | information périphérique en sortie d'écran |
| **Guidé** | viseur fantôme / intermittent | idem |
| **Visible** | viseur permanent | idem |

## 2. Apprentissage du chapitre I

- **Avant I-1** : courte introduction expliquant le point de regard.
- **I-1** : viseur permanent. **I-2** : viseur permanent.
- **I-3** : viseur présent au début, puis disparition progressive.
- **I-4 et suivants** : viseur masqué par défaut, selon le mode choisi.
- Le joueur doit être informé qu'il peut **réactiver l'aide depuis les Réglages**.

**Interdits repris du Gate 1 :** le rendu utilisateur ne doit jamais afficher `VALID_INSIDE`, `YAW`, `PITCH`, ni
aucune étiquette de diagnostic ou état technique de calibration. Le viseur produit doit être une **fonction
indépendante** du HUD de diagnostic développeur.

## 3. Ce que Gate 1 a déjà établi pour le halo

```
OUT-OF-BOUNDS DIRECTION AVAILABLE: YES
OUT-OF-BOUNDS MAGNITUDE AVAILABLE: PARTIAL   (proportionnelle jusqu'à un demi-viewport, saturée ensuite)
FUTURE EDGE HALO FEASIBLE WITHOUT CHANGING GAZE ENGINE: YES
CLAMP: AR/Calibration/GazeMapper.swift → screenPoint(normalized:), lignes 47–53, `overshoot` = 0.5
```

Trois briques existent déjà : la donnée (le point hors bornes traverse le pipeline intact), le modèle
(`GazeDiagnostics.Edge`), le rendu (`drawEdgeIndicator`). Elles ne sont alimentées qu'en DEBUG.

**Garde-fou :** un halo peut indiquer un **côté** ; il ne peut pas indiquer une **distance** au-delà d'un
demi-viewport sans mentir.

## 4. Calibration — langage

L'utilisateur doit recevoir une explication compréhensible : **plus le pourcentage d'erreur moyen est faible, plus
la calibration correspond précisément aux points regardés.** Ne pas promettre une précision parfaite. Le jargon
actuel (« Calibration validée, erreur moyenne N % de la largeur ») doit être repensé.

Rappel du Gate 1 : cette lecture technique **est visible en Release**, dans le panneau de pause, classée **G —
décision humaine**. Le Gate 3 est l'endroit où elle se règle, en même temps que les modes d'aide.

## 5. Chapitre III niveau 7

Ajouter un **retour lumineux** lorsque la comète est effectivement suivie. Solution **visuelle uniquement** autant
que possible. Aucune modification de trajectoire, vitesse, physique, validation ou mapping du regard.

## 6. Ce que Gate 2 laisse comme outils

| Outil | Où | Usage |
|---|---|---|
| `LifecycleTrace` (DEBUG) | `App/Diagnostics/` | horodate cycle de vie, avertissements mémoire, état thermique, changements d'accessibilité → `Documents/iris-lifecycle.log` |
| `StoreDiagnostics` (DEBUG) | `Commerce/Diagnostics/` | état StoreKit → `Documents/iris-storekit.log` |
| `DeviceCapabilityReportTests` | `Tests/IrisTests/AR/` | capacités ARKit réelles d'un appareil |
| Protocole `xctrace` | document 02 | la seule séquence de commandes qui fonctionne sur ces appareils |

Tous les instruments DEBUG sont **absents du binaire Release** (0 symbole, vérifié sur la build signée).

## 7. Ce qui reste ouvert en entrant au Gate 3

1. **iPhone 15 Pro non mesuré** (déconnecté) — protocole prêt, document 04.
2. **Frame pacing non mesuré** — une seconde session humaine avec `Animation Hitches`.
3. **État thermique `Serious`** non attribué — refaire une session sur appareil froid.
4. **Cause du flash non déterminée** — instrument en place ; il faut l'heure du prochain épisode.
5. **Environnement de test StoreKit à purger du 15 Pro** avant toute validation représentative.
