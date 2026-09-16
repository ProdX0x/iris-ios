# 07 — Checklist de validation humaine du Gate 3

Rien de ce qui suit n'est validé. **Aucun point ne doit être marqué HUMAN PASS sans un retour humain.**

Build installée sur les deux appareils : Iris 1.0 (1), Debug signée, branche `feature/iris-gaze-assistance-gate-3`.

> **Avant de commencer.** L'apprentissage ne se déclenche que si le chapitre I niveau 3 n'est pas terminé sur
> l'appareil. Pour revoir le parcours complet depuis le début : **Réglages → Réinitialiser la progression**.
> Cela efface les niveaux atteints et les éclats — ne le faites que si vous acceptez de les perdre.

| # | À vérifier | Attendu | Verdict |
|---|---|---|---|
| **A** | Introduction avant I-1 | trois écrans : « Votre regard n'est pas un point fixe », « Iris vous accompagne au début », « Vous gardez toujours le choix » ; boutons Suivant puis Commencer ; le niveau démarre ensuite | ☐ |
| **B** | I-1 | le repère (anneau ambre) reste visible **tout le niveau** | ☐ |
| **C** | I-2 | le repère reste visible **tout le niveau** ; on voit qu'il bouge un peu même en fixant | ☐ |
| **D** | I-3 | repère entier au départ, puis **fondu progressif** ; éteint vers la fin ; **jamais une coupure nette** | ☐ |
| **E** | I-4 | plus de repère imposé : c'est le mode des Réglages qui s'applique | ☐ |
| **F** | Mode **Classique** | aucun repère pendant le jeu | ☐ |
| **G** | Mode **Guidé** | le repère apparaît brièvement, environ toutes les 6 s, et repart en douceur ; jamais clignotant | ☐ |
| **H** | Mode **Visible** | le repère reste présent pendant le jeu | ☐ |
| **I** | Halo — gauche, droite, haut, bas | regarder franchement au-delà de chaque bord : un halo ambre s'allume **du bon côté** | ☐ |
| **I′** | Halo — quatre coins | regarder au-delà d'un coin : le halo s'allume **sur le coin**, pas sur un seul côté | ☐ |
| **I″** | Halo — intensité | plus le regard s'éloigne, plus le halo est marqué, jusqu'à un palier | ☐ |
| **J** | Calibration | après une calibration : « Calibration réussie — écart moyen N % » ; plus aucun « erreur moyenne … de la largeur » | ☐ |
| **K** | III-7 « le fil vivant » | quand le regard suit l'étincelle, elle **s'intensifie** (halo plus large, cœur plus vif, anneau) ; quand le regard la quitte, elle redevient normale | ☐ |
| **L** | Gameplay inchangé | répulsion, vitesses, difficulté, validation : rien ne semble différent d'avant | ☐ |
| **M** | Fluidité | aucune saccade nouvelle, en particulier avec le halo actif et en mode Visible | ☐ |
| **N** | Aucun flash nouveau | aucun changement brutal d'apparence pendant le test | ☐ |
| **O** | Vocabulaire | nulle part : « diagnostic », « VALID_INSIDE », « YAW », « PITCH », coordonnées techniques | ☐ |
| **P** | VoiceOver — Aide au regard | chaque mode s'annonce avec son nom, sa phrase, et « sélectionné » pour celui qui l'est | ☐ |
| **Q** | Gros caractères | Réglages → Aide au regard reste lisible, rien n'est tronqué | ☐ |
| **R** | Reduce Motion | le halo reste informatif ; aucune pulsation décorative | ☐ |

## Ce qui est déjà mesuré, et n'a pas besoin d'être revérifié à la main

| | |
|---|---|
| Tests | 541, 78 suites, 0 échec |
| Builds | Debug ✓ Release ✓ appareil signé ✓ |
| Diagnostics techniques en Release | 0 symbole (`drawDiagnostics`, `drawEdgeIndicator`, `showsDeveloperGazeDiagnostics`, `oculoStatus`) |
| Systèmes gelés | `git diff` vide sur le moteur, la campagne, la calibration, StoreKit |

## Si un point échoue

Notez **lequel**, **sur quel appareil**, et **ce que vous avez vu**. Les constantes du mode Guidé
(`guidedPeriod`, `guidedHold`, `guidedFade`) et de la disparition de I-3 (`learningHold`, `learningFade`) sont
toutes dans `Domain/GazeAssistance/GazeAssistancePolicy.swift` : elles sont faites pour être ajustées après ce test.
