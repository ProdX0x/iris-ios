# Iris — système de level design

# STATUT : PROVISOIRE — NON AUTORITAIRE AVANT VALIDATION HUMAINE DES CONCEPTS

Ce document a deux parties. La **partie A** (§ 1 à § 10) décrit le système implémenté et vérifié pour les six chapitres actuels : elle reste exacte pour eux. La **partie B** (§ 11 et suivants, ajoutée le 12 septembre 2026) étend le système aux concepts candidats de `GAME_EXPANSION_CONCEPTS.md` ; elle est provisoire. Aucune règle de ce document ne doit contraindre un concept approuvé : si un chapitre approuvé exige une nouvelle dimension, c'est le système qui évolue, jamais le chapitre qui se plie au format.

## Partie A — système implémenté (chapitres I à VI)

Un niveau d'Iris est une **donnée** (`LevelDefinition`, `Domain/Campaign/`). Il est résolu contre la taille réelle de l'écran (`LevelResolver`), puis simulé par le moteur existant enrichi (`GameSession` + `LevelEnvironment`). Chaque niveau est **vérifié par simulation** (`Tests/IrisTests/Campaign/`).

## 1. Unités

| Grandeur | Unité |
|---|---|
| Positions (départ, iris, voiles, courants, veilleuses, voie) | coordonnées normalisées : `x` par la largeur, `y` par la hauteur, 0…1 |
| Zone d'attention, rayon de regard d'une veilleuse | fraction du **petit côté** de l'écran |
| Forces, vitesses, rayons physiques | points par frame de référence (60 Hz) à l'échelle 1, multipliés par `échelle = petit côté / 393` |
| Durées | secondes |

Écran de référence des mesures : 393 × 852 pt (iPhone 15 Pro / 16 / 17). Le moteur utilise cette échelle, si bien que 1 unité normalisée horizontale vaut 393 pt.

## 2. Paramètres disponibles

### 2.1 Niveau

| Paramètre | Défaut | Plage autorisée | Effet |
|---|---|---|---|
| `zone` | 0,48 | 0,40 – 0,52 | Taille de la région repoussée autour du regard. Plus grande, il est plus difficile de trouver où regarder, et plus facile de pousser. |
| `repulsionForce` | 2,4 | 1,6 – 3,2 | Impulsion au contact. `k = force / zone`. |
| `attraction` | 0,5 | 0,4 – 0,6 | Impulsion vers l'iris (prototype : 0,5 – 0,6). |
| `noise` | 0,15 | 0,10 – 0,20 | Dérive organique (prototype). |
| `hold` | 0,75 s | 0,75 s | Présence continue (identité, non modifiable). |
| `ordered` | selon le niveau | vrai / faux | Règle 1 → 2 → 3. |

### 2.2 Lueur

| Paramètre | Valeurs |
|---|---|
| `start`, `iris` | normalisés, à l'intérieur du champ (marges : `x` 0,16 – 0,84, `y` 0,10 – 0,90) |
| `temperament` | `normale` · `lourde` (répulsion × 0,6, attraction × 0,6, rayon × 1,2) · `vive` (répulsion × 1,45, attraction × 1,2, rayon × 0,8) |
| `route` | points de passage prévus par le designer (voie d'aide et robot), vide pour un niveau d'évitement |
| `irisMotion` | `fixe` · `oscillation(vers, période)` |

### 2.3 Éléments

| Élément | Paramètres | Plages |
|---|---|---|
| Courant | rectangle normalisé, direction unitaire, `strength` | force 0,7 – 1,0 (toujours > attraction, sinon ce ne serait qu'un décor) |
| Voile | segment `a → b` normalisé | longueur ≥ 0,20 largeur, jamais à moins de 30 pt d'un iris ou d'un départ |
| Veilleuse | position, `lookRadius` (0,14), `decay` (5 – 9 s), `recharge` (0,8 s), `initialCharge` (0,3 – 1), `linked` (séquences, vide = toutes) | au plus 2 par niveau |
| Iris mouvant | point d'arrivée secondaire, période | vitesse moyenne ≤ 0,12 largeur / s |

## 3. Règles de combinaison

1. **Un seul élément nouveau par chapitre**, présenté d'abord seul (premier niveau du chapitre, une seule lueur).
2. **Hors chapitre VI, au plus deux types d'éléments par niveau** (un élément du chapitre et un élément déjà maîtrisé).
3. **Au plus 3 lueurs**, au plus 2 courants, 3 voiles, 2 veilleuses.
4. **Un iris n'est jamais dans un courant.** Sinon la lueur ne peut pas se poser sans aide permanente.
5. **Un départ n'est jamais à moins de 0,25 largeur de son iris**, ni dans la zone de validation d'un autre iris.
6. **Un voile laisse toujours un passage ≥ 3 rayons de lueur.**
7. **Toute veilleuse est atteignable par le regard** et son rayon de regard est entièrement sur l'écran.
8. **Le dernier niveau d'un chapitre est sa maîtrise** : il combine tout ce que le chapitre a enseigné et possède la difficulté estimée la plus élevée du chapitre.

## 4. Familles de situations

| Famille | Définition | Compétence |
|---|---|---|
| **Évitement** | les lueurs arrivent seules si le regard reste loin | trouver l'espace libre et le déplacer |
| **Traversée** | une lueur doit parcourir l'écran pendant que la zone libre se déplace | suivre sans regarder |
| **Croisement** | les trajectoires droites se coupent | anticiper où les lueurs seront |
| **Garde** | un iris validé est proche du chemin d'une autre lueur | protéger un acquis |
| **Poussée** | un courant bloque la lueur | pousser dans l'axe |
| **Contournement** | un voile bloque la ligne droite | pousser latéralement, viser un angle |
| **Vigilance** | une veilleuse doit être regardée régulièrement | regarder sans troubler |
| **Poursuite** | l'iris se déplace | anticiper une zone mobile |
| **Synthèse** | plusieurs familles à la fois | lire le niveau avant de jouer |

## 5. Difficulté

### 5.1 Métriques calculées

| Métrique | Calcul |
|---|---|
| `freeArea` | part de l'écran (grille de 6 pt) hors de toutes les zones d'attention centrées sur les départs |
| `crossings` | paires de trajectoires droites (départ → iris) qui se coupent |
| `guardPressure` | nombre d'iris situés dans la zone d'attention d'un point de la trajectoire d'une autre lueur |
| `botTime` | temps de résolution du robot guidé bruité (moyenne sur 3 graines) |
| `botIntrusions` | intrusions du robot guidé |
| `passiveSolves` | le robot d'évitement pur termine-t-il en 60 s ? |
| `unlitSolves` | le robot guidé sans regarder les veilleuses termine-t-il en 60 s ? |

### 5.2 Estimation

```
difficulté = 1,0 × lueurs
           + 1,5 × (1 − freeArea)
           + 0,6 × crossings
           + 0,5 × guardPressure
           + 1,0 × (voiles + courants > 0)
           + 1,0 × veilleuses
           + 0,8 × iris mouvants
           + botTime / 20
```

La formule classe, elle ne mesure pas le plaisir. Elle sert à vérifier la règle 8 et à éviter qu'un niveau de maîtrise soit plus simple qu'un niveau d'introduction.

## 6. Vérification automatique

Pour chaque niveau, sur l'écran de référence :

1. **Validité** : règles 3 à 7 respectées.
2. **Faisabilité** : le robot guidé, avec un regard bruité (± 24 pt, lissage du jeu), termine en moins de 90 s, pour 3 graines.
3. **Nécessité** :
   - chapitres I et II : le robot d'évitement termine (le niveau n'exige pas de pousser) ;
   - niveaux avec `route` : le robot d'évitement échoue en 60 s (pousser est nécessaire) ;
   - niveaux avec veilleuse : le robot qui ignore les veilleuses échoue en 60 s (la vigilance est nécessaire).
4. **Regard hors écran** : un regard posé hors écran ne termine aucun niveau (R-23).
5. **Références** : calculées par `par.time = arrondi(1,8 × botTime + 6 s)` et `par.intrusions = ⌈botIntrusions⌉ + 2`. Le test vérifie `par.time ≥ botTime × 1,4` et `par.intrusions ≥ ⌈botIntrusions⌉ + 1`, pour qu'un éclat reste accessible à un humain au regard moins précis que le robot, et `par.time ≤ botTime × 3 + 10 s`, pour qu'il reste une maîtrise.
6. **Différence** : deux niveaux d'un même chapitre diffèrent sur au moins **deux** des critères du § 7.
7. **Maîtrise** : le dernier niveau d'un chapitre a l'estimation la plus élevée du chapitre.

## 7. Critères de différence entre deux niveaux

Deux niveaux d'un même chapitre sont considérés comme réellement différents s'ils diffèrent sur au moins **deux** de ces treize critères, calculés par `LevelAnalysis.signature` :

1. le nombre de lueurs ;
2. les types d'éléments présents ;
3. l'ordre (libre ou 1 → 2 → 3) ;
4. les tempéraments présents ;
5. le nombre de croisements de trajectoires ;
6. la pression de garde (iris exposés au trajet d'une autre lueur) ;
7. les compétences exigées (évitement, pousser contre, contourner, vigilance, anticiper) ;
8. la bande de temps du robot (< 6 s, 6–10 s, > 10 s) ;
9. le nombre d'instances par type (courants, voiles, veilleuses) ;
10. le détour : angle total de la trajectoire prévue (< 30°, 30–120°, > 120°) ;
11. la longueur du trajet le plus long, départ → voie → iris (< 1,0, 1,0–1,6, > 1,6 petit côté) ;
12. la présence d'un iris central (à moins de 0,15 petit côté du centre) ;
13. l'espace libre au départ (< 45 %, 45–65 %, > 65 %).

Un simple déplacement des points ne compte pas. Ce test a obligé trois refontes pendant la conception : le 2-2 (croisement qui traverse tout l'écran), le 4-2 (le col gardé par une seconde lueur) et le 6-4 (iris mouvant qui ne passe jamais au-delà du voile).

## 8. Structure retenue et justification de la longueur

La longueur découle de la matière disponible, pas d'un objectif de volume :

- **I Éveil (5)** : il y a quatre idées d'évitement (repousser, tenir, traverser, partager), plus les tempéraments. Une sixième serait une répétition de la traversée.
- **II Partage (5)** : ordre, croisement, garde, trois lueurs, puis la maîtrise. Au-delà, on ne ferait qu'ajouter du bruit de placement.
- **III Courants (6)**, **IV Voiles (6)**, **V Veilleuses (6)** : introduction seule, deux variations géométriques, une combinaison avec une idée des chapitres I et II (ordre ou tempérament), une combinaison avec l'élément du chapitre précédent, et la maîtrise.
- **VI Clairvoyance (6)** : deux niveaux pour l'iris mouvant (seul, puis ordonné), trois synthèses de deux éléments, et la finale.

Soit **34 niveaux**. Un joueur qui les termine a rencontré chaque combinaison autorisée d'au plus deux éléments au moins une fois. Une combinaison supplémentaire exigerait une nouvelle règle, donc un nouveau chapitre à justifier.

## 9. Niveaux

| ID | Titre | Lueurs | Ordre | Éléments | Famille | Intention |
|---|---|---|---|---|---|---|
| 1-1 | Premier regard | 1 | — | — | évitement | Tutoriel : regarder la lueur, la voir fuir, regarder ailleurs. |
| 1-2 | Tenir | 1 | — | — | évitement | L'iris est au centre : il faut regarder le haut ou le bas pendant la présence. |
| 1-3 | Traversée | 1 | — | — | traversée | La lueur parcourt toute la hauteur : la zone libre se déplace avec elle. Enseigne R-23 (rester sur l'écran). |
| 1-4 | Deux couloirs | 2 | libre | — | évitement | Deux lueurs en sens opposés : la zone libre est au milieu puis aux extrémités. |
| 1-5 | Tempéraments | 2 | libre | lourde, vive | évitement | La vive fuit au moindre regard, la lourde résiste. |
| 2-1 | Dans l'ordre | 2 | 1 → 2 | — | évitement | La lueur 2 arrive la première et doit attendre sans être validée. |
| 2-2 | Croisement | 2 | 1 → 2 | — | croisement | Les trajectoires traversent tout l'écran et se coupent au centre. |
| 2-3 | Garde | 2 | 1 → 2 | — | garde | L'iris 1 est au centre, la lueur 2 passe tout près : la protéger. |
| 2-4 | Trois | 3 | 1 → 2 → 3 | — | croisement | Première cascade possible sur trois rangs. |
| 2-5 | Partage | 3 | 1 → 2 → 3 | vive | synthèse | Maîtrise : croisements, garde et une lueur vive. |
| 3-1 | Le courant | 1 | — | courant | poussée | Un courant bloque la montée : pousser en regardant sous la lueur. |
| 3-2 | La brèche | 1 | — | courant | poussée | Le courant laisse un passage sur le côté : pousser latéralement vers la brèche. |
| 3-3 | Deux rives | 2 | 1 → 2 | courant | poussée | Un courant vertical sépare deux lueurs qui doivent traverser en sens opposés. |
| 3-4 | Contre-marée | 1 | — | 2 courants, vive | poussée | Deux courants successifs et une lueur vive, facile à pousser et à perdre. |
| 3-5 | Contre le courant | 2 | 1 → 2 | courant, lourde | poussée + garde | Une lueur lourde à pousser longtemps pendant qu'une autre attend. |
| 3-6 | Courants | 3 | 1 → 2 → 3 | 2 courants | synthèse | Maîtrise des poussées ordonnées. |
| 4-1 | Le voile | 1 | — | voile | contournement | La lueur bute au milieu du voile : la pousser vers son extrémité. |
| 4-2 | Le col | 2 | libre | 2 voiles | contournement + garde | Le passage n'est pas dans l'axe, et une seconde lueur se pose là où l'on doit regarder pour pousser. |
| 4-3 | Le coude | 1 | — | 2 voiles | contournement | Un voile en L : deux poussées successives. |
| 4-4 | Deux côtés | 2 | 1 → 2 | voile | contournement + garde | Pousser une lueur autour du voile sans chasser l'autre. |
| 4-5 | Voile et courant | 1 | — | voile, courant | synthèse | Le courant plaque la lueur contre le voile. |
| 4-6 | La chambre | 2 | 1 → 2 | 3 voiles | synthèse | Maîtrise : un iris enfermé dans une chambre ouverte d'un seul côté. |
| 5-1 | La veilleuse | 1 | — | veilleuse | vigilance | La flamme faiblit : la regarder avant que l'iris ne se ferme. |
| 5-2 | Près du feu | 2 | 1 → 2 | veilleuse | vigilance + garde | La flamme est au-dessus d'un iris : raviver sans chasser la lueur validée. |
| 5-3 | Deux flammes | 2 | 1 → 2 | 2 veilleuses | vigilance | Chaque flamme éclaire un iris : alterner. |
| 5-4 | Garde et flamme | 3 | 1 → 2 → 3 | veilleuse | vigilance + cascade | La flamme n'éclaire que l'iris 1 : si elle meurt, tout tombe. |
| 5-5 | Derrière le voile | 1 | — | veilleuse, voile | synthèse | Pousser autour d'un voile en gardant la flamme vivante. |
| 5-6 | Veilleuses | 3 | 1 → 2 → 3 | veilleuse, courant | synthèse | Maîtrise : une flamme exigeante et un courant. |
| 6-1 | Iris mouvant | 1 | — | iris mouvant | poursuite | L'iris glisse lentement : anticiper sans le fixer. |
| 6-2 | Marée | 2 | 1 → 2 | iris mouvant | poursuite + garde | Deux iris, un qui bouge, près l'un de l'autre. |
| 6-3 | Flamme et courant | 2 | 1 → 2 | courant, veilleuse | synthèse | Pousser contre le courant sans oublier la flamme. |
| 6-4 | Voile et marée | 1 | — | voile, iris mouvant | synthèse | L'iris glisse au-dessus du voile : contourner par la gauche sans jamais pouvoir le suivre en ligne droite. |
| 6-5 | Constellation | 3 | 1 → 2 → 3 | courant, voile, veilleuse | synthèse | Trois éléments, trois lueurs. |
| 6-6 | Iris | 3 | 1 → 2 → 3 | tout | synthèse | Finale. |

## 10. Mesures vérifiées

Mesures réelles (`LevelLabTests`, écran 393 × 852 pt, robot guidé bruité ± 24 pt, moyenne de 3 graines). « Évitement » et « sans veilleuse » : le niveau est-il terminé en 60 s par ces robots limités ? « Hors écran » : regard posé au-dessus du téléphone pendant 30 s.

| ID | Robot guidé | Temps (s) | Intrusions | Pertes | Évitement | Sans veilleuse | Hors écran | Espace libre | Croisements | Garde | Difficulté | Réf. temps | Réf. intrusions |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| 1-1 | 3/3 | 3.6 | 1.0 | 0.0 | oui | — | non | 0.64 | 0 | 0 | 1.72 | 12 | 3 |
| 1-2 | 3/3 | 3.3 | 0.0 | 0.0 | oui | — | non | 0.76 | 0 | 0 | 1.53 | 12 | 2 |
| 1-3 | 3/3 | 6.0 | 1.0 | 0.0 | oui | — | non | 0.70 | 0 | 0 | 1.76 | 17 | 3 |
| 1-4 | 3/3 | 4.9 | 2.0 | 0.0 | oui | — | non | 0.50 | 0 | 0 | 3.00 | 15 | 4 |
| 1-5 | 3/3 | 4.2 | 0.0 | 0.0 | oui | — | non | 0.48 | 0 | 2 | 3.99 | 14 | 2 |
| 2-1 | 3/3 | 5.3 | 0.0 | 0.0 | oui | — | non | 0.52 | 0 | 0 | 2.99 | 16 | 2 |
| 2-2 | 3/3 | 7.2 | 2.0 | 0.0 | oui | — | non | 0.67 | 1 | 0 | 3.45 | 19 | 4 |
| 2-3 | 3/3 | 4.2 | 0.0 | 0.0 | oui | — | non | 0.51 | 0 | 1 | 3.45 | 14 | 2 |
| 2-4 | 3/3 | 6.8 | 4.0 | 0.0 | oui | — | non | 0.41 | 1 | 2 | 5.82 | 18 | 6 |
| 2-5 | 3/3 | 6.2 | 3.0 | 0.0 | oui | — | non | 0.38 | 3 | 3 | 7.53 | 17 | 5 |
| 3-1 | 3/3 | 5.6 | 1.0 | 0.0 | non | — | non | 0.71 | 0 | 0 | 2.72 | 16 | 3 |
| 3-2 | 3/3 | 7.0 | 1.0 | 0.0 | non | — | non | 0.75 | 0 | 0 | 2.73 | 19 | 3 |
| 3-3 | 3/3 | 7.7 | 3.3 | 0.0 | non | — | non | 0.51 | 1 | 2 | 5.72 | 20 | 6 |
| 3-4 | 3/3 | 6.2 | 1.0 | 0.0 | non | — | non | 0.72 | 0 | 0 | 2.73 | 17 | 3 |
| 3-5 | 3/3 | 7.8 | 2.0 | 0.0 | non | — | non | 0.49 | 1 | 1 | 5.25 | 20 | 4 |
| 3-6 | 3/3 | 8.0 | 7.7 | 0.0 | non | — | non | 0.36 | 2 | 1 | 7.06 | 20 | 10 |
| 4-1 | 3/3 | 6.1 | 1.0 | 0.0 | non | — | non | 0.73 | 0 | 0 | 2.72 | 17 | 3 |
| 4-2 | 3/3 | 6.2 | 2.0 | 0.0 | non | — | non | 0.67 | 0 | 0 | 3.81 | 17 | 4 |
| 4-3 | 3/3 | 7.3 | 1.0 | 0.0 | non | — | non | 0.73 | 0 | 0 | 2.76 | 19 | 3 |
| 4-4 | 3/3 | 8.3 | 3.3 | 0.0 | non | — | non | 0.58 | 0 | 0 | 4.04 | 21 | 6 |
| 4-5 | 3/3 | 9.0 | 1.0 | 0.0 | non | — | non | 0.77 | 0 | 0 | 2.80 | 22 | 3 |
| 4-6 | 3/3 | 11.2 | 7.0 | 0.7 | non | — | non | 0.53 | 1 | 1 | 5.37 | 26 | 9 |
| 5-1 | 3/3 | 4.5 | 0.0 | 0.0 | non | non | non | 0.77 | 0 | 0 | 2.57 | 14 | 2 |
| 5-2 | 3/3 | 5.2 | 2.3 | 0.0 | non | non | non | 0.60 | 1 | 2 | 5.45 | 15 | 5 |
| 5-3 | 3/3 | 6.0 | 5.7 | 0.0 | non | non | non | 0.57 | 0 | 2 | 5.95 | 17 | 8 |
| 5-4 | 3/3 | 7.1 | 8.3 | 0.7 | non | non | non | 0.48 | 0 | 1 | 5.63 | 19 | 11 |
| 5-5 | 3/3 | 7.1 | 2.0 | 0.0 | non | non | non | 0.76 | 0 | 0 | 3.72 | 19 | 4 |
| 5-6 | 3/3 | 9.3 | 8.7 | 0.0 | non | non | non | 0.53 | 1 | 2 | 7.77 | 23 | 11 |
| 6-1 | 3/3 | 4.9 | 0.0 | 0.0 | oui | — | non | 0.77 | 0 | 0 | 2.39 | 15 | 2 |
| 6-2 | 3/3 | 4.9 | 0.0 | 0.0 | oui | — | non | 0.65 | 1 | 2 | 5.18 | 15 | 2 |
| 6-3 | 3/3 | 7.8 | 5.3 | 0.0 | non | non | non | 0.56 | 0 | 0 | 5.05 | 20 | 8 |
| 6-4 | 3/3 | 6.9 | 1.0 | 0.0 | non | — | non | 0.78 | 0 | 0 | 3.48 | 18 | 3 |
| 6-5 | 3/3 | 14.7 | 14.7 | 0.0 | non | non | non | 0.46 | 1 | 2 | 8.15 | 32 | 17 |
| 6-6 | 3/3 | 9.1 | 7.0 | 0.0 | non | non | non | 0.53 | 2 | 2 | 9.16 | 22 | 9 |

Lecture :

- Les chapitres I et II et les iris mouvants (6-1, 6-2) se jouent par évitement : le robot passif les termine.
- Tous les niveaux à voie échouent sans pousser. Tous les niveaux à veilleuse échouent sans regarder la flamme. Aucun niveau ne se termine hors écran.
- Le robot est bien plus précis et rapide qu'un humain : les temps réels d'un joueur seront de 2 à 5 fois plus longs. Les références en tiennent compte.
- 6-5 est le niveau le plus long pour le robot, mais 6-6 reste le plus difficile selon l'estimation (règle 8), grâce à ses deux croisements et à sa pression de garde.

## Partie B — extension provisoire (12 septembre 2026)

### 11. Dimensions de variation

Un niveau varie sur des dimensions ; un chapitre en explore une nouvelle. Les dimensions connues et candidates :

| Dimension | État | Portée |
|---|---|---|
| Espace du regard | implémentée (évitement, poussée) | où poser les yeux |
| Ordre et protection | implémentée | ordre, cascade, garde |
| Résistance au trajet | implémentée (courants, voiles) | pousser, viser |
| Obligation de regard | implémentée (veilleuses) | coups d'œil programmés |
| Mobilité du but | implémentée (iris mouvant) ; candidate (rendez-vous : le but fuit) | anticiper, converger |
| Tiers mobile | candidate (souffles) | protéger |
| Temps | candidate (phares) | attendre, retenir, relâcher |
| Dosage du regard sur la lueur | candidate (braises) | nourrir |
| Attention diffuse | réserve (nuée) | rassembler |
| Fixation imposée | réserve (ancres) | attention couverte |

### 12. Structure d'un chapitre

Entrée (1 niveau : l'élément seul, une lueur) → montée (2 à 3 : variations, puis combinaison avec un acquis) → respiration (1 : précision ≤ 1, stabilité 0, cascade ≤ 1 selon `DIFFICULTY_MODEL.md`) → finale (1 : la charge dominante du chapitre à son maximum). Un chapitre de respiration (rendez-vous, phares) a la même structure avec une amplitude réduite.

### 13. Règles à assouplir ou à préciser

| Règle actuelle | Évolution proposée | Pourquoi |
|---|---|---|
| Au plus 3 lueurs | maintenue pour les lueurs individuelles ; une nuée (réserve) compterait comme un groupe | la charge attentionnelle d'un groupe est inférieure à celle de trois lueurs ordonnées |
| Un seul élément nouveau par chapitre | maintenue ; un chapitre peut aussi introduire une **règle de validation** nouvelle (présence mutuelle, fenêtre) | rendez-vous et phares ne sont pas des objets de plus, ce sont des buts différents |
| Hors chapitre de synthèse, au plus deux types d'éléments | maintenue ; un souffle ou une braise compte comme un type | lisibilité |
| Nécessité prouvée pour tout chapitre | nécessité prouvée pour les chapitres de tension ; **différence prouvée** (le but se comporte autrement) pour les chapitres déclarés de respiration, avec nécessité sur au moins deux de leurs niveaux | un chapitre de respiration existe pour reposer, pas pour forcer |
| Un iris n'est jamais dans un courant | étendue : jamais dans le trajet permanent d'un souffle ; un phare n'est jamais dans un courant | sinon aucune présence n'est possible |
| Toute veilleuse est atteignable par le regard | étendue à toute cible de regard obligatoire, avec rayon ≥ 0,18 ou hystérésis (`PLAYER_COMFORT_CONSTRAINTS.md` § 3.1) | test humain |
| Le dernier niveau est le plus difficile (estimation) | maintenue comme contrôle automatique ; la conception utilise le profil de `DIFFICULTY_MODEL.md` | un nombre ne décrit pas une charge |

### 14. Éléments candidats : paramètres provisoires

À ne lire que comme des hypothèses de prototype. Aucune valeur n'est réglée.

| Élément | Paramètres | Plages provisoires | Preuve de nécessité (nouveau robot) |
|---|---|---|---|
| Souffle | trajet (segment aller-retour ou cercle), vitesse, rayon, force d'entraînement, sensibilité au regard | vitesse ≤ 0,06 largeur/s ; rayon 0,10 – 0,16 ; force ≥ attraction ; au plus 2 ; trajet visible en permanence | le robot qui ne dévie jamais le souffle échoue en 60 s ; le robot qui dévie réussit |
| Braise | charge initiale, rayon de charge, vitesse de chauffe, vitesse de refroidissement, seuil d'acceptation | rayon ≥ 0,20 ; chauffe 1 – 2 s ; refroidissement 6 – 10 s ; seuil 0,6 – 0,8 | le robot qui ne regarde jamais la braise échoue ; le robot qui alterne regarder / relâcher réussit ; dispersion des fuites mesurée |
| Phare | durée d'ouverture, durée de fermeture, phase initiale, rayon et force d'expiration | ouverture ≥ 1,5 s (viser 2,5 – 4) ; fermeture 3 – 8 s ; rayon d'expiration 0,25 – 0,40 ; force > attraction | le robot qui gare la lueur et attend échoue ; le robot qui retient puis relâche réussit |
| Jumelles (rendez-vous) | paire, distance de rendez-vous (= rayon de validation), tempéraments | comme les lueurs ; distance 16 pt à l'échelle 1 | différence : la trajectoire du but n'est pas celle d'un iris fixe ni d'un iris mouvant ; nécessité sur ≥ 2 niveaux du chapitre grâce aux voiles et courants |

### 15. Vérification des nouveaux types

La vérification actuelle (validité, faisabilité, nécessité, hors écran, références, différence, maîtrise) s'applique. Elle s'enrichit de :

- un **biais constant** de 71 pt (calibration acceptée de justesse) en plus du bruit de ± 24 pt, pour toute mécanique qui regarde une région ;
- une mesure de **lisibilité temporelle** pour les phares : la prochaine ouverture doit être prévisible 5 s à l'avance (paramètre, pas simulation) ;
- une mesure de **tolérance de trajet** pour les souffles : aucune validation ne doit pouvoir être perdue sans qu'une déviation ait été possible pendant ≥ 2 s ;
- une mesure de **dispersion** pour les braises : la fuite provoquée par un regard de charge ne doit jamais envoyer la lueur dans un voile ou un courant depuis le point de charge prévu.

### 16. Ce que la partie B ne dit pas

Elle ne décrit aucun niveau. Elle ne fixe aucune valeur. Elle ne remplace pas un prototype joué. Après le jugement des concepts par l'utilisateur, chaque chapitre approuvé sera d'abord prototypé sur deux niveaux, joué sur iPhone, puis seulement conçu en entier.
