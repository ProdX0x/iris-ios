# Iris — invariants du noyau

Statut : les sections A et D sont autoritaires. Les sections B et C évoluent avec la conception approuvée.
Date : 12 septembre 2026, phase A de l'expansion (conception, sans implémentation).

Ce document répond à une seule question : **qu'est-ce qui fait qu'un niveau est un niveau d'Iris ?** Il sert de filtre à toute idée nouvelle, y compris celles de `GAME_EXPANSION_CONCEPTS.md`.

## A. Invariants absolus

| # | Invariant | Pourquoi c'est Iris |
|---|---|---|
| A1 | **Le regard est le seul verbe de jeu.** Le toucher navigue (intro, pause, résultat), il ne joue jamais. | Sans cela, Iris est un jeu tactile avec un gadget oculaire. |
| A2 | **Regarder repousse.** Toute chose regardée dans la zone d'attention s'éloigne du regard, avec une force proportionnelle à l'intrusion (R-02). **Aucun objet n'est attiré par le regard.** | La contradiction fondatrice : ce que vous regardez s'éloigne. Un objet attiré par le regard ferait du regard un curseur. |
| A3 | **L'action est indirecte.** Laissée tranquille, une lueur va vers son but (R-01). Le joueur agit d'abord en ne regardant pas, puis en regardant exprès à côté. | L'apprentissage d'Iris est une retenue qui devient un geste. |
| A4 | **La présence continue.** Trois quarts de seconde ininterrompus dans l'iris (R-08) ; sortir remet à zéro ; une lueur validée tolère 36 pt (R-10). Ce temps ne varie pas d'un niveau à l'autre. | La tension de la dernière seconde est la même partout ; le joueur l'apprend une fois pour toutes. |
| A5 | **L'attention reste sur l'écran** (R-23). Hors de l'écran, rien ne progresse et rien n'est perdu. | Iris récompense la maîtrise de l'attention, jamais l'inattention. |
| A6 | **L'ordre et la cascade** (R-09, R-11) sont des contraintes que l'on introduit et retire selon le niveau, jamais un décor permanent. | Elles donnent un prix à l'erreur ancienne sans jamais punir par une défaite. |
| A7 | **Calme exigeant.** Pas de chronomètre visible, pas de vies, pas de défaite, pas de score pendant le jeu. La maîtrise se mesure après coup (éclats). | La difficulté vient du contrôle de soi, pas d'une pression externe. |
| A8 | **Lisible au premier regard.** L'état du monde se lit sans texte : ce qui est validé, ce qui fuit, ce qui s'éteint, ce qui bouge. Rien de caché au joueur. | Le joueur ne peut pas lire un texte pendant qu'il joue avec ses yeux. |
| A9 | **Chaque niveau dit une chose et le prouve.** Il est faisable par un joueur simulé bruité, et son idée est démontrée nécessaire, ou sa différence démontrée quand son rôle est la respiration. | Aucun niveau de remplissage. |
| A10 | **La physique validée est le sol commun** : friction 0,94, plafond 2,2, rebonds amortis, bruit organique, équivalence temporelle, traces golden. Les éléments s'y ajoutent, ils ne la réécrivent pas. | Ce que le joueur a appris sur le mouvement d'une lueur reste vrai jusqu'à la fin. |
| A11 | **Confidentialité totale.** Aucune donnée de regard ni de visage ne quitte l'appareil ni n'est stockée. | Condition de confiance pour un jeu qui lit les yeux. |
| A12 | **Le joueur peut jouer sans son et sans vibration.** Ces retours confirment, ils n'informent jamais seuls. | Accessibilité et calme. |

### Tests d'appartenance

Une idée appartient à Iris si elle répond oui aux cinq questions :

1. Le regard reste-t-il le seul moyen d'agir, et regarder une chose l'éloigne-t-il toujours ?
2. Le joueur agit-il en choisissant où poser les yeux et où ne pas les poser ?
3. L'état créé par l'idée se voit-il sans texte, sans compteur, sans point de regard affiché ?
4. L'idée reste-t-elle jouable avec un regard imprécis de 18 % du petit côté et un téléphone tenu en main (`PLAYER_COMFORT_CONSTRAINTS.md`) ?
5. Peut-on prouver par simulation qu'un niveau bâti sur l'idée est faisable, et que l'idée y est nécessaire ou y change réellement la manière de regarder ?

## B. Paramètres variables

Ce qui change d'un niveau à l'autre, dans les plages du système de level design (`LEVEL_DESIGN_SYSTEM.md`) :

- la zone d'attention (0,40 – 0,52 du petit côté), la force de répulsion (1,6 – 3,2), l'attraction (0,4 – 0,6), le bruit ;
- le nombre de lueurs (1 à 3 aujourd'hui ; ce plafond est un choix de lisibilité, pas un invariant), leurs tempéraments, leurs départs, leurs iris, leur voie ;
- l'ordre (libre ou imposé) ;
- les éléments présents et leurs paramètres : courants, voiles, veilleuses, iris mouvants, et les éléments candidats une fois approuvés ;
- les consignes contextuelles, les références d'éclats, la nappe sonore du chapitre ;
- la longueur d'un chapitre (5 ou 6 aujourd'hui), le nombre de chapitres, leur ordre, leur découpage : rien de cela n'est sacré.

## C. Extensions compatibles

Familles d'idées qui approfondissent Iris sans le dénaturer (les candidates précises sont dans `GAME_EXPANSION_CONCEPTS.md`) :

| Famille | Condition de compatibilité | Exemples |
|---|---|---|
| Nouveaux objets soumis à la même loi | l'objet regardé s'éloigne ; il n'est jamais attiré | une brume qui dérive et que le regard détourne (« souffles ») |
| Nouvelles raisons de regarder quelque chose | regarder garde son coût (la chose fuit ou le reste est troublé) ; la cible de regard est large et sur l'écran | veilleuses (existant), lueurs à nourrir (« braises ») |
| Structures de temps lentes | aucune fenêtre courte, aucun réflexe ; le rythme se lit à l'avance | iris mouvants (existant), iris qui s'ouvrent et se ferment lentement (« phares ») |
| Contraintes spatiales sur les lueurs | le passage reste large et visible | courants, voiles (existant) |
| Buts mobiles ou mutuels | le but fuit aussi le regard ; il n'est jamais attiré | deux lueurs qui se rejoignent (« rendez-vous ») |
| Attention diffuse | la précision baisse quand le nombre monte | un petit groupe de lueurs et un iris commun (« nuée ») |
| Variations de réponse au regard | par tempérament, visible par la taille et la lumière | lourde, vive (existant), glissante |

## D. Extensions qui dénatureraient Iris

| Idée | Ce qu'elle casse |
|---|---|
| Joystick, glisser, toucher pour déplacer une lueur | A1 |
| Tirer, taper sur une lueur, tap pour valider | A1, A7 |
| Objet attiré par le regard, lueur « curieuse », regard qui tire ou porte | A2, A3 |
| Regard comme pointeur (viser une cible avec le point de regard, menu joué aux yeux) | A2, A8 |
| Clignement, sourcil, mouvement de tête, vitesse du regard comme commande | A1 (bruit physiologique transformé en verbe), confort |
| Point de regard visible pendant le jeu | A8 : l'œil suit le point qui suit l'œil |
| Fenêtres courtes, réflexes, chronomètre, vies, défaite, score en jeu | A7 |
| Précision extrême, cibles de regard minuscules ou aux bords | A4 par la bande, confort |
| Objets cachés, brouillard qui masque une lueur, règle invisible | A8 |
| Ennemis, combat, poursuite agressive, ton anxiogène | A7 (le calme) |
| Niveaux générés au hasard, mode infini, remplissage | A9 |
| Classements en ligne, données de regard exportées | A11 |
| Nouvelle physique qui contredit ce que le joueur a appris (lueur qui traverse un voile, iris dans un courant) | A10 |
