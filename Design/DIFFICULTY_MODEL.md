# Iris — modèle de difficulté

# STATUT : PROVISOIRE — À VALIDER PAR LE TEST HUMAIN DE LA NOUVELLE CAMPAGNE

Date : 12 septembre 2026. Ce modèle remplace, pour la conception, l'estimation à un seul nombre du système actuel (`LEVEL_DESIGN_SYSTEM.md` § 5.2). Cette formule reste utilisée par la vérification automatique de la règle « le dernier niveau d'un chapitre est le plus difficile », mais elle ne décide plus de rien : elle classe, elle ne décrit pas.

## 1. Principe

La difficulté d'un niveau d'Iris n'est pas un nombre. Deux niveaux de même « score » peuvent fatiguer des ressources différentes : tenir un angle de poussée pendant dix secondes n'a rien à voir avec surveiller trois lueurs validées. Un niveau a donc un **profil** sur douze axes, et un chapitre a une **séquence** de profils.

Règles d'usage :

- ne jamais additionner les axes pour décider ;
- nommer la **charge dominante** d'un niveau (un ou deux axes) ; c'est elle qui donne son sens au niveau ;
- juger la **séquence** (fatigue cumulée) autant que le niveau ;
- les valeurs marquées *humain* ne peuvent être estimées qu'en jouant.

## 2. Les douze axes

Échelle 0 – 3 sur chaque axe. « Mesure » indique d'où vient la valeur : *calculée* (`LevelAnalysis`, aujourd'hui), *à calculer* (phase B), *estimée* (par le concepteur), *humain* (test réel).

| Axe | 0 | 1 | 2 | 3 | Mesure |
|---|---|---|---|---|---|
| **Charge attentionnelle** : nombre de choses à surveiller en même temps (lueurs en mouvement, lueurs validées à protéger, éléments qui réclament un regard) | 1 chose | 2 | 3 | 4 ou plus | calculée (lueurs) + estimée (éléments) |
| **Précision** : finesse de la position de regard requise | aucune (évitement large) | angle large (≥ 60°) | angle moyen (40 – 60°) ou brèche étroite | angle serré (< 40°) ou cible de regard < 0,18 — **interdit** | à calculer (largeur des passages, rayons) |
| **Stabilité** : temps pendant lequel le regard doit rester dans une région | aucun | < 1 s | 1 – 3 s | > 3 s — **interdit** | à calculer |
| **Nombre de cibles** : lueurs à valider | 1 | 2 | 3 | 4 ou plus (nuée : voir § 5) | calculée |
| **Risque de cascade** : ordre imposé × rangs validés exposés au trajet des autres | libre ou 1 lueur | ordre, aucun iris exposé | 1 iris exposé | 2 iris ou plus exposés | calculée (`guardPressure`) |
| **Occupation spatiale** : part de l'écran déjà « prise » par les zones d'attention au départ | espace libre > 65 % | 45 – 65 % | 30 – 45 % | < 30 % | calculée (`freeArea`) |
| **Force de répulsion ressentie** : `force / zone` et tempéraments | lourde ou zone large | normale | force 2,6 | vive ou force > 2,8 | calculée |
| **Durée** : temps du robot guidé | < 5 s | 5 – 8 s | 8 – 12 s | > 12 s | calculée (`botTime`) |
| **Complexité de séquence** : nombre d'étapes distinctes du plan (poussées, alternances, attentes) | 0 (laisser venir) | 1 | 2 | 3 ou plus | calculée (points de voie) + estimée |
| **Nouveauté cognitive** : ce que le niveau demande d'apprendre | rien de nouveau | combinaison connue dans une géométrie neuve | combinaison jamais vue | élément nouveau | estimée |
| **Fatigue probable** : dérivée de précision, stabilité, durée et charge, pondérée par la position dans la séquence | repos | légère | marquée | forte | estimée puis *humain* |
| **Tolérance aux micro-mouvements** : sensibilité du niveau à un regard qui tremble de 39 pt | insensible | tolérant | sensible sur une phase courte | sensible en permanence — **interdit** | estimée puis *humain* |

Les valeurs 3 marquées « interdit » sont des garde-fous issus de `PLAYER_COMFORT_CONSTRAINTS.md`.

## 3. Profils des chapitres actuels

Valeurs calculées quand elles existent (`LEVEL_DESIGN_SYSTEM.md` § 10), estimées sinon. Le profil d'un chapitre est celui de son niveau de maîtrise, avec la charge dominante du chapitre.

| Chapitre | Charge dominante | Attention | Précision | Stabilité | Cibles | Cascade | Occupation | Force | Durée | Séquence | Nouveauté | Fatigue | Micro-mvt |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| I Éveil | retenue | 1 | 0 | 0 | 1 | 0 | 1 | 1 | 0 | 0 | 3 | 0 | 0 |
| II Partage | surveillance | 2 | 0 | 0 | 2 | 3 | 2 | 2 | 1 | 1 | 3 | 1 | 0 |
| III Courants | précision d'axe | 2 | 1 | 1 | 2 | 1 | 2 | 2 | 1 | 1 | 3 | 2 | 1 |
| IV Voiles | précision d'angle | 1 | 2 | 1 | 1 | 1 | 1 | 2 | 2 | 2 | 3 | 2 | 1 |
| V Veilleuses | saccades obligatoires | 3 | 2 | 1 | 2 | 2 | 1 | 2 | 2 | 2 | 3 | 3 | 2 |
| VI Clairvoyance | tout à la fois | 3 | 2 | 1 | 2 | 3 | 1 | 2 | 2 | 3 | 2 | 3 | 2 |

Lecture :

- la précision monte de III à V et ne redescend plus ; la fatigue est marquée ou forte sur les quatre derniers chapitres : la séquence manque de respiration ;
- la nouveauté est constante (un élément par chapitre), ce qui est bien, mais elle tombe à 2 en VI, dont l'élément propre (iris mouvant) n'est pas nécessaire (les robots passifs réussissent 6-1 et 6-2) ;
- le risque de cascade atteint 3 dès le chapitre II, puis oscille : il n'est pas une progression, c'est un ingrédient ;
- aucun chapitre n'a une charge dominante « temps » ni « attention diffuse » : ce sont deux directions libres.

## 4. Profils par niveau : ce que la séquence révèle

Charge dominante et fatigue estimée des 34 niveaux (les mesures sont dans `LEVEL_DESIGN_SYSTEM.md` § 10).

| Chapitre | Séquence des charges dominantes | Séquence des fatigues | Remarque |
|---|---|---|---|
| I | retenue, retenue, retenue mobile, partage libre, tempéraments | 0 0 0 1 1 | 1-2 (« tenir ») est estimé plus facile que 1-1 : espace libre 76 %, robot 3,3 s ; il n'ajoute pas de compétence. |
| II | ordre, croisement, garde, trois, synthèse | 1 1 1 2 2 | montée régulière ; pas de respiration, mais la fatigue reste basse. |
| III | poussée, poussée latérale, deux rives, vive, lourde, synthèse | 1 1 2 2 2 2 | 3-1, 3-2 et 3-4 ont le même profil (une lueur, 2,7) : trois découvertes consécutives ; 3-4 n'est une respiration que par le nombre de lueurs, pas par la précision. |
| IV | contournement, col, coude, deux côtés, courant, chambre | 2 2 2 2 2 3 | six niveaux de précision d'angle sans respiration : c'est le segment le plus fatigant après V. |
| V | vigilance, garde, alternance, cascade, voile, synthèse | 2 2 3 3 2 3 | 5-3 et 5-4 enchaînent deux charges 3 ; 5-4 et 4-6 sont les seuls niveaux où le robot perd des validations. |
| VI | anticipation, anticipation, synthèse, synthèse, constellation, finale | 1 1 2 2 3 3 | 6-1 et 6-2 sont la seule vraie respiration de la seconde moitié, par accident (évitement suffit) ; 6-5 est le niveau le plus long et le plus intrusif (14,7 s, 14,7 intrusions). |

## 5. Extension du modèle aux concepts candidats

Le modèle doit pouvoir décrire les quatre finalistes sans être forcé. Ce qu'il faudra ajouter ou préciser en phase B :

| Concept | Axe existant sollicité | Ce qui manque au modèle |
|---|---|---|
| Souffles (brume que le regard détourne) | charge attentionnelle (un objet de plus), cascade (une lueur validée peut être délogée) | un axe **imprévisibilité** : 0 trajet rectiligne visible, 1 rebond sur voile, 2 deux souffles. Une valeur 3 (trajet aléatoire) serait interdite (A8). |
| Braises (lueur qui doit être regardée pour être acceptée) | précision (rayon de charge), séquence (regarder, relâcher, regarder) | un axe **rythme** : nombre de cycles regarder / relâcher nécessaires (1, 2, 3 +). |
| Rendez-vous (deux lueurs se rejoignent) | cibles (2 lueurs, 1 validation), occupation (deux zones qui se rapprochent) | la notion de **but mobile qui fuit** : la précision doit être calculée sur la position relative, pas sur un iris fixe. |
| Phares (iris qui s'ouvre et se ferme lentement) | stabilité (tenir une lueur près d'un iris fermé), séquence (attendre puis relâcher) | un axe **fenêtre** : durée d'ouverture (≥ 4 s : 0, 2,5 – 4 s : 1, 1,5 – 2,5 s : 2, < 1,5 s : interdit). |
| Nuée (réserve) | nombre de cibles > 3 | l'axe « cibles » doit distinguer 3 lueurs individuelles de 8 lueurs collectives : la charge attentionnelle d'une nuée est **inférieure** à celle de trois lueurs ordonnées. |

## 6. Garde-fous de séquence

- Deux niveaux consécutifs ne portent pas la même charge dominante au même niveau de fatigue, sauf en découverte puis consolidation (fatigue ≤ 1).
- Après deux niveaux de fatigue ≥ 2, le suivant est une respiration : précision ≤ 1, stabilité 0, cascade ≤ 1.
- Le niveau de maîtrise d'un chapitre a la charge dominante du chapitre, pas la somme de toutes les charges.
- La nouveauté cognitive 3 (élément nouveau) n'apparaît qu'une fois par chapitre, au premier niveau, avec une seule lueur.
- Aucune valeur « interdit » nulle part.

## 7. Ce que ce modèle ne sait pas

- Le plaisir : un niveau bien profilé peut être ennuyeux.
- La fatigue réelle : les valeurs de l'axe « fatigue probable » sont des hypothèses jusqu'au test humain de chaque nouveau chapitre.
- La difficulté ressentie avec une calibration à 17 % : le robot actuel simule ± 24 pt, pas un biais constant de 67 pt.
- L'effet d'apprentissage : un joueur qui a fini IV ne voit plus IV-1 comme au premier jour ; les profils décrivent un premier parcours.
