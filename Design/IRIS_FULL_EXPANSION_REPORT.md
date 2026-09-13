# Iris — rapport de l'expansion intégrale (branche `feature/iris-full-expansion`, 13 septembre 2026)

Statut global : **TECHNIQUEMENT VALIDÉ / À JOUER HUMAINEMENT**. Aucun niveau des chapitres VII à XII n'a été joué sur un iPhone TrueDepth ; tout ce qui suit est mesuré par la simulation, les tests et le rendu en simulateur.

## 1. Ce qui est protégé

| Invariant | Protection |
|---|---|
| Chapitres I à VI, 34 niveaux (gameplay, physique, géométrie, textes, audio, haptique, identifiants, ordre) | `Tests/IrisTests/Fixtures/historical_campaign.txt` : empreinte canonique de 900 lignes (champs auteur, résolution 393 × 852, trace de 8 s à regard scripté) comparée octet pour octet ; `HistoricalCampaignFingerprintTests` |
| Sources gelées (six fichiers `Campaign+*.swift` historiques, tout `AR/` = Gaze Engine, `GazeFilter`, `TargetPhysics`) | SHA-256 de chaque fichier dans `HistoricalCampaignFingerprintTests.frozenSources` |
| Pureté des niveaux historiques | aucun jumeau, souffle, écho, dormeuse, gouffre ni braise ; thème `chambreNoire` |
| Pas de nouveau comportement dans le pas historique | les mécaniques ajoutent des impulsions uniquement quand elles existent ; une file d'impulsions vide n'est jamais ajoutée ; `BehaviourScale` reste neutre |
| Audio / haptique | aucun nouveau son ni nouvelle pulsation : les idées nouvelles réutilisent la pulsation douce, l'engloutissement réutilise la tonalité de perte ; Effets ON / Ambiance OFF par défaut inchangés |
| `main`, `baseline/iris-expansion-validated`, `baseline-expansion-v1` | jamais touchés (vérifiés avant chaque push) |

## 2. Les six chapitres

| Chapitre | Idée (verbe) | Règle en une phrase | Preuve de nécessité |
|---|---|---|---|
| VII jumelles (6 niveaux, rose sur prune) | réunir | Les jumelles n'ont pas d'iris : chacune attend à son poste ; à portée (0,24 du petit côté, relâchement à 0,30) chacune devient l'iris de l'autre et elles se rejoignent seules | sans poussée, les jumelles ne se voient jamais (25 s simulées sur chaque niveau) |
| VIII souffles (6, cyan sur encre bleu-vert) | porter | Un souffle parcourt sa piste périodiquement (8 s, présent 70 %), emporte toute lueur qu'il traverse et la fait passer par-dessus les voiles ; contre un voile, une lueur glisse vers son iris, il faut la placer sur la piste quand le souffle arrive puis ne plus la regarder (un regard proche la fait tomber) | ablation : sans souffle le voile tient sur les six niveaux ; rien n'est emporté sans le joueur |
| IX échos (6, chartreuse sur mousse) | réveiller | Une dormeuse ne bouge pas et garde l'iris fermé ; l'iris qui se ferme émet un anneau (portée 0,45, vitesse 0,9 petit côté/s) qui réveille et lance les dormeuses atteintes ; un iris fermé respire l'anneau toutes les 4 s | ablation : iris silencieux, la dormeuse ne se réveille jamais |
| X gouffres (6, lavande sur abîme) | esquiver | Un gouffre aspire à portée et avale ce qui entre dans sa bouche : la lueur est tenue 0,7 s puis renvoyée à son départ (une lueur fermée perd sa place) | politique « tout droit » : engloutie sans fin partout où le gouffre est sur la ligne droite ; sans gouffre la ligne droite réussit ; le détour réussit |
| XI braises (6, orange braise sur encre brûlée) | réveiller au regard | La braise validée humainement (réglage A, gelé octet pour octet) rejoint la campagne : seule, à deux, dans un courant, derrière un voile, réveillant une dormeuse par son écho, dans l'ordre | l'évitement (regard jamais proche) n'achève aucun niveau |
| XII constellation (6, argent sur nuit) | tout ensemble | Chaque niveau tisse au moins deux idées, le dernier trois ; le dernier iris est réveillé par l'écho du rendez-vous des jumelles | évitement impossible sur les six ; chaque idée du Carnet est introduite une seule fois, dans l'ordre |

Idées écartées en cours de production : Phares (rythme d'ouverture d'iris : la simulation n'y trouvait pas de décision, seulement de l'attente), Miroirs (nécessité indémontrable, réglage impossible sans humain), souffles à ballant ou déviés par le regard (conséquence brouillonne). Aucun prototype intermédiaire n'a été committé.

## 3. Mesures (bot guidé, 3 graines, 393 × 852, moyenne)

| Niveau | temps s | intrusions | difficulté | Niveau | temps s | intrusions | difficulté |
|---|---|---|---|---|---|---|---|
| 7-1 | 5,0 | 1,7 | 3,47 | 10-1 | 6,0 | 1,0 | 2,39 |
| 7-2 | 5,6 | 2,0 | 4,28 | 10-2 | 7,0 | 1,0 | 3,12 |
| 7-3 | 8,9 | 3,7 | 4,76 | 10-3 | 4,6 | 1,0 | 3,28 |
| 7-4 | 6,1 | 2,0 | 4,48 | 10-4 | 8,3 | 1,0 | 3,40 |
| 7-5 | 6,0 | 4,0 | 4,29 | 10-5 | 9,8 | 4,7 | 4,35 |
| 7-6 | 8,1 | 5,3 | 5,70 | 10-6 | 7,5 | 2,0 | 5,57 |
| 8-1 | 6,5 | 2,0 | 3,50 | 11-1 | 4,9 | 2,0 | 2,15 |
| 8-2 | 13,0 | 8,0 | 4,93 | 11-2 | 4,6 | 3,0 | 3,84 |
| 8-3 | 12,9 | 4,0 | 3,78 | 11-3 | 6,1 | 1,0 | 3,22 |
| 8-4 | 6,7 | 1,0 | 4,45 | 11-4 | 6,0 | 1,0 | 3,18 |
| 8-5 | 8,4 | 3,0 | 4,39 | 11-5 | 6,6 | 4,0 | 4,31 |
| 8-6 | 7,1 | 6,0 | 5,36 | 11-6 | 7,9 | 4,0 | 6,36 |
| 9-1 | 10,6 | 15,7 | 3,97 | 12-1 | 15,5 | 1,3 | 4,72 |
| 9-2 | 5,4 | 4,0 | 3,47 | 12-2 | 12,4 | 5,7 | 4,32 |
| 9-3 | 6,6 | 3,0 | 5,55 | 12-3 | 6,2 | 2,0 | 4,03 |
| 9-4 | 6,4 | 1,3 | 4,55 | 12-4 | 8,1 | 2,0 | 6,01 |
| 9-5 | 10,6 | 8,3 | 4,78 | 12-5 | 8,3 | 8,3 | 5,63 |
| 9-6 | 8,7 | 3,3 | 6,53 | 12-6 | 11,5 | 6,0 | 6,31 |

Les pars suivent la formule historique (`temps = arrondi(1,8 × bot + 6)`, `intrusions = plafond(bot) + 2`) ; chaque chapitre garde son dernier niveau comme plus difficile ; deux niveaux d'un même chapitre diffèrent toujours sur au moins deux critères ; tout niveau est infaisable le regard hors de l'écran (R-23).

## 4. Infrastructure partagée (commit `19f2b1c`)

`Campaign.historicalChapters` + `Campaign.expansionChapters` ; `ChapterTheme` et `DSThemePalette` (lavis de fond, accent, halo ; `chambreNoire` rend exactement comme avant) ; file d'impulsions par cible dans `GameSession` ; numéraux jusqu'à XX ; fin de parcours et éclats dynamiques (66 niveaux, 198 éclats) ; tests d'empreinte et de sources gelées.

## 5. Le simulateur de joueur

`CampaignBot` a appris, sans changer son comportement sur les niveaux historiques : à pousser une jumelle vers sa sœur, à attendre un souffle et tenir la lueur sur la piste depuis loin puis la lâcher, à amener une dormeuse à portée d'un iris (ou d'un rendez-vous de jumelles), à suivre les routes des dormeuses, et une politique « tout droit » qui ignore les routes (chapitre X).

## 6. Ce qui reste humain

- Le rythme d'un souffle (8 s, passage de 2,4 s au croisement) et la lisibilité du disque.
- La portée des jumelles (94 pt) et la sensation de leur fusion.
- La lisibilité des anneaux d'écho et de la respiration des iris fermés.
- La dureté du renvoi au départ par les gouffres.
- L'équilibre des combinaisons du chapitre XII.
- Les lavis de couleur par chapitre (jugés seulement en simulateur).

Rien de tout cela n'est « HUMAINEMENT VALIDÉ ».
