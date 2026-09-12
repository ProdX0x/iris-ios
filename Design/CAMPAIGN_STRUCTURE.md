# Iris — structure de campagne proposée

Statut : proposition à juger. Rien de ce document n'est implémenté ; les six chapitres actuels restent inchangés dans le code.
Date : 12 septembre 2026, phase A.

## 1. Point de départ : les six chapitres existants

| Chapitre | Niveaux | Ce que le joueur sait faire après, qu'il ne savait pas avant | Charge dominante | Fatigue |
|---|---|---|---|---|
| I Éveil | 5 | ne pas regarder ce qu'il veut voir arriver ; garder les yeux sur l'écran ; tenir 0,75 s ; connaître la lourde et la vive | retenue | 0 – 1 |
| II Partage | 5 | ordonner ; anticiper un croisement ; protéger un acquis ; subir et comprendre une cascade | surveillance | 1 – 2 |
| III Courants | 6 | pousser dans l'axe en regardant « derrière » la lueur | précision d'axe | 2 |
| IV Voiles | 6 | pousser sous un angle ; planifier deux poussées ; utiliser un mur | précision d'angle | 2 – 3 |
| V Veilleuses | 6 | programmer des coups d'œil ; garder quelque chose vivant en guidant | saccades obligatoires | 2 – 3 |
| VI Clairvoyance | 6 | anticiper une zone mobile ; lire un niveau avant de jouer | tout à la fois | 1 – 3 |

Trois constats de l'audit (`GAME_DESIGN.md` § 3) :

1. III et IV enseignent le même verbe (pousser) sous deux géométries : douze niveaux de poussée d'affilée.
2. Après II, aucun chapitre ne baisse la charge : quatre chapitres exigeants consécutifs, contraire à `PLAYER_COMFORT_CONSTRAINTS.md` § 3.4.
3. L'élément propre de VI (iris mouvant) est facultatif : 6-1 et 6-2 se jouent par évitement. VI vaut par ses synthèses, pas par son élément.

## 2. Ordre proposé : dix chapitres

| # | Chapitre | Statut | Niveaux | Rôle dans la courbe | Charge dominante | Fatigue visée |
|---|---|---|---|---|---|---|
| I | Éveil | existant | 5 | apprentissage | retenue | 0 – 1 |
| II | Partage | existant, finale à revoir (§ 6) | 5 | consolidation, première tension | surveillance | 1 – 2 |
| III | Courants | existant | 6 | nouveauté : le regard pousse | précision d'axe | 2 |
| IV | Voiles | existant | 6 | précision | précision d'angle | 2 – 3 |
| V | **Rendez-vous** | finaliste | 5 | **respiration** : pas d'iris, pas de cascade, deux lumières qui se rejoignent | convergence | 1 |
| VI | Veilleuses | existant | 6 | nouveauté : regarder sans troubler | saccades | 2 – 3 |
| VII | **Souffles** | finaliste | 6 | tension : le regard protège | garde active | 3 |
| VIII | **Phares** | finaliste | 5 | **respiration** : le temps, la patience | anticipation temporelle | 1 – 2 |
| IX | **Braises** | finaliste | 6 | renversement : regarder pour nourrir | dosage du regard | 2 |
| X | Clairvoyance | existant, à étendre | 7 – 8 | expertise : tout combiné, dont les nouveaux éléments | lecture du niveau | 3, avec une respiration interne |

Total : 34 niveaux existants + 22 nouveaux + 1 ou 2 synthèses ajoutées à X, soit **57 à 58 niveaux**. Durée estimée d'un premier parcours humain : 2 h 30 à 4 h, en sessions de 10 à 15 min (un chapitre par session).

### Pourquoi cet ordre

- **Rendez-vous en V**, entre les douze niveaux de poussée et les veilleuses : c'est la respiration qui manque, et ses situations réutilisent doucement ce que III et IV ont appris (pousser l'une des jumelles autour d'un voile) sans exiger de précision.
- **Souffles en VII**, après les veilleuses : le joueur sait déjà surveiller une flamme ; la brume qui éteint la flamme (situation 3) relie les deux chapitres, et la garde active arrive quand la garde passive est acquise.
- **Phares en VIII** : après la charge la plus forte (VII), une respiration temporelle où l'on attend, retient et relâche.
- **Braises en IX** : le renversement doit venir tard, quand le réflexe « ne jamais regarder la lueur » est profondément acquis. Il prépare X.
- **Clairvoyance en X** : sa fonction (tout lire, tout combiner) ne change pas ; sa matière s'agrandit. 6-1 et 6-2 (iris mouvant seul) peuvent rester son entrée, ou l'iris mouvant peut être promu élément de VIII (un phare qui glisse) : à décider en phase B.

### Courbe résultante

```
apprentissage (I) → consolidation (II) → tension (III) → précision (IV) → respiration (V)
→ nouveauté (VI) → tension maximale (VII) → respiration (VIII) → renversement (IX) → expertise (X)
```

Elle suit la respiration demandée : jamais trois chapitres exigeants d'affilée ; deux respirations placées après les deux blocs les plus fatigants.

## 3. Structure interne d'un chapitre

Chaque chapitre, existant ou nouveau, suit quatre temps :

| Temps | Niveaux | Définition |
|---|---|---|
| Entrée | 1 | l'élément seul, une lueur, consignes contextuelles |
| Montée | 2 – 3 | variations géométriques, puis combinaison avec un acquis (ordre, tempérament, élément précédent) |
| Respiration | 1 | précision ≤ 1, stabilité 0, cascade ≤ 1 ; une lueur ou un but large ; le joueur regarde le chapitre d'un peu plus loin |
| Finale | 1 | maîtrise : la charge dominante du chapitre à son maximum, pas la somme de tout |

Écarts des chapitres existants à cette structure, à corriger en phase B sans changer leur matière :

- III : la respiration de fait (3-4, une lueur vive) est un défi de précision, pas une respiration ; 3-1, 3-2 et 3-4 ont le même profil.
- IV : aucune respiration ; 4-3 (le coude, une lueur) pourrait le devenir avec un passage plus large.
- V : 5-3 et 5-4 enchaînent deux charges 3 ; 5-5 (une lueur, voile et flamme) est la respiration naturelle mais arrive après.
- VI : 6-4 (une lueur) est la respiration ; 6-5 est plus long et plus intrusif que la finale 6-6.

## 4. Découpage par finaliste (esquisse, pas de niveaux conçus)

### V Rendez-vous (5)

1. Jumelles : deux lueurs, aucun élément. Entrée.
2. Le voile entre elles. Montée.
3. Une vive et une lourde. Montée.
4. Dans le courant : les jumelles dérivent toutes deux ; se rejoindre en mouvement. Respiration mobile.
5. Trois : trois lueurs qui se retrouvent ensemble. Finale.

Preuve demandée : la **différence** (le but fuit et bouge), la faisabilité, l'absence de solution hors écran. La nécessité est portée par les niveaux 2, 3 et 5.

### VII Souffles (6)

1. Premier souffle : une lueur posée, une brume qui repasse. Entrée.
2. Escorte : dévier ou faire attendre. Montée.
3. Souffle et flamme. Montée.
4. Rebond sur un voile. Montée.
5. Souffle circulaire lent, une lueur lourde. Respiration.
6. Deux souffles, trois lueurs dans l'ordre. Finale.

Preuve demandée : nécessité (le robot qui ne dévie jamais échoue), faisabilité avec ± 24 pt, lenteur ≤ 0,06 largeur/s, trajet visible, au plus deux souffles.

### VIII Phares (5)

1. Premier phare : retenir, relâcher. Entrée.
2. Deux phares décalés, dans l'ordre. Montée.
3. Phare et courant. Montée.
4. Phare lent, lueur lourde. Respiration.
5. Trois lueurs, deux phares, un iris fixe. Finale.

Preuve demandée : nécessité (le robot qui gare et attend échoue), fenêtre ≥ 1,5 s, rythme lisible ≥ 5 s à l'avance. **Prototype de l'expiration obligatoire avant le premier niveau.**

### IX Braises (6)

1. Première braise. Entrée.
2. Deux feux : braise et lueur normale, dans l'ordre. Montée.
3. Braise et courant : nourrir et pousser d'un seul regard. Montée.
4. Braise derrière un voile. Montée.
5. Une braise lourde, lente à réchauffer, rien d'autre. Respiration.
6. Deux braises de tempéraments différents. Finale.

Preuve demandée : nécessité (le robot qui ne regarde jamais la braise échoue), rayon de charge ≥ 0,20, lumière lisible, absence de projection chaotique (le robot mesure la dispersion des fuites).

## 5. Si un finaliste est rejeté par l'utilisateur

| Rejeté | Remplacement proposé | Conséquence sur l'ordre |
|---|---|---|
| Rendez-vous | Nuée (interlude de 3 niveaux) au même emplacement | la respiration reste ; la scène poétique disparaît |
| Souffles | Ancres (mini-séquence de 2 niveaux) intégrée à X | la campagne perd son chapitre de garde active ; huit chapitres et deux niveaux de plus |
| Phares | Nuée ou rien | sans respiration après VII, insérer la respiration à l'intérieur de VII et de IX (deux niveaux chacun) |
| Braises | Ancres en chapitre court (4) malgré ses risques, ou rien | la campagne n'a plus de renversement ; X vient directement après VIII |

Une campagne de huit chapitres (deux finalistes seulement) reste cohérente si les deux retenus sont un chapitre de tension et un chapitre de respiration.

## 6. Les deux premiers chapitres et le futur modèle commercial

Hypothèse commerciale (contexte, pas de StoreKit ici) : I et II gratuits, le reste débloqué par un achat unique.

### Ce que I et II montrent aujourd'hui

- Ils apprennent le noyau : retenue, écran, présence, ordre, cascade, tempéraments. Un joueur qui les termine comprend Iris.
- Ils montrent l'originalité de la contradiction (« elle fuit mon regard ») dès la première minute.
- Ils **ne montrent pas** le retournement : le regard n'y est jamais un outil. Le joueur gratuit ne voit que le côté gênant du regard ; la découverte que « votre regard pousse aussi » (III-1) est le meilleur moment du jeu et il est derrière l'achat.
- Ils ne contiennent aucune scène de beauté (rendez-vous, veilleuse) : l'émotion arrive plus tard.
- La frustration précoce est faible (fatigue 0 à 2, aucune poussée) ; c'est bien.
- 1-2 « tenir » apporte peu : plus facile que 1-1, sans compétence nouvelle.

### Ajustements conceptuels proposés (aucun code)

1. **Une finale de II qui annonce III** : remplacer ou compléter 2-5 par un niveau où un courant faible existe, contournable par évitement mais franchissable plus vite en poussant, avec la consigne tardive « Votre regard pousse aussi ». La règle « un élément par chapitre » est respectée si le courant y est un décor facultatif, prouvé non nécessaire. Cela donne au joueur gratuit un aperçu du verbe qu'il achète.
2. **Remplacer 1-2** par un niveau qui montre la physique de la fuite plus clairement (une lueur qui longe un bord sous un regard placé exprès), ou fusionner « tenir » dans 1-1 et donner à I une vraie respiration.
3. **Accord (C10) en variation de II** : un niveau où deux iris ne se ferment qu'ensemble, pour que la partie gratuite contienne un moment de maîtrise mémorable.
4. **Ne pas** déplacer un chapitre nouveau dans la partie gratuite : la promesse de I et II est l'apprentissage, pas l'exhaustivité.

Décision humaine requise sur 1 et 2 ; 3 est facultatif.

## 7. Ce que cette structure ne décide pas

- Le sort de l'iris mouvant (élément de X ou de VIII).
- La longueur exacte de X (7 ou 8), et quelles synthèses avec les nouveaux éléments.
- L'ordre relatif de Braises et de Phares : Phares en respiration avant Braises est proposé ; l'inverse (renversement puis respiration) est défendable.
- Les noms définitifs des chapitres ; les noms des finalistes sont provisoires.
- Les tonalités des nappes sonores des nouveaux chapitres.
