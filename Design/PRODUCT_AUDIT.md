# Iris — audit du prototype

Date : 11 septembre 2026. Matériaux : `attention-indirecte.html`, application Swift (moteur porté, Gaze Engine v2), tests, captures simulateur.
Mesures reproductibles : géométrie des 14 niveaux recalculée avec le générateur d'origine sur un écran de 393 × 852 pt.

## 1. Mesures

| Niveau | Lueurs | Zone (pt) | Distance départ → arrivée (pt) | Écran libre au départ | Écran libre aux arrivées | Croisements |
|---|---|---|---|---|---|---|
| 1 | 1 | 352 | 156 | 27,0 % | 28,8 % | 0 |
| 2 | 1 | 352 | **21** | 24,4 % | 23,8 % | 0 |
| 3 | 1 | 352 | 114 | 24,4 % | 26,6 % | 0 |
| 4 | 2 | 304 | 239 · **49** | **1,1 %** | 27,4 % | 0 |
| 5 | 2 | 304 | 331 · 256 | **0,4 %** | 11,4 % | 0 |
| 6 | 2 | 304 | 446 · **37** | 6,5 % | 32,6 % | 0 |
| 7 | 2 | 304 | 474 · 252 | 24,1 % | 41,3 % | 0 |
| 8 | 2 | 304 | 389 · **31** | 15,9 % | 21,9 % | 0 |
| 9 | 3 | 240 | 232 · 314 · 124 | 26,0 % | 26,9 % | 1 |
| 10 | 3 | 240 | 194 · **36** · 412 | 18,4 % | 13,1 % | 0 |
| 11 | 3 | 240 | 85 · 322 · 228 | 6,5 % | 40,6 % | 1 |
| 12 | 3 | 240 | 115 · 226 · 191 | **35,6 %** | 45,4 % | 2 |
| 13 | 3 | 240 | 237 · 226 · 71 | 33,7 % | 17,4 % | 0 |
| 14 | 3 | 240 | 209 · 64 · 423 | 25,6 % | 7,6 % | 1 |

« Écran libre » : part des points de l'écran d'où le regard ne repousse aucune lueur.

## 2. Ce qui constitue l'identité d'Iris (à protéger)

1. **Le regard agit sur le monde** : une lueur dans la zone d'attention est repoussée avec une force proportionnelle à l'intrusion (R-02).
2. **L'action indirecte** : laissée tranquille, la lueur rejoint son but (R-01). Le joueur agit en *ne regardant pas*.
3. **La présence continue** : 0,75 s dans le cercle, remise à zéro en cas de sortie (R-08). Cela crée la tension de la dernière seconde.
4. **L'ordre et la cascade** (R-09, R-11) : l'attention doit se répartir et une erreur ancienne se paie.
5. **La douceur** : pas de chronomètre affiché, pas de vies, pas de défaite. La difficulté vient du contrôle de soi, pas d'une punition.
6. **La physique validée** : friction 0,94, plafond 2,2, rebonds amortis, bruit organique, équivalence temporelle exacte.

## 3. Ce qui fonctionne mais peut être amélioré

- Le moteur est exact (traces golden) et indépendant du framerate.
- Le Gaze Engine v2 fournit un diagnostic, une calibration et une validation. Son parcours est long (≈ 25 s) et reste présenté comme un écran technique.
- Le son est juste (crescendo, carillon, perte) mais il est pauvre : pas d'ambiance, pas de signature de fin de niveau.
- La cascade existe, mais aucun feedback ne montre *pourquoi* la lueur 3 a perdu sa place.

## 4. Ce qui est insuffisant

- **Aucune conception de niveau** : les 14 niveaux sont trois jeux de paramètres identiques (1-3, 4-8, 9-14) avec des positions tirées au hasard. Le niveau 2 se termine presque seul. Les niveaux 6, 8 et 10 contiennent une lueur à moins de 40 pt de son but.
- **Difficulté non maîtrisée** : le niveau 5 ne laisse que 0,4 % d'écran sans repousser une lueur, le niveau 12 en laisse 35,6 %. La courbe monte par le nombre de lueurs, puis oscille au hasard.
- **Zone d'attention non adaptée au téléphone** : 352 pt de rayon sur un écran de 393 pt de large. Le multiplicateur 1,6 compensait WebGazer sur un écran d'ordinateur.
- **Faille fondamentale** : regarder *hors* de l'écran (le plafond, ses mains) résout tous les niveaux. Le jeu récompense l'inattention au lieu de la maîtrise de l'attention.
- **Un seul verbe** : le regard ne sert qu'à gêner. Il ne devient jamais un outil. Après trois niveaux, la seule compétence est « trouver un coin vide ».
- **Aucune variété de situation** : pas d'obstacle, pas de contrainte spatiale, pas d'élément qui réclame de l'attention.
- **Onboarding textuel** : un écran de règles à lire, puis le jeu. Rien n'est appris en jouant.
- **Aucune progression persistante** : relancer l'app repart du niveau 1. Aucune sélection de niveau, aucune trace de maîtrise.
- **Aucune rejouabilité** : un niveau terminé n'a plus rien à offrir.
- **Joueur bloqué sans recours** : pas d'indice, pas de chemin montré.

## 5. Ce qui est hérité du prototype uniquement

- La **perspective** (horizon à 38 %, sol en fuite, échelle 0,55 → 1,2) : elle ment. La physique est plane, une lueur « au loin » est dessinée plus petite mais repousse et se valide exactement comme au premier plan.
- Les **anneaux de séquence à cinq couleurs arbitraires** (`SEQ_COLORS`) et les numéros de 11 pt.
- Les **textes de statut** (« mode : regard », « son : actif ») : ce sont des diagnostics de navigateur.
- Le **flash « niveau terminé »** puis l'enchaînement immédiat.
- Le **nombre 14** et la découpe 3 / 5 / 6.
- Le **générateur à graine** : il sert à la reproductibilité, pas à la conception.
- L'**écran de règles** et la calibration WebGazer à clics, déjà remplacée.

## 6. Ce qui manque pour un jeu complet

1. Des niveaux conçus un par un, qui enseignent puis exploitent.
2. Un deuxième usage du regard : **pousser** une lueur là où elle ne va pas seule.
3. Des éléments qui **demandent** l'attention au lieu de seulement la repousser.
4. Une règle qui garde les yeux **sur l'écran**.
5. Une structure en chapitres, une sélection de niveaux et une progression sauvegardée.
6. Des marques de maîtrise discrètes pour rejouer sans chronomètre visible.
7. Un apprentissage dans le jeu : consignes contextuelles déclenchées par ce que fait le joueur.
8. Une aide pour le joueur bloqué.
9. Une direction artistique propre, une ambiance sonore, une fin de parcours.
10. Un outil de vérification : chaque niveau doit être prouvé faisable, et chaque élément prouvé nécessaire.
