# Iris — expansion oculomotrice : un niveau final par chapitre II à XII

Branche `feature/iris-oculomotor-expansion`, depuis le tag `iris-ch1-oculomotor-human-validated-v1` (`c452c01`).

Statut : **TECHNIQUEMENT VALIDÉ / À JOUER HUMAINEMENT**. Aucun des onze niveaux n'a été joué par un humain.

## Principe

Chaque chapitre II à XII reçoit un niveau final optionnel, ajouté après ses niveaux validés, sans en renuméroter aucun. Le niveau s'ouvre sur une ou plusieurs étapes « gaze-contingent » : le regard est l'interaction, le motif oculaire est la conséquence d'une règle de jeu, jamais une consigne de direction. Quand l'étape est réussie, les lueurs du niveau apparaissent et le niveau se termine avec les règles du chapitre. Un niveau optionnel ne bloque jamais le chapitre suivant.

Les termes scientifiques ci-dessous servent à la conception et aux tests. Ils ne sont jamais montrés au joueur. Aucun niveau ne mesure ni n'entraîne cliniquement quoi que ce soit : le moteur fournit un point de regard 2D, une pose de tête et la géométrie ARKit, rien de plus (ni vergence, ni accommodation, ni acuité).

## Les onze niveaux

| Niveau | Nom | Paradigme | Principe de jeu | Ablation |
|---|---|---|---|---|
| 2-6 | le cœur de verre | fixation stable, inhibition des distracteurs | un cœur froid se réchauffe sous un regard qui reste ; des étincelles surgissent autour et refroidissent le cœur si le regard les suit | quitter le cœur par intermittence, chasser les étincelles, attendre, regard aléatoire : jamais |
| 3-7 | le fil vivant | poursuite lisse | une étincelle file sans s'arrêter sur une boucle lisse ; son fil reste vivant tant que le regard l'accompagne et s'effiloche sinon | centre, coin, point fixe sur la boucle, regard aléatoire : jamais ; perdre puis rattraper : gagne |
| 4-7 | le miroir menteur | anti-saccade | un éclat brille d'un côté, la porte s'ouvre du côté opposé ; suivre l'éclat referme la porte et le cycle recommence | suivre l'éclat, centre, regard aléatoire : jamais |
| 5-7 | les étoiles absentes | saccades guidées par la mémoire | des étoiles brillent un instant puis s'effacent ; elles reviennent là où le regard retourne ; la constellation grandit | regard fixe, regard aléatoire : jamais ; mauvais endroit : une erreur sans pénalité |
| 6-7 | le jardin caché | recherche visuelle, exploration systématique | parmi douze graines qui scintillent, deux respirent ; les regarder les fait pousser ; s'attarder sur une autre replie les pousses du lot | centre, coin, regard aléatoire, balayage lent : jamais ; balayage bref de tout le jardin : gagne (c'est le motif d'exploration) |
| 7-7 | la danse croisée | saccades diagonales d'amplitude variable | les jumelles s'appellent d'un coin à l'autre, près, puis loin, sur une diagonale puis l'autre, et finissent par se rejoindre | un seul quadrant, centre, alternance gauche-droite, regard aléatoire : jamais |
| 8-7 | la lanterne du courant | poursuite prédictive, anticipation | un courant porte une lanterne en boucle ; dès le deuxième tour elle disparaît dans la brume ; il faut être là où elle ressort | joueur réactif (0,35 s de retard, figé dans la brume), attente à une sortie, centre, regard aléatoire : jamais |
| 9-7 | l'absence | désengagement de la fixation (gap / overlap) | une présence tient tant qu'on la regarde ; une réponse apparaît ailleurs, parfois après un silence, parfois pendant que la présence brille encore ; il faut la rejoindre | ne jamais quitter la présence, partir trop tôt, centre, regard aléatoire : jamais |
| 10-7 | l'ancre | stabilisation du regard, inspirée du VOR | les yeux restent sur une ancre ; de petits mouvements de tête poussent une boussole jusqu'à l'arc désigné | regard seul, tête seule, tête toujours du même côté, pas de données de tête, regard aléatoire : jamais |
| 11-7 | d'abord les yeux | coordination œil-tête, saccade avant la tête | des braises s'allument au bord ; les yeux d'abord puis la tête donnent toute la chaleur, la tête d'abord la moitié, les yeux seuls un tiers | regard qui n'atteint pas les braises, tête sans les yeux, regard aléatoire : jamais ; la coordination est distinguée (4, 8 ou 12 braises) |
| 12-7 | l'orchestre du regard | synthèse multimodale | sept passages courts (fixation, transfert, poursuite, recherche, mémoire, diagonales, œil-tête), chacun allume une étoile ; la constellation s'anime à la fin | centre, coin, regard aléatoire : jamais |

Les pars suivent la formule historique (`temps = arrondi(1,8 × bot + 6)`, `intrusions = plafond(bot) + 2`).

| Niveau | bot guidé (3 graines) | temps moyen | intrusions | par |
|---|---|---|---|---|
| 2-6 | 3/3 | 10,3 s | 2,0 | 25 s / 4 |
| 3-7 | 3/3 | 11,8 s | 0,0 | 27 s / 2 |
| 4-7 | 3/3 | 16,4 s | 1,0 | 36 s / 3 |
| 5-7 | 3/3 | 15,6 s | 1,0 | 34 s / 3 |
| 6-7 | 3/3 | 8,5 s | 0,0 | 21 s / 2 |
| 7-7 | 3/3 | 9,9 s | 2,0 | 24 s / 4 |
| 8-7 | 3/3 | 23,6 s | 1,0 | 48 s / 3 |
| 9-7 | 3/3 | 17,0 s | 9,3 | 37 s / 12 |
| 10-7 | 3/3 | 10,4 s | 1,0 | 25 s / 3 |
| 11-7 | 3/3 | 9,1 s | 1,0 | 22 s / 3 |
| 12-7 | 3/3 | 26,7 s | 2,0 | 54 s / 4 |

## Mécanisme partagé

Un niveau final porte une `OculoDefinition` : une suite d'étapes, chacune une petite machine déterministe (`GameEngine/Oculo/*StageState.swift`). `OculoSequenceState` les joue dans l'ordre, chacune sur sa propre horloge, avec une respiration entre elles ; tant que la suite n'est pas complète, les lueurs du niveau restent latentes (invisibles, immobiles, iris fermés). Les étapes reçoivent le curseur de regard lissé du moteur, son activité et la pose de tête issue de l'observation ARKit déjà existante ; elles émettent réussite, erreur et achèvement, qui réutilisent la pulsation douce et le signal de validation existants. Chaque étape expose aussi un « oracle » (regard, tête) utilisé seulement par le joueur simulé. La scène est décrite par rôles (`OculoSnapshot`) et dessinée dans la palette du chapitre (`GameSceneRenderer+Oculo`).

Les chapitres jouables sont `Campaign.baseChapters` (la campagne validée : chapitre I avec son niveau 6, II à VI gelés, VII à XII) plus au plus un niveau final optionnel chacun. Un niveau optionnel ne retient jamais le chapitre suivant.

## Protection

| Invariant | Protection |
|---|---|
| Chapitres I à VI (34 niveaux historiques) | empreinte `historical_campaign.txt` inchangée, SHA-256 des sources inchangés |
| Chapitres VII à XII et niveau 1-6 (validés humainement) | nouvelle empreinte octet pour octet `expansion_campaign.txt` ; leurs sources rejoignent les SHA-256 gelés |
| Structure jouée | chaque chapitre joué commence par ses niveaux validés, dans l'ordre ; au plus un niveau ajouté, toujours optionnel |
| Gaze Engine, calibration, filtrage, seuils, projection, cycle de vie | aucun fichier `AR/` modifié dans cette mission ; SHA-256 gelés |
| Avertissement de décrochage (« visage perdu », R-23) | code intact ; tests de non-régression existants verts |
| Audio, haptique | aucun nouveau son ni nouvelle pulsation ; Effets ON / Ambiance OFF par défaut inchangés |

## Instrumentation (DEBUG)

`OculomotorTrace` (créé pour le niveau 1-6) suit aussi les nouveaux niveaux : états VALID_INSIDE / VALID_OUTSIDE / INVALID, sorties de viewport sans position inventée, pose de tête, et pour chaque étape ses réussites, erreurs et achèvement avec l'état du regard et yaw / pitch au moment. Les états internes des étapes gardent les mesures propres à chaque paradigme : temps de repos et coût des distracteurs (II), pertes et reprises (III), leurres suivis et délais dépassés (IV), erreurs et répétitions (V), graines visitées et replis (VI), échanges par amplitude (VII), prises et fuites par brume (VIII), temps de transfert (IX), glissements et direction apprise par axe (X), chaleur par coordination (XI). Lecture : `log stream --predicate 'subsystem == "net.steve-s.iris" AND category == "oculotest"'`. Rien n'est affiché au joueur ni compilé en Release.

## Ce que le moteur ne mesure pas

Un point de regard 2D calibré, une pose de tête et la géométrie oculaire ARKit. Ni vergence, ni accommodation, ni acuité, ni latence clinique d'une saccade. Les délais et amplitudes des étapes sont des paramètres de jeu.

## À juger humainement

- **2-6 le cœur de verre** : l'envie de suivre les étincelles est-elle réelle ? Six secondes de repos sont-elles tenables sans gêne ?
- **3-7 le fil vivant** : la vitesse de l'étincelle est-elle confortable ? Le fil qui s'effiloche se lit-il ?
- **4-7 le miroir menteur** : la règle se découvre-t-elle au premier cycle sans frustration ? L'éclat est-il assez tentant ?
- **5-7 les étoiles absentes** : trois étoiles restent-elles un jeu et non un test de mémoire ?
- **6-7 le jardin caché** : la différence respirer / scintiller se voit-elle sans être évidente ? Le repli après une hésitation paraît-il juste ?
- **7-7 la danse croisée** : le va-et-vient diagonal se ressent-il comme une danse ? Les coins lointains sont-ils confortables ?
- **8-7 la lanterne du courant** : anticipe-t-on la sortie de brume après un tour ? La fenêtre de prise est-elle juste ?
- **9-7 l'absence** : la différence silence / chevauchement se sent-elle ? Quitter une présence qui brille encore est-il naturel ?
- **10-7 l'ancre** : les mouvements de tête sont-ils petits et confortables, sans vertige ? La boussole suit-elle la tête dans le bon sens ?
- **11-7 d'abord les yeux** : la tête suit-elle naturellement après les yeux ? La différence de chaleur se perçoit-elle ?
- **12-7 l'orchestre du regard** : les passages s'enchaînent-ils en finale plutôt qu'en examen ? La constellation vivante récompense-t-elle ?
