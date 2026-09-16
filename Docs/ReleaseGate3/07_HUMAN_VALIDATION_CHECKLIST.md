# 07 — Checklist de validation humaine du Gate 3

> **VALIDÉE — 17 septembre 2026.** Le Gate 3 a été joué et déclaré **passé** par l'humain :
> validation visuelle PASSED, validation gameplay PASSED. Le retour est un verdict d'ensemble ;
> aucun résultat ligne par ligne n'a été remonté, et aucune ligne n'est donc cochée individuellement
> ci-dessous. Le tableau reste comme trace de ce qui était couvert.
>
> Le comportement validé ici est figé : il doit être préservé par tout travail ultérieur.

Build installée sur les deux appareils : Iris 1.0 (1), Debug signée, branche `feature/iris-gaze-assistance-gate-3`.

> **Avant de commencer.** L'apprentissage ne se déclenche que si le chapitre I niveau 3 n'est pas terminé sur
> l'appareil. Pour revoir le parcours complet depuis le début : **Réglages → Réinitialiser la progression**.
> Cela efface les niveaux atteints et les éclats — ne le faites que si vous acceptez de les perdre.

| # | À vérifier | Attendu | Couvert |
|---|---|---|---|
| **A** | Introduction avant I-1 | trois écrans : « Votre regard n'est pas un point fixe », « Iris vous accompagne au début », « Vous gardez toujours le choix » ; boutons Suivant puis Commencer ; le niveau démarre ensuite | ✓ ensemble |
| **B** | I-1 | le repère (anneau ambre) reste visible **tout le niveau** | ✓ ensemble |
| **C** | I-2 | le repère reste visible **tout le niveau** ; on voit qu'il bouge un peu même en fixant | ✓ ensemble |
| **D** | I-3 | repère entier au départ, puis **fondu progressif** ; éteint vers la fin ; **jamais une coupure nette** | ✓ ensemble |
| **E** | I-4 | plus de repère imposé : c'est le mode des Réglages qui s'applique | ✓ ensemble |
| **F** | Mode **Classique** | aucun repère pendant le jeu | ✓ ensemble |
| **G** | Mode **Guidé** | le repère apparaît brièvement, environ toutes les 6 s, et repart en douceur ; jamais clignotant | ✓ ensemble |
| **H** | Mode **Visible** | le repère reste présent pendant le jeu | ✓ ensemble |
| **I** | Halo — gauche, droite, haut, bas | regarder franchement au-delà de chaque bord : un halo ambre s'allume **du bon côté** | ✓ ensemble |
| **I′** | Halo — quatre coins | regarder au-delà d'un coin : le halo s'allume **sur le coin**, pas sur un seul côté | ✓ ensemble |
| **I″** | Halo — intensité | plus le regard s'éloigne, plus le halo est marqué, jusqu'à un palier | ✓ ensemble |
| **J** | Calibration | après une calibration : « Calibration réussie — écart moyen N % » ; plus aucun « erreur moyenne … de la largeur » | ✓ ensemble |
| **K** | III-7 « le fil vivant » | quand le regard suit l'étincelle, elle **s'intensifie** (halo plus large, cœur plus vif, anneau) ; quand le regard la quitte, elle redevient normale | ✓ ensemble |
| **L** | Gameplay inchangé | répulsion, vitesses, difficulté, validation : rien ne semble différent d'avant | ✓ ensemble |
| **M** | Fluidité | aucune saccade nouvelle, en particulier avec le halo actif et en mode Visible | ✓ ensemble |
| **N** | Aucun flash nouveau | aucun changement brutal d'apparence pendant le test | ✓ ensemble |
| **O** | Vocabulaire | nulle part : « diagnostic », « VALID_INSIDE », « YAW », « PITCH », coordonnées techniques | ✓ ensemble |
| **P** | VoiceOver — Aide au regard | chaque mode s'annonce avec son nom, sa phrase, et « sélectionné » pour celui qui l'est | ✓ ensemble |
| **Q** | Gros caractères | Réglages → Aide au regard reste lisible, rien n'est tronqué | ✓ ensemble |
| **R** | Reduce Motion | le halo reste informatif ; aucune pulsation décorative | ✓ ensemble |

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


---

## Ce qui reste à valider : l'accès depuis la pause (17 septembre 2026)

Raffinement approuvé **après** la validation ci-dessus, donc **non validé** à ce jour.

| # | À vérifier | Attendu | Verdict |
|---|---|---|---|
| **S** | Accès | Pause → « aide au regard » → trois choix, sans passer par Chapitres ni Réglages | ☐ |
| **T** | Effet immédiat | choisir un mode puis **Reprendre** : le niveau obéit tout de suite | ☐ |
| **U** | Aller-retour | changer en pause, ouvrir les Réglages : la même valeur y est sélectionnée | ☐ |
| **V** | Retour inverse | changer dans les Réglages, revenir en pause : la même valeur y est sélectionnée | ☐ |
| **W** | Persistance | quitter l'app, la rouvrir : le mode choisi en pause est toujours là | ☐ |
| **X** | Apprentissage I-1 / I-2 / I-3 (première fois) | les trois choix sont **grisés** et la phrase « L'aide au regard est guidée pendant les premiers niveaux d'apprentissage. » s'affiche | ☐ |
| **Y** | Après I-3 | en pause sur n'importe quel niveau, y compris en rejouant I-1, les choix redeviennent actifs | ☐ |
| **Z** | Calme | le panneau de pause reste compact et lisible ; le verre n'est pas cassé ; rien n'est tronqué en gros caractères | ☐ |

Aucun de ces points ne doit être marqué HUMAN PASS sans retour humain.


---

## Section finale : microcopie de la pause, calibration, accessibilité (17 septembre 2026)

Ajoutée après le raffinement d'accès en pause. **Rien ici n'est validé.**

### Taille de texte normale

| # | À vérifier | Verdict |
|---|---|---|
| **A** | Pause → « aide au regard » est visible | ☐ |
| **B** | Classique → **Sans repère** s'affiche dessous | ☐ |
| **C** | Guidé → **Repère ponctuel** s'affiche dessous | ☐ |
| **D** | Visible → **Repère permanent** s'affiche dessous | ☐ |
| **E** | le mode sélectionné reste évident au premier coup d'œil | ☐ |
| **F** | la ligne de calibration reste lisible | ☐ |
| **G** | « Plus l'écart est faible, plus le suivi du regard est précis. » est lisible juste dessous | ☐ |
| **H** | **Reprendre** reste visible et atteignable | ☐ |
| **I** | **Recommencer** reste visible et atteignable | ☐ |
| **J** | **Chapitres** reste visible et atteignable | ☐ |

### Première traversée de l'apprentissage

| # | À vérifier | Verdict |
|---|---|---|
| **K** | I-1 : les trois choix sont grisés | ☐ |
| **L** | I-2 : les trois choix sont grisés | ☐ |
| **M** | I-3 : les trois choix sont grisés | ☐ |
| **N** | « L'aide au regard est guidée pendant les premiers niveaux d'apprentissage. » est lisible | ☐ |
| **O** | après I-3 terminé, les choix redeviennent actifs | ☐ |

### Taille de texte (Dynamic Type)

Réglages iOS → Affichage et luminosité → Taille du texte, puis Accessibilité → Affichage et taille du texte.

| # | À vérifier | Verdict |
|---|---|---|
| **P** | pause avec un texte iOS agrandi | ☐ |
| **Q** | pause avec une taille d'accessibilité | ☐ |
| **R** | aucun bouton principal ne devient inatteignable (le panneau défile) | ☐ |
| **S** | aucun texte porteur de sens n'est coupé | ☐ |

### VoiceOver

| # | À vérifier | Attendu | Verdict |
|---|---|---|---|
| **T** | Classique | « Classique, sans repère » | ☐ |
| **U** | Guidé | « Guidé, repère ponctuel » | ☐ |
| **V** | Visible | « Visible, repère permanent » | ☐ |
| **W** | sélection | le mode choisi est annoncé comme sélectionné | ☐ |
| **X** | verrou d'apprentissage | pendant I-1/I-2/I-3 les choix s'annoncent comme indisponibles, et la raison est lue | ☐ |

### Stabilité

| # | À vérifier | Verdict |
|---|---|---|
| **Y** | aucune latence nouvelle à l'ouverture de la pause | ☐ |
| **Z** | aucun flash nouveau attribuable à ce raffinement | ☐ |

Aucun de ces points ne doit être marqué HUMAN PASS sans retour humain.

**Ce qui a été vérifié techniquement, et ne vous demande donc que confirmation :** les trois libellés compacts,
la phrase de calibration, la conservation des explications longues des Réglages, et le fait que le sélecteur
— compact comme détaillé — tient dans la largeur de chaque iPhone jusqu'à `accessibility5` sans déborder.
**Ce que la machine ne sait pas dire :** ce que VoiceOver prononce réellement, et si le panneau reste
confortable une fois le texte agrandi. C'est P à X.
