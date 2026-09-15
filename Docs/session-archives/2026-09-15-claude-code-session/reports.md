# Rapports et comptes rendus de Claude (texte d'origine)

Extraits automatiquement : toutes les réponses de Claude de plus de 2 000 caractères (bilans de fin de mission), et celles de plus de 1 500 caractères qui contiennent « rapport final », « rapport de », « verdict », « compte rendu » ou « final report ». Le texte est copié tel quel ; chaque rapport garde sa place dans l'historique complet.


---

## 2026-09-11 00:35:32 +0200 (22:35:32Z)
`f88478cc` · `cb69b33c` · ligne 613

~~~~markdown
Mission terminée. Le projet Xcode **Iris** est directement dans le dossier courant, compilable, testé et documenté ; `attention-indirecte.html` et les deux archives sont intacts.

## Résultats réels

| Vérification | Résultat |
|---|---|
| Build Debug (simulateur iPhone 17 Pro) | `BUILD SUCCEEDED`, 0 erreur, 0 warning de notre code |
| Tests (`xcodebuild test`) | **121/121 PASS**, 18 suites, 0 ignoré |
| Build Release (simulateur) | `BUILD SUCCEEDED` |
| Builds Debug et Release appareil arm64 (non signés) | `BUILD SUCCEEDED` |
| Audit de couches (`Tools/audit.py`) | aucune violation sur 106 fichiers |

Seul diagnostic restant : la notice Xcode `appintentsmetadataprocessor` (pas d'App Intents), sans défaut réel.

## Ce qui a été construit

- **Moteur Swift pur** (Domain + GameEngine, Foundation seul) : port exact du JS. Deux traces « golden » générées depuis le moteur JavaScript extrait prouvent l'équivalence frame par frame (tolérance 1e-6) sur 393 et 241 frames, validations 1→2→3 aux mêmes frames.
- **Indépendance au framerate** : delta borné à 0,1 s, sous-pas d'une frame de référence (30 Hz = 2 × 60 Hz exact), puissance fractionnaire exacte de l'application affine pour 120 Hz ; identité bit à bit à 60 Hz.
- **Règles métier testées** : validation 0,75 s continue, tolérance 36 pt, ordre 1→2→3 avec arrivée physique hors tour autorisée, cascade (perte de 2 invalide 2 et 3, perte de 1 invalide tout), 14 niveaux géométriquement identiques à l'original.
- **Regard** : `ARFaceTrackingConfiguration`, projection du rayon `lookAtPoint` sur le plan de l'appareil, lissage 0,1 et rejet des sauts, états interruption / reprise / arrière-plan / refus caméra / appareil incompatible / erreur AR, tous avec un écran dédié.
- **Audio** : `AVAudioEngine` + synthétiseur sinus sans allocation côté rendu (crescendo par cible, carillon, perte descendante), politique « un seul son de perte par tick, 150 ms de garde ».
- **UI Iris** : design system (tokens, 9 composants), 7 écrans plus overlays, rendu Canvas avec horizon, sol en perspective, sphères ombrées à échelle de profondeur ; vérifié par captures simulateur.

## À valider sur appareil TrueDepth

Le suivi du regard n'a pas été exercé physiquement. Le point critique est le signe du miroir horizontal et l'échelle mètres → points : l'overlay de pause propose « Afficher le point de regard » et « Miroir horizontal » pour vérifier et corriger sans recompiler. Le README (section 12) liste ces limites avec les statuts `[vérifié automatiquement]`, `[vérifié par compilation]` et `[nécessite validation sur appareil TrueDepth]`.

Écarts volontaires documentés : overlay de fin de niveau et écran de fin de parcours (le HTML enchaînait immédiatement), amorçage du curseur sur le dernier regard connu, cascade sonore coalescée, gain audio ×2 pour le haut-parleur iPhone.
~~~~


---

## 2026-09-11 08:30:15 +0200 (06:30:15Z)
`f88478cc` · `8face5b6` · ligne 898

~~~~markdown
Mission Gaze Engine v2 terminée. Le moteur de jeu est intact (traces golden toujours vertes), `attention-indirecte.html` conserve son empreinte, et le pipeline du regard a été reconstruit.

## Résultats réels

| Vérification | Résultat |
|---|---|
| Tests (`xcodebuild test`, iPhone 17 Pro) | **185/185 PASS**, 27 suites, 0 ignoré (121 anciens + 69 nouveaux, 5 tests de projection v1 remplacés) |
| Build Debug et Release simulateur | `BUILD SUCCEEDED`, 0 warning de notre code |
| Build Debug et Release appareil arm64 (non signés) | `BUILD SUCCEEDED` |
| Audit de couches | pass, 138 fichiers |

Un iPhone 14 Pro appairé est visible, mais rien n'y a été installé : la validation humaine reste `[nécessite validation sur iPhone TrueDepth]`.

## Défauts trouvés et corrigés

- **Signes X/Y imposés** et `.portrait` codé en dur : le symptôme « meilleur téléphone retourné » correspond à une inversion des deux axes. Désormais l'orientation vient de la `UIWindowScene`, et les axes écran sont **résolus à l'exécution** parmi ±x/±y du repère caméra grâce à la ligne des yeux (gauche → droite) et à la gravité, par vote majoritaire. Un repère retourné, miroir ou pivoté donne un mapping correct sans conjecture sur les conventions ARKit.
- **Approximations PPI / caméra** reléguées à un repère nominal ; la **calibration affine à 6 coefficients** (9 points, sans clic, clignements exclus, agrégation médiane/MAD) apprend échelle, offset, cisaillement et inversions.
- **Aucune calibration** → parcours diagnostic (10 contrôles) → calibration → vérification 5 points (seuils 18 % moyen / 30 % max de la petite dimension) → « Regard prêt » avec point menthe vivant. Profil persistant avec invalidation (version, viewport, orientation, validité, 30 jours), revalidation rapide aux lancements suivants, « Recalibrer le regard » depuis la pause.
- Perte de visage : pause automatique après 0,3 s, reprise au retour. Réglage « miroir » supprimé ; mode diagnostic brut/calibré/lissé conservé.
- Course détectée en revue : le tracker partagé pouvait être coupé par l'`onDisappear` tardif de l'écran précédent ; corrigé par un drapeau de propriété, avec test de régression.

## Documents

`GAZE_ENGINE_V2_REPORT.md` (avant, défauts, après, fichiers, tests, builds, statuts, procédure de test humain en 10 étapes), section « 4. Regard (Gaze Engine v2) » du README, ADR-10 à ADR-12, règles R-16 à R-22, audit et journal de déduplication mis à jour. Le parcours complet a été vérifié sur simulateur avec un regard scripté (captures des quatre étapes).
~~~~


---

## 2026-09-11 13:49:56 +0200 (11:49:56Z)
`f88478cc` · `4c1acc26` · ligne 1305

~~~~markdown
Iris est maintenant un jeu complet construit sur le noyau du prototype : six chapitres, 34 niveaux conçus un par un, chacun prouvé faisable par simulation. Rien n'a été testé au regard sur un iPhone réel : le robot de simulation prouve qu'un niveau se termine, pas qu'il est agréable.

| Vérification | Résultat |
|---|---|
| Tests | 220 sur 220, dans 33 suites |
| Builds Debug et Release, simulateur et appareil | réussis, sans avertissement de notre code |
| Audit de couches | aucune violation sur 191 fichiers |

**Ce que l'audit du prototype a montré.** Les 14 niveaux n'étaient que trois réglages avec des positions tirées au hasard. Le niveau 2 se terminait presque seul, et le niveau 5 ne laissait que 0,4 % d'écran sans repousser une sphère. Surtout, regarder hors du téléphone gagnait chaque niveau, et le regard ne servait qu'à gêner.

**Ce qui a été conçu puis construit :**
- **Six documents de référence** dans `Design/` : audit, vision, game design, level design, UX et direction artistique. Chacun inclut une revue critique qui a retiré plusieurs idées, dont un défi quotidien et des lueurs attirées par le regard.
- **Le regard devient un outil.** Les courants et les voiles obligent à pousser une lueur en regardant de l'autre côté. Les veilleuses obligent à regarder une flamme sans troubler le reste.
- **Rester sur l'écran** : si les yeux quittent l'écran, les iris se ferment. La faille est supprimée.
- **Apprentissage joué** : le premier niveau sert de tutoriel, avec des consignes qui apparaissent quand le joueur fait la chose.
- **Progression sauvegardée** : carte des chapitres, trois éclats par niveau, carnet des éléments rencontrés, et un chemin d'aide affiché après 45 s.
- **Nouvelle identité « chambre noire »** : vue de face sans fausse perspective, lueurs lumineuses, points d'arrivée en diaphragmes, nappe sonore par chapitre, nouvelle icône.

**Preuve par simulation.** Un robot au regard bruité termine chaque niveau. Sans pousser, sans regarder la flamme ou en regardant hors écran, il échoue là où l'élément est censé être nécessaire. Ce contrôle a forcé la refonte de six niveaux, par exemple un courant trop fort pour une lueur lourde.

**Limites et travail restant :**
- Jouabilité réelle au regard, durée ressentie et pertinence des éclats pour un humain restent à tester sur iPhone TrueDepth.
- Trois retours conçus ne sont pas faits : le trait qui relie une perte en cascade à sa cause, l'assombrissement avant le résultat, et la vibration à chaque validation.
- La simulation ne tourne que sur l'écran de référence de 393 × 852 pt, donc l'iPad n'est pas vérifié.
- La carte d'intro recouvre le bas de l'écran.

Rien n'est commité : 119 fichiers modifiés attendent sur la branche `feature/iris-v2`. Le README détaille les commandes et les résultats.
~~~~


---

## 2026-09-11 23:54:23 +0200 (21:54:23Z)
`f88478cc` · `5227ead2` · ligne 1565

~~~~markdown
Mission terminée : identité Apple verrouillée dans `project.yml`, builds signés, 220 tests verts, app installée et lancée sur l'iPhone 14 Pro, commit de référence créé sur `feature/iris-v2`. Rien n'a été poussé ni fusionné.

## Cause réelle du problème

`NKN63DTRM4` n'a jamais été une équipe. C'est l'identifiant personnel écrit entre parenthèses dans le nom des certificats « Apple Development ». Le vrai Team ID est le champ OU de ces mêmes certificats, `G4U9RG5GL7`. Lors de la création du projet, cette valeur fausse et un préfixe inventé, `com.prodx0x`, ont été inscrits dans `project.yml`. Tu as corrigé l'équipe et l'identifiant dans Xcode, mais Xcode n'écrit que dans le `.pbxproj` généré. Chaque `xcodegen generate` régénérait le projet depuis `project.yml` et effaçait ta correction. Aucun `.xcconfig`, script ou CI n'est en cause.

## Configuration finale

| Réglage | Valeur | Où elle vit |
|---|---|---|
| Bundle ID app | `net.steve-s.iris` | `project.yml`, cible Iris |
| Bundle ID tests | `net.steve-s.iris.tests` | `project.yml`, cible IrisTests |
| Development Team | `G4U9RG5GL7` | `project.yml`, réglages de base, hérité par les deux cibles |
| Signing | `Automatic`, identité générique « Apple Development » | `project.yml` |
| Profil épinglé | aucun | vérifié par l'audit |
| Organisation du projet | Stéphane SAULNIER | attribut `ORGANIZATIONNAME` |

**Team ID déterminé** par quatre sources concordantes : le champ OU des six certificats installés, l'unique équipe connue de Xcode et dernière sélectionnée, les 29 profils de provisioning installés, et le seul build signé présent dans DerivedData. Les valeurs résolues par `xcodebuild -showBuildSettings` sont identiques en Debug et en Release, pour l'appareil comme pour le simulateur. Il n'y a pas de configuration Archive distincte.

**Migration** : `project.yml`, projet régénéré, trois sous-systèmes de log passés à `net.steve-s.iris`, `GAZE_ENGINE_V2_REPORT.md`, `Docs/project-brief.md`, README. Aucun `.xcconfig`, entitlement, URL scheme, App Group ni fichier StoreKit n'existait. L'ancien préfixe ne subsiste que dans l'audit qui l'interdit et dans deux passages historiques documentés.

**Protections ajoutées** : section « Apple Signing » en tête du README, commentaire de tête dans `project.yml`, contrôle C12 dans `Tools/audit.py` qui échoue si `project.yml`, le `.pbxproj` ou les sources divergent, ADR-17 et une convention. Aucun identifiant Apple personnel n'est versionné.

## Vérifications réelles

| Étape | Résultat |
|---|---|
| Debug simulateur | BUILD SUCCEEDED |
| Tests Debug simulateur | 220 exécutés, 220 réussis, 0 échec, 0 ignoré |
| Release simulateur | BUILD SUCCEEDED |
| Debug appareil signé | BUILD SUCCEEDED, `net.steve-s.iris`, équipe `G4U9RG5GL7`, profil automatique |
| Release appareil signé | BUILD SUCCEEDED, même identité |
| build-for-testing appareil signé | TEST BUILD SUCCEEDED, bundle de tests `net.steve-s.iris.tests` |
| Audit | C1, C2, C8, C9, C10, C12 pass, 191 fichiers |

**Appareil** : l'iPhone 14 Pro « iPhone Steve. » était connecté, mode développeur actif, UDID présent dans le profil automatique. Statuts exacts : `[build appareil réussi]`, `[installation appareil réussie]` avec lancement et processus vivant 8 s plus tard, `[nécessite validation humaine]` pour la caméra, la calibration TrueDepth et le jeu. Personne n'a touché l'écran. Le téléphone garde une vieille installation `com.prodx0x.iris` que plus rien ne met à jour. Tu peux la supprimer à la main.

**StoreKit readiness** : oui, le Bundle ID principal est stabilisé, régénéré à l'identique, audité, signé et installé sous la bonne équipe. Reste un prérequis côté portail que je n'ai pas fait : enregistrer l'App ID explicite `net.steve-s.iris`. Le profil actuel est le profil générique de développement, suffisant pour développer, pas pour les achats intégrés.

## Commit de référence

| | |
|---|---|
| Hash complet | `52f20b7a4838e85f5be12c202bd4b98e9693f3a7` |
| Hash court | `52f20b7` |
| Branche | `feature/iris-v2`, 1 commit en avance sur `origin`, arbre propre |
| Message | `feat: complete Iris v2 refactor and Gaze Engine v2` |
| Fichiers ajoutés | 67 |
| Fichiers modifiés | 72 |
| Fichiers supprimés | 17 |
| Fichiers renommés | 6 |

Les 17 suppressions sont voulues : tutoriel, ancienne progression à 14 niveaux et son test, anciennes couleurs de scène et de séquence. Les renommages couvrent le catalogue prototype, son test et quatre colorsets dont Git a apparié le contenu. `attention-indirecte.html` est intact, empreinte inchangée. Pas de push, pas de merge vers `main`, pas de StoreKit.
~~~~


---

## 2026-09-12 00:08:48 +0200 (22:08:48Z)
`f88478cc` · `c448abad` · ligne 1600

~~~~markdown
Iris v2 est officialisé dans `main` par fast-forward, et `feature/game-expansion` est créée. Aucun fichier n'a été modifié, rien n'a été poussé.

## Git

| | |
|---|---|
| Branche active | `feature/game-expansion` |
| Hash de `main` | `52f20b7a4838e85f5be12c202bd4b98e9693f3a7` |
| Hash de `feature/game-expansion` | `52f20b7a4838e85f5be12c202bd4b98e9693f3a7` |
| Commit `52f20b7` inclus | oui, dans `main`, `feature/game-expansion` et `feature/iris-v2` |
| Working tree | propre avant et après |
| Résultat de la fusion | fast-forward réel, sans merge commit, sans rebase ni squash |

`main` était l'ancêtre direct de `feature/iris-v2`, avec un seul commit à intégrer et aucune divergence. `feature/iris-v2` est conservée. Les trois branches locales sont en avance d'un commit sur `origin` : aucun push n'a été fait. Le fast-forward n'ayant changé aucun contenu par rapport au commit déjà validé, les 220 tests n'ont pas été relancés.

## Identité

- Bundle ID : `net.steve-s.iris`, tests `net.steve-s.iris.tests`.
- Team ID : `G4U9RG5GL7`.
- Source autoritaire : `project.yml`, section « Apple Signing » du README, contrôle C12 de l'audit toujours présent et vert.
- `attention-indirecte.html` présent, empreinte inchangée.

## Actions

Confirmé : aucune modification fonctionnelle, aucun nouveau chapitre, aucun nouveau niveau, aucun StoreKit, aucun push. Aucun paramètre du regard, de répulsion, de zone ou de validation n'a été touché.

## Étape suivante : protocole de validation humaine

Le statut reste `[nécessite validation humaine sur iPhone TrueDepth]` pour la précision réelle du regard, la calibration, le confort, la fatigue, la jouabilité et l'équilibrage.

**A. Installation.** Utiliser uniquement l'app `net.steve-s.iris`. L'iPhone 14 Pro porte encore l'ancienne installation `com.prodx0x.iris` : supprimez-la avant de tester pour éviter toute confusion.

**B. Orientation.** Tenir l'iPhone dans son orientation normale. Ne jamais le retourner pour compenser le suivi.

**C. Calibration.** Passer entièrement le diagnostic, la calibration, la vérification, jusqu'à l'état « Regard prêt ».

**D. Diagnostic visuel.** Activer « Afficher les points de regard » dans les réglages ou le menu pause. Regarder successivement le centre, la gauche, la droite, le haut, le bas, puis les quatre coins. Noter immédiatement toute anomalie : côté inversé, décalage constant, point qui décroche.

**E. Partie réelle.** Jouer normalement pendant 10 à 15 minutes minimum, sur plusieurs niveaux, pas seulement vérifier que l'app ne plante pas.

**Notes à prendre pendant la session**, courtes et spontanées, par exemple :

```
Niveau 3 — très facile.
Niveau 4 — première fatigue.
Deux cibles — agréable.
Troisième cible — devient pénible.
Répulsion trop forte.
Je n'arrive pas à maintenir la cible 1.
Zone d'attention trop grande.
Le curseur décroche vers le bas.
Latence perceptible.
Très amusant lorsque les deux cibles se croisent.
Besoin d'un moment de repos après X niveaux.
```

Conservez ces notes : elles dimensionneront les futurs chapitres, la progression, le nombre de cibles et la difficulté.

**Deux catégories à ne jamais mélanger.** Un défaut technique, comme un point qui part du mauvais côté, un suivi perdu, un décalage systématique ou une latence anormale, se corrige d'abord dans le Gaze Engine. Une difficulté de gameplay, comme une répulsion trop forte, un niveau trop long ou une fatigue après plusieurs cibles, alimente le level design.

**Condition pour ouvrir la conception :** calibration réalisée, regard techniquement cohérent, plusieurs niveaux joués, environ 10 à 15 minutes de jeu, premières observations de confort et de difficulté disponibles. Si un défaut majeur de suivi apparaît, la correction ciblée passe avant tout.

StoreKit reste hors périmètre jusqu'à la stabilisation de la structure complète du jeu.

**EN ATTENTE DE VALIDATION HUMAINE DU GAMEPLAY TRUEDEPTH AVANT GAME DESIGN.**
~~~~


---

## 2026-09-12 01:22:53 +0200 (23:22:53Z)
`f88478cc` · `c0d82a4a` · ligne 1736

~~~~markdown
Le retour haptique est rétabli, testé, installé sur l'iPhone et commité sur `feature/game-expansion`. La validation humaine du Gaze Engine est consignée dans le README.

## Cause exacte du défaut

Le réglage « Vibrations » était bien persisté et lu, mais il ne commandait presque rien. Un seul retour haptique existait dans toute l'app : un modificateur SwiftUI sur l'écran de résultat, déclenché quand le troisième éclat s'allume, près d'une seconde après la fin du niveau. Aucun événement de jeu n'appelait de générateur haptique. C'était une décision de conception de la refonte, pas un problème de thread, de `prepare()` ni de générateur perdu. Le joueur ne pouvait donc rien sentir pendant la partie. Point à vérifier de ton côté : si « Vibrations système » est coupé dans Réglages iOS, tous les générateurs UIKit sont muets, Iris ne le contourne pas.

## Architecture retenue

- **Couche `Haptics/`** calquée sur `Audio/` : intentions `HapticCue`, politique `HapticCuePolicy` déterministe sans UIKit, protocole `HapticFeedbackService` avec une implémentation UIKit et une silencieuse.
- **Générateurs conservés** pour la session : impact moyen à 0,7 pour une validation, impact doux à 0,45 pour une perte, notification de réussite en fin de niveau, préparés une fois au début de chaque maintien.
- **Une seule source de vérité** : le modificateur de l'écran de résultat est supprimé, le ViewModel joue les impulsions à chaque tick si la préférence est active. Le moteur de jeu ne connaît pas UIKit.
- **Réglage** : prise en compte au tick suivant, persistance inchangée dans `UserDefaults`.

## Cascade, garde et lien avec l'audio

Un tick produit au plus une impulsion : fin de niveau avant perte, perte avant validation. Tous les événements de perte d'un même tick, cascade comprise, donnent une seule impulsion, décidée dans la politique avant tout appel. La garde audio de 150 ms existait déjà pour le même concept, elle est maintenant une constante du domaine partagée par les deux politiques. Aucune seconde constante. La fin de niveau n'est jamais filtrée, et le maintien de 0,75 s borne la boucle perte, vibration, mouvement, nouvelle perte.

## Vérifications

| Étape | Résultat |
|---|---|
| `git diff --check` | propre |
| Debug simulateur | BUILD SUCCEEDED |
| Tests | 232 exécutés, 232 réussis, 0 échec, 0 ignoré |
| Release simulateur | BUILD SUCCEEDED |
| Debug appareil signé | BUILD SUCCEEDED, `net.steve-s.iris`, `G4U9RG5GL7` |
| Installation et lancement iPhone 14 Pro | réussis, processus vivant après 8 s |
| Audit | C1, C2, C8, C9, C10, C12 pass, 200 fichiers |

Au premier passage, un nouveau test plaçait la seconde perte exactement à la frontière de 150 ms, où l'arithmétique flottante donne 0,1499. Le test place désormais ses pertes nettement en deçà et au-delà. La politique n'a pas changé. Statuts : `[build appareil réussi]`, `[installation appareil réussie]`, `[logique haptique vérifiée automatiquement]`, `[sensation physique nécessite validation humaine]`.

## Commit

| | |
|---|---|
| Hash | `229b8df6a59de6e13599e004477d37885a0a550e` |
| Message | `fix: restore gameplay haptic feedback` |
| Branche | `feature/game-expansion`, working tree propre, rien poussé |
| Fichiers | 10 ajoutés, 16 modifiés |
| Bundle ID | `net.steve-s.iris`, tests `net.steve-s.iris.tests` |
| Team ID | `G4U9RG5GL7`, source `project.yml` |

Fichiers modifiés hors nouvelle couche : le ViewModel du jeu, le conteneur d'injection, la politique audio, l'écran de résultat et son overlay, `project.yml`, l'audit, les tests, le README, le modèle de domaine, l'architecture, la spécification `Docs/Features/Haptics.md` et le game design.

Confirmé : Gaze Engine non modifié, aucun nouveau chapitre, aucun nouveau niveau, aucun StoreKit, aucune modification de difficulté, des paramètres du regard ni du moteur physique. Les observations sur le téléphone tenu en main et sur les bords de l'écran sont consignées comme contraintes de conception, sans correction.

`PRÊT POUR LA PHASE GAME DESIGN / EXPANSION APRÈS VALIDATION HUMAINE DU RETOUR HAPTIQUE.`
~~~~


---

## 2026-09-12 02:09:54 +0200 (00:09:54Z)
`f88478cc` · `b956fcc1` · ligne 1859

~~~~markdown
Phase A terminée et commitée. Plusieurs directions ont été explorées, les faibles éliminées, et quatre concepts méritent potentiellement d'être construits. Rien n'est implémenté.

## Situation actuelle

Les six chapitres et leurs 34 niveaux ont été analysés depuis leurs données réelles. Points forts : chaque élément prouvé nécessaire, chaque paire de niveaux différente, des finales bien placées, une partie gratuite qui ne frustre pas. Faiblesses principales :

- **Aucune respiration conçue** : après le chapitre II, quatre chapitres exigeants d'affilée, en montée continue.
- **III et IV enseignent le même verbe**, pousser, sur douze niveaux consécutifs.
- **L'élément propre de VI est facultatif** : 6-1 et 6-2 se jouent par simple évitement.
- **La garde n'est jamais active** malgré sa présence dans quatre chapitres.
- Répétitions : 1-2 refait 1-1 en plus facile, 3-1 / 3-2 / 3-4 ont le même profil, IV alterne en dents de scie, 6-5 dépasse la finale.

## Documents produits

Tous dans `Design/`, plus le rapport `GAME_EXPANSION_DESIGN_REPORT.md` à la racine et une section 16 du README :

- `GAME_CORE_INVARIANTS.md` : douze invariants, ce qui varie, ce qui approfondit, ce qui dénaturerait, cinq questions de test.
- `PLAYER_COMFORT_CONSTRAINTS.md` : le test iPhone traduit en points. Une bonne calibration place le regard à 39 pt près, une calibration acceptée de justesse à 71 pt. D'où des règles chiffrées pour les cibles de regard, la périphérie, le téléphone tenu en main, la fatigue.
- `DIFFICULTY_MODEL.md` : douze axes, profil des six chapitres et de chaque séquence de niveaux, garde-fous. Provisoire.
- `GAME_EXPANSION_CONCEPTS.md` : douze concepts, chacun avec sa critique à charge, tests chapitre ou niveau, redondance, matrice à treize critères notés séparément, éliminations, seconde passe.
- `CAMPAIGN_STRUCTURE.md` : dix chapitres proposés, courbe, découpage par finaliste, solutions de repli, analyse de la partie gratuite.
- `LEVEL_DESIGN_SYSTEM.md` marqué provisoire avec une partie B, `GAME_VISION.md` et `GAME_DESIGN.md` révisés.

## Élimination

| Catégorie | Concepts |
|---|---|
| Retenir | Souffles, Braises, Rendez-vous, Phares |
| Réserve | Ancres, Nuée, Élan, Accord |
| Rejeter | Ombres, Pénombre, Regard calme, Carrefour |

Rejets motivés : Ombres exige la précision aux frontières et duplique la zone d'attention. Pénombre cache ce que le joueur doit voir sans regarder. Regard calme punit les saccades, fonctionnement normal de l'œil, et amplifie les micro-mouvements du téléphone. Carrefour est une décision unique puis un niveau connu.

La seconde passe critique a **rétrogradé Ancres**, finaliste initial : trop dépendant de la précision du suivi, et troisième mécanique « regardez ici » après veilleuses et braises. **Phares** a pris sa place, seul axe temporel, le plus tolérant au regard imprécis, à condition que son expiration soit prototypée.

## Les quatre finalistes, sans les vendre

- **Souffles** : une brume lente que le regard détourne, le regard comme bouclier. Seul concept sans redondance à valeur de chapitre maximale. Risques : le plus coûteux techniquement, fatigue de surveillance, ton de défense si elle va vite.
- **Braises** : des lueurs froides nourries par de courts regards qui les font fuir. Le plus fidèle à l'identité. Risques : ressemble aux veilleuses, projection chaotique si le rayon de charge est petit, sentiment d'être puni pour obéir.
- **Rendez-vous** : deux lueurs jumelles qui sont le but l'une de l'autre. Respiration confortable et lisible. Risque : nécessité indirecte, sans obstacle elles se rejoignent seules.
- **Phares** : des iris qui s'ouvrent et se ferment lentement, à retenir puis relâcher. Risque : sans expiration l'idée est passive, avec elle on ajoute une règle pour en sauver une autre.

## Campagne proposée

I Éveil, II Partage, III Courants, IV Voiles, **V Rendez-vous**, VI Veilleuses, **VII Souffles**, **VIII Phares**, **IX Braises**, X Clairvoyance étendue. Environ 58 niveaux, deux respirations placées après les blocs les plus fatigants. Rendez-vous s'insère entre IV et V actuels, pas après VI.

Partie gratuite : I et II apprennent Iris mais ne montrent pas le retournement de III. Proposé, sans code : une finale de II qui annonce la poussée, le remplacement de 1-2, Accord en variation.

## Décisions qui t'appartiennent

1. Quels finalistes prototyper, et dans quel ordre.
2. Accepter qu'un chapitre de respiration prouve sa différence plutôt que sa nécessité.
3. Ordre relatif de Phares et Braises, sort de l'iris mouvant, longueur de X.
4. Finale de II et remplacement de 1-2 pour la partie gratuite.
5. Point relevé au passage : le rayon de regard des veilleuses, 55 pt, est inférieur à l'erreur moyenne d'une calibration acceptée de justesse, 71 pt. Non modifié, à vérifier avec un second testeur.

Ces documents ne démontrent ni le plaisir, ni la fatigue, ni la difficulté réelles. Chaque concept approuvé devra être prototypé sur deux niveaux et joué sur iPhone.

## Git

| | |
|---|---|
| Commit | `937d5497f2f82ebad42f3c2d3c883f99d7127113` |
| Message | `docs: define Iris campaign expansion concepts` |
| Branche | `feature/game-expansion`, arbre propre, ni push ni merge |
| Fichiers | 10 modifiés ou ajoutés, documentation uniquement, aucun fichier Swift |

Aucun niveau, aucun chapitre 7 à 10, aucune mécanique, aucun paramètre du regard, aucune modification du Gaze Engine ni du moteur, aucun StoreKit.

**VALIDATION HUMAINE DE LA CONCEPTION AVANT TOUTE IMPLEMENTATION DES NOUVEAUX CHAPITRES.**
~~~~


---

## 2026-09-12 07:17:44 +0200 (05:17:44Z)
`f88478cc` · `22e69251` · ligne 2012

~~~~markdown
Le prototype Braises est construit, testé et commité sur `prototype/braises`. Une seule chose n'a pas pu être faite : l'installation sur l'iPhone, qui était déconnecté au moment voulu.

## Ce qui a été construit

**Mécanique.** Une braise dort, froide, sombre et immobile. Le regard posé dessus, dans un rayon de 86 pt, la réchauffe en moins d'une seconde. À mi-chaleur elle s'allume : elle se réveille, fuit le regard comme toute lueur, dérive vers son iris, et l'iris l'accepte. Ignorée, elle refroidit lentement et se rendort. Si le regard insiste, elle s'affole : elle fuit de plus loin pendant quelques secondes. Elle ne perd jamais sa chaleur ni sa place pour avoir été regardée.

Le sommeil est un ajout au concept de phase A, pour la lisibilité : une braise qui ne bouge pas tant qu'on ne la regarde pas rend la cause et l'effet immédiats. C'est documenté dans le rapport.

**Deux niveaux hors campagne**, chapitre « P », compilés en DEBUG seulement :
- **A · braise** : une braise, un iris. Teste le geste.
- **B · deux feux** : une lueur normale à poser d'abord, puis la braise à réveiller. Son iris est dans la zone d'un regard posé dessus, donc la réveiller là chasse la première lueur. Il faut choisir d'où et quand. Teste la décision.

**Accès sur l'iPhone** : Réglages → *prototypes (debug)* → Braises A ou B. Rien n'est enregistré dans la progression. Le résultat propose le prototype suivant puis les chapitres, jamais la fin de parcours.

## Quantité d'explication

Une phrase d'intro et trois ou quatre consignes d'une ligne par niveau, toutes contextuelles. Aucune page de règles. Jugement honnête : la consigne de départ « Elle est froide. Regardez-la. » est probablement nécessaire pour un joueur qu'Iris a formé à éviter les lueurs, car une braise endormie ne fait rien tant qu'on l'évite. C'est un signal de risque modéré que seul le test humain tranchera. Les autres consignes confirment ce que la lumière et le mouvement montrent.

## Vérifications

| Étape | Résultat |
|---|---|
| `git diff --check` | propre |
| Debug simulateur | BUILD SUCCEEDED |
| Tests | 246 exécutés, 246 réussis, 0 échec |
| Release simulateur | BUILD SUCCEEDED |
| Audit | C1, C2, C8, C9, C10, C12 pass, 205 fichiers |
| Debug appareil signé | BUILD SUCCEEDED, `net.steve-s.iris`, `G4U9RG5GL7` |
| Installation et lancement | non faits, iPhone déconnecté, deux tentatives |

Le joueur simulé qui nourrit termine les deux niveaux sur trois graines sans perte. Celui qui ne nourrit jamais échoue, un regard hors écran aussi. Les 34 niveaux officiels sont vérifiés inchangés par un test dédié, et les traces golden du moteur restent vertes.

## Protection de l'existant

Gaze Engine, calibration, physique de référence, six chapitres et progression inchangés. L'intégrateur reçoit un facteur de comportement neutre pour toute lueur ordinaire. Le rayon des veilleuses est laissé à 55 pt. StoreKit absent, aucune télémétrie. Le prototype se retire en supprimant sept fichiers et un champ optionnel.

## Ce que l'automatisation ne dit pas

Le plaisir, la lisibilité humaine réelle, la fatigue, la valeur comme chapitre, l'endurance sur une séquence longue, et l'interférence d'apprentissage avec les réflexes acquis : `NON RÉSOLUE`, elle exigera un test en contexte de campagne si Braises devient PROMETTEUR.

## Git et documents

| | |
|---|---|
| Commit | `416feb92d2ee27fb020917f4f85e0e1cb4b5b42b` sur `prototype/braises` |
| Fichiers | 7 ajoutés, 24 modifiés, arbre propre, ni push ni merge |
| Rapport | `BRAISES_PROTOTYPE_REPORT.md` |
| Fiche de test | `Design/BRAISES_PROTOTYPE_TEST.md` |

Pour tester : brancher l'iPhone, lancer depuis Xcode sur la branche `prototype/braises`, puis suivre la fiche.

`BRAISES PRÊT POUR TEST HUMAIN SUR IPHONE — AUCUNE DÉCISION DE CHAPITRE N'A ÉTÉ PRISE.`
~~~~


---

## 2026-09-12 12:02:22 +0200 (10:02:22Z)
`f88478cc` · `d629ef3d` · ligne 2139

~~~~markdown
Tout est terminé et commité. Voici le bilan.

## Diagnostic

J'ai reconstitué B tick par tick avec le moteur réel, un regard lissé comme en jeu et un réveil « jusqu'à allumage » comme le fait un humain. Dans la version testée, aucune stratégie ne produisait jamais de perte :

| Stratégie sur l'ancien B | Effet sur la lueur 1 | Pertes |
|---|---|---|
| Attendre la 1, puis réveiller | oscillation de 0,32 pendant quelques images | 0 |
| Réveiller d'abord | rien | 0 |
| Suivre la braise du regard | déviation en route, retard | 0 |

Trois causes. Le regard qui réveille la braise était à 315 pt de tout. La braise réveillée est autonome depuis le sommeil ajouté en B1, donc aucun second regard n'était jamais nécessaire, et la géométrie « iris dangereux à nourrir » du rapport n'était jamais exercée. Rien n'était en cours au moment du réveil. Le rapport `416feb9` était donc **techniquement vrai mais pratiquement neutralisé**, et trompeur sur un point : il présentait comme un choix ce qui était le seul chemin. La perception humaine était juste.

## Décision : issue 1

Une correction de level design seul suffit. Le regard qui réveille une braise est un regard ordinaire avec sa zone de 181 pt. La braise dort désormais 120 pt au-dessus de l'iris de la lueur 1, qui monte du bas de l'écran. Réveiller la braise avant que la 1 ne se pose ne coûte rien. La réveiller après chasse la 1, avec perte visible 0,4 à 0,7 s plus tard, iris rouvert, son et impulsion. Vérifié par simulation avec deux points de repos du regard pour que l'effet ne dépende pas d'où vient le curseur.

Ce qui a changé dans B : quatre positions, une phrase d'intro, deux consignes, deux références. Rien d'autre. A, le réglage de braise, le moteur, le Gaze Engine et les 34 niveaux sont identiques octet pour octet au commit testé, et un test fige A champ par champ.

**Dans A, le joueur décide** comment regarder la braise, assez pour l'allumer, pas assez pour l'affoler, puis où poser les yeux pour la laisser venir.

**Dans B, il décide en plus** quand la réveiller, parce que le regard qui la réveille est aussi un regard sur l'iris de la 1 : avant qu'elle ne s'y pose, ou après en la chassant.

Attendre n'est pas gratuit, et il n'existe pas d'esquive spatiale confortable. Le levier est le moment. Point de vigilance documenté : un curseur arrivant du coin haut gauche pousserait la braise vers le centre.

## Vérifications

| Étape | Résultat |
|---|---|
| `git diff --check` | propre |
| Debug simulateur | BUILD SUCCEEDED |
| Tests | 249 exécutés, 249 réussis, 0 échec |
| Release simulateur | BUILD SUCCEEDED |
| Audit | C1, C2, C8, C9, C10, C12 pass, 205 fichiers |
| Debug appareil signé | BUILD SUCCEEDED, `net.steve-s.iris`, `G4U9RG5GL7` |
| Installation et lancement | réussis sur l'iPhone 14 Pro, processus vivant après 8 s |

Tests ajoutés : A figé, portée accrue de l'affolement telle qu'observée par l'humain, géométrie de B, et le scénario prudent contre le scénario conflit avec événements horodatés. Ce dernier prouve l'existence physique du conflit, pas qu'un humain le percevra.

## Git et documents

| | |
|---|---|
| Commit | `ea1cfaec8b3f91d0ae2dcfa11cf28fbeee7a48f5` sur `prototype/braises-b-rework` |
| Baseline humaine | `416feb9` intacte sur `prototype/braises` |
| Rapport | `BRAISES_B_REWORK_REPORT.md` |
| Fiche | `Design/BRAISES_PROTOTYPE_TEST.md`, baseline humaine consignée et nouvelle fiche B |

Ni push ni merge. Pour tester B : jouer deux fois, une fois en attendant la 1, une fois en réveillant la braise d'abord. L'interférence d'apprentissage reste non résolue.

`BRAISES A PRÉSERVÉ — VALIDATION HUMAINE DE RÉFÉRENCE INCHANGÉE.`

`BRAISES B CORRIGÉ TECHNIQUEMENT — NOUVEAU TEST HUMAIN REQUIS.`

`AUCUNE DÉCISION DE CHAPITRE N'A ÉTÉ PRISE.`
~~~~


---

## 2026-09-12 13:58:44 +0200 (11:58:44Z)
`f88478cc` · `45ad43bc` · ligne 2212

~~~~markdown
Mission terminée et commitée sur `prototype/braises-b-ux-audio`. Voici le bilan des deux sujets.

## Audio

**Diagnostic.** La nappe vient de la refonte du 11 septembre, au titre de la direction artistique « chambre noire » : deux sinus graves en quinte, gain 0,012, une fondamentale par chapitre, produits par le synthétiseur et lancés à chaque activation de l'écran de jeu. Elle ne vient pas du prototype HTML et ne porte aucune information de jeu. Elle sonne sourd parce que des sinus purs de 98 à 147 Hz n'ont pas de timbre sur le haut-parleur d'un iPhone. Un seul réglage « Son » coupait à la fois son démarrage et tous les cues.

**Décision.** Deux réglages dans la même carte : **Effets sonores**, activés par défaut, et **Ambiance sonore**, coupée par défaut. La nappe est conservée mais plus imposée, en attendant un retravail du timbre ou un second test. Le moteur audio ne démarre que si l'un des deux est actif. Synthétiseur, politique sonore, service audio et haptique inchangés.

**Migration** de l'ancien réglage sans rien rallumer : coupé reste tout coupé, activé garde sa nappe, absent reçoit les nouveaux défauts. Conséquence pour toi : ayant coupé « Son », tu retrouveras tout coupé et devras activer une fois « Effets sonores ». C'est voulu.

Vérifié par quatre tests de routage et trois cas de migration.

## Braises B

**Diagnostic de lisibilité.** Avant sa première erreur, le joueur n'avait aucune chance raisonnable de comprendre que le moment du réveil était l'enjeu. Rien ne nommait le temps comme variable. Les numéros, l'ordre imposé et cinq chapitres d'habitude disaient « d'abord la 1 ». La zone d'attention est invisible par principe. Le niveau dure 5 à 8 s. Et la consigne après la perte contredisait la leçon de A sans dire « avant quoi ».

**Correction minimale**, textes uniquement, ni géométrie ni physique :
- carte d'intro : « Réveillez la braise avant que la 1 n'atteigne son iris. »
- départ : « Trop tard, votre regard chassera la 1. »
- première perte : « Trop tard : votre regard sur la braise a chassé la 1. »

Trois phrases, 27 mots. Ce texte sert à évaluer le prototype, pas à préjuger d'un tutoriel final.

**Décision versus règle.** Une fois la règle comprise, la stratégie est déterministe : réveiller tôt ne coûte rien de structurel, attendre coûte toujours une perte, et aucun état du niveau ne rend l'attente préférable. Aucune seconde option n'a été fabriquée. Une piste est notée sans être conçue : un arbitrage n'existerait que si réveiller trop tôt avait aussi un coût naturel. Le coût des trois itérations n'entre pas dans ce jugement, et aucune taille de chapitre n'en est déduite.

## Vérifications

| Étape | Résultat |
|---|---|
| A, moteur Braises, Gaze Engine, campagne, audio bas niveau, haptique | identiques à `416feb9` |
| Debug et Release simulateur | BUILD SUCCEEDED |
| Tests | 253 exécutés, 253 réussis, 0 échec |
| Audit | C1, C2, C8, C9, C10, C12 pass, 205 fichiers |
| Appareil | build signé, installation et lancement réussis sur l'iPhone 14 Pro |

Commit `aeafc28cd0b38147c9d45db166724dc6d454629d`, arbre propre, ni push ni merge. `416feb9` et `ea1cfae` intacts. Rapport : `BRAISES_B1_2_AUDIO_UX_REPORT.md`. Fiche de test : `Design/BRAISES_PROTOTYPE_TEST.md`, section B1.2, dont les deux dernières questions distinguent « compris mais règle optimale » de « vrai arbitrage ».

`BRAISES A PRÉSERVÉ — VALIDATION HUMAINE INCHANGÉE.`

`AMBIANCE ET EFFETS SONORES : SÉPARÉS EN DEUX RÉGLAGES, EFFETS ACTIVÉS PAR DÉFAUT, AMBIANCE CONSERVÉE MAIS COUPÉE PAR DÉFAUT, MIGRATION SANS RALLUMAGE.`

`BRAISES B : FONCTION COMPRISE, MAIS DEUXIÈME PROFONDEUR NON DÉMONTRÉE — LA STRATÉGIE RESTE UNE RÈGLE OPTIMALE PLUTÔT QU'UN ARBITRAGE.`

`AUCUNE DÉCISION DE CHAPITRE N'A ÉTÉ PRISE.`
~~~~


---

## 2026-09-12 14:38:40 +0200 (12:38:40Z)
`f88478cc` · `aed8e3b6` · ligne 2304

~~~~markdown
Mission terminée : diagnostic mesuré, Braises B clos, tout est commité. Voici le bilan.

## Ce qui se passe réellement dans le scénario « trop tard »

J'ai reconstitué le geste avec le moteur réel de l'application, sur 96 scénarios de regard tardif réalistes : trois points de repos, huit décalages du curseur jusqu'à 70 pt dans les quatre directions, fixation fixe ou suivi de la braise, avec ou sans temps de réaction après l'allumage.

| Grandeur | Mesure |
|---|---|
| Perte de validation émise | 80 scénarios sur 96 |
| Sortie maximale de l'iris | médiane 62 pt, cas usuels 45 à 98 pt |
| Durée de la poussée | 0,5 à 1,0 s |
| Perte, retour, revalidation | médiane 1,67 s, cas usuels 1,0 à 2,5 s |
| Fin du niveau | 1,5 à 3 s plus tard qu'en réveillant tôt |
| Scénarios sans aucune perte | 16, curseur 40 à 70 pt au-dessus de la braise |

Concrètement : pendant que le joueur fixe la braise en haut de l'écran, la 1 glisse de deux à cinq diamètres vers le bas pendant une demi-seconde, son iris se rouvre, un glissando et une impulsion jouent, puis elle remonte seule et se revalide en moins de deux secondes. Le retour est automatique, aucune action n'est requise. Et dès que le curseur se pose un peu au-dessus de la braise, cas plausible avec une cible à 150 pt du bord haut et une erreur de calibration verticale, la 1 oscille de 2 à 36 pt sous le seuil de perte : rien n'est signalé. L'hypothèse du §9 de la mission est confirmée dans les deux régimes.

## Pourquoi aucune géométrie ne peut changer cela

Trois faits figés bornent la conséquence. Le regard qui réveille est bref par construction, c'est l'identité validée de A. La fuite et le retour se font à la même vitesse plafonnée, donc toute sortie se répare en un temps égal à la poussée. Le retour est automatique par attraction. L'incident reste donc un blip de 1 à 2,5 s quelle que soit la position de la braise. Le rendre durable exigerait un élément-piège qui retienne la 1, un regard plus long ou plus proche, ou une fixation posée presque sur la 1. Ce sont trois artifices.

## Pourquoi les tests précédents ont conclu à tort

Ils prouvaient l'existence d'un événement de perte dans le cas le plus favorable, sans mesurer son amplitude, sa durée, le caractère automatique du retour, ni la sensibilité à un curseur placé au-dessus de la braise. La simulation était exacte, son interprétation confondait un événement du moteur avec une expérience du joueur.

## Verdict et modifications

**Issue B.** Aucun gameplay, texte, géométrie ni réglage modifié. Deux ajouts hors jeu : un relevé de laboratoire DEBUG affiché pendant les seuls niveaux du chapitre 0, qui montre états, distances, seuils et dernier événement horodaté, pour que ces nombres soient lisibles sur l'iPhone si tu rejoues B une fois, et un test de caractérisation qui fixe le constat dans le dépôt.

Protections vérifiées par diff vide : A, moteur Braises et Gaze Engine identiques à `416feb9`, audio et haptique identiques à `aeafc28`, campagne intacte.

| Étape | Résultat |
|---|---|
| Debug et Release simulateur | BUILD SUCCEEDED |
| Tests | 254 exécutés, 254 réussis, 0 échec |
| Audit | C1, C2, C8, C9, C10, C12 pass, 205 fichiers |
| Appareil | build signé, installation et lancement réussis sur l'iPhone 14 Pro |

Commit `c0709d0fbd62fe79738425c173eabd73c6a1a70a` sur `prototype/braises-b-final-diagnostic`, arbre propre, ni push ni merge. Les trois références précédentes sont intactes. Rapport : `BRAISES_B_FINAL_DIAGNOSTIC_REPORT.md`. Aucune taille de futur chapitre n'est déduite de ce rejet.

`AUDIO VALIDÉ HUMAINEMENT — INCHANGÉ.`

`BRAISES A VALIDÉ HUMAINEMENT — INCHANGÉ.`

`BRAISES B REJETÉ DANS SA FORME ACTUELLE — LA CONSÉQUENCE DU « TROP TARD » NE PEUT PAS ÊTRE RENDUE SIGNIFICATIVE SANS ARTIFICE.`

`AUCUNE NOUVELLE ITÉRATION B1.X NE DOIT ÊTRE CRÉÉE.`

`AUCUNE DÉCISION DE CHAPITRE N'A ÉTÉ PRISE.`
~~~~


---

## 2026-09-12 19:18:56 +0200 (17:18:56Z)
`f88478cc` · `57b6a3ab` · ligne 2395

~~~~markdown
Consolidation terminée. La baseline est construite, vérifiée et commitée ; rien n'a été fusionné ni poussé.

## Git

| | |
|---|---|
| Branche | `baseline/iris-expansion-validated` |
| Ancêtre utilisé | `937d5497f2f82ebad42f3c2d3c883f99d7127113`, vérifié : dernier commit propre avant Braises, contient l'haptique validé et Iris v2, aucun fichier Braises |
| Commit 1 | `194dcd1e6dbcc0d51fccb8518ff2bbb9bf5eb71d` `prototype: preserve validated Braises A` |
| Commit 2 | `4d78ce83ef93200386ae4acc78b79d4ce71c20c7` `feat: preserve validated audio separation` |
| Commit 3 | `d7e3a88eadb59b3bfe50ad0acf64ee6182a9ff24` `docs: record validated expansion baseline` |
| Working tree | propre, index vide |

L'ascendance des six commits est linéaire, sans fusion. `main` reste sur `52f20b7`, `feature/game-expansion` sur `937d549`, les quatre branches `prototype/*` restent des archives intactes.

## Accepté

- **Braises A**, transplanté depuis `416feb9` sans B : diff vide sur tous les fichiers de support, bloc de définition identique caractère pour caractère, réglages figés par test.
- **Audio séparé**, transplanté depuis `aeafc28` sans les textes et tests B : diff vide sur les fichiers audio, préférences et tests. Effets activés et ambiance coupée par défaut, migration sans rien rallumer.

## Rejeté et absent

Braises B, les itérations B1.1 à B1.3, la fiche et les rapports B, l'instrumentation de laboratoire et les tests spécifiques. Vérifié dans le code : aucune référence à `BraisesPrototype.b`, « deux feux », `0-2` ou au relevé de laboratoire ; `BraisesPrototype.levels` ne contient que `0-1` ; un seul bouton de prototype dans les réglages. Statut et motifs, dont l'essai propre à 4,00 / 7,96 / 8,27 / 16,10 s sans perte : `Design/BRAISES_VALIDATION_STATUS.md`.

## Hypothèse documentée

Distance visage-iPhone d'environ 30 cm subjectivement plus favorable au calibrage, bras tendu plus difficile. Statut : **non vérifié**, hypothèse humaine. Aucune modification du Gaze Engine. `Design/GAZE_CALIBRATION_DISTANCE_HYPOTHESIS.md` décrit la limite des données actuelles et un protocole futur possible.

## Protections

Gaze Engine, synthétiseur, service audio, physique de référence et campagne identiques à `937d549`. Seule la politique haptique diffère, par les trois événements de braise qu'elle ignore, support d'A identique à `416feb9`. Six chapitres, 34 niveaux, mêmes identifiants et ordre. Aucun StoreKit, aucun réseau.

## Tests et builds

| Étape | Résultat |
|---|---|
| Tests | 251 exécutés, 251 réussis, 0 échec, 0 ignoré |
| Debug et Release simulateur | BUILD SUCCEEDED |
| Audit | C1, C2, C8, C9, C10, C12 pass, 205 fichiers |
| Appareil | build signé, installation et lancement réussis sur l'iPhone 14 Pro, processus vivant après 8 s |

L'accès Braises A et les deux réglages audio sont ceux du code compilé et installé ; aucune validation humaine n'a été refaite. Rapport : `VALIDATED_EXPANSION_BASELINE_REPORT.md`.

`BASELINE IRIS EXPANSION CONSOLIDÉE — BRAISES A ET AUDIO VALIDÉS CONSERVÉS.`

`BRAISES B B1.X REJETÉ — ABSENT DU RUNTIME CONSOLIDÉ.`

`HYPOTHÈSE DE DISTANCE DE CALIBRATION DOCUMENTÉE — AUCUNE MODIFICATION DU GAZE ENGINE.`

`6 CHAPITRES / 34 NIVEAUX OFFICIELS INCHANGÉS.`

`AUCUN MERGE, AUCUN PUSH.`

`HEAD FINAL : d7e3a88eadb59b3bfe50ad0acf64ee6182a9ff24`

`CE HEAD EST LE POINT DE DÉPART AUTORITATIF DES PROCHAINS PROTOTYPES D'EXPANSION.`
~~~~


---

## 2026-09-12 19:39:25 +0200 (17:39:25Z)
`f88478cc` · `6ddead69` · ligne 2447

~~~~markdown
# IRIS — AUDIT S0 AVANT SAUVEGARDE GITHUB

Audit local terminé, en lecture seule. Aucune commande réseau, aucun commit, aucun tag, aucun fichier du dépôt touché.

## 1. Intégrité initiale

| | |
|---|---|
| Dépôt | `/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris` |
| Branche | `baseline/iris-expansion-validated` |
| HEAD | `d7e3a88eadb59b3bfe50ad0acf64ee6182a9ff24` |
| Working tree | propre, index identique à HEAD |

## 2. Baseline autoritative

`baseline/iris-expansion-validated` pointe exactement sur `d7e3a88eadb59b3bfe50ad0acf64ee6182a9ff24`. Le commit existe localement. Elle contient `main`, `feature/iris-v2` et `feature/game-expansion` comme ancêtres.

## 3. Remotes locaux

Un seul remote, `origin`, en HTTPS vers `github.com/ProdX0x/iris-ios.git`, sans identifiant ni jeton dans l'URL, sans `pushurl` distinct. Le stockage des identifiants passe par `credential.helper osxkeychain`, donc hors du dépôt. Les refs de suivi locales, `origin/main` et `origin/feature/iris-v2`, sont sur `6e1b726` d'après la dernière synchronisation connue. Aucun contact réseau n'a été fait pour le vérifier.

## 4. Branches

Huit branches locales. Aucune n'est une fusion ; toutes descendent linéairement de `52f20b7`.

| Branche | HEAD | Rôle | Classe | Recommandation S1 |
|---|---|---|---|---|
| `baseline/iris-expansion-validated` | `d7e3a88` | baseline validée, point de départ des prototypes | A | pousser |
| `main` | `52f20b7` | Iris v2 officiel, 1 commit devant `origin/main` | A | pousser, fast-forward attendu côté distant |
| `feature/iris-v2` | `52f20b7` | identique à `main`, upstream existant | C | facultatif, redondante |
| `feature/game-expansion` | `937d549` | jalon phase A, contenue dans la baseline | C | facultatif, nom de jalon seulement |
| `prototype/braises` | `416feb9` | Braises A validé humainement, B v1 | B | archiver |
| `prototype/braises-b-rework` | `ea1cfae` | B1.1, version testée humainement | B | archiver |
| `prototype/braises-b-ux-audio` | `aeafc28` | source de la séparation audio validée, B1.2 | B | archiver |
| `prototype/braises-b-final-diagnostic` | `c0709d0` | diagnostic final et rejet de B, contient les trois précédentes | B | archiver |

Les quatre branches prototype partagent leurs objets : la dernière contient les quatre commits, les trois autres n'apportent que des noms de repère cités par la documentation. Aucun push forcé n'est requis : tout est nouvelle ref ou fast-forward, sur la base de la dernière synchronisation connue.

## 5. Tags

Aucun tag local. `baseline-expansion-v1` est disponible ; sa cible `d7e3a88…` existe. Il n'a pas été créé.

## 6. Fichiers actuellement suivis

279 fichiers. Aucun fichier `.p8`, `.p12`, `.pfx`, `.pem`, `.key`, `.mobileprovision`, `.provisionprofile`, `.env`, ni `xcuserdata`, `xcuserstate`, `DerivedData`, `.xcarchive`, `.DS_Store`, log ou artefact de build. Les seuls noms évoquant un secret sont des faux positifs : `CameraAuthorizationService.swift` et le dossier `DesignSystem/Tokens`. Deux archives tierces sont suivies à la racine, voir § 12.

## 7. Historique

Refs scannées : les huit `refs/heads/*`, aucun tag. 12 commits, 726 objets, 445 blobs, 307 chemins distincts ayant existé. Recherche par nom : aucun fichier de clé, profil, environnement, trousseau ni bruit Xcode n'a jamais été commité ; seuls les deux `.zip` ressortent. Recherche par contenu sur les 445 blobs : aucun en-tête de clé privée, aucun jeton GitHub, AWS, Slack ou Google, aucune clé App Store Connect, aucune affectation nommée de type clé ou mot de passe, aucune chaîne à forte entropie en contexte d'authentification. Le contenu des deux archives a été scanné de la même façon, par nom d'entrée et par motif, sans résultat. Aucune valeur n'a été affichée.

## 8. Scanner

`gitleaks`, `git-secrets` et `trufflehog` absents. Rien n'a été installé. Couverture de **niveau B** : Git, scan historique par noms, scan par motifs et heuristique d'entropie via un script Python temporaire, exécuté localement puis supprimé. `gh` est présent mais n'a pas été invoqué.

## 9. `.gitignore`

Présent : `.DS_Store`, `xcuserdata/`, `DerivedData/`, `*.ipa`, `*.dSYM`, `*.xcworkspace`, SPM, Pods, Carthage, fastlane. Manquant : `*.xcarchive`, `build/`, `*.p8`, `*.p12`, `*.pfx`, `*.pem`, `*.key`, `*.mobileprovision`, `*.provisionprofile`, `.env` et `.env.*`, `*.xcuserstate` explicite. Aucune modification effectuée. Un `.gitignore` ne purge jamais l'historique.

## 10. Git LFS

Non utilisé : pas de `.gitattributes`, aucune clé `lfs.*` dans le dépôt, aucun pointeur LFS parmi les blobs. Seules des clés `filter.lfs.*` globales existent sur la machine.

## 11. Hooks locaux

Aucun hook actif, `core.hooksPath` par défaut. Rien à craindre côté `pre-push` en S1.

## 12. Risques

### CRITIQUE

Aucun.

### À EXAMINER

- **Deux archives tierces suivies depuis le commit initial** : `SwiftUI-Agent-Skill-main.zip` et `ios-app-skills.zip`, présentes dans les huit branches, non utilisées par le build. Contenu : documentation, scripts Python et YAML de packs de skills, un fichier LICENSE chacun, aucun motif de secret, aucune archive imbriquée. La question n'est pas la sécurité mais la pertinence et le droit de redistribution dans un dépôt potentiellement public. Elles resteront dans l'historique quoi qu'il arrive, car la réécriture est exclue.
- **Adresse e-mail iCloud de l'auteur** dans les métadonnées des 12 commits. Ce n'est pas un secret, mais elle sera visible si le dépôt est public, et elle ne peut pas être changée sans réécrire l'historique. Point S1 concret : si l'option GitHub « bloquer les pushs qui exposent mon e-mail » est active sur le compte, le push sera refusé.
- **Liens de session Claude** dans 10 messages de commit. Non exploitables sans le compte, mais permanents et publics si le dépôt l'est.

### BÉNIN / HYGIÈNE

- Team ID `G4U9RG5GL7`, identifiants `net.steve-s.iris`, et `NKN63DTRM4`, identifiant personnel figurant dans le nom des certificats, cités dans le README et les docs : non secrets.
- Mentions des mots secret, jeton, mot de passe dans la prose des docs et de l'audit : descriptives, sans valeur associée.
- `contents.xcworkspacedata` suivi malgré la règle `*.xcworkspace` : inoffensif.
- Deux versions de `AppIcon.png` dans l'historique, 1,9 Mo au total : poids seulement.
- Fichiers `.DS_Store` présents localement mais ignorés et jamais commités.
- Un blob pendant et 21 entrées de reflog : non atteignables depuis les refs, non poussés.

## 13. Limites de couverture

Aucun scanner spécialisé n'était disponible. Les motifs couvrent les formats courants de clés privées, jetons GitHub, AWS, Slack, Google, App Store Connect, et les affectations nommées ; une chaîne aléatoire sans contexte reconnaissable, un secret dans un format exotique ou un secret chiffré échapperaient à ces méthodes. Conclusion autorisée : **aucun secret critique détecté dans le périmètre et selon les méthodes décrites.**

## 14. Périmètre S1 recommandé

- **À pousser impérativement** : `baseline/iris-expansion-validated`, `main`.
- **À archiver** : les quatre branches `prototype/braises*`.
- **À exclure ou facultatif** : `feature/iris-v2` et `feature/game-expansion`, redondantes.
- **Tag futur** : `baseline-expansion-v1`, annoté, cible `d7e3a88eadb59b3bfe50ad0acf64ee6182a9ff24`.
- **Avant S1, à ta décision** : sort des deux archives ZIP, visibilité du dépôt, réglage e-mail GitHub.

## 15. Intégrité finale

Branche, HEAD, refs, index et working tree comparés à l'instantané initial : identiques. Aucun tag créé ni modifié, aucun remote ajouté ni modifié, aucun fetch, aucun push, aucune connexion GitHub, aucun fichier du dépôt modifié. Les scripts et instantanés temporaires ont été supprimés.

## 16. Verdict

`AUDIT S0 PROPRE — AUCUN SECRET CRITIQUE DÉTECTÉ DANS LE PÉRIMÈTRE AUDITÉ — PRÊT POUR DÉCISION S1.`

`AUCUN PUSH EFFECTUÉ.`

`AUCUN REMOTE CONTACTÉ.`

`AUCUN HISTORIQUE RÉÉCRIT.`

`AUCUNE MODIFICATION DU DÉPÔT EFFECTUÉE.`

`BASELINE AUTORITATIVE : d7e3a88eadb59b3bfe50ad0acf64ee6182a9ff24.`

`S0 PROPRE — PRÊT POUR DÉCISION S1.`
~~~~


---

## 2026-09-12 20:24:22 +0200 (18:24:22Z)
`f88478cc` · `1ed18636` · ligne 2500

~~~~markdown
# IRIS — S1 SAUVEGARDE GITHUB

Sauvegarde privée effectuée et vérifiée à distance, sans force, sans commit, sans réécriture.

## 1. Dépôt distant

| | |
|---|---|
| Owner | `ProdX0x` |
| Repository | `iris-ios` |
| Visibilité | `PRIVATE`, vérifiée par `gh` avant et après les pushs, non archivé |

## 2. Snapshot avant fetch

Huit branches locales, aucun tag, deux refs distantes mémorisées : `origin/main` et `origin/feature/iris-v2` sur `6e1b726`. Remote `origin` confirmé sur `github.com/ProdX0x/iris-ios.git`, sans identifiant dans l'URL.

## 3. Fetch

Réussi, sans prune ni pull. Seul changement observé : apparition de `refs/remotes/origin/HEAD`. Branches locales, HEAD, index et working tree strictement identiques à l'instantané. L'état réel du distant correspondait à l'état mémorisé.

## 4. Divergence main

| Sens | Résultat |
|---|---|
| `origin/main..main` | 1 commit local, `52f20b7` |
| `main..origin/main` | 0 commit distant inconnu |
| Ascendance | `origin/main` est ancêtre de `main` |

## 5. Autres branches

| Branche | Distante avant | Verdict |
|---|---|---|
| `baseline/iris-expansion-validated` | absente | création simple |
| `prototype/braises` | absente | création simple |
| `prototype/braises-b-rework` | absente | création simple |
| `prototype/braises-b-ux-audio` | absente | création simple |
| `prototype/braises-b-final-diagnostic` | absente | création simple |
| `feature/game-expansion` | absente, jalon `937d549` confirmé | création simple |
| `feature/iris-v2` | existante sur `6e1b726`, ancêtre, sans divergence | non poussée, redondante avec `main` |

## 6. Licences ZIP

| Archive | Licence | Classification |
|---|---|---|
| `SwiftUI-Agent-Skill-main.zip` | MIT, copyright Antoine van der Lee | clairement permissive, notice incluse dans l'archive |
| `ios-app-skills.zip` | MIT, copyright Stéphane Steve Saulnier, ProdX0x | clairement permissive, œuvre propre |

Aucune restriction pour une sauvegarde privée.

## 7. Portes

- A, dépôt privé : PASS
- B, Git : PASS
- C, licences : PASS

## 8. Tag

`baseline-expansion-v1` créé localement, annoté, objet `788da20a5e034e630e2208b1ab6906ab96f98e8d`, cible peeled `d7e3a88eadb59b3bfe50ad0acf64ee6182a9ff24`. Poussé seul, par refspec ciblé, jamais `--tags`. Vérifié à distance : objet et cible peeled identiques.

## 9. Branches poussées

| Branche | HEAD local | HEAD distant vérifié | Statut |
|---|---|---|---|
| `baseline/iris-expansion-validated` | `d7e3a88` | `d7e3a88` | nouvelle |
| `main` | `52f20b7` | `52f20b7` | fast-forward depuis `6e1b726` |
| `prototype/braises` | `416feb9` | `416feb9` | nouvelle |
| `prototype/braises-b-rework` | `ea1cfae` | `ea1cfae` | nouvelle |
| `prototype/braises-b-ux-audio` | `aeafc28` | `aeafc28` | nouvelle |
| `prototype/braises-b-final-diagnostic` | `c0709d0` | `c0709d0` | nouvelle |
| `feature/game-expansion` | `937d549` | `937d549` | nouvelle |

Chaque ref a été relue par `ls-remote` après son push.

## 10. Branches non poussées

`feature/iris-v2` : identique à `main`, reste sur `6e1b726` côté distant. Aucune raison technique de la mettre à jour.

## 11. Informations privées historiques

Adresse e-mail iCloud de l'auteur et liens de session Claude conservés dans l'historique, aucune réécriture. GitHub n'a opposé aucune protection d'e-mail. Ces éléments sont désormais hébergés sur un dépôt confirmé privé : ne pas le rendre public sans décision explicite.

## 12. Intégrité locale

Branche `baseline/iris-expansion-validated`, HEAD `d7e3a88eadb59b3bfe50ad0acf64ee6182a9ff24`, working tree propre, index identique, branches locales identiques à l'instantané, aucun commit créé. Seuls ajouts locaux : le tag annoté et les refs de suivi distantes.

## 13. Sauvegarde

`d7e3a88eadb59b3bfe50ad0acf64ee6182a9ff24` est confirmé présent sur GitHub, à la fois comme HEAD de `baseline/iris-expansion-validated` et comme cible du tag `baseline-expansion-v1`.

`S1 TERMINÉ — SAUVEGARDE GITHUB PRIVÉE VÉRIFIÉE.`

`BASELINE DISTANTE CONFIRMÉE : d7e3a88eadb59b3bfe50ad0acf64ee6182a9ff24.`

`TAG DISTANT CONFIRMÉ : baseline-expansion-v1.`

`MAIN SAUVEGARDÉ SANS FORCE.`

`ARCHIVES BRAISES SAUVEGARDÉES.`

`AUCUN HISTORIQUE RÉÉCRIT.`

`AUCUN FORCE PUSH EFFECTUÉ.`

`WORKING TREE PROPRE.`

`IRIS EST DÉSORMAIS SÉCURISÉ PAR UNE SAUVEGARDE DISTANTE DE LA BASELINE VALIDÉE.`
~~~~


---

## 2026-09-13 03:03:53 +0200 (01:03:53Z)
`f88478cc` · `6c920cc3` · ligne 3747

~~~~markdown
# Rapport final — expansion intégrale

**Campagne : 12 chapitres, 66 niveaux, 198 éclats** (branche `feature/iris-full-expansion`, depuis `baseline-expansion-v1`).

- **VII jumelles** (6 niveaux) : l'une est l'iris de l'autre ; à portée elles se rejoignent seules. TECHNIQUEMENT VALIDÉ / À JOUER HUMAINEMENT.
- **VIII souffles** (6) : un souffle périodique emporte par-dessus les voiles ; placer la lueur sur la piste, puis ne plus la regarder. TECHNIQUEMENT VALIDÉ / À JOUER HUMAINEMENT.
- **IX échos** (6) : les dormeuses ne se réveillent que par l'anneau d'un iris qui se ferme ; un iris fermé respire. TECHNIQUEMENT VALIDÉ / À JOUER HUMAINEMENT.
- **X gouffres** (6) : ce qui entre dans la bouche revient au départ ; l'aspiration se sent avant. TECHNIQUEMENT VALIDÉ / À JOUER HUMAINEMENT.
- **XI braises** (6) : la braise validée humainement (réglage A gelé) dans la campagne, seule, à deux, en courant, derrière un voile, avec une dormeuse, dans l'ordre. TECHNIQUEMENT VALIDÉ / À JOUER HUMAINEMENT.
- **XII constellation** (6) : synthèse, jusqu'au dernier iris réveillé par l'écho du rendez-vous des jumelles. TECHNIQUEMENT VALIDÉ / À JOUER HUMAINEMENT.

Idée écartée en production : Phares (attente sans décision). Chaque idée retenue a sa preuve de nécessité par simulation (ablation, politique aveugle ou évitement).

**Chapitres 1–6 / 34 niveaux : INCHANGÉS.** Empreinte octet pour octet (`Tests/IrisTests/Fixtures/historical_campaign.txt`, 900 lignes) et SHA-256 des sources gelées (chapitres historiques, Gaze Engine, filtre de regard, intégrateur physique). Audio, haptique, progression : aucun nouveau son ni pulsation, défauts Effets ON / Ambiance OFF préservés.

**Tests** : 298 exécutés, 298 réussis (dont 44 suites, 8 suites d'expansion et protection). Audit C1/C2/C8/C9/C10/C12 : pass. `git diff --check` : propre. Debug simulateur et **Release iOS signé** : BUILD SUCCEEDED.

**iPhone 14 Pro** : injoignable (`unavailable`) pendant toute la mission ; l'installation Release a été tentée et a échoué faute d'appareil. Aucun niveau nouveau n'a été lancé sur appareil.

**Git** : 8 commits atomiques (`19f2b1c` infrastructure, un par chapitre, `4bdb0ae` docs), poussés normalement sur `origin/feature/iris-full-expansion` (= HEAD). `main` 52f20b7, `baseline/iris-expansion-validated` d7e3a88 et le tag `baseline-expansion-v1` sont intacts, localement et à distance.

**À juger humainement** : le rythme des souffles, la portée et la fusion des jumelles, la lisibilité des anneaux d'écho, la dureté du renvoi au départ, l'équilibre du chapitre XII, les lavis de couleur par chapitre. Détails : `Design/IRIS_FULL_EXPANSION_REPORT.md`, README §19.
~~~~


---

## 2026-09-14 01:04:55 +0200 (23:04:55Z)
`f88478cc` · `01d957f0` · ligne 4071

~~~~markdown
Tout est vérifié. Rapport final.

# Niveau 6

- créé : `1-6 · le fil des balises`, chapitre I, optionnel (il ne retient pas le chapitre II), proposé après le niveau 5 et visible sur la carte.
- principe de gameplay : l'iris du centre est éteint ; cinq balises dorment (centre, droite, gauche, haut, bas). Seule la balise que le fil désigne respire et s'éveille sous un regard posé ; elle tend un fil vers la suivante et entrouvre l'iris. Le fil complet ouvre l'iris et libère une lueur qui le rejoint comme au niveau 1. Aucune direction n'est jamais nommée au joueur.
- pattern : centre → droite → gauche → centre → haut → bas → centre, puis droite/gauche ×2, haut/bas ×2, centre (16 étapes). Balises à 0,82 / 0,18 en x et 0,16 / 0,84 en y, zone d'acquisition de 79 pt avec hystérésis.
- dwell : 0,25 s (paramètre de jeu expérimental, dans la plage 150–350 ms).

# Décrochage existant

- mécanisme historique identifié : `GameViewModel.tick` compte 0,3 s sans visage, arrête la boucle et passe en `.faceLost` ; overlay « visage perdu » de `GameOverlayView` ; reprise automatique au retour du visage. Plus R-23 dans `GameSession.updateAttention` (iris fermés au-delà de 6 % hors viewport).
- comportement modifié : NON
- avertissement historique préservé : oui, aucune ligne de ce chemin touchée ; la trace ne fait qu'observer les états déjà émis.
- test anti-régression : `OculomotorTraceTests.faceLostUnchanged` (niveaux 1 et 6 comparés) et `attentionOffFieldUnchanged`.

# Instrumentation

- VALID_INSIDE : projection calibrée dans le viewport.
- VALID_OUTSIDE si réellement disponible : oui, le mapper produit une projection hors viewport, écrêtée à ±50 % (signalée `capped` sur la butée).
- INVALID : aucune projection (rayon n'atteignant pas le plan) ou visage perdu.
- dernière position valide : journalisée à chaque sortie.
- direction de sortie : depuis la projection si elle existe, sinon la dernière direction observée, seulement si la dernière position valide était dans le tiers extérieur de ce côté ; aucune position hors écran inventée.
- durée de perte : journalisée, avec la position de réentrée.
- yaw : oui, par échantillon, au départ et à l'acquisition de chaque transition, avec delta.
- pitch : idem ; roll enregistré.
- données oculaires ARKit supplémentaires si utilisées : yeux gauche/droit et lookAt (repère vue) exposés par un champ optionnel `observation` du sample. Deux fichiers `AR/` ont chacun un ajout purement additif ; le calcul du regard ne le lit pas ; les hashes gelés sont mis à jour délibérément avec cette raison.

Journal : `log stream --predicate 'subsystem == "net.steve-s.iris" AND category == "oculotest"'`. Le prototype nécessite un build **Debug** sur l'appareil.

# Protection

- niveaux 1–5 inchangés : oui (`Campaign+Eveil.swift` gelé, empreinte historique intacte).
- Chapitres II–XII inchangés : oui.
- Gaze Engine inchangé : aucune ligne de calcul, de filtre, de seuil ni d'état modifiée.
- calibration inchangée : oui.
- système de décrochage inchangé : oui.

# Tests

- exécutés : 320
- réussis : 320
- échoués : 0
- ignorés : 0
- Debug : BUILD SUCCEEDED (simulateur et appareil signé)
- Release : BUILD SUCCEEDED (iOS signé)

Ablations automatiques : regard central, attente, regard aléatoire (3 graines), passages de 130 ms, mauvais ordre, horizontal seul, vertical seul : aucun ne gagne. Séquence correcte scriptée : gagne ; bot guidé : 3/3 en 11 s ; évitement et hors écran : jamais. Audit C1–C12 : pass. `git diff --check` : propre.

# iPhone

- installé : oui, build Debug signé (`net.steve-s.iris`, `G4U9RG5GL7`) sur l'iPhone 14 Pro.
- lancé : oui, processus vivant après 8 s.
- Niveau 6 accessible : par construction et par test (après le 5, et sur la carte) ; à confirmer à l'écran par le joueur.

# Git

- branche : `prototype/ch1-oculomotor-level6`
- commit : `c452c01` — `prototype: add Chapter I oculomotor level 6`
- HEAD : `c452c01380e80a13b2b31132f8625123f8588b63`
- push : cette branche seule, sans force ; distant = HEAD.
- `iris-expansion-human-validated-v1` intact : oui (4bdb0ae, local et origin).
- `feature/iris-full-expansion` intact : oui (4bdb0ae, local et origin).
- `main` intact : oui (52f20b7, local et origin).

Note : les documents tagués annonçaient « 66 niveaux / 198 éclats » ; le total réel des 12 chapitres est 70 niveaux / 210 éclats. Corrigé sur cette branche seulement. Protocole du test humain et diagnostic à cinq cas : `Design/OCULOMOTOR_LEVEL6_PROTOTYPE.md`.

`CHAPITRE I — NIVEAU 6 OCULOMOTEUR PRÊT POUR TEST HUMAIN.`
~~~~


---

## 2026-09-14 09:54:01 +0200 (07:54:01Z)
`f88478cc` · `0e1938ce` · ligne 4606

~~~~markdown
Les 11 niveaux finaux sont construits, testés (385 tests, 0 échec) et poussés sur `feature/iris-oculomotor-expansion`. Ils ont été installés et lancés sur l'iPhone 14 Pro, mais aucun n'a encore été joué par un humain.

### GIT

- **branche :** `feature/iris-oculomotor-expansion`, créée depuis `iris-ch1-oculomotor-human-validated-v1`.
- **HEAD :** `93326de25380bcd2ae3fc26e34195f3ab94b7de8`
- **commits :** 14 au total.
  - `77e86c2` : infrastructure partagée et protection des niveaux validés.
  - Un commit par chapitre, de `5068e2f` (II) à `66b0d71` (XII).
  - `27c2fac` : horloge propre à chaque étape, pour que les passages enchaînés de la finale XII démarrent correctement.
  - `93326de` : documentation.
- **push :** normal, sans force ; le distant est égal à HEAD.
- **tag source :** `iris-expansion-human-validated-v1` → `4bdb0ae`, intact.
- **tag Chapitre I validé :** `iris-ch1-oculomotor-human-validated-v1` → `c452c01`, créé et poussé en début de mission.
- `main` (`52f20b7`), `feature/iris-full-expansion` (`4bdb0ae`), `prototype/ch1-oculomotor-level6` (`c452c01`) et `baseline-expansion-v1` sont intacts, en local comme sur origin.

### AUDIT INITIAL

| Chapitre | Niveaux avant | Niveau ajouté |
|---|---|---|
| I éveil | 6 (5 historiques + 1-6 validé) | aucun |
| II partage | 5 | 2-6 |
| III courants | 6 | 3-7 |
| IV voiles | 6 | 4-7 |
| V veilleuses | 6 | 5-7 |
| VI clairvoyance | 6 | 6-7 |
| VII jumelles | 6 | 7-7 |
| VIII souffles | 6 | 8-7 |
| IX échos | 6 | 9-7 |
| X gouffres | 6 | 10-7 |
| XI braises | 6 | 11-7 |
| XII constellation | 6 | 12-7 |

La campagne passe de 71 à 82 niveaux. Aucun niveau n'a été renuméroté. Chaque niveau ajouté est optionnel et ne bloque jamais le chapitre suivant.

### NOUVEAUX NIVEAUX

| Niveau | Nom | Paradigme | Principe de jeu | Ablations qui échouent |
|---|---|---|---|---|
| 2-6 | le cœur de verre | fixation stable, distracteurs | un cœur se réchauffe sous un regard qui reste ; suivre une étincelle le refroidit | quitter le cœur par intermittence, chasser les étincelles, aléatoire |
| 3-7 | le fil vivant | poursuite lisse | le fil d'une étincelle en mouvement continu reste vivant tant qu'on l'accompagne | centre, point fixe sur la boucle, aléatoire |
| 4-7 | le miroir menteur | anti-saccade | un éclat d'un côté, la porte s'ouvre en face ; suivre l'éclat relance le cycle | suivre le leurre, centre, aléatoire |
| 5-7 | les étoiles absentes | saccades guidées par la mémoire | les étoiles reviennent là où le regard retourne après leur disparition | regard fixe, aléatoire |
| 6-7 | le jardin caché | recherche visuelle | parmi des graines qui scintillent, celles qui respirent poussent sous le regard | centre, coin, balayage qui s'attarde, aléatoire |
| 7-7 | la danse croisée | saccades diagonales | les jumelles s'appellent d'un coin à l'autre, près puis loin, sur les deux diagonales | un quadrant, centre, alternance gauche-droite |
| 8-7 | la lanterne du courant | poursuite prédictive | la lanterne disparaît dans la brume ; il faut être là où elle ressort | joueur réactif figé, attente à une sortie, aléatoire |
| 9-7 | l'absence | désengagement (gap / overlap) | tenir une présence, puis rejoindre la réponse, après un silence ou pendant qu'elle brille encore | ne jamais quitter, partir trop tôt, aléatoire |
| 10-7 | l'ancre | stabilisation du regard, inspirée du VOR | yeux sur l'ancre, petits mouvements de tête pour pousser la boussole dans l'arc | regard seul, tête seule, tête toujours du même côté |
| 11-7 | d'abord les yeux | coordination œil-tête | des braises au bord ; yeux puis tête donne toute la chaleur, tête d'abord la moitié, yeux seuls un tiers | regard qui n'atteint pas les braises, tête sans les yeux |
| 12-7 | l'orchestre du regard | synthèse | sept passages courts, chacun allume une étoile ; la constellation s'anime à la fin | centre, coin, aléatoire |

Chaque niveau reprend l'identité de son chapitre et a son propre visuel. Au niveau 11-7, les trois coordinations progressent mais à des vitesses différentes : il faut 4, 8 ou 12 braises.

Au niveau 10-7, le sens de chaque axe de tête est appris du premier mouvement du joueur. Aucune convention de signe n'est donc supposée.

**Verdict technique :** les 11 niveaux sont TECHNIQUEMENT VALIDÉS. Pour chacun, le joueur simulé guidé gagne sur les 3 graines, et l'évitement comme le regard hors écran échouent.

### CHAPITRE I

- **Niveau oculomoteur validé préservé :** oui. Il est protégé par une empreinte octet pour octet (`expansion_campaign.txt`) et par le SHA-256 de sa source.
- **aucune modification :** confirmé, aucun fichier de niveau validé n'a changé depuis le tag.

### MOTEUR

- **Gaze Engine inchangé :** oui, aucun fichier `AR/` modifié.
- **calibration inchangée :** oui.
- **décrochage inchangé :** oui, les tests « visage perdu » et R-23 existants sont verts.
- **physique historique inchangée :** oui, l'empreinte des chapitres I à VI est intacte.
- Les chapitres VII à XII ont maintenant leur propre empreinte octet pour octet.

### TESTS

- **tests exécutés :** 385
- **réussis :** 385
- **échoués :** 0
- **ignorés :** 0
- **nouveaux tests :** 65 (le tag de départ en comptait 320).
- **anti-régressions :** les deux empreintes (historique et expansion) passent, ainsi que les SHA-256 gelés, la structure jouée et les suites existantes.
- **git diff --check :** propre. L'audit C1 à C12 passe.

### BUILDS

- **Debug :** BUILD SUCCEEDED, sur simulateur et en signé pour l'appareil.
- **Release :** BUILD SUCCEEDED, signé `net.steve-s.iris` / `G4U9RG5GL7`. Il a été construit depuis `66b0d71`, dont le code est identique à HEAD (HEAD n'ajoute que de la documentation).

### IPHONE

- **disponible :** oui, iPhone 14 Pro connecté.
- **installation :** oui. Une étape intermédiaire (chapitres II à VI) a d'abord été installée, puis la version finale.
- **lancement :** oui, le processus était vivant après 10 s.
- **nouveaux niveaux accessibles :** oui dans la campagne normale, vérifié par les tests et par des captures simulateur de 2-6, 4-7, 8-7, 10-7 et 12-7.
  - Personne ne les a ouverts à l'écran sur l'appareil.
  - Le tracking et le décrochage n'ont pas été éprouvés sur l'appareil.
- **Traces DEBUG :** elles n'existent que dans un build Debug. Pour les relever pendant le test, lancer sur le Mac :

```
log stream --predicate 'subsystem == "net.steve-s.iris" AND category == "oculotest"'
```

### À JUGER HUMAINEMENT

- **2-6 le cœur de verre :** les étincelles tentent-elles vraiment ? Six secondes de fixation restent-elles confortables ?
- **3-7 le fil vivant :** la vitesse est-elle confortable ? Voit-on bien le fil s'effilocher ?
- **4-7 le miroir menteur :** la règle se découvre-t-elle au premier cycle, sans frustration ?
- **5-7 les étoiles absentes :** trois étoiles restent-elles un jeu plutôt qu'un test ?
- **6-7 le jardin caché :** la différence entre respirer et scintiller se voit-elle ? Le repli des pousses paraît-il juste ?
- **7-7 la danse croisée :** ressent-on une danse ? Les coins lointains sont-ils confortables ?
- **8-7 la lanterne du courant :** anticipe-t-on la sortie de brume ? La fenêtre de prise est-elle juste ?
- **9-7 l'absence :** sent-on la différence entre le silence et le chevauchement ? Quitter une présence qui brille encore est-il naturel ?
- **10-7 l'ancre :** les mouvements de tête sont-ils petits, sans vertige ? La boussole suit-elle dans le bon sens ? Ce niveau exige l'iPhone : en simulateur, sans données de tête, il ne progresse pas.
- **11-7 d'abord les yeux :** la tête suit-elle naturellement les yeux ? L'écart de chaleur se perçoit-il ?
- **12-7 l'orchestre du regard :** est-ce une finale plutôt qu'un examen ? La constellation vivante récompense-t-elle ?

Détails complets dans `Design/OCULOMOTOR_EXPANSION_REPORT.md` et au README, section 21.

`IRIS — 11 NOUVEAUX NIVEAUX OCULOMOTEURS PRÊTS POUR VALIDATION HUMAINE.`

`LIQUID GLASS N'A PAS ÉTÉ MODIFIÉ DANS CETTE MISSION.`
~~~~


---

## 2026-09-14 11:12:54 +0200 (09:12:54Z)
`f88478cc` · `1bba8651` · ligne 4927

~~~~markdown
**Vérification restante.** La correction est testée, poussée et installée sur l'iPhone 14 Pro. Seul le contrôle visuel sur le téléphone reste à faire par un humain, car je ne peux ni voir ni faire défiler l'écran de l'appareil.

**CAUSE RACINE**
Chaque bouton de niveau avait un cadre fixe de 48 pt, dans une rangée espacée de 8 pt. La largeur minimale de la rangée grandissait donc avec le nombre de niveaux. Sur un iPhone 14 Pro, une carte ne laisse que 297 pt à sa rangée. La carte la plus large élargissait ensuite toute la colonne, ce qui rognait les cartes à gauche et à droite.

| Niveaux | Largeur exigée | Place disponible sur un 14 Pro |
|---|---|---|
| 6 | 328 pt | 297 pt |
| 7 | 384 pt | 297 pt |

À 6 niveaux, le dépassement existait déjà, mais il était caché dans les marges.

**CORRECTION**
- **La rangée prend la largeur offerte, jamais plus.** Une mise en page dédiée calcule la géométrie à partir du conteneur.
- **L'ordre de repli suit la priorité demandée.** D'abord une seule rangée, puis un espacement réduit jusqu'à 4 pt, puis des boutons réduits jusqu'à 44 pt. Ensuite seulement viennent plusieurs rangées équilibrées, la dernière centrée.
- **L'en-tête ne pousse plus la carte.** Le titre et la devise passent à la ligne, et le compteur reste toujours visible.
- **L'identité visuelle ne change pas.** Polices, couleurs et anneaux restent identiques. Il n'y a ni largeur par chapitre, ni décalage, ni défilement horizontal.

| Écran | 6 niveaux | 7 niveaux |
|---|---|---|
| 375 pt | 3 + 3 | 4 + 3 |
| 393 pt, iPhone 14 Pro | une rangée | 4 + 3 |
| 402 pt | une rangée | 4 + 3 |
| 440 pt, Pro Max | une rangée | une rangée |

**TESTS**

| Mesure | Résultat |
|---|---|
| Suite complète | 396 tests, 61 suites |
| Réussis | 396 |
| Échecs | 0 |
| Ignorés | 0 |
| Nouveaux tests de layout | 11 |

- **Nombres de niveaux.** Les tests couvrent 0, 1, 5, 6, 7, 8, 10 et 24 niveaux, sur toutes les largeurs de téléphone.
- **Rendu des cartes.** Les cartes sont rendues à 375, 393, 402 et 440 pt, en texte standard et en texte agrandi. Un test échoue si un rendu dépasse la largeur du téléphone.
- **Chapitres.** Les 12 chapitres sont vérifiés, soit 82 niveaux au total.
- **Contrôles du dépôt.** `git diff --check` est propre, et l'audit du projet passe sur ses 284 fichiers.
- **Pas de tests UI.** Le projet n'a pas de cible de tests UI, et les rendus à largeur réelle en tiennent lieu.
- **Captures réelles sur simulateur.** Elles ont été faites à 402 pt et à 375 pt, en texte standard et en très grand texte. Les zones sûres et la Dynamic Island sont respectées. Les captures des chapitres I, II, III, VI, IX et XII ont été envoyées.

**BUILDS**
- **Build de test.** Il réussit.
- **Release pour iOS générique.** Le build réussit, signé net.steve-s.iris avec l'équipe G4U9RG5GL7.
- **Debug pour l'appareil.** Le build réussit, avec la même signature.

**IPHONE**
Le build Debug est installé sur l'iPhone 14 Pro et lancé directement sur l'écran des chapitres. Aucune progression simulée n'a été envoyée à l'appareil, donc la sauvegarde réelle est intacte.

**PROTECTION**
- **Aucun fichier modifié dans les zones protégées.** Rien n'a changé dans AR, GameEngine, Domain ni dans les fixtures.
- **Suivi du regard intact.** Gaze Engine, calibration, tracking, décrochage, yaw et pitch sont intacts.
- **Campagnes protégées.** Les suites de protection des campagnes historique et d'extension passent, empreintes SHA-256 comprises.
- **Aucun calcul par frame.** La géométrie est recalculée seulement lors des mises en page SwiftUI.

**GIT**

| Élément | Valeur |
|---|---|
| Branche | fix/chapter-card-adaptive-layout |
| Commit | e29cae7, fix: make chapter cards adaptive to level count |
| Parent | 93326de |
| Fichiers | 8, dont 4 nouveaux |
| Push | cette branche seule, sans force |

- **Remote vérifié.** Sur origin, seule la nouvelle branche est apparue. main, les autres branches et les tags validés n'ont pas bougé, et rien n'a été mergé.
- **Disque interne du Mac presque plein.** Il est descendu à 122 Mo libres pendant la mission. J'ai supprimé deux simulateurs et des copies de build créés pendant cette session, et aucune donnée personnelle n'a été touchée.
- **Fichiers de travail.** Les builds, journaux et captures sont désormais sur le SSD, hors du dépôt, dans le dossier `.iris-derived-data`. Ils peuvent être supprimés après la validation.

CARTES DE CHAPITRES — LAYOUT ADAPTATIF PRÊT POUR VALIDATION HUMAINE.
AUCUNE MODIFICATION LIQUID GLASS N'A ÉTÉ EFFECTUÉE.
~~~~


---

## 2026-09-14 16:08:09 +0200 (14:08:09Z)
`f88478cc` · `923ca9f9` · ligne 5524

~~~~markdown
X·7 est corrigé, committé en trois commits ciblés et installé sur l'iPhone 14 Pro. Rien n'a été poussé. Un point reste invérifiable sans vous : que l'anneau suit la tête du bon côté sur le téléphone. Le simulateur ne fournit aucune pose de tête, donc seul un essai réel le confirmera.

**Point de départ**
- Au départ, la branche active était `fix/chapter-card-adaptive-layout`, en e29cae790288fd752fc2e2f0aabd379216b5286e. L'arbre suivi était propre et l'index vide.
- Le seul fichier non suivi était l'image de référence, que la mission demandait de lire.
- Le tag `iris-expansion-human-validated-v1` est présent en local et sur origin, et pointe sur 4bdb0ae210bd2257b1c129ea71e999627c745ed2.
- **Écart avec la mission.** À ce tag, le chapitre X n'a que six niveaux et X·7 n'existe pas. J'ai donc créé `prototype/x7-stabilisation-head-guidance` depuis e29cae7. Ce commit descend du tag, contient X·7 et correspond au build déjà sur l'iPhone.
- Un fichier `SKILL.md` sur l'observabilité DEBUG est apparu à la racine pendant le travail. Je l'ai lu et suivi. Lui et l'image restent non suivis.

**Logique finale de X·7**
1. **Ancrage.** Visage de face, yeux sur le point au centre. La tête reste immobile 0,8 s, puis un son doux confirme le départ.
2. **Départ.** La tête tourne vers la droite et la boucle commence.
3. **Cercle.** Le parcours continu de la tête remplit l'anneau segmenté : droite, haut, gauche, bas. Il ne progresse que vers l'avant, sans saut et à allure bornée. Des poses séparées ou le mauvais sens ne remplissent rien.
4. **Jalons.** Côté de départ, haut, côté opposé et bas donnent chacun un son doux et un éclat lumineux.
5. **Regard tolérant.** Les yeux doivent seulement rester près du point. Un vrai regard ailleurs met l'anneau en pause sans rien effacer, et une perte de suivi ne fait que suspendre.
6. **Retour face.** Il ferme la boucle, avec le signal de validation, puis l'anneau se dissout en poussière d'étoiles.
7. **Boucle inverse.** Même boucle en partant vers la gauche. La lueur rejoint ensuite son iris seule et le niveau se termine.
8. **Orientation de la tête.** Elle est lue dans le repère de l'écran grâce à la correspondance d'axes déjà résolue par la calibration. Aucun signe n'est supposé.

**Silhouette**
- **Tracé.** J'ai relevé le trait néon de `x7_silhouette_reference.png` par balayage de luminance : crâne, oreilles, mâchoire, cou et épaules. Il est devenu un contour vectoriel symétrique et lissé.
- **Rendu.** Il est dessiné en lavande translucide du chapitre X, grand et centré sur le point, avec l'anneau à l'intérieur du visage.
- **Mouvement.** La silhouette se penche doucement avec la tête. Tant que la tête ne bouge pas, elle montre elle-même la boucle à faire.
- **Fidélité.** Une superposition en rouge sur l'image confirme le tracé. L'image n'est pas embarquée, et elle ne contenait ni texte ni bouton.

**Principaux fichiers**
- `GameEngine/Oculo/AncreStageState.swift` : la boucle de tête.
- `Domain/Campaign/Campaign+FinalGouffres.swift` : deux boucles, textes en trois étapes, par de 81 s et 2 intrusions.
- `Features/Game/Rendering/AncreSilhouette.swift` : la silhouette tracée.
- `Features/Game/Rendering/GameSceneRenderer+Ancre.swift` : silhouette, anneau, jalons, point et poussière d'étoiles.
- `Features/Game/Rendering/AncreSceneSnapshot.swift` : la description de scène.
- `Features/Game/ViewModels/GameViewModel.swift` : orientation de la tête et branchement DEBUG.
- `Features/Game/Diagnostics/AncreCapture.swift` : capture JSON Lines, active seulement avec l'argument `--iris-capture`.
- `Design/X7_ANCRE_CORRECTION.md` : la documentation, avec le README, l'ADR-21 et le rapport d'expansion.

**Tests et builds**

| Contrôle | Résultat |
|---|---|
| Suite complète au HEAD final | 406 tests, 62 suites, 0 échec |
| Premier commit seul, dans un worktree | 406 tests, 62 suites, 0 échec |
| Tests X·7 réécrits ou ajoutés | 11 sur le moteur, 4 sur la scène |
| Build Debug simulateur | réussi |
| Builds Release et Debug appareil | réussis et signés |
| Capture DEBUG dans le binaire Release | absente |
| Audit du projet | 7 contrôles au vert |
| Contrôle des espaces du diff | propre |

- **Couverture des tests.** Le joueur idéal gagne, et un regard détourné en cours de boucle n'empêche pas la fin. Aucune variante fautive ne gagne : tête immobile, tête sans les yeux, mauvais sens, poses séparées, absence de tête ou regard aléatoire. Les tests couvrent aussi la tolérance, l'allure bornée et les consignes.
- **Images de contrôle.** Dix moments du niveau ont été rendus et vérifiés visuellement, plus deux captures du simulateur.
- **Correction pendant la vérification.** Les images ont révélé un blocage du joueur simulé après un regard détourné. Je l'ai corrigé et un test le verrouille.

**iPhone.** Le build Debug est installé et tourne, lancé sur l'écran des chapitres avec la capture activée. La vraie progression n'a pas été touchée.

**À juger humainement**
- Le cercle se comprend-il avec la carte, la silhouette et l'anneau ?
- L'amplitude, environ 10° à gauche et à droite et 8° en haut et en bas, est-elle confortable et sans vertige ?
- L'anneau suit-il la tête du bon côté ?
- La tolérance du regard est-elle ni punitive ni triviale ?
- Le suivi du visage tient-il sur toute la boucle ? La trace JSON Lines de la partie se récupère depuis le conteneur de l'app pour l'analyser.

**Reste de l'application.** Aucun fichier AR, Gaze Engine, calibration, fixture, audio ou haptique n'a changé. Les tests d'empreinte des campagnes validées passent, et aucune autre finale n'est modifiée. Les changements partagés restent minimes :
- l'orientation de la tête, qui ne change pas l'amplitude des mouvements lus par 11-7 et 12-7 ;
- un déclencheur d'indice pour une étape terminée et une aide propre au niveau, sans effet ailleurs ;
- les branchements de rendu propres à X·7.

**Git**
- Commits : bd7bddd (le niveau), f51be97 (l'observation DEBUG) et 3abddb7 (la documentation).
- HEAD final : 3abddb732b8ad54c04fe27d9acdd967d49535176.
- Aucun push, comme la mission le demandait. `main`, les branches existantes et les tags validés sont inchangés en local et sur origin.
- Les builds, journaux et images sont sur le SSD dans `.iris-derived-data`, hors du dépôt, et peuvent être supprimés après validation.

X·7 CORRIGÉ — SILHOUETTE DE RÉFÉRENCE INTÉGRÉE — MOUVEMENT CIRCULAIRE DE TÊTE CLARIFIÉ — AUCUNE RÉGRESSION INTENTIONNELLE HORS DE CE NIVEAU.
~~~~


---

## 2026-09-14 21:02:25 +0200 (19:02:25Z)
`f88478cc` · `4f73e9b4` · ligne 5712

~~~~markdown
X·7 fonctionne désormais selon l'option A : les yeux sont vérifiés avant et après les cercles, et la tête seule dessine les cercles. La suite complète passe, les builds sont signés et le build est installé sur l'iPhone 14 Pro. Deux commits sont faits et rien n'a été poussé. Personne n'a encore joué cette version sur le téléphone : le verdict reste humain.

**1. Départ**
- Branche `prototype/x7-stabilisation-head-guidance`, HEAD 3abddb732b8ad54c04fe27d9acdd967d49535176.
- Index vide. Seuls `SKILL.md` et l'image de référence n'étaient pas suivis, et je les ai laissés intacts.
- J'ai créé la branche `fix/x7-head-only-circling` depuis ce HEAD.

**2. Fichiers modifiés**
- `AncreStageState.swift` : la nouvelle machine d'états.
- `OculoDefinition.swift` : les fixations et la lecture de la tête sans regard, propre à ce niveau.
- `Campaign+FinalGouffres.swift` : les deux boucles, les indices par étape et le par de 82 s.
- `GameViewModel.swift` : pour 10-7 seulement, la pose de tête est lue même quand le regard n'a pas de projection.
- `GameSceneSnapshot.swift` : l'indicateur de regard DEBUG est masqué pendant les cercles de X·7.
- Les autres fichiers :
  - la description de scène et le rendu du point ;
  - le déclencheur d'indice « n-ième succès d'une étape » ;
  - la trace et la capture DEBUG ;
  - les deux fichiers de tests, la carte des fichiers et quatre documents.

**3. Nouvelle machine d'états**

| Phase | Regard | Tête | Fin de phase |
|---|---|---|---|
| Fixation d'ouverture | critère | présente, immobile, à peu près de face | 0,8 s sur le point |
| Départ vers la droite | ignoré | seule entrée | la tête atteint le côté |
| Premier cercle | ignoré | seule entrée | 300° parcourus vers l'avant |
| Retour face | ignoré | seule entrée | 0,3 s au repos |
| Respiration | sans effet | sans effet | 1,8 s de poussière d'étoiles |
| Re-fixation | critère | présente, immobile, à peu près de face | 0,7 s sur le point |
| Départ, cercle inverse, retour | ignoré | seule entrée | mêmes règles, vers la gauche |
| Fixation finale | critère | présente, revenue près du repos | 0,7 s sur le point, puis fin |

**4 et 5. Rôle du regard**
- **Critère.** Le regard compte uniquement pendant les trois fixations : l'ouverture, la re-fixation et la fixation finale.
- **Ignoré.** Pendant les départs, les deux cercles et les retours, le code ne lit pas le regard du tout. Un regard hors écran, invalide ou absent ne met rien en pause.
- **Retours.** Une fixation acquise joue la pulsation sonore existante. Je n'ai ajouté aucune vibration, pour ne pas toucher à l'haptique globale.
- **Textes.** Ils reprennent vos formulations, au vouvoiement comme le reste du jeu.

**6. Point et anneau fixes**
- Leurs coordonnées d'écran viennent du niveau, jamais du regard.
- Le test K compare deux parties : dans l'une, le regard saute hors écran à chaque image des cercles. Sur plus de 600 images, il ne trouve aucune différence de scène, aucun déplacement et aucune marque de regard.
- Le halo qui rappelle les yeux n'apparaît que pendant une fixation.

**7. Progression pendant un cercle**
- La seule entrée est le lacet et le tangage, orientés comme l'écran.
- Sans pose de tête, l'anneau attend et ne gagne rien. Après une coupure, il faut un nouveau mouvement vers l'avant pour progresser.
- Le roulis n'intervient jamais : un test montre qu'un roulis pur de 20° laisse le lacet et le tangage à zéro.

**8. Bug de format**
- **Cause.** La trace appliquait `%d` à des entiers Swift de 64 bits. La ligne d'état de l'ancre, reconstruite à chaque image, inondait le journal.
- **Correction.** Les lignes de l'ancre et les quatre lignes génériques d'événements oculomoteurs sont construites par interpolation.
- **Hors périmètre.** Les journaux des balises du niveau 1-6 gardent leur `%d`, car ils ne tournent jamais dans X·7. Le gameplay n'est pas modifié.

**9 et 10. Tests et builds**

| Contrôle | Résultat |
|---|---|
| Suite complète | 417 tests, 62 suites |
| Passés | 417 |
| Échoués | 0 |
| Ignorés | 0 |
| Tests moteur de X·7 | 19, dont A à J et L |
| Tests de scène de X·7 | 7, dont K, trace et capture DEBUG |
| Build Debug simulateur | réussi |
| Release signé | réussi, capture DEBUG absente |
| Debug appareil signé | réussi |
| Audit du projet | 7 contrôles au vert |
| Contrôle des espaces du diff | propre |

Le test de capture écrit `VALID_OUTSIDE` à côté d'un balayage qui grandit, avec le rôle `ignored`. Ce comportement est désormais attendu.

**11. Preuve que le moteur n'a pas changé**
- Le diff depuis 3abddb7 ne touche aucun fichier sous AR, Gaze, Physics, Session, Audio, Haptics, App, ni les fixtures.
- La suite de protection historique, qui contrôle l'empreinte des sources AR, de la calibration et du filtre du regard, passe.
- Le test L vérifie octet par octet les 20 fichiers des autres finales et de leurs machines d'étapes.

**12 à 14. Git**

| Élément | Valeur |
|---|---|
| Commit 1 | 9fa4d4ef3e763f16fdac58f683cc83ee91c4cdb2, le code et les tests |
| Commit 2 | b1805a6150edcacf1d0d8ca8080751272b423dbd, la documentation |
| Diff final | 18 fichiers, 785 insertions, 374 suppressions |
| Références protégées | inchangées |
| Push | aucun |

**iPhone.** Le build Debug est installé et lancé sur l'écran des chapitres, avec la capture JSON Lines activée.

**À juger sur le téléphone**
- Les fixations passent-elles naturellement ? Les seuils « à peu près de face », 30° de lacet et 40° de tangage, ne sont pas vérifiés sur l'appareil, mais la capture enregistrera les vraies valeurs.
- Le cercle ne bloque-t-il plus jamais quand les yeux restent volontairement sur le point ?
- La re-fixation et la fixation finale se comprennent-elles sans hésitation ?
~~~~


---

## 2026-09-14 21:55:20 +0200 (19:55:20Z)
`f88478cc` · `9feddd37` · ligne 5880

~~~~markdown
**Audit en lecture seule terminé.** Aucun fichier du dépôt n'a changé, et je n'ai créé ni branche, ni commit, ni tag.

Deux constats changent la base de décision :
- **L'identité n'est pas violette.** C'est de l'ambre chaud sur une encre noire neutre, documenté ainsi dans la direction artistique.
- **L'ambre de l'interface est aussi la couleur d'attention du jeu.** C'est le même jeton pour les chapitres I à VI, donc toute recoloration commence par séparer ces jetons.

**A. ÉTAT GIT**

| Élément | Valeur |
|---|---|
| Branche | fix/x7-head-only-circling |
| HEAD | b1805a6150edcacf1d0d8ca8080751272b423dbd |
| Fichiers suivis modifiés | 0 |
| Index | vide |
| Non suivis | SKILL.md, x7_silhouette_reference.png, non touchés |
| Remote | origin, github.com/ProdX0x/iris-ios |
| Branche amont | aucune |
| Présence sur origin | ni cette branche ni prototype/x7-stabilisation-head-guidance |
| Avance locale | 5 commits sur fix/chapter-card-adaptive-layout, 6 sur la branche d'expansion oculomotrice, 34 sur main |

- **Commits attendus.** 9fa4d4e et b1805a6 sont bien présents. La lignée X·7 (bd7bddd, f51be97, 3abddb7, 9fa4d4e, b1805a6) n'existe qu'en local.
- **Environnement.** Xcode 26.3 avec le SDK iOS 26.2. Cible de déploiement iOS 17.0, Swift 6. iPhone et iPad, portrait, mode sombre imposé.
- **Appareil de test.** L'iPhone 14 Pro tourne sous iOS 26.5.2.
- **Style iOS 26 déjà actif.** L'Info.plist ne contient pas la clé de compatibilité de design. Compilés avec ce SDK, les contrôles système standard prennent donc déjà le style iOS 26.

**B. INVENTAIRE UI ACTUEL**

Tous les écrans sont en SwiftUI, et aucun n'utilise UIKit. Neuf écrans existent.

| Écran | Fichier | Rôle | Accès | Sorties |
|---|---|---|---|---|
| Seuil | Features/Home/HomeView.swift | reprendre en un geste | lancement, boutons « Seuil » et « Retour » | Commencer ou Continuer, Chapitres, Réglages |
| Permission caméra | Features/CameraAccess/CameraAccessView.swift | expliquer et demander la caméra | lancement de niveau sans autorisation | reprise du lancement, Seuil, Réglages iOS |
| Regard indisponible | Features/Unavailable/UnavailableView.swift | appareil sans TrueDepth | lancement de niveau | Seuil |
| Regard | Features/GazeSetup/Views/GazeSetupView.swift | diagnostic, calibration, vérification, verdict | lancement de niveau, Réglages, Pause | jeu, route précédente ou Seuil |
| Chapitres | Features/Chapters/ChaptersView.swift | carte des 12 chapitres et 82 niveaux | Seuil, résultat, pause, fin de parcours, Carnet | Seuil, Carnet, niveau |
| Carnet | Features/Carnet/CarnetView.swift | idées rencontrées | lien de Chapitres, Réglages | Chapitres |
| Jeu | Features/Game/Views/GameView.swift | jouer un niveau | lancement de niveau | chapitres, niveau suivant, recalibrage, Seuil, fin |
| Fin de parcours | Features/JourneyComplete/JourneyCompleteView.swift | clore la campagne | résultat du dernier niveau | Chapitres, Seuil |
| Réglages, en feuille | Features/Settings/SettingsView.swift | préférences, regard, confidentialité | icône du Seuil uniquement | Fermer, Recalibrer, Carnet, Réinitialiser |

| Écran | Haut | Bas | Cartes et surcouches | Canvas | Regard | Performance |
|---|---|---|---|---|---|---|
| Seuil | icône réglages 44 pt | aucun | aucune carte ; feuille Réglages | fibres du fond | non | respiration du fond 8 s et de l'emblème 4 s |
| Caméra | aucun | aucun | une carte de 3 lignes d'état | fibres | non | faible |
| Indisponible | aucun | aucun | une carte | fibres | non | faible |
| Regard | barre d'état masquée | Annuler | liste d'état, mesures, voiles d'encre à 94 %, points de regard en direct | fibres | central | échantillons à 60 Hz |
| Chapitres | rangée maison « ‹ Seuil » et « Carnet » | aucun | 12 cartes, 82 nœuds | fibres | non | long défilement |
| Carnet | « ‹ Chapitres » | aucun | une carte de 29 lignes | 29 glyphes | non | faible |
| Jeu | repère « III · 2 », pause 44 pt | consigne en capsule | 10 phases de surcouche | monde entier | total | boucle à 60 Hz |
| Fin de parcours | aucun | aucun | une carte de mesures | fibres | non | respiration |
| Réglages | titre et Fermer | aucun | 3 à 4 cartes, dialogue de réinitialisation | aucun | non | faible |

- **Phases du jeu.** Les surcouches sont :
  - initialisation ;
  - carte d'intro du niveau ;
  - partie, avec le HUD seul ;
  - pause, avec une carte regard qui propose le recalibrage et les points de diagnostic ;
  - résultat, avec éclats, mesures, Suivant, Rejouer et Chapitres ;
  - interruption, reprise, visage perdu, suspension et échec.
- **Monde figé derrière les surcouches.** Le code arrête la boucle avant chaque phase à surcouche.
- **Dépendance au jeu.** Seuls le jeu et la calibration dépendent du regard. Leurs view models appartiennent au coordinateur, et tous les écrans lisent le coordinateur par l'environnement.
- **Écrans inexistants.** Onboarding dédié, progression, profil, aide, à propos, crédits, confidentialité dédiée, accessibilité, fin de chapitre dédiée. Les prototypes Braises existent seulement en DEBUG, depuis les Réglages.

**C. NAVIGATION ACTUELLE**

Le coordinateur est une machine à états observable à 8 routes. La vue racine affiche la route courante dans un `ZStack`, avec un fondu et un léger zoom. Il n'y a qu'une seule feuille, et un seul dialogue de confirmation dans les Réglages. Le code ne contient ni pile de navigation, ni lien de navigation, ni barre d'onglets, ni barre d'outils, ni plein écran modal, ni alerte. Les retours sont des boutons faits main, sans geste de balayage.

```
Seuil
├─ Réglages (feuille)
│   ├─ Recalibrer → Regard (recalibrage) → route précédente
│   ├─ Carnet → ‹ Chapitres
│   ├─ Réinitialiser → dialogue de confirmation
│   └─ [DEBUG] Braises A → lancement de niveau
├─ Commencer / Continuer → lancement de niveau
└─ Chapitres
    ├─ ‹ Seuil
    ├─ Carnet → ‹ Chapitres
    └─ nœud débloqué → lancement de niveau

Lancement de niveau
  pas de TrueDepth → Regard indisponible → Seuil
  caméra non autorisée → Permission caméra → autorisée : suite ; abandon : Seuil
  regard non validé dans la session → Regard → validé : Jeu ; annulé : Seuil
  regard validé → Jeu

Jeu
  intro → Commencer | chapitres
  pause → Reprendre | Recommencer | Chapitres | Recalibrer → Regard → retour au jeu
  résultat → Suivant (niveau suivant, même écran) | Rejouer | Chapitres
            └ dernier niveau → Fin de parcours → Chapitres | Seuil
  interruption, reprise, visage perdu, suspension, échec → Réessayer | Réglages iOS | Seuil
```

1. **Navigation globale.** Il n'y en a pas. C'est un aiguillage plat de routes.
2. **Barre d'onglets.** Aucune.
3. **Barre d'outils.** Aucune barre cohérente, seulement des rangées de boutons faites main.
4. **Menu global.** Aucun. La feuille Réglages ne s'ouvre que depuis le Seuil.
5. **Destinations accessibles seulement indirectement :**
   - le Carnet, par un lien de Chapitres ou par les Réglages ;
   - les Réglages, uniquement depuis le Seuil ;
   - le recalibrage, par les Réglages ou la Pause ;
   - la fin de parcours, qu'on ne peut pas revoir.
6. **Destinations inexistantes :** progression et statistiques, profil, aide rejouable, à propos et crédits, confidentialité dédiée, narration.

**D. DESIGN SYSTEM ACTUEL**

| Famille | État | Centralisation |
|---|---|---|
| Couleurs | 37 jetons adossés au catalogue, dont 18 de chapitres, plus 3 rangs | aucune couleur littérale hors jetons |
| Typographie | New York serif en minuscules pour les titres, SF pour le corps, styles Dynamic Type | aucune taille fixe |
| Espacement | grille de 4 pt, 9 valeurs, gouttière de 24 | respecté |
| Rayons | 8, 14, 22 et capsule | respecté |
| Mouvement | 0,15, 0,28 et 0,45 s, respiration, ressort amorti, variante Réduire les animations | respecté |
| Ombres | seulement dans un halo inutilisé | aucune ombre visible |
| Matériaux et flou | aucun | aucun |
| SF Symbols | 18 dans l'interface, 10 dans la liste de diagnostic | jamais dans le monde du jeu |

| Composant | Rôle | Usages | Remarque |
|---|---|---|---|
| DSScreen | page défilante, colonne de 560 pt | 5 | |
| DSBackground | encre, abysse, 80 fibres, halo ambre, respiration de 8 s | 9 | aussi sous le jeu |
| DSThemeWash | teinte des chapitres VII à XII | 1 | jeu seulement |
| DSCard | surface arrondie de 22 pt, trait de 1 pt | 13 | le style « glass » est une surface opaque à 88 % |
| DSButton | capsule de 52 pt | 40 | principal ambre, secondaire ardoise, fantôme |
| DSOverlayPanel | voile d'encre plein écran de 75 à 94 %, titre et actions | 10 | toutes les surcouches |
| DSStatusRow | ligne d'état avec pastille | 8 | icône ambre |
| DSIrisMark | emblème diaphragme | 4 | ambre |
| DSEclats | trois arcs menthe | 2 | |
| DSGlyph | 29 glyphes du Carnet | 3 | 24 opacités littérales |
| DSBadge | pastille | 3 | |
| DSProgressRing, DSGlow | anneau et halo | 0 | inutilisés |

- **Valeurs codées en dur.**
  - Les surfaces translucides faites main ont chacune leur opacité : consigne 55 %, pause 60 %, annulation de calibration 70 %, carte d'intro 80 %, carte « glass » 88 %.
  - Les boutons-icônes de 44 pt sont recopiés sans composant.
  - Le mode sombre est imposé dans cinq vues, alors que l'Info.plist l'impose déjà.
- **Composants locaux.** FixationMark, EclatBadge, les points de regard en direct, ChapterCard et LevelNode.

**E. LIQUID GLASS ACTUEL**

Iris n'utilise pas le vrai système Liquid Glass d'Apple.

- **Aucune API de verre.** Les dossiers App, Navigation, Features et DesignSystem ne contiennent aucune occurrence de `glassEffect`, `GlassEffectContainer`, `glassEffectID`, style de bouton en verre, `Material`, flou, `visualEffect`, barre d'outils ou `TabView`.
- **Transparence simple.** Cinq surfaces sont des aplats translucides sans flou : la carte « glass », la carte d'intro, la pause, la capsule de consigne et le bouton d'annulation.
- **Simulation maison.** Des voiles d'encre de 75 à 94 % et des halos radiaux.
- **Verre natif implicite.** Il se limite aux contrôles système sous iOS 26 : interrupteurs, dialogue de confirmation, indicateur de chargement, poignée de feuille. Le fond opaque imposé à la feuille Réglages y bloque le verre natif.
- **Conflit documenté.** La direction artistique range « verre dépoli, reflets, néons » et les « dégradés décoratifs sur les fonds d'interface » dans « À éviter ». Une refonte Liquid Glass exige de réviser explicitement ce document.

**F. PROBLÈMES ET INCOHÉRENCES**

- **Couplage de l'accent.** L'accent ambre sert l'interface et le rendu du jeu, avec 19 usages directs dans le renderer plus la palette des chapitres I à VI. Recolorer l'interface recolorerait des chapitres validés.
- **Halo sous le jeu.** Le halo ambre du fond d'interface est aussi dessiné sous le jeu.
- **Texte faux sur l'écran caméra.** Il affiche « Aucune calibration : le jeu démarre dès que votre visage est détecté », alors qu'une calibration suit.
- **Retour du Carnet.** Il revient toujours à Chapitres, même quand le Carnet a été ouvert depuis les Réglages du Seuil.
- **Réglages mal placés.** La feuille mélange préférences et navigation, avec un bouton vers le Carnet.
- **Doublons.** Recalibrage et points de diagnostic apparaissent à la fois dans les Réglages et dans la Pause.
- **Diagnostic en production.** Le réglage « Points de regard (diagnostic) » est visible en Release.
- **Faux verre.** Le style de carte « glass » n'est pas du verre.
- **Opacités éparses.** Les opacités translucides ne sont pas des jetons.
- **Libellés de retour.** Le Seuil s'appelle « Seuil » sur les boutons de retour mais « iris » à l'écran. « Retour », « Seuil » et « Chapitres » coexistent.
- **Consigne tronquée.** La consigne en jeu est limitée à deux lignes et peut être coupée aux grandes tailles de texte.
- **Accessibilité des couleurs.** Aucune couleur n'a de variante contraste élevé, et Réduire la transparence n'est pas géré, ce qui deviendra nécessaire.
- **Documentation en retard.**
  - La vision UX place le lien Carnet en bas, alors que le code le met en haut.
  - Elle cite « clairvoyance » et « n / 102 » en fin de parcours.
  - Elle prévoit « Afficher les points de regard » dans la pause.
- **Voiles trop opaques.** Les voiles de 86 à 94 % cachent presque entièrement le monde figé derrière la pause et le résultat.

**G. ARCHITECTURE DE NAVIGATION RECOMMANDÉE**

| Destination | Existe ? | Contenu actuel | Place permanente ? | Risque de doublon |
|---|---|---|---|---|
| Accueil (Seuil) | oui | emblème, Continuer, Chapitres, total d'éclats | oui | faible si seul le Seuil porte « Continuer » |
| Chapitres | oui | 12 chapitres, 82 niveaux, éclats par niveau | oui | aucun |
| Progression | non | données dispersées : totaux, éclats par nœud, meilleur temps au résultat, temps total en fin de parcours | non | fort avec Chapitres |
| Profil | non | aucun compte ni donnée | non | écran vide |
| Carnet | oui | 29 idées, glyphe et phrase | oui | aucun |
| Réglages | oui, en feuille | préférences et regard | non, en barre d'outils | déjà en partie dans la Pause |

- **Option 1, quatre onglets Accueil, Chapitres, Progression, Profil.** Rejetée. Deux onglets n'ont ni écran ni contenu, Progression doublerait la carte et Profil serait vide.
- **Option 2, trois onglets natifs Seuil, Chapitres, Carnet.**
  - Les trois destinations existent et ont du contenu.
  - Le Carnet sort de l'accès indirect.
  - Sur iPad, la barre devient une barre latérale.
- **Option 3, sans onglets.** Le Seuil sert de hub, avec une pile de navigation et des barres d'outils en verre. C'est le risque le plus faible, mais le Carnet reste enfoui et il n'y a pas de chrome global.

**Recommandation : option 2.**
- **Pourquoi.** Elle repose sur trois destinations réelles et fait de la barre d'onglets native la surface de verre la plus légitime. Elle supprime les retours faits main et garde une seule action principale, Continuer, sur le Seuil.
- **Sélection d'onglet.** Elle passe par le coordinateur, comme l'impose la règle « les vues ne décident pas des destinations ».
- **Écrans hors onglets.** Jeu, Regard, Permission caméra, Regard indisponible et Fin de parcours s'affichent en plein écran au-dessus des onglets.
- **Barre d'onglets.** Elle se réduit au défilement dans Chapitres et Carnet.
- **Accessoire bas « Continuer ».** Pas en première version, car il doublerait le Seuil.
- **Progression.** Elle reste répartie dans les en-têtes de Chapitres et sur le Seuil. Si les statistiques grandissent, elles deviendront une section de Chapitres, pas un onglet.

| Fonction | Emplacement recommandé |
|---|---|
| Son : effets, ambiance, vibrations | Réglages, section Son |
| Voix narrative | Réglages, section Narration, plus tard |
| Recalibrer le regard | Réglages, section Regard ; conservé en Pause, où il est contextuel |
| Points de regard (diagnostic) | Réglages, sous-section Avancé ; à retirer de la Pause en Release, sur décision |
| Accessibilité, Réduire les animations | réglages iOS respectés, sans doublon |
| Aide « Comment jouer » | Réglages, plus tard ; le Carnet reste la référence des idées |
| À propos : version, crédits des voix | Réglages |
| Confidentialité | Réglages, texte actuel |
| Réinitialiser la progression | bas des Réglages, confirmation destructive inchangée |
| Debug | section Réglages visible seulement en DEBUG |

Les Réglages s'ouvrent depuis un bouton en verre dans la barre d'outils de chaque onglet, dans une feuille au verre natif sans fond opaque imposé.

**H. ARCHITECTURE LIQUID GLASS RECOMMANDÉE**

| Rôle | Surfaces |
|---|---|
| A. Verre clair, très transparent | boutons-icônes flottants sur fond sombre peu détaillé : pause en jeu, icône Réglages, fermer |
| B. Verre lisible (regular) | barre d'onglets et barres d'outils système ; feuille Réglages ; panneaux quand la boucle est arrêtée (intro, pause, résultat, reprise, visage perdu, échec) ; carte des mesures du verdict ; dialogues |
| C. Aucun verre | cartes de chapitres ; lignes du Carnet ; carte de fin de parcours ; consigne en jeu ; repère de niveau ; cibles, libellés et liste de diagnostic de la calibration ; textes des écrans caméra et indisponible |
| D. Contenu plein écran | monde du jeu, champ de la chambre noire, silhouette et anneau de X·7, emblème du Seuil |

Règles pour Iris :
1. **Couche de commande.** Le verre sert aux commandes, jamais au contenu.
2. **Deux variantes.** Le verre clair ne sert que pour une icône seule, le verre lisible dès qu'il y a du texte.
3. **Teinte rare.** Pas de teinte par défaut, et une seule surface teintée par écran : l'action principale. C'est l'héritage de la règle « une seule surface ambrée ».
4. **Jamais de verre sur du verre.** Les commandes voisines se regroupent dans un même conteneur. Un panneau en verre contient des boutons pleins ou textuels.
5. **Un fond à réfracter.** Le verre a besoin d'une texture derrière lui : fibres, halo, monde figé, cartes qui défilent. Pas d'aplat noir.
6. **Voile allégé.** Sous un panneau en verre, le voile d'encre descend vers 30 à 45 %, pour que le monde figé reste visible et donne la profondeur.
7. **API native uniquement.** Aucun flou fait main. Avec la cible iOS 17, le repli opaque tient dans un seul composant du design system, qui sert aussi pour Réduire la transparence.
8. **Un seul verre pendant la partie.** Le bouton pause.
9. **Transitions.** Les transitions morphing du verre restent hors jeu. Avec Réduire les animations, un fondu les remplace.
10. **Contraste.** Le texte sur verre est vérifié sur le fond le plus clair possible : au moins 4,5:1, ou 3:1 pour les titres.

Pour obtenir l'impression de verre vivant sans « plastique violet » :
- le verre reste neutre ;
- l'accent coloré se limite à l'état sélectionné et à l'action principale ;
- les fonds gardent une structure lumineuse discrète, sinon le verre se lit comme un simple gris.

**I. PALETTE COULEUR RECOMMANDÉE**

| Rôle actuel | Valeur | Où |
|---|---|---|
| Fond : encre, abysse, ardoise | #07080B, #0D0F14, #161922 | tous les écrans et le champ de jeu |
| Texte : nacre, brume, cendre | #ECE7DC, #A7A399, #85817A | interface |
| Accent : ambre, braise | #F2B35A, #C9812F | action principale, emblème, prochain niveau, icônes d'état, lames d'iris et veilleuses du jeu |
| Réussite : menthe | #7FE0C0 | éclats, niveaux faits, calibration validée |
| Danger : corail | #FF7A5C | échecs, visage perdu |
| Info : givre | #9CC3E6 | badges de diagnostic |
| Chapitres VII à XII | rose #F2A6C0, cyan #9FD3E6, chartreuse #C9E36B, lavande #B39CFF sur #100A1C, orange #FF8C42, argent #E8E6F2 | numéraux et jeu |

- **Usage des teintes, relié au code.**
  - Le violet se limite à la palette du chapitre X, à la silhouette de X·7 et au rang « orchidée ».
  - Le bleu se limite à la marée des courants et à l'info.
  - Il n'y a ni indigo ni magenta.
  - Le noir est neutre, pas indigo.
  - Le blanc est une nacre chaude.
- **Conclusion.** L'identité ne repose pas sur du violet opaque. L'impression de violet vient très probablement des tests de X·7 dans le chapitre X.

Proposition de jetons conceptuels, rien n'étant écrit dans le code :

| Groupe | Jeton conceptuel | Valeur indicative | Usage |
|---|---|---|---|
| A. Identité | identity.ground.deep | #060817 | fond bleu-noir indigo des écrans hors jeu |
| A | identity.ground.halo | #111838 | halo du Seuil |
| A | identity.spectral | #7C6CFF | emblème, action principale |
| A | identity.frost | #78BDFF | sélection, focus |
| A | identity.lavender | #C7BDFF | accents de texte doux |
| A | identity.light, mist, ash | #F3F2FA, #A9A9C4, #7F809B | texte principal, secondaire, tertiaire |
| A | identity.magenta | #FF5CD6 | ponctuel : « nouveau », fin de parcours |
| B. Navigation | nav.glass | aucun teint | verre neutre |
| B | nav.selected, nav.focus | light, frost | onglet choisi, focus |
| B | nav.prominent | spectral en teinte légère | action principale en verre |
| C. Chapitres | chapter.* | valeurs actuelles gelées, dont ambre et encre des chapitres I à VI | jeu, numéraux, cartes |
| D. États | success, danger, warning, info | menthe et corail inchangés, ambre en avertissement d'interface seulement, frost | états |

- **Garder les couleurs des chapitres.**
  - L'écran de jeu garde exactement ses fonds et accents actuels.
  - Le violet spectral de l'interface reste plus bleu que la lavande du chapitre X.
  - Sur les écrans du chapitre X, l'action principale reste en verre neutre, sans teinte.
- **Décision explicite requise.** Adopter cette palette change l'identité ambre documentée, l'emblème et probablement l'icône. Le document de direction artistique doit être révisé.
- **Contrastes estimés.** Environ 18:1 pour le texte principal et 8:1 pour le secondaire. Le texte blanc sur verre teinté spectral doit être vérifié.

**J. ÉCRAN DE JEU**

- **Barre d'onglets.** Recommandation ferme : elle n'existe pas pendant le jeu. Le jeu s'ouvre en plein écran au-dessus des onglets, qu'on retrouve en quittant.
- **Pendant la partie.**
  - Seul le bouton pause devient du verre clair de 44 pt.
  - Le repère « III · 2 » reste du texte simple.
  - La consigne reste une capsule d'encre, sans verre : elle touche le bas du champ et du texte sur verre clair y serait peu lisible.
- **Surcouches.** Les panneaux d'intro, pause, résultat, reprise, visage perdu et échec deviennent du verre lisible, sur un voile allégé. Le fond qu'ils recouvrent est statique, puisque la boucle est arrêtée.
- **Aucun verre sur le champ de jeu actif.** Ni morphing, ni verre interactif, ni conteneur animé pendant une partie.
- **Isolation du rendu.** Aujourd'hui, seul l'hôte du Canvas lit l'instantané de chaque image, et le HUD et les surcouches lisent des propriétés rares. Aucune vue en verre ne doit lire l'instantané.
- **Inchangés.** Canvas, physique, couleurs des niveaux, cadence à 60 Hz, barre d'état et indicateur d'accueil masqués.
- **Respiration du champ.** C'est un visuel validé. On ne la fige qu'avec une décision, et seulement si une mesure sur appareil montre un coût.

**K. CALIBRATION**

- **Aucun verre pendant la mesure.** Ni pendant le diagnostic, ni pendant la calibration, ni pendant la vérification : le fond reste neutre. Aucun reflet ne doit bouger près des cibles.
- **Bouton Annuler.** Pendant les cibles, il reste un bouton simple sans verre, car il est proche du coin inférieur gauche des points.
- **Liste de diagnostic.** Elle reste plate et statique, car le point de fixation central est actif pendant son affichage.
- **Verdict.** Il peut recevoir un seul panneau de mesures en verre lisible, plus des boutons en verre, puisqu'on ne mesure plus.
- **Échec et pause.** Leurs panneaux peuvent passer en verre lisible.
- **À ne surtout pas rendre plus distrayant :**
  - le mouvement des cibles et leur halo ;
  - les teintes près des cibles ;
  - le libellé d'étape ;
  - la respiration du fond, qui est à évaluer pendant la collecte.
- **Précision préservée.** Aucun changement de géométrie, de taille de cible ou de minutage.

**L. AUDIO ACTUEL**

```
AudioService (protocole, acteur principal) : activate, deactivate, apply(AudioCue), statut
├─ AVAudioEngineAudioService (appareil, simulateur)
│   ├─ session AVAudioSession : catégorie ambient, mixWithOthers
│   ├─ AVAudioEngine + AVAudioSourceNode mono → SineSynth (rendu sans allocation)
│   └─ interruptions, changement de configuration, réinitialisation des services média
├─ SilentAudioService (aperçus)
AudioCuePolicy : événements de jeu → crescendo, carillon, perte, arpège, pulsation, drone
Déclenchement : uniquement dans le view model du jeu, à chaque tick ; drone par fréquence de chapitre
Réglages persistés (UserDefaults) : effets activés, ambiance coupée, vibrations activées, diagnostic
Haptique : service et politique séparés
Fichiers audio embarqués : aucun
Tests : AudioCuePolicyTests, SineSynthTests, GameSettingsStoreTests, MockAudioService
```

- **Hors du jeu.** Aucun son n'est joué dans les menus.
- **Mode silencieux.** La catégorie actuelle respecte l'interrupteur Silencieux.

**M. FUTURE NARRATION**

Architecture recommandée, sans code aujourd'hui :
- **NarrationCue**, dans le domaine sans AVFoundation : une clé stable par moment, par exemple accueil, intro du chapitre 10, intro du niveau 10-7, fin de parcours.
- **VoiceProfile** : identifiant stable, libellé affiché, langue, dossier. Aucun `maleVoice` ni `femaleVoice` dans le code.
- **NarratorPreference** : désactivée, ou une voix choisie par identifiant.
- **NarrationCatalog** : lit un manifeste par voix et résout la clé, la voix et la langue en fichier, avec les replis.
- **NarrationService**, dans la couche Audio : lire, arrêter, écouter un aperçu, savoir si une lecture est en cours. Une implémentation silencieuse sert aux aperçus et aux tests.
- **NarrationPolicy**, du côté du coordinateur. Elle ne parle jamais :
  - pendant une partie ou pendant les cibles de calibration ;
  - avec VoiceOver actif, où la lecture automatique est coupée et un bouton de réécoute la remplace ;
  - plusieurs fois pour la même intro, sauf réécoute.
- **Mixage.** La voix a son propre lecteur, indépendant du synthé, du drone et de l'haptique, sur la même session audio. Pendant la voix, les effets et le drone baissent. Cette baisse de volume est la seule adaptation d'interface nécessaire côté audio historique.

| Contexte | Classement | Raison |
|---|---|---|
| Premier accueil | FORTEMENT RECOMMANDÉ | donne le ton, court, une seule fois |
| Intro de chapitre, au premier niveau du chapitre | FORTEMENT RECOMMANDÉ | 12 phrases de principe, moment calme |
| Fin de campagne | FORTEMENT RECOMMANDÉ | récompense, écran contemplatif |
| Explication avant la caméra, confidentialité | OPTIONNEL | peut rassurer, mais le jeu doit enseigner seul |
| Niveaux spéciaux, finales oculomotrices, X·7 | OPTIONNEL | sur la carte d'intro uniquement, première fois |
| Fin de chapitre | OPTIONNEL | transition courte |
| Consignes de calibration avant de commencer | OPTIONNEL | jamais pendant les cibles |
| Lignes du Carnet | OPTIONNEL | à la demande |
| Chaque intro des 82 niveaux | À ÉVITER | répétitif |
| Aides en jeu, résultats, éclats | À ÉVITER | le jeu du regard exige le silence |

```
Resources/Narration/
  fr/
    voice-a/
      manifest.json            (clé, fichier, durée, empreinte du texte)
      welcome.m4a
      chapter-01-intro.m4a … chapter-12-intro.m4a
      level-10-07-intro.m4a
      journey-end.m4a
    voice-b/
      (mêmes clés)
```

- **Format.** AAC en .m4a, mono, 48 kHz, environ 96 kb/s. Loudness à −16 LUFS, crête à −1 dBTP, silences de début et de fin raccourcis.
- **Durées et taille.**

| Élément | Estimation |
|---|---|
| Durée par fichier | 3 à 20 s |
| Accueil | 25 s au plus |
| Environ 30 clés par voix | quelques mégaoctets par voix |
| Deux voix | environ 7 Mo au total |

- **Chargement.** À la demande, à l'apparition de l'écran concerné, sans préchargement global. Le streaming est inutile et tout reste local.
- **Replis.** Un fichier absent ne produit aucun son, le texte restant affiché. Il n'y a pas de repli vers l'autre voix. Un journal DEBUG signale le manque, et un test vérifie que chaque manifeste est complet.
- **Lecture interrompue.** La lecture s'arrête au changement d'écran, au début d'une partie ou au passage en arrière-plan, sans reprise automatique.
- **Écriture des textes.** Tutoiement exclu, comme le prévoit la vision UX.
- **Emplacement du choix.** Réglages, section Narration : « Désactivée » et les voix disponibles, chacune avec un bouton d'aperçu. Les libellés définitifs sont à décider.
- **Persistance.** Une clé UserDefaults stocke l'identifiant de voix. Le changement s'applique à chaud et arrête la lecture en cours.
- **Valeur par défaut.** Désactivée tant que les fichiers n'existent pas, puis choix humain.
- **Mode silencieux.** La catégorie ambient le respecte, et les Réglages doivent le dire.
- **Voix sans fichiers.** Masquée, ou grisée avec la mention « non installée ».

**N. PERFORMANCE / ACCESSIBILITÉ**

| Risque | Niveau | Stratégie |
|---|---|---|
| Verre au-dessus du Canvas pendant la partie, qui rééchantillonne le fond à chaque image | ÉLEVÉ si la surface est grande | seul le bouton pause de 44 pt ; panneaux uniquement boucle arrêtée |
| Verre près des cibles de calibration | ÉLEVÉ pour la précision | aucun verre pendant la mesure |
| Transparences empilées : fond, lavis de chapitre, voile, verre | MOYEN | voile allégé, pas de verre sur verre, commandes regroupées |
| Respiration continue du fond sous le jeu et la calibration | MOYEN | mesurer ; ne figer que sur décision |
| ARKit, Canvas à 60 Hz et composition GPU sur de longues sessions | MOYEN | Instruments sur l'iPhone 14 Pro : cadence, état thermique |
| Invalidations SwiftUI | FAIBLE | garder les hôtes isolés ; le chrome ne lit jamais l'instantané |
| Morphing de navigation hors jeu | FAIBLE | fondu avec Réduire les animations |
| Long défilement de Chapitres sous la barre d'onglets | FAIBLE | réduction de la barre au défilement |

Accessibilité :
- **Dynamic Type.** Les polices suivent déjà les styles de texte. La consigne en deux lignes et la carte d'intro sont à vérifier aux tailles d'accessibilité.
- **VoiceOver.** Les boutons-icônes ont des libellés, le champ de jeu est masqué et les consignes sont annoncées. La narration automatique ne doit pas doubler VoiceOver.
- **Réduire les animations.** 8 usages existent déjà ; il faut étendre ce traitement au verre.
- **Réduire la transparence et Contraste élevé.** Aucun n'est géré aujourd'hui. Le verre natif s'adapte seul. Les jetons doivent recevoir des variantes contraste élevé, et le repli opaque doit exister.
- **Cibles tactiles.** 44 pt pour les icônes, 52 pt pour les boutons, 44 pt minimum pour les nœuds : à conserver.
- **Texte sur verre.** Jamais de texte courant sur du verre clair.

**O. ARCHITECTURE CIBLE**

```
App (IrisApp, AppContainer)
├── Navigation
│   ├── AppCoordinator : onglet sélectionné, flux plein écran, feuille
│   ├── AppShell : TabView native Seuil · Chapitres · Carnet, bouton Réglages en barre d'outils
│   └── Flux plein écran : Permission caméra, Regard, Jeu, Fin de parcours, Regard indisponible
├── DesignSystem
│   ├── Tokens : identity.*, nav.*, state.*, chapter.* gelés, typographie, espacement, rayons, mouvement
│   ├── Rôles de verre : chrome système, contrôle clair, panneau lisible, aucun ; repli opaque unique
│   └── Composants : bouton, carte de contenu, panneau de surcouche, fond d'identité, champ de jeu gelé
├── Features
│   ├── Seuil, Chapitres, Carnet
│   ├── Réglages : Son, Narration, Regard, Confidentialité, À propos, Réinitialiser, DEBUG
│   ├── Jeu : HUD minimal, surcouches en verre lisible boucle arrêtée
│   └── Regard, Permission caméra, Fin de parcours, Indisponible
├── Moteur, rendu, campagne : gelés
├── Audio
│   ├── Sons de jeu : service, synthé, politique, inchangés hors baisse de volume
│   └── Narration : NarrationService, VoiceProfile, NarrationCue, NarrationCatalog, préférence, politique
└── Resources : catalogue de couleurs avec contraste élevé, Narration/<langue>/<voix>/
```

**P. PLAN DE MIGRATION**

1. **Phase 0, décisions sans code.** Il faut trancher :
   - la cible de déploiement, iOS 26 ou iOS 17 avec repli ;
   - la navigation à trois onglets ;
   - la palette ;
   - la révision de la direction artistique ;
   - les libellés.

   Il faut aussi capturer les images de référence de tous les écrans. Sortie : décisions écrites.
2. **Phase 1, séparation des jetons sans aucun changement de pixel.**
   - Couches : tokens, fond, renderer en lecture de jetons de chapitre.
   - Risque : recolorer le jeu par erreur.
   - Validation : images de contrôle identiques et empreintes vertes.
   - Sortie : diff visuel nul.
3. **Phase 2, rôles de verre et composants.**
   - Couches : design system, avec disponibilité, repli, contraste et transparence.
   - Validation : galerie d'aperçus et rendus de contrôle.
   - Sortie : aucun écran encore migré.
4. **Phase 3, coquille de navigation.**
   - Couches : coordinateur, vue racine, onglets, plein écran, feuille.
   - Risques : régressions de flux, recalibrage.
   - Validation : tests du coordinateur adaptés, parcours complets sur simulateur.
   - Sortie : tous les flux actuels atteignables.
5. **Phase 4, Seuil, Chapitres, Carnet et Réglages avec la nouvelle palette de chrome.**
   - Validation : captures, Dynamic Type, VoiceOver.
   - Sortie : validation humaine visuelle.
6. **Phase 5, jeu, résultat et fin de parcours.**
   - Couches : HUD, surcouches.
   - Risques : performance, lisibilité.
   - Validation : Instruments sur l'iPhone 14 Pro, 82 niveaux inchangés, empreintes vertes.
   - Sortie : partie complète jouée par un humain.
7. **Phase 6, Permission caméra, Regard et Regard indisponible.**
   - Risque : précision.
   - Validation : calibration humaine avec erreurs comparables aux mesures actuelles.
   - Sortie : verdict humain.
8. **Phase 7, infrastructure de narration sans fichier audio.**
   - Couches : Audio, domaine, Réglages.
   - Validation : tests du catalogue, du repli et de la politique.
   - Sortie : option Désactivée seule visible.
9. **Phase 8, finition.**
   - Couches : performance, accessibilité, états d'erreur, documentation.
   - Validation : appareil et accessibilité.
   - Sortie : tag de candidat.

**Q. STRATÉGIE GIT**

- **Nom de la branche future.** `feature/iris-liquid-glass-2026`.
- **Prérequis avant création.**
  - X·7 option A validé humainement, et les cartes de chapitres aussi.
  - Tag de validation posé sur b1805a6, ou sur son successeur si X·7 évolue.
  - Branches locales de X·7 poussées normalement sur origin, car elles n'existent aujourd'hui qu'en local.
  - Décisions de la phase 0 prises.
- **Point de départ exact.** Ce tag, pas main, qui a 34 commits de retard.
- **Commits.** Un commit atomique par sous-étape, tests verts à chaque commit, et un tag de base `baseline-before-liquid-glass` au départ.
- **Tags intermédiaires.** En fin de phase 1 (jetons, zéro pixel), de phase 3 (coquille), de phase 5 (jeu validé sur appareil) et de phase 8 (candidat).

**R. ÉLÉMENTS GELÉS**

- **Moteur de regard.** Gaze Engine, fichiers AR, service ARKit, TrueDepth, filtre du regard.
- **Calibration.** Protocole, seuils, correspondance d'axes, transformation affine, stockage du profil.
- **Physique et session.** Physique des cibles, session de jeu, environnement, cadence à 60 Hz.
- **Campagne.** Données des niveaux, fixtures, empreintes, difficulté, pars, règles de déblocage.
- **Mécanismes oculomoteurs.** Étapes validées, dont X·7 option A.
- **Rendu du jeu.** Formes, couleurs de chapitre, ambre et encre des chapitres I à VI, lavis VII à XII, respiration du champ sauf décision.
- **Audio historique.** Synthé, politique de sons, drone, valeurs par défaut des réglages. Seule exception : l'adaptation nécessaire à la narration.
- **Haptique historique.**
- **Autres invariants.** Confidentialité, portrait, mode sombre, identité Apple et `project.yml`, sauf les ajouts décidés.

**S. RISQUES**

| Risque | Gravité | Parade |
|---|---|---|
| Recoloration involontaire des chapitres validés par l'accent partagé | élevée | phase 1 de séparation, zéro pixel, avant tout |
| Verre sur le jeu actif : coût GPU et distraction du regard | élevée | un seul bouton en verre pendant la partie |
| Précision de calibration dégradée par le décor | élevée | aucun verre pendant la mesure |
| Régressions de flux en passant aux onglets | moyenne | tests du coordinateur, parcours complets |
| Cible iOS 17 et verre natif iOS 26 | moyenne | décision de phase 0, repli unique |
| Lisibilité du texte sur verre, Contraste élevé, Réduire la transparence | moyenne | règles de contraste, variantes de jetons |
| Conflit avec la direction artistique documentée | moyenne | révision explicite du document |
| Narration et VoiceOver qui se superposent | moyenne | politique de narration |
| Fichier de voix manquant ou mode silencieux mal compris | faible | manifeste testé, mention dans les Réglages |

**T. RECOMMANDATION FINALE**

Refondre d'abord la structure, sans toucher aux pixels, puis poser le verre là où il sert. Réponses aux 17 questions :
1. **Architecture UI.** SwiftUI pur, 9 écrans. Un design system maison de jetons d'assets et de composants pleins. Aucun verre, aucun matériau.
2. **Navigation.** Une machine à états de 8 routes dans un `ZStack`, une feuille et des retours faits main, sans pile ni onglets.
3. **Barre d'onglets.** Oui, hors du jeu.
4. **Nombre de destinations.** Trois : Seuil, Chapitres, Carnet.
5. **Menu secondaire.** Oui : Réglages, en feuille ouverte depuis la barre d'outils.
6. **Verre selon les surfaces.**
   - Clair pour les boutons-icônes flottants.
   - Lisible pour les barres, la feuille et les panneaux où la boucle est arrêtée.
   - Aucun sur le contenu.
7. **Verre en erreur.**
   - Sur le champ de jeu actif, près des cibles de calibration, sur les cartes de chapitres et du Carnet.
   - Sur la consigne en jeu.
   - Verre teinté partout.
8. **Palette.**
   - Indigo profond, violet spectral plus bleu que la lavande du chapitre X, bleu givre, lavande, blanc lumineux.
   - Magenta rare, verre neutre, menthe et corail conservés.
   - Sous réserve de réviser l'identité ambre documentée.
9. **Couleurs des chapitres.** Par des jetons de chapitre séparés et gelés, en phase 1, avant toute recoloration.
10. **Écran de jeu.**
    - Pas d'onglets, un seul verre pendant la partie : le bouton pause.
    - Surcouches en verre lisible sur le monde figé.
    - Rendu et couleurs inchangés.
11. **Calibration.** Neutre et sans verre pendant la mesure. Verre possible seulement sur le verdict et les échecs.
12. **Impact performance.** Faible hors jeu. Élevé seulement si le verre recouvre le Canvas actif, à mesurer sur l'iPhone 14 Pro.
13. **Deux voix sans les intégrer.**
    - Clés de narration, profils de voix et manifeste par voix.
    - Service silencieux et option Désactivée.
    - Aucun fichier audio pour l'instant.
14. **Architecture de narration.**
    - Service de narration indépendant et catalogue avec replis.
    - Politique décidée par le coordinateur.
    - Baisse du volume des effets pendant la voix.
15. **Valeur de la narration.** Premier accueil, intro de chapitre et fin de campagne. Plus, en option, les niveaux spéciaux, la fin de chapitre et le Carnet.
16. **Branche future.** `feature/iris-liquid-glass-2026`.
17. **Ordre de migration.** Décisions, séparation des jetons, composants de verre, coquille de navigation, écrans de menu, jeu, calibration, narration, finition.

VERDICT MISSION 0

Navigation recommandée :
TabView native à trois destinations, Seuil, Chapitres et Carnet. Réglages en feuille depuis la barre d'outils. Jeu, regard, caméra et fin de parcours en plein écran, sans barre d'onglets.

Liquid Glass :
API native iOS 26 réservée à la couche de commande. Verre clair pour les boutons-icônes, verre lisible pour les barres, la feuille et les panneaux boucle arrêtée. Aucun verre sur le contenu, sur le jeu actif ni pendant la mesure du regard.

Palette :
Indigo profond, violet spectral, bleu givre, lavande et blanc lumineux pour l'interface. Magenta rare, verre neutre, menthe et corail conservés. Couleurs de chapitre gelées dans des jetons séparés, sous réserve de réviser l'identité ambre documentée.

Narration :
NarrationService, VoiceProfile, NarrationCue et un manifeste par voix, sur un lecteur indépendant des effets. Désactivée par défaut, choix et aperçu dans les Réglages. Accueil, intro de chapitre et fin de campagne en priorité.

Future branche :
feature/iris-liquid-glass-2026

Point de départ Git :
Un tag de validation humaine posé sur b1805a6150edcacf1d0d8ca8080751272b423dbd, ou sur son successeur si X·7 évolue, une fois les branches X·7 poussées sur origin.

Nombre de phases :
8 phases d'implémentation, précédées d'une phase 0 de décisions sans code.

Principal risque :
Recolorer involontairement les chapitres validés, parce que l'accent ambre de l'interface est le même jeton que la couleur d'attention du jeu.

Première action après validation humaine du rapport :
Trancher les décisions de la phase 0 : cible iOS, trois onglets, palette et révision de la direction artistique. Ensuite, capturer les images de référence de tous les écrans avant de créer la branche.
~~~~


---

## 2026-09-14 23:02:37 +0200 (21:02:37Z)
`f88478cc` · `323d033d` · ligne 6462

~~~~markdown
# Rapport final — Phase 1 Liquid Glass 2026 : séparation des rôles de couleur

La séparation est faite et vérifiée sans aucun écart visuel. Les deux passages de la version d'origine donnent un bruit de fond nul, et sur 126 captures l'état final est identique octet pour octet à cette version. Tout est dans deux commits locaux, sans push ni tag.

## A. État Git
- **Branche :** `feature/iris-liquid-glass-2026`, créée depuis `b1805a6`, le HEAD de `fix/x7-head-only-circling`.
- **Commits :** `c3781f7 refactor: separate app and chapter color roles`, puis `a4bff43 test: protect visual color boundaries`.
- **Rien d'autre n'a bougé :**
  - aucun push, et la branche n'a pas d'amont ;
  - aucun tag, les trois tags existants sont intacts ;
  - `main` est toujours à `52f20b7` ;
  - aucun rebase ni merge ;
  - `SKILL.md` et `x7_silhouette_reference.png` n'ont pas été touchés.
- X·7 n'est pas présenté comme validé humainement.

## B. Audit de départ
- **Références :** 280 aux anciens jetons « à plat » dans 40 fichiers, total recoupé dans HEAD. Aucun `Color("…")` en dehors de `DSColor.swift`.
- **Jetons partagés entre l'interface et le jeu :**
  - `accent` : 20 usages dans le jeu, 21 dans l'interface ;
  - `statusSuccess` 12/14, `statusDanger` 9/9 ;
  - `textPrimary` : 2 dans le jeu plus les fibres du fond, 28 dans l'interface ;
  - `textTertiary` 8/14, `lineSubtle` 1/8 ;
  - `fieldInk` : 4 dans le jeu, 7 dans l'interface ;
  - `fieldAbyss` 5/1, `lueurCore` 18/2, `lueurGlow` 9/1.
- **Jetons propres au jeu :** `accentDeep`, `maree`, `veil`, `rank`, et les 18 jetons de thème des chapitres VII–XII.
- **Jetons propres à l'interface :** les trois fonds, `textSecondary`, `textWarm`, `textOnAccent`, `statusInfo`.
- **Dépendance cachée :** `GameView` s'appuyait sur `DSBackground`, le fond de l'interface.

## C. Conception
`DSColor` contient maintenant quatre familles imbriquées. Pas de protocole, pas de moteur de thème.

| Famille | Jetons |
|---|---|
| `Identity` | ground, groundAbyss, surface, surfaceElevated, line, text ×4, accent, emblemCore, emblemGlow |
| `Navigation` | primary, onPrimary, secondary, control (interrupteurs, « Fermer », indicateur de chargement), selection (anneau du prochain niveau), veil (voiles des surcouches, capsule d'indice, dégradé de l'intro) |
| `State` | success, danger, warning, info |
| `Chapter` | ink, abyss, attention, attentionDeep, lueurCore, lueurGlow, maree, veil, nacre, cendre, line, success, trouble, rank(_:), 18 jetons de thème |

- **Monde du jeu, lit seulement `Chapter` :** le renderer et ses extensions, `DSThemePalette`, `DSThemeWash`, `GameView`, `GameFieldBackground`.
- **Interface autour du jeu, lit les trois autres familles :** HUD, pause, intro, résultat, calibration et menus.
- **Couleur d'un chapitre dans l'interface :** elle passe uniquement par la palette du chapitre (numéral de la carte, surtitre de l'intro).

## D. Catalogue de couleurs
- **Avant :** 41 jeux `ds.*`. **Après :** 56, dont 34 `chapter`, 12 `identity`, 6 `navigation` et 4 `state`.
- **41 renommages identiques à l'octet :** 34 vers `ds.chapter.*`, 7 jeux propres à l'interface vers leur famille.
- **15 copies identiques** pour les couleurs que l'interface partageait avec le jeu.
- **Aucune suppression ni valeur changée :** aucun contenu de jeu de couleurs n'a disparu. Les anciens noms n'existent plus parce que plus aucun code ne les lit.
- `AccentColor`, `LaunchBackground` et `project.yml` sont intacts.

## E. Migration du code
- Les 280 références sont migrées, dont 276 appariées une à une.
- **Retraits volontaires :**
  - `DSIrisFibers` reçoit maintenant sa couleur en paramètre ;
  - le preview de `DSThemeWash` affiche la palette jumelles sur `Chapter.ink` au lieu de trois `statusInfo` sur `DSBackground` (un preview Xcode, invisible dans l'app).
- Le preview de `GameCanvasView` utilise `GameFieldBackground`.
- **Docs :** `design-system.md` (tableau des jetons), ADR-22 et une ligne « Forbidden » dans `architecture.md`, `file-map` régénéré.

## F. Fond du menu et fond du jeu
- `DSBackground` reste le fond de l'interface, en jetons `Identity`.
- `GameFieldBackground` est le nouveau fond du jeu, en jetons `Chapter`. C'est une copie exacte du `DSBackground` calme : même structure, mêmes opacités, même respiration de 8 s, même gestion de « Réduire les animations ».

## G. Tests ajoutés (14)
- **`ColorRoleBoundaryTests` (7 tests) :**
  - A : couleurs des chapitres I–VI inchangées ;
  - B : chapitres VII–XII inchangés ;
  - C : couleurs d'état inchangées ;
  - D : chaque nouveau jeton porte la valeur de l'ancien, `AccentColor` et `LaunchBackground` compris ;
  - E : le monde du jeu ne lit que `Chapter`, pas de `DSBackground`, pas de `Color("…")` ;
  - E (sens inverse) : l'interface ne lit aucun jeton `Chapter` ;
  - F : un jeu de couleurs par jeton, préfixé par sa famille, aucun partagé ; le catalogue et l'app résolvent la même valeur ; une recoloration hypothétique de toute l'interface ne change aucun des 34 jeux `chapter`.
- **`GameContentFreezeTests` (4 tests) :**
  - G : empreintes SHA-256 de 32 fichiers (moteur, horloges, session, audio, haptique, progression, `GameViewModel`, `GazeSetupViewModel`) ;
  - H : les 8 fichiers de X·7, par 82, final optionnel ;
  - I : 82 niveaux (identifiants et ordre) et 20 fichiers de données de campagne ;
  - J : 11 fichiers de mécaniques et 6 constantes de temps.
  - Ces tests complètent les protections existantes : chapitres historiques, Gaze Engine, `GazeFilter`, `TargetPhysics` et les finals.
- **`VisualCaptureTests` (3 tests) :** le rendu hors écran tourne toujours. Les deux autres ne tournent que si `IRIS_CAPTURE_DIR` est défini.
- Au premier passage, E a trouvé un vrai `DSBackground()` dans le preview de `DSThemeWash`. J'ai corrigé le preview, pas le test.

## H. Preuve visuelle (images hors dépôt, dans `.iris-derived-data/phase1/`)
- **Méthode :**
  - « avant » : worktree de `b1805a6` avec seulement le harnais ajouté, capturé deux fois ;
  - « après » : le code final, sur le même simulateur.
- **Contenu d'un passage (126 images) :**
  - **Hors écran :** 22 écrans, à savoir Seuil ×2, Chapitres, les 12 cartes, Carnet, Réglages, Fin du voyage, appareil incompatible, caméra refusée, calibration (état initial, point, verdict), 5 intros, partie visible, pause, 2 résultats, échec de suivi.
  - **En fenêtre :** les mêmes 22 écrans, hébergés dans une vraie fenêtre, animations coupées.
  - **Niveaux :** les 82 niveaux après 1,5 s de jeu.
- **Pourquoi la fenêtre :** le rendu hors écran (`ImageRenderer`) laisse vides les listes défilantes et les interrupteurs : Réglages et le panneau de pause sortaient blancs.
- **Bruit de fond :** les deux passages « avant » sont identiques sur 126 images sur 126.
- **Avant / après :** identiques octet pour octet sur 126 sur 126, et les manifestes confirment que chaque écran a atteint la même phase.
- **Simulateur réel** (iPhone 17, barre d'état figée, 6 écrans lancés directement) :
  - dans un même démarrage, app d'origine / app refactorisée / app d'origine : 6 sur 6 identiques à chaque comparaison ;
  - contre la capture prise avant le redémarrage, 5 sur 6 identiques. `chapitres` diffère de 19 pixels à 1/255, tous dans la barre d'état du système, et l'app d'origine réinstallée montre exactement le même écart : c'est le système, pas l'app.
- **Écart entre les deux versions du harnais :** sur le même code, 103 sur 104. Seul `calibration-verdict` diffère, parce que la v2 reconstruit cette calibration depuis zéro. Le code n'y est pour rien.

## I. Suite de tests (simulateur iPhone 17 Pro)
| État | Suites | Exécutés | Passés | Échoués | Ignorés |
|---|---|---|---|---|---|
| `a4bff43`, état final | 65 | 431 | 429 | 0 | 2 (captures en fenêtre et 82 niveaux) |
| `c3781f7` seul, dans un worktree | 62 | 417 | 417 | 0 | 0 |

`c3781f7` seul compte le même nombre de tests que `b1805a6`, et son pbxproj régénéré est identique à celui du commit.

## J. Compilations
- **Debug simulateur :** réussie.
- **Release appareil signée :** réussie, `net.steve-s.iris`, équipe `G4U9RG5GL7`, `AncreCapture` absent du binaire.
- **Debug appareil signée :** réussie.
- L'iPhone 14 Pro est visible mais rien n'y a été installé, ce qui n'était pas demandé.
- **Audit :** C1, C2, C8, C9, TODO, C10 et C12 passent sur les deux commits.

## K. Diff
- **`c3781f7` :** 101 fichiers, +968 −307. **`a4bff43` :** 5 fichiers, +665.
- `git diff --check` est propre.
- **Zones protégées :** aucune n'est touchée (AR, GameEngine, Audio, Haptics, Domain, App, Config, `project.yml`, `AppCoordinator`, calibration).
- **X·7 :** seul `GameSceneRenderer+Ancre.swift` change, par 5 renommages de couleur.
- **Aucune occurrence ajoutée** de `glassEffect`, `GlassEffectContainer`, `glassEffectID`, `.glass`, `glassProminent`, `TabView`, `Tab`, `NavigationStack`, `toolbar`, `Material` ou `Narration*`. La seule ligne où « glass » apparaît est le style `DSCard .glass`, qui existait déjà et dont seul le jeton a été renommé.

## L. Incidents
- **Mémoire :** deux tâches en arrière-plan ont été tuées faute de mémoire. La machine a 17 Go de RAM, et le swap vit sur le disque interne, qui n'a plus que 3,8 Go libres. J'ai tout refait en séquentiel, et je n'ai rien supprimé sur ce disque.
- **Harnais :** une erreur Swift 6 sur `AnyView` est corrigée en marquant la fermeture de dessin `@MainActor`.

## M. Limites de la preuve
- La barre d'état du système est hors du rendu en fenêtre.
- Réglages est capturé comme écran, pas dans sa feuille. Sa couleur de présentation dans `RootView` n'est couverte que par le test de valeurs D.
- Le jeu est capturé avec une horloge manuelle, sans animation en cours. La respiration du fond n'est prouvée que par sa structure et ses valeurs.
- Aucun contrôle visuel sur l'iPhone physique.

## N. À savoir pour la phase 2 (rien n'a été fait)
- Recolorer `Identity`, `Navigation` et `State` changera aussi le HUD et les surcouches affichés pendant le jeu. C'est voulu, et ni le monde, ni le fond du jeu, ni les palettes ne bougeront.
- `AccentColor`, la teinte globale du système, reste ambre. À recolorer en connaissance de cause.
- Pour une nouvelle preuve avant/après, relancer le harnais avec `TEST_RUNNER_IRIS_CAPTURE_DIR`.

**Verdict :** La frontière entre l'identité UI et le contenu de jeu est désormais suffisamment séparée pour permettre la recoloration de l'interface sans modifier les chapitres. Aucun changement visuel volontaire n'a été introduit.

Phase 1 terminée, je m'arrête ici.
~~~~


---

## 2026-09-15 00:22:40 +0200 (22:22:40Z)
`f88478cc` · `ba0c7536` · ligne 6750

~~~~markdown
# Rapport final — Phase 2 : socle Liquid Glass natif et repli

Le socle est construit, testé et committé, et Iris s'affiche toujours exactement comme avant. Les 126 captures des écrans de production sont identiques octet pour octet à la référence de la Phase 1. Aucun écran n'utilise encore le verre.

## A. État Git initial
- **Emplacement :** `/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris`, branche `feature/iris-liquid-glass-2026`.
- **HEAD :** `a4bff436d5d5…`, conforme à l'attendu.
- **Status :** seuls `SKILL.md` et `x7_silhouette_reference.png` non suivis.
- **Remote :** `origin` (ProdX0x/iris-ios), 3 tags existants.

## B. API réellement présentes dans le SDK
Xcode 26.3 (17C529), SDK iOS 26.2, simulateur iOS 26.3.1.

| API | Disponibilité | Usage |
|---|---|---|
| `glassEffect(_ glass: Glass = .regular, in: some Shape)` | iOS 26.0 | utilisée |
| `Glass` : `.regular`, `.clear`, `.identity`, `tint(_:)`, `interactive(_:)` ; comparable par égalité | iOS 26.0 | utilisée |
| `GlassEffectContainer(spacing:content:)` | iOS 26.0 | utilisée |
| `glassEffectID(_:in:)`, `glassEffectTransition` (`.matchedGeometry`, `.materialize`, `.identity`) | iOS 26.0 | utilisées |
| `glassEffectUnion`, `ConcentricRectangle` | iOS 26.0 | non utilisées |
| `.buttonStyle(.glass)`, `.glassProminent` | iOS 26.0 | galerie seulement, comme référence |
| `.glass(_ Glass)`, `GlassButtonStyle(_:)` | **iOS 26.1** | écartées |
| `scrollEdgeEffectStyle`, `backgroundExtensionEffect`, `ToolbarSpacer`, `tabBarMinimizeBehavior`, `tabViewBottomAccessory` | iOS 26.0 | réservées à la phase navigation |
| `accessibilityReduceTransparency`, `accessibilityReduceMotion`, `colorSchemeContrast` | iOS 13+ | utilisées |

- `simctl ui` sait régler le contraste et la taille de texte, mais n'a aucune option pour « Réduire la transparence ».
- La clé système de ce réglage, `EnhancedBackgroundContrastEnabled`, est confirmée dans le runtime iOS.

## C. Architecture
Six fichiers dans `DesignSystem/Glass`, qui n'importent que SwiftUI :
- `DSGlassRole` : les rôles ;
- `DSGlassShape` : les formes ;
- `DSGlassRendering` : la seule décision natif / translucide / opaque, et fondu ou morphing ;
- `DSGlassSurface` : la surface de repli ;
- `DSGlassModifier` : le modificateur `.dsGlass(role)` ;
- `DSGlassGroup` : le regroupement, plus `.dsGlassID`.

C'est le seul endroit de l'app qui contient `#available(iOS 26…)`. L'appel depuis une vue reste d'une ligne :
```swift
Image(systemName: "pause.fill").frame(width: 48, height: 48).dsGlass(.clearControl)
```

## D. Rôles
| Rôle | iOS 26 | iOS 17–25 | Réduire la transparence | Forme | Réagit au toucher |
|---|---|---|---|---|---|
| clearControl | `Glass.clear` | surface à 60 % avec filet | surface élevée opaque | cercle | oui |
| regularPanel | `Glass.regular` | surface à 88 % avec filet | surface opaque | arrondi 22 pt (`DSRadius.l`) | non |
| chrome | `Glass.regular` | surface élevée à 92 % avec filet | surface élevée opaque | capsule | non |
| prominentAction | `Glass.regular` teinté `Navigation.primary` à 40 % | ambre plein, texte foncé | idem | capsule | oui |

- Le verre reste neutre : seule l'action proéminente porte une teinte.
- Aucune couleur `Chapter` n'est utilisée, et les rayons existants n'ont pas changé.

## E. Comportement sur iOS 26
- `.dsGlass` applique `glassEffect` avec la variante et la forme du rôle.
- `DSGlassGroup` enveloppe `GlassEffectContainer`, et `dsGlassID` ajoute le morphing `.matchedGeometry`.
- Les captures sont réelles, sur le simulateur iOS 26.3.1, avec la ligne « verre natif : oui » affichée à l'écran.
- Les barres système sont laissées au système, sans imitation.

## F. Repli iOS 17–25
- Un remplissage translucide et un filet, sans flou, sans Material, sans animation.
- Aucune vue n'a à écrire `#available`, et le test B le vérifie.
- **Limite :** aucun simulateur iOS 17–25 n'existe sur la machine. Je n'en ai pas créé, pour ménager le disque interne presque plein. Le repli est donc prouvé par les tests et affiché en mode forcé sur iOS 26, avec une étiquette explicite, mais il n'a pas été vu sur un vrai iOS 18.

## G. Réduire la transparence et Augmenter le contraste
- **Réduire la transparence :** tous les rôles passent sur surface opaque, quelle que soit la version. Le contraste du texte est d'au moins 4,5:1, vérifié par test pour les 4 rôles.
- **Capture réelle :** le réglage a été activé (préférence système, puis redémarrage du simulateur), et le manifeste enregistre « réduire la transparence : true ». Les 4 rôles sont opaques, et le système rend aussi ses propres boutons de verre opaques.
- **Augmenter le contraste**, activé via `simctl ui` et confirmé par le manifeste :
  - le système assombrit lui-même le verre natif ;
  - les surfaces de repli prennent un filet renforcé, sans nouveau jeton.
- Les réglages du simulateur ont été remis à leur état initial.

## H. Réduire les animations
- La réaction du verre au toucher est coupée.
- `dsGlassID` passe du morphing à un simple fondu du matériau (`.materialize`), et cette décision est testée.
- Une capture fixe ne peut pas montrer un mouvement : ce point n'est prouvé que par les tests.

## I. Galerie et previews
La galerie vit dans la cible de tests (`Tests/IrisTests/DesignSystem/DSGlassGallery.swift`) et n'apparaît jamais dans l'app : aucun symbole dans le binaire Release, et le test H le vérifie. Elle couvre les 10 points demandés :
- **Page rôles :** contrôles séparés, contrôles réunis, panneau à texte court, panneau à texte long, chrome, action proéminente.
- **Page comparaison :** rendu choisi par le système, repli forcé, opaque forcé, plus les boutons de verre du système en référence.
- **Page texte :** grande taille de texte (accessibility2).
- **Fonds :** un fond simple, et un fond riche de démonstration (bleu-noir, indigo, lumières, fibres). Ses couleurs ne sont pas des jetons et ce n'est pas le futur fond d'Iris.
- **Preview Xcode :** « Rôles de verre », sur le fond d'interface existant.

## J. Captures
11 captures PNG et 3 manifestes, dans `.iris-derived-data/phase2/galerie/` :
- **normal :** roles-simple, roles-riche, comparaison-simple, comparaison-riche, texte-grand-riche ;
- **contraste :** roles-riche, comparaison-riche, texte-grand-riche ;
- **transparence :** roles-riche, comparaison-riche, texte-grand-riche.

**Méthode :** le test garde chaque page affichée, et un script extérieur prend une vraie capture du simulateur. On voit donc le verre réellement composé par le système.

**Corrections après captures :**
- La première série tronquait le texte long en grande taille, parce que la page de galerie ne défilait pas. La galerie défile maintenant, et le panneau grandit entièrement.
- Le renommage `Material` → `Variant` a eu lieu après les captures. C'est un simple identifiant, sans effet visuel, et la suite a été relancée verte.

**Ce que j'observe, à confirmer à l'œil :**
- les contrôles clairs sont très transparents, avec l'effet de lentille visible ;
- le panneau régulier est nettement plus présent et reste lisible sur le fond riche ;
- l'action proéminente donne un ambre-bronze discret ;
- le `.glassProminent` du système, teinté ambre, est vif avec un texte blanc peu contrasté, ce qui a motivé la teinte légère.

## K. Tests
**DSGlassTests (8 tests) :**
- **A :** sur iOS 26, chaque rôle utilise le bon verre natif.
- **B :** le repli est sélectionné sans iOS 26, et `#available` n'apparaît qu'à un seul endroit.
- **C :** « Réduire la transparence » donne une surface opaque au contraste d'au moins 4,5:1 ; « Augmenter le contraste » renforce le filet ; les transitions changent sous « Réduire les animations ».
- **D :** les quatre rôles restent distincts.
- **E :** aucune couleur `Chapter` ni palette de chapitre.
- **F :** SwiftUI seul, sans moteur, Timer, DisplayLink, Canvas ni flou.
- **G :** aucune API de réalité augmentée, de regard, de calibration, de physique, d'audio ou d'haptique.
- **H :** aucun usage du socle dans l'app.

**I et J :**
- les protections de la Phase 1 restent vertes ;
- les 82 niveaux sont intacts ;
- les écrans de production sont identiques sur 126 images sur 126.

| État | Suites | Tests | Passés | Échoués | Ignorés |
|---|---|---|---|---|---|
| `25135a3` (final) | 67 | 440 | 437 | 0 | 3 (tests réservés aux captures) |
| `b740654` seul (worktree) | 65 | 431 | 429 | 0 | 2 |

## L. Compilations
- **Debug simulateur :** réussie, sur l'état final et sur le premier commit seul.
- **Release appareil signée :** réussie sur l'état final, identité `net.steve-s.iris`, équipe G4U9RG5GL7, galerie absente du binaire.
- **Debug appareil signée :** réussie sur l'état final. L'iPhone 14 Pro est visible, rien n'y a été installé.
- **Audit :** vert sur les deux commits.

## M. Performance
- Le socle ne contient que des surfaces SwiftUI natives : aucun flou fait main, Timer, TimelineView, DisplayLink ni Canvas (test F).
- Il n'accède ni au moteur ni à `GameSceneSnapshot`.
- `DSGlassGroup` évite d'empiler du verre sur du verre, et le repli se limite à un remplissage et un filet.
- La règle « pas de grande surface de verre animée au-dessus du jeu » est écrite dans l'ADR-23 et dans les interdits.
- **Non mesuré :** le coût réel du verre au-dessus du jeu sur appareil, puisque rien n'y est encore posé.

## N. Fichiers
- **`b740654` feat (10 fichiers, +356) :** les 6 fichiers de `DesignSystem/Glass` ; `architecture.md` (ADR-23 et 2 nouveaux interdits) ; `design-system.md` ; `file-map.md` ; pbxproj.
- **`25135a3` test (5 fichiers, +499) :** `DSGlassTests`, `DSGlassGallery`, `DSGlassGalleryCaptureTests`, pbxproj, `file-map.md`.
- Aucun fichier de code existant n'a été modifié.

## O. Zones non modifiées
Rien n'a bougé dans :
- **les écrans :** Seuil, Chapitres, Carnet, Réglages, jeu, pause, intro, résultat, calibration, caméra, indisponibilité, fin de parcours ;
- **la navigation :** aucun TabView, toolbar ni NavigationStack, ni route ou coordinateur ;
- **le visuel :** jetons, assets, palette et `project.yml` ;
- **le jeu et ses données :** Gaze Engine, ARKit et TrueDepth, calibration, GameEngine, physique, progression, campagne, X·7, audio, haptique, pars, logique oculomotrice, `GameViewModel`, données des 82 niveaux ;
- **la narration :** rien n'a été ajouté.

C'est vérifié par le diff de `a4bff43` à `25135a3` et par le test H.

## P. Git final
- **Historique :** HEAD `25135a3`, précédé de `b740654`, puis `a4bff43` et `c3781f7`.
- **Status :** seuls les deux fichiers non suivis d'origine, intacts.
- **Push, tags, main :** aucun push, aucun tag, `main` toujours à `52f20b7`, aucun worktree restant.

## Q. Limites connues
1. Le repli n'a jamais été vu sur un vrai iOS 17–25.
2. Les captures viennent du simulateur, pas de l'iPhone.
3. « Réduire les animations » n'est pas démontré visuellement.
4. La teinte de l'action proéminente (40 %) est un point de départ à valider.
5. Le rôle chrome n'a pas été confronté à une vraie barre système.
6. Le coût du verre au-dessus du jeu n'est pas mesuré.
7. La mémoire de la machine est très limitée (swap sur un disque interne presque plein) : tout a été exécuté en séquence.

## R. Recommandation pour la Phase 3
1. Faire d'abord la revue visuelle des 11 captures, en particulier la teinte proéminente et la présence du panneau.
2. Piloter ensuite un seul contrôle clair, hors jeu actif, avec captures avant/après.
3. Ne poser du verre au-dessus du jeu qu'après une mesure sur l'iPhone.

---

**VERDICT PHASE 2**

Vrai Liquid Glass natif disponible :
OUI

Fallback disponible :
OUI

Clear control :
Natif `Glass.clear`, réagit au toucher, en cercle ; repli translucide ; opaque sous Réduire la transparence. Capturé.

Regular panel :
Natif `Glass.regular`, arrondi 22 pt, grandit avec le texte ; repli translucide ; opaque sous Réduire la transparence. Capturé avec texte court, long et grand.

Chrome :
Natif `Glass.regular` en capsule, pour conteneur personnalisé ; les barres système restent au système. Capturé, mais pas confronté à une vraie barre.

Prominent action :
Natif `Glass.regular` teinté ambre à 40 %, réagit au toucher ; repli ambre plein. Capturé, teinte à valider.

Reduce Transparency :
Surface opaque pour les 4 rôles, sur toutes les versions. Capturé avec le réglage réellement activé ; contraste d'au moins 4,5:1 testé.

Écrans de production migrés :
0

Nouvelle palette appliquée :
NON

Navigation modifiée :
NON

Narration ajoutée :
NON

Tests :
440 tests dans 67 suites : 437 passés, 0 échec, 3 ignorés (tests réservés aux captures). Premier commit seul : 431 tests, 429 passés, 0 échec, 2 ignorés. Écrans de production identiques sur 126 captures sur 126.

Builds :
Debug simulateur OK · Release appareil signé OK · Debug appareil signé OK · audit vert

Push :
AUCUN

Tag :
AUCUN

Première action recommandée pour Phase 3 :
Revue visuelle humaine des 11 captures de la galerie (teinte proéminente, présence du panneau), puis un pilote limité à un seul contrôle clair hors jeu actif, avec captures avant/après.

Je m'arrête ici.
~~~~


---

## 2026-09-15 22:54:19 +0200 (20:54:19Z)
`f88478cc` · `f4f8ba09` · ligne 6907

~~~~markdown
# Rapport final — Phase 2B : raffinement visuel du socle Liquid Glass

Les variantes demandées existent et sont capturées. Aucun écran de production n'a bougé : les rôles gardent leurs rendus de la Phase 2 tant que vous n'avez pas choisi. Tout est dans deux commits locaux, sans push ni tag.

## A. HEAD de départ
- Branche `feature/iris-liquid-glass-2026`, HEAD `25135a3478aa…`, conforme.
- Seuls `SKILL.md` et `x7_silhouette_reference.png` n'étaient pas suivis, et aucun travail Phase 2B n'avait été entamé.

## B. Variantes créées
**Recette de verre.** Chaque rôle possède maintenant une `DSGlassRecipe` : variante native (clair ou régulier), teinte, couleur de texte, contour et réaction au toucher. Cela permet d'afficher une recette candidate avec les surfaces de repli et d'accessibilité propres au rôle, donc exactement comme elle serait livrée. En production, l'appel `.dsGlass(role)` ne change pas.

**Candidates.** Elles vivent uniquement dans la cible de tests :
- **Page « Sélection Iris Liquid Glass » :** le contrôle clair validé, 3 panneaux, 3 chromes, 4 actions principales et 2 rayons sur une seule page.
- **Pages ciblées :** panneaux, chrome, action principale et grande taille de texte.
- **Fonds :** le fond riche d'origine, plus une version calme du même fond.

## C. Panneaux
| Variante | Recette native | Observé |
|---|---|---|
| current | `Glass.regular`, sans teinte (rendu Phase 2) | bloc bleu-noir |
| airy | `Glass.clear` + teinte `Identity.ground` à 12 % | le fond traverse fortement (lettres, anneaux) ; texte lisible mais agité derrière un texte long |
| balanced | `Glass.clear` + teinte `Identity.ground` à 32 % | verre fumé : fond et réfraction perceptibles, texte net |

- **Pourquoi une teinte et pas un aplat :** `Glass.regular` ne peut pas être éclairci. Le seul levier natif est `Glass.clear`, et la lisibilité revient par une teinte neutre sombre posée dans le verre, sans remplissage séparé.

## D. Chrome
Les trois barres ont la même mise en page. C'est une simulation, pas une TabView.

| Variante | Recette native | Observé |
|---|---|---|
| current | `Glass.regular` en capsule | grosse barre sombre |
| clear | `Glass.clear` | très aérienne ; la lentille déforme ce qui passe sous les libellés |
| balanced | `Glass.clear` + teinte `Identity.ground` à 20 % | flottante et translucide, sans capsule noire |

## E. Action principale
| Variante | Recette | Observé |
|---|---|---|
| current Phase 2 | `Glass.regular` teinté ambre (`Navigation.primary`) à 40 % | capsule bronze, la version rejetée |
| neutral glass | `Glass.clear`, texte ambre, contour ambre à 50 % | reste du verre ; la priorité passe par le texte et le contour |
| spectral hint | `Glass.clear` + violet exploratoire à 20 %, galerie seulement, pas un jeton | verre lavande léger, texte clair |
| référence système | `.buttonStyle(.glassProminent)` | ambre vif plein, libellé peu contrasté |

## F. Rayons comparés
- Sur le panneau balanced : 22 pt (le rayon actuel, `DSRadius.l`) contre 16 pt. `DSRadius` n'a pas été modifié.
- `ConcentricRectangle` n'est pas présenté. Il n'a de sens que dans un conteneur aux coins connus, comme une feuille ou une fenêtre ; un panneau libre dans une page n'en tire rien.
- Le cercle est gardé pour les contrôles, la capsule pour les actions compactes et le chrome.

## G. Accessibilité
- **Réduire la transparence :** capture faite avec le réglage réellement actif. Panneaux, chromes et contrôles deviennent opaques. Les quatre actions principales passent en ambre plein avec texte foncé ; la couleur de texte de « neutral » ne s'applique qu'au verre natif, donc elle reste lisible.
- **Augmenter le contraste :** capture faite avec le réglage réellement actif. Le système assombrit lui-même le verre natif.
- **Réduire les animations :** logique inchangée (réaction au toucher coupée, fondu au lieu du morphing), vérifiée par les tests.
- **Dynamic Type :** en accessibility2, les trois panneaux grandissent et rien n'est tronqué.
- **Contrôle clair :** les 5 pages de la Phase 2, redessinées avec la nouvelle recette, sont identiques octet pour octet à leurs captures d'origine.

## H. Captures générées
Dans `.iris-derived-data/phase2b/galerie/`, PNG 1206×2622, simulateur iOS 26.3.1 :
1. `selection-iris-rich-normal.png`
2. `selection-iris-calm-normal.png`
3. `selection-iris-rich-large-text.png` : seulement la section panneaux en accessibility2, car la page complète ne tient pas dans un écran à cette taille.
4. `selection-iris-rich-high-contrast.png`
5. `selection-iris-rich-reduce-transparency.png`
6. `panels-comparison.png` : titre, corps court et corps long.
7. `chrome-comparison.png`
8. `prominent-comparison.png`

S'y ajoutent les 5 recaptures de référence de la Phase 2, identiques aux originales, et 4 manifestes qui enregistrent l'état système réel pendant chaque passage.

## I. Tests
**`DSGlassTests` compte maintenant 11 tests :**
- A à H adaptés aux recettes ;
- **I :** le contrôle clair garde exactement son verre, sa forme et ses surfaces, et les autres rôles gardent leurs recettes Phase 2 ;
- **J :** les recettes candidates, les fonds de démonstration et la couleur spectrale n'apparaissent jamais dans l'app ;
- **K :** la navigation reste intacte (aucune TabView, NavigationStack ni toolbar), avec les empreintes des 5 fichiers de navigation figées jusqu'à la phase navigation.

**Protections existantes :**
- les protections de la Phase 1 restent vertes et les 82 niveaux sont intacts ;
- les écrans de production sont identiques sur 126 captures sur 126.

| État | Suites | Tests | Passés | Échoués | Ignorés |
|---|---|---|---|---|---|
| `4e8283d` (final) | 67 | 443 | 440 | 0 | 3 (tests réservés aux captures) |
| `65bae13` seul (worktree) | 67 | 443 | 440 | 0 | 3 |

## J. Compilations
- **Debug simulateur :** réussie, sur l'état final et sur le premier commit seul.
- **Release et Debug signés pour appareil :** réussis sur le contenu final (identique aux commits), `net.steve-s.iris`, équipe G4U9RG5GL7, aucune trace de la galerie dans le binaire Release.
- **Audit :** vert sur les deux commits.

## K. Fichiers modifiés
- **`65bae13` feat (6 fichiers, +150 −52) :**
  - `DSGlassRecipe.swift` (nouveau), `DSGlassRole.swift`, `DSGlassModifier.swift` ;
  - `DSGlassTests.swift` ;
  - `file-map.md`, pbxproj.
- **`4e8283d` test (8 fichiers, +360 −53) :**
  - `DSGlassSelectionGallery.swift` et `GalleryDemoGround.swift` (nouveaux) ;
  - `DSGlassGallery.swift` (le fond en est sorti), `DSGlassGalleryCaptureTests.swift` ;
  - `design-system.md`, `architecture.md` (note ADR-23), `file-map.md`, pbxproj.

## L. Confirmations
- **Production migrée :** 0.
- **Navigation :** inchangée.
- **Palette de production :** inchangée ; seules des teintes `Identity` sont utilisées, et le violet reste dans la galerie.
- **Jeu :** inchangé.
- **Narration :** absente.
- **Git :** HEAD `4e8283d`, aucun push, aucun tag, `main` intacte, fichiers non suivis intacts.

---

**VERDICT PHASE 2B**

Clear control :
VALIDÉ (inchangé, redessiné identique octet pour octet)

Regular panel recommandé par Claude :
**Balanced** (`Glass.clear` + teinte sombre neutre à 32 %). Le fond et la réfraction restent perceptibles, le texte reste net sur les fonds riche et calme. Airy est plus beau en transparence, mais s'agite derrière un texte long.

Chrome recommandé par Claude :
**Balanced** (`Glass.clear` + teinte sombre neutre à 20 %). La barre est flottante et translucide, sans capsule noire. Clear est le plus léger, mais sa lentille déforme fortement ce qui passe sous les libellés.

Prominent action recommandé par Claude :
**Neutral glass** (`Glass.clear`, texte et contour ambre). L'action reste du verre et sa priorité est claire, sans bloc coloré. Spectral est à réévaluer avec la future palette.

Rayon recommandé :
**16 pt** pour les panneaux, cercle pour les contrôles, capsule pour les actions compactes et le chrome.

Ces recommandations ne sont pas appliquées : les rôles de production gardent leurs recettes Phase 2 jusqu'à votre choix.

Les variantes sont prêtes pour validation visuelle humaine.
~~~~


---

## 2026-09-14 16:42:34 +0200 (14:42:34Z)
`4a1b6284` · `9f513ce6` · ligne 183

~~~~markdown
# RAPPORT D'AUDIT DE MATURITÉ — IRIS

**Date :** 14 septembre 2026. **Auditeur :** Claude, en lecture seule.

**Aucune modification du dépôt.** `git status` est identique avant et après l'audit : seuls `SKILL.md` et `x7_silhouette_reference.png` sont non suivis, et ils l'étaient déjà. Les artefacts de build et de tests sont hors du dépôt, dans `.iris-derived-data/` et dans le scratchpad. Le projet XcodeGen de contrôle a été généré dans le scratchpad, pas dans le dépôt.

**Légende :** **[V]** = vérifié par commande ou lecture de code · **[I]** = inféré · **[NV]** = non vérifiable depuis le dépôt.

---

## 1. État Git [V]

| Élément | Valeur |
|---|---|
| Branche courante | `prototype/x7-stabilisation-head-guidance` |
| HEAD | `3abddb732b8ad54c04fe27d9acdd967d49535176` |
| Fichiers suivis modifiés | aucun |
| Fichiers non suivis | `SKILL.md`, `x7_silhouette_reference.png` (1,3 Mo) |
| Remote | `origin` = `https://github.com/ProdX0x/iris-ios.git` |
| Divergence de la branche courante | **n'existe pas sur origin** (jamais poussée) |
| Autres branches locales (12) | toutes synchronisées avec origin, sauf `feature/iris-v2` (1 commit local non poussé) |
| `main` | bloquée à `52f20b7` (« complete Iris v2 refactor »). HEAD a **32 commits d'avance**, et tout le travail depuis le 11/09 vit hors de `main`. |
| Tags | `baseline-expansion-v1` → `788da20`, `iris-expansion-human-validated-v1` → `c6d9581`, `iris-ch1-oculomotor-human-validated-v1` → `ee2d3bd` |
| Historique | 35 commits du 11 au 14/09/2026 (4 jours), 1 auteur, 33 commits avec co-auteur IA |
| `.git` | 12 Mo |

---

## 2. Inventaire technique

### 2.1 Structure [V]
387 fichiers suivis : 290 Swift, 47 JSON (assets et fixtures), 36 Markdown, 2 **zip**, 1 HTML de référence, `project.yml`, un projet Xcode généré mais suivi.

| Couche | Contenu |
|---|---|
| `App/` | DI, persistance, plateforme |
| `Domain/` | campagne, entités, validation, progression, value objects |
| `GameEngine/` | Oculo, environnement, session, physique, horloge, bruit, gaze |
| `AR/` | services ARKit, calibration, projection |
| `Audio/`, `Haptics/` | services et politiques |
| `Navigation/`, `Features/` | 11 écrans |
| `DesignSystem/`, `Resources/` | composants, tokens, assets |
| `Tests/IrisTests` | tests unitaires |
| `Tools/` | `audit.py`, `MakeAppIcon.swift` |
| `Docs/`, `Design/` | documentation, plus 3 rapports à la racine |

### 2.2 Mesure des lignes [V]
**Méthode.** Script Python sur les fichiers `*.swift` suivis par Git. Chaque ligne est classée : vide, commentaire (ligne commençant par `//`, ou bloc `/* */`), ou code. Les commentaires en fin de ligne comptent comme du code.

Mesure croisée : le compilateur (xccov) compte **11 832 lignes exécutables** dans l'app. C'est la mesure la plus proche du « code effectif » : les accolades et déclarations seules en sont exclues.

| Périmètre | Fichiers | Physiques | Vides | Commentaires | Code |
|---|---|---|---|---|---|
| **Produit** | 219 | 16 280 | 1 586 | 1 624 | **13 070** |
| **Tests** | 70 | 8 750 | 1 060 | 390 | **7 300** |
| Outils | 1 | 70 | 4 | 9 | 57 |
| **Total Swift** | 290 | 25 100 | 2 650 | 2 023 | **20 427** |

- Ratio code de test / code produit : **0,56**.
- Documentation Markdown suivie : 36 fichiers, 4 145 lignes (3 164 non vides).
- Les 19 932 lignes annoncées auparavant sont cohérentes à ±2,5 % près ; l'écart vient de la méthode de comptage.

**Répartition du code produit par sous-système :**

| Sous-système | Lignes de code | Part |
|---|---|---|
| Features (UI et ViewModels) | 4 479, dont Game 3 102 | 34 % |
| GameEngine | 2 776, dont Oculo 1 451 | 21 % |
| Domain | 2 345, dont Campaign 1 904 (niveaux déclarés en données) | 18 % |
| AR / Gaze | 1 258 | 10 % |
| DesignSystem | 941 | 7 % |
| Audio | 475 | 4 % |
| Navigation | 365 | 3 % |
| App | 337 | 3 % |
| Haptics | 94 | <1 % |

**Ce que ce volume signifie.**
- Environ 13 000 lignes de produit, c'est un projet de taille moyenne pour une app iOS indépendante.
- La densité est élevée : peu de code de liaison, beaucoup de logique pure.

**Ce qu'il ne signifie pas.**
- Ni qualité, ni maturité, ni fiabilité.
- Il n'y a aucun code tiers, donc tout est du code propre au projet. Mais environ 1 900 lignes sont des données de niveaux écrites en Swift, pas de la logique.
- Le projet a été produit en 4 jours avec forte assistance IA [V, co-auteurs des commits]. Le volume ne reflète donc pas un effort humain proportionnel, ni une maturation dans le temps.

### 2.3 Frameworks et dépendances [V]
- **Apple uniquement :** Foundation, SwiftUI, simd, UIKit, os, Observation, AVFoundation, ARKit, CoreGraphics, QuartzCore, ImageIO, CryptoKit (celui-ci dans les tests), UniformTypeIdentifiers.
- **Zéro dépendance externe :** aucun paquet SPM, CocoaPods ou SDK tiers.

---

## 3. Architecture

### Carte
```
IrisApp → AppContainer (racine de composition : live / preview / simulator)
   │
   ├── Navigation : AppCoordinator (routes, progression) → RootView (scenePhase)
   │       └── Features/* (Views SwiftUI + ViewModels @Observable @MainActor)
   │              ├── GameViewModel ─► GameSession (GameEngine, pur) ─► Domain
   │              │        │                └── Oculo *StageState, Environment, Physics
   │              │        ├── GameSceneSnapshot (immuable) ─► GameSceneRenderer (Canvas)
   │              │        ├── GazeTrackingService (protocole) ◄── ARKit | Simulated
   │              │        ├── AudioService (protocole) ◄── AVAudioEngine + SineSynth
   │              │        └── HapticFeedbackService, GameClock (CADisplayLink)
   │              └── GazeSetupViewModel ─► Readiness → FixationSequence → AffineTransform2D
   └── Persistence : ProgressStore / CalibrationStore (UserDefaults | InMemory)
```

**Points forts [V]**
- **Frontières appliquées par un outil.** `Domain` et `GameEngine` n'importent que Foundation. `Tools/audit.py` interdit SwiftUI, UIKit et ARKit dans ces couches, et la vérification passe (C1 = 0 violation).
- **Injection par protocoles.** Tous les services passent par le constructeur, avec des variantes Silent, Stub, InMemory ou Manual. Aucun singleton applicatif.
- **Cœur de jeu déterministe et pur.** `GameSession` utilise un pas de temps borné à 0,1 s découpé en sous-pas, avec un LCG et un bruit reproductibles.
- **Rendu isolé.** Le rendu se fait par snapshot immuable, et l'observation par frame est limitée au Canvas (`GameCanvasView.swift:20-28`).

**Points faibles [V]**
- **`GameViewModel` (586 lignes) porte trop de responsabilités.** Environ 30 propriétés : cycle de vie, boucle, regard, audio, haptique, consignes, résultats, recalibration. 12 blocs `#if DEBUG` y sont mêlés au gameplay. C'est la dette principale.
- **Fonctions longues.** `GameSession.tick` fait 153 lignes, `OculoSnapshot.scene` 123, `drawOculoElement` 97.
- **Dispatch répétitif.** `OculoStageState` utilise un switch à 10 cas répété pour `update`, `isComplete` et `progress`, soit 4 endroits à modifier par nouvelle étape.
- **Code prototype ou diagnostic dans les dossiers produit.** `PrototypeLevelCatalog` n'est utilisé que par les tests. `OculomotorTrace` est compilé en Release ; ce n'est pas une fuite de comportement, il est seulement instancié en DEBUG.

---

## 4. Qualité du code [V]

| Indicateur | Produit |
|---|---|
| `fatalError` / `try!` / `as!` / force unwrap / `precondition` | **0 / 0 / 0 / 0 / 0** (confirmé par `audit.py` C9) |
| TODO / FIXME / HACK | 0 |
| `print(` dans l'app | 0 (le seul se trouve dans `Tools/`, hors cible) |
| Mode de compilation | Swift 6, `SWIFT_STRICT_CONCURRENCY: complete`, `ExistentialAny` |
| Warnings compilateur | 0 (tests : seulement 2 notices `appintentsmetadataprocessor`, émises par l'outillage Xcode) |
| `@MainActor` / `Sendable` / `@unchecked Sendable` | 42 / 207 / 7 |
| `try?` | 12 réels (2 faux positifs) |
| Fichier le plus long | `GameSceneRenderer.swift`, 644 lignes |

**`@unchecked Sendable`.** Les 7 occurrences sont justifiées : protection par `NSLock`, `UserDefaults` thread-safe, ou synthé à un écrivain par thread. Deux concernent des doubles de test livrés dans le code produit.

**`try?`.** Quatre avalent réellement des pertes de données : décodage et encodage de la progression et de la calibration.

**Limite de la mesure des warnings.** Les builds étaient incrémentaux sur un DerivedData existant : « 0 warning » ne couvre donc que les fichiers recompilés. Le README déclare aussi 0 warning sur build complet [NV aujourd'hui].

**Documentation interne.** Elle n'est plus à jour [V] :
- `Docs/architecture.md` mentionne encore « 6 chapitres, 34 niveaux » et un type `GameProgression` qui n'existe plus.
- `Docs/conventions.md` affirme « pas de persistance », alors qu'elle existe.

---

## 5. Tests et assurance qualité

### Exécution réelle [V]
Commande : `xcodebuild test`, simulateur iPhone 17 Pro (iOS 26.3.1), Debug.

| Déclarés `@Test` | Exécutés | Passés | Échoués | Ignorés | Échecs attendus | Résultat |
|---|---|---|---|---|---|---|
| 406 | 406 | **406** | 0 | 0 | 0 | **TEST SUCCEEDED** (environ 62 s) |

- 62 `@Suite`, 1 544 assertions `#expect` / `#require`.
- **Aucun test paramétré** (`arguments:` n'apparaît que dans le code produit) : 406 déclarés = 406 exécutés.

### Nature des tests [V]
- **Unitaires :** physique, validation, règles, calibration, filtres, politiques audio et haptiques, DSP du synthé.
- **Traces golden :** comparaison frame par frame avec le moteur JavaScript de référence, tolérance 1e-6.
- **Simulation :** `CampaignBot` joue les 70 niveaux et vérifie faisabilité et nécessité.
- **Protection des niveaux validés :** empreintes SHA-256 de 33 fichiers source figés, plus un dump comportemental.
- **ViewModels et coordinateur :** machines d'états complètes avec mocks, y compris interruptions, arrière-plan, visage perdu et erreurs.
- **Absents :** aucune cible de tests UI, aucun test snapshot, aucun test de performance.

### Couverture mesurée [V]
xccov : **62,07 % de l'app** (7 344 / 11 832 lignes).

| Zone | Couverture |
|---|---|
| GameEngine (Session, Oculo, Environment, Campaign, Physics) | 96–100 % |
| AR/Calibration | 96 % |
| Domain | 90–100 % |
| Politiques audio et haptiques, Synth | 96–100 % |
| AppCoordinator | 86 % |
| Features/Game | 49 % |
| AR/Services | 37 % (`ARKitGazeTrackingService` à **0 %**) |
| Features/GazeSetup | 31 % |
| DesignSystem/Components | 27 % |
| Audio/Services | 2 % (`AVAudioEngineAudioService` à **0 %**) |
| Settings, Carnet, JourneyComplete, Unavailable, Haptics/Services | **0 %** |

**Zones importantes non testées :**
- acquisition ARKit réelle (axes, pose de tête) ;
- rendu Canvas ;
- moteur audio ;
- horloge `CADisplayLink` ;
- persistance corrompue ;
- échec AR suivi d'une reprise ;
- visage suivi sans intersection de rayon prolongée.

**Validation humaine [NV].** Selon les tags et le README, elle a eu lieu sur iPhone 14 Pro. Aucune preuve exécutable n'existe dans le dépôt.

---

## 6. Builds et reproductibilité

| Vérification | Résultat |
|---|---|
| Debug, simulateur (via test) | **SUCCEEDED** [V] |
| Release, `generic/platform=iOS` | **SUCCEEDED**, signé « Apple Development », profil automatique « iOS Team Provisioning Profile: * » [V] |
| Bundle ID | `net.steve-s.iris`, tests `net.steve-s.iris.tests` [V] |
| Équipe | `G4U9RG5GL7`, signature automatique [V] |
| Cohérence `project.yml` ↔ pbxproj | régénération dans le scratchpad : **aucune différence de fond**, seulement les chemins relatifs dus à l'emplacement [V] ; `audit.py` C12 passe |
| Archive, export IPA, TestFlight | non exécutés, aucune trace dans le dépôt [NV] |
| CI | **absente** (pas de `.github/`, pas de fastlane ni de Xcode Cloud) [V] |
| Version | `MARKETING_VERSION 1.0` / `CURRENT_PROJECT_VERSION 1`, jamais incrémentée [V] |

**Reprise par un autre développeur.** Elle est bonne, sous deux conditions : XcodeGen et Xcode 26.3. Il faut aussi changer d'équipe de signature, ce qui est volontairement verrouillé et documenté.

**Point faible.** Le pbxproj généré est suivi par Git : c'est un risque de divergence, atténué par C12.

---

## 7. Fiabilité et robustesse [V sauf mention]

**Ce qui est bien géré :**
- **États typés :** `GamePhase` (10 cas), `GameFailure`, `GazeTrackingState`, `CalibrationFitError`.
- **Interruptions :** interruption ARSession, puis `.starting` et reprise ; interruptions audio, changement de configuration et reset des media services avec reconstruction du moteur.
- **Arrière-plan et avant-plan :** `scenePhase` suspend en inactive ou background et réveille en active (`RootView.swift:63`).
- **Matériel et permissions :** absence de TrueDepth vers l'écran Unavailable ; permission caméra refusée ou restreinte gérée.
- **Horloge :** `stop()` remet le timestamp à zéro, donc aucun delta géant à la reprise.
- **Visage perdu :** timeout de 0,3 s vers `.faceLost`, testé.

**Défauts confirmés :**
1. **Perte silencieuse de progression.** Un échec de décodage ou une version différente fait retourner une progression vide, et la sauvegarde suivante écrase les données (`UserDefaultsProgressStore.swift:14-21`). Il n'y a ni migration ni log. Renommer un cas de `GameElement` effacerait toute la progression [I].
2. **Bug de viewport.** Un second `prepare` transmet les **anciens** `bounds` (`GameViewModel.swift:118-120`, idem dans GazeSetup). L'impact est faible, l'app étant en portrait seulement [I].
3. **Curseur figé.** Si le visage reste suivi mais qu'aucun rayon n'intersecte le plan, ou si les frames cessent, le timeout ne se déclenche pas et le curseur reste figé. Cela contredit le « aucun point périmé » du rapport Gaze v2.
4. **Pas de reprise automatique** après un échec AR, et `.failed(message: String)` n'est pas typé.
5. **Calibration invalide acceptée.** « Continuer quand même » enregistre un profil `isValid:false` que le jeu accepte ensuite.
6. **Installation sur appareils sans TrueDepth.** `UIRequiredDeviceCapabilities` ne déclare que `front-facing-camera` : l'app s'installe sur des appareils incompatibles, où elle est bloquée à l'exécution.

---

## 8. Gaze Engine / ARKit / TrueDepth [V sauf mention]

**Pipeline :**
```
ARFaceAnchor (isTracked) → rayon milieu des yeux → lookAtPoint → plan z=0
  → AxisMapping (inter-yeux + gravité, vote de majorité ≥ 0,8)
  → géométrie nominale (ppi estimé par famille) → affine 6 coeff. → points
  → GazeFilter (EMA α = 0,1, rejet de saut > 300 pt sauf 3 consécutifs) → gameplay
```

**Acquisition :**
- `ARFaceTrackingConfiguration`, 1 visage, format ≥ 60 fps.
- Délégué sur `.main` avec `MainActor.assumeIsolated`. C'est correct, et piégeant si la file change.
- Aucune `ARFrame` n'est retenue.
- Pose de tête (yaw, pitch, roll) utilisée par le gameplay oculomoteur.

**Calibration :**
- Porte de *readiness* : 10 critères stables pendant 1 s.
- Grille 3×3 : stabilisation 0,3 s, collecte de 0,8 à 2,5 s, une reprise par point.
- Agrégation robuste : médiane et coupure à 3,5 × MAD, au moins 12 échantillons, clignements exclus.
- Moindres carrés ordinaires **sans régularisation**, refus des cas dégénérés.
- Critère de vérification : erreur moyenne ≤ 18 %, maximum ≤ 30 %.

**Invalidation de la calibration.** Déclenchée par la version, l'orientation, le viewport à ±1 %, un âge supérieur à 30 jours ou des valeurs non finies. **Pas** par la distance, la posture ou un changement d'utilisateur.

**Limites :**
- **Vérification optimiste.** Les 5 cibles de vérification sont des points de la grille d'apprentissage : aucun point hors apprentissage n'est testé, et la précision est probablement surestimée [I].
- **Filtre simple.** Un EMA à α fixe par échantillon, non indexé sur le temps : la constante dépend de la fréquence ARKit [I].
- **Clignements en jeu.** Pas de rejet dédié ; `blinkDetector` est déclaré mais inutilisé dans `GazeReadinessEvaluator.swift:27`.
- **Seuil fixe.** Le seuil de saut de 300 pt n'est pas proportionné à l'écran.
- **Incohérence de message.** La plage de distance est de 15–90 cm dans le code, mais l'utilisateur lit « 20 à 80 cm ».

**Séparation et tests.** Acquisition, mapping et gameplay sont bien séparés par le protocole `GazeTrackingService` et des structs pures ; la calibration mathématique est couverte à 96 %. L'acquisition ARKit réelle est à 0 % et ne peut être confirmée que sur appareil.

**Sophistication.** C'est le point le plus élaboré du projet : axes résolus par mesure plutôt que présumés, agrégation robuste, machine d'états de setup testée. Le traitement du signal reste de niveau jeu : pas de One-Euro ni de Kalman, pas de compensation de dérive tête ou distance. Aucune affirmation médicale n'est faite ici.

---

## 9. Performance

**Observé [V] :**
- `CADisplayLink` à 60 Hz, sous-pas bornés.
- Canvas synchrone, observation par frame restreinte.
- Synthé temps réel sans verrou bloquant (`withLockIfAvailable`), sans allocation.
- Aucun log par frame en Release.

**Risques théoriques [I], non mesurés :**
- Tout se passe sur le main thread : frames ARKit, physique, rendu.
- Snapshot reconstruit à chaque tick (`.map`), gradients recréés à chaque dessin.
- Dictionnaire `blendShapes` ponté à chaque frame.
- Trafic ARC sur des tableaux dans le thread audio.

**Non démontré.** Aucun profil Instruments, énergie, thermique ou mémoire n'existe dans le dépôt [NV]. Le README ne fait état d'aucun problème de fluidité ressenti par l'humain [NV].

---

## 10. Sécurité et confidentialité [V]

- **Réseau :** 0 URL `http(s)` dans le code, 0 `URLSession`, 0 SDK analytics ou crash, 0 secret. Les hits de la recherche « token » sont des noms de variables de design ou de NotificationCenter.
- **Données stockées :** `UserDefaults` uniquement, avec préférences, profil de calibration (coefficients, sans échantillon) et progression. Aucune image, géométrie de visage ou donnée de regard n'est persistée.
- **Permission :** `NSCameraUsageDescription` claire et exacte.
- **Exception DEBUG :** `AncreCapture` écrit angles de tête et regard x/y dans un JSONL de `tmp`, uniquement avec `--iris-capture`. Absent en Release.
- **Manquant :** **`PrivacyInfo.xcprivacy` absent**. L'usage de `UserDefaults` est une *required-reason API*, ce qui bloque la soumission App Store [V : absence ; exigence Apple = connaissance externe].
- **Hygiène :** deux archives zip sans rapport avec l'app (`SwiftUI-Agent-Skill-main.zip`, `ios-app-skills.zip`) sont suivies dans Git.

L'absence d'analytics et de cloud est un **choix cohérent** avec le produit et n'est pas pénalisée.

---

## 11. UX, accessibilité et localisation [V]

**Présent :**
- Reduce Motion appliqué largement, y compris dans le renderer (85 occurrences).
- Dynamic Type par styles de texte (`DSFont`), sans `@ScaledMetric`.
- Environ 49 modificateurs VoiceOver.
- Cibles ≥ 44 pt [déclaré dans le README, I].

**Absent :**
- **Localisation :** 0 `.xcstrings`, 0 `String(localized:)`, `SWIFT_EMIT_LOC_STRINGS: NO`, environ 238 littéraux français dans `Domain/Campaign`. L'app est française uniquement.
- **Orientation :** portrait seulement sur iPhone.
- **iPad :** famille d'appareils 1,2, mais faisabilité des niveaux non vérifiée sur iPad (aveu du README § 12).
- **Tests UI :** aucun, et les vues sont à 0 % de couverture.
- **Nature du jeu :** l'expérience au regard est par essence inaccessible à VoiceOver (Canvas `accessibilityHidden`). C'est inhérent au produit.

---

## 12. Documentation et maintenabilité humaine [V]

**Contenu :**
- README de 75 Ko : signature, architecture, pipeline Gaze, tests, builds, validation, « limites honnêtes ».
- `Docs/` : architecture, conventions, modèle de domaine, file-map vérifiée par C10, fiches par fonctionnalité.
- `Design/` : 17 documents, invariants, décisions de corrections faisant office d'ADR informels.

**Défauts :**
- Le README est un **journal chronologique** (§ 0 à § 22), pas une documentation structurée.
- `architecture.md` et `conventions.md` sont obsolètes.
- 3 rapports traînent à la racine.

**Réponse à la question posée : oui.** Un développeur iOS expérimenté pourrait compiler (XcodeGen, commandes exactes), tester (406 tests verts, environ 1 min) et modifier le cœur (couches nettes, tests de protection). Deux freins : il devrait lire un README-journal pour retrouver l'état courant, et comprendre quelle branche fait foi, puisque `main` n'est pas à jour.

---

## 13. Git et gestion de configuration [V]

**Points forts :**
- Messages cohérents (`chapter N: add …`, `fix:`, `docs:`) et commits granulaires, un par niveau ou fonctionnalité.
- États validés **tagués** et poussés.
- Branches baseline dédiées.
- `.gitignore` correct pour Xcode.

**Faiblesses :**
- `main` n'est pas une ligne de release : 32 commits de retard, le travail est dispersé sur 13 branches.
- La branche courante n'est pas poussée.
- Zips étrangers suivis.
- Historique très court (4 jours).
- Pbxproj généré suivi.
- Pas de convention de version ni de CHANGELOG.

---

## 14. Dépendances et risque fournisseur [V]

- Surface limitée aux frameworks Apple : excellent pour la maintenance et le verrouillage.
- Seul risque réel : **ARKit face tracking**. Axes de la caméra frontale non documentés par Apple (reconnu dans le README), dépendance au TrueDepth, évolutions d'API iOS.
- Déploiement iOS 17, Swift 6 : pile moderne, faible risque d'obsolescence à court terme [I].

---

## 15. Préparation à la production

| Élément | État |
|---|---|
| Crash reporting / MetricKit | absent |
| Analytics | absent, choix de confidentialité acceptable |
| CI | absente |
| Release automatisée / TestFlight / archive | aucune trace |
| Privacy manifest | **absent, bloquant App Store** |
| Localisation | absente |
| Profilage perf, énergie, mémoire | aucune trace |
| QA matrix appareils | 1 appareil humain (iPhone 14 Pro), simulateurs |
| Checklist de release / rollback | absente (les tags font office de points de retour) |
| Versioning | 1.0 (1), jamais incrémenté |
| Observabilité | `os.Logger` (5), traces DEBUG riches, options de lancement DEBUG |

---

## 16. Grille de notation

| # | Catégorie | Score | Max | Preuves (+) | Limites (−) |
|---|---|---|---|---|---|
| 1 | Architecture et modularité | **12** | 15 | couches imposées par `audit.py`, DI par protocoles, cœur pur, 0 singleton | `GameViewModel` trop chargé, dispatch à 10 cas répété, prototype dans le produit |
| 2 | Qualité et maintenabilité du code | **8** | 10 | 0 force unwrap / `try!` / `fatalError` / TODO, Swift 6 strict, 0 warning | fonctions de 150 lignes, `try?` avalant des pertes, DEBUG mêlé au gameplay |
| 3 | Tests et prévention des régressions | **11** | 15 | 406/406, golden traces, bot 70 niveaux, empreintes SHA-256, cœur à 96 % et plus | couverture globale 62 %, 0 test UI, ARKit, audio et vues à 0 %, pas de CI pour les exécuter |
| 4 | Fiabilité / gestion des erreurs | **7** | 10 | états typés, interruptions AR et audio, scenePhase, horloge bornée | reset silencieux de progression, curseur figé, bug viewport, `failed(String)` |
| 5 | Build / release / reproductibilité | **5** | 10 | XcodeGen source de vérité cohérente, Debug et Release OK, signature auto, C12 | pas de CI, pas d'archive ni de TestFlight démontrés, version jamais incrémentée |
| 6 | Performance et temps réel | **5** | 10 | display link, sous-pas, isolation Canvas, synthé temps réel sûr | aucun profilage, tout sur le main thread, allocations par tick |
| 7 | Sécurité / confidentialité | **8** | 10 | 0 réseau, 0 SDK, 0 secret, pas de persistance de données faciales | privacy manifest absent, zips étrangers dans le dépôt |
| 8 | UX / accessibilité / adaptation | **3** | 5 | Reduce Motion, Dynamic Type, VoiceOver | 0 localisation, portrait seulement, iPad non vérifié |
| 9 | Documentation / maintenabilité humaine | **4** | 5 | README exhaustif, Docs et Design, file-map vérifiée | README-journal, docs d'architecture obsolètes |
| 10 | Git / configuration management | **3** | 5 | commits granulaires, tags validés, baselines | `main` obsolète, branche non poussée, zips suivis, historique de 4 jours |
| 11 | Observabilité / diagnostic | **1** | 3 | Logger, traces DEBUG avancées | rien en production : ni crash, ni MetricKit |
| 12 | Préparation réelle à la production | **1** | 2 | build signé, installé et joué sur appareil | privacy manifest, TestFlight, release : aucun |
| | **TOTAL** | **68** | **100** | | |

---

## 17. Classification

**Score 68/100 → Application semi-professionnelle** (bande 55–69, en haut de bande).

## 18. Deuxième classification, indépendante du score

| Axe | Niveau | Justification courte |
|---|---|---|
| A. Qualité d'architecture | **professionnelle** | couches imposées, DI, cœur pur ; pas « avancée » à cause de `GameViewModel` et du dispatch |
| B. Discipline d'ingénierie | **professionnelle** | tests de protection, tags, audit automatisé, Swift 6 strict ; mais sans CI ni processus de release |
| C. Robustesse | **application classique** | cas nominaux et lifecycle gérés, défauts de persistance et de gaze non traités |
| D. Testabilité | **forte** | tout le cœur est injectable et testé ; « très forte » exclue par l'absence de tests UI et d'intégration matériel |
| E. Complexité technique | **élevée** | ARKit, calibration robuste, moteur physique déterministe, DSP temps réel, 70 niveaux simulés |
| F. Maturité du projet | **semi-pro** | code de niveau pro, cycle de vie produit (release, CI, conformité store, i18n) de niveau prototype |

**Comparaison.** Les deux classifications sont cohérentes, mais révèlent un **décalage interne** : A, B, D et E tirent vers « professionnel », alors que la maturité produit et processus (catégories 5, 11 et 12, localisation, `main`) tire vers « semi-pro ». Le /100 intègre ces deux faces, d'où 68, juste sous le seuil.

## 19. Comparaison qualitative (maturité technique uniquement)

| Type de projet | Position d'Iris |
|---|---|
| Projet étudiant | **nettement au-dessus** : architecture, tests, rigueur de concurrence |
| Prototype hackathon | **nettement au-dessus** |
| App indie simple | **au-dessus** en ingénierie et en complexité technique |
| App App Store sérieuse d'un indépendant | **comparable en code, en dessous en préparation release** : pas de manifest, pas de TestFlight, pas de crash reporting |
| App pro d'une petite équipe | **proche en qualité du cœur**, en dessous en CI, i18n, QA multi-appareils, observabilité |
| Produit mobile mature d'entreprise | **nettement en dessous** : pipeline, monitoring, i18n, accessibilité complète, historique |
| Logiciel critique réglementé | **hors catégorie** : aucune traçabilité exigences/tests, aucune validation formelle |

## 20. Les 10 éléments qui empêchent la classe supérieure (« professionnelle »)

| # | Élément | Gravité |
|---|---|---|
| 1 | `PrivacyInfo.xcprivacy` absent (soumission App Store impossible en l'état) | **bloquant** |
| 2 | Aucune CI : les 406 tests et `audit.py` ne s'exécutent que manuellement | **bloquant** |
| 3 | Pas de ligne de release : `main` a 32 commits de retard, branche courante non poussée, version 1.0 (1) figée | **bloquant** |
| 4 | Perte silencieuse de la progression au décodage ou au changement de version, sans migration | **important** |
| 5 | Aucun crash reporting ni MetricKit en production | **important** |
| 6 | Acquisition ARKit, moteur audio et vues à 0 % de couverture, aucun test UI | **important** |
| 7 | Aucun profilage Instruments (CPU, énergie, thermique, mémoire) d'une app ARKit à 60 Hz sur main thread | **important** |
| 8 | Défauts du pipeline gaze : curseur figé sans intersection, viewport obsolète, vérification sur points d'apprentissage | **important** |
| 9 | Localisation absente (chaînes françaises en dur, domaine inclus) | **amélioration** |
| 10 | Dette de structure et d'hygiène : `GameViewModel` trop chargé, DEBUG mêlé au gameplay, docs obsolètes, zips suivis, prototypes dans le produit | **amélioration** |

---

## VERDICT FINAL

**Classification :**
Application semi-professionnelle (haut de bande)

**Score :**
68/100

**Niveau de confiance :**
élevé

**Phrase de synthèse :**
Iris a un cœur d'ingénierie de niveau professionnel (architecture imposée par outil, Swift 6 strict, 406 tests verts dont traces golden et simulation des 70 niveaux), mais son cycle de vie produit (CI, release, conformité App Store, observabilité, localisation) reste à un stade pré-production.

**Pourquoi :**
- Build Debug et Release, tests (406/406) et couverture (62 %) ont été exécutés et mesurés, pas seulement déclarés.
- Le cœur (moteur, domaine, calibration) est pur, injecté et couvert à plus de 90 % ; aucun motif dangereux (force unwrap, `try!`, `fatalError`).
- Le sous-système gaze est réellement sophistiqué pour un jeu, mais son acquisition ARKit n'est testée ni automatiquement ni sur une matrice d'appareils.
- Rien n'est industrialisé : pas de CI, de privacy manifest, de TestFlight, de crash reporting ni de ligne `main` à jour.
- Des défauts de robustesse confirmés subsistent : reset silencieux de progression, curseur figé, viewport obsolète.
- La confiance n'est pas « très élevée » : ni profilage, ni validation appareil n'ont pu être vérifiés depuis le dépôt, et les builds étaient incrémentaux.

**Principal point fort :**
Un filet anti-régression rare à ce stade : traces golden contre le moteur de référence, bot sur les 70 niveaux, empreintes SHA-256 des niveaux validés, et frontières de couches vérifiées automatiquement.

**Principal facteur limitant :**
L'absence de chaîne de production : CI, release versionnée sur `main`, privacy manifest, crash reporting.

**Distance estimée de la classe supérieure :**
faible. Il manque 2 points, et les éléments bloquants sont bien délimités et relèvent du processus, pas d'une refonte du code.

---

## RÉSUMÉ COMPACT (copiable)

```
AUDIT MATURITÉ IRIS — 14/09/2026 — HEAD 3abddb7 (prototype/x7-…, non poussée)
Lecture seule : dépôt inchangé (git status identique avant/après).
Code Swift : produit 13 070 l. (219 fichiers), tests 7 300 l. (70), ratio 0,56 ;
  11 832 lignes exécutables mesurées par le compilateur. 0 dépendance externe.
Tests exécutés : 406 déclarés / 406 exécutés / 406 passés / 0 échec / 0 ignoré.
Couverture : 62,07 % app ; cœur moteur/domaine/calibration ≥ 90 % ;
  ARKitGazeTrackingService, AVAudioEngineAudioService, vues : 0 %. Aucun test UI.
Builds : Debug sim OK, Release appareil signé OK (G4U9RG5GL7, auto) ;
  project.yml ↔ pbxproj cohérents ; audit.py C1–C12 pass ; 0 warning compilateur.
Qualité : 0 force unwrap / try! / fatalError / TODO ; Swift 6 strict complete.
Forces : couches imposées par outil, DI protocoles, golden traces, bot 70 niveaux,
  empreintes SHA-256, calibration robuste (médiane/MAD, affine, 9+5 points).
Défauts confirmés : reset silencieux de la progression, curseur gaze figé sans
  intersection, viewport obsolète au re-prepare, GameViewModel trop chargé.
Manques production : pas de CI, pas de PrivacyInfo.xcprivacy (bloquant store),
  pas de crash reporting, pas de TestFlight, main 32 commits en retard, 0 i18n,
  aucun profilage Instruments.
Grille : Archi 12/15 · Code 8/10 · Tests 11/15 · Fiabilité 7/10 · Build 5/10 ·
  Perf 5/10 · Sécu 8/10 · UX 3/5 · Doc 4/5 · Git 3/5 · Observ. 1/3 · Prod 1/2
SCORE : 68/100 → APPLICATION SEMI-PROFESSIONNELLE (haut de bande)
2e classification : archi pro · discipline pro · robustesse classique ·
  testabilité forte · complexité élevée · maturité semi-pro (cohérente).
Confiance : élevée. Distance de « professionnelle » : faible (processus, pas refonte).
```
~~~~


---

## 2026-09-14 16:37:25 +0200 (14:37:25Z)
`4a1b6284` · `8f141e83` · ligne 102 · sous-agent agent-a5504523198b6ab18

~~~~markdown
I audited the gaze pipeline without changing anything in the repo; here is what I found. **V** = VÉRIFIÉ (checked in code), **I** = INFÉRÉ (inferred), **NV** = NON VÉRIFIABLE (cannot be checked from code).

## 1. Acquisition
- **Session setup (V):** `ARFaceTrackingConfiguration` with 1 face, no light estimation, and a ≥60 fps video format when one exists (`ARKitGazeTrackingService.swift:79-87`). Support is checked before `run` through the `DeviceCapabilities` protocol, which wraps `isSupported` (`:42`, `DeviceCapabilities.swift:15`).
- **Face anchor (V):** only the first anchor with `isTracked == true` is used. If none, the state becomes `.tracking(faceVisible:false)` (`:93-95`).
- **Gaze ray (V):** it runs from the midpoint of the two eye transforms through `lookAtPoint`, all expressed in the camera frame for the current orientation, and is intersected with the plane z=0 (`:97-105`, `GazeRay.swift:12-22`).
- **Axes (V):** screen right comes from the line between the eyes. Screen up comes from gravity, with a fallback derived from the face (`:107-119`). These are resolved per frame and settled by majority vote with confidence ≥0.8 (`AxisMapping.swift:42-86`, `GazeReadinessEvaluator.swift:116`).
- **Orientation (V):** read from the real `UIWindowScene`, falling back to portrait (`InterfaceOrientationProvider.swift:36-40`). The Info.plist allows portrait only on iPhone.
- **Head pose (V):** yaw, pitch and roll are computed on every frame, Release builds included (`+Observation.swift`). The mapping ignores them, but gameplay uses them through `ingestHeadPose` (`GameViewModel.swift:505`).
- **Threading (V):** `delegateQueue = .main` (`:38`), and the `nonisolated` delegate methods use `MainActor.assumeIsolated` (`:164-178`). This is sound, and it traps if someone changes the queue. No `ARFrame` is retained; the output `RawGazeSample` is a Sendable value type.
- **`@unchecked Sendable` (V, justified):**
  - `UserDefaultsCalibrationStore` holds only an immutable `UserDefaults`, which is thread-safe (`CalibrationStore.swift:13`).
  - `InMemoryCalibrationStore` and `StubCameraAuthorizationService` guard their state with `NSLock`.
  - None of these touch the hot path.

## 2. Calibration
- **Model (V):** a 6-coefficient affine transform, fitted by ordinary least squares (normal equations plus Gaussian elimination with pivoting). There is **no regularization** (`AffineTransform2D.swift:44-68`). The fit is refused with fewer than 3 points, non-finite input or a degenerate system.
- **Sequence (V):**
  - First, a readiness gate of 10 checks that must stay green for 1 s (`GazeSetupViewModel.swift:244-247`).
  - Then 9 points on a 3×3 grid: 0.3 s settle, 0.8 s collection extendable to 2.5 s, one retry per point (`FixationSequence.swift:20-30`).
  - Each point is aggregated with a per-axis median, a 3.5×MAD cut-off and ≥12 samples (`RobustAggregator.swift`). Blinks are excluded (threshold 0.5, 120 ms hold-off).
- **Quality gate (V):** 5 validation targets must give mean error ≤18% and max ≤30% of the short screen side (`CalibrationResult.swift:62-74`).
  - **Weakness (V):** all 5 validation targets are also points of the 9-point grid (`CalibrationGrid.swift`). The samples are new, but no untrained location is tested, so accuracy is probably overestimated (I).
- **Rejection (V):** a failed validation shows `.insufficient`. "Continue anyway" saves the profile with `isValid:false` (`:126-130`), and gameplay still accepts it through `isUsable` (`GameViewModel.swift:137`).
- **Persistence (V):** JSON in `UserDefaults` with coefficients, axis mapping, orientation, viewport, nominal geometry, errors and date. No gaze samples are stored.
- **Invalidation (V):** version, orientation, viewport beyond ±1%, age over 30 days, non-finite values (`CalibrationProfile.swift:58-66`). **Not** invalidated by face distance, head posture or change of user.

## 3. Filtering
- **Type (V):** exponential moving average (EMA) with α=0.1, applied per sample rather than scaled by deltaTime (`GazeFilter.swift:38`). Its effective time constant therefore depends on the ARKit frame rate (I). There is no One-Euro or Kalman filter.
- **Outliers (V):** a jump over 300 pt is ignored until 3 in a row. The 300 pt is absolute, not scaled to the viewport.
- **Blinks in gameplay (V):** there is no blink detection during play (`BlinkDetector` is used only in setup). Blinks are handled only by the jump gate.
- **Dropouts (V):**
  - A null `planeHit` just drops the sample, and the cursor keeps its last position.
  - Face lost for 0.3 s, measured with the display-link delta, triggers `.faceLost` (`GameViewModel.swift:295-304`).
  - This gap contradicts the report's "aucun point périmé" (no stale point reused): if the face stays tracked but the ray never hits the plane, or frames stop arriving, the timeout never fires.
- **Dead code (V):** `GazeReadinessEvaluator` has a `blinkDetector` field that is never used (`:27`).

## 4. Screen mapping
- **Chain (V):** plane hit → axis mapping → nominal geometry (ppi estimate) → affine transform → points (`GazeMapper.swift`).
- **Clamping (V):** to ±50% of the viewport outside its edges, not to the screen itself (`:47-53`).
- **Bug (V):** when `prepare` runs again, it passes the **old** `bounds` with the new geometry and does not rebuild the mapper (`GameViewModel.swift:118-120`, same in `GazeSetupViewModel:85-87`). Impact is small because the app is portrait-only (I).

## 5. Lifecycle and errors
- **AR events (V):** interruption becomes `.interrupted`; the end of an interruption becomes `.starting`, then tracking resumes. `cameraUnauthorized` and `unsupportedConfiguration` are mapped to typed errors; anything else becomes `.failed(message: String)` (stringly-typed).
  - `cameraRestricted` never comes from ARKit; it is detected through `AVCaptureDevice` in readiness (`GazeSetupViewModel:235`).
- **Background (V):** `scenePhase` suspends the game on inactive or background (`RootView.swift:63-70`) and does the same in setup. An interrupted fixation restarts the diagnostic (`:177-181`).
- **Recovery (V):** there is no automatic retry after an AR failure. The user has to trigger `retryAfterFailure`.
- **Errors (V):** typed errors are surfaced in the UI and tested (`GameViewModelTests:343`, `GazeSetupViewModelTests:230`, `CameraAccessViewModelTests`).
- **Install requirements (V):** `UIRequiredDeviceCapabilities` lists only `front-facing-camera`, so devices without TrueDepth can install. The block happens at runtime.

## 6. Separation and tests
- **Structure (V):** `GazeTrackingService` is a `@MainActor` protocol with an ARKit implementation and a simulated one (`SimulatedGazeTrackingService`). The mapper, fit, aggregator and filter are pure structs. One tracker is shared by setup and game, with an `ownsGaze` flag for handover.
- **AR tests (V):**
  - `AffineTransform2D`: identity, offset, scale, shear, mirror, noise, refusals.
  - `AxisMapping`: standard, 180°, mirror, 90°, flat device, vote.
  - `GazeMapper`: ray/plane, overshoot, `BlinkDetector`.
  - `FixationSequence`, `RobustAggregator`, `CalibrationProfile`, `NormalizedCoordinates`, `GazeReadinessEvaluator`.
- **Presentation tests (V):** full setup run (bias, mirror, insufficient verdict, revalidation, blinks, suspend); GameViewModel gaze behaviour (profile applied, face lost, background, recalibration, late `onDisappear`); `GazeFilterTests` (in `GameEngine/`).
- **Not tested (V):**
  - `ARKitGazeTrackingService.process`: the real ARKit axes and the head-pose computation.
  - `WindowSceneOrientationProvider`, `NominalDisplayGeometry.estimate`, `DisplayLinkGameClock`.
  - An AR failure followed by a retry.
  - A face tracked but no plane hit for a long time.
  - Real accuracy. The report's 185 passing tests: NV (not run here).

## 7. Per-frame cost
All of this runs on the main thread at 60 Hz (V):
- The `blendShapes` dictionary is bridged on every frame (allocation, I).
- The head-pose observation is always computed.
- `GameSceneSnapshot` is rebuilt on every tick.
- Readiness uses `removeAll` on every sample, plus sorts every 0.1 s (setup only).

No per-frame logging in Release (V): the logs cover state changes and events. The `OculomotorTrace` and `AncreCapture` code is DEBUG-only.

## 8. Privacy
- **Network (V):** no `URLSession` or network framework in the app sources.
- **Stored data (V):** the profile holds only coefficients.
- **DEBUG exception (V):** `AncreCapture` writes head angles and gaze x/y to a JSONL file in `tmp`, and only with `--iris-capture` (`AncreCapture.swift:47,65`). No images and no blend shapes.
- **Logs (V):** OculoTest public logs contain head yaw/pitch deltas (DEBUG only).

## 9. Doc claims vs code
- **Both docs mostly match:** 9+5 points, 18%/30%, α=0.1, 0.3 s face-lost, 10 readiness checks all hold in code (V).
- **Stale in `Docs/Features/Gaze.md`:** it lists a `DisplayGeometry` entity that was deleted, and says "device validation pending" (your notes say it was validated on 2026-09-12; NV from code).
- **Inconsistent (V):** the readiness range is 15–90 cm, but the on-screen message says "20 à 80 cm" (`GazeReadinessEvaluator.swift:13,89`).
- **Overstated (V):** "aucun point périmé" (see §3).

## Overall assessment
The engineering is solid for a game:
- axes are resolved from measurements rather than assumed;
- aggregation is robust and the fit is guarded;
- the setup is an explicit, well-tested state machine;
- concurrency is clean.

Signal processing is basic: a fixed-α EMA with no timing, no gameplay blink rejection, an unregularized affine fit, no correction for head or distance drift after calibration, and a quality gate that only re-measures trained points. The fragile areas are the stale cursor when no ray hits, the viewport update bug, and ARKit axis handling that only a device can confirm.
~~~~


---

## 2026-09-14 16:38:35 +0200 (14:38:35Z)
`4a1b6284` · `f291ad13` · ligne 90 · sous-agent agent-a80c23fe5e191c27f

~~~~markdown
# Iris senior audit (read-only; the ARKit gaze internals are excluded)

Overall the core is clean, deterministic and strongly protected. The debt is concentrated in `GameViewModel`, in docs that no longer match the code, in silent progress resets, and in the lack of localization. Nothing was modified, built or run.

## 1. Architecture
- **Imports (VÉRIFIÉ, from a grep per folder):**
  - Domain (70 imports) and GameEngine (35) import only Foundation. None of them import SwiftUI, UIKit, ARKit or AVFoundation.
  - AR imports ARKit, AVFoundation, UIKit and simd. Audio imports AVFoundation. Haptics imports UIKit.
  - DesignSystem, Navigation and Features import SwiftUI. App imports UIKit, QuartzCore and SwiftUI.
  - The declared layering holds. `Tools/audit.py:44-47` (check C1) enforces the banned imports.
- **DI (VÉRIFIÉ):** `AppContainer` is the single composition root, with `live()`, `preview()` and simulator variants chosen by `#if targetEnvironment` (`AppContainer.swift:44-90`). Services are injected through constructors behind protocols: `GazeTrackingService`, `AudioService`, `HapticFeedbackService`, `GameClock`, `ProgressStore`, `CalibrationStore`. Silent, Stub, InMemory and Manual versions exist for each. Three test mocks live in `Tests/IrisTests/Mocks`.
- **Singletons:** no app-level singleton. Only the system ones are used (`AVAudioSession.sharedInstance`, `UIApplication.shared` in `InterfaceOrientationProvider.swift:37`).
- **Docs out of date (VÉRIFIÉ):**
  - `architecture.md` still says "6 chapters, 34 LevelDefinition" and names a `GameProgression` type that does not exist.
  - `conventions.md` says the app "has no persistence", but `UserDefaultsProgressStore` exists.

## 2. God types and function size
- **`GameViewModel` (586 lines) does too much (VÉRIFIÉ).** It holds about 30 stored properties and handles lifecycle, the loop, gaze mapping, audio, haptics, hints, results, the calibration reload and DEBUG instrumentation (12 `#if DEBUG` blocks). `handleGazeSample` (473-506) mixes the tracing hooks with gameplay. This is the main debt item.
- **Longest functions (VÉRIFIÉ, measured with a script):**

| Function | Lines | Location |
|---|---|---|
| `GameSession.tick` | 153 | `GameSession.swift:192` |
| `OculoSnapshot.scene` | 123 | `OculoSnapshot.swift:157` |
| `drawOculoElement` | 97 | `GameSceneRenderer+Oculo.swift:58` |
| `LevelResolver.resolve` | 88 | `LevelResolver.swift:23` |
| `GameSceneSnapshot.init` | 86 | `GameSceneSnapshot.swift:211` |
| `GameSceneRenderer.draw` | 76 | `GameSceneRenderer.swift:13` (dispatcher) |

- **Renderer:** every draw function receives `palette`, `scale` and `reduceMotion` as separate parameters. That is noisy but stateless.
- **`*StageState` files:** each is its own state machine (settling, seeking and so on), so the logic is not really duplicated. The repetition is in `OculoStageState.swift:74-140+`: a 10-case switch written out again for `update`, `isComplete` and `progress`. Adding a stage means editing about 4 switches. It keeps value semantics and `Hashable`.
- **`AppCoordinator` (287 lines):** routes, owns progress and persists it. Acceptable size.
- Views contain little logic: accessibility strings and layout metrics only.

## 3. Game loop and rendering (VÉRIFIÉ)
- **Timing:**
  - Frames come from a `CADisplayLink` pinned to 60 Hz in `.common` mode, with a weak proxy to avoid a retain cycle (`DisplayLinkGameClock.swift:20-62`).
  - `stop()` resets the timestamp, so resuming never produces a huge delta.
  - `GameSession.advance` clamps the delta to 0.1 s and splits it into reference-frame substeps (`GameSession.swift:176-185`).
- **Drawing:**
  - `Canvas(rendersAsynchronously: false)`.
  - `GameCanvasHost` limits the per-frame observation of `snapshot` to the canvas (`GameCanvasView.swift:20-28`), a good defence against invalidating the whole screen.
- **Per-frame allocations:** `refreshSnapshot()` rebuilds several arrays with `.map` on every tick (`GameSceneSnapshot.swift:211+`), and `Gradient` arrays are created on every draw. Low but real.
- **Main thread:** physics, ARKit frames and drawing all run there. No profiling was done, so impact is INFÉRÉ acceptable at 60 Hz.
- **DEBUG code:**
  - `AncreCapture` is fully wrapped in `#if DEBUG` (lines 9-190).
  - `OculomotorTrace.swift` is **not** wrapped. It is compiled into Release but only instantiated under DEBUG (`GameViewModel.swift:70-77, 391-398`), so it is dead weight in Release, not a behaviour leak.
  - `LaunchOptions` is only parsed in DEBUG (`AppContainer.swift:45-49`).
  - The lone `print()` is in `Tools/MakeAppIcon.swift:70`, which is not part of the app target.

## 4. Persistence
- **Format (VÉRIFIÉ):** progress is JSON under one UserDefaults key, with `version = 1` (`CampaignProgress.swift:8`).
- **Version mismatch or decode failure (VÉRIFIÉ):** `load()` silently returns empty progress (`UserDefaultsProgressStore.swift:16-20`). There is no migration and no logging, and the next `save` overwrites the unreadable data.
- **Enum risk:** `encounteredElements: Set<GameElement>` is a String raw-value enum. Renaming or removing a case would make the whole decode throw and wipe all progress (INFÉRÉ from Codable behaviour). Encode failure is also dropped silently (line 25).
- **The `try?` count is 12 real, not 14.** Two grep hits are false positives: the text "try?" appears inside `NominalDisplayGeometry?`.

| Where | Verdict |
|---|---|
| Progress decode/encode, calibration decode/encode | Swallow real data loss |
| `AncreCapture` (6) | DEBUG file I/O, acceptable |
| `LevelResultView.swift:51` `Task.sleep` | Fine |
| `AVAudioSession.setActive(false)` | Fine |

- **Tests:** a store round trip is tested (`HintTrackerTests.swift:80`); corrupted data is not.

## 5. Audio and haptics
- **Interruptions and resets (VÉRIFIÉ):**
  - Observers cover interruption, `AVAudioEngineConfigurationChange` and `mediaServicesWereReset`, and rebuild the engine when needed (`AVAudioEngineAudioService.swift:107-138`).
  - There is no `routeChangeNotification` observer. The configuration-change observer covers format changes (INFÉRÉ sufficient).
  - The session category is `.ambient` with `mixWithOthers`, so the silent switch mutes the game. That is a design choice.
- **Real-time thread:**
  - `SineSynth` publishes commands through `OSAllocatedUnfairLock` and reads them with `withLockIfAvailable`, so it never blocks, and state is fixed-size (`SineSynth.swift:185-237`). Good design.
  - Minor: the `chimeFrequencies` and `completionFrequencies` arrays are passed on every sample (`:225-230`), which causes ARC retain/release traffic on the audio thread (INFÉRÉ). It does not allocate.
- **The 7 `@unchecked Sendable`:**
  - `InMemoryProgressStore`: NSLock, justified.
  - `NotificationObserverBag`: NSLock, justified.
  - `UserDefaultsProgressStore`: justified, since UserDefaults is thread-safe.
  - `SineSynth`: justified by the one-writer-per-thread design, but only by convention.
  - `StubCameraAuthorizationService` and `InMemoryCalibrationStore`: test doubles shipped in product code.
  - `UserDefaultsCalibrationStore`: OK.
- **Haptics:** the generators live for the whole session and `prepare` is used. They are not tested.

## 6. Lifecycle (VÉRIFIÉ)
- `RootView.swift:63-72` calls `suspend()` on both `.background` **and `.inactive``, and `wake()` on `.active`. Pulling down Control Center therefore pauses ARKit and audio. That is safe but aggressive.
- States are typed: `GamePhase` has 10 cases, plus `GameFailure` and `GazeTrackingState`.
- Recovery paths exist: `retryAfterFailure`, `phaseAfterReturn`, and a 0.3 s face-lost timeout.
- Progress is saved on events only (`AppCoordinator.swift` `persist()` at 255 and 262).

## 7. Accessibility and localization
- **Reduce Motion** is applied widely, including inside the renderer. **Dynamic Type:** `DSFont` uses text styles throughout; there is no `@ScaledMetric`.
- **VoiceOver:** about 49 accessibility modifiers, for example `LevelNode.swift:52`. The canvas is `accessibilityHidden`, which is inherent to a gaze game.
- **Localization (VÉRIFIÉ):**
  - There is no `.xcstrings` or `.strings` file, `String(localized:)` is used 0 times, and `SWIFT_EMIT_LOC_STRINGS: NO`.
  - French text is hardcoded as `String` values that SwiftUI would not localize (`LevelNode.swift:57-60`), and there are about 238 French literals in `Domain/Campaign`.
  - The app is effectively French-only.
- **Orientation and iPad (VÉRIFIÉ):**
  - iPhone is locked to portrait. iPad allows portrait and upside-down, with `UIRequiresFullScreen`.
  - `TARGETED_DEVICE_FAMILY` is `1,2`, but `UIRequiredDeviceCapabilities` lists only `front-facing-camera`, so iPads without TrueDepth fall through to the runtime `.unavailable` screen.
  - iPad only changes the nominal geometry estimate.

## 8. Tests (VÉRIFIÉ)
- 406 `@Test` cases (Swift Testing) in a single unit-test bundle. There is **no UI test target and no snapshot tests**.
- Kinds of tests:
  - Unit tests: Domain, AR math, policies.
  - Golden traces: JSON fixtures produced by `golden_generator.js` from the reference engine.
  - Byte-for-byte text dumps of the campaign.
  - A simulated-player bot, `CampaignBot`, used in 24 files.
  - ViewModel and coordinator tests with mocks.
  - `SineSynth` DSP tests.
- **Untested:** `GameSceneRenderer` drawing, `AVAudioEngineAudioService`, `DisplayLinkGameClock`, UIKit haptics, corrupted persistence, scenePhase wiring.

## 9. Dead code and protection
- `PrototypeLevelCatalog` is referenced only by tests (it feeds the golden traces), yet it lives in product `Domain` and ships (VÉRIFIÉ).
- `BraisesPrototype` is DEBUG-only (`BraisesPrototype.swift:7-41`). The `.disabled` hits are legitimate UI uses.
- **Fingerprints** (`HistoricalCampaignFingerprintTests.swift`):
  - They combine SHA-256 of 33 frozen source files with a behavioural dump that includes an 8 s scripted simulation. The combination is sound.
  - Limits: the hashes depend on formatting, and paths come from `#filePath`, so the tests need a source tree on the machine that runs them.
  - `GameSession.swift`, `LevelResolver`, `LevelDefinition` and the renderer are not hashed. The behavioural dump covers them for the historical levels only (INFÉRÉ).

## Summary
- **Strengths:**
  - A pure, deterministic core whose layering is enforced by `audit.py`.
  - Real protocol-based DI.
  - A careful clock with clamped substeps.
  - A lock-disciplined, real-time-safe synth.
  - Typed phases.
  - An unusually rigorous regression net (golden traces, dumps, hashes, bots).
- **Weaknesses:**
  - `GameViewModel` does too much, and DEBUG hooks are woven into gameplay code.
  - Progress resets silently, with no migration.
  - No localization.
  - No UI or render tests.
  - Architecture docs no longer match the code.
- **Main debt:**
  - The 10-case enum dispatch in `OculoStageState`.
  - Prototype and diagnostic code sitting in product folders.
  - Parameters threaded through every renderer call.
  - Per-tick snapshot allocations.
~~~~
