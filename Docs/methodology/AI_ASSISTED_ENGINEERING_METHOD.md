# Méthode d'ingénierie assistée par IA

Extrait du projet Iris le 17 septembre 2026. Chaque règle est suivie de la preuve qui l'a produite ; les preuves
détaillées sont dans `IRIS_CASE_STUDY.md` et les sources dans `SOURCE_INDEX.md`.

**Ce document n'est pas une doctrine.** Iris est **un** projet : une application Apple, un développeur, un agent
IA, un domaine où le matériel compte. Une règle validée par un seul projet est une règle *plausible*, pas une loi.
Chaque section dit donc aussi où elle ne s'applique pas.

---

## 1. Le modèle de preuve

Le problème qu'il résout : une IA produit des phrases fluides et confiantes, et une corrélation bien racontée se
lit comme une causalité. Nommer le niveau de preuve force la distinction.

Quatre niveaux ont réellement servi sur Iris. Un cinquième s'est avéré utile après coup.

| Niveau | Définition | L'agent peut dire | L'agent ne peut pas dire |
|---|---|---|---|
| **MEASURED / OBSERVED** | une valeur relevée par un outil, avec sa commande et sa date | « à 13:47:12Z, `environment=(unavailable)` » | ce que cette valeur implique |
| **PROVEN** | établi par une mesure ou une vérification déterministe, reproductible | « le binaire Release ne contient aucun symbole `drawDiagnostics` » | l'étendre au-delà de ce qui a été mesuré |
| **STRONGLY SUPPORTED** | une seule variable a changé et le résultat a basculé, mais le mécanisme n'a pas été observé | « le comportement dépend de la configuration du scheme » | « la cause est X » |
| **NOT PROVEN** | plusieurs hypothèses restent compatibles avec les faits | « deux lectures restent possibles, voici lesquelles » | choisir la plus séduisante |
| **NOT DETERMINED** | hors de portée des outils disponibles | « aucun accès à App Store Connect n'a été utilisé » | supposer l'état |

**RULE.** Toute conclusion porte son niveau. Un rapport sans niveaux est un rapport d'opinion.

**RATIONALE.** Sur Iris, la distinction entre *STRONGLY SUPPORTED* et *PROVEN* a empêché deux fois de figer une
cause fausse — et la distinction entre *NOT PROVEN* et *NOT DETERMINED* dit si le travail peut avancer ou s'il
faut aller chercher un accès ailleurs.

**EXCEPTIONS.** Sur une modification triviale et réversible, annoter chaque phrase est du bruit. Les niveaux
servent quand quelqu'un décidera *à partir* du rapport.

**FAILURE MODE.** Multiplier les niveaux jusqu'à ce que personne ne les distingue. Quatre ou cinq suffisent ;
sept étaient de trop.

**NEGATIVE KNOWLEDGE.** Ne jamais transformer « l'hypothèse B n'est plus nécessaire pour expliquer les
résultats » en « l'hypothèse B est fausse ». Ce sont deux affirmations différentes.

---

## 2. L'expérimentation réversible

Le problème qu'il résout : face à une anomalie, la première action qui vient à l'esprit est souvent destructive —
désinstaller, réinitialiser, effacer — parce qu'elle est simple, pas parce qu'elle est justifiée.

### Le protocole

```
 1. Établir l'état initial, par mesure, pas de mémoire
 2. Sauvegarder ce que l'expérience pourrait détruire — et vérifier la sauvegarde (hash)
 3. Écrire les hypothèses CONCURRENTES, explicitement
 4. Identifier la variable qui les discrimine
 5. Chercher l'expérience LA MOINS INVASIVE qui touche cette variable
 6. Ne changer QUE cette variable
 7. Instrumenter la mesure avant d'agir
 8. Mesurer
 9. Restaurer
10. PROUVER la restauration (hash, diff), ne pas la supposer
11. Interpréter sans dépasser la preuve
12. SEULEMENT alors, décider si une action destructive reste justifiée
```

### DESTRUCTIVE ACTION BUDGET

**RULE.** Une opération destructive exige une justification **strictement supérieure** à celle d'une expérience
réversible encore disponible. Tant qu'une expérience réversible peut discriminer les hypothèses, l'opération
destructive n'est pas justifiée — quelle que soit sa simplicité apparente.

**EVIDENCE.** Sur Iris, l'action destructive proposée (désinstaller l'app, au prix du profil de calibration)
aurait été **inutile** : l'expérience réversible a montré que la cause n'était pas là. Voir
`IRIS_CASE_STUDY.md` §2.

### STOP CONDITIONS

Arrêter et demander avant de continuer si :

- l'état initial ne peut pas être établi de façon fiable **avant** la modification ;
- la sauvegarde ne peut pas être vérifiée ;
- la restauration ne peut pas être prouvée identique ;
- l'expérience exigerait de franchir une interdiction posée par le mandat ;
- le résultat est ambigu entre deux hypothèses et l'ambiguïté n'est pas levable avec les outils disponibles.

**Le dernier point est le plus important** : un résultat ambigu doit être rapporté comme ambigu, pas résolu par
préférence.

**EXCEPTIONS.** Un incident de production en cours, où le coût de l'attente dépasse le coût de l'erreur. Le budget
s'inverse alors : c'est *l'inaction* qui doit être justifiée.

**FAILURE MODE.** Faire l'expérience réversible, obtenir un résultat ambigu, et conclure quand même. Sur Iris, le
premier test a donné un résultat ambigu ; le rapporter comme tel a conduit au second test, qui a tout changé.

---

## 3. Les Release Gates

Un Gate est un point où l'on décide, avec des preuves, si le travail peut continuer — et où l'on écrit ce qui
n'est pas résolu.

### Structure générique

| Champ | Rôle |
|---|---|
| Objectif | la question à laquelle ce Gate répond |
| Préconditions | HEAD, branche, état attendu, vérifiés avant de commencer |
| Critères d'acceptation | écrits **avant** le travail |
| Preuves automatisées | tests, audits, builds — avec les nombres réels du runner |
| Preuves physiques | ce qu'un appareil a montré |
| Validation humaine | ce qu'un humain doit juger, et son verdict **tel qu'il a été donné** |
| Exclusions | ce que ce Gate ne traite pas |
| Anomalies restantes | ce qui reste ouvert, avec son niveau de preuve |
| Statut | PASS / PARTIAL / FAIL |
| **Conditions de réouverture** | ce qui ferait rouvrir une décision prise sans preuve complète |
| Point de rollback | le commit ou le tag où revenir |

**Le champ le plus utile est « conditions de réouverture ».** Iris a fermé des blockers sans en avoir prouvé la
cause — la bonne décision, mais seulement parce que les conditions de réouverture étaient écrites
(`Docs/ReleaseGate2/07_STABILITY_DECISION.md` §4).

### Quand un Gate est inutile

**RULE.** Ne pas ouvrir de Gate pour un changement local, réversible, couvert par les tests existants, et sans
effet externe. Le Gate coûte du temps et produit de la documentation que personne ne relira.

Un Gate se justifie quand au moins deux des conditions suivantes sont réunies : effet irréversible ou externe
(publication, paiement, données utilisateur), matériel spécialisé, coût d'erreur élevé, plusieurs sous-systèmes
touchés, ou une décision que seul un humain peut prendre.

### Trois profondeurs

| Mode | Quand | Audit | Documentation | Tests | Gate | Preuve | Validation humaine |
|---|---|---|---|---|---|---|---|
| **LIGHT** | correction locale, risque faible | diff relu | message de commit | tests existants | non | l'exécution suffit | non |
| **STANDARD** | fonctionnalité, refactor significatif | audit de couches, tests ciblés | un document si une décision non évidente est prise | ciblés + suite complète | non, sauf effet externe | niveaux nommés sur les conclusions | si perceptible |
| **DEEP** | release, migration, paiement, données, matériel, investigation difficile | complet | rapport structuré | suite complète + physique | oui | niveaux nommés partout | oui |

**FAILURE MODE.** Appliquer DEEP partout. La méthode devient alors elle-même la source de l'over-engineering
qu'elle prétend éviter. Le mode se choisit **avant** de commencer, et se déclare.

---

## 4. Les sous-systèmes gelés

Le problème qu'il résout : un agent IA voit en permanence des occasions de refactor. Sur un sous-système validé
par un humain, à l'issue d'un travail coûteux, « améliorer » est un risque net.

**FROZEN SUBSYSTEM** — un ensemble de fichiers dont le comportement a été validé et qui ne doit plus changer sans
preuve nouvelle.

| | |
|---|---|
| **Conditions de gel** | validé (humainement ou par mesure), coûteux à revalider, et sans défaut connu |
| **Ce que le gel interdit** | tout changement de comportement, y compris « équivalent », y compris cosmétique |
| **Ce que le gel n'interdit pas** | lire, mesurer, documenter, et la présentation strictement autour — si le mandat le dit |
| **Réouverture** | un défaut démontré, ou une exigence produit explicite — pas une intuition d'élégance |
| **Preuve exigée** | la reproduction du défaut avant le correctif |

**Le gel doit être exécutable.** Sur Iris, une table de SHA-256 (`GameContentFreezeTests`) fait échouer les tests
dès qu'un fichier gelé change, et re-geler un hash oblige à écrire pourquoi, dans le fichier de test. Un gel qui
n'existe que dans un document est un vœu.

**EVIDENCE.** Trois re-gels ont eu lieu sur Iris, chacun avec sa justification écrite. Et une régression réelle a
été attrapée par un test de gel voisin, pas par une relecture.

**EXCEPTIONS.** Une faille de sécurité, une API dépréciée qui casse la compilation, une donnée utilisateur en
danger. Le gel ne survit pas à ça.

**FAILURE MODE.** Geler trop tôt — avant validation — ou trop large. Le gel porte sur ce qui a été *validé*, pas
sur ce qui est *fini d'écrire*.

---

## 5. Git comme filet de sécurité

Ces pratiques ont réellement servi. Elles sont séparées de ce qui relève du choix de projet.

### Bonnes pratiques générales

| Pratique | Ce qu'elle achète |
|---|---|
| Une branche par mission, créée depuis un HEAD **vérifié** | l'état de départ est un fait, pas un souvenir |
| Vérifier branche + HEAD **avant** d'agir, s'arrêter en cas d'écart | empêche de travailler sur un état imaginé |
| Commits bornés à une intention | rend le diff relisable et le retour arrière chirurgical |
| Commits **docs-only** quand c'est une mission d'audit | rend vérifiable l'affirmation « aucun code produit n'a changé » |
| Tags annotés aux points validés **par un humain** | des points de restauration qui veulent dire quelque chose |
| Hash des fichiers critiques avant/après | prouve une restauration au lieu de la supposer |
| **Prouver** la restauration (hash **et** diff) | un `git diff` vide ne suffit pas si le fichier est ignoré |
| Ne jamais supprimer un fichier non suivi sans demander | ce sont souvent les preuves brutes de l'utilisateur |
| Commiter tôt une preuve qu'une action va détruire | l'expérience suivante ne peut plus effacer l'évidence |
| Vérifier l'ancestry avant de fusionner | évite les fusions inutiles faites « au cas où » |

**RULE.** Avant toute fusion, prouver qu'elle est nécessaire. Sur Iris, l'audit de lignée a montré que
18 branches sur 22 étaient **déjà** ancêtres du HEAD : aucune fusion n'était requise.

### Choix propres à Iris — à ne pas ériger en règles

- **Lignée linéaire sans merge** (91 commits) : lisible ici parce qu'un seul agent travaillait à la fois. Sans
  valeur pour une équipe parallèle.
- **Ne jamais pousser** : décision de ce projet, pas une pratique générale.
- **Tags uniquement après validation humaine** : cohérent avec un produit dont la valeur se juge à l'œil.
- **Sauvegarde hors du dépôt** pour les données d'appareil : évite de polluer l'arbre de travail.

**FAILURE MODE.** Prendre la discipline pour de la sécurité. Un dépôt jamais poussé n'a **aucune** redondance
hors de la machine — sur Iris, une sauvegarde externe séparée a dû exister pour cette raison.

---

## 6. Preuve automatisée et preuve humaine

**RULE.** Ce ne sont pas deux qualités de preuve, mais deux **domaines**. Ni l'une ni l'autre n'est supérieure ;
elles répondent à des questions différentes.

| La machine établit | L'humain établit |
|---|---|
| présence ou absence d'un symbole, d'une chaîne, d'un fichier | si une transition « se voit » |
| conformité d'une valeur, d'un hash, d'un nombre | si un texte est compréhensible sans explication |
| non-régression sur ce qui était déjà couvert | si un mode est utilisable en jouant |
| qu'une mise en page tient à une taille donnée | si elle reste **confortable** |
| qu'aucune animation n'est déclarée | ce qu'un lecteur d'écran prononce vraiment |

**RULE.** Enregistrer un verdict humain **tel qu'il a été donné**. Si la personne dit « l'ensemble est passé »,
ne pas fabriquer un résultat ligne par ligne. Sur Iris, la checklist porte « ✓ ensemble » et une note disant que
le détail n'a pas été remonté.

**RULE.** Un point peut être déclaré **hors critère** plutôt que passé ou échoué. Iris a placé VoiceOver hors
critère pour un jeu qui se joue en regardant l'écran — en écrivant explicitement que cela n'autorise **aucune**
promesse d'accessibilité.

**FAILURE MODE.** Traiter « l'app est installée sur l'appareil » comme une validation visuelle. Une installation
n'est pas un regard.

---

## 7. Le handoff de session

Le problème qu'il résout : une session d'agent finit par perdre son contexte. Si l'état du projet vit dans la
conversation, il disparaît avec elle.

**RULE.** L'état du projet doit être **dans le dépôt**, pas dans le contexte. Un handoff est autosuffisant : une
session qui ne sait rien d'autre doit pouvoir reprendre.

### Contenu minimal

Projet et ce qu'il est · branche · HEAD exact · état Git (propre ? fichiers non suivis ?) · points de restauration
avec leurs commits · décisions prises et **pourquoi** · état de chaque Gate · preuves avec leur niveau · problèmes
ouverts · sous-systèmes gelés · **interdictions** · matériel disponible et le rôle de chaque appareil · comment
construire et tester · où lire la suite · **la première action de la prochaine session**.

### Protocole de reprise

```
READ  → VERIFY → COMPARE → CONFIRM ENVIRONMENT → WAIT FOR MISSION
```

Pas :

```
READ → IMMEDIATELY MODIFY CODE
```

**RULE.** Vérifier l'état réel (`pwd`, racine, branche, HEAD, `status`, `diff`) et le **comparer** au handoff.
En cas d'écart : signaler, ne rien corriger.

**RULE.** Séparer l'**état du projet** de la **connaissance réutilisable**. Deux documents, deux durées de vie :
l'état périme à chaque commit, la méthode non.

**FAILURE MODE.** Un handoff qui raconte la session au lieu de décrire l'état. Le critère : un lecteur qui n'a
rien vécu peut-il agir ?

---

## 8. Travailler avec un agent IA

Ce que la pratique d'Iris a montré sur le mandat donné à l'agent.

### Ce qui marche

| Pratique | Pourquoi |
|---|---|
| **Mission bornée**, avec un objectif unique | empêche la dérive de périmètre, le risque par défaut d'un agent capable |
| **Interdictions explicites et nommées** | « ne touche pas au scheme » est vérifiable ; « sois prudent » ne l'est pas |
| **HEAD et branche attendus**, avec ordre de s'arrêter en cas d'écart | rend impossible de travailler sur un état imaginé |
| **STOP conditions écrites à l'avance** | l'agent sait où s'arrêter, y compris au milieu |
| **Format de rapport imposé** | force à répondre à chaque question, y compris celles qui fâchent |
| **Gel de ce qui est validé** | protège le travail coûteux de l'envie d'améliorer |
| **Exiger une preuve d'outil plutôt qu'une affirmation** | « interroge Git, ne te fie pas à la mémoire de la session » |
| **Conserver les décisions négatives** | l'hypothèse rejetée coûte cher ; la jeter, c'est la repayer |

### Ce qui a échoué, et ce qui l'a rattrapé

| Erreur réelle de l'agent | Ce qui l'a détectée |
|---|---|
| Une suppression de condition perdue en réécrivant un composant | un test de gel voisin, pas une relecture |
| Un décompte de tests annoncé faux dans un rapport (détail par suite) | un humain qui a additionné |
| Une description de tests incomplète, l'agent ayant compté deux preuves pour deux tests alors qu'un seul les couvrait | un humain qui a additionné, de nouveau |
| Un premier parseur de trace lisant 7 lignes sur 342 — il aurait inversé la conclusion mémoire | une incohérence d'ordre de grandeur remarquée |
| Une conclusion tirée d'une expérience contaminée par un cache | avoir rapporté l'ambiguïté au lieu de la résoudre |

**Aucune de ces erreurs n'a été rattrapée par la prudence de l'agent.** Toutes l'ont été par un contrôle externe :
un test, un humain qui vérifie un nombre, un ordre de grandeur invraisemblable. C'est l'argument central pour des
contrôles exécutables.

### Répartition des rôles

Ceci décrit une **méthode de collaboration**, pas une affirmation sur les compétences de quiconque.

| L'agent peut porter | Reste explicitement humain |
|---|---|
| implémentation, inspection, instrumentation | l'intention produit |
| tests, mesures, automatisation | les contraintes et les interdictions |
| documentation, analyse | le **refus** |
| proposition d'hypothèses | le choix entre hypothèses concurrentes |
| exécution d'expériences bornées | la validation physique et perceptive |
| rapport avec niveaux de preuve | l'acceptation d'un risque |
| | la **fermeture d'un Gate** |
| | l'autorisation d'une action destructive |

**RULE.** Le propriétaire du produit n'a pas besoin d'écrire le code pour garder le contrôle. Il a besoin de
pouvoir dire non, de choisir entre hypothèses, de valider ce qui se juge à l'usage, et de décider ce qui est clos.

**FAILURE MODE.** Un mandat qui interdit une opération **et** exige un résultat qui en dépend. Cela s'est produit
sur Iris : la voie la moins invasive passait par le scheme, que le mandat interdisait. La bonne réponse a été de
le signaler, pas de contourner.

---

## 9. Résoudre les conflits entre règles

Les principes se contredisent : vitesse contre sécurité, gel contre correction nécessaire, réversibilité contre
urgence, documentation contre coût.

**RULE.** Trancher dans cet ordre, en s'arrêtant au premier critère qui départage :

```
1. RÉVERSIBILITÉ   — l'option réversible l'emporte tant qu'elle discrimine encore
2. COÛT DE L'ERREUR — données utilisateur, argent, publication : le prudent l'emporte
3. PREUVE           — celle qui produit une preuve l'emporte sur celle qui produit une opinion
4. COÛT             — à égalité, la moins chère
```

Pas de scoring. Quatre critères ordonnés suffisent, et restent explicables.

**EXCEPTIONS.** En incident de production, le critère 2 passe premier : le coût de l'inaction entre dans la
balance.

---

## 10. Calibrer la méthode sur ses résultats

Une méthode qui ne s'observe pas devient un rituel.

**Principe seulement — aucun outil à construire aujourd'hui.** À chaque clôture de Gate, noter :

- les hypothèses invalidées, et ce qui les rendait séduisantes ;
- les bugs apparus **après** un Gate — donc ce que le Gate n'a pas vu ;
- les faux positifs de l'agent ;
- les opérations destructives évitées, et si l'évitement s'est révélé justifié ;
- les écarts entre prédiction et résultat ;
- le temps dépensé en formalisme, rapporté à ce qu'il a attrapé.

**Ce qu'on en fait.** Une règle qui n'a jamais rien attrapé sur plusieurs projets est du cérémonial : la
supprimer. Une règle qui a attrapé une erreur réelle mérite d'être rendue exécutable.

**RULE.** La méthode doit pouvoir **maigrir**. Sans mécanisme de retrait, elle ne fait que croître.

---

## Ce que ce document ne prétend pas

- **Un projet ne prouve pas une méthode.** Rien ici n'a été comparé à un groupe témoin.
- **Le domaine compte.** Iris dépend de matériel spécialisé, de paiements et d'une publication : les coûts
  d'erreur y sont élevés. Sur un outil interne jetable, presque tout ce document est du luxe.
- **L'échelle compte.** Un développeur et un agent, en série. Rien n'est validé pour une équipe en parallèle.
- **Le formalisme a un coût** qui n'a pas été mesuré. Combien de temps les Gates ont pris, et combien ils ont
  fait gagner : inconnu.
- **Aucune règle ici n'a été testée contre son absence.** Elles ont été suivies, et le projet s'est bien passé.
  C'est un argument faible, et il faut le savoir.
