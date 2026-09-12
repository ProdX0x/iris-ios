# Iris — rapport B1.2 : ambiance et effets séparés, fonction de Braises B explicitée

Date : 12 septembre 2026. Branche : `prototype/braises-b-ux-audio`, créée depuis `ea1cfaec8b3f91d0ae2dcfa11cf28fbeee7a48f5`. Références intactes : `416feb9` (B1, test humain), `ea1cfae` (B1.1, test humain). Bundle `net.steve-s.iris`, équipe `G4U9RG5GL7`, `project.yml` source de vérité, inchangés.

---

# PARTIE A — AUDIO

## Diagnostic

**Origine exacte.** La nappe est produite par `SineSynth.renderAmbient` (`Audio/Synth/SineSynth.swift`) : deux sinus, fondamentale du chapitre et sa quinte (× 1,5), mélangés 0,6 / 0,4, gain 0,012, fondu de 0,8 s à l'entrée et à la sortie. Elle est commandée par le cue `AudioCue.ambient(frequency:)`, envoyé par `GameViewModel.activateAudio()` à chaque activation de l'écran de jeu (préparation, retour d'arrière-plan, reprise après recalibration), changé de fondamentale à chaque changement de chapitre (`playNext`), et éteint par `deactivateAudio()` (fréquence nulle, puis arrêt du moteur) à la sortie du jeu. Elle joue pendant toute la présence à l'écran de jeu : carte d'intro, partie, pause, résultat.

**Raison historique.** Ajoutée le 11 septembre 2026 par la refonte (commit `52f20b7`), au titre de la direction artistique « chambre noire » (`Design/ART_DIRECTION.md` : « nappe d'ambiance par chapitre, deux sinus graves en quinte, gain très faible ») : donner une identité sonore à chaque chapitre (I 110 Hz, II 123,5 Hz, III 98 Hz, IV 130,8 Hz, V 116,5 Hz, VI 146,8 Hz). Elle ne vient pas du prototype HTML, qui n'avait que le crescendo, le carillon et le son de perte. Elle ne porte **aucune information de jeu**.

**Pourquoi elle sonne sourd.** Ce sont des sinus purs de 98 à 147 Hz, sans harmoniques, sur le haut-parleur d'un iPhone dont la réponse chute sous 200 Hz : il en reste un bourdonnement grave et étouffé, sans timbre.

**Comportement avant B1.2.** Un seul réglage, « Son » (`GameSettingsStore.soundEnabled`, clé `iris.soundEnabled`, vrai par défaut), gouvernait à la fois le démarrage du moteur audio, la nappe, et l'envoi de tous les cues d'événements. Couper le son coupait tout.

## Retour humain

`Le joueur a volontairement coupé le son parce que l'ambiance lui était désagréable. Ce choix a également supprimé les cues événementiels qu'il souhaite conserver.`

## Décision

| Point | Décision |
|---|---|
| Ambiance conservée ? | **Oui, conservée mais coupée par défaut.** Elle a une intention documentée (identité de chapitre) et un système propre ; elle n'a aucune valeur de jeu et le seul retour humain est négatif. Elle n'est pas supprimée avant un retravail du timbre ou un second test ; elle n'est plus imposée. |
| Nouveaux réglages | « **Effets sonores** » (`soundEffectsEnabled`, activés par défaut) : crescendo, carillon, perte, arpège, battement de veilleuse, allumage de braise. « **Ambiance sonore** » (`ambienceEnabled`, coupée par défaut) : la nappe. Deux interrupteurs, dans la même carte que les vibrations. |
| Routage | `GameViewModel` : le moteur ne démarre que si l'un des deux est actif ; la nappe n'est envoyée que si l'ambiance est active ; les cues d'événements ne sont envoyés que si les effets sont actifs. Aucun changement du synthétiseur, de la politique sonore, du service audio ni de l'haptique. |
| Persistance | deux clés `iris.soundEffectsEnabled` et `iris.ambienceEnabled` dans `UserDefaults`. |
| Migration | l'ancienne clé `iris.soundEnabled` est lue une fois puis supprimée : **coupé → effets coupés et ambiance coupée** (rien n'est rallumé dans le dos du joueur) ; **activé → effets activés et ambiance activée** (le joueur garde exactement ce qu'il entendait) ; **absente → effets activés, ambiance coupée** (nouveaux défauts). Une clé nouvelle déjà présente l'emporte sur l'ancienne. |

Conséquence pour le testeur : ayant coupé « Son », il retrouvera tout coupé ; il devra activer « Effets sonores » une fois. C'est voulu.

## Vérification

- `GameViewModelTests` : effets activés / ambiance coupée → moteur démarré, aucun cue de nappe, crescendo et arpège envoyés ; effets coupés / ambiance activée → moteur démarré, nappe envoyée, aucun cue d'événement (seuls les arrêts de voix, silencieux) ; tout coupé → moteur jamais démarré, aucun cue ; tout activé → nappe et cues.
- `GameSettingsStoreTests` : défauts, persistance, et les trois cas de migration (coupé, activé, clé nouvelle prioritaire).
- Ces tests vérifient les intentions et le routage du service audio, pas le haut-parleur.

---

# PARTIE B — BRAISES B

## Retour humain

`Le joueur ne comprend pas encore spontanément la fonction ni l'intérêt de Braises B malgré la correction physique précédente.`

## Diagnostic UX

Analyse de la version `ea1cfae` telle que le joueur la voit, avant sa première erreur :

1. **Rien ne dit l'enjeu.** La carte d'intro (« La 1 monte au centre. La braise dort juste au-dessus. ») et la consigne de départ (« La braise dort au-dessus de l'iris de la 1. ») décrivent la géométrie, pas ce que le joueur doit décider. Le mot « quand » n'apparaît nulle part.
2. **Le niveau contredit une habitude sans le dire.** Les numéros 1 et 2, l'ordre imposé et cinq chapitres d'Iris disent « d'abord la 1 ». B exige de s'occuper de la 2 avant que la 1 ne soit posée. Cette inversion est le cœur de B, et elle est invisible.
3. **La zone d'attention est invisible par principe** (A8). Le joueur ne peut pas voir que regarder la braise, c'est aussi regarder l'iris de la 1 à 120 pt. Il ne peut inférer le lien que par l'accident.
4. **Le niveau dure 5 à 8 s.** La 1 monte en 4,3 s. Il n'y a pas le temps d'observer, seulement d'agir par réflexe : attendre.
5. **Le retour d'erreur arrivait trop tard et disait mal.** La perte se produisait quand le joueur regardait la braise ; la consigne « Votre regard sur la braise a chassé la 1. Réveillez-la avant. » contredisait A (« regardez la braise ») sans expliciter « avant quoi ». Le joueur pouvait en conclure que regarder la braise est mauvais, l'inverse de la leçon.
6. **La braise endormie ressemble à un objet inerte** dont on cherche la fonction ; sans énoncé de la règle, le joueur passe son temps à la deviner.

## Question centrale

« Avant d'échouer, le joueur a-t-il une chance raisonnable de comprendre que le moment du réveil est l'enjeu ? » **Non.** Rien dans la présentation ne désigne le temps comme variable ; tout (numéros, ordre, habitude, brièveté) pousse à attendre, et l'erreur n'est expliquée qu'après coup, de façon ambiguë.

## Correction minimale

Uniquement des textes ; ni géométrie, ni physique, ni feedback nouveau, ni HUD, ni flèche.

| Moment | Avant (ea1cfae) | Après (B1.2) |
|---|---|---|
| Carte d'intro | « La 1 monte au centre. La braise dort juste au-dessus. » | « **Réveillez la braise avant que la 1 n'atteigne son iris.** » |
| Consigne de départ | « La braise dort au-dessus de l'iris de la 1. » | « Trop tard, votre regard chassera la 1. » |
| Première perte | « Votre regard sur la braise a chassé la 1. Réveillez-la avant. » | « Trop tard : votre regard sur la braise a chassé la 1. » |
| Affolement | inchangé | inchangé |

Le retour visuel et sonore de la perte (iris rouvert, lueur éteinte, glissando, impulsion) et le comportement des objets sont ceux d'Iris, inchangés.

## Quantité d'explication

Trois phrases, 27 mots au total (10 + 7 + 10). La règle apparaît sur la carte d'intro, avant de jouer ; sa conséquence pendant 4,5 s au début de la partie ; la cause à la première perte. Le joueur peut ensuite jouer sans autre assistance : les retours d'Iris suffisent pour vérifier la relation. Ce texte explicite sert à **évaluer le prototype** ; il ne préjuge pas d'un tutoriel final, qui devrait enseigner la même chose par la situation et le feedback.

## Question toujours ouverte

`La clarté de la règle ne démontre pas encore que la décision est intéressante.`

## Décision versus règle

Une fois la règle comprise, la stratégie est **déterministe** : réveiller la braise immédiatement. Analyse à partir des simulations B1.1 :

- réveiller tôt ne coûte rien de structurel : la 1 est au plus effleurée en montant, la braise réveillée attend allumée à son iris pendant environ neuf secondes avant de se rendormir, et si elle se rendort c'est loin de l'iris 1, donc sans risque ;
- attendre coûte toujours une perte ;
- il n'existe aucun état du niveau où attendre serait préférable ; la seule variable, l'affolement par un regard trop long, est la règle d'A, pas une raison d'attendre.

B représente donc, dans sa forme actuelle :

### B — une règle optimale déterministe

`BRAISES B EST COMPRIS, MAIS LA STRATÉGIE OBSERVÉE RESTE DÉTERMINISTE : UNE RÈGLE OPTIMALE, PAS ENCORE UN ARBITRAGE.`

Le « compris » reste à confirmer par le test humain B1.2 ; le caractère déterministe de la stratégie, lui, est établi par l'analyse. Aucune seconde option n'a été fabriquée pour y remédier : pas de compteur, pas de bonus, pas de pénalité, pas de script, pas de mécanique.

Une piste, notée sans être conçue ni implémentée : un arbitrage sur le moment n'existerait que si réveiller **trop tôt** avait aussi un coût naturel (par exemple une braise dont la fuite au réveil traverse le chemin de la 1 encore en route), créant une fenêtre « ni trop tôt ni trop tard ». Sa faisabilité par le seul level design n'est pas démontrée ; la direction de fuite dépend de l'approche du curseur, figée avec A.

## Ce que ce rapport ne conclut pas

Ni la taille d'un futur chapitre Braises, ni son existence : `LA PROFONDEUR SUPPLÉMENTAIRE TESTÉE PAR BRAISES B N'EST PAS DÉMONTRÉE DANS CETTE FORME.` Le coût des itérations B1, B1.1 et B1.2 n'entre pas dans ce jugement.

L'interférence d'apprentissage en campagne reste `NON RÉSOLUE`.

---

# VÉRIFICATIONS

Résultats réels de cette branche :

| Étape | Résultat |
|---|---|
| `git diff --check` | propre |
| A, réglage de braise, moteur Braises, physique, Gaze Engine, campagne, synthétiseur, politique sonore, haptique | identiques à `416feb9` (diff vide sur ces fichiers) ; tests `aIsFrozen`, `flareReach`, `officialCampaignUntouched` verts |
| Debug simulateur | BUILD SUCCEEDED |
| Tests | 253 exécutés, 253 réussis, 0 échec, 0 ignoré (4 ajoutés : routage audio en quatre combinaisons, migration du réglage ; contenu de B vérifié) |
| Release simulateur | BUILD SUCCEEDED |
| Audit | C1, C2, C8, C9, C10, C12 pass, 205 fichiers |
| Debug appareil signé | BUILD SUCCEEDED, `net.steve-s.iris`, `G4U9RG5GL7` |
| Installation et lancement | réussis sur l'iPhone 14 Pro, processus vivant après 8 s |

Aucun test humain n'a été réalisé sur cette version.
