# Historique de session Claude Code — partie 006

Session `4a1b6284-eeb2-4ff3-9176-b7e4a3a1b4bc` (session distincte ouverte le 2026-09-14 dans le projet Iris, avec deux sous-agents d'audit) · texte d'origine.

### 2026-09-14 16:32:56 +0200 (14:32:56Z) · COMMAND (commande locale)
`4a1b6284` · `07944ee2` · ligne 6

~~~~text
<command-name>/model</command-name>
            <command-message>model</command-message>
            <command-args></command-args>
~~~~

### 2026-09-14 16:32:56 +0200 (14:32:56Z) · COMMAND (commande locale)
`4a1b6284` · `af8eb42f` · ligne 7

~~~~text
<local-command-stdout>Set model to `Opus 5 (1M context) (default)` and saved as your default for new sessions</local-command-stdout>
~~~~

### 2026-09-14 16:33:08 +0200 (14:33:08Z) · COMMAND (commande locale)
`4a1b6284` · `2caf00ff` · ligne 10

~~~~text
<command-name>/effort</command-name>
            <command-message>effort</command-message>
            <command-args></command-args>
~~~~

### 2026-09-14 16:33:08 +0200 (14:33:08Z) · COMMAND (commande locale)
`4a1b6284` · `0e6f3411` · ligne 11

~~~~text
<local-command-stdout>Set effort level to low (saved as your default for new sessions): Quick, straightforward implementation with minimal overhead</local-command-stdout>
~~~~

### 2026-09-14 16:33:13 +0200 (14:33:13Z) · USER
`4a1b6284` · `98e42ad7` · ligne 14

~~~~markdown
MISSION — AUDIT DE MATURITÉ PROFESSIONNELLE COMPLET DU PROJET IRIS

Contexte :
Tu travailles dans le dépôt Iris situé ici :

/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris

Je veux savoir, avec le plus haut niveau de rigueur possible, à quel niveau réel de maturité logicielle se situe cette application iOS.

IMPORTANT :
Je ne veux PAS une estimation vague.
Je ne veux PAS une appréciation fondée principalement sur le nombre de lignes de code.
Je veux un audit technique complet, fondé sur des preuves vérifiables présentes dans le dépôt, dans Git, dans les tests, dans les builds et dans la structure réelle du projet.

Tu dois agir comme un auditeur logiciel senior indépendant.

==================================================
1. RÈGLES ABSOLUES
==================================================

1. Cette mission est en LECTURE SEULE.

Tu n’as pas le droit de :
- modifier un fichier ;
- reformater du code ;
- corriger quoi que ce soit ;
- créer une branche ;
- créer un commit ;
- créer un tag ;
- modifier project.yml ;
- générer du code ;
- modifier les tests ;
- déplacer ou supprimer des fichiers.

Tu peux exécuter des commandes qui lisent/analyent le dépôt.

Si certaines commandes de build ou de test créent automatiquement des artefacts temporaires de compilation en dehors des sources, c’est acceptable, mais aucun fichier source ou fichier de projet ne doit être modifié intentionnellement.

2. Commence par vérifier l’état Git.

Donne :
- branche courante ;
- HEAD exact ;
- git status ;
- remote(s) ;
- tags pertinents ;
- divergence éventuelle avec origin ;
- fichiers suivis modifiés ou non suivis.

3. Ne considère aucune affirmation historique comme vraie sans vérification lorsque le dépôt peut la confirmer.

4. Chaque conclusion importante doit être reliée à une preuve :
- fichier ;
- répertoire ;
- test ;
- commande ;
- résultat ;
- configuration ;
- commit ;
- métrique mesurée.

5. Distingue clairement :
- VÉRIFIÉ ;
- INFÉRÉ ;
- NON VÉRIFIABLE depuis le dépôt.

6. Ne gonfle jamais la note.
Si un critère n’est pas démontré, ne lui attribue pas artificiellement un bon score.

7. Inversement, ne pénalise pas Iris parce qu’elle n’est pas un logiciel bancaire, médical, aéronautique ou militaire.
Évalue-la selon ce qu’est réellement le produit :
une application iOS native grand public utilisant notamment gaze tracking / TrueDepth / ARKit et un moteur de jeu.

==================================================
2. OBJECTIF DE L’AUDIT
==================================================

Je veux répondre précisément à cette question :

« Iris est-elle :
- un prototype ;
- une application amateur ;
- une application amateur avancée ;
- une application semi-professionnelle ;
- une application professionnelle ;
- une application professionnelle avancée / production-grade ;
- ou un logiciel de niveau industriel / critique ? »

Il n’existe pas nécessairement une norme mondiale unique avec ces mots.

Tu dois donc construire une classification sérieuse en t’appuyant sur des critères reconnus de maturité logicielle, d’ingénierie logicielle, de qualité produit et de préparation à la production.

Tu peux notamment t’inspirer conceptuellement de :
- ISO/IEC 25010 pour les caractéristiques qualité ;
- principes de software engineering ;
- practices de production readiness ;
- testability ;
- maintainability ;
- reliability ;
- security/privacy ;
- portability ;
- observability ;
- release engineering ;
- configuration management ;
- architecture quality ;
- automated testing ;
- reproducibility.

N’affirme cependant PAS qu’Iris est « certifiée ISO » ou conforme officiellement à une norme si aucune certification formelle n’existe.

==================================================
3. INVENTAIRE TECHNIQUE COMPLET
==================================================

Avant de noter le projet, dresse un inventaire réel.

Inspecte notamment :

- arborescence complète ;
- nombre de fichiers Swift ;
- lignes de code Swift effectif ;
- lignes de tests ;
- ratio code produit / tests ;
- fichiers de configuration ;
- project.yml ;
- Xcode project/workspace ;
- frameworks Apple utilisés ;
- dépendances externes éventuelles ;
- modules ;
- services ;
- domain layer ;
- UI ;
- rendering ;
- game engine ;
- gaze engine ;
- calibration ;
- persistence ;
- audio ;
- haptics ;
- lifecycle ;
- diagnostics ;
- accessibility ;
- localization ;
- debug tooling ;
- tests ;
- fixtures ;
- documentation ;
- scripts ;
- CI éventuelle ;
- Git hygiene.

Pour le comptage de code :
ne compte pas simplement toutes les lignes physiques.
Fournis au minimum :
- lignes physiques ;
- lignes non vides ;
- lignes de commentaires ;
- estimation ou mesure des lignes de code effectif ;
- code produit ;
- code test.

Explique la méthode utilisée.

==================================================
4. ARCHITECTURE
==================================================

Analyse profondément l’architecture.

Cherche notamment :

- séparation des responsabilités ;
- modularité ;
- couplage ;
- cohésion ;
- dépendances entre couches ;
- frontières Domain / Infrastructure / UI ;
- injection de dépendances ;
- protocoles/interfaces ;
- testabilité ;
- duplication ;
- types trop centraux ou massifs ;
- singletons éventuels ;
- responsabilités excessives ;
- logique métier dans les vues ;
- moteur physique ;
- gaze pipeline ;
- calibration ;
- rendering ;
- persistence ;
- audio/haptics ;
- configuration des niveaux.

Produis une carte architecturale textuelle du système.

Identifie :
- points forts ;
- points faibles ;
- zones réellement sophistiquées ;
- zones fragiles ;
- dette architecturale.

==================================================
5. QUALITÉ DU CODE
==================================================

Analyse :

- lisibilité ;
- nommage ;
- taille des fichiers ;
- taille des types ;
- taille des fonctions ;
- duplication ;
- complexité ;
- gestion des états ;
- invariants ;
- force unwrap ;
- fatalError ;
- try! ;
- casts forcés ;
- concurrence ;
- actor isolation ;
- Sendable ;
- async/await ;
- risques de race ;
- code mort ;
- TODO/FIXME/HACK ;
- warnings ;
- logs de debug laissés en production ;
- abstraction excessive ou insuffisante.

Si possible, donne des statistiques.

Ne modifie rien.

==================================================
6. TESTS ET ASSURANCE QUALITÉ
==================================================

Audite réellement les tests.

Détermine :

- nombre de suites ;
- nombre de tests ;
- nombre de cas réellement exécutés ;
- unit tests ;
- integration tests ;
- UI tests ;
- tests paramétrés ;
- tests du moteur physique ;
- tests du Gaze Engine ;
- tests de calibration ;
- tests de progression ;
- tests des niveaux ;
- tests de layout ;
- tests audio/haptique si présents ;
- tests de persistence ;
- tests de régression ;
- tests d’erreur/lifecycle.

Exécute les tests si cela est raisonnablement possible.

Rapporte exactement :
- passed ;
- failed ;
- skipped ;
- expected failures ;
- résultat final.

Ne te contente pas de compter les fonctions @Test dans le source.
Si le framework exécute plusieurs cas paramétrés, distingue :
- tests déclarés ;
- tests/cas réellement exécutés.

Cherche également les zones importantes non testées.

==================================================
7. BUILDS ET REPRODUCTIBILITÉ
==================================================

Vérifie autant que possible :

- Debug build ;
- Release build ;
- simulateur ;
- configuration appareil physique si disponible ;
- signing ;
- Bundle ID ;
- Development Team ;
- automatic/manual signing ;
- warnings de compilation ;
- erreurs ;
- configuration source de vérité.

Ne change pas la configuration.

Évalue :
- reproductibilité ;
- cohérence project.yml / projet généré ;
- facilité de reprise par un autre développeur.

==================================================
8. FIABILITÉ ET ROBUSTESSE
==================================================

Analyse la gestion :

- erreurs ;
- états invalides ;
- interruptions ARSession ;
- absence TrueDepth ;
- permissions caméra ;
- background/foreground ;
- calibration invalide ;
- tracking perdu ;
- données gaze invalides ;
- changement d’orientation ;
- timing/deltaTime ;
- performance ;
- memory lifecycle ;
- récupération après erreur.

Cherche si les erreurs sont :
- détectées ;
- représentées explicitement ;
- récupérables ;
- testées ;
- affichées correctement.

==================================================
9. GAZE ENGINE / ARKIT / TRUEDPETH
==================================================

Cette partie est particulièrement importante.

Audite sans le modifier :

- acquisition TrueDepth / ARKit ;
- face anchor ;
- gaze source ;
- eye transforms ;
- lookAtPoint si utilisé ;
- head pose ;
- orientation ;
- axes ;
- calibration ;
- affine transform ;
- filtrage ;
- blink rejection ;
- mapping écran ;
- viewport ;
- invalidation ;
- lifecycle ;
- diagnostics ;
- séparation acquisition / mapping / gameplay.

Évalue la sophistication réelle de ce sous-système.

Ne fais aucune affirmation médicale.

==================================================
10. PERFORMANCE
==================================================

Analyse les risques de performance :

- frame loop ;
- allocations répétées ;
- calculs par frame ;
- rendering ;
- SwiftUI invalidations ;
- SpriteKit/Core Graphics si utilisés ;
- ARKit callbacks ;
- audio ;
- haptics ;
- persistence ;
- JSON/logging ;
- main thread ;
- concurrence.

Distingue :
- problèmes réellement observés ;
- risques théoriques.

==================================================
11. SÉCURITÉ ET CONFIDENTIALITÉ
==================================================

Audite :

- données collectées ;
- caméra/TrueDepth ;
- stockage ;
- réseau ;
- télémétrie ;
- analytics ;
- permissions ;
- secrets ;
- API keys ;
- données personnelles ;
- fichiers temporaires ;
- logs ;
- partage de données ;
- dépendances externes.

Cherche dans le dépôt :
- URLs ;
- tokens ;
- secrets ;
- clés ;
- endpoints ;
- analytics SDKs.

Ne présume rien.

==================================================
12. UX / ACCESSIBILITÉ / LOCALISATION
==================================================

Inspecte :

- Dynamic Type ;
- VoiceOver ;
- contraste si discernable dans le code ;
- réductions d’animation éventuelles ;
- taille des targets ;
- orientations ;
- adaptation tailles d’écran ;
- layout dynamique ;
- localisation ;
- strings ;
- textes hardcodés ;
- accessibilité de l’expérience gaze.

Ne donne pas une note esthétique subjective sans preuve.

==================================================
13. DOCUMENTATION ET MAINTENABILITÉ
==================================================

Évalue :

- README ;
- documentation architecture ;
- ADR ;
- rapports ;
- commentaires utiles ;
- documentation des invariants ;
- setup développeur ;
- instructions build/test ;
- historiques de décisions ;
- documentation Git ;
- nomenclature.

Question :
« Un développeur iOS expérimenté qui ne connaît pas Iris pourrait-il raisonnablement comprendre, compiler, tester et modifier ce projet ? »

Justifie.

==================================================
14. GIT / CONFIGURATION MANAGEMENT
==================================================

Analyse :

- historique Git ;
- taille et qualité des commits ;
- branches ;
- tags ;
- baselines ;
- cohérence des messages ;
- granularité ;
- capacité à retrouver un état validé ;
- fichiers générés suivis ou non ;
- .gitignore ;
- artefacts accidentels ;
- provenance des modifications.

Ne modifie rien.

==================================================
15. DÉPENDANCES ET RISQUE FOURNISSEUR
==================================================

Inventorie :
- dépendances Apple ;
- packages Swift ;
- frameworks externes ;
- SDK externes ;
- services réseau.

Évalue :
- surface de dépendance ;
- verrouillage ;
- maintenance future ;
- risque de rupture API.

==================================================
16. PRODUCTION READINESS
==================================================

Détermine ce qui sépare encore Iris d’une application totalement « production-grade ».

Cherche notamment :
- crash reporting ;
- analytics ;
- CI ;
- automated release ;
- TestFlight ;
- monitoring ;
- accessibility completeness ;
- privacy manifest ;
- store compliance ;
- localization ;
- QA matrix ;
- performance profiling ;
- energy profiling ;
- memory profiling ;
- release checklist ;
- rollback strategy.

ATTENTION :
L’absence volontaire d’analytics ou de cloud n’est pas nécessairement un défaut.
Juge selon le produit et la politique de confidentialité choisie.

==================================================
17. GRILLE DE NOTATION
==================================================

Construis une grille sur 100 points.

Utilise exactement ces catégories :

1. Architecture et modularité — 15
2. Qualité et maintenabilité du code — 10
3. Tests et prévention des régressions — 15
4. Fiabilité / gestion des erreurs — 10
5. Build / release / reproductibilité — 10
6. Performance et maîtrise temps réel — 10
7. Sécurité / confidentialité — 10
8. UX / accessibilité / adaptation — 5
9. Documentation / maintenabilité humaine — 5
10. Git / configuration management — 5
11. Observabilité / diagnostic — 3
12. Préparation réelle à la production — 2

TOTAL = 100.

Pour chaque catégorie :
- score ;
- maximum ;
- preuves ;
- limites ;
- justification.

==================================================
18. CLASSIFICATION FINALE
==================================================

Utilise cette échelle :

0–24 :
Prototype expérimental

25–39 :
Application amateur

40–54 :
Application amateur avancée

55–69 :
Application semi-professionnelle

70–82 :
Application professionnelle

83–92 :
Application professionnelle avancée / production-grade

93–100 :
Niveau industriel / critique

IMPORTANT :
Le dernier niveau ne doit PAS être attribué simplement parce que le code est excellent.
Il implique un degré exceptionnel de processus, validation, qualité, reproductibilité et assurance.

==================================================
19. DEUXIÈME CLASSIFICATION INDÉPENDANTE
==================================================

Après le score sur 100, fais une deuxième classification sans utiliser directement ce score.

Réponds indépendamment à :

A. Qualité d’architecture :
- faible
- correcte
- professionnelle
- avancée

B. Discipline d’ingénierie :
- faible
- intermédiaire
- professionnelle
- avancée

C. Robustesse :
- prototype
- application classique
- production
- critique

D. Testabilité :
- faible
- moyenne
- forte
- très forte

E. Complexité technique :
- faible
- moyenne
- élevée
- très élevée

F. Maturité du projet :
- prototype
- amateur
- semi-pro
- professionnel
- professionnel avancé
- industriel

Puis compare cette deuxième classification au résultat /100.
S’il existe une incohérence, explique-la.

==================================================
20. COMPARAISON AVEC DES TYPES DE PROJETS
==================================================

Situe Iris qualitativement par rapport à :

- projet étudiant ;
- prototype hackathon ;
- application indie simple ;
- application App Store sérieuse développée par un indépendant ;
- application professionnelle d’une petite équipe ;
- produit mobile mature d’entreprise ;
- logiciel critique réglementé.

Ne fais pas de comparaison commerciale ou marketing.
Compare uniquement la maturité technique et d’ingénierie.

==================================================
21. CE QUI EMPÊCHE LE NIVEAU SUPÉRIEUR
==================================================

Après la classification, donne précisément :

« Les 10 éléments qui empêchent actuellement Iris d’obtenir la classe immédiatement supérieure. »

Classe-les :
- bloquant ;
- important ;
- amélioration.

Ne propose pas de changement de code pendant cet audit.

==================================================
22. ANALYSE DU NOMBRE DE LIGNES
==================================================

Le projet a précédemment donné environ 19 932 lignes Swift non vides/non commentaires avec une commande simple.

Ne prends pas ce chiffre comme vérité définitive.

Refais une mesure plus rigoureuse.

Dis :
- combien de lignes de code produit ;
- combien de lignes de test ;
- combien de lignes de documentation/commentaires ;
- combien de fichiers ;
- distribution approximative par grand sous-système.

Explique ce que ce volume signifie réellement et surtout ce qu’il NE signifie PAS.

==================================================
23. VERDICT FINAL
==================================================

Termine le rapport par cette structure exacte :

VERDICT FINAL

Classification :
[classe]

Score :
[xx/100]

Niveau de confiance :
[faible / moyen / élevé / très élevé]

Phrase de synthèse :
[une seule phrase précise]

Pourquoi :
[5 à 10 lignes maximum]

Principal point fort :
[...]

Principal facteur limitant :
[...]

Distance estimée de la classe supérieure :
[faible / modérée / importante]

==================================================
24. LIVRABLE
==================================================

Je veux un rapport très complet mais lisible.

Nom suggéré :

RAPPORT_AUDIT_MATURITE_IRIS.md

Mais ATTENTION :
comme cette mission doit rester en lecture seule, ne crée PAS ce fichier dans le dépôt.

Présente le rapport directement dans la session Terminal/Claude.

À la toute fin, affiche également un résumé compact de 15 à 20 lignes que je pourrai copier séparément.

==================================================
25. PRIORITÉ ABSOLUE
==================================================

Je préfère un score plus bas mais démontré à un score flatteur et faux.

Ne protège pas le projet de la critique.

Ne cherche pas non plus artificiellement des défauts.

Mesure ce qui existe réellement.

Commence maintenant par l’état Git et l’inventaire du dépôt, puis mène l’audit jusqu’au verdict final sans me poser de question sauf impossibilité technique absolue.
~~~~

### 2026-09-14 16:33:13 +0200 (14:33:13Z) · SYSTEM · modèle : Opus 5 (1M context) (claude-opus-5[1m])
`4a1b6284` · `37a68854` · ligne 16

### 2026-09-14 16:33:13 +0200 (14:33:13Z) · SYSTEM · date de session : 2026-09-14
`4a1b6284` · `b760d8ba` · ligne 24

### (sans horodatage) · TITRE DE SESSION : Audit de maturité Iris
`4a1b6284` · `` · ligne 32

### 2026-09-14 16:33:16 +0200 (14:33:16Z) · CLAUDE
`4a1b6284` · `dc04bbb1` · ligne 34

~~~~markdown
Je commence par l'état Git et l'inventaire (lecture seule).
~~~~

#### 2026-09-14 16:33:19 +0200 (14:33:19Z) · TOOL CALL · Bash · GIT
`4a1b6284` · `fa2867b2` · ligne 35 · Inspect git state, remotes, tags, branches, history

~~~~bash
cd "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris" && git branch --show-current && git rev-parse HEAD && git status --short && git remote -v && git fetch --dry-run 2>&1 | head -3; git rev-list --left-right --count origin/prototype/x7-stabilisation-head-guidance...HEAD 2>&1; git rev-list --left-right --count origin/main...HEAD 2>&1; git tag -l | head -50; echo ---; git branch -a; echo ---; git log --oneline | wc -l; git log --format='%h %ad %s' --date=short | tail -3; git log --format='%h %ad %s' --date=short | head -40
~~~~

#### 2026-09-14 16:33:22 +0200 (14:33:22Z) · TOOL CALL · Bash · GIT
`4a1b6284` · `df1a4d7c` · ligne 36 · List repo top-level, gitignore, tracked file distribution

~~~~bash
cd "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris" && ls -la && cat .gitignore 2>/dev/null; echo ---; git ls-files | awk -F/ '{print $1"/"$2}' | sort | uniq -c | sort -rn | head -40; echo ---; git ls-files | wc -l; git ls-files | sed 's/.*\.//' | sort | uniq -c | sort -rn | head
~~~~

#### 2026-09-14 16:33:23 +0200 (14:33:23Z) · TOOL RESULT · Bash · GIT
`4a1b6284` · `793b1fce` · ligne 37 · Inspect git state, remotes, tags, branches, history

~~~~text
prototype/x7-stabilisation-head-guidance
3abddb732b8ad54c04fe27d9acdd967d49535176
?? SKILL.md
?? x7_silhouette_reference.png
origin	https://github.com/ProdX0x/iris-ios.git (fetch)
origin	https://github.com/ProdX0x/iris-ios.git (push)
fatal: ambiguous argument 'origin/prototype/x7-stabilisation-head-guidance...HEAD': unknown revision or path not in the working tree.
Use '--' to separate paths from revisions, like this:
'git <command> [<revision>...] -- [<file>...]'
0	32
baseline-expansion-v1
iris-ch1-oculomotor-human-validated-v1
iris-expansion-human-validated-v1
---
  baseline/iris-expansion-validated
  feature/game-expansion
  feature/iris-full-expansion
  feature/iris-oculomotor-expansion
  feature/iris-v2
  fix/chapter-card-adaptive-layout
  main
  prototype/braises
  prototype/braises-b-final-diagnostic
  prototype/braises-b-rework
  prototype/braises-b-ux-audio
  prototype/ch1-oculomotor-level6
* prototype/x7-stabilisation-head-guidance
  remotes/origin/HEAD -> origin/main
  remotes/origin/baseline/iris-expansion-validated
  remotes/origin/feature/game-expansion
  remotes/origin/feature/iris-full-expansion
  remotes/origin/feature/iris-oculomotor-expansion
  remotes/origin/feature/iris-v2
  remotes/origin/fix/chapter-card-adaptive-layout
  remotes/origin/main
  remotes/origin/prototype/braises
  remotes/origin/prototype/braises-b-final-diagnostic
  remotes/origin/prototype/braises-b-rework
  remotes/origin/prototype/braises-b-ux-audio
  remotes/origin/prototype/ch1-oculomotor-level6
---
      35
52f20b7 2026-09-11 feat: complete Iris v2 refactor and Gaze Engine v2
6e1b726 2026-09-11 Add .gitignore and update project settings
ced3722 2026-09-11 Initial Commit
3abddb7 2026-09-14 docs: record the X·7 correction
f51be97 2026-09-14 x7: observe the head loops in DEBUG
bd7bddd 2026-09-14 x7: guide the head around two loops with the reference silhouette
e29cae7 2026-09-14 fix: make chapter cards adaptive to level count
93326de 2026-09-14 docs: record the oculomotor expansion
66b0d71 2026-09-14 chapter 12: add final « l'orchestre du regard » (multi-modal synthesis)
d7b3325 2026-09-14 chapter 11: add final « d'abord les yeux » (eye-head coordination)
275aa8f 2026-09-14 chapter 10: add final « l'ancre » (gaze stabilisation, VOR-inspired)
1ba7f30 2026-09-14 chapter 9: add final « l'absence » (fixation disengagement)
8a96759 2026-09-14 chapter 8: add final « la lanterne du courant » (predictive pursuit)
27c2fac 2026-09-14 oculomotor: run every stage on its own clock
5108926 2026-09-14 chapter 7: add final « la danse croisée » (diagonal saccades)
9793b86 2026-09-14 chapter 6: add final « le jardin caché » (visual search, scanning)
e547c2e 2026-09-14 chapter 5: add final « les étoiles absentes » (memory-guided saccades)
0cb3aea 2026-09-14 chapter 4: add final « le miroir menteur » (anti-saccade)
3e86cce 2026-09-14 chapter 3: add final « le fil vivant » (smooth pursuit)
5068e2f 2026-09-14 chapter 2: add final « le cœur de verre » (fixation stability)
77e86c2 2026-09-14 oculomotor: add shared stage infrastructure and protect the validated levels
c452c01 2026-09-14 prototype: add Chapter I oculomotor level 6
4bdb0ae 2026-09-13 docs: record the full expansion
8282ffd 2026-09-13 chapter 12: add constellation
d90f117 2026-09-13 chapter 11: add braises
31ed0f7 2026-09-13 chapter 10: add gouffres
393a566 2026-09-13 chapter 9: add échos
ae0ef43 2026-09-13 chapter 8: add souffles
6d17731 2026-09-12 chapter 7: add jumelles
19f2b1c 2026-09-12 expansion: add shared chapter mechanics infrastructure
d7e3a88 2026-09-12 docs: record validated expansion baseline
4d78ce8 2026-09-12 feat: preserve validated audio separation
194dcd1 2026-09-12 prototype: preserve validated Braises A
937d549 2026-09-12 docs: define Iris campaign expansion concepts
229b8df 2026-09-12 fix: restore gameplay haptic feedback
52f20b7 2026-09-11 feat: complete Iris v2 refactor and Gaze Engine v2
6e1b726 2026-09-11 Add .gitignore and update project settings
ced3722 2026-09-11 Initial Commit
~~~~

#### 2026-09-14 16:33:25 +0200 (14:33:25Z) · TOOL RESULT · Bash · GIT
`4a1b6284` · `0ed5c97f` · ligne 38 · List repo top-level, gitignore, tracked file distribution

~~~~text
total 4240
drwxr-xr-x  31 prodx0x  staff      992 14 sept. 16:05 .
drwx------  18 prodx0x  staff      576 14 sept. 10:50 ..
-rw-r--r--@  1 prodx0x  staff    14340 14 sept. 16:06 .DS_Store
drwxr-xr-x  15 prodx0x  staff      480 14 sept. 16:33 .git
-rw-r--r--@  1 prodx0x  staff      502 11 sept. 09:26 .gitignore
drwxr-xr-x   7 prodx0x  staff      224 12 sept. 00:08 App
drwxr-xr-x   6 prodx0x  staff      192 11 sept. 08:02 AR
-rw-r--r--@  1 prodx0x  staff    24266 10 sept. 23:16 attention-indirecte.html
drwxr-xr-x   6 prodx0x  staff      192 11 sept. 00:05 Audio
drwxr-xr-x   3 prodx0x  staff       96 10 sept. 23:48 Config
drwxr-xr-x  19 prodx0x  staff      608 14 sept. 15:56 Design
drwxr-xr-x   6 prodx0x  staff      192 10 sept. 23:59 DesignSystem
drwxr-xr-x  13 prodx0x  staff      416 12 sept. 19:12 Docs
drwxr-xr-x  12 prodx0x  staff      384 12 sept. 01:17 Domain
drwxr-xr-x  13 prodx0x  staff      416 12 sept. 00:08 Features
-rw-r--r--   1 prodx0x  staff    12886 12 sept. 02:08 GAME_EXPANSION_DESIGN_REPORT.md
drwxr-xr-x  11 prodx0x  staff      352 14 sept. 04:28 GameEngine
-rw-r--r--   1 prodx0x  staff    15133 12 sept. 00:08 GAZE_ENGINE_V2_REPORT.md
drwxr-xr-x   5 prodx0x  staff      160 12 sept. 01:17 Haptics
-rw-------@  1 prodx0x  staff   112405 29 août  06:55 ios-app-skills.zip
drwxr-xr-x@  5 prodx0x  staff      160 14 sept. 16:05 Iris.xcodeproj
drwxr-xr-x   7 prodx0x  staff      224 12 sept. 19:12 Navigation
-rw-r--r--   1 prodx0x  staff     3228 12 sept. 01:18 project.yml
-rw-r--r--   1 prodx0x  staff    75200 14 sept. 15:56 README.md
drwxr-xr-x   4 prodx0x  staff      128 10 sept. 23:48 Resources
-rw-r--r--@  1 prodx0x  staff    18763 14 sept. 15:21 SKILL.md
-rw-r--r--@  1 prodx0x  staff   581123  5 sept. 13:21 SwiftUI-Agent-Skill-main.zip
drwxr-xr-x   4 prodx0x  staff      128 10 sept. 23:53 Tests
drwxr-xr-x   4 prodx0x  staff      128 12 sept. 00:08 Tools
-rw-r--r--   1 prodx0x  staff     5692 12 sept. 19:16 VALIDATED_EXPANSION_BASELINE_REPORT.md
-rw-r--r--@  1 prodx0x  staff  1284587 14 sept. 14:29 x7_silhouette_reference.png
# Xcode
.DS_Store
*.swp
*~.nib
*.pbxuser
!default.pbxuser
*.mode1v3
!default.mode1v3
*.mode2v3
!default.mode2v3
*.perspectivev3
!default.perspectivev3
xcuserdata/
*.xccheckout
*.moved-aside
DerivedData/
*.hmap
*.ipa
*.dSYM.zip
*.dSYM
timeline.xctimeline
playground.xcworkspace

# Swift Package Manager
.build/
.swiftpm/
Package.resolved

# CocoaPods
Pods/
*.xcworkspace

# Carthage
Carthage/Build/

# fastlane
fastlane/report.xml
fastlane/Preview.html
fastlane/screenshots/**/*.png
fastlane/test_output---
  75 Tests/IrisTests
  46 Resources/Assets.xcassets
  45 Domain/Campaign
  21 Features/Game
  15 AR/Calibration
  12 DesignSystem/Components
  11 GameEngine/Oculo
  11 GameEngine/Environment
   8 Features/GazeSetup
   8 AR/Services
   6 Docs/Features
   6 DesignSystem/Tokens
   5 Features/Chapters
   5 Domain/ValueObjects
   5 Domain/Validation
   5 Domain/Progress
   5 Domain/Entities
   4 Audio/Services
   4 App/Platform
   3 Haptics/Services
   3 GameEngine/Session
   3 GameEngine/Noise
   3 GameEngine/Campaign
   3 Features/CameraAccess
   2 Haptics/Policy
   2 GameEngine/Clock
   2 Features/Shared
   2 Domain/Levels
   2 DesignSystem/Modifiers
   2 Audio/Policy
   2 App/Persistence
   2 App/DI
   1 VALIDATED_EXPANSION_BASELINE_REPORT.md/
   1 Tools/MakeAppIcon.swift
   1 Tools/audit.py
   1 SwiftUI-Agent-Skill-main.zip/
   1 README.md/
   1 project.yml/
   1 Navigation/RootView.swift
   1 Navigation/HomeSummary.swift
---
     387
 290 swift
  47 json
  36 md
   2 zip
   2 txt
   1 yml
   1 xcworkspacedata
   1 xcscheme
   1 py
   1 png
~~~~

#### 2026-09-14 16:33:37 +0200 (14:33:37Z) · TOOL CALL · Read
`4a1b6284` · `72b7c774` · ligne 50

~~~~json
{
 "file_path": "/Users/prodx0x/.claude/projects/-Volumes-Steve-Pro-BlackSSD-Dev-App-Mobile-Iris/memory/iris-project-setup.md"
}
~~~~

#### 2026-09-14 16:33:37 +0200 (14:33:37Z) · TOOL RESULT · Read
`4a1b6284` · `44a70daf` · ligne 51

~~~~text
1	---
2	name: iris-project-setup
3	description: "How the Iris iOS project is built and verified (xcodegen, test/build commands, debug launch options, campaign verification, what still needs a TrueDepth device)"
4	metadata: 
5	  node_type: memory
6	  type: project
7	  originSessionId: f88478cc-d512-4210-bc11-758059278995
8	  modified: 2026-09-11T11:46:40.732Z
9	---
10	
11	Iris lives directly in the working directory, is a git repo (branch `feature/iris-v2`, remote `ProdX0x/iris-ios`) and `Iris.xcodeproj` is generated from `project.yml` with XcodeGen: run `xcodegen generate` after adding or removing files. Tests run on the `iPhone 17 Pro` simulator (220 tests on 2026-09-11 after the redesign). Device builds are signed for real with `-destination 'generic/platform=iOS'` (team G4U9RG5GL7, automatic profile), see [[iris-apple-identity]].
12	
13	Product references live in `Design/` (PRODUCT_AUDIT, GAME_VISION, GAME_DESIGN, LEVEL_DESIGN_SYSTEM, UX_VISION, ART_DIRECTION). The campaign is authored data (`Domain/Campaign/Campaign+*.swift`, 6 chapters, 34 levels) resolved per screen by `LevelResolver`; `PrototypeLevelCatalog` (14 levels) is kept only for the golden traces of `attention-indirecte.html`.
14	
15	Every level is proven by simulated players in `Tests/IrisTests/Campaign/` (`CampaignBot`, `CampaignMeasurements`, `CampaignValidationTests`); `LevelLabTests` prints the metrics table used in LEVEL_DESIGN_SYSTEM.md section 10. Changing a level's geometry means re-running the lab and recomputing its par (`time = round(1.8 × botTime + 6)`, `intrusions = ceil(botIntrusions) + 2`).
16	
17	Debug launch arguments: `--iris-route <home|cameraAccess|gazeSetup|chapters|carnet|game|journeyComplete|unavailable>`, `--iris-level c-i`, `--iris-progress all|c-i`, `--iris-autoplay`, `--iris-gaze x,y`, `--iris-oracle-gaze`. For screenshots use `xcrun simctl` on the `iPhone 17` simulator while tests run on `iPhone 17 Pro` with `test-without-building`; never install while an `xcodebuild` is rewriting DerivedData.
18	
19	**Why:** the user runs autonomous, no-question missions and wants honest status labels; README.md is the authoritative technical notebook.
20	
21	**How to apply:** never modify `attention-indirecte.html`; commit only when asked (the reference commit `feat: complete Iris v2 refactor and Gaze Engine v2` was requested on 2026-09-11); real gaze accuracy, calibration comfort and human play feel are still `[nécessite validation sur iPhone TrueDepth]` (the app was installed and launched on the paired iPhone 14 Pro on 2026-09-11 via devicectl, but nobody has calibrated or played on it).
22	
23	**Disk space (14 Sept 2026):** the Mac's internal disk is nearly full (a few GiB free; a full disk once broke builds and the tool harness). Build and test with `-derivedDataPath "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/.iris-derived-data/<sim|release|device>"`, which sits outside the repo on the external SSD, and avoid creating new simulators. See [[iris-chapter-card-layout]].
24	
~~~~

#### 2026-09-14 16:33:48 +0200 (14:33:48Z) · TOOL CALL · Bash · GIT
`4a1b6284` · `a00aa9ca` · ligne 52 · Measure Swift LOC by subsystem, largest files

~~~~bash
cd "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris" && cat > "/private/tmp/claude-501/-Volumes-Steve-Pro-BlackSSD-Dev-App-Mobile-Iris/4a1b6284-eeb2-4ff3-9176-b7e4a3a1b4bc/scratchpad/loc.py" <<'EOF'
import subprocess,re,collections
files=subprocess.check_output(['git','ls-files','*.swift']).decode().split('\n')
files=[f for f in files if f]
agg=collections.defaultdict(lambda:[0,0,0,0,0])  # files, physical, blank, comment, code
for f in files:
    txt=open(f,encoding='utf-8').read().split('\n')
    if txt and txt[-1]=='': txt=txt[:-1]
    blank=com=code=0; inblock=0
    for l in txt:
        s=l.strip()
        if inblock:
            com+=1
            inblock+=s.count('/*')-s.count('*/')
            continue
        if not s: blank+=1
        elif s.startswith('//'): com+=1
        elif s.startswith('/*'):
            com+=1; inblock=s.count('/*')-s.count('*/')
        else: code+=1
    if f.startswith('Tests/'): key='TEST:'+'/'.join(f.split('/')[:3]) if f.count('/')>2 else 'TEST'
    else: key='/'.join(f.split('/')[:2]) if '/' in f else f
    top='TEST' if f.startswith('Tests/') else ('TOOLS' if f.startswith('Tools/') else 'PRODUCT')
    for k in (key,'=='+top):
        a=agg[k]; a[0]+=1; a[1]+=len(txt); a[2]+=blank; a[3]+=com; a[4]+=code
print(f"{'group':45}{'files':>6}{'phys':>7}{'blank':>7}{'comm':>7}{'code':>7}")
for k,v in sorted(agg.items(),key=lambda x:(-x[1][4])):
    print(f"{k:45}{v[0]:>6}{v[1]:>7}{v[2]:>7}{v[3]:>7}{v[4]:>7}")
EOF
python3 "/private/tmp/claude-501/-Volumes-Steve-Pro-BlackSSD-Dev-App-Mobile-Iris/4a1b6284-eeb2-4ff3-9176-b7e4a3a1b4bc/scratchpad/loc.py"; echo; git ls-files '*.swift' | grep -v '^Tests/' | xargs wc -l | sort -rn | head -25; echo; git ls-files '*.swift' | grep '^Tests/' | xargs wc -l | sort -rn | head -10
~~~~

#### 2026-09-14 16:33:50 +0200 (14:33:50Z) · TOOL RESULT · Bash · GIT
`4a1b6284` · `0e9200d5` · ligne 53 · Measure Swift LOC by subsystem, largest files

~~~~text
group                                         files   phys  blank   comm   code
==PRODUCT                                       219  16280   1586   1624  13070
==TEST                                           70   8750   1060    390   7300
TEST:Tests/IrisTests/Campaign                    29   4237    350    223   3664
Features/Game                                    21   3650    277    271   3102
Domain/Campaign                                  45   2444    180    360   1904
GameEngine/Oculo                                 11   1714    132    131   1451
TEST:Tests/IrisTests/Presentation                10   1603    197     53   1353
TEST:Tests/IrisTests/GameEngine                   9   1008    167     36    805
DesignSystem/Components                          12    928     88     42    798
AR/Calibration                                   15   1033    143    105    785
Features/GazeSetup                                8    800     79     41    680
TEST:Tests/IrisTests/AR                           8    768    130     28    610
GameEngine/Environment                           11    636     80     87    469
GameEngine/Session                                3    577     47     66    464
AR/Services                                       8    599     85     56    458
TEST:Tests/IrisTests/Domain                       6    545     99     18    428
Audio/Synth                                       1    297     28     17    252
Features/Chapters                                 5    319     32     36    251
Navigation/AppCoordinator.swift                   1    287     40     11    236
GameEngine/Campaign                               3    257     21     18    218
TEST:Tests/IrisTests/Audio                        2    233     54      6    173
Audio/Services                                    4    206     28     16    162
App/Platform                                      4    191     23     22    146
App/DI                                            2    173     18     14    141
Features/CameraAccess                             3    165     21     10    134
Domain/Progress                                   5    162     30     20    112
DesignSystem/Tokens                               6    175     21     43    111
TEST:Tests/IrisTests/Fixtures                     2    137     19     12    106
Domain/Entities                                   5    156     23     29    104
TEST:Tests/IrisTests/Mocks                        3    115     22     10     83
GameEngine/Physics                                1    114     10     22     82
TEST:Tests/IrisTests/Haptics                      1    104     22      4     78
Navigation/RootView.swift                         1     82      6      3     73
Domain/Validation                                 5    117     17     28     72
Domain/ValueObjects                               5    109     24     19     66
Features/Settings                                 1     70      4      3     63
Haptics/Policy                                    2     86      7     16     63
Audio/Policy                                      2     88      7     20     61
Domain/Levels                                     2     81      9     13     59
Features/Home                                     1     65      4      3     58
Tools/MakeAppIcon.swift                           1     70      4      9     57
==TOOLS                                           1     70      4      9     57
Features/JourneyComplete                          1     61      5      3     53
Features/Carnet                                   1     59      6      3     50
Features/Shared                                   2     59      4      6     49
App/Persistence                                   2     58     12      6     40
Features/Unavailable                              1     48      6      3     39
GameEngine/Gaze                                   1     49      6      8     35
DesignSystem/Modifiers                            2     46      8      6     32
Haptics/Services                                  3     51      8     12     31
GameEngine/Clock                                  2     45      9      7     29
GameEngine/Noise                                  3     47      9     10     28
Navigation/AppRoute.swift                         1     34      5      3     26
Navigation/HomeSummary.swift                      1     33      5      3     25
AR/Projection                                     1     23      2      6     15
Domain/Physics                                    1     28      5     10     13
Domain/Random                                     1     19      4      4     11
App/IrisApp.swift                                 1     16      3      3     10
Navigation/AppSheet.swift                         1     11      3      3      5
Domain/Feedback                                   1     12      2      6      4

   16350 total
     644 Features/Game/Rendering/GameSceneRenderer.swift
     586 Features/Game/ViewModels/GameViewModel.swift
     507 GameEngine/Session/GameSession.swift
     482 Domain/Campaign/OculoDefinition.swift
     369 Features/GazeSetup/ViewModels/GazeSetupViewModel.swift
     350 Features/Game/Diagnostics/OculomotorTrace.swift
     314 GameEngine/Oculo/AncreStageState.swift
     304 Features/Game/Rendering/GameSceneSnapshot.swift
     297 Audio/Synth/SineSynth.swift
     287 Navigation/AppCoordinator.swift
     280 Features/Game/Rendering/OculoSnapshot.swift
     275 GameEngine/Oculo/OculoStageState.swift
     247 DesignSystem/Components/DSGlyph.swift
     239 Features/Game/Rendering/GameSceneRenderer+Ancre.swift
     190 Features/Game/Diagnostics/AncreCapture.swift
     183 GameEngine/Oculo/TournerStageState.swift
     179 AR/Services/ARKitGazeTrackingService.swift
     167 Features/Game/Rendering/GameSceneRenderer+Oculo.swift
     159 App/DI/AppContainer.swift
     154 GameEngine/Oculo/CourantStageState.swift
     153 GameEngine/Oculo/AbsenceStageState.swift
     153 AR/Calibration/FixationSequence.swift
     145 GameEngine/Oculo/MiroirStageState.swift
     143 Audio/Services/AVAudioEngineAudioService.swift

    8750 total
     419 Tests/IrisTests/Presentation/GameViewModelTests.swift
     390 Tests/IrisTests/Campaign/CampaignBot.swift
     277 Tests/IrisTests/Presentation/GazeSetupViewModelTests.swift
     275 Tests/IrisTests/Campaign/OculoAncreTests.swift
     265 Tests/IrisTests/Campaign/OculomotorLevelTests.swift
     250 Tests/IrisTests/Campaign/BraisesPrototypeTests.swift
     227 Tests/IrisTests/GameEngine/LevelEnvironmentTests.swift
     210 Tests/IrisTests/Campaign/JumellesTests.swift
     202 Tests/IrisTests/Presentation/AppCoordinatorTests.swift
~~~~

#### 2026-09-14 16:34:02 +0200 (14:34:02Z) · TOOL CALL · Bash · GIT
`4a1b6284` · `836b9863` · ligne 54 · Code-quality, concurrency, security grep statistics

~~~~bash
cd "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris" && P=$(git ls-files '*.swift' | grep -v '^Tests/'); T=$(git ls-files '*.swift' | grep '^Tests/'); c(){ echo "$1: prod=$(echo "$P" | tr '\n' '\0' | xargs -0 grep -E "$2" 2>/dev/null | wc -l) test=$(echo "$T" | tr '\n' '\0' | xargs -0 grep -E "$2" 2>/dev/null | wc -l)"; }
c "fatalError" 'fatalError\(' ; c "try!" 'try!' ; c "as!" 'as! ' ; c "try?" 'try\?' ; c "forceunwrap(heur)" '[A-Za-z0-9_\)\]]![\.\)\], ]' ; c "precondition/assert" '(precondition|assert)(ionFailure)?\(' ; c "TODO/FIXME/HACK" 'TODO|FIXME|HACK|XXX' ; c "print(" '\bprint\(' ; c "os Logger" 'Logger\(|os_log|OSLog' ; c "#if DEBUG" '#if DEBUG' ; c ".shared" '\.shared\b' ; c "static let shared" 'static (let|var) shared' ; c "@MainActor" '@MainActor' ; c "actor decl" '^\s*(final )?actor ' ; c "Sendable" 'Sendable' ; c "nonisolated" 'nonisolated' ; c "async" '\basync\b' ; c "Task {" 'Task( |\.detached)?\s*\{' ; c "DispatchQueue" 'DispatchQueue' ; c "@unchecked" '@unchecked' ; c "protocol decl" '^\s*(public )?protocol ' ; c "struct" '^\s*(public |private |fileprivate |internal )?struct ' ; c "final class/class" '^\s*(public |private |final |fileprivate )*class ' ; c "enum" '^\s*(public |private |fileprivate |indirect )*enum ' ; c "@Observable" '@Observable' ; c "ObservableObject" 'ObservableObject' ; c "accessibility" 'accessibility' ; c "reduceMotion" 'accessibilityReduceMotion|reduceMotion' ; c "dynamicTypeSize" 'dynamicTypeSize|DynamicTypeSize' ; c "LocalizedStringKey/String(localized" 'String\(localized|LocalizedStringKey|NSLocalizedString' ; c "http(s)" 'https?://' ; c "URLSession" 'URLSession' ; c "UserDefaults" 'UserDefaults' ; c "FileManager" 'FileManager' ; c "@Test" '@Test' ; c "func test" 'func test' ; c "#expect/XCTAssert" '#expect|#require|XCTAssert' ; c "arguments:" 'arguments:' ; c "@Suite" '@Suite' ; c "withKnownIssue" 'withKnownIssue' ; c ".disabled" '\.disabled' 
echo; echo "imports:"; git ls-files '*.swift' | tr '\n' '\0' | xargs -0 grep -h '^import ' | sort | uniq -c | sort -rn
echo; git ls-files | grep -Ei 'zip|html|png|Design/|\.github|ci|fastlane|PrivacyInfo|entitlements|plist|xcodeproj|Docs/' | head -60
echo; grep -rEin 'api[_-]?key|secret|token|password|bearer' --include='*.swift' --include='*.yml' --include='*.plist' --include='*.json' . 2>/dev/null | grep -v '.git/' | head
~~~~

#### 2026-09-14 16:34:06 +0200 (14:34:06Z) · TOOL RESULT · Bash · GIT
`4a1b6284` · `8ef83552` · ligne 55 · Code-quality, concurrency, security grep statistics

~~~~text
fatalError: prod=       0 test=       0
try!: prod=       0 test=       0
as!: prod=       0 test=       0
try?: prod=      14 test=       0
forceunwrap(heur): prod=       0 test=       0
precondition/assert: prod=       0 test=       0
TODO/FIXME/HACK: prod=       0 test=       0
print(: prod=       1 test=       2
os Logger: prod=       5 test=       0
#if DEBUG: prod=      19 test=       2
.shared: prod=       1 test=       0
static let shared: prod=       0 test=       0
@MainActor: prod=      42 test=      14
actor decl: prod=       0 test=       0
Sendable: prod=     207 test=       2
nonisolated: prod=       5 test=       0
async: prod=       6 test=       3
Task {: prod=       1 test=       0
DispatchQueue: prod=       1 test=       0
@unchecked: prod=       7 test=       1
protocol decl: prod=      13 test=       0
struct: prod=     192 test=      73
final class/class: prod=      26 test=       4
enum: prod=      88 test=       8
@Observable: prod=       5 test=       0
ObservableObject: prod=       0 test=       0
accessibility: prod=      58 test=       1
reduceMotion: prod=      85 test=       1
dynamicTypeSize: prod=       1 test=       4
LocalizedStringKey/String(localized: prod=       0 test=       0
http(s): prod=       0 test=       0
URLSession: prod=       0 test=       0
UserDefaults: prod=      15 test=      14
FileManager: prod=       3 test=       0
@Test: prod=       0 test=     406
func test: prod=       0 test=       0
#expect/XCTAssert: prod=       0 test=    1544
arguments:: prod=       2 test=       0
@Suite: prod=       0 test=      62
withKnownIssue: prod=       0 test=       0
.disabled: prod=       3 test=       0

imports:
 230 import Foundation
  59 import Testing
  49 import SwiftUI
  28 import simd
   6 import UIKit
   6 import os
   5 import Observation
   2 import CoreGraphics
   2 import AVFoundation
   2 import ARKit
   1 import UniformTypeIdentifiers
   1 import QuartzCore
   1 import ImageIO
   1 import CryptoKit

Config/Info.plist
Design/ART_DIRECTION.md
Design/BRAISES_VALIDATION_STATUS.md
Design/CAMPAIGN_STRUCTURE.md
Design/DIFFICULTY_MODEL.md
Design/GAME_CORE_INVARIANTS.md
Design/GAME_DESIGN.md
Design/GAME_EXPANSION_CONCEPTS.md
Design/GAME_VISION.md
Design/GAZE_CALIBRATION_DISTANCE_HYPOTHESIS.md
Design/IRIS_FULL_EXPANSION_REPORT.md
Design/LEVEL_DESIGN_SYSTEM.md
Design/OCULOMOTOR_EXPANSION_REPORT.md
Design/OCULOMOTOR_LEVEL6_PROTOTYPE.md
Design/PLAYER_COMFORT_CONSTRAINTS.md
Design/PRODUCT_AUDIT.md
Design/UX_VISION.md
Design/X7_ANCRE_CORRECTION.md
DesignSystem/Tokens/DSSpacing.swift
Docs/Features/Audio.md
Docs/Features/Game.md
Docs/Features/Gaze.md
Docs/Features/Haptics.md
Docs/Features/JourneyEnd.md
Docs/Features/Onboarding.md
Docs/architecture.md
Docs/audit-2026-09-11.md
Docs/conventions.md
Docs/dedup-log.md
Docs/design-system.md
Docs/domain-model.md
Docs/file-map.md
Docs/product.md
Docs/project-brief.md
Iris.xcodeproj/project.pbxproj
Iris.xcodeproj/project.xcworkspace/contents.xcworkspacedata
Iris.xcodeproj/xcshareddata/xcschemes/Iris.xcscheme
Resources/Assets.xcassets/AppIcon.appiconset/AppIcon.png
SwiftUI-Agent-Skill-main.zip
attention-indirecte.html
ios-app-skills.zip

DesignSystem/Tokens/DSColor.swift:3:// Purpose: Semantic colour tokens of the "chambre noire" identity (values live in the asset catalogue)
DesignSystem/Tokens/DSThemePalette.swift:22:    /// Chapters I to VI: the historical tokens, no wash.
DesignSystem/Tokens/DSFont.swift:3:// Purpose: Typography tokens: New York serif titles in lowercase, SF for reading, all Dynamic Type aware
DesignSystem/Tokens/DSMotion.swift:3:// Purpose: Motion tokens; every animation has a Reduce Motion variant (cross-fade only)
Audio/Services/NotificationObserverBag.swift:3:// Purpose: Owns NotificationCenter observer tokens and removes them when its owner is deallocated
Audio/Services/NotificationObserverBag.swift:9:    private var tokens: [any NSObjectProtocol] = []
Audio/Services/NotificationObserverBag.swift:14:        for token in tokens {
Audio/Services/NotificationObserverBag.swift:15:            NotificationCenter.default.removeObserver(token)
Audio/Services/NotificationObserverBag.swift:19:    func add(_ token: any NSObjectProtocol) {
Audio/Services/NotificationObserverBag.swift:20:        lock.withLock { tokens.append(token) }
~~~~

#### 2026-09-14 16:34:07 +0200 (14:34:07Z) · TOOL CALL · Bash · GIT
`4a1b6284` · `8993ccb7` · ligne 56 · Show project config, docs, tooling, git stats

~~~~bash
cd "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris" && cat project.yml; echo ---; ls Config Resources Tools Docs Docs/* Design Tests Tests/*; echo ---; find . -name '*.plist' -not -path './.git/*' | head; find . -name 'PrivacyInfo*' -o -name '*.entitlements' | grep -v .git; echo ---; which xcodegen; xcodebuild -version; xcrun simctl list devices available | grep -i iphone | head -5; echo ---; git ls-files Iris.xcodeproj; git check-ignore -v Iris.xcodeproj/project.pbxproj; git log --stat --format='%h %s' | awk '/files? changed/' | head -40; git log --shortstat --format='' | awk '{f+=$1; i+=$4; d+=$6} END {print "total files",f,"ins",i,"del",d}'
~~~~

#### 2026-09-14 16:34:11 +0200 (14:34:11Z) · TOOL RESULT · Bash · GIT
`4a1b6284` · `ea7c3d28` · ligne 63 · Show project config, docs, tooling, git stats

~~~~text
# Iris — spécification XcodeGen. CE FICHIER EST LA SOURCE DE VÉRITÉ du projet Xcode.
# `Iris.xcodeproj` est entièrement régénéré par `xcodegen generate` : tout réglage modifié
# dans Xcode (Signing & Capabilities, Build Settings) est ÉCRASÉ à la régénération suivante.
#
# Identité Apple verrouillée — NE PAS MODIFIER SANS RAISON EXPLICITE (voir README, « Apple Signing ») :
#   PRODUCT_BUNDLE_IDENTIFIER = net.steve-s.iris        (cible de tests : net.steve-s.iris.tests)
#   DEVELOPMENT_TEAM          = G4U9RG5GL7              (Stéphane SAULNIER, équipe individuelle Apple Developer)
#   CODE_SIGN_STYLE           = Automatic               (aucun profil ni certificat imposé)
# `Tools/audit.py` (contrôle C12) échoue si ces valeurs divergent entre ce fichier et le projet généré.
name: Iris
options:
  bundleIdPrefix: net.steve-s
  deploymentTarget:
    iOS: "17.0"
  xcodeVersion: "26.3"
  createIntermediateGroups: true
  generateEmptyDirectories: false
  groupSortPosition: top
  developmentLanguage: fr
attributes:
  ORGANIZATIONNAME: Stéphane SAULNIER
settings:
  base:
    SWIFT_VERSION: "6.0"
    SWIFT_STRICT_CONCURRENCY: complete
    IPHONEOS_DEPLOYMENT_TARGET: "17.0"
    TARGETED_DEVICE_FAMILY: "1,2"
    DEVELOPMENT_TEAM: G4U9RG5GL7
    CODE_SIGN_STYLE: Automatic
    CODE_SIGN_IDENTITY: Apple Development
    ENABLE_USER_SCRIPT_SANDBOXING: "YES"
    ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS: "NO"
    SWIFT_EMIT_LOC_STRINGS: "NO"
    GCC_WARN_UNUSED_VARIABLE: "YES"
    SWIFT_UPCOMING_FEATURE_EXISTENTIAL_ANY: "YES"
targets:
  Iris:
    type: application
    platform: iOS
    deploymentTarget: "17.0"
    sources:
      - path: App
      - path: Domain
      - path: GameEngine
      - path: AR
      - path: Audio
      - path: Haptics
      - path: Navigation
      - path: Features
      - path: DesignSystem
      - path: Resources
    settings:
      base:
        PRODUCT_BUNDLE_IDENTIFIER: net.steve-s.iris
        PRODUCT_NAME: Iris
        CODE_SIGN_IDENTITY: Apple Development
        INFOPLIST_FILE: Config/Info.plist
        GENERATE_INFOPLIST_FILE: "NO"
        ASSETCATALOG_COMPILER_APPICON_NAME: AppIcon
        ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME: AccentColor
        MARKETING_VERSION: "1.0"
        CURRENT_PROJECT_VERSION: "1"
        SUPPORTS_MACCATALYST: "NO"
        SUPPORTED_PLATFORMS: "iphoneos iphonesimulator"
        INFOPLIST_KEY_LSApplicationCategoryType: public.app-category.games
  IrisTests:
    type: bundle.unit-test
    platform: iOS
    deploymentTarget: "17.0"
    sources:
      - path: Tests/IrisTests
    dependencies:
      - target: Iris
    settings:
      base:
        PRODUCT_BUNDLE_IDENTIFIER: net.steve-s.iris.tests
        GENERATE_INFOPLIST_FILE: "YES"
        TEST_HOST: "$(BUILT_PRODUCTS_DIR)/Iris.app/$(BUNDLE_EXECUTABLE_FOLDER_PATH)/Iris"
        BUNDLE_LOADER: "$(TEST_HOST)"
schemes:
  Iris:
    build:
      targets:
        Iris: all
        IrisTests: [test]
    run:
      config: Debug
    test:
      config: Debug
      targets:
        - IrisTests
      gatherCoverageData: false
    profile:
      config: Release
    analyze:
      config: Debug
    archive:
      config: Release
---
Docs/architecture.md
Docs/audit-2026-09-11.md
Docs/conventions.md
Docs/dedup-log.md
Docs/design-system.md
Docs/domain-model.md
Docs/file-map.md
Docs/product.md
Docs/project-brief.md

Config:
Info.plist

Design:
ART_DIRECTION.md
BRAISES_VALIDATION_STATUS.md
CAMPAIGN_STRUCTURE.md
DIFFICULTY_MODEL.md
GAME_CORE_INVARIANTS.md
GAME_DESIGN.md
GAME_EXPANSION_CONCEPTS.md
GAME_VISION.md
GAZE_CALIBRATION_DISTANCE_HYPOTHESIS.md
IRIS_FULL_EXPANSION_REPORT.md
LEVEL_DESIGN_SYSTEM.md
OCULOMOTOR_EXPANSION_REPORT.md
OCULOMOTOR_LEVEL6_PROTOTYPE.md
PLAYER_COMFORT_CONSTRAINTS.md
PRODUCT_AUDIT.md
UX_VISION.md
X7_ANCRE_CORRECTION.md

Docs:
architecture.md
audit-2026-09-11.md
conventions.md
dedup-log.md
design-system.md
domain-model.md
Features
file-map.md
product.md
project-brief.md

Docs/Features:
Audio.md
Game.md
Gaze.md
Haptics.md
JourneyEnd.md
Onboarding.md

Resources:
Assets.xcassets

Tests:
IrisTests

Tests/IrisTests:
AR
Audio
Campaign
Domain
Fixtures
GameEngine
Haptics
Mocks
Presentation

Tools:
audit.py
MakeAppIcon.swift
---
./Config/Info.plist
---
/opt/homebrew/bin/xcodegen
Xcode 26.3
Build version 17C529
    iPhone 17 Pro (C051CA11-78BB-41FA-BBA0-9D46165D1F86) (Shutdown) 
    iPhone 17 (B04E7E00-9369-42E0-B9DA-E496BE01588D) (Booted) 
---
Iris.xcodeproj/project.pbxproj
Iris.xcodeproj/project.xcworkspace/contents.xcworkspacedata
Iris.xcodeproj/xcshareddata/xcschemes/Iris.xcscheme
 4 files changed, 85 insertions(+), 5 deletions(-)
 5 files changed, 256 insertions(+)
 18 files changed, 1259 insertions(+), 269 deletions(-)
 8 files changed, 414 insertions(+), 29 deletions(-)
 4 files changed, 112 insertions(+)
 14 files changed, 255 insertions(+), 9 deletions(-)
 12 files changed, 435 insertions(+), 3 deletions(-)
 13 files changed, 411 insertions(+), 4 deletions(-)
 12 files changed, 407 insertions(+), 4 deletions(-)
 13 files changed, 424 insertions(+), 5 deletions(-)
 5 files changed, 57 insertions(+), 3 deletions(-)
 13 files changed, 349 insertions(+), 6 deletions(-)
 15 files changed, 329 insertions(+), 9 deletions(-)
 12 files changed, 340 insertions(+), 4 deletions(-)
 12 files changed, 410 insertions(+), 4 deletions(-)
 13 files changed, 298 insertions(+), 5 deletions(-)
 14 files changed, 385 insertions(+), 4 deletions(-)
 38 files changed, 1571 insertions(+), 44 deletions(-)
 40 files changed, 1361 insertions(+), 39 deletions(-)
 4 files changed, 100 insertions(+)
 14 files changed, 315 insertions(+), 5 deletions(-)
 17 files changed, 287 insertions(+), 4 deletions(-)
 32 files changed, 672 insertions(+), 18 deletions(-)
 34 files changed, 752 insertions(+), 19 deletions(-)
 32 files changed, 859 insertions(+), 40 deletions(-)
 33 files changed, 698 insertions(+), 24 deletions(-)
 23 files changed, 1377 insertions(+), 42 deletions(-)
 4 files changed, 167 insertions(+)
 9 files changed, 128 insertions(+), 27 deletions(-)
 29 files changed, 813 insertions(+), 29 deletions(-)
 10 files changed, 1269 insertions(+), 152 deletions(-)
 26 files changed, 571 insertions(+), 43 deletions(-)
 162 files changed, 6719 insertions(+), 2138 deletions(-)
 2 files changed, 42 insertions(+), 2 deletions(-)
 204 files changed, 14953 insertions(+)
total files 900 ins 38880 del 2989
~~~~

#### 2026-09-14 16:34:26 +0200 (14:34:26Z) · TOOL CALL · Bash · TEST · arrière-plan
`4a1b6284` · `8c1dea1d` · ligne 69 · Run full test suite on iPhone 17 Pro simulator

~~~~bash
cd "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris" && S="/private/tmp/claude-501/-Volumes-Steve-Pro-BlackSSD-Dev-App-Mobile-Iris/4a1b6284-eeb2-4ff3-9176-b7e4a3a1b4bc/scratchpad" && xcodebuild test -project Iris.xcodeproj -scheme Iris -destination 'platform=iOS Simulator,name=iPhone 17 Pro' -derivedDataPath "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/.iris-derived-data/sim" -resultBundlePath "$S/tests.xcresult" > "$S/test.log" 2>&1; echo "exit=$?" >> "$S/test.log"; tail -30 "$S/test.log"
~~~~

#### 2026-09-14 16:34:27 +0200 (14:34:27Z) · TOOL RESULT · Bash · TEST
`4a1b6284` · `8a0f2afc` · ligne 70 · Run full test suite on iPhone 17 Pro simulator

~~~~text
Command running in background with ID: b96wlrsld. Output is being written to: /private/tmp/claude-501/-Volumes-Steve-Pro-BlackSSD-Dev-App-Mobile-Iris/4a1b6284-eeb2-4ff3-9176-b7e4a3a1b4bc/tasks/b96wlrsld.output. You will be notified when it completes. To check interim output, use Read on that file path.
Session cwd remains /Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris; directory changes made by the backgrounded command do not apply to subsequent commands.
~~~~

#### 2026-09-14 16:34:29 +0200 (14:34:29Z) · TOOL CALL · Bash · BUILD · arrière-plan
`4a1b6284` · `62b7fa9e` · ligne 71 · Build Release for generic iOS device

~~~~bash
cd "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris" && S="/private/tmp/claude-501/-Volumes-Steve-Pro-BlackSSD-Dev-App-Mobile-Iris/4a1b6284-eeb2-4ff3-9176-b7e4a3a1b4bc/scratchpad" && xcodebuild build -project Iris.xcodeproj -scheme Iris -configuration Release -destination 'generic/platform=iOS' -derivedDataPath "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/.iris-derived-data/release" > "$S/release.log" 2>&1; echo "exit=$?" >> "$S/release.log"; grep -E 'warning:|error:' "$S/release.log" | sort -u | head -30; tail -5 "$S/release.log"
~~~~

#### 2026-09-14 16:34:31 +0200 (14:34:31Z) · TOOL RESULT · Bash · BUILD
`4a1b6284` · `5a414187` · ligne 72 · Build Release for generic iOS device

~~~~text
Command running in background with ID: b45ltg7t3. Output is being written to: /private/tmp/claude-501/-Volumes-Steve-Pro-BlackSSD-Dev-App-Mobile-Iris/4a1b6284-eeb2-4ff3-9176-b7e4a3a1b4bc/tasks/b45ltg7t3.output. You will be notified when it completes. To check interim output, use Read on that file path.
Session cwd remains /Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris; directory changes made by the backgrounded command do not apply to subsequent commands.
~~~~

#### 2026-09-14 16:34:34 +0200 (14:34:34Z) · TOOL CALL · Bash · GIT
`4a1b6284` · `2ea52e16` · ligne 73 · Check project.yml vs pbxproj, Info.plist, audit script

~~~~bash
cd "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris" && S="/private/tmp/claude-501/-Volumes-Steve-Pro-BlackSSD-Dev-App-Mobile-Iris/4a1b6284-eeb2-4ff3-9176-b7e4a3a1b4bc/scratchpad/gen" && mkdir -p "$S" && xcodegen generate --spec project.yml --project "$S" --project-root . 2>&1 | tail -3; diff <(sed 's#[^ ]*scratchpad/gen/##g' "$S/Iris.xcodeproj/project.pbxproj") Iris.xcodeproj/project.pbxproj | head -20; echo "diffexit=$?"; git status --short; echo ---; cat Config/Info.plist; echo ---; sed -n 1,60p Tools/audit.py; grep -n '^def \|C[0-9]\+' Tools/audit.py | head -40; echo ---; git ls-files -s SwiftUI-Agent-Skill-main.zip ios-app-skills.zip attention-indirecte.html; du -sh .git; git count-objects -vH
~~~~

#### 2026-09-14 16:34:37 +0200 (14:34:37Z) · TOOL RESULT · Bash · GIT
`4a1b6284` · `8fd3cda5` · ligne 74 · Check project.yml vs pbxproj, Info.plist, audit script

~~~~text
⚙️  Generating project...
⚙️  Writing project...
Created project at /tmp/claude-501/-Volumes-Steve-Pro-BlackSSD-Dev-App-Mobile-Iris/4a1b6284-eeb2-4ff3-9176-b7e4a3a1b4bc/scratchpad/gen/Iris.xcodeproj
790,791c790
< 			name = Navigation;
< 			path = "../../../../../../Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris/Navigation";
---
> 			path = Navigation;
902,903c901
< 			name = Features;
< 			path = "../../../../../../Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris/Features";
---
> 			path = Features;
912,913c910
< 			name = Haptics;
< 			path = "../../../../../../Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris/Haptics";
---
> 			path = Haptics;
923,924c920
< 			name = DesignSystem;
< 			path = "../../../../../../Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris/DesignSystem";
---
> 			path = DesignSystem;
diffexit=0
?? SKILL.md
?? x7_silhouette_reference.png
---
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>CFBundleDevelopmentRegion</key>
	<string>fr</string>
	<key>CFBundleDisplayName</key>
	<string>Iris</string>
	<key>CFBundleExecutable</key>
	<string>$(EXECUTABLE_NAME)</string>
	<key>CFBundleIdentifier</key>
	<string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>
	<key>CFBundleInfoDictionaryVersion</key>
	<string>6.0</string>
	<key>CFBundleName</key>
	<string>$(PRODUCT_NAME)</string>
	<key>CFBundlePackageType</key>
	<string>$(PRODUCT_BUNDLE_PACKAGE_TYPE)</string>
	<key>CFBundleShortVersionString</key>
	<string>$(MARKETING_VERSION)</string>
	<key>CFBundleVersion</key>
	<string>$(CURRENT_PROJECT_VERSION)</string>
	<key>ITSAppUsesNonExemptEncryption</key>
	<false/>
	<key>LSApplicationCategoryType</key>
	<string>public.app-category.games</string>
	<key>LSRequiresIPhoneOS</key>
	<true/>
	<key>NSCameraUsageDescription</key>
	<string>Iris utilise la caméra frontale TrueDepth pour détecter la direction de votre regard : c'est ce regard qui repousse les sphères du jeu. Les images restent sur l'appareil, ne sont jamais enregistrées ni envoyées.</string>
	<key>UIApplicationSceneManifest</key>
	<dict>
		<key>UIApplicationSupportsMultipleScenes</key>
		<false/>
	</dict>
	<key>UIApplicationSupportsIndirectInputEvents</key>
	<true/>
	<key>UILaunchScreen</key>
	<dict>
		<key>UIColorName</key>
		<string>LaunchBackground</string>
	</dict>
	<key>UIRequiredDeviceCapabilities</key>
	<array>
		<string>arm64</string>
		<string>front-facing-camera</string>
	</array>
	<key>UIRequiresFullScreen</key>
	<true/>
	<key>UIStatusBarStyle</key>
	<string>UIStatusBarStyleLightContent</string>
	<key>UISupportedInterfaceOrientations</key>
	<array>
		<string>UIInterfaceOrientationPortrait</string>
	</array>
	<key>UISupportedInterfaceOrientations~ipad</key>
	<array>
		<string>UIInterfaceOrientationPortrait</string>
		<string>UIInterfaceOrientationPortraitUpsideDown</string>
	</array>
	<key>UIUserInterfaceStyle</key>
	<string>Dark</string>
</dict>
</plist>
---
#!/usr/bin/env python3
"""Layer audit for Iris (layer-auditor skill, checks C1, C2, C8, C9, C10, C12 plus dead-file and TODO scans).
C12 locks the Apple identity: project.yml (XcodeGen source of truth), the generated pbxproj and the sources must agree on the bundle identifiers and the development team.
Run from the project root: python3 Tools/audit.py [--write-file-map]
"""
import os, re, sys, subprocess

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
LAYERS = {
    "App": "App", "Domain": "Domain", "GameEngine": "GameEngine", "AR": "AR", "Audio": "Audio", "Haptics": "Haptics",
    "Navigation": "Presentation", "Features": "Presentation", "DesignSystem": "DesignSystem", "Tests": "Tests",
}
FORBIDDEN = {
    "Domain": {"SwiftUI", "UIKit", "ARKit", "AVFoundation", "AVFAudio", "Combine", "SwiftData", "CoreData", "QuartzCore"},
    "GameEngine": {"SwiftUI", "UIKit", "ARKit", "AVFoundation", "AVFAudio", "Combine", "SwiftData", "CoreData", "QuartzCore"},
    "DesignSystem": set(),
    "AR": {"SwiftUI"},
    "Audio": {"SwiftUI", "UIKit", "ARKit"},
    "Haptics": {"SwiftUI", "ARKit", "AVFoundation", "AVFAudio"},
}
TYPE_DECL = re.compile(r"^(?:@\w+(?:\([^)]*\))?\s+)*(?:public |internal |private |fileprivate )?(?:final )?(struct|class|enum|protocol|actor)\s+(\w+)", re.M)

def swift_files():
    for base in LAYERS:
        for dirpath, _, files in os.walk(os.path.join(ROOT, base)):
            for f in files:
                if f.endswith(".swift"):
                    yield os.path.relpath(os.path.join(dirpath, f), ROOT)

def layer_of(path):
    return LAYERS[path.split(os.sep)[0]]

def strip_strings_and_comments(text):
    text = re.sub(r"//.*", "", text)
    text = re.sub(r'"""[\s\S]*?"""', '""', text)
    text = re.sub(r'"(?:\\.|[^"\\])*"', '""', text)
    return text

findings = {"C1": [], "C2": [], "C8": [], "C9": [], "TODO": [], "C10": [], "C12": []}
rows = []
files = sorted(swift_files())
for path in files:
    text = open(os.path.join(ROOT, path)).read()
    layer = layer_of(path)
    imports = set(re.findall(r"^import (\w+)", text, re.M))
    for banned in FORBIDDEN.get(layer, set()):
        if banned in imports:
            findings["C1"].append(f"{path}: imports {banned}")
    if layer == "DesignSystem":
        for token in ["GameSession", "Target(", "AppCoordinator", "GameViewModel"]:
            if token in text:
                findings["C1"].append(f"{path}: references {token}")
    decls = TYPE_DECL.findall(text)
    top_level = []
    for line in text.splitlines():
        m = TYPE_DECL.match(line)
        if m and not line.startswith((" ", "\t")):
            top_level.append(m.group(2))
    name = os.path.splitext(os.path.basename(path))[0]
    primary = name.split("+")[0]
2:"""Layer audit for Iris (layer-auditor skill, checks C1, C2, C8, C9, C10, C12 plus dead-file and TODO scans).
3:C12 locks the Apple identity: project.yml (XcodeGen source of truth), the generated pbxproj and the sources must agree on the bundle identifiers and the development team.
23:def swift_files():
30:def layer_of(path):
33:def strip_strings_and_comments(text):
39:findings = {"C1": [], "C2": [], "C8": [], "C9": [], "TODO": [], "C10": [], "C12": []}
48:            findings["C1"].append(f"{path}: imports {banned}")
52:                findings["C1"].append(f"{path}: references {token}")
62:        findings["C2"].append(f"{path}: file name does not match a top-level type {top_level}")
66:            findings["C8"].append(f"{path}: raw colour or font literal")
69:            findings["C9"].append(f"{path}: try!")
71:            findings["C9"].append(f"{path}: as!")
73:            findings["C9"].append(f"{path}: fatalError")
78:            findings["C9"].append(f"{path}: force unwrap near '{snippet.strip()}'")
88:# C12: Apple identity lock (README, "Apple Signing"). project.yml is the source of truth; the pbxproj is generated from it.
97:        findings["C12"].append(f"project.yml: missing `{expected.strip()}`")
99:    findings["C12"].append("project.yml: a provisioning profile is pinned; automatic signing must stay unpinned")
105:            findings["C12"].append(f"project.pbxproj: PRODUCT_BUNDLE_IDENTIFIER = {value} (regenerate with `xcodegen generate`)")
108:            findings["C12"].append(f"project.pbxproj: DEVELOPMENT_TEAM = {value} (regenerate with `xcodegen generate`)")
111:            findings["C12"].append(f"project.pbxproj: CODE_SIGN_STYLE = {value}")
113:        findings["C12"].append("project.pbxproj: a provisioning profile is pinned")
115:    findings["C12"].append("Iris.xcodeproj/project.pbxproj is missing: run `xcodegen generate`")
118:        findings["C12"].append(f"{path}: retired bundle prefix {RETIRED_PREFIX}")
120:# C10: file map vs disk
130:    findings["C10"].append(f"not in file-map.md: {missing}")
132:    findings["C10"].append(f"in file-map.md but not on disk: {stale}")
140:    findings["C10"] = []
145:    status = "pass" if not items else ("warn" if key in ("C8", "TODO") else "fail")
---
100644 1064d0f7fb8dbe956f94c7d9a3634ffd7aa4c231 0	SwiftUI-Agent-Skill-main.zip
100644 533901743c4a13944d9fbeed9665ad287b901c9f 0	attention-indirecte.html
100644 6fdb6ca1aed5b837c563bb5c9ad64d0415d94ff3 0	ios-app-skills.zip
 12M	.git
count: 1669
size: 11.15 MiB
in-pack: 0
packs: 0
size-pack: 0 bytes
prune-packable: 0
garbage: 0
size-garbage: 0 bytes
~~~~

#### 2026-09-14 16:34:47 +0200 (14:34:47Z) · TOOL CALL · Agent
`4a1b6284` · `d32dd105` · ligne 75 · Audit gaze/AR subsystem

~~~~json
{
 "description": "Audit gaze/AR subsystem",
 "subagent_type": "general-purpose",
 "prompt": "STRICTLY READ-ONLY senior audit. Do not modify, create, format or delete any file in the repo; no git writes; no builds (another process is building). Repo: /Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris (native iOS SwiftUI game driven by gaze tracking via ARKit/TrueDepth, Swift 6 strict concurrency).\n\nAudit the gaze pipeline: AR/ (Services, Calibration, Projection), GameEngine/Gaze, Features/GazeSetup, App/Platform, App/DI/AppContainer.swift, and how gaze reaches gameplay (Features/Game/ViewModels/GameViewModel.swift, GameEngine/Session). Also read GAZE_ENGINE_V2_REPORT.md and Docs/Features/Gaze.md but VERIFY their claims against code.\n\nReport with file:line evidence, labeling each claim VÉRIFIÉ / INFÉRÉ / NON VÉRIFIABLE:\n1. Acquisition: ARFaceTrackingConfiguration use, isSupported check, faceAnchor, eye transforms vs lookAtPoint, head pose, isTracked handling, orientation/axes handling, which thread/queue delegates run on and how data crosses to MainActor (Sendable/@unchecked usage — are the @unchecked Sendable justified?).\n2. Calibration: model (affine? least squares? regularization?), fixation sequence, validation/quality gates, invalid calibration rejection, persistence of calibration, invalidation (distance, orientation change).\n3. Filtering: filter type (One-Euro? EMA? Kalman?), blink rejection, outlier handling, deltaTime handling, dropouts.\n4. Screen mapping/viewport, clamping.\n5. Lifecycle: session interruption, background/foreground, camera permission denied/restricted, no TrueDepth, tracking lost recovery; are errors explicit types, surfaced in UI, tested?\n6. Separation acquisition / mapping / gameplay: protocols, mocks, testability. Which parts are covered by Tests/IrisTests/AR and Presentation tests (name test files and what they cover), and what is NOT tested.\n7. Performance per-frame: allocations, main-thread work, per-frame logging.\n8. Privacy: are face data/frames stored or logged anywhere? Any network?\n9. Weaknesses, fragile areas, real sophistication level (be honest, neither inflate nor invent defects). No medical claims.\nKeep final report dense, ≤ 900 words."
}
~~~~

#### 2026-09-14 16:34:50 +0200 (14:34:50Z) · TOOL RESULT · Agent
`4a1b6284` · `e8d7c03d` · ligne 76 · Audit gaze/AR subsystem

~~~~text
Async agent launched successfully. (This tool result is internal metadata — never quote or paste any part of it, including the agentId below, into a user-facing reply.)
agentId: a5504523198b6ab18 (internal ID - do not mention to user. Use SendMessage with to: 'a5504523198b6ab18', summary: '<5-10 word recap>' to continue this agent.)
The agent is working in the background. You will be notified automatically when it completes. You know nothing about its results until that notification arrives — do not report, assume, or predict them; continue other work or respond to the user in the meantime.
Do not duplicate this agent's work — avoid working with the same files or topics it is using.
output_file: /private/tmp/claude-501/-Volumes-Steve-Pro-BlackSSD-Dev-App-Mobile-Iris/4a1b6284-eeb2-4ff3-9176-b7e4a3a1b4bc/tasks/a5504523198b6ab18.output
Do NOT Read or tail this file via the shell tool — it is the full subagent JSONL transcript and reading it will overflow your context. If the user asks for progress, say the agent is still running; you'll get a completion notification.
~~~~

#### 2026-09-14 16:35:03 +0200 (14:35:03Z) · TOOL CALL · Agent
`4a1b6284` · `411ded19` · ligne 77 · Audit architecture and robustness

~~~~json
{
 "description": "Audit architecture and robustness",
 "subagent_type": "general-purpose",
 "prompt": "STRICTLY READ-ONLY senior audit. Do not modify, create, format or delete any file in the repo; no git writes; no builds/tests (another process runs them). Repo: /Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris (native iOS SwiftUI game with gaze tracking, Swift 6 strict concurrency, XcodeGen). Top dirs: App (DI, Persistence, Platform), Domain (Campaign 45 files, Entities, ValueObjects, Validation, Progress, Physics...), GameEngine (Oculo, Environment, Session, Physics, Clock, Noise, Campaign, Gaze), AR, Audio, Haptics, Navigation, Features (Game 21 files incl. Rendering/ViewModels/Diagnostics, GazeSetup, Chapters, ...), DesignSystem, Tests/IrisTests. Docs/architecture.md, Docs/conventions.md exist — verify claims against code.\n\nExcluding the ARKit gaze acquisition/calibration internals (audited separately), report with file:line evidence and VÉRIFIÉ/INFÉRÉ labels:\n1. Architectural map (layers and actual import/dependency directions). Check whether Domain/GameEngine import SwiftUI/UIKit/ARKit (grep imports per directory). DI approach (AppContainer), protocols & mocks, singletons, global state.\n2. God types / excessive responsibilities: examine GameSceneRenderer.swift (644 lines), GameViewModel.swift (586), GameSession.swift (507), OculoDefinition.swift (482), AppCoordinator.swift. Function sizes (find the longest functions), logic in views, duplication across GameEngine/Oculo/*StageState.swift (similar state machines?).\n3. Game loop / rendering: how frames are driven (TimelineView? CADisplayLink? Canvas?), deltaTime clamping, per-frame allocations, SwiftUI invalidation risks, main-thread work, DEBUG diagnostics compiled out in Release (check #if DEBUG around OculomotorTrace/AncreCapture and the lone print()).\n4. Persistence (App/Persistence, UserDefaults): schema/versioning, migration, corrupted-data handling, the 14 `try?` in product code — which swallow errors meaningfully?\n5. Audio (AVAudioEngine, SineSynth) and Haptics: interruption handling, route changes, real-time render thread safety, @unchecked Sendable justification (7 occurrences in product — list them and judge).\n6. Lifecycle: scenePhase background/foreground pause, error states represented as types, recovery.\n7. Accessibility/localization: VoiceOver labels, Dynamic Type, Reduce Motion, hardcoded strings (is there a String Catalog? developmentLanguage fr), orientation locks (Config/Info.plist), iPad support (TARGETED_DEVICE_FAMILY 1,2).\n8. Tests: characterize test kinds in Tests/IrisTests (unit, simulated-player bots, golden traces, integration; any UI tests? snapshot tests?). Notable untested production areas (renderer, audio engine, AR service, persistence corruption...).\n9. Dead code (e.g., PrototypeLevelCatalog, prototype-only code, .disabled usages), and whether prototype/validation-protection mechanisms (fingerprints) are sound.\nGive strengths, weaknesses, architectural debt. Be honest, no inflation, no invented defects. Dense final report ≤ 1100 words."
}
~~~~

#### 2026-09-14 16:35:05 +0200 (14:35:05Z) · TOOL RESULT · Agent
`4a1b6284` · `56f3509a` · ligne 84 · Audit architecture and robustness

~~~~text
Async agent launched successfully. (This tool result is internal metadata — never quote or paste any part of it, including the agentId below, into a user-facing reply.)
agentId: a80c23fe5e191c27f (internal ID - do not mention to user. Use SendMessage with to: 'a80c23fe5e191c27f', summary: '<5-10 word recap>' to continue this agent.)
The agent is working in the background. You will be notified automatically when it completes. You know nothing about its results until that notification arrives — do not report, assume, or predict them; continue other work or respond to the user in the meantime.
Do not duplicate this agent's work — avoid working with the same files or topics it is using.
output_file: /private/tmp/claude-501/-Volumes-Steve-Pro-BlackSSD-Dev-App-Mobile-Iris/4a1b6284-eeb2-4ff3-9176-b7e4a3a1b4bc/tasks/a80c23fe5e191c27f.output
Do NOT Read or tail this file via the shell tool — it is the full subagent JSONL transcript and reading it will overflow your context. If the user asks for progress, say the agent is still running; you'll get a completion notification.
~~~~

### 2026-09-14 16:34:33 +0200 (14:34:33Z) · NOTIFICATION (tâche d'arrière-plan / message en file)
`4a1b6284` · `85338484` · ligne 86

~~~~text
<task-notification>
<task-id>b45ltg7t3</task-id>
<tool-use-id>toolu_011NuvaNcQtgbDKqKsH2nmBg</tool-use-id>
<output-file>/private/tmp/claude-501/-Volumes-Steve-Pro-BlackSSD-Dev-App-Mobile-Iris/4a1b6284-eeb2-4ff3-9176-b7e4a3a1b4bc/tasks/b45ltg7t3.output</output-file>
<status>completed</status>
<summary>Background command "Build Release for generic iOS device" completed (exit code 0)</summary>
</task-notification>
~~~~

#### 2026-09-14 16:35:17 +0200 (14:35:17Z) · TOOL CALL · Bash · GIT
`4a1b6284` · `d1192dc9` · ligne 89 · Check Release output, pbxproj drift, audit script, DEBUG leakage

~~~~bash
cd "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris" && S="/private/tmp/claude-501/-Volumes-Steve-Pro-BlackSSD-Dev-App-Mobile-Iris/4a1b6284-eeb2-4ff3-9176-b7e4a3a1b4bc/scratchpad"; cat "$S/../tasks/b45ltg7t3.output"; grep -c 'warning:' "$S/release.log"; grep -E 'Signing Identity|Provisioning Profile' "$S/release.log" | sort -u | head; echo ---; diff <(sed 's#[^ ]*scratchpad/gen/##g' "$S/gen/Iris.xcodeproj/project.pbxproj") Iris.xcodeproj/project.pbxproj | grep '^[<>]' | grep -v -E 'name = (Navigation|Features|Haptics|DesignSystem|App|Domain|GameEngine|AR|Audio|Resources|Tests|IrisTests|Config);|path = ' | head; echo "---audit.py (read-only mode)"; grep -n 'write\|open(.*"w' Tools/audit.py | head; python3 Tools/audit.py 2>&1 | tail -25; git status --short; echo ---; APP=$(find "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/.iris-derived-data/release" -name Iris.app -path '*Release-iphoneos*' | head -1); ls -la "$APP" | head -3; strings "$APP/Iris" | grep -iE 'OculomotorTrace|AncreCapture|iris-route|iris-oracle|iris-autoplay' | head; du -sh "$APP"
~~~~

#### 2026-09-14 16:35:21 +0200 (14:35:21Z) · TOOL RESULT · Bash · GIT
`4a1b6284` · `d3983aa8` · ligne 90 · Check Release output, pbxproj drift, audit script, DEBUG leakage

~~~~text
    builtin-validationUtility /Volumes/Steve\ Pro\ BlackSSD/Dev/App\ Mobile/.iris-derived-data/release/Build/Products/Release-iphoneos/Iris.app -shallow-bundle -infoplist-subpath Info.plist

** BUILD SUCCEEDED **

exit=0

[exited with code 0]
0
    Provisioning Profile: "iOS Team Provisioning Profile: *"
    Signing Identity:     "Apple Development: Stéphane SAULNIER (NKN63DTRM4)"
---
---audit.py (read-only mode)
4:Run from the project root: python3 Tools/audit.py [--write-file-map]
134:if "--write-file-map" in sys.argv:
135:    with open(fm_path, "w") as f:
136:        f.write("# File Map\n\nRegistry of every source file in the project. One row per file. Updated by every skill that creates or deletes a file. Search this table before creating anything.\n\n")
137:        f.write("| Path | Type | Layer | Purpose | Created by |\n|---|---|---|---|---|\n")
139:            f.write(f"| {path} | {kind} | {layer} | {purpose} | Claude (mission Iris) |\n")
[C1] pass (0)
[C2] pass (0)
[C8] pass (0)
[C9] pass (0)
[TODO] pass (0)
[C10] pass (0)
[C12] pass (0)
files: 289
?? SKILL.md
?? x7_silhouette_reference.png
---
total 10280
drwxr-xr-x   3 prodx0x  staff       96 14 sept. 11:07 _CodeSignature
drwxr-xr-x  10 prodx0x  staff      320 14 sept. 16:34 .
_TtC4Iris15OculomotorTrace
OculomotorTrace
5,0M	/Volumes/Steve Pro BlackSSD/Dev/App Mobile/.iris-derived-data/release/Build/Products/Release-iphoneos/Iris.app
~~~~

#### 2026-09-14 16:35:35 +0200 (14:35:35Z) · TOOL CALL · Bash · GIT
`4a1b6284` · `a522629f` · ligne 96 · Check debug diagnostics, README structure, push state, CI, lifecycle

~~~~bash
cd "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris" && grep -rn -B2 -A2 '#if DEBUG' Features/Game/Diagnostics/OculomotorTrace.swift | head -20; grep -rln 'OculomotorTrace' --include='*.swift' . ; grep -rn 'print(' --include='*.swift' App AR Audio Domain Features GameEngine Haptics Navigation DesignSystem; echo ---README; grep -n '^#' README.md | head -60; echo ---; for b in $(git for-each-ref --format='%(refname:short)' refs/heads); do echo "$b: $(git rev-list --left-right --count origin/$b...$b 2>/dev/null || echo 'NOT ON ORIGIN')"; done; git for-each-ref --format='%(refname:short) -> %(objectname:short)' refs/tags; git log --format='%an <%ae>' | sort | uniq -c; git log --format='%B' | grep -c 'Co-Authored-By'; echo ---; ls -a .github 2>&1; find . -name '*.xcstrings' -o -name '*.strings' -o -name 'PrivacyInfo.xcprivacy' | grep -v .git; grep -rn 'scenePhase' --include='*.swift' . | head; grep -rn 'Error\b.*enum\|enum .*Error' --include='*.swift' App AR Audio Domain Features GameEngine Haptics Navigation | head
~~~~

#### 2026-09-14 16:35:38 +0200 (14:35:38Z) · TOOL RESULT · Bash · GIT
`4a1b6284` · `851c5321` · ligne 97 · Check debug diagnostics, README structure, push state, CI, lifecycle

~~~~text
Features/Game/Diagnostics/OculomotorTrace.swift
Features/Game/ViewModels/GameViewModel.swift
Tests/IrisTests/Presentation/OculomotorTraceTests.swift
Domain/Levels/PrototypeLevelCatalog.swift:30:            targets.append(TargetBlueprint(sequence: targetIndex + 1,
GameEngine/Campaign/LevelResolver.swift:36:            TargetBlueprint(sequence: index + 1,
---README
1:# Iris
13:# Apple Signing — NE PAS MODIFIER SANS RAISON EXPLICITE
36:## 0. Refonte du produit (11 septembre 2026)
64:## 1. Projet
102:## 2. Source de référence
106:### 2.1 Correspondance HTML / JavaScript → Swift
135:### 2.2 Différences volontaires
147:## 3. Architecture
168:## 4. Regard (Gaze Engine v2)
172:### 4.1 Diagnostic de l'ancienne chaîne (v1)
180:### 4.2 Pipeline retenu
201:### 4.3 Diagnostic (`Gaze Readiness`)
205:### 4.4 Calibration
209:### 4.5 Vérification et critère
213:### 4.6 Regard prêt, persistance, recalibration
221:### 4.7 Statuts
229:## 5. Game Engine
248:## 6. Niveaux
276:## 7. Audio
288:## 8. UI / UX
309:## 9. Confidentialité
322:## 10. Tests
343:### 10.1 Résultats réels de la dernière exécution (12 septembre 2026, après la correction haptique)
364:## 10 bis. Builds
396:## 11. Validation
409:## 12. Limites honnêtes
424:## 13. Identité Apple : migration, cause et vérifications (11 septembre 2026)
428:### 13.1 Bundle
438:### 13.2 Team
447:### 13.3 Signing
461:### 13.4 Cause réelle du problème
470:### 13.5 Appareil
474:### 13.6 Identité
481:### 13.7 StoreKit readiness
487:## 14. Validation humaine — iPhone 14 Pro (12 septembre 2026)
507:## 15. Haptique (12 septembre 2026)
525:## 16. Conception de l'expansion — phase A (12 septembre 2026)
545:## 17. Prototype « Braises A » (hors campagne, DEBUG, validé humainement)
558:## 18. Baseline validée d'expansion (branche `baseline/iris-expansion-validated`, 12 septembre 2026)
577:## 19. Expansion intégrale — chapitres VII à XII (branche `feature/iris-full-expansion`, 13 septembre 2026)
592:## 20. Prototype oculomoteur — chapitre I, niveau 6 (branche `prototype/ch1-oculomotor-level6`, 14 septembre 2026)
598:## 21. Expansion oculomotrice — un niveau final par chapitre II à XII (branche `feature/iris-oculomotor-expansion`)
618:## 22. Correction de X·7 « l'ancre » (branche `prototype/x7-stabilisation-head-guidance`)
---
baseline/iris-expansion-validated: 0	0
feature/game-expansion: 0	0
feature/iris-full-expansion: 0	0
feature/iris-oculomotor-expansion: 0	0
feature/iris-v2: 0	1
fix/chapter-card-adaptive-layout: 0	0
main: 0	0
prototype/braises: 0	0
prototype/braises-b-final-diagnostic: 0	0
prototype/braises-b-rework: 0	0
prototype/braises-b-ux-audio: 0	0
prototype/ch1-oculomotor-level6: 0	0
prototype/x7-stabilisation-head-guidance: NOT ON ORIGIN
baseline-expansion-v1 -> 788da20
iris-ch1-oculomotor-human-validated-v1 -> ee2d3bd
iris-expansion-human-validated-v1 -> c6d9581
  35 ProdX0x <[REDACTED_EMAIL]>
33
---
ls: .github: No such file or directory
Features/GazeSetup/Views/GazeSetupView.swift:10:    @Environment(\.scenePhase) private var scenePhase
Features/GazeSetup/Views/GazeSetupView.swift:27:        .onChange(of: scenePhase) { _, phase in
Features/CameraAccess/CameraAccessView.swift:10:    @Environment(\.scenePhase) private var scenePhase
Features/CameraAccess/CameraAccessView.swift:33:        .onChange(of: scenePhase) { _, phase in
Navigation/RootView.swift:9:    @Environment(\.scenePhase) private var scenePhase
Navigation/RootView.swift:63:        .onChange(of: scenePhase) { _, phase in
AR/Calibration/AffineTransform2D.swift:8:enum CalibrationFitError: Error, Hashable, Sendable {
Audio/Services/AVAudioEngineAudioService.swift:141:enum AudioServiceError: Error {
~~~~

### 2026-09-14 16:35:34 +0200 (14:35:34Z) · NOTIFICATION (tâche d'arrière-plan / message en file)
`4a1b6284` · `16b0790b` · ligne 99

~~~~text
<task-notification>
<task-id>b96wlrsld</task-id>
<tool-use-id>toolu_01UPwjYfgu1qu567aoBxVkkK</tool-use-id>
<output-file>/private/tmp/claude-501/-Volumes-Steve-Pro-BlackSSD-Dev-App-Mobile-Iris/4a1b6284-eeb2-4ff3-9176-b7e4a3a1b4bc/tasks/b96wlrsld.output</output-file>
<status>completed</status>
<summary>Background command "Run full test suite on iPhone 17 Pro simulator" completed (exit code 0)</summary>
</task-notification>
~~~~

#### 2026-09-14 16:35:47 +0200 (14:35:47Z) · TOOL CALL · Bash · GIT
`4a1b6284` · `e9801a11` · ligne 108 · Extract exact test results and main branch position

~~~~bash
cd "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris" && S="/private/tmp/claude-501/-Volumes-Steve-Pro-BlackSSD-Dev-App-Mobile-Iris/4a1b6284-eeb2-4ff3-9176-b7e4a3a1b4bc/scratchpad"; tail -8 "$S/test.log"; grep -c 'warning:' "$S/test.log"; grep 'warning:' "$S/test.log" | sort -u | head; xcrun xcresulttool get test-results summary --path "$S/tests.xcresult" 2>&1 | head -40; xcrun xcresulttool get test-results tests --path "$S/tests.xcresult" 2>/dev/null | python3 -c '
import json,sys,collections
d=json.load(sys.stdin); c=collections.Counter(); args=0
def walk(n):
    global args
    t=n.get("nodeType")
    if t=="Test Case": c[n.get("result")]+=1
    if t=="Arguments": args+=1; c["arg:"+str(n.get("result"))]+=1
    for ch in n.get("children",[]): walk(ch)
for n in d["testNodes"]: walk(n)
print(c, "argument cases:",args)'; git log main -1 --format='%h %s'; git merge-base --is-ancestor main HEAD && echo main-ancestor; grep -n 'Trace\|#if DEBUG' Features/Game/ViewModels/GameViewModel.swift | head
~~~~

#### 2026-09-14 16:35:50 +0200 (14:35:50Z) · TOOL RESULT · Bash · GIT
`4a1b6284` · `83c90db9` · ligne 109 · Extract exact test results and main branch position

~~~~text
Test session results, code coverage, and logs:
	/tmp/claude-501/-Volumes-Steve-Pro-BlackSSD-Dev-App-Mobile-Iris/4a1b6284-eeb2-4ff3-9176-b7e4a3a1b4bc/scratchpad/tests.xcresult

** TEST SUCCEEDED **

Testing started
exit=0
2
2026-09-14 16:34:33.534 appintentsmetadataprocessor[10180:5234418] warning: Metadata extraction skipped. No AppIntents.framework dependency found.
2026-09-14 16:34:33.874 appintentsmetadataprocessor[10183:5234431] warning: Metadata extraction skipped. No AppIntents.framework dependency found.
{
  "devicesAndConfigurations" : [
    {
      "device" : {
        "architecture" : "arm64",
        "deviceId" : "C051CA11-78BB-41FA-BBA0-9D46165D1F86",
        "deviceName" : "iPhone 17 Pro",
        "modelName" : "iPhone 17 Pro",
        "osBuildNumber" : "23D8133",
        "osVersion" : "26.3.1",
        "platform" : "iOS Simulator"
      },
      "expectedFailures" : 0,
      "failedTests" : 0,
      "passedTests" : 406,
      "skippedTests" : 0,
      "testPlanConfiguration" : {
        "configurationId" : "1",
        "configurationName" : "Test Scheme Action"
      }
    }
  ],
  "environmentDescription" : "Iris · Built with macOS 26.3.1",
  "expectedFailures" : 0,
  "failedTests" : 0,
  "finishTime" : 1789396531.568,
  "passedTests" : 406,
  "result" : "Passed",
  "skippedTests" : 0,
  "startTime" : 1789396469.289,
  "statistics" : [

  ],
  "testFailures" : [

  ],
  "title" : "Test - Iris",
  "topInsights" : [
    {
      "category" : "Longest Test Runs",
Counter({'Passed': 406}) argument cases: 0
52f20b7 feat: complete Iris v2 refactor and Gaze Engine v2
main-ancestor
70:    #if DEBUG
72:    @ObservationIgnored private(set) var oculoTrace: OculomotorTrace?
300:                #if DEBUG
309:        #if DEBUG
310:        oculoTrace?.observeTick(session: session, events: events)
337:        #if DEBUG
365:        #if DEBUG
372:        #if DEBUG
391:        #if DEBUG
393:            oculoTrace = OculomotorTrace(names: balises.balises.map(\.name))
~~~~

#### 2026-09-14 16:36:02 +0200 (14:36:02Z) · TOOL CALL · Bash · GIT · TEST · arrière-plan
`4a1b6284` · `072e58c8` · ligne 115 · Run tests with code coverage into scratchpad

~~~~bash
cd "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris" && S="/private/tmp/claude-501/-Volumes-Steve-Pro-BlackSSD-Dev-App-Mobile-Iris/4a1b6284-eeb2-4ff3-9176-b7e4a3a1b4bc/scratchpad" && xcodebuild test -project Iris.xcodeproj -scheme Iris -destination 'platform=iOS Simulator,name=iPhone 17 Pro' -enableCodeCoverage YES -derivedDataPath "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/.iris-derived-data/sim" -resultBundlePath "$S/cov.xcresult" > "$S/cov.log" 2>&1; echo exit=$?; xcrun xccov view --report --only-targets "$S/cov.xcresult"; xcrun xccov view --report "$S/cov.xcresult" | grep -E '^\s+[A-Za-z].*\.swift' | awk '{print $(NF-1), $1}' | sort -n | head -40; git status --short
~~~~

#### 2026-09-14 16:36:06 +0200 (14:36:06Z) · TOOL RESULT · Bash · GIT · TEST
`4a1b6284` · `5588e9e4` · ligne 116 · Run tests with code coverage into scratchpad

~~~~text
Command running in background with ID: baj5icp2x. Output is being written to: /private/tmp/claude-501/-Volumes-Steve-Pro-BlackSSD-Dev-App-Mobile-Iris/4a1b6284-eeb2-4ff3-9176-b7e4a3a1b4bc/tasks/baj5icp2x.output. You will be notified when it completes. To check interim output, use Read on that file path.
Session cwd remains /Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris; directory changes made by the backgrounded command do not apply to subsequent commands.
~~~~

#### 2026-09-14 16:36:10 +0200 (14:36:10Z) · TOOL CALL · Read
`4a1b6284` · `2f9f0619` · ligne 121

~~~~json
{
 "file_path": "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris/README.md",
 "offset": 300,
 "limit": 125
}
~~~~

#### 2026-09-14 16:36:10 +0200 (14:36:10Z) · TOOL RESULT · Read
`4a1b6284` · `55ecab80` · ligne 122

~~~~text
300	  - **fin de parcours** « clairvoyance » avec niveaux, éclats et temps de jeu ;
301	  - **appareil sans suivi facial**.
302	- **Retours** : onde corail proportionnelle à la force de répulsion, lames qui se ferment, iris grisés quand le regard quitte l'écran ou qu'une veilleuse s'éteint, flamme qui vacille et anneau de charge corail sous 30 %, voie en pointillés après 45 s ; au toucher, une impulsion par validation, par perte et à la fin du niveau (§ 15).
303	- **Rendu** : un fond statique et un seul `Canvas` alimenté par un snapshot immuable par frame ; halos en dégradés radiaux additifs, sans filtre de flou ; HUD et overlays observent des propriétés grossières.
304	- **Accessibilité** : Dynamic Type, cibles ≥ 44 pt, libellés VoiceOver (chapitres, nœuds, éclats, HUD), consignes publiées comme annonces d'accessibilité, rang jamais porté par la seule couleur, Reduce Motion (pas de respiration, filaments figés, pas de scintillement ni d'onde animée), texte tertiaire ≥ 4,5:1.
305	- **Captures simulateur** (iPhone 17) réalisées après implémentation : seuil (premier lancement et reprise), chapitres, carnet, intro 3-1, jeu 4-6, 5-6 et 6-5, résultat 1-2, fin de parcours, calibration. Deux défauts visuels relevés ainsi ont été corrigés : les lames se reliaient en anneau continu, et la carte d'intro masquait le niveau.
306	
307	---
308	
309	## 9. Confidentialité
310	
311	- Caméra frontale utilisée uniquement via `ARFaceTrackingConfiguration` pour estimer `lookAtPoint` en temps réel. Message `NSCameraUsageDescription` (`Config/Info.plist`) en français, compréhensible.
312	- Aucune image, aucune vidéo, aucune géométrie ni représentation du visage n'est conservée : les `ARFrame` sont lus puis relâchés dans le callback ; l'échantillon brut (impact sur le plan, position des yeux, clignements) vit le temps d'une frame et n'est jamais persisté ; les échantillons de calibration sont agrégés puis oubliés.
313	- Aucun compte, serveur, cloud, analytics. Stockage local dans `UserDefaults`, limité à :
314	  - quatre préférences : points de regard, effets sonores, ambiance sonore, vibrations ;
315	  - le profil de calibration : 6 coefficients, mapping d'axes, orientation, viewport, repère nominal, date, erreurs de vérification, validité ;
316	  - la progression : pour chaque niveau, nombre de réussites, meilleur temps, moins d'intrusions et éclats ; plus le temps de jeu total et les éléments rencontrés.
317	
318	  Aucune donnée de regard ni de visage n'est stockée. La progression peut être effacée depuis les réglages.
319	
320	---
321	
322	## 10. Tests
323	
324	Suite Swift Testing (`Tests/IrisTests`, 37 fichiers) exécutée sur simulateur iPhone 17 Pro (iOS 26.3.1) via `xcodebuild test`.
325	
326	| Domaine | Fichiers | Ce qui est couvert |
327	|---|---|---|
328	| Physique | `TargetPhysicsTests` | attraction, répulsion, proportionnalité, frontière de zone, bruit uniquement hors zone, plafond 2,2, friction 0,94, équivalence temporelle (demi-pas), rebonds amortis, quatre bords, stabilité pour f ∈ {0,05 … 3}, facteurs de pas fractionnaire |
329	| Validation | `ValidationRuleTests` | entrée dans la zone, refus à 44 frames, validation à 45, validation temporelle à 30 et 120 Hz, sortie avant validation, rayon strict 16 pt, maintien à 35 pt, perte à 37 pt, progression des événements |
330	| Ordre | `SequenceOrderTests` | 1 immédiatement, 2 pas avant 1, 3 pas avant 1 et 2, arrivée physique hors tour, validation 1 → 2 → 3, `TurnRule` |
331	| Cascade | `CascadeRuleTests` | perte de 3 seule ; perte de 2 → 2 et 3 ; perte de 1 → 1, 2, 3 (règle et session, avec événements), retour à l'ordre, absence de cascade en niveau simple |
332	| Prototype | `PrototypeLevelCatalogTests` | 14 niveaux historiques, comptes 1/2/3, bandes exactes, hold 0,75 s, marges, géométrie exacte niveaux 1 et 9 |
333	| Campagne | `CampaignStructureTests`, `CampaignSimulationTests`, `LevelLabTests` | structure 5/5/6/6/6/6, introductions, combinaisons, géométrie, résolution sur 3 tailles d'écran ; faisabilité (robot guidé, 3 graines), nécessité (évitement, sans veilleuse, hors écran), références, 13 critères de différence, maîtrise ; table de mesures |
334	| Environnement | `LevelEnvironmentTests` | échelle du résolveur, R-23 regard hors écran et tolérance, courant bloquant puis traversé en poussant, voile bloquant et réponse de collision, cycle et arithmétique de veilleuse, iris mouvant, intrusions, prototype non affecté |
335	| Progression et consignes | `CampaignProgressTests`, `ProgressStoreTests`, `HintTrackerTests`, `LaunchOptionsTests` | éclats, records, déblocage et prochain niveau, éléments rencontrés ; stockage UserDefaults et mémoire ; consignes par déclencheur, disparition après 4,5 s, aide générique ; options de lancement et progression amorcée |
336	| Fidélité | `GameSessionGoldenTests` | deux traces frame par frame générées par le moteur JavaScript extrait (`Fixtures/golden_generator.js`) : niveau 1 (393 frames, répulsion, rebonds, attraction, validation) et niveau 9 (241 frames, validations 1, 2, 3 aux frames 151, 196, 241), tolérance 1e-6 |
337	| Session | `GameSessionTests`, `GazeFilterTests`, `ValueNoise1DTests`, `LinearCongruentialGeneratorTests` | chargement, complétion, bornage 0,1 s, 30 Hz = 2 × 60 Hz exact, 120 Hz, deltas nuls, lissage, sauts, bruit, LCG |
338	| Haptique | `HapticCuePolicyTests`, `GameSettingsStoreTests` | validation, perte quelle que soit la cause, cascade = une impulsion, une impulsion par tick (perte avant validation), garde partagée avec l'audio et non empilement, fin de niveau jamais filtrée, préparation une fois par maintien, événements muets, remise à zéro ; préférences par défaut et persistance |
339	| Audio | `AudioCuePolicyTests`, `SineSynthTests` | cascade → un seul son, garde 150 ms, arpège de fin qui remplace le carillon, veilleuse (perte, battement limité), hauteurs 560 / 305 Hz, gains, extinction, carillon, balayage descendant, arpège, battement, nappe (fondu entrant et sortant) |
340	| Regard v2 | `AxisMappingTests`, `AffineTransform2DTests`, `RobustAggregatorTests`, `FixationSequenceTests`, `NormalizedCoordinatesTests`, `CalibrationProfileTests`, `GazeMapperTests`, `GazeReadinessEvaluatorTests`, `GazeSetupViewModelTests` | repère standard, retourné 180°, miroir, pivoté 90°, gravité / repli, dégénérescences, votes ; identité, offsets, échelles, combinaison, miroir corrigé, bruit, refus (< 3 points, non fini, colinéaire) ; médiane / MAD ; stabilisation, collecte, clignements, reprise puis échec, prolongation ; conversions et grilles ; sauvegarde / chargement (mémoire et UserDefaults), compatibilité (version, validité, orientation, viewport, âge) ; rayon / plan des deux côtés, mapping appliqué avant le nominal, calibration appliquée une fois, bornage, détecteur de clignements ; readiness (prêt, en attente, bloqué, yeux, direction, stabilité, blend shapes) ; parcours complet avec biais appris, regard miroir corrigé, verdict insuffisant / continuer quand même, recalibration, revalidation, signal insuffisant, matériel / caméra, clignements ignorés, cycle de vie, propriété du tracker partagé |
341	| Présentation | `GameViewModelTests`, `AppCoordinatorTests`, `CameraAccessViewModelTests` | intro, nappe du chapitre, son désactivé, haptique activée (préparation puis impulsion de fin avec l'arpège) et désactivée (rien, prise en compte au tick suivant), consignes jouées, résultat et éclats nouveaux, niveau suivant, fin de chapitre et de campagne, rejouer, recommencer, chapitres, voie après 45 s, curseur, profil appliqué, visage perdu, interruptions et erreurs, arrière-plan, recalibration, autoplay, propriété du tracker partagé ; seuil, appareil incompatible, premier lancement, revalidation, caméra, annulation, niveaux verrouillés et progression, carnet, parcours depuis les chapitres, réglages et recalibration, finale, réinitialisation, options de lancement ; permission |
342	
343	### 10.1 Résultats réels de la dernière exécution (12 septembre 2026, après la correction haptique)
344	
345	Commande :
346	
347	```
348	xcodebuild -project Iris.xcodeproj -scheme Iris \
349	  -destination 'platform=iOS Simulator,name=iPhone 17 Pro' -configuration Debug test
350	```
351	
352	Résultat : `Test run with 232 tests in 35 suites passed after 6.320 seconds` puis `** TEST SUCCEEDED **`. Le bundle de tests construit porte l'identifiant `net.steve-s.iris.tests`, l'hôte `net.steve-s.iris`.
353	
354	| Exécutés | Réussis | Échoués | Ignorés |
355	|---|---|---|---|
356	| 232 | 232 | 0 | 0 |
357	
358	**232/232 PASS** (220 tests de la refonte, 12 tests haptiques et de préférences ajoutés). Aucun test n'est désactivé. Au premier passage, un nouveau test de garde haptique échouait parce qu'il plaçait la seconde perte exactement à la frontière de 150 ms, où l'arithmétique flottante donne 0,1499… : le test place désormais ses pertes nettement en deçà et au-delà de la garde ; la politique n'a pas changé. Les traces golden du moteur JavaScript restent vertes : le noyau historique n'a pas changé.
359	
360	Deux tests de présentation ont été réécrits parce que leur objet a disparu : le parcours à 14 niveaux (`GameProgression`) et le tutoriel. Deux tests audio ont été adaptés : la dernière validation joue désormais l'arpège de fin au lieu du carillon. Au premier passage de la suite complète, un test échouait : il supposait qu'une caméra encore refusée menait au setup du regard. Le code est correct, car le coordinateur revérifie l'autorisation réelle. Le test a été corrigé et couvre maintenant les deux cas.
361	
362	---
363	
364	## 10 bis. Builds
365	
366	Toutes les commandes ont été réellement exécutées depuis la racine du projet, sur macOS 26.3 (Darwin 25.3.0), Xcode 26.3 (17C529), SDK iOS 26.2, simulateur iPhone 17 Pro (iOS 26.3.1), le 12 septembre 2026 après la correction haptique (§ 15) ; les résultats du 11 septembre (identité Apple, § 13) étaient identiques hors nombre de tests. Les builds appareil sont désormais **signés** (signature automatique, équipe `G4U9RG5GL7`), plus `CODE_SIGNING_ALLOWED=NO`.
367	
368	| # | Commande | Résultat réel |
369	|---|---|---|
370	| 1 | `xcodebuild -project Iris.xcodeproj -scheme Iris -destination 'platform=iOS Simulator,name=iPhone 17 Pro' -configuration Debug build` | `** BUILD SUCCEEDED **`, 0 erreur, 0 warning issu de notre code |
371	| 2 | `xcodebuild -project Iris.xcodeproj -scheme Iris -destination 'platform=iOS Simulator,name=iPhone 17 Pro' -configuration Debug test` | `** TEST SUCCEEDED **`, 232 tests, 232 réussis, 0 échec, 0 ignoré |
372	| 3 | `xcodebuild -project Iris.xcodeproj -scheme Iris -destination 'platform=iOS Simulator,name=iPhone 17 Pro' -configuration Release build` | `** BUILD SUCCEEDED **`, 0 erreur, 0 warning |
373	| 4 | `xcodebuild -project Iris.xcodeproj -scheme Iris -destination 'generic/platform=iOS' -configuration Debug build` (signé) | `** BUILD SUCCEEDED **` ; `codesign` : `Identifier=net.steve-s.iris`, `TeamIdentifier=G4U9RG5GL7`, identité « Apple Development », profil « iOS Team Provisioning Profile: * » choisi automatiquement (rien d'épinglé), entitlements `application-identifier`, `com.apple.developer.team-identifier`, `get-task-allow` |
374	| 5 | `xcodebuild -project Iris.xcodeproj -scheme Iris -destination 'generic/platform=iOS' -configuration Release build` (signé) | `** BUILD SUCCEEDED **` ; `Identifier=net.steve-s.iris`, `TeamIdentifier=G4U9RG5GL7` |
375	| 6 | `xcodebuild -project Iris.xcodeproj -scheme Iris -destination 'generic/platform=iOS' -configuration Debug build-for-testing` (signé) | `** TEST BUILD SUCCEEDED **` ; `IrisTests.xctest` signé `net.steve-s.iris.tests`, équipe `G4U9RG5GL7` (11 septembre, non relancé le 12) |
376	| 7 | `xcrun devicectl device install app --device <iPhone 14 Pro> Iris.app` puis `xcrun devicectl device process launch --device <iPhone 14 Pro> net.steve-s.iris` | `App installed: bundleID: net.steve-s.iris` ; `Launched application` (build haptique du 12 septembre installé par-dessus la précédente) |
377	| 8 | `python3 Tools/audit.py` | C1, C2, C8, C9, C10, C12 et scan TODO : pass, 200 fichiers |
378	
379	Diagnostics restants :
380	
381	- `appintentsmetadataprocessor[...] warning: Metadata extraction skipped. No AppIntents.framework dependency found.` : notice de l'outillage Xcode émise pour toute app sans App Intents ; aucun défaut du projet, non masquée.
382	- Aucun warning du compilateur Swift (mode Swift 6, concurrence stricte complète, `ExistentialAny` activé) ni de l'éditeur de liens.
383	
384	Appareil physique : `xcrun devicectl list devices` montre l'iPhone 14 Pro « iPhone Steve. » (iOS 26.5.2, mode développeur activé, jumelé, connecté) ; son UDID figure dans le profil de développement automatique de l'équipe. Statuts réels :
385	
386	- `[build appareil réussi]` : Debug et Release signés pour arm64 (lignes 4 à 6).
387	- `[installation appareil réussie]` : le build Debug du 11 septembre, puis celui du 12 (haptique), ont été installés par `devicectl` (mise à jour de l'installation `net.steve-s.iris`, données conservées) et lancés. Aucune interaction n'a eu lieu sur l'écran lors de ces lancements automatisés.
388	- Validation humaine du regard : faite le 12 septembre (§ 14). `[sensation physique nécessite validation humaine]` pour les impulsions haptiques (§ 15).
389	
390	L'iPhone conserve aussi une installation `com.prodx0x.iris` faite depuis Xcode avant la migration ; rien ne la met plus à jour, elle peut être supprimée à la main.
391	
392	Vérifications sur simulateur (iPhone 17, options DEBUG `--iris-route`, `--iris-level`, `--iris-progress`, `--iris-autoplay`, `--iris-gaze`, `--iris-oracle-gaze`) : captures des écrans listés au § 8, aucun rapport de plantage produit. Le regard y est simulé : ces captures valident le rendu et la navigation, pas la jouabilité au regard.
393	
394	---
395	
396	## 11. Validation
397	
398	| Élément | Statut |
399	|---|---|
400	| Noyau historique (générateur prototype, bruit, physique, validation, ordre, cascade, filtre de regard), règles de campagne R-23 à R-30, faisabilité et nécessité de chaque niveau par simulation, références d'éclats, progression et stockage, consignes, politique et synthèse audio, Gaze Engine v2 (rayon, axes, affine, agrégation, fixation, critères, profil, readiness), machines d'états du jeu, du setup et du coordinateur, permission | `[vérifié automatiquement]` |
401	| Intégration ARKit (`ARSession`, délégué, interruptions), `AVAudioEngine` sur appareil, `CADisplayLink`, rendu Canvas de la chambre noire, écrans SwiftUI (seuil, chapitres, carnet, réglages, intro, résultat, fin de parcours), vibration de réussite, Info.plist / permission caméra | `[vérifié par compilation]` (Debug et Release simulateur, Debug et Release appareil arm64 signés) ; écrans et rendu également observés sur simulateur avec un regard simulé ; lancement sur iPhone 14 Pro sans plantage à 8 s |
402	| Identité Apple : Bundle ID `net.steve-s.iris`, équipe `G4U9RG5GL7`, signature automatique, cohérence `project.yml` / projet généré / sources | `[vérifié automatiquement]` (audit C12) et `[build appareil réussi]` (signature réelle, profil automatique) |
403	| Direction du regard, calibration et jouabilité de base sur iPhone 14 Pro | validés par un humain le 12 septembre 2026 (§ 14) |
404	| Logique haptique (événements, cascade, garde, réglage) | `[logique haptique vérifiée automatiquement]` |
405	| Sensation des impulsions, jouabilité fine des niveaux de poussée (III, IV, VI) et de vigilance (V), pertinence des références d'éclats, durée et courbe de difficulté ressenties, lisibilité en lumière réelle, sons sur appareil | `[sensation physique nécessite validation humaine]` / `[nécessite validation sur iPhone TrueDepth]` |
406	
407	---
408	
409	## 12. Limites honnêtes
410	
411	- Le suivi du regard a été validé par un humain sur iPhone 14 Pro le 12 septembre 2026 (§ 14) : calibration fonctionnelle, gameplay fluide. Deux contraintes observées, non « réparées » : sensibilité aux micro-mouvements du téléphone tenu en main, et point de diagnostic qui sort de l'écran aux extrêmes. Le confort sur une longue session et le ressenti des vibrations restent à mesurer.
412	- Les conventions d'axes du repère caméra ARKit pour la caméra frontale ne sont pas documentées de façon exploitable ; le Gaze Engine v2 ne les présume plus (résolution par les yeux et la gravité), mais la première confirmation viendra du diagnostic sur appareil (ligne « Orientation du regard » et logs `gaze`).
413	- Le simulateur n'a pas de TrueDepth : la build simulateur remplace le regard par le doigt (glisser sur l'écran) ou, avec `--iris-oracle-gaze`, par un regard scripté qui fixe chaque cible ; le HUD l'indique (« mode : simulateur (toucher) »). Ces modes n'existent pas sur appareil.
414	- L'échelle physique de l'écran et la position de la caméra sont des estimations par famille d'appareil (erreur attendue de quelques pour cent). Les iPad dont la caméra est sur le bord long (iPad Pro M4, iPad 10) sont approximés avec une caméra en haut.
415	- La suite de tests s'exécute avec l'app comme hôte sur simulateur ; elle ne dépend d'aucun matériel.
416	- Les gains sonores absolus ont été validés hors ligne, pas à l'oreille sur appareil.
417	- Le robot de campagne est plus précis et plus rapide qu'un humain. Il prouve qu'un niveau est faisable et qu'un élément est nécessaire, pas qu'il est agréable. La courbe de difficulté ressentie, la frustration et la durée réelle d'un parcours (estimée entre 1 h 30 et 2 h 30) restent à mesurer avec des joueurs.
418	- Deux retours conçus ne sont pas implémentés : le trait corail qui relie une perte en cascade à sa cause et l'assombrissement avant le résultat (`Design/GAME_DESIGN.md` § 11). La vibration par validation l'est depuis le 12 septembre 2026 (§ 15).
419	- La carte d'intro, même translucide, recouvre le bas de l'écran. Sur les niveaux dont la lueur part en bas, le joueur la découvre pleinement en touchant *Commencer*, avant tout mouvement.
420	- Les niveaux sont réglés et vérifiés sur un écran de 393 × 852 pt. Ils se résolvent sur toutes les tailles testées (375 × 812, 430 × 932, 834 × 1194), mais la simulation de faisabilité n'est exécutée que sur l'écran de référence ; l'iPad, au rapport d'aspect différent, n'est pas vérifié par simulation.
421	
422	---
423	
424	## 13. Identité Apple : migration, cause et vérifications (11 septembre 2026)
~~~~

### 2026-09-14 16:36:16 +0200 (14:36:16Z) · CLAUDE
`4a1b6284` · `8cbd0b0a` · ligne 132

~~~~markdown
Encore trois tâches en cours : la mesure de couverture et les deux revues de code (Gaze/AR, architecture). Tout le reste est vérifié :

- **Tests :** 406 sur 406 réussis.
- **Build Release :** signé, sans erreur.
- **Git :** état relevé.
- **project.yml :** cohérent avec le projet Xcode.
- **Script d'audit :** tous les contrôles passent.

Aucun fichier du dépôt n'a été modifié : `git status` montre toujours les deux mêmes fichiers non suivis. Je rédige le rapport complet dès que ces trois résultats arrivent.
~~~~

### 2026-09-14 16:37:28 +0200 (14:37:28Z) · USER
`4a1b6284` · `ff655a37` · ligne 136

~~~~markdown
<task-notification>
<task-id>a5504523198b6ab18</task-id>
<tool-use-id>toolu_01V8ADQZChpDJVSvKbZGLtaL</tool-use-id>
<output-file>/private/tmp/claude-501/-Volumes-Steve-Pro-BlackSSD-Dev-App-Mobile-Iris/4a1b6284-eeb2-4ff3-9176-b7e4a3a1b4bc/tasks/a5504523198b6ab18.output</output-file>
<status>completed</status>
<summary>Agent "Audit gaze/AR subsystem" finished</summary>
<note>A task-notification fires each time this agent stops with no live background children of its own. The user can send it another message and resume it, so the same task-id may notify more than once.</note>
<result>I audited the gaze pipeline without changing anything in the repo; here is what I found. **V** = VÉRIFIÉ (checked in code), **I** = INFÉRÉ (inferred), **NV** = NON VÉRIFIABLE (cannot be checked from code).

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

Signal processing is basic: a fixed-α EMA with no timing, no gameplay blink rejection, an unregularized affine fit, no correction for head or distance drift after calibration, and a quality gate that only re-measures trained points. The fragile areas are the stale cursor when no ray hits, the viewport update bug, and ARKit axis handling that only a device can confirm.</result>
<usage><subagent_tokens>115529</subagent_tokens><tool_uses>33</tool_uses><duration_ms>155650</duration_ms></usage>
</task-notification>
~~~~

### 2026-09-14 16:37:30 +0200 (14:37:30Z) · CLAUDE
`4a1b6284` · `13978bf6` · ligne 137

~~~~markdown
L'audit Gaze/AR est terminé. J'attends encore l'audit architecture et la mesure de couverture avant de rédiger le rapport.
~~~~

### 2026-09-14 16:37:37 +0200 (14:37:37Z) · USER
`4a1b6284` · `e463ea4d` · ligne 141

~~~~markdown
<task-notification>
<task-id>baj5icp2x</task-id>
<tool-use-id>toolu_01C3N3ZxGuLnWpg71M9Joppp</tool-use-id>
<output-file>/private/tmp/claude-501/-Volumes-Steve-Pro-BlackSSD-Dev-App-Mobile-Iris/4a1b6284-eeb2-4ff3-9176-b7e4a3a1b4bc/tasks/baj5icp2x.output</output-file>
<status>completed</status>
<summary>Background command "Run tests with code coverage into scratchpad" completed (exit code 0)</summary>
</task-notification>
~~~~

#### 2026-09-14 16:37:40 +0200 (14:37:40Z) · TOOL CALL · Read
`4a1b6284` · `d6fd99a3` · ligne 142

~~~~json
{
 "file_path": "/private/tmp/claude-501/-Volumes-Steve-Pro-BlackSSD-Dev-App-Mobile-Iris/4a1b6284-eeb2-4ff3-9176-b7e4a3a1b4bc/tasks/baj5icp2x.output"
}
~~~~

#### 2026-09-14 16:37:40 +0200 (14:37:40Z) · TOOL RESULT · Read
`4a1b6284` · `fbb624e9` · ligne 143

~~~~text
1	exit=0
2	ID Name             # Source Files Coverage            
3	-- ---------------- -------------- ------------------- 
4	0  Iris.app         176            62.07% (7344/11832) 
5	1  IrisTests.xctest 70             97.15% (7129/7338)  
6	
7	?? SKILL.md
8	?? x7_silhouette_reference.png
9	
10	[exited with code 0]
11	
~~~~

#### 2026-09-14 16:37:48 +0200 (14:37:48Z) · TOOL CALL · Bash
`4a1b6284` · `77ee99b6` · ligne 154 · Break down code coverage by subsystem

~~~~bash
S="/private/tmp/claude-501/-Volumes-Steve-Pro-BlackSSD-Dev-App-Mobile-Iris/4a1b6284-eeb2-4ff3-9176-b7e4a3a1b4bc/scratchpad"; xcrun xccov view --report --json "$S/cov.xcresult" | python3 -c '
import json,sys,collections
d=json.load(sys.stdin)
t=[x for x in d["targets"] if x["name"]=="Iris.app"][0]
agg=collections.defaultdict(lambda:[0,0]); low=[]
for f in t["files"]:
    p=f["path"].split("/Iris/",1)[-1]; k="/".join(p.split("/")[:2])
    agg[k][0]+=f["coveredLines"]; agg[k][1]+=f["executableLines"]
    if f["executableLines"]>=40: low.append((f["lineCoverage"],f["executableLines"],p))
for k,(c,e) in sorted(agg.items(),key=lambda x:-x[1][1]): print(f"{k:40}{c:>6}/{e:<6}{100*c/max(e,1):6.1f}%")
print("--- lowest (>=40 exec lines)")
for c,e,p in sorted(low)[:18]: print(f"{100*c:5.1f}% {e:5} {p}")'
~~~~

#### 2026-09-14 16:37:52 +0200 (14:37:52Z) · TOOL RESULT · Bash
`4a1b6284` · `99125970` · ligne 155 · Break down code coverage by subsystem

~~~~text
Features/Game                             1568/3226    48.6%
GameEngine/Oculo                          1231/1280    96.2%
DesignSystem/Components                    278/1038    26.8%
Features/GazeSetup                         284/913     31.1%
AR/Calibration                             640/666     96.1%
Domain/Campaign                            423/468     90.4%
GameEngine/Session                         436/448     97.3%
Features/Chapters                          264/391     67.5%
AR/Services                                131/359     36.5%
GameEngine/Environment                     339/348     97.4%
GameEngine/Campaign                        249/251     99.2%
Audio/Synth                                234/243     96.3%
Navigation/AppCoordinator.swift            186/217     85.7%
Features/Settings                            0/190      0.0%
Features/Home                              173/181     95.6%
Audio/Services                               3/161      1.9%
Features/CameraAccess                       30/144     20.8%
Navigation/RootView.swift                   90/122     73.8%
App/Platform                                77/118     65.3%
Features/JourneyComplete                     0/117      0.0%
App/DI                                      94/99      94.9%
Features/Carnet                              0/95       0.0%
Domain/Progress                             73/89      82.0%
GameEngine/Physics                          73/73     100.0%
Domain/Entities                             60/62      96.8%
Domain/Validation                           57/57     100.0%
Features/Unavailable                         0/53       0.0%
Haptics/Policy                              53/53     100.0%
Audio/Policy                                50/50     100.0%
Features/Shared                             11/43      25.6%
Domain/Levels                               42/42     100.0%
Domain/ValueObjects                         39/39     100.0%
App/Persistence                             34/34     100.0%
GameEngine/Gaze                             26/26     100.0%
DesignSystem/Modifiers                       0/18       0.0%
GameEngine/Noise                            17/17     100.0%
GameEngine/Clock                            17/17     100.0%
Haptics/Services                             0/16       0.0%
Navigation/HomeSummary.swift                13/13     100.0%
DesignSystem/Tokens                          8/12      66.7%
AR/Projection                               11/11     100.0%
App/IrisApp.swift                            9/9      100.0%
Domain/Physics                               8/9       88.9%
Domain/Random                                7/7      100.0%
Navigation/AppRoute.swift                    6/6      100.0%
Navigation/AppSheet.swift                    0/1        0.0%
--- lowest (>=40 exec lines)
  0.0%    40 DesignSystem/Components/DSProgressRing.swift
  0.0%    44 DesignSystem/Components/DSScreen.swift
  0.0%    53 Features/Unavailable/UnavailableView.swift
  0.0%    54 Features/Game/Views/GameView.swift
  0.0%    82 DesignSystem/Components/DSStatusRow.swift
  0.0%    95 Features/Carnet/CarnetView.swift
  0.0%   106 Features/GazeSetup/Views/FixationTargetView.swift
  0.0%   112 Features/CameraAccess/CameraAccessView.swift
  0.0%   117 Features/JourneyComplete/JourneyCompleteView.swift
  0.0%   124 Features/Chapters/ChaptersView.swift
  0.0%   133 DesignSystem/Components/DSOverlayPanel.swift
  0.0%   143 Audio/Services/AVAudioEngineAudioService.swift
  0.0%   146 Features/Game/Views/GameOverlayView.swift
  0.0%   151 Features/GazeSetup/Views/GazeVerdictView.swift
  0.0%   152 Features/Game/Views/GameHUDView.swift
  0.0%   152 Features/GazeSetup/Views/GazeReadinessView.swift
  0.0%   155 AR/Services/ARKitGazeTrackingService.swift
  0.0%   161 Features/GazeSetup/Views/GazeSetupView.swift
~~~~

### 2026-09-14 16:37:56 +0200 (14:37:56Z) · CLAUDE
`4a1b6284` · `1c21ea6c` · ligne 159

~~~~markdown
Couverture mesurée : 62,07 % du code de l'app. Moteur, domaine et calibration sont au-dessus de 90 %, mais les vues SwiftUI, le service ARKit et le service audio ne sont pas couverts du tout. J'attends encore la revue architecture et fiabilité ; je rédige le rapport complet dès qu'elle arrive.
~~~~

### 2026-09-14 16:38:38 +0200 (14:38:38Z) · USER · DECISION
`4a1b6284` · `2026308b` · ligne 163

~~~~markdown
<task-notification>
<task-id>a80c23fe5e191c27f</task-id>
<tool-use-id>toolu_01DwUXqek8vQEqpSghHUeRre</tool-use-id>
<output-file>/private/tmp/claude-501/-Volumes-Steve-Pro-BlackSSD-Dev-App-Mobile-Iris/4a1b6284-eeb2-4ff3-9176-b7e4a3a1b4bc/tasks/a80c23fe5e191c27f.output</output-file>
<status>completed</status>
<summary>Agent "Audit architecture and robustness" finished</summary>
<note>A task-notification fires each time this agent stops with no live background children of its own. The user can send it another message and resume it, so the same task-id may notify more than once.</note>
<result># Iris senior audit (read-only; the ARKit gaze internals are excluded)

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
- **Enum risk:** `encounteredElements: Set&lt;GameElement&gt;` is a String raw-value enum. Renaming or removing a case would make the whole decode throw and wipe all progress (INFÉRÉ from Codable behaviour). Encode failure is also dropped silently (line 25).
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
  - Per-tick snapshot allocations.</result>
<usage><subagent_tokens>114083</subagent_tokens><tool_uses>25</tool_uses><duration_ms>209590</duration_ms></usage>
</task-notification>
~~~~

### 2026-09-14 16:38:42 +0200 (14:38:42Z) · CLAUDE
`4a1b6284` · `9b404f06` · ligne 171

~~~~markdown
Deux revues reçues. Avant de noter, je vérifie moi-même les deux constats les plus lourds (reset silencieux de la progression, bug de viewport).
~~~~

#### 2026-09-14 16:38:45 +0200 (14:38:45Z) · TOOL CALL · Bash
`4a1b6284` · `e1c62e02` · ligne 172 · Verify persistence and viewport findings

~~~~bash
cd "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris" && sed -n 10,30p App/Persistence/UserDefaultsProgressStore.swift; echo ---; sed -n 110,125p Features/Game/ViewModels/GameViewModel.swift; echo ---; sed -n 290,306p Features/Game/ViewModels/GameViewModel.swift; grep -n 'UIRequired\|front-facing' Config/Info.plist; grep -rn 'blinkDetector' AR/Calibration/GazeReadinessEvaluator.swift | head -3
~~~~

#### 2026-09-14 16:38:45 +0200 (14:38:45Z) · TOOL RESULT · Bash
`4a1b6284` · `6970c3c2` · ligne 173 · Verify persistence and viewport findings

~~~~text
    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func load() -> CampaignProgress {
        guard let data = defaults.data(forKey: Self.key),
              let progress = try? JSONDecoder().decode(CampaignProgress.self, from: data),
              progress.version == CampaignProgress.currentVersion else {
            return CampaignProgress()
        }
        return progress
    }

    func save(_ progress: CampaignProgress) {
        guard let data = try? JSONEncoder().encode(progress) else { return }
        defaults.set(data, forKey: Self.key)
    }

    func reset() {
        defaults.removeObject(forKey: Self.key)
---
    }

    // MARK: Lifecycle

    /// Called by the view once its size is known. Builds the gaze mapper, loads the level, starts tracking and audio.
    func prepare(width: Double, height: Double, displayScale: Double) {
        let newBounds = PlayfieldBounds(width: width, height: height)
        let geometry = NominalDisplayGeometry.estimate(viewport: newBounds, displayScale: displayScale, isPad: isPad)
        if isPrepared {
            gaze.updateViewport(GazeViewport(bounds: bounds, nominal: geometry))
            return
        }
        isPrepared = true
        bounds = newBounds
        nominal = geometry
        reloadCalibration()
---
        refreshSnapshot()
    }

    private func tick(_ deltaTime: TimeInterval) {
        guard phase == .playing else { return }
        if case .tracking(false) = gazeState {
            faceLostDuration += deltaTime
            if faceLostDuration >= Self.faceLostTimeout {
                haltLoop()
                phase = .faceLost
                #if DEBUG
                ancreCapture?.mark("faceLostWarning", session: session, phase: phase)
                #endif
                return
            }
        } else {
            faceLostDuration = 0
43:	<key>UIRequiredDeviceCapabilities</key>
46:		<string>front-facing-camera</string>
AR/Calibration/GazeReadinessEvaluator.swift:27:    private var blinkDetector = BlinkDetector()
~~~~

#### 2026-09-14 16:39:20 +0200 (14:39:20Z) · TOOL CALL · Bash · GIT
`4a1b6284` · `caf88613` · ligne 178 · Count tracked Markdown documentation lines

~~~~bash
cd "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris" && git ls-files '*.md' | tr '\n' '\0' | xargs -0 wc -l | tail -1; git ls-files '*.md' | tr '\n' '\0' | xargs -0 cat | grep -cv '^\s*$'; git ls-files '*.json' | grep -v xcassets | head -3; git status --short
~~~~

#### 2026-09-14 16:39:23 +0200 (14:39:23Z) · TOOL RESULT · Bash · GIT
`4a1b6284` · `b9ceccc6` · ligne 179 · Count tracked Markdown documentation lines

~~~~text
    4145 total
3164
Tests/IrisTests/Fixtures/golden_level1_scripted.json
Tests/IrisTests/Fixtures/golden_level9_far.json
?? SKILL.md
?? x7_silhouette_reference.png
~~~~

### 2026-09-14 16:42:34 +0200 (14:42:34Z) · CLAUDE · REPORT
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

### 2026-09-14 16:45:38 +0200 (14:45:38Z) · SYSTEM · récapitulatif d'absence (généré)
`4a1b6284` · `136c64d9` · ligne 191

~~~~markdown
Tu m'avais demandé un audit de maturité d'Iris en lecture seule : il est terminé et le rapport complet est affiché plus haut. Verdict : application semi-professionnelle, 68/100, avec les 406 tests réussis et le dépôt inchangé. Prochaine étape pour toi : lire le rapport et choisir les éléments bloquants à traiter. (disable recaps in /config)
~~~~


---

## Sous-agent `agent-a5504523198b6ab18` (transcription de la sous-tâche, isSidechain)

### 2026-09-14 16:34:49 +0200 (14:34:49Z) · USER
`4a1b6284` · `f3922fd3` · ligne 1 · sous-agent agent-a5504523198b6ab18

~~~~markdown
STRICTLY READ-ONLY senior audit. Do not modify, create, format or delete any file in the repo; no git writes; no builds (another process is building). Repo: /Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris (native iOS SwiftUI game driven by gaze tracking via ARKit/TrueDepth, Swift 6 strict concurrency).

Audit the gaze pipeline: AR/ (Services, Calibration, Projection), GameEngine/Gaze, Features/GazeSetup, App/Platform, App/DI/AppContainer.swift, and how gaze reaches gameplay (Features/Game/ViewModels/GameViewModel.swift, GameEngine/Session). Also read GAZE_ENGINE_V2_REPORT.md and Docs/Features/Gaze.md but VERIFY their claims against code.

Report with file:line evidence, labeling each claim VÉRIFIÉ / INFÉRÉ / NON VÉRIFIABLE:
1. Acquisition: ARFaceTrackingConfiguration use, isSupported check, faceAnchor, eye transforms vs lookAtPoint, head pose, isTracked handling, orientation/axes handling, which thread/queue delegates run on and how data crosses to MainActor (Sendable/@unchecked usage — are the @unchecked Sendable justified?).
2. Calibration: model (affine? least squares? regularization?), fixation sequence, validation/quality gates, invalid calibration rejection, persistence of calibration, invalidation (distance, orientation change).
3. Filtering: filter type (One-Euro? EMA? Kalman?), blink rejection, outlier handling, deltaTime handling, dropouts.
4. Screen mapping/viewport, clamping.
5. Lifecycle: session interruption, background/foreground, camera permission denied/restricted, no TrueDepth, tracking lost recovery; are errors explicit types, surfaced in UI, tested?
6. Separation acquisition / mapping / gameplay: protocols, mocks, testability. Which parts are covered by Tests/IrisTests/AR and Presentation tests (name test files and what they cover), and what is NOT tested.
7. Performance per-frame: allocations, main-thread work, per-frame logging.
8. Privacy: are face data/frames stored or logged anywhere? Any network?
9. Weaknesses, fragile areas, real sophistication level (be honest, neither inflate nor invent defects). No medical claims.
Keep final report dense, ≤ 900 words.
~~~~

### 2026-09-14 16:34:50 +0200 (14:34:50Z) · SYSTEM · modèle : Opus 5 (1M context) (claude-opus-5[1m])
`4a1b6284` · `0cf701cc` · ligne 4 · sous-agent agent-a5504523198b6ab18

### 2026-09-14 16:34:50 +0200 (14:34:50Z) · SYSTEM · date de session : 2026-09-14
`4a1b6284` · `0de01e15` · ligne 8 · sous-agent agent-a5504523198b6ab18

#### 2026-09-14 16:34:53 +0200 (14:34:53Z) · TOOL CALL · Bash
`4a1b6284` · `f062a83b` · ligne 11 · sous-agent agent-a5504523198b6ab18

~~~~bash
cd "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris"; ls; find Iris* -path '*AR/*' -o -path '*GameEngine/Gaze*' -o -path '*GazeSetup*' -o -path '*App/Platform*' -o -path '*DI/AppContainer*' -o -path '*GameEngine/Session*' | grep swift | xargs wc -l; find . -path '*Tests/IrisTests/AR*' -o -path '*Tests/IrisTests/Presentation*' | grep swift | xargs wc -l; find . -name GameViewModel.swift | xargs wc -l
~~~~

#### 2026-09-14 16:34:55 +0200 (14:34:55Z) · TOOL RESULT · Bash
`4a1b6284` · `15ae2db1` · ligne 12 · sous-agent agent-a5504523198b6ab18

~~~~text
App
AR
attention-indirecte.html
Audio
Config
Design
DesignSystem
Docs
Domain
Features
GAME_EXPANSION_DESIGN_REPORT.md
GameEngine
GAZE_ENGINE_V2_REPORT.md
Haptics
ios-app-skills.zip
Iris.xcodeproj
Navigation
project.yml
README.md
Resources
SKILL.md
SwiftUI-Agent-Skill-main.zip
Tests
Tools
VALIDATED_EXPANSION_BASELINE_REPORT.md
x7_silhouette_reference.png
      64 ./Tests/IrisTests/AR/RobustAggregatorTests.swift
     110 ./Tests/IrisTests/AR/FixationSequenceTests.swift
     121 ./Tests/IrisTests/AR/GazeMapperTests.swift
      97 ./Tests/IrisTests/AR/CalibrationProfileTests.swift
      85 ./Tests/IrisTests/AR/AxisMappingTests.swift
     125 ./Tests/IrisTests/AR/AffineTransform2DTests.swift
     114 ./Tests/IrisTests/AR/GazeReadinessEvaluatorTests.swift
      52 ./Tests/IrisTests/AR/NormalizedCoordinatesTests.swift
     179 ./Tests/IrisTests/Presentation/AncreSceneTests.swift
     106 ./Tests/IrisTests/Presentation/ChapterCardLayoutTests.swift
     419 ./Tests/IrisTests/Presentation/GameViewModelTests.swift
      46 ./Tests/IrisTests/Presentation/LaunchOptionsTests.swift
     148 ./Tests/IrisTests/Presentation/OculomotorTraceTests.swift
     277 ./Tests/IrisTests/Presentation/GazeSetupViewModelTests.swift
      63 ./Tests/IrisTests/Presentation/GameSettingsStoreTests.swift
     202 ./Tests/IrisTests/Presentation/AppCoordinatorTests.swift
     105 ./Tests/IrisTests/Presentation/AdaptiveLevelRowMetricsTests.swift
      58 ./Tests/IrisTests/Presentation/CameraAccessViewModelTests.swift
    2371 total
     586 ./Features/Game/ViewModels/GameViewModel.swift
~~~~

#### 2026-09-14 16:34:58 +0200 (14:34:58Z) · TOOL CALL · Bash
`4a1b6284` · `4bfe2f30` · ligne 18 · sous-agent agent-a5504523198b6ab18

~~~~bash
cd "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris"; find AR GameEngine/Gaze GameEngine/Session Features/GazeSetup App/Platform App/DI -name '*.swift' | xargs wc -l; wc -l GAZE_ENGINE_V2_REPORT.md Docs/Features/Gaze.md
~~~~

#### 2026-09-14 16:34:58 +0200 (14:34:58Z) · TOOL RESULT · Bash
`4a1b6284` · `badc224d` · ligne 19 · sous-agent agent-a5504523198b6ab18

~~~~text
     159 App/DI/AppContainer.swift
      14 App/DI/AppEnvironment.swift
      49 GameEngine/Gaze/GazeFilter.swift
      13 GameEngine/Session/SessionMetrics.swift
      57 GameEngine/Session/GameEvent.swift
     507 GameEngine/Session/GameSession.swift
      10 App/Platform/DeviceIdiom.swift
     109 App/Platform/LaunchOptions.swift
      62 App/Platform/DisplayLinkGameClock.swift
      10 App/Platform/SystemLinks.swift
      64 AR/Calibration/GazeMapper.swift
     111 AR/Calibration/AffineTransform2D.swift
      49 AR/Calibration/NominalDisplayGeometry.swift
      55 AR/Calibration/CalibrationStore.swift
     153 AR/Calibration/FixationSequence.swift
      77 AR/Calibration/GazeReadinessReport.swift
      27 AR/Calibration/CalibrationGrid.swift
      45 AR/Calibration/RobustAggregator.swift
      28 AR/Calibration/BlinkDetector.swift
     134 AR/Calibration/GazeReadinessEvaluator.swift
      87 AR/Calibration/AxisMapping.swift
      75 AR/Calibration/CalibrationResult.swift
      72 AR/Calibration/CalibrationProfile.swift
      29 AR/Calibration/DeviceAxis.swift
      27 AR/Calibration/NormalizedCoordinates.swift
     179 AR/Services/ARKitGazeTrackingService.swift
     131 AR/Services/SimulatedGazeTrackingService.swift
      64 AR/Services/CameraAuthorizationService.swift
      20 AR/Services/ARKitGazeTrackingService+Observation.swift
      50 AR/Services/InterfaceOrientationProvider.swift
      29 AR/Services/GazeObservation.swift
      24 AR/Services/DeviceCapabilities.swift
     102 AR/Services/GazeTrackingService.swift
      23 AR/Projection/GazeRay.swift
      11 Features/GazeSetup/ViewModels/GazeSetupIntent.swift
     369 Features/GazeSetup/ViewModels/GazeSetupViewModel.swift
      11 Features/GazeSetup/ViewModels/GazeSetupNavigating.swift
      71 Features/GazeSetup/ViewModels/GazeSetupPhase.swift
      54 Features/GazeSetup/Views/FixationTargetView.swift
      95 Features/GazeSetup/Views/GazeReadinessView.swift
     108 Features/GazeSetup/Views/GazeSetupView.swift
      81 Features/GazeSetup/Views/GazeVerdictView.swift
    3445 total
     116 GAZE_ENGINE_V2_REPORT.md
      32 Docs/Features/Gaze.md
     148 total
~~~~

#### 2026-09-14 16:35:01 +0200 (14:35:01Z) · TOOL CALL · Read
`4a1b6284` · `5215718d` · ligne 24 · sous-agent agent-a5504523198b6ab18

~~~~json
{
 "file_path": "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris/AR/Services/ARKitGazeTrackingService.swift"
}
~~~~

#### 2026-09-14 16:35:01 +0200 (14:35:01Z) · TOOL RESULT · Read
`4a1b6284` · `df62c250` · ligne 25 · sous-agent agent-a5504523198b6ab18

~~~~text
1	// ARKitGazeTrackingService.swift
2	// Layer: AR
3	// Purpose: ARFaceTrackingConfiguration session producing raw metric gaze samples in the interface-oriented
4	// camera frame. No screen scale, camera position or axis sign is assumed here.
5	
6	import Foundation
7	import ARKit
8	import os
9	import simd
10	
11	@MainActor
12	final class ARKitGazeTrackingService: NSObject, GazeTrackingService {
13	    private(set) var state: GazeTrackingState = .idle {
14	        didSet {
15	            if state != oldValue {
16	                logger.info("gaze state \(String(describing: self.state), privacy: .public)")
17	                onStateChange?(state)
18	            }
19	        }
20	    }
21	    private(set) var latestSample: RawGazeSample?
22	    var onStateChange: (@MainActor (GazeTrackingState) -> Void)?
23	    var onSample: (@MainActor (RawGazeSample) -> Void)?
24	
25	    private let session = ARSession()
26	    private var configuration: ARFaceTrackingConfiguration?
27	    private var viewport: GazeViewport?
28	    private let capabilities: any DeviceCapabilities
29	    private let orientationProvider: any InterfaceOrientationProvider
30	    private let logger = Logger(subsystem: "net.steve-s.iris", category: "gaze")
31	
32	    init(capabilities: any DeviceCapabilities = ARKitDeviceCapabilities(),
33	         orientationProvider: any InterfaceOrientationProvider = WindowSceneOrientationProvider()) {
34	        self.capabilities = capabilities
35	        self.orientationProvider = orientationProvider
36	        super.init()
37	        session.delegate = self
38	        session.delegateQueue = .main
39	    }
40	
41	    func start(viewport: GazeViewport) {
42	        guard capabilities.supportsFaceTracking else {
43	            state = .unavailable(.faceTrackingUnsupported)
44	            return
45	        }
46	        self.viewport = viewport
47	        let configuration = Self.makeConfiguration()
48	        self.configuration = configuration
49	        state = .starting
50	        logger.info("start viewport \(viewport.bounds.width, format: .fixed(precision: 0))x\(viewport.bounds.height, format: .fixed(precision: 0)) orientation \(self.orientationProvider.interfaceOrientation.irisName, privacy: .public)")
51	        session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
52	    }
53	
54	    func pause() {
55	        guard configuration != nil else { return }
56	        session.pause()
57	        state = .idle
58	    }
59	
60	    func resume() {
61	        guard viewport != nil else { return }
62	        let configuration = self.configuration ?? Self.makeConfiguration()
63	        self.configuration = configuration
64	        state = .starting
65	        session.run(configuration, options: [])
66	    }
67	
68	    func stop() {
69	        session.pause()
70	        configuration = nil
71	        latestSample = nil
72	        state = .idle
73	    }
74	
75	    func updateViewport(_ viewport: GazeViewport) {
76	        self.viewport = viewport
77	    }
78	
79	    private static func makeConfiguration() -> ARFaceTrackingConfiguration {
80	        let configuration = ARFaceTrackingConfiguration()
81	        configuration.isLightEstimationEnabled = false
82	        configuration.maximumNumberOfTrackedFaces = 1
83	        if let format = ARFaceTrackingConfiguration.supportedVideoFormats.first(where: { $0.framesPerSecond >= 60 }) {
84	            configuration.videoFormat = format
85	        }
86	        return configuration
87	    }
88	
89	    // MARK: Frame processing
90	
91	    private func process(_ frame: ARFrame) {
92	        guard viewport != nil else { return }
93	        guard let face = frame.anchors.lazy.compactMap({ $0 as? ARFaceAnchor }).first(where: \.isTracked) else {
94	            state = .tracking(faceVisible: false)
95	            return
96	        }
97	        let orientation = orientationProvider.interfaceOrientation.resolvedForGaze
98	        let view = frame.camera.viewMatrix(for: orientation)
99	        let anchorToView = view * face.transform
100	
101	        let leftEye = Self.point(anchorToView * face.leftEyeTransform.columns.3)
102	        let rightEye = Self.point(anchorToView * face.rightEyeTransform.columns.3)
103	        let eyeOrigin = (leftEye + rightEye) * 0.5
104	        let lookAt = face.lookAtPoint
105	        let lookAtView = Self.point(anchorToView * SIMD4<Float>(lookAt.x, lookAt.y, lookAt.z, 1))
106	
107	        let eyeLine = rightEye - leftEye
108	        let userRight = SIMD2(eyeLine.x, eyeLine.y)
109	        let userRightUnit = simd_length(userRight) > 1e-9 ? simd_normalize(userRight) : SIMD2<Double>(0, 0)
110	
111	        // World +y is up (gravity alignment); expressed in the view frame and projected on the device plane.
112	        let upInView = view * SIMD4<Float>(0, 1, 0, 0)
113	        let deviceUp = SIMD2(Double(upInView.x), Double(upInView.y))
114	
115	        // Face-derived fallback: right x forward, forward being the direction from the eyes to the camera.
116	        let forward = simd_length(eyeOrigin) > 1e-6 ? simd_normalize(-eyeOrigin) : SIMD3<Double>(0, 0, 1)
117	        let rightUnit3D = simd_length(eyeLine) > 1e-9 ? simd_normalize(eyeLine) : SIMD3<Double>(1, 0, 0)
118	        let faceUp3D = simd_cross(rightUnit3D, forward)
119	        let faceUp = SIMD2(faceUp3D.x, faceUp3D.y)
120	
121	        let blendShapes = face.blendShapes
122	        let blinkLeft = blendShapes[.eyeBlinkLeft]?.doubleValue ?? 0
123	        let blinkRight = blendShapes[.eyeBlinkRight]?.doubleValue ?? 0
124	
125	        let sample = RawGazeSample(timestamp: frame.timestamp,
126	                                   planeHit: GazeRay.planeHit(eyeOrigin: eyeOrigin, lookAt: lookAtView),
127	                                   eyeOrigin: eyeOrigin,
128	                                   eyeSeparation: simd_length(eyeLine),
129	                                   userRight: userRightUnit,
130	                                   deviceUp: deviceUp,
131	                                   faceUp: faceUp,
132	                                   blinkLeft: blinkLeft,
133	                                   blinkRight: blinkRight,
134	                                   hasBlendShapes: !blendShapes.isEmpty,
135	                                   observation: Self.observation(anchorToView: anchorToView, leftEye: leftEye, rightEye: rightEye, lookAt: lookAtView))
136	        latestSample = sample
137	        state = .tracking(faceVisible: true)
138	        onSample?(sample)
139	    }
140	
141	    private static func point(_ vector: SIMD4<Float>) -> SIMD3<Double> {
142	        SIMD3(Double(vector.x), Double(vector.y), Double(vector.z))
143	    }
144	
145	    private func handleFailure(_ error: any Error) {
146	        if let arError = error as? ARError {
147	            switch arError.code {
148	            case .cameraUnauthorized:
149	                state = .unavailable(.cameraDenied)
150	                return
151	            case .unsupportedConfiguration:
152	                state = .unavailable(.faceTrackingUnsupported)
153	                return
154	            default:
155	                break
156	            }
157	        }
158	        logger.error("AR session failed: \(error.localizedDescription, privacy: .public)")
159	        state = .failed(message: error.localizedDescription)
160	    }
161	}
162	
163	extension ARKitGazeTrackingService: ARSessionDelegate {
164	    nonisolated func session(_ session: ARSession, didUpdate frame: ARFrame) {
165	        MainActor.assumeIsolated { process(frame) }
166	    }
167	
168	    nonisolated func session(_ session: ARSession, didFailWithError error: any Error) {
169	        MainActor.assumeIsolated { handleFailure(error) }
170	    }
171	
172	    nonisolated func sessionWasInterrupted(_ session: ARSession) {
173	        MainActor.assumeIsolated { state = .interrupted }
174	    }
175	
176	    nonisolated func sessionInterruptionEnded(_ session: ARSession) {
177	        MainActor.assumeIsolated { state = .starting }
178	    }
179	}
180	
~~~~

#### 2026-09-14 16:35:02 +0200 (14:35:02Z) · TOOL CALL · Read
`4a1b6284` · `dd7b466b` · ligne 26 · sous-agent agent-a5504523198b6ab18

~~~~json
{
 "file_path": "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris/AR/Services/GazeTrackingService.swift"
}
~~~~

#### 2026-09-14 16:35:02 +0200 (14:35:02Z) · TOOL RESULT · Read
`4a1b6284` · `5afe6b75` · ligne 27 · sous-agent agent-a5504523198b6ab18

~~~~text
1	// GazeTrackingService.swift
2	// Layer: AR (service contract consumed by Presentation)
3	// Purpose: Abstraction over gaze acquisition. Produces raw, metric samples; calibration and mapping happen downstream.
4	
5	import Foundation
6	import simd
7	
8	enum GazeUnavailabilityReason: Hashable, Sendable {
9	    case faceTrackingUnsupported
10	    case cameraDenied
11	    case cameraRestricted
12	}
13	
14	enum GazeTrackingState: Hashable, Sendable {
15	    case idle
16	    case starting
17	    case tracking(faceVisible: Bool)
18	    case interrupted
19	    case unavailable(GazeUnavailabilityReason)
20	    case failed(message: String)
21	}
22	
23	/// One frame of raw gaze geometry in the interface-oriented camera frame (metres). Never persisted.
24	struct RawGazeSample: Hashable, Sendable {
25	    let timestamp: TimeInterval
26	    /// Hit of the gaze ray on the device plane, nil when the gaze does not reach the plane.
27	    let planeHit: SIMD2<Double>?
28	    /// Midpoint of both eyes.
29	    let eyeOrigin: SIMD3<Double>
30	    /// Distance between the eyes (metres), a plausibility cue.
31	    let eyeSeparation: Double
32	    /// Direction from the user's left eye to their right eye, projected on the device plane.
33	    let userRight: SIMD2<Double>
34	    /// Direction opposite to gravity, projected on the device plane (short when the device lies flat).
35	    let deviceUp: SIMD2<Double>
36	    /// Fallback up direction derived from the face itself.
37	    let faceUp: SIMD2<Double>
38	    let blinkLeft: Double
39	    let blinkRight: Double
40	    let hasBlendShapes: Bool
41	    /// PROTOTYPE observation (head pose, eye geometry) for DEBUG traces; nil from the simulator and in tests. Not read by the mapping.
42	    let observation: GazeObservation?
43	
44	    init(timestamp: TimeInterval, planeHit: SIMD2<Double>?, eyeOrigin: SIMD3<Double>, eyeSeparation: Double,
45	         userRight: SIMD2<Double>, deviceUp: SIMD2<Double>, faceUp: SIMD2<Double>,
46	         blinkLeft: Double, blinkRight: Double, hasBlendShapes: Bool, observation: GazeObservation? = nil) {
47	        self.timestamp = timestamp
48	        self.planeHit = planeHit
49	        self.eyeOrigin = eyeOrigin
50	        self.eyeSeparation = eyeSeparation
51	        self.userRight = userRight
52	        self.deviceUp = deviceUp
53	        self.faceUp = faceUp
54	        self.blinkLeft = blinkLeft
55	        self.blinkRight = blinkRight
56	        self.hasBlendShapes = hasBlendShapes
57	        self.observation = observation
58	    }
59	
60	    var faceDistance: Double { simd_length(eyeOrigin) }
61	
62	    /// Axis mapping suggested by this single frame (majority voting happens in the readiness evaluator).
63	    var suggestedAxisMapping: AxisMapping? {
64	        AxisResolver.resolve(userRight: userRight, deviceUp: deviceUp, faceUp: faceUp)
65	    }
66	}
67	
68	/// Gaze sample mapped to playfield points (the game's coordinate space).
69	struct GazeSample: Hashable, Sendable {
70	    let point: Vector2
71	    let timestamp: TimeInterval
72	
73	    init(point: Vector2, timestamp: TimeInterval) {
74	        self.point = point
75	        self.timestamp = timestamp
76	    }
77	}
78	
79	struct GazeViewport: Hashable, Sendable {
80	    let bounds: PlayfieldBounds
81	    /// Nominal frame used by the simulator to invert pointer positions; ignored by the ARKit service.
82	    let nominal: NominalDisplayGeometry
83	
84	    init(bounds: PlayfieldBounds, nominal: NominalDisplayGeometry) {
85	        self.bounds = bounds
86	        self.nominal = nominal
87	    }
88	}
89	
90	@MainActor
91	protocol GazeTrackingService: AnyObject {
92	    var state: GazeTrackingState { get }
93	    var latestSample: RawGazeSample? { get }
94	    var onStateChange: (@MainActor (GazeTrackingState) -> Void)? { get set }
95	    var onSample: (@MainActor (RawGazeSample) -> Void)? { get set }
96	
97	    func start(viewport: GazeViewport)
98	    func pause()
99	    func resume()
100	    func stop()
101	    func updateViewport(_ viewport: GazeViewport)
102	}
103	
~~~~

#### 2026-09-14 16:35:03 +0200 (14:35:03Z) · TOOL CALL · Read
`4a1b6284` · `0febef40` · ligne 28 · sous-agent agent-a5504523198b6ab18

~~~~json
{
 "file_path": "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris/AR/Services/ARKitGazeTrackingService+Observation.swift"
}
~~~~

#### 2026-09-14 16:35:03 +0200 (14:35:03Z) · TOOL RESULT · Read
`4a1b6284` · `78e96aa2` · ligne 29 · sous-agent agent-a5504523198b6ab18

~~~~text
1	// ARKitGazeTrackingService+Observation.swift
2	// Layer: AR
3	// Purpose: PROTOTYPE observation only: derives head yaw, pitch and roll from the face anchor's rotation in the view
4	// frame, next to the eye positions the service already computes. Pure geometry, no effect on the gaze sample.
5	
6	import Foundation
7	import simd
8	
9	extension ARKitGazeTrackingService {
10	    /// The face anchor's +z axis points out of the face toward the camera; its +y axis is the face's up.
11	    static func observation(anchorToView: simd_float4x4, leftEye: SIMD3<Double>, rightEye: SIMD3<Double>, lookAt: SIMD3<Double>) -> GazeObservation {
12	        let forward = anchorToView * SIMD4<Float>(0, 0, 1, 0)
13	        let up = anchorToView * SIMD4<Float>(0, 1, 0, 0)
14	        let fx = Double(forward.x), fy = Double(forward.y), fz = Double(forward.z)
15	        let yaw = atan2(fx, fz) * 180 / .pi
16	        let pitch = atan2(fy, (fx * fx + fz * fz).squareRoot()) * 180 / .pi
17	        let roll = atan2(Double(up.x), Double(up.y)) * 180 / .pi
18	        return GazeObservation(headYaw: yaw, headPitch: pitch, headRoll: roll, leftEye: leftEye, rightEye: rightEye, lookAt: lookAt)
19	    }
20	}
21	
~~~~

#### 2026-09-14 16:35:04 +0200 (14:35:04Z) · TOOL CALL · Read
`4a1b6284` · `05fa91fc` · ligne 30 · sous-agent agent-a5504523198b6ab18

~~~~json
{
 "file_path": "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris/AR/Services/GazeObservation.swift"
}
~~~~

#### 2026-09-14 16:35:04 +0200 (14:35:04Z) · TOOL RESULT · Read
`4a1b6284` · `7e6c52c0` · ligne 31 · sous-agent agent-a5504523198b6ab18

~~~~text
1	// GazeObservation.swift
2	// Layer: AR
3	// Purpose: PROTOTYPE observation only: head orientation and eye geometry ARKit already provides for every frame,
4	// exposed next to the gaze sample for DEBUG traces. Nothing in the gaze computation reads it.
5	
6	import Foundation
7	import simd
8	
9	struct GazeObservation: Hashable, Sendable {
10	    /// Head orientation in the interface-oriented camera view frame, degrees. Yaw is positive when the face turns
11	    /// toward the view's +x, pitch positive when it turns toward +y, roll positive when the face's up axis leans
12	    /// toward +x. Signs are a convention for deltas, not a clinical measure.
13	    let headYaw: Double
14	    let headPitch: Double
15	    let headRoll: Double
16	    /// Eye centres and ARKit's look-at point, view frame, metres.
17	    let leftEye: SIMD3<Double>
18	    let rightEye: SIMD3<Double>
19	    let lookAt: SIMD3<Double>
20	
21	    init(headYaw: Double, headPitch: Double, headRoll: Double, leftEye: SIMD3<Double>, rightEye: SIMD3<Double>, lookAt: SIMD3<Double>) {
22	        self.headYaw = headYaw
23	        self.headPitch = headPitch
24	        self.headRoll = headRoll
25	        self.leftEye = leftEye
26	        self.rightEye = rightEye
27	        self.lookAt = lookAt
28	    }
29	}
30	
~~~~

#### 2026-09-14 16:35:05 +0200 (14:35:05Z) · TOOL CALL · Read
`4a1b6284` · `a93e1b98` · ligne 32 · sous-agent agent-a5504523198b6ab18

~~~~json
{
 "file_path": "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris/AR/Services/InterfaceOrientationProvider.swift"
}
~~~~

#### 2026-09-14 16:35:05 +0200 (14:35:05Z) · TOOL RESULT · Read
`4a1b6284` · `ecc95c20` · ligne 33 · sous-agent agent-a5504523198b6ab18

~~~~text
1	// InterfaceOrientationProvider.swift
2	// Layer: AR
3	// Purpose: The interface orientation actually used by the foreground window scene, never a hard-coded value
4	
5	import Foundation
6	import UIKit
7	
8	@MainActor
9	protocol InterfaceOrientationProvider: AnyObject {
10	    var interfaceOrientation: UIInterfaceOrientation { get }
11	}
12	
13	extension UIInterfaceOrientation {
14	    /// Stable name stored with a calibration profile.
15	    var irisName: String {
16	        switch self {
17	        case .portrait: "portrait"
18	        case .portraitUpsideDown: "portraitUpsideDown"
19	        case .landscapeLeft: "landscapeLeft"
20	        case .landscapeRight: "landscapeRight"
21	        case .unknown: "unknown"
22	        @unknown default: "unknown"
23	        }
24	    }
25	
26	    /// Unknown orientations fall back to portrait, the only orientation Iris supports.
27	    var resolvedForGaze: UIInterfaceOrientation {
28	        self == .unknown ? .portrait : self
29	    }
30	}
31	
32	@MainActor
33	final class WindowSceneOrientationProvider: InterfaceOrientationProvider {
34	    init() {}
35	
36	    var interfaceOrientation: UIInterfaceOrientation {
37	        let scenes = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
38	        let active = scenes.first { $0.activationState == .foregroundActive } ?? scenes.first
39	        return (active?.interfaceOrientation ?? .portrait).resolvedForGaze
40	    }
41	}
42	
43	@MainActor
44	final class FixedOrientationProvider: InterfaceOrientationProvider {
45	    let interfaceOrientation: UIInterfaceOrientation
46	
47	    init(_ orientation: UIInterfaceOrientation = .portrait) {
48	        self.interfaceOrientation = orientation
49	    }
50	}
51	
~~~~

#### 2026-09-14 16:35:05 +0200 (14:35:05Z) · TOOL CALL · Read
`4a1b6284` · `a8b6b27f` · ligne 34 · sous-agent agent-a5504523198b6ab18

~~~~json
{
 "file_path": "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris/AR/Services/DeviceCapabilities.swift"
}
~~~~

#### 2026-09-14 16:35:05 +0200 (14:35:05Z) · TOOL RESULT · Read
`4a1b6284` · `c44ccf30` · ligne 35 · sous-agent agent-a5504523198b6ab18

~~~~text
1	// DeviceCapabilities.swift
2	// Layer: AR
3	// Purpose: Hardware capability probe (TrueDepth face tracking) behind a protocol for tests and previews
4	
5	import Foundation
6	import ARKit
7	
8	protocol DeviceCapabilities: Sendable {
9	    var supportsFaceTracking: Bool { get }
10	}
11	
12	struct ARKitDeviceCapabilities: DeviceCapabilities {
13	    init() {}
14	
15	    var supportsFaceTracking: Bool { ARFaceTrackingConfiguration.isSupported }
16	}
17	
18	struct StaticDeviceCapabilities: DeviceCapabilities {
19	    let supportsFaceTracking: Bool
20	
21	    init(supportsFaceTracking: Bool) {
22	        self.supportsFaceTracking = supportsFaceTracking
23	    }
24	}
25	
~~~~

#### 2026-09-14 16:35:06 +0200 (14:35:06Z) · TOOL CALL · Read
`4a1b6284` · `761f456a` · ligne 36 · sous-agent agent-a5504523198b6ab18

~~~~json
{
 "file_path": "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris/AR/Services/CameraAuthorizationService.swift"
}
~~~~

#### 2026-09-14 16:35:06 +0200 (14:35:06Z) · TOOL RESULT · Read
`4a1b6284` · `47d0eb06` · ligne 37 · sous-agent agent-a5504523198b6ab18

~~~~text
1	// CameraAuthorizationService.swift
2	// Layer: AR
3	// Purpose: Camera permission status and request, abstracted from AVFoundation
4	
5	import Foundation
6	import AVFoundation
7	
8	enum CameraAuthorizationStatus: Hashable, Sendable {
9	    case notDetermined
10	    case authorized
11	    case denied
12	    case restricted
13	}
14	
15	protocol CameraAuthorizationService: Sendable {
16	    func currentStatus() -> CameraAuthorizationStatus
17	    func requestAccess() async -> CameraAuthorizationStatus
18	}
19	
20	struct AVCaptureCameraAuthorizationService: CameraAuthorizationService {
21	    init() {}
22	
23	    func currentStatus() -> CameraAuthorizationStatus {
24	        Self.map(AVCaptureDevice.authorizationStatus(for: .video))
25	    }
26	
27	    func requestAccess() async -> CameraAuthorizationStatus {
28	        _ = await AVCaptureDevice.requestAccess(for: .video)
29	        return currentStatus()
30	    }
31	
32	    private static func map(_ status: AVAuthorizationStatus) -> CameraAuthorizationStatus {
33	        switch status {
34	        case .authorized: .authorized
35	        case .denied: .denied
36	        case .restricted: .restricted
37	        case .notDetermined: .notDetermined
38	        @unknown default: .denied
39	        }
40	    }
41	}
42	
43	/// Deterministic authorization used by previews and tests.
44	final class StubCameraAuthorizationService: CameraAuthorizationService, @unchecked Sendable {
45	    private let lock = NSLock()
46	    private var status: CameraAuthorizationStatus
47	    private let statusAfterRequest: CameraAuthorizationStatus
48	
49	    init(status: CameraAuthorizationStatus, statusAfterRequest: CameraAuthorizationStatus = .authorized) {
50	        self.status = status
51	        self.statusAfterRequest = statusAfterRequest
52	    }
53	
54	    func currentStatus() -> CameraAuthorizationStatus {
55	        lock.withLock { status }
56	    }
57	
58	    func requestAccess() async -> CameraAuthorizationStatus {
59	        lock.withLock {
60	            status = statusAfterRequest
61	            return status
62	        }
63	    }
64	}
65	
~~~~

#### 2026-09-14 16:35:07 +0200 (14:35:07Z) · TOOL CALL · Read
`4a1b6284` · `5aacc4e4` · ligne 38 · sous-agent agent-a5504523198b6ab18

~~~~json
{
 "file_path": "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris/AR/Projection/GazeRay.swift"
}
~~~~

#### 2026-09-14 16:35:07 +0200 (14:35:07Z) · TOOL RESULT · Read
`4a1b6284` · `16705007` · ligne 39 · sous-agent agent-a5504523198b6ab18

~~~~text
1	// GazeRay.swift
2	// Layer: AR (pure Swift)
3	// Purpose: Intersection of the eye-to-lookAtPoint ray with the device plane (z = 0 of the interface-oriented camera
4	// frame). Makes no assumption about which side of the plane the face is on or about the sign of the in-plane axes.
5	
6	import Foundation
7	import simd
8	
9	enum GazeRay {
10	    /// Returns the in-plane hit point (metres) of the ray from `eyeOrigin` through `lookAt`, or nil when the ray
11	    /// does not travel toward the plane (looking away) or when inputs are not finite.
12	    static func planeHit(eyeOrigin: SIMD3<Double>, lookAt: SIMD3<Double>) -> SIMD2<Double>? {
13	        guard eyeOrigin.x.isFinite, eyeOrigin.y.isFinite, eyeOrigin.z.isFinite,
14	              lookAt.x.isFinite, lookAt.y.isFinite, lookAt.z.isFinite else { return nil }
15	        let direction = lookAt - eyeOrigin
16	        guard abs(direction.z) > 1e-9, abs(eyeOrigin.z) > 1e-6 else { return nil }
17	        let travel = -eyeOrigin.z / direction.z
18	        guard travel > 0, travel.isFinite else { return nil }
19	        let hit = eyeOrigin + direction * travel
20	        guard hit.x.isFinite, hit.y.isFinite else { return nil }
21	        return SIMD2(hit.x, hit.y)
22	    }
23	}
24	
~~~~

#### 2026-09-14 16:35:08 +0200 (14:35:08Z) · TOOL CALL · Read
`4a1b6284` · `dda41241` · ligne 40 · sous-agent agent-a5504523198b6ab18

~~~~json
{
 "file_path": "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris/AR/Calibration/AffineTransform2D.swift"
}
~~~~

#### 2026-09-14 16:35:08 +0200 (14:35:08Z) · TOOL RESULT · Read
`4a1b6284` · `9f5c8d38` · ligne 41 · sous-agent agent-a5504523198b6ab18

~~~~text
1	// AffineTransform2D.swift
2	// Layer: AR (calibration, pure Swift)
3	// Purpose: Six-coefficient affine correction (offset, scale, shear, axis flips) fitted by least squares
4	
5	import Foundation
6	import simd
7	
8	enum CalibrationFitError: Error, Hashable, Sendable {
9	    case insufficientPoints(Int)
10	    case nonFiniteInput
11	    case degenerateGeometry
12	}
13	
14	struct AffineTransform2D: Codable, Hashable, Sendable {
15	    var a0: Double
16	    var a1: Double
17	    var a2: Double
18	    var b0: Double
19	    var b1: Double
20	    var b2: Double
21	
22	    init(a0: Double, a1: Double, a2: Double, b0: Double, b1: Double, b2: Double) {
23	        self.a0 = a0
24	        self.a1 = a1
25	        self.a2 = a2
26	        self.b0 = b0
27	        self.b1 = b1
28	        self.b2 = b2
29	    }
30	
31	    static let identity = AffineTransform2D(a0: 0, a1: 1, a2: 0, b0: 0, b1: 0, b2: 1)
32	
33	    /// `x' = a0 + a1 x + a2 y`, `y' = b0 + b1 x + b2 y`
34	    func apply(_ point: SIMD2<Double>) -> SIMD2<Double> {
35	        SIMD2(a0 + a1 * point.x + a2 * point.y, b0 + b1 * point.x + b2 * point.y)
36	    }
37	
38	    var isFinite: Bool {
39	        [a0, a1, a2, b0, b1, b2].allSatisfy(\.isFinite)
40	    }
41	
42	    /// Least-squares fit of raw -> target pairs through the normal equations of a 3-parameter linear model per axis.
43	    /// Needs at least three pairs that are not collinear; non-finite inputs are refused.
44	    static func fit(_ pairs: [(raw: SIMD2<Double>, target: SIMD2<Double>)]) throws(CalibrationFitError) -> AffineTransform2D {
45	        guard pairs.count >= 3 else { throw .insufficientPoints(pairs.count) }
46	        guard pairs.allSatisfy({ NormalizedCoordinates.isFinite($0.raw) && NormalizedCoordinates.isFinite($0.target) }) else {
47	            throw .nonFiniteInput
48	        }
49	        var matrix = [[Double]](repeating: [Double](repeating: 0, count: 3), count: 3)
50	        var rhsX = [Double](repeating: 0, count: 3)
51	        var rhsY = [Double](repeating: 0, count: 3)
52	        for pair in pairs {
53	            let basis = [1.0, pair.raw.x, pair.raw.y]
54	            for row in 0..<3 {
55	                for column in 0..<3 {
56	                    matrix[row][column] += basis[row] * basis[column]
57	                }
58	                rhsX[row] += basis[row] * pair.target.x
59	                rhsY[row] += basis[row] * pair.target.y
60	            }
61	        }
62	        guard let coefficientsX = LinearSolver3.solve(matrix, rhsX), let coefficientsY = LinearSolver3.solve(matrix, rhsY) else {
63	            throw .degenerateGeometry
64	        }
65	        let transform = AffineTransform2D(a0: coefficientsX[0], a1: coefficientsX[1], a2: coefficientsX[2],
66	                                          b0: coefficientsY[0], b1: coefficientsY[1], b2: coefficientsY[2])
67	        guard transform.isFinite else { throw .degenerateGeometry }
68	        return transform
69	    }
70	
71	    /// Euclidean residual of every pair in the target space.
72	    func residuals(_ pairs: [(raw: SIMD2<Double>, target: SIMD2<Double>)]) -> [Double] {
73	        pairs.map { simd_length(apply($0.raw) - $0.target) }
74	    }
75	}
76	
77	/// Gaussian elimination with partial pivoting for a 3x3 system.
78	enum LinearSolver3 {
79	    static func solve(_ matrix: [[Double]], _ rhs: [Double]) -> [Double]? {
80	        var a = matrix
81	        var b = rhs
82	        let scale = max(1e-300, a.flatMap { $0 }.map { abs($0) }.max() ?? 1)
83	        for column in 0..<3 {
84	            var pivot = column
85	            for row in column + 1..<3 where abs(a[row][column]) > abs(a[pivot][column]) {
86	                pivot = row
87	            }
88	            if abs(a[pivot][column]) <= 1e-12 * scale { return nil }
89	            if pivot != column {
90	                a.swapAt(pivot, column)
91	                b.swapAt(pivot, column)
92	            }
93	            for row in column + 1..<3 {
94	                let factor = a[row][column] / a[column][column]
95	                for k in column..<3 {
96	                    a[row][k] -= factor * a[column][k]
97	                }
98	                b[row] -= factor * b[column]
99	            }
100	        }
101	        var solution = [Double](repeating: 0, count: 3)
102	        for row in stride(from: 2, through: 0, by: -1) {
103	            var sum = b[row]
104	            for k in row + 1..<3 {
105	                sum -= a[row][k] * solution[k]
106	            }
107	            solution[row] = sum / a[row][row]
108	        }
109	        return solution.allSatisfy(\.isFinite) ? solution : nil
110	    }
111	}
112	
~~~~

#### 2026-09-14 16:35:08 +0200 (14:35:08Z) · TOOL CALL · Read
`4a1b6284` · `f5220859` · ligne 42 · sous-agent agent-a5504523198b6ab18

~~~~json
{
 "file_path": "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris/AR/Calibration/GazeMapper.swift"
}
~~~~

#### 2026-09-14 16:35:08 +0200 (14:35:08Z) · TOOL RESULT · Read
`4a1b6284` · `3a6dbdf0` · ligne 43 · sous-agent agent-a5504523198b6ab18

~~~~text
1	// GazeMapper.swift
2	// Layer: AR (calibration, pure Swift)
3	// Purpose: Raw metric sample -> axis-resolved plane offsets -> nominal normalized -> affine calibration -> points
4	
5	import Foundation
6	import simd
7	
8	struct GazeMapper: Hashable, Sendable {
9	    var viewport: PlayfieldBounds
10	    var nominal: NominalDisplayGeometry
11	    var axisMapping: AxisMapping
12	    var calibration: AffineTransform2D?
13	    /// Points farther than this fraction of the viewport outside its edges are clamped.
14	    var overshoot: Double = 0.5
15	
16	    init(viewport: PlayfieldBounds, nominal: NominalDisplayGeometry, axisMapping: AxisMapping = .standard,
17	         calibration: AffineTransform2D? = nil) {
18	        self.viewport = viewport
19	        self.nominal = nominal
20	        self.axisMapping = axisMapping
21	        self.calibration = calibration
22	    }
23	
24	    init(viewport: PlayfieldBounds, profile: CalibrationProfile) {
25	        self.init(viewport: viewport, nominal: profile.nominalGeometry, axisMapping: profile.axisMapping,
26	                  calibration: profile.transform)
27	    }
28	
29	    var isCalibrated: Bool { calibration != nil }
30	
31	    /// Uncalibrated position (nominal frame), used for the raw diagnostic dot and as calibration input.
32	    func nominalNormalized(_ sample: RawGazeSample) -> SIMD2<Double>? {
33	        guard let hit = sample.planeHit else { return nil }
34	        let offsets = axisMapping.screenCoordinates(of: hit)
35	        let normalized = nominal.normalized(right: offsets.x, up: offsets.y, viewport: viewport)
36	        return NormalizedCoordinates.isFinite(normalized) ? normalized : nil
37	    }
38	
39	    /// Calibrated position when a transform exists, nominal otherwise.
40	    func calibratedNormalized(_ sample: RawGazeSample) -> SIMD2<Double>? {
41	        guard let raw = nominalNormalized(sample) else { return nil }
42	        guard let calibration else { return raw }
43	        let corrected = calibration.apply(raw)
44	        return NormalizedCoordinates.isFinite(corrected) ? corrected : nil
45	    }
46	
47	    func screenPoint(normalized: SIMD2<Double>) -> Vector2 {
48	        let point = NormalizedCoordinates.points(normalized, in: viewport)
49	        let marginX = viewport.width * overshoot
50	        let marginY = viewport.height * overshoot
51	        return Vector2(x: min(max(point.x, -marginX), viewport.width + marginX),
52	                       y: min(max(point.y, -marginY), viewport.height + marginY))
53	    }
54	
55	    /// Calibrated, clamped playfield point.
56	    func screenPoint(_ sample: RawGazeSample) -> Vector2? {
57	        calibratedNormalized(sample).map(screenPoint(normalized:))
58	    }
59	
60	    /// Uncalibrated, clamped playfield point (diagnostics).
61	    func rawScreenPoint(_ sample: RawGazeSample) -> Vector2? {
62	        nominalNormalized(sample).map(screenPoint(normalized:))
63	    }
64	}
65	
~~~~

#### 2026-09-14 16:35:09 +0200 (14:35:09Z) · TOOL CALL · Read
`4a1b6284` · `e127218c` · ligne 44 · sous-agent agent-a5504523198b6ab18

~~~~json
{
 "file_path": "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris/AR/Calibration/AxisMapping.swift"
}
~~~~

#### 2026-09-14 16:35:09 +0200 (14:35:09Z) · TOOL RESULT · Read
`4a1b6284` · `adb10841` · ligne 45 · sous-agent agent-a5504523198b6ab18

~~~~text
1	// AxisMapping.swift
2	// Layer: AR (calibration, pure Swift)
3	// Purpose: Which in-plane camera axes are the screen's right and up, resolved from the user's eyes and gravity
4	// instead of from assumptions about ARKit's front-camera conventions
5	
6	import Foundation
7	import simd
8	
9	struct AxisMapping: Codable, Hashable, Sendable {
10	    var right: DeviceAxis
11	    var up: DeviceAxis
12	
13	    init(right: DeviceAxis, up: DeviceAxis) {
14	        self.right = right
15	        self.up = up
16	    }
17	
18	    /// The mapping one would assume for a view frame with x to the right and y up.
19	    static let standard = AxisMapping(right: .positiveX, up: .positiveY)
20	
21	    /// Metres to the right and up of the camera for a device-plane point.
22	    func screenCoordinates(of planePoint: SIMD2<Double>) -> SIMD2<Double> {
23	        SIMD2(right.component(of: planePoint), up.component(of: planePoint))
24	    }
25	
26	    /// Inverse of `screenCoordinates` (used by the simulator).
27	    func planePoint(right rightMetres: Double, up upMetres: Double) -> SIMD2<Double> {
28	        right.vector * rightMetres + up.vector * upMetres
29	    }
30	
31	    /// True when (right, up, toward the user) form a right-handed frame; recorded for diagnostics only.
32	    var isRightHanded: Bool {
33	        right.vector.x * up.vector.y - right.vector.y * up.vector.x > 0
34	    }
35	}
36	
37	enum AxisResolver {
38	    /// - userRight: from the user's left eye to their right eye, projected on the device plane (any length).
39	    /// - deviceUp: direction opposite to gravity projected on the device plane; near zero when the device lies flat.
40	    /// - faceUp: fallback up direction derived from the face, used when gravity is degenerate.
41	    /// Returns nil when a direction is too short to be trusted or when both map to the same physical axis.
42	    static func resolve(userRight: SIMD2<Double>, deviceUp: SIMD2<Double>, faceUp: SIMD2<Double>,
43	                        minimumLength: Double = 0.2) -> AxisMapping? {
44	        guard let right = dominantAxis(of: userRight, minimumLength: minimumLength) else { return nil }
45	        let upSource = simd_length(deviceUp) >= minimumLength ? deviceUp : faceUp
46	        guard let up = dominantAxis(of: upSource, minimumLength: minimumLength), up.isHorizontal != right.isHorizontal else {
47	            return nil
48	        }
49	        return AxisMapping(right: right, up: up)
50	    }
51	
52	    static func dominantAxis(of direction: SIMD2<Double>, minimumLength: Double) -> DeviceAxis? {
53	        guard direction.x.isFinite, direction.y.isFinite, simd_length(direction) >= minimumLength else { return nil }
54	        if abs(direction.x) >= abs(direction.y) {
55	            return direction.x >= 0 ? .positiveX : .negativeX
56	        }
57	        return direction.y >= 0 ? .positiveY : .negativeY
58	    }
59	}
60	
61	/// Majority vote over many frames so that a momentary head tilt never flips the mapping.
62	struct AxisVote: Hashable, Sendable {
63	    private var counts: [AxisMapping: Int] = [:]
64	    private(set) var total = 0
65	
66	    init() {}
67	
68	    mutating func add(_ mapping: AxisMapping) {
69	        counts[mapping, default: 0] += 1
70	        total += 1
71	    }
72	
73	    mutating func reset() {
74	        counts.removeAll()
75	        total = 0
76	    }
77	
78	    var majority: AxisMapping? {
79	        counts.max { lhs, rhs in lhs.value < rhs.value }?.key
80	    }
81	
82	    /// Share of votes won by the majority mapping (0 when empty).
83	    var confidence: Double {
84	        guard total > 0, let majority, let count = counts[majority] else { return 0 }
85	        return Double(count) / Double(total)
86	    }
87	}
88	
~~~~

#### 2026-09-14 16:35:10 +0200 (14:35:10Z) · TOOL CALL · Read
`4a1b6284` · `75e4c0d1` · ligne 46 · sous-agent agent-a5504523198b6ab18

~~~~json
{
 "file_path": "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris/AR/Calibration/FixationSequence.swift"
}
~~~~

#### 2026-09-14 16:35:10 +0200 (14:35:10Z) · TOOL RESULT · Read
`4a1b6284` · `8448a11c` · ligne 47 · sous-agent agent-a5504523198b6ab18

~~~~text
1	// FixationSequence.swift
2	// Layer: AR (calibration, pure Swift)
3	// Purpose: Time-based target sequence: settle, collect usable samples, aggregate robustly, retry once, move on
4	
5	import Foundation
6	import simd
7	
8	enum FixationFailure: Hashable, Sendable {
9	    case insufficientSamples(target: Int)
10	}
11	
12	enum FixationEvent: Hashable, Sendable {
13	    case targetChanged(index: Int)
14	    case targetMeasured(index: Int)
15	    case completed
16	    case failed(FixationFailure)
17	}
18	
19	struct FixationSequence: Hashable, Sendable {
20	    struct Configuration: Hashable, Sendable {
21	        /// Time to let the eyes travel to the new target before collecting.
22	        var settleDuration: TimeInterval = 0.3
23	        /// Nominal collection window per target.
24	        var collectDuration: TimeInterval = 0.8
25	        /// Valid samples needed after outlier rejection.
26	        var minimumSamples: Int = 12
27	        /// Collection keeps going past `collectDuration` up to this bound when samples are missing (blinks).
28	        var maximumCollectDuration: TimeInterval = 2.5
29	        var maximumRetries: Int = 1
30	
31	        init() {}
32	    }
33	
34	    enum Stage: Hashable, Sendable {
35	        case idle
36	        case settling(target: Int)
37	        case collecting(target: Int)
38	        case completed
39	        case failed(FixationFailure)
40	    }
41	
42	    let targets: [SIMD2<Double>]
43	    let configuration: Configuration
44	    private(set) var stage: Stage = .idle
45	    private(set) var measurements: [Int: RobustAggregator.Result] = [:]
46	    private var stageStart: TimeInterval?
47	    private var buffer: [SIMD2<Double>] = []
48	    private var retries: [Int: Int] = [:]
49	
50	    init(targets: [SIMD2<Double>], configuration: Configuration = Configuration()) {
51	        self.targets = targets
52	        self.configuration = configuration
53	    }
54	
55	    var currentTargetIndex: Int? {
56	        switch stage {
57	        case let .settling(target), let .collecting(target): target
58	        case .idle, .completed, .failed: nil
59	        }
60	    }
61	
62	    var currentTarget: SIMD2<Double>? {
63	        currentTargetIndex.map { targets[$0] }
64	    }
65	
66	    var isCollecting: Bool {
67	        if case .collecting = stage { return true }
68	        return false
69	    }
70	
71	    var isFinished: Bool {
72	        switch stage {
73	        case .completed, .failed: true
74	        case .idle, .settling, .collecting: false
75	        }
76	    }
77	
78	    /// 0...1 progress of the current target (settling counts for nothing, collection fills the ring).
79	    func progress(at time: TimeInterval) -> Double {
80	        guard case .collecting = stage, let stageStart else { return 0 }
81	        return min(max((time - stageStart) / configuration.collectDuration, 0), 1)
82	    }
83	
84	    /// Raw -> target pairs of every measured target, in target order.
85	    var pairs: [(raw: SIMD2<Double>, target: SIMD2<Double>)] {
86	        measurements.keys.sorted().map { (measurements[$0]?.center ?? SIMD2(0, 0), targets[$0]) }
87	    }
88	
89	    mutating func start(at time: TimeInterval) -> FixationEvent? {
90	        guard !targets.isEmpty else {
91	            stage = .completed
92	            return .completed
93	        }
94	        stage = .settling(target: 0)
95	        stageStart = time
96	        buffer.removeAll(keepingCapacity: true)
97	        return .targetChanged(index: 0)
98	    }
99	
100	    /// Feeds one observation. `sample` is nil when the tracker produced nothing; `isUsable` is false during blinks.
101	    mutating func feed(sample: SIMD2<Double>?, isUsable: Bool, at time: TimeInterval) -> FixationEvent? {
102	        switch stage {
103	        case .idle:
104	            return start(at: time)
105	        case let .settling(target):
106	            guard let stageStart else { return nil }
107	            if time - stageStart >= configuration.settleDuration {
108	                stage = .collecting(target: target)
109	                self.stageStart = time
110	                buffer.removeAll(keepingCapacity: true)
111	            }
112	            return nil
113	        case let .collecting(target):
114	            guard let stageStart else { return nil }
115	            if isUsable, let sample, NormalizedCoordinates.isFinite(sample) {
116	                buffer.append(sample)
117	            }
118	            let elapsed = time - stageStart
119	            guard elapsed >= configuration.collectDuration else { return nil }
120	            if let result = RobustAggregator.aggregate(buffer, minimumAccepted: configuration.minimumSamples) {
121	                measurements[target] = result
122	                return advance(from: target, at: time)
123	            }
124	            if elapsed < configuration.maximumCollectDuration {
125	                return nil
126	            }
127	            let attempts = retries[target, default: 0]
128	            if attempts < configuration.maximumRetries {
129	                retries[target] = attempts + 1
130	                stage = .settling(target: target)
131	                self.stageStart = time
132	                buffer.removeAll(keepingCapacity: true)
133	                return .targetChanged(index: target)
134	            }
135	            stage = .failed(.insufficientSamples(target: target))
136	            return .failed(.insufficientSamples(target: target))
137	        case .completed, .failed:
138	            return nil
139	        }
140	    }
141	
142	    private mutating func advance(from target: Int, at time: TimeInterval) -> FixationEvent {
143	        let next = target + 1
144	        if next < targets.count {
145	            stage = .settling(target: next)
146	            stageStart = time
147	            buffer.removeAll(keepingCapacity: true)
148	            return .targetChanged(index: next)
149	        }
150	        stage = .completed
151	        return .completed
152	    }
153	}
154	
~~~~

#### 2026-09-14 16:35:11 +0200 (14:35:11Z) · TOOL CALL · Read
`4a1b6284` · `28b260e1` · ligne 48 · sous-agent agent-a5504523198b6ab18

~~~~json
{
 "file_path": "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris/AR/Calibration/GazeReadinessEvaluator.swift"
}
~~~~

#### 2026-09-14 16:35:11 +0200 (14:35:11Z) · TOOL RESULT · Read
`4a1b6284` · `617ec0c3` · ligne 49 · sous-agent agent-a5504523198b6ab18

~~~~text
1	// GazeReadinessEvaluator.swift
2	// Layer: AR (calibration, pure Swift)
3	// Purpose: Checks that the gaze signal is usable before calibrating: face, eyes, direction, stability, blinks, axes
4	
5	import Foundation
6	import simd
7	
8	struct GazeReadinessEvaluator: Hashable, Sendable {
9	    struct Configuration: Hashable, Sendable {
10	        var windowDuration: TimeInterval = 1.2
11	        var minimumSamples = 20
12	        var minimumHitRatio = 0.8
13	        var distanceRange: ClosedRange<Double> = 0.15...0.9
14	        var eyeSeparationRange: ClosedRange<Double> = 0.04...0.10
15	        /// RMS deviation of the eye midpoint over the window (metres).
16	        var maximumHeadDeviation = 0.02
17	        /// RMS deviation of the nominal normalized gaze over the window while looking at a fixed point.
18	        var maximumSignalDeviation = 0.10
19	        var minimumAxisConfidence = 0.8
20	
21	        init() {}
22	    }
23	
24	    let configuration: Configuration
25	    private var window: [RawGazeSample] = []
26	    private var axisVote = AxisVote()
27	    private var blinkDetector = BlinkDetector()
28	
29	    init(configuration: Configuration = Configuration()) {
30	        self.configuration = configuration
31	    }
32	
33	    var sampleCount: Int { window.count }
34	
35	    mutating func reset() {
36	        window.removeAll()
37	        axisVote.reset()
38	    }
39	
40	    mutating func ingest(_ sample: RawGazeSample) {
41	        window.append(sample)
42	        let cutoff = sample.timestamp - configuration.windowDuration
43	        window.removeAll { $0.timestamp < cutoff }
44	        if let mapping = sample.suggestedAxisMapping {
45	            axisVote.add(mapping)
46	        }
47	    }
48	
49	    func report(supportsFaceTracking: Bool, cameraAuthorized: Bool, trackingState: GazeTrackingState,
50	                nominal: NominalDisplayGeometry, viewport: PlayfieldBounds) -> GazeReadinessReport {
51	        var checks: [ReadinessCheck] = []
52	        checks.append(ReadinessCheck(kind: .faceTracking, status: supportsFaceTracking ? .pass : .fail,
53	                                     detail: supportsFaceTracking ? "Suivi facial ARKit disponible" : "Appareil sans suivi facial"))
54	        checks.append(ReadinessCheck(kind: .cameraAccess, status: cameraAuthorized ? .pass : .fail,
55	                                     detail: cameraAuthorized ? "Autorisé" : "Refusé ou restreint"))
56	
57	        let sessionStatus: ReadinessStatus
58	        let sessionDetail: String
59	        switch trackingState {
60	        case .tracking: sessionStatus = .pass; sessionDetail = "Frames reçues"
61	        case .starting, .idle: sessionStatus = .pending; sessionDetail = "Démarrage"
62	        case .interrupted: sessionStatus = .fail; sessionDetail = "Session interrompue"
63	        case .unavailable: sessionStatus = .fail; sessionDetail = "Indisponible"
64	        case .failed: sessionStatus = .fail; sessionDetail = "Erreur"
65	        }
66	        checks.append(ReadinessCheck(kind: .session, status: sessionStatus, detail: sessionDetail))
67	
68	        let faceVisible: Bool
69	        if case .tracking(true) = trackingState { faceVisible = true } else { faceVisible = false }
70	        let enough = window.count >= configuration.minimumSamples
71	        checks.append(ReadinessCheck(kind: .faceDetected, status: faceVisible && enough ? .pass : .pending,
72	                                     detail: faceVisible ? (enough ? "Visage suivi" : "Un instant…") : "Placez votre visage face à l'écran"))
73	
74	        guard enough else {
75	            for kind in [ReadinessCheckKind.eyeTracking, .gazeDirection, .headStable, .signalStable, .blinkDetection, .axisMapping] {
76	                checks.append(ReadinessCheck(kind: kind, status: .pending, detail: "En attente du signal"))
77	            }
78	            return GazeReadinessReport(checks: checks, axisMapping: axisVote.majority, axisConfidence: axisVote.confidence, sampleCount: window.count)
79	        }
80	
81	        let distances = window.map(\.faceDistance)
82	        let separations = window.map(\.eyeSeparation)
83	        let medianDistance = RobustAggregator.median(distances)
84	        let medianSeparation = RobustAggregator.median(separations)
85	        let eyesValid = medianSeparation.isFinite && configuration.eyeSeparationRange.contains(medianSeparation)
86	            && medianDistance.isFinite && configuration.distanceRange.contains(medianDistance)
87	        checks.append(ReadinessCheck(kind: .eyeTracking, status: eyesValid ? .pass : .fail,
88	                                     detail: eyesValid ? String(format: "Distance %.0f cm", medianDistance * 100)
89	                                                       : "Rapprochez-vous ou éloignez-vous de l'écran (20 à 80 cm)"))
90	
91	        let hits = window.compactMap { sample -> SIMD2<Double>? in
92	            sample.planeHit.map { hit in
93	                let offsets = AxisMapping.standard.screenCoordinates(of: hit)
94	                return nominal.normalized(right: offsets.x, up: offsets.y, viewport: viewport)
95	            }
96	        }
97	        let hitRatio = Double(hits.count) / Double(window.count)
98	        checks.append(ReadinessCheck(kind: .gazeDirection, status: hitRatio >= configuration.minimumHitRatio ? .pass : .fail,
99	                                     detail: hitRatio >= configuration.minimumHitRatio ? "Regard dirigé vers l'écran" : "Regardez l'écran"))
100	
101	        let headDeviation = Self.rmsDeviation(window.map { SIMD2($0.eyeOrigin.x, $0.eyeOrigin.y) })
102	        let headStable = headDeviation <= configuration.maximumHeadDeviation
103	        checks.append(ReadinessCheck(kind: .headStable, status: headStable ? .pass : .pending,
104	                                     detail: headStable ? "Tête immobile" : "Gardez la tête immobile"))
105	
106	        let signalDeviation = Self.rmsDeviation(hits)
107	        let signalStable = hits.count >= configuration.minimumSamples / 2 && signalDeviation <= configuration.maximumSignalDeviation
108	        checks.append(ReadinessCheck(kind: .signalStable, status: signalStable ? .pass : .pending,
109	                                     detail: signalStable ? "Signal régulier" : "Fixez le point au centre"))
110	
111	        let blinksAvailable = window.allSatisfy(\.hasBlendShapes)
112	        checks.append(ReadinessCheck(kind: .blinkDetection, status: blinksAvailable ? .pass : .fail,
113	                                     detail: blinksAvailable ? "Les clignements seront ignorés" : "Blend shapes indisponibles"))
114	
115	        let mapping = axisVote.majority
116	        let axisOK = mapping != nil && axisVote.confidence >= configuration.minimumAxisConfidence
117	        checks.append(ReadinessCheck(kind: .axisMapping, status: axisOK ? .pass : .pending,
118	                                     detail: axisOK ? "Axes résolus (\(Self.describe(mapping)))" : "Tenez l'iPhone droit devant vous"))
119	
120	        return GazeReadinessReport(checks: checks, axisMapping: mapping, axisConfidence: axisVote.confidence, sampleCount: window.count)
121	    }
122	
123	    static func rmsDeviation(_ points: [SIMD2<Double>]) -> Double {
124	        guard !points.isEmpty else { return .infinity }
125	        let mean = points.reduce(SIMD2<Double>(0, 0), +) / Double(points.count)
126	        let squared = points.reduce(0.0) { $0 + simd_length_squared($1 - mean) }
127	        return (squared / Double(points.count)).squareRoot()
128	    }
129	
130	    static func describe(_ mapping: AxisMapping?) -> String {
131	        guard let mapping else { return "?" }
132	        return "droite = \(mapping.right.rawValue), haut = \(mapping.up.rawValue)"
133	    }
134	}
135	
~~~~

#### 2026-09-14 16:35:12 +0200 (14:35:12Z) · TOOL CALL · Read
`4a1b6284` · `7b2ee6b1` · ligne 50 · sous-agent agent-a5504523198b6ab18

~~~~json
{
 "file_path": "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris/AR/Calibration/CalibrationStore.swift"
}
~~~~

#### 2026-09-14 16:35:12 +0200 (14:35:12Z) · TOOL RESULT · Read
`4a1b6284` · `c0baf642` · ligne 51 · sous-agent agent-a5504523198b6ab18

~~~~text
1	// CalibrationStore.swift
2	// Layer: AR (calibration)
3	// Purpose: Local persistence of the calibration profile (UserDefaults JSON) behind a protocol
4	
5	import Foundation
6	
7	protocol CalibrationStore: AnyObject, Sendable {
8	    func load() -> CalibrationProfile?
9	    func save(_ profile: CalibrationProfile)
10	    func clear()
11	}
12	
13	final class UserDefaultsCalibrationStore: CalibrationStore, @unchecked Sendable {
14	    private static let key = "iris.gaze.calibrationProfile"
15	    private let defaults: UserDefaults
16	
17	    init(defaults: UserDefaults = .standard) {
18	        self.defaults = defaults
19	    }
20	
21	    func load() -> CalibrationProfile? {
22	        guard let data = defaults.data(forKey: Self.key) else { return nil }
23	        return try? JSONDecoder().decode(CalibrationProfile.self, from: data)
24	    }
25	
26	    func save(_ profile: CalibrationProfile) {
27	        guard let data = try? JSONEncoder().encode(profile) else { return }
28	        defaults.set(data, forKey: Self.key)
29	    }
30	
31	    func clear() {
32	        defaults.removeObject(forKey: Self.key)
33	    }
34	}
35	
36	final class InMemoryCalibrationStore: CalibrationStore, @unchecked Sendable {
37	    private let lock = NSLock()
38	    private var profile: CalibrationProfile?
39	
40	    init(profile: CalibrationProfile? = nil) {
41	        self.profile = profile
42	    }
43	
44	    func load() -> CalibrationProfile? {
45	        lock.withLock { profile }
46	    }
47	
48	    func save(_ profile: CalibrationProfile) {
49	        lock.withLock { self.profile = profile }
50	    }
51	
52	    func clear() {
53	        lock.withLock { profile = nil }
54	    }
55	}
56	
~~~~

#### 2026-09-14 16:35:12 +0200 (14:35:12Z) · TOOL CALL · Read
`4a1b6284` · `7003a391` · ligne 52 · sous-agent agent-a5504523198b6ab18

~~~~json
{
 "file_path": "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris/AR/Calibration/CalibrationProfile.swift"
}
~~~~

#### 2026-09-14 16:35:12 +0200 (14:35:12Z) · TOOL RESULT · Read
`4a1b6284` · `7e72af14` · ligne 53 · sous-agent agent-a5504523198b6ab18

~~~~text
1	// CalibrationProfile.swift
2	// Layer: AR (calibration, pure Swift)
3	// Purpose: Persisted result of a gaze calibration: coefficients and the context they are valid for. No gaze data.
4	
5	import Foundation
6	
7	struct CalibrationProfile: Codable, Hashable, Sendable {
8	    static let currentVersion = 1
9	
10	    var version: Int
11	    var transform: AffineTransform2D
12	    var axisMapping: AxisMapping
13	    var interfaceOrientation: String
14	    var viewportWidth: Double
15	    var viewportHeight: Double
16	    /// Nominal frame the transform was fitted against; must be reused when applying the transform.
17	    var nominalGeometry: NominalDisplayGeometry
18	    var createdAt: Date
19	    var validationMeanError: Double?
20	    var validationMaxError: Double?
21	    var isValid: Bool
22	
23	    init(version: Int = CalibrationProfile.currentVersion,
24	         transform: AffineTransform2D,
25	         axisMapping: AxisMapping,
26	         interfaceOrientation: String,
27	         viewport: PlayfieldBounds,
28	         nominalGeometry: NominalDisplayGeometry,
29	         createdAt: Date,
30	         validationMeanError: Double?,
31	         validationMaxError: Double?,
32	         isValid: Bool) {
33	        self.version = version
34	        self.transform = transform
35	        self.axisMapping = axisMapping
36	        self.interfaceOrientation = interfaceOrientation
37	        self.viewportWidth = viewport.width
38	        self.viewportHeight = viewport.height
39	        self.nominalGeometry = nominalGeometry
40	        self.createdAt = createdAt
41	        self.validationMeanError = validationMeanError
42	        self.validationMaxError = validationMaxError
43	        self.isValid = isValid
44	    }
45	
46	    var viewport: PlayfieldBounds { PlayfieldBounds(width: viewportWidth, height: viewportHeight) }
47	
48	    /// A profile is reusable when it has the current model version, was validated, matches the viewport
49	    /// (within one percent) and the interface orientation, and is not older than `maximumAge`.
50	    func isCompatible(viewport: PlayfieldBounds, interfaceOrientation: String, now: Date,
51	                      maximumAge: TimeInterval = 30 * 24 * 3600) -> Bool {
52	        guard isValid else { return false }
53	        return isUsable(viewport: viewport, interfaceOrientation: interfaceOrientation, now: now, maximumAge: maximumAge)
54	    }
55	
56	    /// Same context checks without the validity flag: the game may run on a profile the player chose to keep
57	    /// despite a mediocre validation, which still beats the nominal projection.
58	    func isUsable(viewport: PlayfieldBounds, interfaceOrientation: String, now: Date = Date(),
59	                  maximumAge: TimeInterval = 30 * 24 * 3600) -> Bool {
60	        guard version == Self.currentVersion, transform.isFinite else { return false }
61	        guard self.interfaceOrientation == interfaceOrientation else { return false }
62	        let widthMatches = abs(viewportWidth - viewport.width) <= viewport.width * 0.01
63	        let heightMatches = abs(viewportHeight - viewport.height) <= viewport.height * 0.01
64	        guard widthMatches && heightMatches else { return false }
65	        return now.timeIntervalSince(createdAt) <= maximumAge && createdAt <= now.addingTimeInterval(60)
66	    }
67	
68	    /// Cheap check used before the viewport is known (route selection at launch).
69	    var isCurrentAndValid: Bool {
70	        version == Self.currentVersion && isValid && transform.isFinite
71	    }
72	}
73	
~~~~

#### 2026-09-14 16:35:13 +0200 (14:35:13Z) · TOOL CALL · Read
`4a1b6284` · `3c1e6f24` · ligne 54 · sous-agent agent-a5504523198b6ab18

~~~~json
{
 "file_path": "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris/AR/Calibration/RobustAggregator.swift"
}
~~~~

#### 2026-09-14 16:35:13 +0200 (14:35:13Z) · TOOL RESULT · Read
`4a1b6284` · `18e77729` · ligne 55 · sous-agent agent-a5504523198b6ab18

~~~~text
1	// RobustAggregator.swift
2	// Layer: AR (calibration, pure Swift)
3	// Purpose: Median-based fixation estimate with MAD outlier rejection, so a blink or a glance never skews a point
4	
5	import Foundation
6	import simd
7	
8	enum RobustAggregator {
9	    struct Result: Hashable, Sendable {
10	        /// Mean of the accepted samples (trimmed mean around the per-axis median).
11	        let center: SIMD2<Double>
12	        let acceptedCount: Int
13	        let rejectedCount: Int
14	        /// Root mean square distance of accepted samples to the centre (normalized units).
15	        let dispersion: Double
16	    }
17	
18	    /// - madMultiplier: samples farther than this many median absolute deviations from the median are rejected.
19	    /// - madFloor: minimum tolerated deviation so that an extremely tight cluster never rejects everything.
20	    static func aggregate(_ samples: [SIMD2<Double>], madMultiplier: Double = 3.5, madFloor: Double = 0.01,
21	                          minimumAccepted: Int) -> Result? {
22	        let finite = samples.filter(NormalizedCoordinates.isFinite)
23	        guard finite.count >= minimumAccepted, finite.count > 0 else { return nil }
24	        let medianX = median(finite.map(\.x))
25	        let medianY = median(finite.map(\.y))
26	        let deviations = finite.map { simd_length($0 - SIMD2(medianX, medianY)) }
27	        let mad = max(median(deviations), madFloor)
28	        let accepted = zip(finite, deviations).filter { $0.1 <= madMultiplier * mad }.map(\.0)
29	        guard accepted.count >= minimumAccepted else { return nil }
30	        let sum = accepted.reduce(SIMD2<Double>(0, 0), +)
31	        let center = sum / Double(accepted.count)
32	        let squared = accepted.reduce(0.0) { $0 + simd_length_squared($1 - center) }
33	        return Result(center: center,
34	                      acceptedCount: accepted.count,
35	                      rejectedCount: finite.count - accepted.count,
36	                      dispersion: (squared / Double(accepted.count)).squareRoot())
37	    }
38	
39	    static func median(_ values: [Double]) -> Double {
40	        guard !values.isEmpty else { return .nan }
41	        let sorted = values.sorted()
42	        let middle = sorted.count / 2
43	        return sorted.count.isMultiple(of: 2) ? (sorted[middle - 1] + sorted[middle]) / 2 : sorted[middle]
44	    }
45	}
46	
~~~~

#### 2026-09-14 16:35:14 +0200 (14:35:14Z) · TOOL CALL · Read
`4a1b6284` · `7cce87f8` · ligne 56 · sous-agent agent-a5504523198b6ab18

~~~~json
{
 "file_path": "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris/AR/Calibration/BlinkDetector.swift"
}
~~~~

#### 2026-09-14 16:35:14 +0200 (14:35:14Z) · TOOL RESULT · Read
`4a1b6284` · `eedc8b46` · ligne 57 · sous-agent agent-a5504523198b6ab18

~~~~text
1	// BlinkDetector.swift
2	// Layer: AR (calibration, pure Swift)
3	// Purpose: Flags samples taken during a blink (either eye) and shortly after it
4	
5	import Foundation
6	
7	struct BlinkDetector: Hashable, Sendable {
8	    var threshold: Double
9	    var holdOff: TimeInterval
10	    private var lastBlinkTime: TimeInterval?
11	
12	    init(threshold: Double = 0.5, holdOff: TimeInterval = 0.12) {
13	        self.threshold = threshold
14	        self.holdOff = holdOff
15	    }
16	
17	    /// `left` and `right` are the `eyeBlinkLeft` / `eyeBlinkRight` blend shape coefficients (0...1).
18	    mutating func isBlinking(left: Double, right: Double, at time: TimeInterval) -> Bool {
19	        if max(left, right) >= threshold {
20	            lastBlinkTime = time
21	            return true
22	        }
23	        if let lastBlinkTime, time - lastBlinkTime < holdOff {
24	            return true
25	        }
26	        return false
27	    }
28	}
29	
~~~~

#### 2026-09-14 16:35:15 +0200 (14:35:15Z) · TOOL CALL · Read
`4a1b6284` · `60acdda7` · ligne 58 · sous-agent agent-a5504523198b6ab18

~~~~json
{
 "file_path": "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris/GameEngine/Gaze/GazeFilter.swift"
}
~~~~

#### 2026-09-14 16:35:15 +0200 (14:35:15Z) · TOOL RESULT · Read
`4a1b6284` · `0d0876f7` · ligne 59 · sous-agent agent-a5504523198b6ab18

~~~~text
1	// GazeFilter.swift
2	// Layer: GameEngine
3	// Purpose: R-13 port of the reference gaze listener: exponential smoothing (alpha 0.1) and sustained-jump gating
4	
5	import Foundation
6	
7	struct GazeFilter: Hashable, Sendable {
8	    /// `alpha = 0.1`: stability over reactivity.
9	    var smoothing: Double
10	    /// A raw sample farther than this from the cursor is a "big jump" (blink or glitch).
11	    var jumpThreshold: Double
12	    /// Number of consecutive big jumps needed before the jump is trusted as a real gaze move.
13	    var sustainedJumpCount: Int
14	
15	    private(set) var position: Vector2
16	    private(set) var isActive: Bool
17	    private var consecutiveBigJumps: Int
18	
19	    init(initialPosition: Vector2, smoothing: Double = 0.1, jumpThreshold: Double = 300, sustainedJumpCount: Int = 3) {
20	        self.position = initialPosition
21	        self.smoothing = smoothing
22	        self.jumpThreshold = jumpThreshold
23	        self.sustainedJumpCount = sustainedJumpCount
24	        self.isActive = false
25	        self.consecutiveBigJumps = 0
26	    }
27	
28	    /// Feeds one raw sample. Returns false when the sample was ignored as an isolated big jump.
29	    @discardableResult
30	    mutating func ingest(_ raw: Vector2) -> Bool {
31	        let jump = raw.distance(to: position)
32	        if jump > jumpThreshold && isActive {
33	            consecutiveBigJumps += 1
34	            if consecutiveBigJumps < sustainedJumpCount { return false }
35	        } else {
36	            consecutiveBigJumps = 0
37	        }
38	        position = position + (raw - position) * smoothing
39	        isActive = true
40	        return true
41	    }
42	
43	    /// Places the cursor exactly, bypassing smoothing (used by tests, golden traces and previews).
44	    mutating func place(at point: Vector2) {
45	        position = point
46	        isActive = true
47	        consecutiveBigJumps = 0
48	    }
49	}
50	
~~~~

#### 2026-09-14 16:35:15 +0200 (14:35:15Z) · TOOL CALL · Read
`4a1b6284` · `f72bf8f5` · ligne 60 · sous-agent agent-a5504523198b6ab18

~~~~json
{
 "file_path": "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris/AR/Calibration/CalibrationResult.swift"
}
~~~~

#### 2026-09-14 16:35:15 +0200 (14:35:15Z) · TOOL RESULT · Read
`4a1b6284` · `fb506ddb` · ligne 61 · sous-agent agent-a5504523198b6ab18

~~~~text
1	// CalibrationResult.swift
2	// Layer: AR (calibration, pure Swift)
3	// Purpose: Outcome of a calibration fit and of a validation pass
4	
5	import Foundation
6	import simd
7	
8	struct CalibrationResult: Hashable, Sendable {
9	    let transform: AffineTransform2D
10	    /// Residuals of the fitted points in normalized units.
11	    let residualMean: Double
12	    let residualMax: Double
13	    let pointCount: Int
14	
15	    init(transform: AffineTransform2D, residualMean: Double, residualMax: Double, pointCount: Int) {
16	        self.transform = transform
17	        self.residualMean = residualMean
18	        self.residualMax = residualMax
19	        self.pointCount = pointCount
20	    }
21	
22	    static func fit(pairs: [(raw: SIMD2<Double>, target: SIMD2<Double>)]) throws(CalibrationFitError) -> CalibrationResult {
23	        let transform = try AffineTransform2D.fit(pairs)
24	        let residuals = transform.residuals(pairs)
25	        return CalibrationResult(transform: transform,
26	                                 residualMean: residuals.reduce(0, +) / Double(max(residuals.count, 1)),
27	                                 residualMax: residuals.max() ?? 0,
28	                                 pointCount: pairs.count)
29	    }
30	}
31	
32	struct ValidationResult: Hashable, Sendable {
33	    struct Measurement: Hashable, Sendable {
34	        let target: SIMD2<Double>
35	        let measured: SIMD2<Double>
36	        /// Error in points divided by the shorter viewport side.
37	        let error: Double
38	    }
39	
40	    let measurements: [Measurement]
41	    let meanError: Double
42	    let maxError: Double
43	
44	    init(measurements: [Measurement]) {
45	        self.measurements = measurements
46	        let errors = measurements.map(\.error)
47	        meanError = errors.reduce(0, +) / Double(max(errors.count, 1))
48	        maxError = errors.max() ?? 0
49	    }
50	
51	    init(pairs: [(measured: SIMD2<Double>, target: SIMD2<Double>)], viewport: PlayfieldBounds) {
52	        self.init(measurements: pairs.map {
53	            Measurement(target: $0.target, measured: $0.measured,
54	                        error: NormalizedCoordinates.error(between: $0.measured, and: $0.target, in: viewport))
55	        })
56	    }
57	}
58	
59	/// Accepts a calibration when the validation error stays within a fraction of the shorter screen side.
60	/// 18 percent mean / 30 percent max: tolerant to ARKit's few-centimetre gaze accuracy, strict enough to reject
61	/// an inverted axis (errors above 50 percent) or a wrong scale.
62	struct GazeQualityCriteria: Hashable, Sendable {
63	    var meanErrorLimit: Double
64	    var maxErrorLimit: Double
65	
66	    init(meanErrorLimit: Double = 0.18, maxErrorLimit: Double = 0.30) {
67	        self.meanErrorLimit = meanErrorLimit
68	        self.maxErrorLimit = maxErrorLimit
69	    }
70	
71	    func accepts(_ result: ValidationResult) -> Bool {
72	        result.meanError.isFinite && result.maxError.isFinite
73	            && result.meanError <= meanErrorLimit && result.maxError <= maxErrorLimit
74	    }
75	}
76	
~~~~

#### 2026-09-14 16:35:16 +0200 (14:35:16Z) · TOOL CALL · Read
`4a1b6284` · `24902026` · ligne 62 · sous-agent agent-a5504523198b6ab18

~~~~json
{
 "file_path": "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris/AR/Calibration/NominalDisplayGeometry.swift"
}
~~~~

#### 2026-09-14 16:35:16 +0200 (14:35:16Z) · TOOL RESULT · Read
`4a1b6284` · `3e6b6021` · ligne 63 · sous-agent agent-a5504523198b6ab18

~~~~text
1	// NominalDisplayGeometry.swift
2	// Layer: AR (calibration, pure Swift)
3	// Purpose: Rough physical model of the screen used ONLY as a first guess before calibration and for the
4	// uncalibrated diagnostic dot. The calibrated path never depends on these numbers: the affine calibration
5	// learns the real scale and offset on top of this nominal frame.
6	
7	import Foundation
8	import simd
9	
10	struct NominalDisplayGeometry: Codable, Hashable, Sendable {
11	    /// Nominal physical size of one point in metres.
12	    var metersPerPoint: Double
13	    /// Nominal camera position in viewport points (top centre of the screen).
14	    var cameraOrigin: Vector2
15	
16	    init(metersPerPoint: Double, cameraOrigin: Vector2) {
17	        self.metersPerPoint = metersPerPoint
18	        self.cameraOrigin = cameraOrigin
19	    }
20	
21	    /// Order-of-magnitude estimate from the display scale and idiom (3x iPhones about 460 ppi, 2x iPhones 326 ppi,
22	    /// iPads 264 ppi). A few percent of error is expected and absorbed by the calibration.
23	    static func estimate(viewport: PlayfieldBounds, displayScale: Double, isPad: Bool) -> NominalDisplayGeometry {
24	        let pixelsPerInch: Double
25	        if isPad {
26	            pixelsPerInch = viewport.width <= 744 ? 326 : 264
27	        } else {
28	            pixelsPerInch = displayScale >= 2.5 ? 460 : 326
29	        }
30	        let metersPerPoint = displayScale * 0.0254 / pixelsPerInch
31	        let cameraY: Double = isPad ? -40 : 12
32	        return NominalDisplayGeometry(metersPerPoint: metersPerPoint, cameraOrigin: Vector2(x: viewport.width / 2, y: cameraY))
33	    }
34	
35	    /// Nominal normalized viewport coordinates (0...1 inside the screen) of a point `right` metres to the right
36	    /// of the camera and `up` metres above it.
37	    func normalized(right: Double, up: Double, viewport: PlayfieldBounds) -> SIMD2<Double> {
38	        let x = (cameraOrigin.x + right / metersPerPoint) / viewport.width
39	        let y = (cameraOrigin.y - up / metersPerPoint) / viewport.height
40	        return SIMD2(x, y)
41	    }
42	
43	    /// Inverse of `normalized(right:up:viewport:)`.
44	    func planeOffsets(normalized: SIMD2<Double>, viewport: PlayfieldBounds) -> (right: Double, up: Double) {
45	        let right = (normalized.x * viewport.width - cameraOrigin.x) * metersPerPoint
46	        let up = (cameraOrigin.y - normalized.y * viewport.height) * metersPerPoint
47	        return (right, up)
48	    }
49	}
50	
~~~~

#### 2026-09-14 16:35:17 +0200 (14:35:17Z) · TOOL CALL · Read
`4a1b6284` · `76d4ee58` · ligne 64 · sous-agent agent-a5504523198b6ab18

~~~~json
{
 "file_path": "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris/GAZE_ENGINE_V2_REPORT.md"
}
~~~~

#### 2026-09-14 16:35:17 +0200 (14:35:17Z) · TOOL RESULT · Read
`4a1b6284` · `2642b559` · ligne 65 · sous-agent agent-a5504523198b6ab18

~~~~text
1	# Gaze Engine v2 — rapport
2	
3	Date : 11 septembre 2026. Portée : pipeline de suivi du regard d'Iris (ARKit → regard brut → projection → calibration → lissage → coordonnées jeu). Le moteur de jeu (physique, validation 0,75 s, séquence, cascade, niveaux, progression, audio) n'a pas été modifié.
4	
5	## Avant
6	
7	Chaîne v1 (session du 10 septembre) :
8	
9	1. `ARKitGazeTrackingService` : `viewMatrix(for: .portrait)` **codé en dur**, rayon `milieu des yeux → lookAtPoint`, intersection avec le plan `z = 0`, **hypothèse** `eyeOrigin.z < 0`.
10	2. `GazeProjector` : conversion mètres → points par `metersPerPoint` **estimé** (460 ppi pour les iPhone 3x, 326 ppi pour 2x, 264 ppi iPad), origine caméra **supposée** à `(largeur/2, 12 pt)` (`-40 pt` sur iPad), **miroir horizontal imposé** (`screenX = cx - x/mpp`), signe vertical imposé (`screenY = cy - y/mpp`).
11	3. Réglage manuel « Miroir horizontal » dans le menu pause pour corriger un éventuel mauvais signe.
12	4. `GazeFilter` (alpha 0,1, rejet des sauts) dans la session de jeu.
13	5. Aucune calibration : hypothèse `lookAtPoint ne nécessite aucune calibration`.
14	
15	## Défauts trouvés
16	
17	- **Signes X et Y déduits d'un raisonnement sur les conventions ARKit**, jamais mesurés. Le symptôme observé (« le suivi fonctionne mieux iPhone retourné ») correspond exactement à une inversion des deux axes (rotation de 180°) ou d'un axe plus un mauvais miroir : le code v1 fixait `screenX` avec un miroir et `screenY` avec un signe imposé.
18	- Orientation `.portrait` forcée dans la projection au lieu de l'orientation réelle de la `UIWindowScene`.
19	- Échelle physique et position de caméra approximées par famille d'appareil : erreur d'échelle et d'offset structurelle, différente pour chaque iPhone.
20	- Aucun contrôle du signal avant de jouer (visage, yeux, direction, stabilité, clignements).
21	- Aucune correction du biais individuel (offset, échelle, cisaillement).
22	- Un point de regard périmé continuait d'être utilisé quand le visage disparaissait (curseur figé).
23	- Le réglage « miroir » servait de rustine à une transformation incertaine.
24	
25	## Après
26	
27	Chaîne v2 :
28	
29	1. **`ARKitGazeTrackingService`** : `viewMatrix(for: orientation)` avec l'orientation réelle fournie par `WindowSceneOrientationProvider` (`UIWindowScene.interfaceOrientation`, repli portrait si inconnue). Par frame : positions des deux yeux (`leftEyeTransform`, `rightEyeTransform`), `lookAtPoint`, tous transformés dans le repère caméra orienté ; intersection rayon/plan **sans hypothèse sur le côté du plan** (`GazeRay.planeHit`, paramètre `t > 0`) ; direction « droite de l'utilisateur » (œil gauche → œil droit, projetée dans le plan) ; direction « haut » issue de la **gravité** (`+y monde` exprimé dans le repère caméra, alignement gravité par défaut d'ARKit) ; repli « haut visage » (produit vectoriel droite × direction yeux→caméra) si l'appareil est à plat ; blend shapes `eyeBlinkLeft/Right` ; distance et écartement des yeux. Sortie : `RawGazeSample` métrique, **sans aucun signe, échelle ou position de caméra présumés**.
30	2. **`AxisResolver` / `AxisVote`** : les axes écran (droite, haut) sont **résolus à l'exécution** parmi ±x/±y du repère caméra à partir de la ligne des yeux et de la gravité, par vote majoritaire sur la fenêtre de diagnostic (confiance ≥ 0,8). Un iPhone retourné, un repère miroir ou pivoté de 90° donnent des mappings différents mais corrects. Le résultat est enregistré dans le profil (contexte d'orientation) et journalisé (y compris la main du repère, à titre diagnostique).
31	3. **`NominalDisplayGeometry`** : les anciennes estimations (ppi, caméra en haut au centre) subsistent uniquement comme *repère nominal* pour normaliser les mètres en coordonnées 0…1 et pour le point brut de diagnostic. Elles ne sont plus le chemin principal : la calibration apprend l'échelle et l'offset réels par-dessus.
32	4. **`GazeMapper`** : `RawGazeSample` → offsets (droite, haut) via `AxisMapping` → nominal normalisé → **affine 2D** (`AffineTransform2D`, 6 coefficients, moindres carrés par équations normales, élimination de Gauss avec pivot) → points, bornés à ±50 % du viewport.
33	5. **Diagnostic (`GazeReadinessEvaluator`)** : caméra TrueDepth, permission, session AR, visage détecté, suivi des yeux (distance 15–90 cm, écartement 4–10 cm), direction du regard (≥ 80 % des rayons atteignent l'écran), tête stable (RMS ≤ 2 cm), signal stable (RMS ≤ 10 % du nominal), clignements disponibles, axes résolus. Écran `Gaze Readiness` avec liste ✓ et « regard prêt pour la calibration » ; calibration lancée d'elle-même après 1 s de diagnostic vert.
34	6. **Calibration** : 9 points (grille 3 × 3, marges 15 % / 14 %), par point 300 ms de stabilisation puis 800 ms de collecte (prolongeable à 2,5 s si les échantillons manquent, une reprise du point), échantillons ignorés pendant les clignements (seuil 0,5, garde 120 ms) et non finis, **agrégation robuste** (médiane par axe, rejet > 3,5 MAD, moyenne tronquée, ≥ 12 échantillons valides). Temps réel (horodatage des frames), jamais un nombre de frames.
35	7. **Vérification** : 5 cibles (centre, gauche, droite, haut, bas) mesurées avec le regard **calibré** ; erreur = distance en points divisée par la petite dimension du viewport. **Critère** : moyenne ≤ 18 % et maximum ≤ 30 %. Échec → « La précision peut être améliorée » avec Recalibrer (et Continuer quand même après un premier essai, profil marqué non validé).
36	8. **`Regard prêt`** : point menthe vivant qui suit le regard calibré, bouton Continuer.
37	9. **Persistance** (`CalibrationProfile`, JSON dans `UserDefaults`) : version du modèle, 6 coefficients, mapping d'axes, orientation, viewport, repère nominal utilisé, date, erreurs de vérification, validité. **Invalidation** : version différente, viewport différent de plus de 1 %, orientation différente, profil non validé, âge > 30 jours, transformée non finie. Lancements suivants : diagnostic → vérification 5 points (revalidation) → jeu ; échec → calibration complète.
38	10. **Recalibration** : bouton « Recalibrer le regard » dans le menu pause ; le jeu est suspendu (progression conservée), le parcours diagnostic → calibration → vérification s'exécute, puis le jeu reprend avec le nouveau profil.
39	11. **Lissage** : inchangé (`GazeFilter`, alpha 0,1, rejet des sauts > 300 pt sauf 3 consécutifs), appliqué **après** calibration et conversion en points, uniquement pendant `playing`.
40	12. **Perte de visage** : après 0,3 s sans visage pendant la partie, phase `faceLost` (boucle arrêtée, crescendos coupés), reprise automatique au retour du visage. Aucun point périmé n'est réutilisé.
41	13. **Diagnostic visuel** : « Afficher les points de regard » (menu pause et écrans de calibration) : corail = brut nominal, menthe = calibré non lissé, ambre = curseur lissé du jeu. Le réglage « miroir » a été supprimé.
42	14. **Logs** (`os.Logger`, sous-systèmes `net.steve-s.iris`, catégories `gaze`, `calibration`, `game`) : orientation, viewport, états AR, axes résolus, résidus de calibration, erreurs de vérification, chargement de profil. Aucune donnée faciale.
43	
44	## Fichiers modifiés ou créés
45	
46	Nouveaux : `AR/Calibration/{DeviceAxis, AxisMapping, NominalDisplayGeometry, NormalizedCoordinates, AffineTransform2D, RobustAggregator, FixationSequence, CalibrationGrid, CalibrationResult, CalibrationProfile, CalibrationStore, BlinkDetector, GazeMapper, GazeReadiness}.swift`, `AR/Projection/GazeRay.swift`, `AR/Services/InterfaceOrientationProvider.swift`, `Features/GazeSetup/ViewModels/{GazeSetupIntent, GazeSetupPhase, GazeSetupNavigating, GazeSetupViewModel}.swift`, `Features/GazeSetup/Views/{GazeSetupView, GazeReadinessView, FixationTargetView, GazeVerdictView}.swift`, `Features/Game/ViewModels/GazeCalibrationStatus.swift`, tests `Tests/IrisTests/AR/{AxisMapping, AffineTransform2D, RobustAggregator, FixationSequence, NormalizedCoordinates, CalibrationProfile, GazeMapper, GazeReadinessEvaluator}Tests.swift`, `Tests/IrisTests/Presentation/GazeSetupViewModelTests.swift`.
47	
48	Modifiés : `AR/Services/{GazeTrackingService, ARKitGazeTrackingService, SimulatedGazeTrackingService}.swift`, `Features/Game/ViewModels/{GameViewModel, GamePhase, GameSettingsStore, GameNavigating}.swift`, `Features/Game/Rendering/{GameSceneSnapshot, GameSceneRenderer}.swift`, `Features/Game/Views/GameOverlayView.swift`, `Features/Home/HomeView.swift`, `Navigation/{AppRoute, AppCoordinator, RootView}.swift`, `App/DI/AppContainer.swift`, `App/Platform/LaunchOptions.swift`, `Domain/ValueObjects/Vector2.swift` (Codable), tests `GameViewModelTests`, `AppCoordinatorTests`, `MockGameNavigating`.
49	
50	Supprimés : `AR/Projection/GazeProjector.swift`, `AR/Projection/DisplayGeometry.swift`, `Tests/IrisTests/AR/GazeProjectorTests.swift`.
51	
52	## Tests
53	
54	Commande : `xcodebuild -project Iris.xcodeproj -scheme Iris -destination 'platform=iOS Simulator,name=iPhone 17 Pro' -configuration Debug test`
55	
56	Résultat réel (11 septembre 2026) : `Test run with 185 tests in 27 suites passed after 0.544 seconds`, `** TEST SUCCEEDED **`.
57	
58	| Exécutés | Réussis | Échoués | Ignorés |
59	|---|---|---|---|
60	| 185 | 185 | 0 | 0 |
61	
62	Nouveaux tests (69) : `AxisMappingTests` (8), `AffineTransform2DTests` (10), `RobustAggregatorTests` (4), `FixationSequenceTests` (6), `NormalizedCoordinatesTests` (4), `CalibrationProfileTests` (5), `GazeMapperTests` (8), `GazeReadinessEvaluatorTests` (7), `GazeSetupViewModelTests` (10), et les cas ajoutés à `GameViewModelTests` (profil appliqué, visage perdu, recalibration, propriété du tracker partagé) et `AppCoordinatorTests` (setup premier lancement / revalidation, complétion, annulation, recalibration aller-retour). Tous les anciens tests du moteur (physique, validation 0,75 s, séquence, cascade, progression, niveaux, traces golden) passent sans modification.
63	
64	## Builds
65	
66	| Build | Commande | Résultat réel |
67	|---|---|---|
68	| Debug simulateur | `xcodebuild … -destination 'platform=iOS Simulator,name=iPhone 17 Pro' -configuration Debug build` | `** BUILD SUCCEEDED **`, 0 warning de notre code |
69	| Release simulateur | `… -configuration Release build` | `** BUILD SUCCEEDED **` |
70	| Debug appareil arm64 | `… -destination 'generic/platform=iOS' -configuration Debug build CODE_SIGNING_ALLOWED=NO` | `** BUILD SUCCEEDED **` |
71	| Release appareil arm64 | `… -destination 'generic/platform=iOS' -configuration Release build CODE_SIGNING_ALLOWED=NO` | `** BUILD SUCCEEDED **` |
72	| Audit de couches | `python3 Tools/audit.py` | pass, 138 fichiers |
73	
74	Un iPhone 14 Pro appairé est visible (`xcrun xctrace list devices`) ; aucune installation ni exécution n'a été réalisée dessus. `[compilation appareil réussie]` n'est pas `[calibration TrueDepth validée humainement]`.
75	
76	## Ce qui est maintenant vérifié
77	
78	`[vérifié automatiquement]`
79	- Intersection rayon / plan sans hypothèse de côté ; rejet des rayons qui s'éloignent et des valeurs non finies.
80	- Résolution des axes pour un repère standard, retourné de 180°, miroir, pivoté de 90°, gravité dégénérée (repli visage), directions dégénérées ou conflictuelles, vote majoritaire.
81	- Modèle affine : identité, offsets X/Y, échelles X/Y, combinaison avec cisaillement et inversion, miroir corrigé, récupération sur données bruitées, résidus, refus (< 3 points, non fini, colinéaire).
82	- Agrégation robuste (médiane, MAD, rejet d'outliers, non finis), détection des clignements avec garde.
83	- Protocole de fixation temps réel : stabilisation, collecte, prolongation, reprise, échec, complétion.
84	- Coordonnées normalisées (coins, centre, plusieurs viewports, erreur relative à la petite dimension).
85	- Persistance (mémoire et UserDefaults), compatibilité (version, validité, orientation, viewport ± 1 %, âge).
86	- Readiness : dix contrôles, états en attente / réussi / bloqué.
87	- Machine d'états du setup : readiness → calibration → vérification → prêt ; biais appris (30 pt, −20 pt) ; regard miroir corrigé (coefficient négatif) ; verdict insuffisant, recalibration, continuer quand même (profil non validé) ; revalidation sans calibration ; matériel / caméra ; clignements ignorés ; cycle de vie ; annulation.
88	- Jeu : profil appliqué au curseur, perte de visage après 0,3 s et reprise automatique, recalibration depuis la pause, propriété du tracker partagé pendant les transitions.
89	- Navigation : premier lancement → setup, profil stocké → revalidation, complétion → tutoriel puis jeu, annulation → accueil, recalibration aller-retour.
90	
91	`[vérifié par compilation]`
92	- `ARKitGazeTrackingService` v2 (viewMatrix avec l'orientation réelle, yeux, lookAtPoint, gravité, blend shapes, logs), `WindowSceneOrientationProvider`, écrans du setup, overlay « visage perdu », menu pause avec recalibration. Exercés sur simulateur avec un regard scripté (captures des quatre étapes).
93	
94	`[nécessite validation sur iPhone TrueDepth]`
95	- Direction réelle du regard (le mapping d'axes résolu, la main du repère journalisée).
96	- Précision réelle après calibration (erreurs de vérification observées, pertinence des seuils 18 % / 30 %).
97	- Confort du protocole (durées 0,3 s + 0,8 s par cible, taille des cibles, 9 + 5 points).
98	- Comportement en lumière réelle, port de lunettes, distance, clignements réels.
99	
100	## Test humain à effectuer au retour de l'utilisateur
101	
102	Ouvrir `Iris.xcodeproj`, choisir l'iPhone, Run (signature automatique). Puis :
103	
104	1. **Sens normal** : tenir l'iPhone en portrait, caméra en haut, à 30–40 cm, sans le retourner.
105	2. **Diagnostic** : Commencer → autoriser la caméra → l'écran « diagnostic du regard » doit passer ses dix lignes au vert en fixant le point ; noter la ligne « Orientation du regard (droite = …, haut = …) ».
106	3. **Calibration** : suivre les 9 points des yeux sans bouger la tête (≈ 12 s), puis les 5 points de vérification (≈ 6 s).
107	4. **Centre** : sur « regard prêt », fixer le centre de l'écran : le point menthe doit s'y poser (à quelques millimètres près).
108	5. **Haut** : regarder le haut de l'écran : le point monte.
109	6. **Bas** : regarder le bas : le point descend.
110	7. **Gauche** : regarder le bord gauche : le point va à gauche.
111	8. **Droite** : regarder le bord droit : le point va à droite.
112	9. **Coins** : balayer les quatre coins : le point suit chaque coin sans inversion ni rotation.
113	10. **Partie réelle** : Continuer → tutoriel → Jouer ; regarder une sphère la repousse, regarder ailleurs la laisse rejoindre son cercle ; en pause, « Afficher les points de regard » montre corail (brut), menthe (calibré), ambre (curseur) ; « Recalibrer le regard » refait le parcours et revient au niveau en cours.
114	
115	Si l'étape 5, 6, 7 ou 8 est inversée, relever la ligne « Orientation du regard » du diagnostic et les logs `subsystem:net.steve-s.iris category:gaze` (Console) : ils indiquent le mapping résolu et la main du repère, ce qui permettra de corriger sans conjecture.
116	
117	
~~~~

#### 2026-09-14 16:35:18 +0200 (14:35:18Z) · TOOL CALL · Read
`4a1b6284` · `7fbb4333` · ligne 66 · sous-agent agent-a5504523198b6ab18

~~~~json
{
 "file_path": "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris/Docs/Features/Gaze.md"
}
~~~~

#### 2026-09-14 16:35:18 +0200 (14:35:18Z) · TOOL RESULT · Read
`4a1b6284` · `035485af` · ligne 67 · sous-agent agent-a5504523198b6ab18

~~~~text
1	# Feature: Gaze
2	
3	Status: implemented (device validation pending)
4	Priority: P0
5	Depends on: none
6	
7	## Job
8	When I open the app, I want to start playing in seconds, so I can avoid setup and calibration.
9	
10	## Screens
11	CameraAccessView (explain, requesting, denied, restricted). ViewModel: done. View: done.
12	UnavailableView (no face tracking). View: done.
13	GazeSetupView (readiness, calibrating, validating, insufficient, ready, failed). ViewModel: done. View: done.
14	
15	## Acceptance criteria
16	- AC-1 Given a device without ARFaceTracking support, when the journey begins, then the Unavailable screen is shown.
17	- AC-2 Given camera access not determined, when the journey begins, then the explanation screen is shown before the system prompt.
18	- AC-3 Given camera access denied or restricted, when the screen appears, then a Settings shortcut or an explanation is shown and the game does not start.
19	- AC-4 Given a tracked face, when frames arrive, then the look-at ray is intersected with the device plane in the real interface orientation, axes are resolved from the eyes and gravity, the profile's affine correction is applied and the result is smoothed with alpha 0.1 (R-13, R-16, R-17).
20	- AC-5 Given the face leaves the frame for 0.3 s while playing, when frames stop, then the game pauses itself and resumes when the face is back (R-22).
21	- AC-6 Given the first launch, when the gaze setup runs, then nine fixations are collected without taps, blinks excluded, and five control targets validate the correction before the game (R-18 to R-20).
22	- AC-7 Given a stored valid profile, when the app launches again, then only the diagnostic and the five-point verification run (R-21).
23	- AC-8 Given a poor verification, when the verdict is shown, then Recalibrer restarts the setup and no endless loop occurs.
24	
25	## Entities
26	GazeSample, GazeTrackingState, GazeViewport, DisplayGeometry.
27	
28	## Notes
29	Gaze Engine v2: no hard-coded orientation, sign, mirror, ppi or camera position on the calibrated path. The diagnostic dots (raw coral, calibrated mint) can be shown from the pause overlay. Human validation on a TrueDepth iPhone is still required (see GAZE_ENGINE_V2_REPORT.md).
30	
31	## Test coverage
32	AC-1 to AC-3: AppCoordinatorTests, CameraAccessViewModelTests. AC-4: GazeMapperTests, AxisMappingTests, GazeFilterTests. AC-5: GameViewModelTests. AC-6 to AC-8: GazeSetupViewModelTests, FixationSequenceTests, AffineTransform2DTests, RobustAggregatorTests, CalibrationProfileTests, GazeReadinessEvaluatorTests.
33	
~~~~

#### 2026-09-14 16:35:25 +0200 (14:35:25Z) · TOOL CALL · Read
`4a1b6284` · `6cb307ca` · ligne 71 · sous-agent agent-a5504523198b6ab18

~~~~json
{
 "file_path": "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris/Features/GazeSetup/ViewModels/GazeSetupViewModel.swift"
}
~~~~

#### 2026-09-14 16:35:25 +0200 (14:35:25Z) · TOOL RESULT · Read
`4a1b6284` · `d31670be` · ligne 72 · sous-agent agent-a5504523198b6ab18

~~~~text
1	// GazeSetupViewModel.swift
2	// Layer: Presentation
3	// Purpose: Runs diagnostic, nine-point calibration, five-point validation and persists the profile
4	
5	import Foundation
6	import Observation
7	import os
8	import simd
9	
10	@MainActor
11	@Observable
12	final class GazeSetupViewModel {
13	    private(set) var phase: GazeSetupPhase = .starting
14	    private(set) var gazeState: GazeTrackingState = .idle
15	    /// Live positions in normalized coordinates (diagnostic dots and the "Regard prêt" verification).
16	    private(set) var liveRaw: SIMD2<Double>?
17	    private(set) var liveCalibrated: SIMD2<Double>?
18	    let intent: GazeSetupIntent
19	
20	    var showsDiagnostics: Bool {
21	        get { settings.showsGazeIndicator }
22	        set { settings.showsGazeIndicator = newValue }
23	    }
24	
25	    var isSimulatedGaze: Bool { gaze is SimulatedGazeTrackingService }
26	
27	    /// Readiness must stay green this long before the calibration starts by itself.
28	    static let readinessHold: TimeInterval = 1.0
29	
30	    @ObservationIgnored private var bounds: PlayfieldBounds = .referencePhone
31	    @ObservationIgnored private var nominal: NominalDisplayGeometry?
32	    @ObservationIgnored private var mapper: GazeMapper?
33	    @ObservationIgnored private var evaluator = GazeReadinessEvaluator()
34	    @ObservationIgnored private var blinkDetector = BlinkDetector()
35	    @ObservationIgnored private var sequence: FixationSequence?
36	    @ObservationIgnored private var readySince: TimeInterval?
37	    @ObservationIgnored private var lastReportTime: TimeInterval = -1
38	    @ObservationIgnored private var attempts = 0
39	    @ObservationIgnored private var storedProfile: CalibrationProfile?
40	    @ObservationIgnored private var isPrepared = false
41	    @ObservationIgnored private var lastCalibration: CalibrationResult?
42	    /// True while this ViewModel owns the shared gaze tracker's callbacks (see GameViewModel.ownsGaze).
43	    @ObservationIgnored private var ownsGaze = false
44	
45	    @ObservationIgnored private let gaze: any GazeTrackingService
46	    @ObservationIgnored private let calibrationStore: any CalibrationStore
47	    @ObservationIgnored private let capabilities: any DeviceCapabilities
48	    @ObservationIgnored private let cameraAuthorization: any CameraAuthorizationService
49	    @ObservationIgnored private let orientation: any InterfaceOrientationProvider
50	    @ObservationIgnored private let settings: GameSettingsStore
51	    @ObservationIgnored private let criteria: GazeQualityCriteria
52	    @ObservationIgnored private let isPad: Bool
53	    @ObservationIgnored private weak var navigator: (any GazeSetupNavigating)?
54	    @ObservationIgnored private let logger = Logger(subsystem: "net.steve-s.iris", category: "calibration")
55	
56	    init(intent: GazeSetupIntent,
57	         gaze: any GazeTrackingService,
58	         calibrationStore: any CalibrationStore,
59	         capabilities: any DeviceCapabilities,
60	         cameraAuthorization: any CameraAuthorizationService,
61	         orientation: any InterfaceOrientationProvider,
62	         settings: GameSettingsStore,
63	         criteria: GazeQualityCriteria = GazeQualityCriteria(),
64	         isPad: Bool,
65	         navigator: any GazeSetupNavigating) {
66	        self.intent = intent
67	        self.gaze = gaze
68	        self.calibrationStore = calibrationStore
69	        self.capabilities = capabilities
70	        self.cameraAuthorization = cameraAuthorization
71	        self.orientation = orientation
72	        self.settings = settings
73	        self.criteria = criteria
74	        self.isPad = isPad
75	        self.navigator = navigator
76	    }
77	
78	    var viewport: PlayfieldBounds { bounds }
79	
80	    // MARK: Lifecycle
81	
82	    func prepare(width: Double, height: Double, displayScale: Double) {
83	        let newBounds = PlayfieldBounds(width: width, height: height)
84	        let geometry = NominalDisplayGeometry.estimate(viewport: newBounds, displayScale: displayScale, isPad: isPad)
85	        if isPrepared {
86	            gaze.updateViewport(GazeViewport(bounds: bounds, nominal: geometry))
87	            return
88	        }
89	        isPrepared = true
90	        bounds = newBounds
91	        nominal = geometry
92	        let orientationName = orientation.interfaceOrientation.irisName
93	        storedProfile = calibrationStore.load().flatMap { profile in
94	            profile.isCompatible(viewport: bounds, interfaceOrientation: orientationName, now: Date()) ? profile : nil
95	        }
96	        logger.info("setup \(String(describing: self.intent), privacy: .public) viewport \(width, format: .fixed(precision: 0))x\(height, format: .fixed(precision: 0)) orientation \(orientationName, privacy: .public) stored profile \(self.storedProfile != nil)")
97	        startTracking()
98	    }
99	
100	    func viewDisappeared() {
101	        guard ownsGaze else { return }
102	        teardown()
103	    }
104	
105	    func suspend() {
106	        guard isPrepared, ownsGaze, phase != .suspended else { return }
107	        gaze.pause()
108	        phase = .suspended
109	    }
110	
111	    func wake() {
112	        guard phase == .suspended else { return }
113	        startTracking()
114	    }
115	
116	    // MARK: Intents
117	
118	    /// Restarts the whole setup from the diagnostic (after a failure or a poor validation).
119	    func recalibrate() {
120	        attempts += 1
121	        storedProfile = nil
122	        startTracking()
123	    }
124	
125	    /// Keeps a calibration that failed the quality criteria; the profile is stored as not validated.
126	    func continueAnyway() {
127	        guard case let .insufficient(result, _) = phase, let lastCalibration, let mapper else { return }
128	        saveProfile(transform: lastCalibration.transform, mapper: mapper, validation: result, isValid: false)
129	        finish()
130	    }
131	
132	    /// From "Regard prêt".
133	    func finish() {
134	        teardown()
135	        navigator?.gazeSetupCompleted(intent: intent)
136	    }
137	
138	    func cancel() {
139	        teardown()
140	        navigator?.gazeSetupCancelled(intent: intent)
141	    }
142	
143	    // MARK: Tracking
144	
145	    private func startTracking() {
146	        guard let nominal else { return }
147	        evaluator.reset()
148	        readySince = nil
149	        sequence = nil
150	        liveRaw = nil
151	        liveCalibrated = nil
152	        mapper = GazeMapper(viewport: bounds, nominal: nominal)
153	        phase = .starting
154	        ownsGaze = true
155	        gaze.onStateChange = { [weak self] state in self?.handleGazeState(state) }
156	        gaze.onSample = { [weak self] sample in self?.handleSample(sample) }
157	        gazeState = gaze.state
158	        gaze.start(viewport: GazeViewport(bounds: bounds, nominal: nominal))
159	        simulateFixation(at: SIMD2(0.5, 0.5))
160	    }
161	
162	    private func teardown() {
163	        guard ownsGaze else { return }
164	        ownsGaze = false
165	        gaze.onSample = nil
166	        gaze.onStateChange = nil
167	        gaze.stop()
168	    }
169	
170	    private func handleGazeState(_ state: GazeTrackingState) {
171	        gazeState = state
172	        switch state {
173	        case .tracking:
174	            if phase == .starting {
175	                publishReadiness(now: gaze.latestSample?.timestamp ?? 0, force: true)
176	            }
177	        case .interrupted:
178	            if case .readiness = phase { return }
179	            if case .starting = phase { return }
180	            // A fixation in progress cannot survive an interruption: back to the diagnostic.
181	            startTracking()
182	        case let .unavailable(reason):
183	            phase = .failed(Self.failure(for: reason))
184	        case let .failed(message):
185	            phase = .failed(.trackingError(message: message))
186	        case .idle, .starting:
187	            break
188	        }
189	    }
190	
191	    private func handleSample(_ sample: RawGazeSample) {
192	        guard let mapper else { return }
193	        let isBlinking = blinkDetector.isBlinking(left: sample.blinkLeft, right: sample.blinkRight, at: sample.timestamp)
194	        updateLive(sample, mapper: mapper)
195	        switch phase {
196	        case .starting, .readiness:
197	            evaluator.ingest(sample)
198	            publishReadiness(now: sample.timestamp, force: false)
199	        case .calibrating:
200	            feedSequence(sample: mapper.nominalNormalized(sample), isUsable: !isBlinking, at: sample.timestamp, mapper: mapper)
201	        case .validating:
202	            feedSequence(sample: mapper.calibratedNormalized(sample), isUsable: !isBlinking, at: sample.timestamp, mapper: mapper)
203	        case .insufficient, .ready, .suspended, .failed:
204	            break
205	        }
206	    }
207	
208	    private func updateLive(_ sample: RawGazeSample, mapper: GazeMapper) {
209	        let wantsLive: Bool
210	        switch phase {
211	        case .ready: wantsLive = true
212	        default: wantsLive = settings.showsGazeIndicator
213	        }
214	        guard wantsLive else {
215	            if liveRaw != nil { liveRaw = nil; liveCalibrated = nil }
216	            return
217	        }
218	        liveRaw = mapper.nominalNormalized(sample)
219	        liveCalibrated = mapper.calibratedNormalized(sample)
220	    }
221	
222	    // MARK: Readiness
223	
224	    private func publishReadiness(now: TimeInterval, force: Bool) {
225	        guard let nominal else { return }
226	        guard force || now - lastReportTime >= 0.1 else { return }
227	        lastReportTime = now
228	        let report = evaluator.report(supportsFaceTracking: capabilities.supportsFaceTracking,
229	                                      cameraAuthorized: cameraAuthorization.currentStatus() == .authorized,
230	                                      trackingState: gazeState, nominal: nominal, viewport: bounds)
231	        if report.isBlocked {
232	            if !capabilities.supportsFaceTracking {
233	                phase = .failed(.faceTrackingUnsupported)
234	            } else {
235	                phase = .failed(cameraAuthorization.currentStatus() == .restricted ? .cameraRestricted : .cameraDenied)
236	            }
237	            return
238	        }
239	        if case let .readiness(previous) = phase, previous == report {
240	            // unchanged
241	        } else {
242	            phase = .readiness(report)
243	        }
244	        if report.isReady {
245	            if readySince == nil { readySince = now }
246	            if let readySince, now - readySince >= Self.readinessHold, let mapping = report.axisMapping {
247	                beginFixations(axisMapping: mapping)
248	            }
249	        } else {
250	            readySince = nil
251	        }
252	    }
253	
254	    // MARK: Fixations
255	
256	    private func beginFixations(axisMapping: AxisMapping) {
257	        guard let nominal else { return }
258	        logger.info("readiness passed, axes \(GazeReadinessEvaluator.describe(axisMapping), privacy: .public) right-handed \(axisMapping.isRightHanded)")
259	        if intent == .revalidate, let storedProfile, storedProfile.axisMapping == axisMapping {
260	            mapper = GazeMapper(viewport: bounds, profile: storedProfile)
261	            lastCalibration = CalibrationResult(transform: storedProfile.transform, residualMean: 0, residualMax: 0, pointCount: 0)
262	            startSequence(targets: CalibrationGrid.validation, validating: true)
263	        } else {
264	            mapper = GazeMapper(viewport: bounds, nominal: nominal, axisMapping: axisMapping)
265	            startSequence(targets: CalibrationGrid.nine, validating: false)
266	        }
267	    }
268	
269	    private func startSequence(targets: [SIMD2<Double>], validating: Bool) {
270	        var sequence = FixationSequence(targets: targets)
271	        let time = gaze.latestSample?.timestamp ?? 0
272	        _ = sequence.start(at: time)
273	        self.sequence = sequence
274	        publishFixation(validating: validating, at: time)
275	        simulateFixation(at: sequence.currentTarget)
276	    }
277	
278	    private func feedSequence(sample: SIMD2<Double>?, isUsable: Bool, at time: TimeInterval, mapper: GazeMapper) {
279	        guard var sequence else { return }
280	        let validating: Bool
281	        if case .validating = phase { validating = true } else { validating = false }
282	        let event = sequence.feed(sample: sample, isUsable: isUsable, at: time)
283	        self.sequence = sequence
284	        switch event {
285	        case .targetChanged:
286	            simulateFixation(at: sequence.currentTarget)
287	            publishFixation(validating: validating, at: time)
288	        case .targetMeasured, .none:
289	            publishFixation(validating: validating, at: time)
290	        case .completed:
291	            if validating {
292	                completeValidation(sequence: sequence, mapper: mapper)
293	            } else {
294	                completeCalibration(sequence: sequence, mapper: mapper)
295	            }
296	        case let .failed(failure):
297	            switch failure {
298	            case let .insufficientSamples(target):
299	                logger.error("fixation failed on target \(target)")
300	                phase = .failed(.insufficientSignal(target: target))
301	            }
302	        }
303	    }
304	
305	    private func publishFixation(validating: Bool, at time: TimeInterval) {
306	        guard let sequence, let target = sequence.currentTarget, let index = sequence.currentTargetIndex else { return }
307	        let display = FixationDisplay(target: target, index: index, count: sequence.targets.count,
308	                                      progress: sequence.progress(at: time), isCollecting: sequence.isCollecting)
309	        phase = validating ? .validating(display) : .calibrating(display)
310	    }
311	
312	    private func completeCalibration(sequence: FixationSequence, mapper: GazeMapper) {
313	        do {
314	            let result = try CalibrationResult.fit(pairs: sequence.pairs)
315	            lastCalibration = result
316	            var calibrated = mapper
317	            calibrated.calibration = result.transform
318	            self.mapper = calibrated
319	            logger.info("calibration fitted: residual mean \(result.residualMean, format: .fixed(precision: 4)) max \(result.residualMax, format: .fixed(precision: 4))")
320	            startSequence(targets: CalibrationGrid.validation, validating: true)
321	        } catch {
322	            logger.error("calibration fit failed: \(String(describing: error), privacy: .public)")
323	            phase = .failed(.fitFailed)
324	        }
325	    }
326	
327	    private func completeValidation(sequence: FixationSequence, mapper: GazeMapper) {
328	        let pairs = sequence.pairs.map { (measured: $0.raw, target: $0.target) }
329	        let result = ValidationResult(pairs: pairs, viewport: bounds)
330	        logger.info("validation: mean \(result.meanError, format: .fixed(precision: 3)) max \(result.maxError, format: .fixed(precision: 3)) accepted \(self.criteria.accepts(result))")
331	        guard let lastCalibration else {
332	            phase = .failed(.fitFailed)
333	            return
334	        }
335	        if criteria.accepts(result) {
336	            saveProfile(transform: lastCalibration.transform, mapper: mapper, validation: result, isValid: true)
337	            phase = .ready(result)
338	            simulateFixation(at: nil)
339	        } else {
340	            phase = .insufficient(result, attempts: attempts + 1)
341	        }
342	    }
343	
344	    private func saveProfile(transform: AffineTransform2D, mapper: GazeMapper, validation: ValidationResult, isValid: Bool) {
345	        let profile = CalibrationProfile(transform: transform,
346	                                         axisMapping: mapper.axisMapping,
347	                                         interfaceOrientation: orientation.interfaceOrientation.irisName,
348	                                         viewport: bounds,
349	                                         nominalGeometry: mapper.nominal,
350	                                         createdAt: Date(),
351	                                         validationMeanError: validation.meanError,
352	                                         validationMaxError: validation.maxError,
353	                                         isValid: isValid)
354	        calibrationStore.save(profile)
355	        logger.info("calibration profile saved (valid \(isValid))")
356	    }
357	
358	    private func simulateFixation(at target: SIMD2<Double>?) {
359	        (gaze as? SimulatedGazeTrackingService)?.simulateFixation(at: target)
360	    }
361	
362	    private static func failure(for reason: GazeUnavailabilityReason) -> GazeSetupFailure {
363	        switch reason {
364	        case .faceTrackingUnsupported: .faceTrackingUnsupported
365	        case .cameraDenied: .cameraDenied
366	        case .cameraRestricted: .cameraRestricted
367	        }
368	    }
369	}
370	
~~~~

#### 2026-09-14 16:35:26 +0200 (14:35:26Z) · TOOL CALL · Read
`4a1b6284` · `6f10ac7f` · ligne 73 · sous-agent agent-a5504523198b6ab18

~~~~json
{
 "file_path": "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris/Features/Game/ViewModels/GameViewModel.swift"
}
~~~~

#### 2026-09-14 16:35:26 +0200 (14:35:26Z) · TOOL RESULT · Read
`4a1b6284` · `6276eee1` · ligne 74 · sous-agent agent-a5504523198b6ab18

~~~~text
1	// GameViewModel.swift
2	// Layer: Presentation
3	// Purpose: Owns one play session: campaign level, engine loop, gaze mapping, hints, audio, haptics, results and phases
4	
5	import Foundation
6	import Observation
7	import os
8	
9	@MainActor
10	@Observable
11	final class GameViewModel {
12	    // Coarse state read by HUD and overlays.
13	    private(set) var phase: GamePhase = .initializing
14	    private(set) var level: LevelDefinition
15	    private(set) var chapter: ChapterDefinition
16	    private(set) var hint: String?
17	    private(set) var gazeState: GazeTrackingState = .idle
18	    private(set) var audioStatus: AudioStatus = .inactive
19	    private(set) var calibrationStatus: GazeCalibrationStatus = .uncalibrated
20	
21	    // Per-frame state read by the canvas only.
22	    private(set) var snapshot: GameSceneSnapshot
23	
24	    var showsGazeIndicator: Bool {
25	        get { settings.showsGazeIndicator }
26	        set {
27	            settings.showsGazeIndicator = newValue
28	            refreshSnapshot()
29	        }
30	    }
31	
32	    var isSimulatedGaze: Bool { gaze is SimulatedGazeTrackingService }
33	
34	    /// Face absence tolerated while playing before the game pauses itself (the reference engine's FACE_LOST_TIMEOUT).
35	    static let faceLostTimeout: TimeInterval = 0.3
36	    /// Seconds before the route help or the empty-space advice appears.
37	    static let helpDelay: TimeInterval = 45
38	
39	    @ObservationIgnored private var bounds: PlayfieldBounds = .referencePhone
40	    @ObservationIgnored private var resolved: ResolvedLevel
41	    @ObservationIgnored private var session: GameSession
42	    @ObservationIgnored private var hints: HintTracker
43	    @ObservationIgnored private var hintsBegun = false
44	    @ObservationIgnored private var showsRoute = false
45	    @ObservationIgnored private var nominal: NominalDisplayGeometry?
46	    @ObservationIgnored private var mapper: GazeMapper?
47	    @ObservationIgnored private var diagnostics = GazeDiagnostics()
48	    @ObservationIgnored private var cuePolicy = AudioCuePolicy()
49	    @ObservationIgnored private var hapticPolicy = HapticCuePolicy()
50	    @ObservationIgnored private var levelInProgress = false
51	    @ObservationIgnored private var phaseBeforeSuspension: GamePhase?
52	    @ObservationIgnored private var isPrepared = false
53	    @ObservationIgnored private var faceLostDuration: TimeInterval = 0
54	    @ObservationIgnored private var sampleCounter = 0
55	    /// True while this ViewModel owns the shared gaze tracker's callbacks. Cleared by teardown so that a late
56	    /// `onDisappear` (SwiftUI transitions overlap) never stops a session another screen has just started.
57	    @ObservationIgnored private var ownsGaze = false
58	
59	    @ObservationIgnored private let gaze: any GazeTrackingService
60	    @ObservationIgnored private let audio: any AudioService
61	    @ObservationIgnored private let haptics: any HapticFeedbackService
62	    @ObservationIgnored private let clock: any GameClock
63	    @ObservationIgnored private let settings: GameSettingsStore
64	    @ObservationIgnored private let calibrationStore: any CalibrationStore
65	    @ObservationIgnored private let orientation: any InterfaceOrientationProvider
66	    @ObservationIgnored private let isPad: Bool
67	    @ObservationIgnored private let autoplay: Bool
68	    @ObservationIgnored private weak var navigator: (any GameNavigating)?
69	    @ObservationIgnored private let logger = Logger(subsystem: "net.steve-s.iris", category: "game")
70	    #if DEBUG
71	    /// PROTOTYPE (chapter I level 6): observation-only trace; nil for every other level. Never steers the game.
72	    @ObservationIgnored private(set) var oculoTrace: OculomotorTrace?
73	    /// One DEBUG line for the HUD diagnostics (shown only with the gaze indicator).
74	    private(set) var oculoStatus: String?
75	    /// Chapter X final: the JSON Lines capture, only when the app was launched with `--iris-capture`.
76	    @ObservationIgnored private var ancreCapture: AncreCapture?
77	    #endif
78	
79	    init(level: LevelDefinition,
80	         gaze: any GazeTrackingService,
81	         audio: any AudioService,
82	         haptics: any HapticFeedbackService,
83	         clock: any GameClock,
84	         settings: GameSettingsStore,
85	         calibrationStore: any CalibrationStore,
86	         orientation: any InterfaceOrientationProvider,
87	         isPad: Bool,
88	         autoplay: Bool = false,
89	         navigator: any GameNavigating) {
90	        let chapter = Self.chapter(of: level)
91	        self.level = level
92	        self.chapter = chapter
93	        let resolved = LevelResolver.resolve(level, in: .referencePhone)
94	        let session = resolved.makeSession()
95	        self.resolved = resolved
96	        self.session = session
97	        self.hints = HintTracker.forLevel(level, helpDelay: Self.helpDelay)
98	        self.snapshot = GameSceneSnapshot(session: session, resolved: resolved, showsRoute: false,
99	                                          showsGaze: settings.showsGazeIndicator, diagnostics: nil, theme: chapter.theme)
100	        self.gaze = gaze
101	        self.audio = audio
102	        self.haptics = haptics
103	        self.clock = clock
104	        self.settings = settings
105	        self.calibrationStore = calibrationStore
106	        self.orientation = orientation
107	        self.isPad = isPad
108	        self.autoplay = autoplay
109	        self.navigator = navigator
110	    }
111	
112	    // MARK: Lifecycle
113	
114	    /// Called by the view once its size is known. Builds the gaze mapper, loads the level, starts tracking and audio.
115	    func prepare(width: Double, height: Double, displayScale: Double) {
116	        let newBounds = PlayfieldBounds(width: width, height: height)
117	        let geometry = NominalDisplayGeometry.estimate(viewport: newBounds, displayScale: displayScale, isPad: isPad)
118	        if isPrepared {
119	            gaze.updateViewport(GazeViewport(bounds: bounds, nominal: geometry))
120	            return
121	        }
122	        isPrepared = true
123	        bounds = newBounds
124	        nominal = geometry
125	        reloadCalibration()
126	        loadLevel(level)
127	        wireServices()
128	        phase = .initializing
129	        gaze.start(viewport: GazeViewport(bounds: bounds, nominal: geometry))
130	        activateAudio()
131	    }
132	
133	    /// Rebuilds the mapper from the stored profile (after a recalibration or at start).
134	    func reloadCalibration() {
135	        guard let nominal else { return }
136	        let orientationName = orientation.interfaceOrientation.irisName
137	        if let profile = calibrationStore.load(), profile.isUsable(viewport: bounds, interfaceOrientation: orientationName) {
138	            mapper = GazeMapper(viewport: bounds, profile: profile)
139	            calibrationStatus = .calibrated(meanError: profile.validationMeanError, isValid: profile.isValid)
140	            logger.info("calibration loaded: valid \(profile.isValid)")
141	        } else {
142	            mapper = GazeMapper(viewport: bounds, nominal: nominal)
143	            calibrationStatus = .uncalibrated
144	            logger.info("no usable calibration, nominal mapping in use")
145	        }
146	    }
147	
148	    func viewDisappeared() {
149	        guard ownsGaze else { return }
150	        teardown()
151	    }
152	
153	    // MARK: Player intents
154	
155	    /// Tap on the scene or the main button: starts, resumes or moves on depending on the phase.
156	    func primaryAction() {
157	        switch phase {
158	        case .ready, .paused, .resuming:
159	            play()
160	        case let .levelComplete(result):
161	            if result.isCampaignEnd {
162	                finishCampaign()
163	            } else if result.hasNextLevel {
164	                playNext()
165	            } else {
166	                openChapters()
167	            }
168	        case .initializing, .playing, .interrupted, .faceLost, .suspended, .failed:
169	            break
170	        }
171	    }
172	
173	    func pause() {
174	        guard phase == .playing else { return }
175	        haltLoop()
176	        phase = .paused
177	    }
178	
179	    func restartLevel() {
180	        guard phase == .paused || phase == .playing || phase == .resuming else { return }
181	        haltLoop()
182	        loadLevel(level)
183	        phase = .ready
184	    }
185	
186	    func replay() {
187	        guard case .levelComplete = phase else { return }
188	        loadLevel(level)
189	        phase = .ready
190	    }
191	
192	    func playNext() {
193	        guard case .levelComplete = phase, let next = Self.next(after: level) else { return }
194	        let chapterChanged = next.chapter != level.chapter
195	        loadLevel(next)
196	        if chapterChanged && settings.ambienceEnabled {
197	            audio.apply(.ambient(frequency: chapter.ambientFrequency))
198	        }
199	        phase = .ready
200	    }
201	
202	    func openChapters() {
203	        teardown()
204	        navigator?.gameDidRequestChapters()
205	    }
206	
207	    func retryAfterFailure() {
208	        guard case .failed = phase, let nominal else { return }
209	        phase = .initializing
210	        if !ownsGaze { wireServices() }
211	        gaze.start(viewport: GazeViewport(bounds: bounds, nominal: nominal))
212	        activateAudio()
213	    }
214	
215	    func exit() {
216	        teardown()
217	        navigator?.gameDidRequestExit()
218	    }
219	
220	    /// Leaves the game screen for the gaze setup (recalibration) and keeps the level.
221	    func requestRecalibration() {
222	        guard phase == .paused else { return }
223	        phaseBeforeSuspension = .paused
224	        haltLoop()
225	        releaseGaze()
226	        deactivateAudio()
227	        phase = .suspended
228	        navigator?.gameDidRequestRecalibration()
229	    }
230	
231	    /// Back from the gaze setup: reload the profile and restart tracking.
232	    func resumeAfterRecalibration() {
233	        guard phase == .suspended, let nominal else { return }
234	        reloadCalibration()
235	        wireServices()
236	        phase = .initializing
237	        gaze.start(viewport: GazeViewport(bounds: bounds, nominal: nominal))
238	        activateAudio()
239	    }
240	
241	    /// Simulator and previews only: the pointer plays the role of the gaze.
242	    func simulatePointer(x: Double, y: Double, timestamp: TimeInterval) {
243	        (gaze as? SimulatedGazeTrackingService)?.inject(point: Vector2(x: x, y: y), timestamp: timestamp)
244	    }
245	
246	    // MARK: Scene phase
247	
248	    func suspend() {
249	        guard isPrepared, phase != .suspended, !isFailed else { return }
250	        phaseBeforeSuspension = phase
251	        haltLoop()
252	        gaze.pause()
253	        deactivateAudio()
254	        phase = .suspended
255	    }
256	
257	    func wake() {
258	        guard phase == .suspended, let nominal else { return }
259	        phase = .initializing
260	        if ownsGaze {
261	            gaze.resume()
262	        } else {
263	            wireServices()
264	            gaze.start(viewport: GazeViewport(bounds: bounds, nominal: nominal))
265	        }
266	        activateAudio()
267	    }
268	
269	    // MARK: Loop
270	
271	    private func play() {
272	        phase = .playing
273	        levelInProgress = true
274	        faceLostDuration = 0
275	        seedCursorIfNeeded()
276	        if !hintsBegun {
277	            hintsBegun = true
278	            hints.begin()
279	            hint = hints.current
280	        }
281	        clock.start { [weak self] deltaTime in
282	            self?.tick(deltaTime)
283	        }
284	    }
285	
286	    /// Samples already flow before the first tap, so the cursor starts exactly at the current gaze.
287	    private func seedCursorIfNeeded() {
288	        guard !session.gaze.isActive, let sample = gaze.latestSample, let point = mapper?.screenPoint(sample) else { return }
289	        session.placeGaze(at: point)
290	        refreshSnapshot()
291	    }
292	
293	    private func tick(_ deltaTime: TimeInterval) {
294	        guard phase == .playing else { return }
295	        if case .tracking(false) = gazeState {
296	            faceLostDuration += deltaTime
297	            if faceLostDuration >= Self.faceLostTimeout {
298	                haltLoop()
299	                phase = .faceLost
300	                #if DEBUG
301	                ancreCapture?.mark("faceLostWarning", session: session, phase: phase)
302	                #endif
303	                return
304	            }
305	        } else {
306	            faceLostDuration = 0
307	        }
308	        let events = session.advance(by: deltaTime)
309	        #if DEBUG
310	        oculoTrace?.observeTick(session: session, events: events)
311	        ancreCapture?.observeTick(session: session, phase: phase, events: events)
312	        #endif
313	        if settings.soundEffectsEnabled {
314	            for cue in cuePolicy.cues(for: events, at: session.elapsed) {
315	                audio.apply(cue)
316	            }
317	        }
318	        if settings.hapticsEnabled {
319	            for cue in hapticPolicy.cues(for: events, at: session.elapsed) {
320	                haptics.play(cue)
321	            }
322	        }
323	        if hints.observe(events: events, elapsed: session.elapsed) {
324	            hint = hints.current
325	        }
326	        if !showsRoute && level.requiresPushing && session.elapsed >= Self.helpDelay {
327	            showsRoute = true
328	        }
329	        refreshSnapshot()
330	        if events.contains(.levelCompleted) {
331	            completeLevel()
332	        }
333	    }
334	
335	    private func completeLevel() {
336	        haltLoop()
337	        #if DEBUG
338	        ancreCapture?.stop(reason: "level complete")
339	        #endif
340	        levelInProgress = false
341	        hint = nil
342	        let outcome = LevelOutcome(time: session.elapsed, intrusions: session.metrics.intrusions, losses: session.metrics.losses)
343	        let previous = navigator?.gameDidComplete(level: level, outcome: outcome) ?? LevelRecord()
344	        let earned = outcome.eclats(par: level.par)
345	        let next = Self.next(after: level)
346	        phase = .levelComplete(LevelResult(levelID: level.id,
347	                                           outcome: outcome,
348	                                           earned: earned,
349	                                           newlyEarned: earned.subtracting(previous.eclats),
350	                                           isNewBestTime: previous.bestTime.map { outcome.time < $0 } ?? false,
351	                                           hasNextLevel: next != nil,
352	                                           isChapterEnd: !level.isExperimental && Campaign.isLastInChapter(level),
353	                                           isCampaignEnd: !level.isExperimental && next == nil))
354	        logger.info("level \(self.level.id, privacy: .public) completed in \(outcome.time, format: .fixed(precision: 1)) s, intrusions \(outcome.intrusions), losses \(outcome.losses)")
355	    }
356	
357	    private func finishCampaign() {
358	        teardown()
359	        navigator?.gameDidFinishCampaign()
360	    }
361	
362	    /// Campaign chapters, plus the experimental chapter in DEBUG builds (prototype levels are never in the campaign).
363	    private static func chapter(of level: LevelDefinition) -> ChapterDefinition {
364	        if let chapter = Campaign.chapter(of: level) { return chapter }
365	        #if DEBUG
366	        if let chapter = BraisesPrototype.chapter(of: level) { return chapter }
367	        #endif
368	        return Campaign.chapters[0]
369	    }
370	
371	    private static func next(after level: LevelDefinition) -> LevelDefinition? {
372	        #if DEBUG
373	        if level.isExperimental { return BraisesPrototype.next(after: level) }
374	        #endif
375	        return Campaign.next(after: level)
376	    }
377	
378	    private func loadLevel(_ definition: LevelDefinition) {
379	        level = definition
380	        chapter = Self.chapter(of: definition)
381	        resolved = LevelResolver.resolve(definition, in: bounds)
382	        session = resolved.makeSession()
383	        hints = HintTracker.forLevel(definition, helpDelay: Self.helpDelay)
384	        hintsBegun = false
385	        hint = nil
386	        showsRoute = false
387	        cuePolicy.reset()
388	        hapticPolicy.reset()
389	        faceLostDuration = 0
390	        levelInProgress = false
391	        #if DEBUG
392	        if let balises = definition.balises {
393	            oculoTrace = OculomotorTrace(names: balises.balises.map(\.name))
394	        } else if let oculo = definition.oculo {
395	            oculoTrace = OculomotorTrace(names: oculo.stages.indices.map { "stage\($0 + 1)" })
396	        } else {
397	            oculoTrace = nil
398	        }
399	        oculoStatus = nil
400	        ancreCapture?.stop(reason: "another level")
401	        ancreCapture = AncreCapture(level: definition)
402	        #endif
403	        refreshSnapshot()
404	        navigator?.gameDidStart(level: definition)
405	    }
406	
407	    private func refreshSnapshot() {
408	        snapshot = GameSceneSnapshot(session: session, resolved: resolved, showsRoute: showsRoute,
409	                                     showsGaze: settings.showsGazeIndicator, diagnostics: diagnostics, theme: chapter.theme)
410	    }
411	
412	    /// Stops ticking and silences every crescendo voice; the scene stays as it is.
413	    private func haltLoop() {
414	        clock.stop()
415	        for voice in 0..<3 {
416	            audio.apply(.stopProgress(voice: voice))
417	        }
418	    }
419	
420	    private func fail(_ failure: GameFailure) {
421	        haltLoop()
422	        phase = .failed(failure)
423	    }
424	
425	    private func teardown() {
426	        haltLoop()
427	        #if DEBUG
428	        ancreCapture?.stop(reason: "left the game")
429	        #endif
430	        releaseGaze()
431	        deactivateAudio()
432	    }
433	
434	    private func releaseGaze() {
435	        guard ownsGaze else { return }
436	        ownsGaze = false
437	        gaze.onSample = nil
438	        gaze.onStateChange = nil
439	        gaze.stop()
440	    }
441	
442	    /// The engine runs when effects or ambience are wanted; the drone plays only if the ambience is wanted.
443	    private func activateAudio() {
444	        guard settings.wantsAudio else { return }
445	        audio.activate()
446	        if settings.ambienceEnabled {
447	            audio.apply(.ambient(frequency: chapter.ambientFrequency))
448	        }
449	    }
450	
451	    private func deactivateAudio() {
452	        audio.apply(.ambient(frequency: nil))
453	        audio.deactivate()
454	    }
455	
456	    // MARK: Services
457	
458	    private func wireServices() {
459	        ownsGaze = true
460	        gaze.onStateChange = { [weak self] state in
461	            self?.handleGazeState(state)
462	        }
463	        gaze.onSample = { [weak self] sample in
464	            self?.handleGazeSample(sample)
465	        }
466	        audio.onStatusChange = { [weak self] status in
467	            self?.audioStatus = status
468	        }
469	        audioStatus = audio.status
470	        gazeState = gaze.state
471	    }
472	
473	    private func handleGazeSample(_ sample: RawGazeSample) {
474	        guard let mapper else { return }
475	        let mapped = mapper.screenPoint(sample)
476	        #if DEBUG
477	        if let oculoTrace {
478	            oculoTrace.observeSample(mapped: mapped, sample: sample, bounds: bounds)
479	            if settings.showsGazeIndicator { oculoStatus = oculoTrace.statusLine }
480	        }
481	        if let ancreCapture {
482	            var faceTracked: Bool?
483	            if case let .tracking(visible) = gazeState { faceTracked = visible }
484	            ancreCapture.observeSample(session: session, phase: phase, faceTracked: faceTracked, observation: sample.observation,
485	                                       screenHead: sample.observation.map { Self.screenHead($0, mapping: mapper.axisMapping) }, mapped: mapped,
486	                                       gazeState: oculoTrace?.state.rawValue ?? (mapped == nil ? "INVALID" : "UNKNOWN"), bounds: bounds,
487	                                       timestamp: sample.timestamp)
488	        }
489	        #endif
490	        if settings.showsGazeIndicator {
491	            var edge: GazeDiagnostics.Edge?
492	            #if DEBUG
493	            edge = oculoTrace?.lastEdge.flatMap { GazeDiagnostics.Edge(rawValue: $0.rawValue.lowercased()) }
494	            #endif
495	            diagnostics = GazeDiagnostics(raw: mapper.rawScreenPoint(sample), calibrated: mapped, edge: edge)
496	            sampleCounter += 1
497	            if phase != .playing, sampleCounter.isMultiple(of: 3) {
498	                refreshSnapshot()
499	            }
500	        }
501	        guard phase == .playing, let point = mapped else { return }
502	        session.ingestGaze(point)
503	        // OCULOMOTOR EXPANSION: the stages that ask for the head read it from the same observation, oriented like the
504	        // screen by the calibration's axis mapping (the one that already places the gaze), so no axis sign is assumed.
505	        session.ingestHeadPose(sample.observation.map { Self.screenHead($0, mapping: mapper.axisMapping) })
506	    }
507	
508	    /// View-frame head angles in screen terms: yaw toward the screen's right as the player sees it, pitch toward its top.
509	    /// The mapping only swaps or flips the two in-plane axes, so the size of a head turn is unchanged.
510	    nonisolated static func screenHead(_ observation: GazeObservation, mapping: AxisMapping) -> HeadPose {
511	        let screen = mapping.screenCoordinates(of: SIMD2(observation.headYaw, observation.headPitch))
512	        return HeadPose(yaw: screen.x, pitch: screen.y)
513	    }
514	
515	    private func handleGazeState(_ state: GazeTrackingState) {
516	        gazeState = state
517	        switch state {
518	        case let .tracking(faceVisible):
519	            #if DEBUG
520	            oculoTrace?.observeFaceVisible(faceVisible)
521	            if settings.showsGazeIndicator, let oculoTrace { oculoStatus = oculoTrace.statusLine }
522	            ancreCapture?.mark(faceVisible ? "faceVisible" : "faceHidden", session: session, phase: phase, faceTracked: faceVisible)
523	            #endif
524	            if faceVisible {
525	                trackingBecameAvailable()
526	            }
527	        case .interrupted:
528	            if phase == .playing {
529	                haltLoop()
530	            }
531	            if phase == .playing || phase == .paused || phase == .ready || phase == .resuming || phase == .initializing || phase == .faceLost {
532	                phase = .interrupted
533	            }
534	        case let .unavailable(reason):
535	            fail(Self.failure(for: reason))
536	        case let .failed(message):
537	            fail(.trackingError(message: message))
538	        case .idle, .starting:
539	            break
540	        }
541	    }
542	
543	    private func trackingBecameAvailable() {
544	        switch phase {
545	        case .initializing:
546	            if let previous = phaseBeforeSuspension {
547	                phaseBeforeSuspension = nil
548	                phase = Self.phaseAfterReturn(from: previous, levelInProgress: levelInProgress)
549	            } else if autoplay {
550	                play()
551	            } else {
552	                phase = .ready
553	            }
554	        case .interrupted:
555	            phase = levelInProgress ? .resuming : .ready
556	        case .faceLost:
557	            play()
558	        case .ready, .playing, .paused, .levelComplete, .resuming, .suspended, .failed:
559	            break
560	        }
561	    }
562	
563	    private static func phaseAfterReturn(from previous: GamePhase, levelInProgress: Bool) -> GamePhase {
564	        switch previous {
565	        case .playing, .paused, .resuming, .interrupted, .faceLost:
566	            levelInProgress ? .resuming : .ready
567	        case let .levelComplete(result):
568	            .levelComplete(result)
569	        case .initializing, .ready, .suspended, .failed:
570	            .ready
571	        }
572	    }
573	
574	    private static func failure(for reason: GazeUnavailabilityReason) -> GameFailure {
575	        switch reason {
576	        case .faceTrackingUnsupported: .faceTrackingUnsupported
577	        case .cameraDenied: .cameraDenied
578	        case .cameraRestricted: .cameraRestricted
579	        }
580	    }
581	
582	    private var isFailed: Bool {
583	        if case .failed = phase { return true }
584	        return false
585	    }
586	}
587	
~~~~

#### 2026-09-14 16:35:27 +0200 (14:35:27Z) · TOOL CALL · Read
`4a1b6284` · `4ed4c1e3` · ligne 75 · sous-agent agent-a5504523198b6ab18

~~~~json
{
 "file_path": "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris/App/DI/AppContainer.swift"
}
~~~~

#### 2026-09-14 16:35:27 +0200 (14:35:27Z) · TOOL RESULT · Read
`4a1b6284` · `89d3c1c5` · ligne 76 · sous-agent agent-a5504523198b6ab18

~~~~text
1	// AppContainer.swift
2	// Layer: App (DI)
3	// Purpose: Composition root. The only place concrete services are chosen.
4	
5	import Foundation
6	
7	@MainActor
8	final class AppContainer {
9	    let environment: AppEnvironment
10	    let capabilities: any DeviceCapabilities
11	    let cameraAuthorization: any CameraAuthorizationService
12	    let settings: GameSettingsStore
13	    let calibrationStore: any CalibrationStore
14	    let progressStore: any ProgressStore
15	    let orientationProvider: any InterfaceOrientationProvider
16	    let isPad: Bool
17	    let launchOptions: LaunchOptions
18	
19	    /// One gaze tracker per process, shared by the setup and the game (one ARSession, started and stopped by each screen).
20	    private(set) lazy var gazeTracking: any GazeTrackingService = makeGazeTrackingService()
21	
22	    init(environment: AppEnvironment,
23	         capabilities: any DeviceCapabilities,
24	         cameraAuthorization: any CameraAuthorizationService,
25	         settings: GameSettingsStore,
26	         calibrationStore: any CalibrationStore,
27	         progressStore: any ProgressStore,
28	         orientationProvider: any InterfaceOrientationProvider,
29	         isPad: Bool,
30	         launchOptions: LaunchOptions = .none) {
31	        self.environment = environment
32	        self.capabilities = capabilities
33	        self.cameraAuthorization = cameraAuthorization
34	        self.settings = settings
35	        self.calibrationStore = calibrationStore
36	        self.progressStore = progressStore
37	        self.orientationProvider = orientationProvider
38	        self.isPad = isPad
39	        self.launchOptions = launchOptions
40	    }
41	
42	    /// The container used by the running app. On the simulator, gaze comes from the pointer (or a scripted oracle)
43	    /// because no TrueDepth camera exists there; on a device every service is real.
44	    static func live() -> AppContainer {
45	        #if DEBUG
46	        let launchOptions = LaunchOptions.parse(ProcessInfo.processInfo.arguments)
47	        #else
48	        let launchOptions = LaunchOptions.none
49	        #endif
50	        let progressStore: any ProgressStore = launchOptions.seededProgress.map {
51	            InMemoryProgressStore(progress: LaunchOptions.progress(for: $0))
52	        } ?? UserDefaultsProgressStore()
53	        #if targetEnvironment(simulator)
54	        return AppContainer(environment: .simulator,
55	                            capabilities: StaticDeviceCapabilities(supportsFaceTracking: true),
56	                            cameraAuthorization: StubCameraAuthorizationService(status: .authorized),
57	                            settings: GameSettingsStore(),
58	                            calibrationStore: UserDefaultsCalibrationStore(),
59	                            progressStore: progressStore,
60	                            orientationProvider: WindowSceneOrientationProvider(),
61	                            isPad: DeviceIdiom.isPad,
62	                            launchOptions: launchOptions)
63	        #else
64	        return AppContainer(environment: .live,
65	                            capabilities: ARKitDeviceCapabilities(),
66	                            cameraAuthorization: AVCaptureCameraAuthorizationService(),
67	                            settings: GameSettingsStore(),
68	                            calibrationStore: UserDefaultsCalibrationStore(),
69	                            progressStore: progressStore,
70	                            orientationProvider: WindowSceneOrientationProvider(),
71	                            isPad: DeviceIdiom.isPad,
72	                            launchOptions: launchOptions)
73	        #endif
74	    }
75	
76	    static func preview(supportsFaceTracking: Bool = true,
77	                        cameraStatus: CameraAuthorizationStatus = .authorized,
78	                        calibrationStore: any CalibrationStore = InMemoryCalibrationStore(),
79	                        progressStore: any ProgressStore = InMemoryProgressStore(),
80	                        launchOptions: LaunchOptions = .none) -> AppContainer {
81	        AppContainer(environment: .preview,
82	                     capabilities: StaticDeviceCapabilities(supportsFaceTracking: supportsFaceTracking),
83	                     cameraAuthorization: StubCameraAuthorizationService(status: cameraStatus),
84	                     settings: GameSettingsStore(defaults: UserDefaults(suiteName: "iris.preview.\(UUID().uuidString)") ?? .standard),
85	                     calibrationStore: calibrationStore,
86	                     progressStore: progressStore,
87	                     orientationProvider: FixedOrientationProvider(),
88	                     isPad: false,
89	                     launchOptions: launchOptions)
90	    }
91	
92	    // MARK: Services
93	
94	    private func makeGazeTrackingService() -> any GazeTrackingService {
95	        switch environment {
96	        case .live:
97	            ARKitGazeTrackingService(capabilities: capabilities, orientationProvider: orientationProvider)
98	        case .simulator, .preview:
99	            SimulatedGazeTrackingService(parkedPoint: launchOptions.parkedGaze, oracle: launchOptions.oracleGaze)
100	        }
101	    }
102	
103	    func makeAudioService() -> any AudioService {
104	        switch environment {
105	        case .live, .simulator: AVAudioEngineAudioService()
106	        case .preview: SilentAudioService()
107	        }
108	    }
109	
110	    func makeHapticFeedbackService() -> any HapticFeedbackService {
111	        switch environment {
112	        case .live, .simulator: UIKitHapticFeedbackService()
113	        case .preview: SilentHapticFeedbackService()
114	        }
115	    }
116	
117	    func makeGameClock() -> any GameClock {
118	        switch environment {
119	        case .live, .simulator: DisplayLinkGameClock()
120	        case .preview: ManualGameClock()
121	        }
122	    }
123	
124	    // MARK: Presentation
125	
126	    func makeAppCoordinator() -> AppCoordinator {
127	        AppCoordinator(container: self)
128	    }
129	
130	    func makeGameViewModel(level: LevelDefinition, navigator: any GameNavigating) -> GameViewModel {
131	        GameViewModel(level: level,
132	                      gaze: gazeTracking,
133	                      audio: makeAudioService(),
134	                      haptics: makeHapticFeedbackService(),
135	                      clock: makeGameClock(),
136	                      settings: settings,
137	                      calibrationStore: calibrationStore,
138	                      orientation: orientationProvider,
139	                      isPad: isPad,
140	                      autoplay: launchOptions.autoplay,
141	                      navigator: navigator)
142	    }
143	
144	    func makeCameraAccessViewModel(navigator: any CameraAccessNavigating) -> CameraAccessViewModel {
145	        CameraAccessViewModel(authorization: cameraAuthorization, navigator: navigator)
146	    }
147	
148	    func makeGazeSetupViewModel(intent: GazeSetupIntent, navigator: any GazeSetupNavigating) -> GazeSetupViewModel {
149	        GazeSetupViewModel(intent: intent,
150	                           gaze: gazeTracking,
151	                           calibrationStore: calibrationStore,
152	                           capabilities: capabilities,
153	                           cameraAuthorization: cameraAuthorization,
154	                           orientation: orientationProvider,
155	                           settings: settings,
156	                           isPad: isPad,
157	                           navigator: navigator)
158	    }
159	}
160	
~~~~

#### 2026-09-14 16:35:28 +0200 (14:35:28Z) · TOOL CALL · Read
`4a1b6284` · `658a3b3c` · ligne 77 · sous-agent agent-a5504523198b6ab18

~~~~json
{
 "file_path": "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris/App/Platform/DisplayLinkGameClock.swift"
}
~~~~

#### 2026-09-14 16:35:28 +0200 (14:35:28Z) · TOOL RESULT · Read
`4a1b6284` · `a6024146` · ligne 78 · sous-agent agent-a5504523198b6ab18

~~~~text
1	// DisplayLinkGameClock.swift
2	// Layer: App (platform adapter)
3	// Purpose: CADisplayLink clock pinned to 60 Hz, the rate the reference engine was validated at
4	
5	import Foundation
6	import QuartzCore
7	
8	@MainActor
9	final class DisplayLinkGameClock: GameClock {
10	    private(set) var isRunning = false
11	    private var link: CADisplayLink?
12	    private var lastTimestamp: CFTimeInterval?
13	    private var onTick: (@MainActor (TimeInterval) -> Void)?
14	    private let preferredFrameRate: Float
15	
16	    init(preferredFrameRate: Float = 60) {
17	        self.preferredFrameRate = preferredFrameRate
18	    }
19	
20	    func start(_ onTick: @escaping @MainActor (TimeInterval) -> Void) {
21	        stop()
22	        self.onTick = onTick
23	        let proxy = DisplayLinkProxy(owner: self)
24	        let link = CADisplayLink(target: proxy, selector: #selector(DisplayLinkProxy.step(_:)))
25	        link.preferredFrameRateRange = CAFrameRateRange(minimum: preferredFrameRate, maximum: preferredFrameRate, preferred: preferredFrameRate)
26	        link.add(to: .main, forMode: .common)
27	        self.link = link
28	        isRunning = true
29	    }
30	
31	    func stop() {
32	        link?.invalidate()
33	        link = nil
34	        lastTimestamp = nil
35	        onTick = nil
36	        isRunning = false
37	    }
38	
39	    fileprivate func step(timestamp: CFTimeInterval, duration: CFTimeInterval) {
40	        let delta = lastTimestamp.map { timestamp - $0 } ?? duration
41	        lastTimestamp = timestamp
42	        onTick?(delta)
43	    }
44	}
45	
46	/// Breaks the retain cycle CADisplayLink would otherwise create with its target.
47	@MainActor
48	private final class DisplayLinkProxy: NSObject {
49	    private weak var owner: DisplayLinkGameClock?
50	
51	    init(owner: DisplayLinkGameClock) {
52	        self.owner = owner
53	    }
54	
55	    @objc func step(_ link: CADisplayLink) {
56	        guard let owner else {
57	            link.invalidate()
58	            return
59	        }
60	        owner.step(timestamp: link.timestamp, duration: link.duration)
61	    }
62	}
63	
~~~~

#### 2026-09-14 16:35:28 +0200 (14:35:28Z) · TOOL CALL · Read
`4a1b6284` · `b1161e5c` · ligne 79 · sous-agent agent-a5504523198b6ab18

~~~~json
{
 "file_path": "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris/AR/Services/SimulatedGazeTrackingService.swift"
}
~~~~

#### 2026-09-14 16:35:28 +0200 (14:35:28Z) · TOOL RESULT · Read
`4a1b6284` · `0f791ee8` · ligne 80 · sous-agent agent-a5504523198b6ab18

~~~~text
1	// SimulatedGazeTrackingService.swift
2	// Layer: AR
3	// Purpose: Pointer-driven or scripted gaze for the simulator, previews and tests (no camera involved)
4	
5	import Foundation
6	import simd
7	
8	@MainActor
9	final class SimulatedGazeTrackingService: GazeTrackingService {
10	    private(set) var state: GazeTrackingState = .idle {
11	        didSet { if state != oldValue { onStateChange?(state) } }
12	    }
13	    private(set) var latestSample: RawGazeSample?
14	    var onStateChange: (@MainActor (GazeTrackingState) -> Void)?
15	    var onSample: (@MainActor (RawGazeSample) -> Void)?
16	
17	    /// Simulated physical geometry: the eyes 35 cm in front of the camera, 6.3 cm apart, device upright.
18	    static let eyeOrigin = SIMD3<Double>(0, 0, -0.35)
19	    static let eyeSeparation = 0.063
20	
21	    private var viewport: GazeViewport?
22	    private let startsUnavailable: GazeUnavailabilityReason?
23	    private let parkedPoint: Vector2?
24	    private let oracle: Bool
25	    private var fixation: SIMD2<Double>?
26	    private var timer: Timer?
27	    private var tick = 0
28	
29	    /// - oracle: emits samples at the fixation target set through `simulateFixation`, 60 times per second,
30	    ///   so that the calibration flow can be exercised without a face.
31	    init(startsUnavailable: GazeUnavailabilityReason? = nil, parkedPoint: Vector2? = nil, oracle: Bool = false) {
32	        self.startsUnavailable = startsUnavailable
33	        self.parkedPoint = parkedPoint
34	        self.oracle = oracle
35	    }
36	
37	    func start(viewport: GazeViewport) {
38	        self.viewport = viewport
39	        if let startsUnavailable {
40	            state = .unavailable(startsUnavailable)
41	            return
42	        }
43	        if let parkedPoint {
44	            latestSample = makeSample(point: parkedPoint, timestamp: 0)
45	        }
46	        state = .tracking(faceVisible: true)
47	        if oracle { startOracle() }
48	    }
49	
50	    func pause() {
51	        stopOracle()
52	        state = .idle
53	    }
54	
55	    func resume() {
56	        guard viewport != nil else { return }
57	        state = startsUnavailable.map { .unavailable($0) } ?? .tracking(faceVisible: true)
58	        if oracle, case .tracking = state { startOracle() }
59	    }
60	
61	    func stop() {
62	        stopOracle()
63	        state = .idle
64	        latestSample = nil
65	    }
66	
67	    func updateViewport(_ viewport: GazeViewport) {
68	        self.viewport = viewport
69	    }
70	
71	    /// Injects a pointer position as if it were a gaze sample.
72	    func inject(point: Vector2, timestamp: TimeInterval) {
73	        guard case .tracking = state else { return }
74	        emit(makeSample(point: point, timestamp: timestamp))
75	    }
76	
77	    /// Oracle mode: the simulated gaze fixates this normalized target (nil parks it on the last one).
78	    func simulateFixation(at normalized: SIMD2<Double>?) {
79	        fixation = normalized
80	    }
81	
82	    /// Test hook to drive the state machine (interruptions, failures).
83	    func simulate(state newState: GazeTrackingState) {
84	        state = newState
85	    }
86	
87	    /// Builds a raw sample whose nominal mapping lands exactly on `point`.
88	    func makeSample(point: Vector2, timestamp: TimeInterval, blinkLeft: Double = 0, blinkRight: Double = 0) -> RawGazeSample {
89	        let viewport = self.viewport ?? GazeViewport(bounds: .referencePhone,
90	                                                     nominal: NominalDisplayGeometry.estimate(viewport: .referencePhone, displayScale: 3, isPad: false))
91	        let normalized = NormalizedCoordinates.normalized(point, in: viewport.bounds)
92	        let offsets = viewport.nominal.planeOffsets(normalized: normalized, viewport: viewport.bounds)
93	        let hit = AxisMapping.standard.planePoint(right: offsets.right, up: offsets.up)
94	        return RawGazeSample(timestamp: timestamp,
95	                             planeHit: hit,
96	                             eyeOrigin: Self.eyeOrigin,
97	                             eyeSeparation: Self.eyeSeparation,
98	                             userRight: SIMD2(1, 0),
99	                             deviceUp: SIMD2(0, 1),
100	                             faceUp: SIMD2(0, 1),
101	                             blinkLeft: blinkLeft,
102	                             blinkRight: blinkRight,
103	                             hasBlendShapes: true)
104	    }
105	
106	    private func emit(_ sample: RawGazeSample) {
107	        latestSample = sample
108	        onSample?(sample)
109	    }
110	
111	    private func startOracle() {
112	        stopOracle()
113	        timer = Timer.scheduledTimer(withTimeInterval: 1.0 / 60.0, repeats: true) { [weak self] _ in
114	            MainActor.assumeIsolated { self?.oracleTick() }
115	        }
116	    }
117	
118	    private func stopOracle() {
119	        timer?.invalidate()
120	        timer = nil
121	    }
122	
123	    private func oracleTick() {
124	        guard case .tracking = state, let viewport else { return }
125	        tick += 1
126	        let target = fixation ?? SIMD2(0.5, 0.5)
127	        let jitter = SIMD2(sin(Double(tick) * 0.7) * 0.004, cos(Double(tick) * 0.9) * 0.004)
128	        let point = NormalizedCoordinates.points(target + jitter, in: viewport.bounds)
129	        emit(makeSample(point: point, timestamp: ProcessInfo.processInfo.systemUptime))
130	    }
131	}
132	
~~~~

#### 2026-09-14 16:35:33 +0200 (14:35:33Z) · TOOL CALL · Bash
`4a1b6284` · `21201373` · ligne 81 · sous-agent agent-a5504523198b6ab18

~~~~bash
cd "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris"; echo ---unchecked; grep -rn "@unchecked\|nonisolated(unsafe)\|assumeIsolated" --include=*.swift . | grep -v "^./Tests" ; echo ---network; grep -rniE "URLSession|http[s]?://|Network\b|import Network|CloudKit|FileManager|write\(to|capturedImage|ARFrame" --include=*.swift . | grep -v Tests; echo ---filtertests; ls Tests/IrisTests/*; grep -rln "GazeFilter" Tests; echo ---scenePhase; grep -rn "scenePhase\|willResignActive\|didEnterBackground\|didBecomeActive" --include=*.swift . | grep -v Tests; echo --- logger; grep -rn "logger\.\|print(" --include=*.swift GameEngine Features/Game Features/GazeSetup AR App | head -60; grep -n "NSCamera\|UIRequiredDevice\|arkit\|front-facing" -i project.yml
~~~~

#### 2026-09-14 16:35:33 +0200 (14:35:33Z) · TOOL RESULT · Bash
`4a1b6284` · `cdb1b39e` · ligne 82 · sous-agent agent-a5504523198b6ab18

~~~~text
---unchecked
(eval):1: no matches found: --include=*.swift
---network
(eval):1: no matches found: --include=*.swift
---filtertests
Tests/IrisTests/AR:
AffineTransform2DTests.swift
AxisMappingTests.swift
CalibrationProfileTests.swift
FixationSequenceTests.swift
GazeMapperTests.swift
GazeReadinessEvaluatorTests.swift
NormalizedCoordinatesTests.swift
RobustAggregatorTests.swift

Tests/IrisTests/Audio:
AudioCuePolicyTests.swift
SineSynthTests.swift

Tests/IrisTests/Campaign:
BraisesChapterTests.swift
BraisesPrototypeTests.swift
CampaignBot.swift
CampaignMeasurements.swift
CampaignValidationTests.swift
ConstellationTests.swift
EchosTests.swift
ExpansionCampaignDump.swift
ExpansionCampaignFingerprintTests.swift
GouffresTests.swift
HistoricalCampaignDump.swift
HistoricalCampaignFingerprintTests.swift
JumellesTests.swift
LevelAnalysis.swift
LevelLabTests.swift
OculoAbsenceTests.swift
OculoAncreTests.swift
OculoCoeurTests.swift
OculoCourantTests.swift
OculoCroisementTests.swift
OculoEtoilesTests.swift
OculoFilTests.swift
OculoJardinTests.swift
OculoMiroirTests.swift
OculomotorLevelTests.swift
OculoOrchestreTests.swift
OculoStageTestSupport.swift
OculoTournerTests.swift
SoufflesTests.swift

Tests/IrisTests/Domain:
CampaignProgressTests.swift
CascadeRuleTests.swift
LinearCongruentialGeneratorTests.swift
PrototypeLevelCatalogTests.swift
SequenceOrderTests.swift
ValidationRuleTests.swift

Tests/IrisTests/Fixtures:
expansion_campaign.txt
golden_generator.js
golden_level1_scripted.json
golden_level9_far.json
GoldenTrace.swift
historical_campaign.txt
SessionFixture.swift

Tests/IrisTests/GameEngine:
BraiseStateTests.swift
GameSessionGoldenTests.swift
GameSessionTests.swift
GazeFilterTests.swift
HintTrackerTests.swift
LevelEnvironmentTests.swift
OculoSequenceClockTests.swift
TargetPhysicsTests.swift
ValueNoise1DTests.swift

Tests/IrisTests/Haptics:
HapticCuePolicyTests.swift

Tests/IrisTests/Mocks:
MockAudioService.swift
MockGameNavigating.swift
MockHapticFeedbackService.swift

Tests/IrisTests/Presentation:
AdaptiveLevelRowMetricsTests.swift
AncreSceneTests.swift
AppCoordinatorTests.swift
CameraAccessViewModelTests.swift
ChapterCardLayoutTests.swift
GameSettingsStoreTests.swift
GameViewModelTests.swift
GazeSetupViewModelTests.swift
LaunchOptionsTests.swift
OculomotorTraceTests.swift
Tests/IrisTests/GameEngine/GazeFilterTests.swift
Tests/IrisTests/Campaign/HistoricalCampaignFingerprintTests.swift
---scenePhase
(eval):1: no matches found: --include=*.swift
--- logger
(eval):1: no matches found: --include=*.swift
~~~~

#### 2026-09-14 16:35:44 +0200 (14:35:44Z) · TOOL CALL · Bash
`4a1b6284` · `6c1063d4` · ligne 86 · sous-agent agent-a5504523198b6ab18

~~~~bash
cd "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris"; echo ---unchecked; grep -rn '@unchecked\|nonisolated(unsafe)\|assumeIsolated' --include='*.swift' . | grep -v '^./Tests' ; echo ---network; grep -rniE 'URLSession|https?://|import Network|CloudKit|FileManager|write\(to|capturedImage|FileHandle' --include='*.swift' . | grep -v '^./Tests'; echo ---scenePhase; grep -rn 'scenePhase\|willResignActive\|didEnterBackground\|didBecomeActive\|\.suspend()\|\.wake()' --include='*.swift' . | grep -v '^./Tests'; echo ---ancre; grep -rln 'AncreCapture' --include='*.swift' .; grep -n 'NSCamera\|UIRequiredDevice\|arkit\|front-facing\|INFOPLIST' -i project.yml; echo ---gazeSession; grep -n 'gaze\|Gaze\|HeadPose\|ingestHead' GameEngine/Session/GameSession.swift | head -40; echo ---tests; grep -n '@Test\|func test' Tests/IrisTests/Presentation/GazeSetupViewModelTests.swift Tests/IrisTests/Presentation/GameViewModelTests.swift Tests/IrisTests/Presentation/CameraAccessViewModelTests.swift Tests/IrisTests/GameEngine/GazeFilterTests.swift Tests/IrisTests/AR/*.swift; grep -rln 'BlinkDetector\|GazeRay\|ARKitGazeTrackingService\|AxisVote\|screenHead' Tests
~~~~

#### 2026-09-14 16:35:44 +0200 (14:35:44Z) · TOOL RESULT · Bash
`4a1b6284` · `0eec731c` · ligne 87 · sous-agent agent-a5504523198b6ab18

~~~~text
---unchecked
App/Persistence/UserDefaultsProgressStore.swift:7:final class UserDefaultsProgressStore: ProgressStore, @unchecked Sendable {
App/Persistence/InMemoryProgressStore.swift:7:final class InMemoryProgressStore: ProgressStore, @unchecked Sendable {
Tests/IrisTests/Campaign/CampaignMeasurements.swift:20:extension CampaignBot.Result: @unchecked Sendable {}
Audio/Synth/SineSynth.swift:10:final class SineSynth: @unchecked Sendable {
Audio/Services/NotificationObserverBag.swift:7:final class NotificationObserverBag: @unchecked Sendable {
Audio/Services/AVAudioEngineAudioService.swift:112:            MainActor.assumeIsolated {
Audio/Services/AVAudioEngineAudioService.swift:117:            MainActor.assumeIsolated { self?.rebuildEngine() }
Audio/Services/AVAudioEngineAudioService.swift:120:            MainActor.assumeIsolated { self?.rebuildEngine() }
AR/Calibration/CalibrationStore.swift:13:final class UserDefaultsCalibrationStore: CalibrationStore, @unchecked Sendable {
AR/Calibration/CalibrationStore.swift:36:final class InMemoryCalibrationStore: CalibrationStore, @unchecked Sendable {
AR/Services/SimulatedGazeTrackingService.swift:114:            MainActor.assumeIsolated { self?.oracleTick() }
AR/Services/CameraAuthorizationService.swift:44:final class StubCameraAuthorizationService: CameraAuthorizationService, @unchecked Sendable {
AR/Services/ARKitGazeTrackingService.swift:165:        MainActor.assumeIsolated { process(frame) }
AR/Services/ARKitGazeTrackingService.swift:169:        MainActor.assumeIsolated { handleFailure(error) }
AR/Services/ARKitGazeTrackingService.swift:173:        MainActor.assumeIsolated { state = .interrupted }
AR/Services/ARKitGazeTrackingService.swift:177:        MainActor.assumeIsolated { state = .starting }
---network
Tools/MakeAppIcon.swift:13:    FileHandle.standardError.write(Data("usage: MakeAppIcon <output.png>\n".utf8))
Features/Game/Diagnostics/AncreCapture.swift:65:        let directory = FileManager.default.temporaryDirectory.appendingPathComponent(Self.directoryName, isDirectory: true)
Features/Game/Diagnostics/AncreCapture.swift:69:            try? FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
Features/Game/Diagnostics/AncreCapture.swift:70:            FileManager.default.createFile(atPath: target.path, contents: nil)
Features/Game/Diagnostics/AncreCapture.swift:183:            guard let handle = try? FileHandle(forWritingTo: target) else { return }
Tests/IrisTests/Presentation/AncreSceneTests.swift:152:                try data.write(to: directory.appendingPathComponent("x7-\(name).png"))
Tests/IrisTests/Presentation/AncreSceneTests.swift:177:        try data.write(to: URL(fileURLWithPath: directory, isDirectory: true).appendingPathComponent("x7-reference-overlay.png"))
Tests/IrisTests/Presentation/ChapterCardLayoutTests.swift:100:                        try data.write(to: url)
---scenePhase
Features/CameraAccess/CameraAccessView.swift:10:    @Environment(\.scenePhase) private var scenePhase
Features/CameraAccess/CameraAccessView.swift:33:        .onChange(of: scenePhase) { _, phase in
Features/GazeSetup/Views/GazeSetupView.swift:10:    @Environment(\.scenePhase) private var scenePhase
Features/GazeSetup/Views/GazeSetupView.swift:27:        .onChange(of: scenePhase) { _, phase in
Features/GazeSetup/Views/GazeSetupView.swift:29:            case .background, .inactive: viewModel.suspend()
Features/GazeSetup/Views/GazeSetupView.swift:30:            case .active: viewModel.wake()
Tests/IrisTests/Presentation/GameViewModelTests.swift:362:        sut.suspend()
Tests/IrisTests/Presentation/GameViewModelTests.swift:364:        sut.wake()
Tests/IrisTests/Presentation/GameViewModelTests.swift:374:        sut.suspend()
Tests/IrisTests/Presentation/GameViewModelTests.swift:375:        sut.wake()
Navigation/RootView.swift:9:    @Environment(\.scenePhase) private var scenePhase
Navigation/RootView.swift:63:        .onChange(of: scenePhase) { _, phase in
Navigation/RootView.swift:66:                if case .game = coordinator.route { coordinator.gameViewModel?.suspend() }
Navigation/RootView.swift:68:                if case .game = coordinator.route { coordinator.gameViewModel?.wake() }
Tests/IrisTests/Presentation/GazeSetupViewModelTests.swift:268:        sut.suspend()
Tests/IrisTests/Presentation/GazeSetupViewModelTests.swift:270:        sut.wake()
---ancre
Features/Game/ViewModels/GameViewModel.swift
Features/Game/Diagnostics/AncreCapture.swift
57:        INFOPLIST_FILE: Config/Info.plist
58:        GENERATE_INFOPLIST_FILE: "NO"
65:        INFOPLIST_KEY_LSApplicationCategoryType: public.app-category.games
77:        GENERATE_INFOPLIST_FILE: "YES"
---gazeSession
17:    private(set) var gaze: GazeFilter
46:    private(set) var headPose: HeadPose?
53:         initialGaze: Vector2? = nil,
54:         gazeJumpThreshold: Double = 300,
67:        self.gaze = GazeFilter(initialPosition: initialGaze ?? bounds.center, jumpThreshold: gazeJumpThreshold)
106:    /// OCULOMOTOR EXPANSION: the gaze-contingent stages.
115:    /// OCULOMOTOR EXPANSION: head orientation from the gaze observation; read only by the stages that ask for it.
116:    mutating func ingestHeadPose(_ pose: HeadPose?) {
147:    /// Smoothed gaze input (what the reference engine's gaze listener did).
148:    mutating func ingestGaze(_ point: Vector2) {
149:        gaze.ingest(point)
152:    /// Exact gaze placement without smoothing (tests, golden traces, previews).
153:    mutating func placeGaze(at point: Vector2) {
154:        gaze.place(at: point)
196:        let cursor = gaze.position
259:            integrator.integrate(&target, gaze: cursor, noise: { noise.value(at: $0) }, frameTime: frameTime,
392:        let onField = gaze.isActive && environment.isOnField(cursor, bounds: bounds)
405:            switch environment.veilleuses[index].update(seconds: seconds, gaze: cursor, gazeActive: gaze.isActive) {
414:    /// EXPERIMENTAL (prototype B1): warms or cools each braise from the gaze distance to its lueur.
419:            let change = braise.update(seconds: seconds, gazeDistance: distance, gazeActive: gaze.isActive)
450:    /// PROTOTYPE (chapter I level 6): the balise the thread designates wakes under a steady gaze; when the thread is
454:        let change = sequence.update(seconds: seconds, gaze: cursor, gazeActive: gaze.isActive, elapsed: elapsed)
478:        let input = OculoInput(seconds: seconds, gaze: cursor, gazeActive: gaze.isActive, head: headPose, elapsed: elapsed)
500:        let inZone = gaze.isActive && target.position.distance(to: cursor) < target.attentionZone
---tests
Tests/IrisTests/Presentation/GazeSetupViewModelTests.swift:75:    @Test("readiness passes with a stable signal and the calibration starts by itself after one second")
Tests/IrisTests/Presentation/GazeSetupViewModelTests.swift:94:    @Test("a full run with a biased gaze ends in Regard prêt with the bias learned and the profile saved")
Tests/IrisTests/Presentation/GazeSetupViewModelTests.swift:122:    @Test("a mirrored gaze (axis inverted) is corrected by the calibration and still validates")
Tests/IrisTests/Presentation/GazeSetupViewModelTests.swift:140:    @Test("a gaze that ignores the validation targets is reported as insufficient; recalibrate restarts, continue anyway keeps the profile as invalid")
Tests/IrisTests/Presentation/GazeSetupViewModelTests.swift:165:    @Test("recalibrate after an insufficient verdict goes back to the diagnostic")
Tests/IrisTests/Presentation/GazeSetupViewModelTests.swift:182:    @Test("revalidation with a stored profile skips the nine-point calibration")
Tests/IrisTests/Presentation/GazeSetupViewModelTests.swift:205:    @Test("no samples on a target fails with an explicit signal error")
Tests/IrisTests/Presentation/GazeSetupViewModelTests.swift:230:    @Test("unsupported hardware and a denied camera are reported as failures")
Tests/IrisTests/Presentation/GazeSetupViewModelTests.swift:241:    @Test("blinks during calibration are ignored and do not spoil the fit")
Tests/IrisTests/Presentation/GazeSetupViewModelTests.swift:263:    @Test("cancel tears down and notifies; suspend and wake restart the diagnostic")
Tests/IrisTests/GameEngine/GazeFilterTests.swift:11:    @Test("the first sample activates the filter and moves 10 percent of the way")
Tests/IrisTests/GameEngine/GazeFilterTests.swift:22:    @Test("repeated samples converge exponentially (alpha 0.1)")
Tests/IrisTests/GameEngine/GazeFilterTests.swift:32:    @Test("an isolated big jump (blink) is ignored twice, the third consecutive one is trusted")
Tests/IrisTests/GameEngine/GazeFilterTests.swift:47:    @Test("a small sample between jumps resets the jump counter")
Tests/IrisTests/GameEngine/GazeFilterTests.swift:63:    @Test("jumps are never gated before the filter is active")
Tests/IrisTests/GameEngine/GazeFilterTests.swift:72:    @Test("placing the cursor bypasses smoothing")
Tests/IrisTests/Presentation/CameraAccessViewModelTests.swift:14:    @Test("initial phase mirrors the authorization status")
Tests/IrisTests/Presentation/CameraAccessViewModelTests.swift:21:    @Test("granting access navigates forward")
Tests/IrisTests/Presentation/CameraAccessViewModelTests.swift:30:    @Test("denying access shows the denied state")
Tests/IrisTests/Presentation/CameraAccessViewModelTests.swift:40:    @Test("refresh after returning from Settings navigates when now authorized")
Tests/IrisTests/Presentation/CameraAccessViewModelTests.swift:50:    @Test("abandon returns to the navigator")
Tests/IrisTests/AR/FixationSequenceTests.swift:32:    @Test("settling produces no samples, collection fills the ring, then the next target comes")
Tests/IrisTests/AR/FixationSequenceTests.swift:48:    @Test("nine targets complete in about ten seconds and yield nine measurements")
Tests/IrisTests/AR/FixationSequenceTests.swift:64:    @Test("blinks are excluded but do not prevent completion")
Tests/IrisTests/AR/FixationSequenceTests.swift:75:    @Test("a target without usable samples is retried once, then the sequence fails")
Tests/IrisTests/AR/FixationSequenceTests.swift:88:    @Test("collection extends past the nominal window when samples are scarce, then succeeds")
Tests/IrisTests/AR/FixationSequenceTests.swift:102:    @Test("an empty target list completes immediately and finished sequences ignore input")
Tests/IrisTests/AR/CalibrationProfileTests.swift:29:    @Test("save then load round trips through the in-memory and UserDefaults stores")
Tests/IrisTests/AR/CalibrationProfileTests.swift:46:    @Test("a fresh valid profile for the same viewport and orientation is compatible")
Tests/IrisTests/AR/CalibrationProfileTests.swift:52:    @Test("version mismatch, invalidation, other orientation, other viewport or old age make it incompatible")
Tests/IrisTests/AR/CalibrationProfileTests.swift:61:    @Test("a small viewport difference (safe area rounding) is tolerated")
Tests/IrisTests/AR/CalibrationProfileTests.swift:66:    @Test("the mapper built from a profile applies its transform")
Tests/IrisTests/AR/NormalizedCoordinatesTests.swift:14:    @Test("corners and centre map to 0, 0.5 and 1 on every viewport")
Tests/IrisTests/AR/NormalizedCoordinatesTests.swift:24:    @Test("round trip is exact")
Tests/IrisTests/AR/NormalizedCoordinatesTests.swift:33:    @Test("error is measured in points relative to the short side")
Tests/IrisTests/AR/NormalizedCoordinatesTests.swift:42:    @Test("the nine-point grid and validation targets stay inside the margins")
Tests/IrisTests/AR/RobustAggregatorTests.swift:12:    @Test("a tight cluster returns its centre with no rejection")
Tests/IrisTests/AR/RobustAggregatorTests.swift:29:    @Test("a few far outliers (a glance away) are rejected and do not move the centre")
Tests/IrisTests/AR/RobustAggregatorTests.swift:49:    @Test("non finite samples are dropped and too few samples give nil")
Tests/IrisTests/AR/RobustAggregatorTests.swift:58:    @Test("median handles odd and even counts")
Tests/IrisTests/Presentation/GameViewModelTests.swift:50:    @Test("prepare loads the level, shows the intro once tracking works, starts audio with the chapter drone when the ambience is on")
Tests/IrisTests/Presentation/GameViewModelTests.swift:72:    @Test("effects on, ambience off (default): the engine runs, event cues play, no drone")
Tests/IrisTests/Presentation/GameViewModelTests.swift:84:    @Test("effects off, ambience on: the drone plays and every event cue stays silent")
Tests/IrisTests/Presentation/GameViewModelTests.swift:98:    @Test("effects off, ambience off: the audio engine is never activated and no cue is sent")
Tests/IrisTests/Presentation/GameViewModelTests.swift:111:    @Test("effects on, ambience on: drone and event cues together")
Tests/IrisTests/Presentation/GameViewModelTests.swift:123:    @Test("haptics on: the hold prepares the engine, the completing validation is one success pulse alongside the arpeggio")
Tests/IrisTests/Presentation/GameViewModelTests.swift:136:    @Test("haptics off: no cue reaches the service, and the toggle acts on the next tick")
Tests/IrisTests/Presentation/GameViewModelTests.swift:153:    @Test("the start hint shows when play begins and follows the player's first actions")
Tests/IrisTests/Presentation/GameViewModelTests.swift:175:    @Test("completing a level shows the result with éclats, reports the outcome and loads the next level on demand")
Tests/IrisTests/Presentation/GameViewModelTests.swift:202:    @Test("replay reloads the same level; restart from pause too")
Tests/IrisTests/Presentation/GameViewModelTests.swift:221:    @Test("the last level of the campaign ends on the finale")
Tests/IrisTests/Presentation/GameViewModelTests.swift:240:    @Test("the last level of a chapter proposes the next chapter and changes the drone when the ambience is on")
Tests/IrisTests/Presentation/GameViewModelTests.swift:258:    @Test("pause stops the loop, resume continues, chapters leaves the game")
Tests/IrisTests/Presentation/GameViewModelTests.swift:277:    @Test("after the help delay a pushing level shows its route")
Tests/IrisTests/Presentation/GameViewModelTests.swift:293:    @Test("the cursor starts on the latest gaze, follows samples while playing, freezes while paused")
Tests/IrisTests/Presentation/GameViewModelTests.swift:311:    @Test("a stored compatible profile corrects the gaze")
Tests/IrisTests/Presentation/GameViewModelTests.swift:330:    @Test("face lost for 0.3 s pauses the game, which resumes by itself")
Tests/IrisTests/Presentation/GameViewModelTests.swift:343:    @Test("interruption, camera denial and tracking errors")
Tests/IrisTests/Presentation/GameViewModelTests.swift:357:    @Test("background and foreground keep the level, the result survives a background trip")
Tests/IrisTests/Presentation/GameViewModelTests.swift:379:    @Test("recalibration suspends the game and resumes it")
Tests/IrisTests/Presentation/GameViewModelTests.swift:392:    @Test("autoplay skips the intro card")
Tests/IrisTests/Presentation/GameViewModelTests.swift:399:    @Test("a late onDisappear after handing the tracker to the setup does not stop the setup's session")
Tests/IrisTests/AR/AffineTransform2DTests.swift:36:    @Test("identity is recovered from an exact grid")
Tests/IrisTests/AR/AffineTransform2DTests.swift:44:    @Test("pure offsets on x and y are recovered")
Tests/IrisTests/AR/AffineTransform2DTests.swift:53:    @Test("scales on x and y are recovered")
Tests/IrisTests/AR/AffineTransform2DTests.swift:62:    @Test("a full affine combination with shear and an axis flip is recovered")
Tests/IrisTests/AR/AffineTransform2DTests.swift:69:    @Test("an inverted axis (mirror) is corrected by the fit")
Tests/IrisTests/AR/AffineTransform2DTests.swift:79:    @Test("noisy synthetic data gives small residuals and near coefficients")
Tests/IrisTests/AR/AffineTransform2DTests.swift:92:    @Test("fewer than three points is refused")
Tests/IrisTests/AR/AffineTransform2DTests.swift:99:    @Test("non finite input is refused")
Tests/IrisTests/AR/AffineTransform2DTests.swift:106:    @Test("collinear points are degenerate")
Tests/IrisTests/AR/AffineTransform2DTests.swift:116:    @Test("CalibrationResult reports mean and max residual")
Tests/IrisTests/AR/GazeReadinessEvaluatorTests.swift:39:    @Test("a stable centred signal passes every check and resolves the standard axes")
Tests/IrisTests/AR/GazeReadinessEvaluatorTests.swift:52:    @Test("before enough samples the signal checks are pending, not failed")
Tests/IrisTests/AR/GazeReadinessEvaluatorTests.swift:64:    @Test("unsupported hardware or a denied camera block readiness")
Tests/IrisTests/AR/GazeReadinessEvaluatorTests.swift:74:    @Test("a face too far or with implausible eye separation fails the eye check")
Tests/IrisTests/AR/GazeReadinessEvaluatorTests.swift:85:    @Test("a gaze that never reaches the screen fails the direction check")
Tests/IrisTests/AR/GazeReadinessEvaluatorTests.swift:93:    @Test("a moving head or a wandering gaze keep the stability checks pending")
Tests/IrisTests/AR/GazeReadinessEvaluatorTests.swift:104:    @Test("missing blend shapes fail the blink check and the window forgets old samples")
Tests/IrisTests/AR/GazeMapperTests.swift:15:    @Test("nominal geometry normalizes and inverts consistently")
Tests/IrisTests/AR/GazeMapperTests.swift:27:    @Test("ray-plane intersection works whichever side of the plane the face is on")
Tests/IrisTests/AR/GazeMapperTests.swift:40:    @Test("looking away from the device or non finite input gives no hit")
Tests/IrisTests/AR/GazeMapperTests.swift:47:    @Test("an uncalibrated mapper reproduces the simulated pointer position")
Tests/IrisTests/AR/GazeMapperTests.swift:62:    @Test("axis mapping is applied before the nominal frame, so a flipped device still maps correctly")
Tests/IrisTests/AR/GazeMapperTests.swift:83:    @Test("calibration is applied once and the result is clamped to the overshoot band")
Tests/IrisTests/AR/GazeMapperTests.swift:96:    @Test("a sample without plane hit maps to nothing")
Tests/IrisTests/AR/GazeMapperTests.swift:107:    @Test("blink detector flags blinks and a short hold-off after them")
Tests/IrisTests/AR/AxisMappingTests.swift:12:    @Test("standard frame: user right along +x and gravity up along +y")
Tests/IrisTests/AR/AxisMappingTests.swift:20:    @Test("a frame rotated 180 degrees (phone upside down) maps right to -x and up to -y")
Tests/IrisTests/AR/AxisMappingTests.swift:27:    @Test("a mirrored frame (right along -x, up along +y) is resolved and flagged left-handed")
Tests/IrisTests/AR/AxisMappingTests.swift:35:    @Test("a frame rotated 90 degrees maps right to a y axis")
Tests/IrisTests/AR/AxisMappingTests.swift:42:    @Test("gravity is used when available, the face fallback when the device lies flat")
Tests/IrisTests/AR/AxisMappingTests.swift:51:    @Test("degenerate or conflicting directions give no mapping")
Tests/IrisTests/AR/AxisMappingTests.swift:58:    @Test("screen coordinates and plane points are inverses for every mapping")
Tests/IrisTests/AR/AxisMappingTests.swift:72:    @Test("votes pick the majority and report confidence")
Tests/IrisTests/AR/GazeMapperTests.swift
Tests/IrisTests/Campaign/HistoricalCampaignFingerprintTests.swift
Tests/IrisTests/AR/AxisMappingTests.swift
Tests/IrisTests/Campaign/OculoAncreTests.swift
~~~~

#### 2026-09-14 16:35:55 +0200 (14:35:55Z) · TOOL CALL · Bash
`4a1b6284` · `a08f2de2` · ligne 92 · sous-agent agent-a5504523198b6ab18

~~~~bash
cd "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris"; sed -n 1,80p Features/Game/Diagnostics/AncreCapture.swift; echo ...; sed -n 170,200p Features/Game/Diagnostics/AncreCapture.swift; grep -n '#if\|#endif' Features/Game/Diagnostics/AncreCapture.swift | head; echo ---root; sed -n 55,75p Navigation/RootView.swift; echo ---plist; cat Config/Info.plist | grep -A3 -i 'camera\|Required\|Orientation'; grep -n -i 'orientation' project.yml; echo ---trace; grep -rn 'logger\.\|print(' Features/Game/Diagnostics AR GameEngine/Gaze | head -30; grep -n '#if DEBUG' Features/Game/Diagnostics/*.swift | head; echo ---gazesetupview; sed -n 15,45p Features/GazeSetup/Views/GazeSetupView.swift
~~~~

#### 2026-09-14 16:35:56 +0200 (14:35:56Z) · TOOL RESULT · Bash
`4a1b6284` · `e6589330` · ligne 93 · sous-agent agent-a5504523198b6ab18

~~~~text
// AncreCapture.swift
// Layer: Presentation (DEBUG instrumentation)
// Purpose: Chapter X final « l'ancre »: a short local JSON Lines capture, started only by the `--iris-capture` launch
// argument, that keeps apart what a head loop can mix up: the game phase (with the face-lost warning), face tracking,
// the head pose (camera frame and screen-oriented), gaze availability and state, and the loop's phase, checkpoints,
// sweep and the eyes' presence on the point. Observation only: no camera image, no face geometry, no blend shape, no
// upload; bounded in time and written off the main thread into the app's temporary directory.

#if DEBUG
import Foundation
import os

@MainActor
final class AncreCapture {
    struct Record: Encodable, Sendable {
        /// Seconds since the capture started (monotonic), and the level's own clock.
        let t: Double
        let levelTime: Double
        let kind: String
        let session: String
        let level: String
        let gamePhase: String
        let faceLostWarning: Bool
        let loop: Int?
        let loopStart: String?
        let loopPhase: String?
        let checkpoints: Int?
        let sweepDeg: Double?
        let eyesOnPoint: Double?
        var faceTracked: Bool?
        var headYawDeg: Double?
        var headPitchDeg: Double?
        var headRollDeg: Double?
        var screenYawDeg: Double?
        var screenPitchDeg: Double?
        var gazeSample: Bool?
        var gazeState: String?
        var gazeX: Double?
        var gazeY: Double?
        var lastValidAgeMs: Double?
        var event: String?
    }

    static let maximumDuration: TimeInterval = 180
    static let directoryName = "iris-debug"

    /// An explicit developer action: the capture never runs unless the app was launched with this argument.
    static var isRequested: Bool { ProcessInfo.processInfo.arguments.contains("--iris-capture") }

    let url: URL
    private let levelID: String
    private let sessionID = String(UUID().uuidString.prefix(8))
    private let startedAt = ProcessInfo.processInfo.systemUptime
    private let queue = DispatchQueue(label: "net.steve-s.iris.ancre-capture", qos: .utility)
    private let logger = Logger(subsystem: "net.steve-s.iris", category: "oculotest")
    private var pending: [Record] = []
    private var lastValidTime: TimeInterval?
    private(set) var isStopped = false

    /// Nil unless the level is the ancre and the capture was requested.
    init?(level: LevelDefinition) {
        guard Self.isRequested, level.oculo?.element == .ancre else { return nil }
        levelID = level.id
        let stamp = ISO8601DateFormatter().string(from: Date()).replacingOccurrences(of: ":", with: "-")
        let directory = FileManager.default.temporaryDirectory.appendingPathComponent(Self.directoryName, isDirectory: true)
        let target = directory.appendingPathComponent("iris-debug-\(stamp)-\(level.id).jsonl")
        url = target
        queue.async {
            try? FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
            FileManager.default.createFile(atPath: target.path, contents: nil)
        }
        logger.info("[OculoTest] ancre capture started: \(target.path, privacy: .public)")
    }

    /// One gaze sample, with what the session and the tracker say at that moment.
    func observeSample(session: GameSession, phase: GamePhase, faceTracked: Bool?, observation: GazeObservation?, screenHead: HeadPose?,
                       mapped: Vector2?, gazeState: String, bounds: PlayfieldBounds, timestamp: TimeInterval) {
        guard var record = record(session: session, phase: phase, kind: "sample") else { return }
        if mapped != nil && gazeState == "VALID_INSIDE" { lastValidTime = timestamp }
        record.faceTracked = faceTracked
...
        guard !pending.isEmpty else { return }
        let batch = pending
        pending.removeAll(keepingCapacity: true)
        let target = url
        queue.async {
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.sortedKeys]
            var data = Data()
            for record in batch {
                guard let line = try? encoder.encode(record) else { continue }
                data.append(line)
                data.append(0x0A)
            }
            guard let handle = try? FileHandle(forWritingTo: target) else { return }
            defer { try? handle.close() }
            _ = try? handle.seekToEnd()
            try? handle.write(contentsOf: data)
        }
    }
}
#endif
9:#if DEBUG
190:#endif
---root
            switch sheet {
            case .settings:
                SettingsView()
                    .environment(coordinator)
                    .presentationBackground(DSColor.backgroundSurface)
                    .presentationDragIndicator(.visible)
            }
        }
        .onChange(of: scenePhase) { _, phase in
            switch phase {
            case .background, .inactive:
                if case .game = coordinator.route { coordinator.gameViewModel?.suspend() }
            case .active:
                if case .game = coordinator.route { coordinator.gameViewModel?.wake() }
            @unknown default:
                break
            }
        }
    }

    private var sheetBinding: Binding<AppSheet?> {
---plist
	<key>NSCameraUsageDescription</key>
	<string>Iris utilise la caméra frontale TrueDepth pour détecter la direction de votre regard : c'est ce regard qui repousse les sphères du jeu. Les images restent sur l'appareil, ne sont jamais enregistrées ni envoyées.</string>
	<key>UIApplicationSceneManifest</key>
	<dict>
--
	<key>UIRequiredDeviceCapabilities</key>
	<array>
		<string>arm64</string>
		<string>front-facing-camera</string>
	</array>
	<key>UIRequiresFullScreen</key>
	<true/>
--
	<key>UISupportedInterfaceOrientations</key>
	<array>
		<string>UIInterfaceOrientationPortrait</string>
	</array>
	<key>UISupportedInterfaceOrientations~ipad</key>
	<array>
		<string>UIInterfaceOrientationPortrait</string>
		<string>UIInterfaceOrientationPortraitUpsideDown</string>
	</array>
	<key>UIUserInterfaceStyle</key>
	<string>Dark</string>
---trace
Features/Game/Diagnostics/AncreCapture.swift:72:        logger.info("[OculoTest] ancre capture started: \(target.path, privacy: .public)")
Features/Game/Diagnostics/AncreCapture.swift:125:        logger.info("[OculoTest] ancre capture stopped (\(reason, privacy: .public)): \(path, privacy: .public)")
Features/Game/Diagnostics/OculomotorTrace.swift:332:        logger.info("\(line, privacy: .public)")
AR/Services/ARKitGazeTrackingService.swift:16:                logger.info("gaze state \(String(describing: self.state), privacy: .public)")
AR/Services/ARKitGazeTrackingService.swift:50:        logger.info("start viewport \(viewport.bounds.width, format: .fixed(precision: 0))x\(viewport.bounds.height, format: .fixed(precision: 0)) orientation \(self.orientationProvider.interfaceOrientation.irisName, privacy: .public)")
AR/Services/ARKitGazeTrackingService.swift:158:        logger.error("AR session failed: \(error.localizedDescription, privacy: .public)")
Features/Game/Diagnostics/AncreCapture.swift:9:#if DEBUG
---gazesetupview
            DSBackground(intensity: .calm)
            content
            GazeLiveDotsView(viewModel: viewModel)
        }
        .background(DSColor.backgroundPrimary)
        .onGeometryChange(for: CGSize.self) { proxy in
            proxy.size
        } action: { size in
            viewModel.prepare(width: size.width, height: size.height, displayScale: displayScale)
        }
        .statusBarHidden(true)
        .onDisappear { viewModel.viewDisappeared() }
        .onChange(of: scenePhase) { _, phase in
            switch phase {
            case .background, .inactive: viewModel.suspend()
            case .active: viewModel.wake()
            @unknown default: break
            }
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.phase {
        case .starting:
            VStack(spacing: DSSpacing.l) {
                DSIrisMark(size: 90, isBreathing: true)
                Text("démarrage du suivi du regard…")
                    .font(DSFont.callout)
                    .foregroundStyle(DSColor.textSecondary)
            }
~~~~

#### 2026-09-14 16:36:09 +0200 (14:36:09Z) · TOOL CALL · Bash
`4a1b6284` · `4847ccd9` · ligne 97 · sous-agent agent-a5504523198b6ab18

~~~~bash
cd "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris"; head -12 Features/Game/Diagnostics/OculomotorTrace.swift; sed -n 315,335p Features/Game/Diagnostics/OculomotorTrace.swift; grep -n 'func \|isReady\|isBlocked' AR/Calibration/GazeReadinessReport.swift; cat AR/Calibration/CalibrationGrid.swift | sed -n 8,27p; sed -n 343,356p Tests/IrisTests/Presentation/GameViewModelTests.swift; grep -rn 'blinkDetector' AR/Calibration/GazeReadinessEvaluator.swift
~~~~

#### 2026-09-14 16:36:09 +0200 (14:36:09Z) · TOOL RESULT · Bash
`4a1b6284` · `d9610065` · ligne 98 · sous-agent agent-a5504523198b6ab18

~~~~text
// OculomotorTrace.swift
// Layer: Presentation (DEBUG instrumentation)
// Purpose: PROTOTYPE (chapter I level 6): observes, never steers. Classifies every gaze sample (VALID_INSIDE,
// VALID_OUTSIDE when the mapper still produces a projection outside the viewport, INVALID otherwise), records
// viewport exits with only what was really observed, and measures each balise transition (acquisition, dwell,
// head yaw/pitch deltas). Technical figures, not clinical ones.

import Foundation
import os

@MainActor
final class OculomotorTrace {
        return worst.0
    }

    /// The last observed direction, kept only when the last inside position lay in the outer third toward that edge.
    static func nearEdge(_ position: Vector2, in bounds: PlayfieldBounds, direction: Edge?) -> Edge? {
        guard let direction else { return nil }
        switch direction {
        case .left: return position.x <= bounds.width / 3 ? .left : nil
        case .right: return position.x >= bounds.width * 2 / 3 ? .right : nil
        case .top: return position.y <= bounds.height / 3 ? .top : nil
        case .bottom: return position.y >= bounds.height * 2 / 3 ? .bottom : nil
        }
    }

    private func log(_ message: String) {
        let line = "[OculoTest] " + message
        lines.append(line)
        logger.info("\(line, privacy: .public)")
    }

    private func describe(_ point: Vector2?) -> String {
74:    var isReady: Bool { checks.allSatisfy { $0.status == .pass } }
75:    var isBlocked: Bool { checks.contains { $0.kind.isBlocking && $0.status == .fail } }
enum CalibrationGrid {
    static let horizontalMargin = 0.15
    static let verticalMargin = 0.14

    /// Nine targets on a 3 x 3 grid in reading order.
    static var nine: [SIMD2<Double>] {
        let xs = [horizontalMargin, 0.5, 1 - horizontalMargin]
        let ys = [verticalMargin, 0.5, 1 - verticalMargin]
        return ys.flatMap { y in xs.map { x in SIMD2(x, y) } }
    }

    /// Five control targets: centre, left, right, top, bottom.
    static var validation: [SIMD2<Double>] {
        [SIMD2(0.5, 0.5),
         SIMD2(horizontalMargin, 0.5),
         SIMD2(1 - horizontalMargin, 0.5),
         SIMD2(0.5, verticalMargin),
         SIMD2(0.5, 1 - verticalMargin)]
    }
}
    @Test("interruption, camera denial and tracking errors")
    func interruptionsAndFailures() {
        let sut = makeSUT(level: restingLevel())
        startPlaying(sut)
        gaze.simulate(state: .interrupted)
        #expect(sut.phase == .interrupted)
        gaze.simulate(state: .tracking(faceVisible: true))
        #expect(sut.phase == .resuming)
        gaze.simulate(state: .unavailable(.cameraDenied))
        #expect(sut.phase == .failed(.cameraDenied))
        gaze.simulate(state: .failed(message: "boom"))
        #expect(sut.phase == .failed(.trackingError(message: "boom")))
    }

AR/Calibration/GazeReadinessEvaluator.swift:27:    private var blinkDetector = BlinkDetector()
~~~~

### 2026-09-14 16:37:25 +0200 (14:37:25Z) · CLAUDE · REPORT
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

## Sous-agent `agent-a80c23fe5e191c27f` (transcription de la sous-tâche, isSidechain)

### 2026-09-14 16:35:05 +0200 (14:35:05Z) · USER
`4a1b6284` · `0728ba1d` · ligne 1 · sous-agent agent-a80c23fe5e191c27f

~~~~markdown
STRICTLY READ-ONLY senior audit. Do not modify, create, format or delete any file in the repo; no git writes; no builds/tests (another process runs them). Repo: /Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris (native iOS SwiftUI game with gaze tracking, Swift 6 strict concurrency, XcodeGen). Top dirs: App (DI, Persistence, Platform), Domain (Campaign 45 files, Entities, ValueObjects, Validation, Progress, Physics...), GameEngine (Oculo, Environment, Session, Physics, Clock, Noise, Campaign, Gaze), AR, Audio, Haptics, Navigation, Features (Game 21 files incl. Rendering/ViewModels/Diagnostics, GazeSetup, Chapters, ...), DesignSystem, Tests/IrisTests. Docs/architecture.md, Docs/conventions.md exist — verify claims against code.

Excluding the ARKit gaze acquisition/calibration internals (audited separately), report with file:line evidence and VÉRIFIÉ/INFÉRÉ labels:
1. Architectural map (layers and actual import/dependency directions). Check whether Domain/GameEngine import SwiftUI/UIKit/ARKit (grep imports per directory). DI approach (AppContainer), protocols & mocks, singletons, global state.
2. God types / excessive responsibilities: examine GameSceneRenderer.swift (644 lines), GameViewModel.swift (586), GameSession.swift (507), OculoDefinition.swift (482), AppCoordinator.swift. Function sizes (find the longest functions), logic in views, duplication across GameEngine/Oculo/*StageState.swift (similar state machines?).
3. Game loop / rendering: how frames are driven (TimelineView? CADisplayLink? Canvas?), deltaTime clamping, per-frame allocations, SwiftUI invalidation risks, main-thread work, DEBUG diagnostics compiled out in Release (check #if DEBUG around OculomotorTrace/AncreCapture and the lone print()).
4. Persistence (App/Persistence, UserDefaults): schema/versioning, migration, corrupted-data handling, the 14 `try?` in product code — which swallow errors meaningfully?
5. Audio (AVAudioEngine, SineSynth) and Haptics: interruption handling, route changes, real-time render thread safety, @unchecked Sendable justification (7 occurrences in product — list them and judge).
6. Lifecycle: scenePhase background/foreground pause, error states represented as types, recovery.
7. Accessibility/localization: VoiceOver labels, Dynamic Type, Reduce Motion, hardcoded strings (is there a String Catalog? developmentLanguage fr), orientation locks (Config/Info.plist), iPad support (TARGETED_DEVICE_FAMILY 1,2).
8. Tests: characterize test kinds in Tests/IrisTests (unit, simulated-player bots, golden traces, integration; any UI tests? snapshot tests?). Notable untested production areas (renderer, audio engine, AR service, persistence corruption...).
9. Dead code (e.g., PrototypeLevelCatalog, prototype-only code, .disabled usages), and whether prototype/validation-protection mechanisms (fingerprints) are sound.
Give strengths, weaknesses, architectural debt. Be honest, no inflation, no invented defects. Dense final report ≤ 1100 words.
~~~~

### 2026-09-14 16:35:05 +0200 (14:35:05Z) · SYSTEM · modèle : Opus 5 (1M context) (claude-opus-5[1m])
`4a1b6284` · `d7b03a17` · ligne 4 · sous-agent agent-a80c23fe5e191c27f

### 2026-09-14 16:35:05 +0200 (14:35:05Z) · SYSTEM · date de session : 2026-09-14
`4a1b6284` · `391438a8` · ligne 8 · sous-agent agent-a80c23fe5e191c27f

#### 2026-09-14 16:35:09 +0200 (14:35:09Z) · TOOL CALL · Bash
`4a1b6284` · `e562116b` · ligne 12 · sous-agent agent-a80c23fe5e191c27f

~~~~bash
cd "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris"; ls; for d in App Domain GameEngine AR Audio Haptics Navigation Features DesignSystem; do echo "== $d"; grep -rhoE '^(@preconcurrency )?import [A-Za-z]+' $d --include=*.swift | sort | uniq -c; done; find . -name '*.swift' -not -path './.build/*' | xargs wc -l | sort -n | tail -25
~~~~

#### 2026-09-14 16:35:11 +0200 (14:35:11Z) · TOOL RESULT · Bash
`4a1b6284` · `e646d974` · ligne 13 · sous-agent agent-a80c23fe5e191c27f

~~~~text
App
AR
attention-indirecte.html
Audio
Config
Design
DesignSystem
Docs
Domain
Features
GAME_EXPANSION_DESIGN_REPORT.md
GameEngine
GAZE_ENGINE_V2_REPORT.md
Haptics
ios-app-skills.zip
Iris.xcodeproj
Navigation
project.yml
README.md
Resources
SKILL.md
SwiftUI-Agent-Skill-main.zip
Tests
Tools
VALIDATED_EXPANSION_BASELINE_REPORT.md
x7_silhouette_reference.png
== App
(eval):1: no matches found: --include=*.swift
== Domain
(eval):1: no matches found: --include=*.swift
== GameEngine
(eval):1: no matches found: --include=*.swift
== AR
(eval):1: no matches found: --include=*.swift
== Audio
(eval):1: no matches found: --include=*.swift
== Haptics
(eval):1: no matches found: --include=*.swift
== Navigation
(eval):1: no matches found: --include=*.swift
== Features
(eval):1: no matches found: --include=*.swift
== DesignSystem
(eval):1: no matches found: --include=*.swift
     197 ./Tests/IrisTests/Campaign/SoufflesTests.swift
     202 ./Tests/IrisTests/Presentation/AppCoordinatorTests.swift
     210 ./Tests/IrisTests/Campaign/JumellesTests.swift
     227 ./Tests/IrisTests/GameEngine/LevelEnvironmentTests.swift
     239 ./Features/Game/Rendering/GameSceneRenderer+Ancre.swift
     247 ./DesignSystem/Components/DSGlyph.swift
     250 ./Tests/IrisTests/Campaign/BraisesPrototypeTests.swift
     265 ./Tests/IrisTests/Campaign/OculomotorLevelTests.swift
     275 ./GameEngine/Oculo/OculoStageState.swift
     275 ./Tests/IrisTests/Campaign/OculoAncreTests.swift
     277 ./Tests/IrisTests/Presentation/GazeSetupViewModelTests.swift
     280 ./Features/Game/Rendering/OculoSnapshot.swift
     287 ./Navigation/AppCoordinator.swift
     297 ./Audio/Synth/SineSynth.swift
     304 ./Features/Game/Rendering/GameSceneSnapshot.swift
     314 ./GameEngine/Oculo/AncreStageState.swift
     350 ./Features/Game/Diagnostics/OculomotorTrace.swift
     369 ./Features/GazeSetup/ViewModels/GazeSetupViewModel.swift
     390 ./Tests/IrisTests/Campaign/CampaignBot.swift
     419 ./Tests/IrisTests/Presentation/GameViewModelTests.swift
     482 ./Domain/Campaign/OculoDefinition.swift
     507 ./GameEngine/Session/GameSession.swift
     586 ./Features/Game/ViewModels/GameViewModel.swift
     644 ./Features/Game/Rendering/GameSceneRenderer.swift
   25100 total
~~~~

#### 2026-09-14 16:35:17 +0200 (14:35:17Z) · TOOL CALL · Bash
`4a1b6284` · `8879f324` · ligne 19 · sous-agent agent-a80c23fe5e191c27f

~~~~bash
cd "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris"; for d in App Domain GameEngine AR Audio Haptics Navigation Features DesignSystem; do echo "== $d"; grep -rhoE '^(@preconcurrency )?import [A-Za-z]+' --include='*.swift' $d | sort | uniq -c; done; echo; grep -rnE '^(@preconcurrency )?import (SwiftUI|UIKit|ARKit|AVFoundation|Combine|QuartzCore)' --include='*.swift' Domain GameEngine; echo ==unchecked; grep -rn '@unchecked Sendable' --include='*.swift' . | grep -v Tests; echo ==try; grep -rn 'try?' --include='*.swift' . | grep -v Tests; echo ==print; grep -rn 'print(' --include='*.swift' . | grep -v Tests; echo ==static shared; grep -rnE 'static (let|var) shared|nonisolated\(unsafe\)|static var ' --include='*.swift' . | grep -v Tests
~~~~

#### 2026-09-14 16:35:18 +0200 (14:35:18Z) · TOOL CALL · Bash
`4a1b6284` · `64f292d7` · ligne 20 · sous-agent agent-a80c23fe5e191c27f

~~~~bash
cd "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris"; cat project.yml; ls Config Resources; find . -name '*.xcstrings' -o -name '*.strings' | grep -v xcodeproj; ls Tests Tests/IrisTests Tests/IrisTests/*; find App -name '*.swift'; find Audio Haptics Navigation -name '*.swift'
~~~~

#### 2026-09-14 16:35:19 +0200 (14:35:19Z) · TOOL RESULT · Bash
`4a1b6284` · `f22b4b93` · ligne 21 · sous-agent agent-a80c23fe5e191c27f

~~~~text
== App
   8 import Foundation
   1 import QuartzCore
   1 import SwiftUI
   2 import UIKit
== Domain
  70 import Foundation
== GameEngine
  35 import Foundation
== AR
   2 import ARKit
   1 import AVFoundation
  24 import Foundation
   1 import os
  18 import simd
   1 import UIKit
== Audio
   1 import AVFoundation
   7 import Foundation
   1 import os
== Haptics
   4 import Foundation
   1 import UIKit
== Navigation
   4 import Foundation
   1 import Observation
   1 import SwiftUI
== Features
  19 import Foundation
   4 import Observation
   4 import os
   2 import simd
  25 import SwiftUI
== DesignSystem
  20 import SwiftUI

(eval):1: =unchecked not found
~~~~

#### 2026-09-14 16:35:19 +0200 (14:35:19Z) · TOOL RESULT · Bash
`4a1b6284` · `ad96e68d` · ligne 22 · sous-agent agent-a80c23fe5e191c27f

~~~~text
# Iris — spécification XcodeGen. CE FICHIER EST LA SOURCE DE VÉRITÉ du projet Xcode.
# `Iris.xcodeproj` est entièrement régénéré par `xcodegen generate` : tout réglage modifié
# dans Xcode (Signing & Capabilities, Build Settings) est ÉCRASÉ à la régénération suivante.
#
# Identité Apple verrouillée — NE PAS MODIFIER SANS RAISON EXPLICITE (voir README, « Apple Signing ») :
#   PRODUCT_BUNDLE_IDENTIFIER = net.steve-s.iris        (cible de tests : net.steve-s.iris.tests)
#   DEVELOPMENT_TEAM          = G4U9RG5GL7              (Stéphane SAULNIER, équipe individuelle Apple Developer)
#   CODE_SIGN_STYLE           = Automatic               (aucun profil ni certificat imposé)
# `Tools/audit.py` (contrôle C12) échoue si ces valeurs divergent entre ce fichier et le projet généré.
name: Iris
options:
  bundleIdPrefix: net.steve-s
  deploymentTarget:
    iOS: "17.0"
  xcodeVersion: "26.3"
  createIntermediateGroups: true
  generateEmptyDirectories: false
  groupSortPosition: top
  developmentLanguage: fr
attributes:
  ORGANIZATIONNAME: Stéphane SAULNIER
settings:
  base:
    SWIFT_VERSION: "6.0"
    SWIFT_STRICT_CONCURRENCY: complete
    IPHONEOS_DEPLOYMENT_TARGET: "17.0"
    TARGETED_DEVICE_FAMILY: "1,2"
    DEVELOPMENT_TEAM: G4U9RG5GL7
    CODE_SIGN_STYLE: Automatic
    CODE_SIGN_IDENTITY: Apple Development
    ENABLE_USER_SCRIPT_SANDBOXING: "YES"
    ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS: "NO"
    SWIFT_EMIT_LOC_STRINGS: "NO"
    GCC_WARN_UNUSED_VARIABLE: "YES"
    SWIFT_UPCOMING_FEATURE_EXISTENTIAL_ANY: "YES"
targets:
  Iris:
    type: application
    platform: iOS
    deploymentTarget: "17.0"
    sources:
      - path: App
      - path: Domain
      - path: GameEngine
      - path: AR
      - path: Audio
      - path: Haptics
      - path: Navigation
      - path: Features
      - path: DesignSystem
      - path: Resources
    settings:
      base:
        PRODUCT_BUNDLE_IDENTIFIER: net.steve-s.iris
        PRODUCT_NAME: Iris
        CODE_SIGN_IDENTITY: Apple Development
        INFOPLIST_FILE: Config/Info.plist
        GENERATE_INFOPLIST_FILE: "NO"
        ASSETCATALOG_COMPILER_APPICON_NAME: AppIcon
        ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME: AccentColor
        MARKETING_VERSION: "1.0"
        CURRENT_PROJECT_VERSION: "1"
        SUPPORTS_MACCATALYST: "NO"
        SUPPORTED_PLATFORMS: "iphoneos iphonesimulator"
        INFOPLIST_KEY_LSApplicationCategoryType: public.app-category.games
  IrisTests:
    type: bundle.unit-test
    platform: iOS
    deploymentTarget: "17.0"
    sources:
      - path: Tests/IrisTests
    dependencies:
      - target: Iris
    settings:
      base:
        PRODUCT_BUNDLE_IDENTIFIER: net.steve-s.iris.tests
        GENERATE_INFOPLIST_FILE: "YES"
        TEST_HOST: "$(BUILT_PRODUCTS_DIR)/Iris.app/$(BUNDLE_EXECUTABLE_FOLDER_PATH)/Iris"
        BUNDLE_LOADER: "$(TEST_HOST)"
schemes:
  Iris:
    build:
      targets:
        Iris: all
        IrisTests: [test]
    run:
      config: Debug
    test:
      config: Debug
      targets:
        - IrisTests
      gatherCoverageData: false
    profile:
      config: Release
    analyze:
      config: Debug
    archive:
      config: Release
Config:
Info.plist

Resources:
Assets.xcassets
Tests:
IrisTests

Tests/IrisTests:
AR
Audio
Campaign
Domain
Fixtures
GameEngine
Haptics
Mocks
Presentation

Tests/IrisTests/AR:
AffineTransform2DTests.swift
AxisMappingTests.swift
CalibrationProfileTests.swift
FixationSequenceTests.swift
GazeMapperTests.swift
GazeReadinessEvaluatorTests.swift
NormalizedCoordinatesTests.swift
RobustAggregatorTests.swift

Tests/IrisTests/Audio:
AudioCuePolicyTests.swift
SineSynthTests.swift

Tests/IrisTests/Campaign:
BraisesChapterTests.swift
BraisesPrototypeTests.swift
CampaignBot.swift
CampaignMeasurements.swift
CampaignValidationTests.swift
ConstellationTests.swift
EchosTests.swift
ExpansionCampaignDump.swift
ExpansionCampaignFingerprintTests.swift
GouffresTests.swift
HistoricalCampaignDump.swift
HistoricalCampaignFingerprintTests.swift
JumellesTests.swift
LevelAnalysis.swift
LevelLabTests.swift
OculoAbsenceTests.swift
OculoAncreTests.swift
OculoCoeurTests.swift
OculoCourantTests.swift
OculoCroisementTests.swift
OculoEtoilesTests.swift
OculoFilTests.swift
OculoJardinTests.swift
OculoMiroirTests.swift
OculomotorLevelTests.swift
OculoOrchestreTests.swift
OculoStageTestSupport.swift
OculoTournerTests.swift
SoufflesTests.swift

Tests/IrisTests/Domain:
CampaignProgressTests.swift
CascadeRuleTests.swift
LinearCongruentialGeneratorTests.swift
PrototypeLevelCatalogTests.swift
SequenceOrderTests.swift
ValidationRuleTests.swift

Tests/IrisTests/Fixtures:
expansion_campaign.txt
golden_generator.js
golden_level1_scripted.json
golden_level9_far.json
GoldenTrace.swift
historical_campaign.txt
SessionFixture.swift

Tests/IrisTests/GameEngine:
BraiseStateTests.swift
GameSessionGoldenTests.swift
GameSessionTests.swift
GazeFilterTests.swift
HintTrackerTests.swift
LevelEnvironmentTests.swift
OculoSequenceClockTests.swift
TargetPhysicsTests.swift
ValueNoise1DTests.swift

Tests/IrisTests/Haptics:
HapticCuePolicyTests.swift

Tests/IrisTests/Mocks:
MockAudioService.swift
MockGameNavigating.swift
MockHapticFeedbackService.swift

Tests/IrisTests/Presentation:
AdaptiveLevelRowMetricsTests.swift
AncreSceneTests.swift
AppCoordinatorTests.swift
CameraAccessViewModelTests.swift
ChapterCardLayoutTests.swift
GameSettingsStoreTests.swift
GameViewModelTests.swift
GazeSetupViewModelTests.swift
LaunchOptionsTests.swift
OculomotorTraceTests.swift
App/IrisApp.swift
App/DI/AppContainer.swift
App/DI/AppEnvironment.swift
App/Platform/DeviceIdiom.swift
App/Platform/LaunchOptions.swift
App/Platform/DisplayLinkGameClock.swift
App/Platform/SystemLinks.swift
App/Persistence/InMemoryProgressStore.swift
App/Persistence/UserDefaultsProgressStore.swift
Navigation/HomeSummary.swift
Navigation/AppCoordinator.swift
Navigation/AppSheet.swift
Navigation/RootView.swift
Navigation/AppRoute.swift
Audio/Synth/SineSynth.swift
Audio/Services/SilentAudioService.swift
Audio/Services/NotificationObserverBag.swift
Audio/Services/AVAudioEngineAudioService.swift
Audio/Services/AudioService.swift
Audio/Policy/AudioCuePolicy.swift
Audio/Policy/AudioCue.swift
Haptics/Services/UIKitHapticFeedbackService.swift
Haptics/Services/HapticFeedbackService.swift
Haptics/Services/SilentHapticFeedbackService.swift
Haptics/Policy/HapticCue.swift
Haptics/Policy/HapticCuePolicy.swift
~~~~

#### 2026-09-14 16:35:28 +0200 (14:35:28Z) · TOOL CALL · Bash
`4a1b6284` · `a5cc3bfb` · ligne 26 · sous-agent agent-a80c23fe5e191c27f

~~~~bash
cd "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris"; echo "--unchecked"; grep -rn '@unchecked Sendable' --include='*.swift' . | grep -v Tests; echo "--try"; grep -rn 'try?' --include='*.swift' . | grep -v Tests; echo "--print"; grep -rn 'print(' --include='*.swift' . | grep -v Tests; echo "--globals"; grep -rnE 'static (let|var) shared|nonisolated\(unsafe\)|static var |\.shared\b' --include='*.swift' . | grep -v Tests; echo "--debug"; grep -rn '#if DEBUG' --include='*.swift' . | grep -v Tests; echo "--disabled"; grep -rn '\.disabled\|PrototypeLevelCatalog' --include='*.swift' . | grep -v Tests | head -30; echo "--a11y"; grep -rnE 'accessibility(Label|Hint|Hidden|Element|Value|ReduceMotion|AddTraits)|dynamicTypeSize|reduceMotion|UIAccessibility' --include='*.swift' . | grep -v Tests | wc -l; grep -rnE 'reduceMotion|ReduceMotion|dynamicTypeSize' --include='*.swift' . | grep -v Tests; grep -rnE '\.font\(\.system\(size' --include='*.swift' . | grep -v Tests | wc -l; echo "--scenePhase"; grep -rn 'scenePhase\|willResignActive\|didEnterBackground\|interruptionNotification\|routeChange\|mediaServicesWereReset' --include='*.swift' . | grep -v Tests; echo "--frames"; grep -rn 'TimelineView\|CADisplayLink\|Canvas {\|Canvas(' --include='*.swift' . | grep -v Tests
~~~~

#### 2026-09-14 16:35:28 +0200 (14:35:28Z) · TOOL RESULT · Bash
`4a1b6284` · `186ac643` · ligne 27 · sous-agent agent-a80c23fe5e191c27f

~~~~text
--unchecked
App/Persistence/UserDefaultsProgressStore.swift:7:final class UserDefaultsProgressStore: ProgressStore, @unchecked Sendable {
App/Persistence/InMemoryProgressStore.swift:7:final class InMemoryProgressStore: ProgressStore, @unchecked Sendable {
Audio/Synth/SineSynth.swift:10:final class SineSynth: @unchecked Sendable {
Audio/Services/NotificationObserverBag.swift:7:final class NotificationObserverBag: @unchecked Sendable {
AR/Services/CameraAuthorizationService.swift:44:final class StubCameraAuthorizationService: CameraAuthorizationService, @unchecked Sendable {
AR/Calibration/CalibrationStore.swift:13:final class UserDefaultsCalibrationStore: CalibrationStore, @unchecked Sendable {
AR/Calibration/CalibrationStore.swift:36:final class InMemoryCalibrationStore: CalibrationStore, @unchecked Sendable {
--try
App/Persistence/UserDefaultsProgressStore.swift:17:              let progress = try? JSONDecoder().decode(CampaignProgress.self, from: data),
App/Persistence/UserDefaultsProgressStore.swift:25:        guard let data = try? JSONEncoder().encode(progress) else { return }
Features/GazeSetup/ViewModels/GazeSetupViewModel.swift:31:    @ObservationIgnored private var nominal: NominalDisplayGeometry?
Features/Game/ViewModels/GameViewModel.swift:45:    @ObservationIgnored private var nominal: NominalDisplayGeometry?
Features/Game/Diagnostics/AncreCapture.swift:69:            try? FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
Features/Game/Diagnostics/AncreCapture.swift:179:                guard let line = try? encoder.encode(record) else { continue }
Features/Game/Diagnostics/AncreCapture.swift:183:            guard let handle = try? FileHandle(forWritingTo: target) else { return }
Features/Game/Diagnostics/AncreCapture.swift:184:            defer { try? handle.close() }
Features/Game/Diagnostics/AncreCapture.swift:185:            _ = try? handle.seekToEnd()
Features/Game/Diagnostics/AncreCapture.swift:186:            try? handle.write(contentsOf: data)
Features/Game/Views/LevelResultView.swift:51:                try? await Task.sleep(for: .milliseconds(260))
Audio/Services/AVAudioEngineAudioService.swift:39:        try? AVAudioSession.sharedInstance().setActive(false, options: [.notifyOthersOnDeactivation])
AR/Calibration/CalibrationStore.swift:23:        return try? JSONDecoder().decode(CalibrationProfile.self, from: data)
AR/Calibration/CalibrationStore.swift:27:        guard let data = try? JSONEncoder().encode(profile) else { return }
--print
Tools/MakeAppIcon.swift:70:print("wrote \(url.path)")
GameEngine/Campaign/LevelResolver.swift:36:            TargetBlueprint(sequence: index + 1,
Domain/Levels/PrototypeLevelCatalog.swift:30:            targets.append(TargetBlueprint(sequence: targetIndex + 1,
--globals
App/Platform/SystemLinks.swift:9:    static var appSettings: URL? { URL(string: UIApplication.openSettingsURLString) }
App/Platform/DeviceIdiom.swift:9:    @MainActor static var isPad: Bool { UIDevice.current.userInterfaceIdiom == .pad }
Features/Game/Diagnostics/AncreCapture.swift:48:    static var isRequested: Bool { ProcessInfo.processInfo.arguments.contains("--iris-capture") }
Features/Game/Rendering/AncreSilhouette.swift:35:    static var headContour: [CGPoint] {
AR/Calibration/CalibrationGrid.swift:13:    static var nine: [SIMD2<Double>] {
AR/Calibration/CalibrationGrid.swift:20:    static var validation: [SIMD2<Double>] {
Domain/Campaign/BraisesPrototype.swift:14:    static var levels: [LevelDefinition] { chapter.levels }
AR/Services/InterfaceOrientationProvider.swift:37:        let scenes = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
--debug
App/DI/AppContainer.swift:45:        #if DEBUG
App/Platform/LaunchOptions.swift:77:        #if DEBUG
Features/Settings/SettingsView.swift:45:                #if DEBUG
Features/Game/Diagnostics/AncreCapture.swift:9:#if DEBUG
Features/Game/ViewModels/GameViewModel.swift:70:    #if DEBUG
Features/Game/ViewModels/GameViewModel.swift:300:                #if DEBUG
Features/Game/ViewModels/GameViewModel.swift:309:        #if DEBUG
Features/Game/ViewModels/GameViewModel.swift:337:        #if DEBUG
Features/Game/ViewModels/GameViewModel.swift:365:        #if DEBUG
Features/Game/ViewModels/GameViewModel.swift:372:        #if DEBUG
Features/Game/ViewModels/GameViewModel.swift:391:        #if DEBUG
Features/Game/ViewModels/GameViewModel.swift:427:        #if DEBUG
Features/Game/ViewModels/GameViewModel.swift:476:        #if DEBUG
Features/Game/ViewModels/GameViewModel.swift:492:            #if DEBUG
Features/Game/ViewModels/GameViewModel.swift:519:            #if DEBUG
Features/Game/Views/GameHUDView.swift:100:        #if DEBUG
Navigation/AppCoordinator.swift:109:    #if DEBUG
Navigation/AppCoordinator.swift:174:        #if DEBUG
Domain/Campaign/BraisesPrototype.swift:7:#if DEBUG
--disabled
DesignSystem/Components/DSButton.swift:90:        DSButton("Désactivé") {}.disabled(true)
Features/Chapters/LevelNode.swift:51:        .disabled(state == .locked)
Features/Game/Views/GameHUDView.swift:32:                .disabled(!showsPause)
Domain/Levels/PrototypeLevelCatalog.swift:1:// PrototypeLevelCatalog.swift
Domain/Levels/PrototypeLevelCatalog.swift:7:enum PrototypeLevelCatalog {
--a11y
     134
DesignSystem/Components/DSButton.swift:75:    @Environment(\.accessibilityReduceMotion) private var reduceMotion
DesignSystem/Components/DSButton.swift:79:            .scaleEffect(configuration.isPressed && !reduceMotion ? 0.97 : 1)
DesignSystem/Components/DSButton.swift:81:            .animation(DSMotion.animation(DSMotion.spring, reduceMotion: reduceMotion), value: configuration.isPressed)
DesignSystem/Components/DSButton.swift:100:        .dynamicTypeSize(.accessibility3)
DesignSystem/Components/DSIrisMark.swift:11:    @Environment(\.accessibilityReduceMotion) private var reduceMotion
DesignSystem/Components/DSIrisMark.swift:39:            guard isBreathing, !reduceMotion else { return }
DesignSystem/Tokens/DSMotion.swift:19:    static func animation(_ animation: Animation, reduceMotion: Bool) -> Animation {
DesignSystem/Tokens/DSMotion.swift:20:        reduceMotion ? .easeInOut(duration: fast) : animation
DesignSystem/Components/DSBackground.swift:15:    @Environment(\.accessibilityReduceMotion) private var reduceMotion
DesignSystem/Components/DSBackground.swift:34:            guard !reduceMotion else { return }
Features/GazeSetup/Views/FixationTargetView.swift:13:    @Environment(\.accessibilityReduceMotion) private var reduceMotion
Features/GazeSetup/Views/FixationTargetView.swift:21:                    .animation(DSMotion.animation(DSMotion.standardAnimation, reduceMotion: reduceMotion), value: display.target)
Features/Game/Views/LevelResultView.swift:15:    @Environment(\.accessibilityReduceMotion) private var reduceMotion
Features/Game/Views/LevelResultView.swift:46:            if reduceMotion {
Features/Game/Rendering/GameSceneRenderer+Ancre.swift:11:                   palette: DSThemePalette, reduceMotion: Bool) {
Features/Game/Rendering/GameSceneRenderer+Ancre.swift:13:        drawAncreSilhouette(scene, center: center, in: &context, scale: scale, palette: palette, reduceMotion: reduceMotion)
Features/Game/Rendering/GameSceneRenderer+Ancre.swift:16:                          in: &context, scale: scale, palette: palette, reduceMotion: reduceMotion)
Features/Game/Rendering/GameSceneRenderer+Ancre.swift:20:                              palette: palette, reduceMotion: reduceMotion)
Features/Game/Rendering/GameSceneRenderer+Ancre.swift:24:                          in: &context, scale: scale, palette: palette, reduceMotion: reduceMotion)
Features/Game/Rendering/GameSceneRenderer+Ancre.swift:26:        drawAncrePoint(scene, center: center, time: time, in: &context, scale: scale, palette: palette, reduceMotion: reduceMotion)
Features/Game/Rendering/GameSceneRenderer+Ancre.swift:32:                                     palette: DSThemePalette, reduceMotion: Bool) {
Features/Game/Rendering/GameSceneRenderer+Ancre.swift:36:        let lean = reduceMotion ? CGVector.zero : ancreLean(scene)
Features/Game/Rendering/GameSceneRenderer+Ancre.swift:84:                               in context: inout GraphicsContext, scale: Double, palette: DSThemePalette, reduceMotion: Bool) {
Features/Game/Rendering/GameSceneRenderer+Ancre.swift:114:        drawAncreCheckpoints(scene, center: center, opacity: opacity, time: time, in: &context, scale: scale, palette: palette, reduceMotion: reduceMotion)
Features/Game/Rendering/GameSceneRenderer+Ancre.swift:151:                                      scale: Double, palette: DSThemePalette, reduceMotion: Bool) {
Features/Game/Rendering/GameSceneRenderer+Ancre.swift:161:                if let age = checkpoint.age, age < 0.7, !reduceMotion {
Features/Game/Rendering/GameSceneRenderer+Ancre.swift:168:                let breath = reduceMotion ? 0.75 : 0.6 + 0.35 * sin(time * 3)
Features/Game/Rendering/GameSceneRenderer+Ancre.swift:181:                                palette: DSThemePalette, reduceMotion: Bool) {
Features/Game/Rendering/GameSceneRenderer+Ancre.swift:194:            halo(30 * scale, 0.45 * (reduceMotion ? 1 : 0.75 + 0.25 * sin(time * 4)) * presence)
Features/Game/Rendering/GameSceneRenderer+Ancre.swift:204:        if scene.phase == .seeking && scene.phaseTime < 0.6 && !reduceMotion {
Features/Game/Rendering/GameSceneRenderer+Ancre.swift:212:                                   scale: Double, palette: DSThemePalette, reduceMotion: Bool) {
Features/Game/Rendering/GameSceneRenderer+Ancre.swift:226:                let twinkle = reduceMotion ? 1 : 0.55 + 0.45 * sin(time * (5 + 6 * b) + 30 * a)
Features/Game/Rendering/GameSceneRenderer+Oculo.swift:11:                                palette: DSThemePalette, reduceMotion: Bool) {
Features/Game/Rendering/GameSceneRenderer+Oculo.swift:16:            drawOculoElement(star, time: time, in: &context, scale: scale, palette: palette, reduceMotion: reduceMotion)
Features/Game/Rendering/GameSceneRenderer+Oculo.swift:21:                   palette: DSThemePalette, reduceMotion: Bool) {
Features/Game/Rendering/GameSceneRenderer+Oculo.swift:23:            drawAncre(ancre, time: time, in: &context, scale: scale, palette: palette, reduceMotion: reduceMotion)
Features/Game/Rendering/GameSceneRenderer+Oculo.swift:32:            drawOculoElement(element, time: time, in: &context, scale: scale, palette: palette, reduceMotion: reduceMotion)
Features/Game/Rendering/GameSceneRenderer+Oculo.swift:59:                                  palette: DSThemePalette, reduceMotion: Bool) {
Features/Game/Rendering/GameSceneRenderer+Oculo.swift:61:        let breath = reduceMotion ? 1 : 1 + 0.12 * sin(time * 3.1 + Double(element.index))
Features/Game/Rendering/GameSceneRenderer+Oculo.swift:96:            let pulse = reduceMotion ? 1 : 1 + (0.15 + 0.35 * element.phase) * sin(time * 2.1 + Double(element.index) * 0.9)
Features/Game/Rendering/GameSceneRenderer+Oculo.swift:118:                if reduceMotion {
Features/Game/Rendering/GameSceneRenderer.swift:13:    func draw(_ snapshot: GameSceneSnapshot, in context: inout GraphicsContext, size: CGSize, reduceMotion: Bool) {
Features/Game/Rendering/GameSceneRenderer.swift:16:        drawCurrents(snapshot, in: &context, reduceMotion: reduceMotion)
Features/Game/Rendering/GameSceneRenderer.swift:18:            drawGouffre(well, time: snapshot.time, in: &context, scale: scale, palette: palette, reduceMotion: reduceMotion)
Features/Game/Rendering/GameSceneRenderer.swift:32:            drawTwinPair(pair, sequential: snapshot.isSequential, time: snapshot.time, in: &context, scale: scale, palette: palette, reduceMotion: reduceMotion)
Features/Game/Rendering/GameSceneRenderer.swift:41:            drawVeilleuse(veilleuse, time: snapshot.time, in: &context, scale: scale, reduceMotion: reduceMotion)
Features/Game/Rendering/GameSceneRenderer.swift:44:            drawSouffle(souffle, time: snapshot.time, in: &context, scale: scale, palette: palette, reduceMotion: reduceMotion)
Features/Game/Rendering/GameSceneRenderer.swift:47:            drawBalise(balise, time: snapshot.time, in: &context, scale: scale, reduceMotion: reduceMotion)
Features/Game/Rendering/GameSceneRenderer.swift:50:            drawOculoConstellation(oculo, time: snapshot.time, in: &context, scale: scale, palette: palette, reduceMotion: reduceMotion)
Features/Game/Rendering/GameSceneRenderer.swift:53:                drawOculo(oculo, time: snapshot.time, in: &context, scale: scale, palette: palette, reduceMotion: reduceMotion)
Features/Game/Rendering/GameSceneRenderer.swift:64:                drawLift(lueur, time: snapshot.time, in: &context, palette: palette, reduceMotion: reduceMotion)
Features/Game/Rendering/GameSceneRenderer.swift:67:                drawSleeper(lueur, sequential: snapshot.isSequential, time: snapshot.time, in: &context, palette: palette, reduceMotion: reduceMotion)
Features/Game/Rendering/GameSceneRenderer.swift:77:            drawLueur(lueur, sequential: snapshot.isSequential, time: snapshot.time, in: &context, reduceMotion: reduceMotion)
Features/Game/Rendering/GameSceneRenderer.swift:92:    private func drawCurrents(_ snapshot: GameSceneSnapshot, in context: inout GraphicsContext, reduceMotion: Bool) {
Features/Game/Rendering/GameSceneRenderer.swift:109:                let travel = reduceMotion ? 0 : snapshot.time * speed / axisLength
Features/Game/Rendering/GameSceneRenderer.swift:207:                              scale: Double, palette: DSThemePalette, reduceMotion: Bool) {
Features/Game/Rendering/GameSceneRenderer.swift:231:        let breath = reduceMotion ? 1 : 0.94 + 0.06 * sin(time * 3)
Features/Game/Rendering/GameSceneRenderer.swift:285:                             palette: DSThemePalette, reduceMotion: Bool) {
Features/Game/Rendering/GameSceneRenderer.swift:298:        let travel = reduceMotion ? 0 : time * 1.6
Features/Game/Rendering/GameSceneRenderer.swift:315:    private func drawLift(_ lueur: LueurSnapshot, time: TimeInterval, in context: inout GraphicsContext, palette: DSThemePalette, reduceMotion: Bool) {
Features/Game/Rendering/GameSceneRenderer.swift:317:        let breath = reduceMotion ? 1 : 0.9 + 0.1 * sin(time * 6)
Features/Game/Rendering/GameSceneRenderer.swift:349:                             palette: DSThemePalette, reduceMotion: Bool) {
Features/Game/Rendering/GameSceneRenderer.swift:352:        let breath = reduceMotion ? 1 : 0.92 + 0.08 * sin(time * 1.4 + Double(lueur.sequence))
Features/Game/Rendering/GameSceneRenderer.swift:382:                             palette: DSThemePalette, reduceMotion: Bool) {
Features/Game/Rendering/GameSceneRenderer.swift:391:        let spin = reduceMotion ? 0 : time * 0.9
Features/Game/Rendering/GameSceneRenderer.swift:421:    private func drawVeilleuse(_ flame: VeilleuseSnapshot, time: TimeInterval, in context: inout GraphicsContext, scale: Double, reduceMotion: Bool) {
Features/Game/Rendering/GameSceneRenderer.swift:432:            let flicker = (flame.isLow && !reduceMotion) ? 0.85 + 0.15 * sin(time * 22) : 1
Features/Game/Rendering/GameSceneRenderer.swift:446:    private func drawLueur(_ lueur: LueurSnapshot, sequential: Bool, time: TimeInterval, in context: inout GraphicsContext, reduceMotion: Bool) {
Features/Game/Rendering/GameSceneRenderer.swift:448:            drawBraise(lueur, heat: heat, sequential: sequential, time: time, in: &context, reduceMotion: reduceMotion)
Features/Game/Rendering/GameSceneRenderer.swift:454:        let shimmer = (lueur.temperament == .vive && !reduceMotion) ? 0.8 + 0.2 * sin(time * 9 + Double(lueur.sequence)) : 1
Features/Game/Rendering/GameSceneRenderer.swift:475:            if reduceMotion {
Features/Game/Rendering/GameSceneRenderer.swift:487:    private func drawBraise(_ lueur: LueurSnapshot, heat: Double, sequential: Bool, time: TimeInterval, in context: inout GraphicsContext, reduceMotion: Bool) {
Features/Game/Rendering/GameSceneRenderer.swift:491:        let flarePulse = (lueur.isFlaring && !reduceMotion) ? 0.5 + 0.5 * sin(time * 26) : (lueur.isFlaring ? 1 : 0)
Features/Game/Rendering/GameSceneRenderer.swift:521:            if reduceMotion {
Features/Game/Rendering/GameSceneRenderer.swift:546:    private func drawBalise(_ balise: BaliseSnapshot, time: TimeInterval, in context: inout GraphicsContext, scale: Double, reduceMotion: Bool) {
Features/Game/Rendering/GameSceneRenderer.swift:552:            let breath = reduceMotion ? 1 : 1 + 0.18 * sin(time * 3.2)
Features/Game/Views/GameHUDView.swift:14:    @Environment(\.accessibilityReduceMotion) private var reduceMotion
Features/Game/Views/GameHUDView.swift:57:        .animation(DSMotion.animation(.easeInOut(duration: 0.35), reduceMotion: reduceMotion), value: hint)
Features/Game/Views/GameCanvasView.swift:9:    let reduceMotion: Bool
Features/Game/Views/GameCanvasView.swift:14:            renderer.draw(snapshot, in: &context, size: size, reduceMotion: reduceMotion)
Features/Game/Views/GameCanvasView.swift:23:    @Environment(\.accessibilityReduceMotion) private var reduceMotion
Features/Game/Views/GameCanvasView.swift:26:        GameCanvasView(snapshot: viewModel.snapshot, reduceMotion: reduceMotion)
Features/Game/Views/GameCanvasView.swift:37:                           reduceMotion: false)
Navigation/RootView.swift:10:    @Environment(\.accessibilityReduceMotion) private var reduceMotion
Navigation/RootView.swift:51:        .animation(DSMotion.animation(DSMotion.slowAnimation, reduceMotion: reduceMotion), value: coordinator.route)
Navigation/RootView.swift:80:        reduceMotion ? .opacity : .opacity.combined(with: .scale(scale: 0.985))
       0
--scenePhase
Features/GazeSetup/Views/GazeSetupView.swift:10:    @Environment(\.scenePhase) private var scenePhase
Features/GazeSetup/Views/GazeSetupView.swift:27:        .onChange(of: scenePhase) { _, phase in
Features/CameraAccess/CameraAccessView.swift:10:    @Environment(\.scenePhase) private var scenePhase
Features/CameraAccess/CameraAccessView.swift:33:        .onChange(of: scenePhase) { _, phase in
Navigation/RootView.swift:9:    @Environment(\.scenePhase) private var scenePhase
Navigation/RootView.swift:63:        .onChange(of: scenePhase) { _, phase in
Audio/Services/AVAudioEngineAudioService.swift:109:        observers.add(center.addObserver(forName: AVAudioSession.interruptionNotification, object: nil, queue: .main) { [weak self] notification in
Audio/Services/AVAudioEngineAudioService.swift:119:        observers.add(center.addObserver(forName: AVAudioSession.mediaServicesWereResetNotification, object: nil, queue: .main) { [weak self] _ in
--frames
DesignSystem/Components/DSBackground.swift:45:        Canvas { context, size in
DesignSystem/Components/DSGlyph.swift:37:        Canvas { context, size in
App/Platform/DisplayLinkGameClock.swift:3:// Purpose: CADisplayLink clock pinned to 60 Hz, the rate the reference engine was validated at
App/Platform/DisplayLinkGameClock.swift:11:    private var link: CADisplayLink?
App/Platform/DisplayLinkGameClock.swift:24:        let link = CADisplayLink(target: proxy, selector: #selector(DisplayLinkProxy.step(_:)))
App/Platform/DisplayLinkGameClock.swift:46:/// Breaks the retain cycle CADisplayLink would otherwise create with its target.
App/Platform/DisplayLinkGameClock.swift:55:    @objc func step(_ link: CADisplayLink) {
Features/Game/Views/GameCanvasView.swift:13:        Canvas(rendersAsynchronously: false) { context, size in
~~~~

#### 2026-09-14 16:35:29 +0200 (14:35:29Z) · TOOL CALL · Read
`4a1b6284` · `c0d04272` · ligne 28 · sous-agent agent-a80c23fe5e191c27f

~~~~json
{
 "file_path": "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris/Config/Info.plist"
}
~~~~

#### 2026-09-14 16:35:29 +0200 (14:35:29Z) · TOOL RESULT · Read
`4a1b6284` · `401d2b22` · ligne 29 · sous-agent agent-a80c23fe5e191c27f

~~~~text
1	<?xml version="1.0" encoding="UTF-8"?>
2	<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
3	<plist version="1.0">
4	<dict>
5		<key>CFBundleDevelopmentRegion</key>
6		<string>fr</string>
7		<key>CFBundleDisplayName</key>
8		<string>Iris</string>
9		<key>CFBundleExecutable</key>
10		<string>$(EXECUTABLE_NAME)</string>
11		<key>CFBundleIdentifier</key>
12		<string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>
13		<key>CFBundleInfoDictionaryVersion</key>
14		<string>6.0</string>
15		<key>CFBundleName</key>
16		<string>$(PRODUCT_NAME)</string>
17		<key>CFBundlePackageType</key>
18		<string>$(PRODUCT_BUNDLE_PACKAGE_TYPE)</string>
19		<key>CFBundleShortVersionString</key>
20		<string>$(MARKETING_VERSION)</string>
21		<key>CFBundleVersion</key>
22		<string>$(CURRENT_PROJECT_VERSION)</string>
23		<key>ITSAppUsesNonExemptEncryption</key>
24		<false/>
25		<key>LSApplicationCategoryType</key>
26		<string>public.app-category.games</string>
27		<key>LSRequiresIPhoneOS</key>
28		<true/>
29		<key>NSCameraUsageDescription</key>
30		<string>Iris utilise la caméra frontale TrueDepth pour détecter la direction de votre regard : c'est ce regard qui repousse les sphères du jeu. Les images restent sur l'appareil, ne sont jamais enregistrées ni envoyées.</string>
31		<key>UIApplicationSceneManifest</key>
32		<dict>
33			<key>UIApplicationSupportsMultipleScenes</key>
34			<false/>
35		</dict>
36		<key>UIApplicationSupportsIndirectInputEvents</key>
37		<true/>
38		<key>UILaunchScreen</key>
39		<dict>
40			<key>UIColorName</key>
41			<string>LaunchBackground</string>
42		</dict>
43		<key>UIRequiredDeviceCapabilities</key>
44		<array>
45			<string>arm64</string>
46			<string>front-facing-camera</string>
47		</array>
48		<key>UIRequiresFullScreen</key>
49		<true/>
50		<key>UIStatusBarStyle</key>
51		<string>UIStatusBarStyleLightContent</string>
52		<key>UISupportedInterfaceOrientations</key>
53		<array>
54			<string>UIInterfaceOrientationPortrait</string>
55		</array>
56		<key>UISupportedInterfaceOrientations~ipad</key>
57		<array>
58			<string>UIInterfaceOrientationPortrait</string>
59			<string>UIInterfaceOrientationPortraitUpsideDown</string>
60		</array>
61		<key>UIUserInterfaceStyle</key>
62		<string>Dark</string>
63	</dict>
64	</plist>
65	
~~~~

#### 2026-09-14 16:35:30 +0200 (14:35:30Z) · TOOL CALL · Read
`4a1b6284` · `54ebafe9` · ligne 30 · sous-agent agent-a80c23fe5e191c27f

~~~~json
{
 "file_path": "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris/App/Persistence/UserDefaultsProgressStore.swift"
}
~~~~

#### 2026-09-14 16:35:30 +0200 (14:35:30Z) · TOOL RESULT · Read
`4a1b6284` · `d5304f67` · ligne 31 · sous-agent agent-a80c23fe5e191c27f

~~~~text
1	// UserDefaultsProgressStore.swift
2	// Layer: App (persistence adapter)
3	// Purpose: Campaign progress stored as JSON in UserDefaults (records and éclats only, no gaze data)
4	
5	import Foundation
6	
7	final class UserDefaultsProgressStore: ProgressStore, @unchecked Sendable {
8	    private static let key = "iris.campaign.progress"
9	    private let defaults: UserDefaults
10	
11	    init(defaults: UserDefaults = .standard) {
12	        self.defaults = defaults
13	    }
14	
15	    func load() -> CampaignProgress {
16	        guard let data = defaults.data(forKey: Self.key),
17	              let progress = try? JSONDecoder().decode(CampaignProgress.self, from: data),
18	              progress.version == CampaignProgress.currentVersion else {
19	            return CampaignProgress()
20	        }
21	        return progress
22	    }
23	
24	    func save(_ progress: CampaignProgress) {
25	        guard let data = try? JSONEncoder().encode(progress) else { return }
26	        defaults.set(data, forKey: Self.key)
27	    }
28	
29	    func reset() {
30	        defaults.removeObject(forKey: Self.key)
31	    }
32	}
33	
~~~~

#### 2026-09-14 16:35:31 +0200 (14:35:31Z) · TOOL CALL · Read
`4a1b6284` · `f83f97bd` · ligne 32 · sous-agent agent-a80c23fe5e191c27f

~~~~json
{
 "file_path": "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris/App/DI/AppContainer.swift"
}
~~~~

#### 2026-09-14 16:35:31 +0200 (14:35:31Z) · TOOL RESULT · Read
`4a1b6284` · `04ce2857` · ligne 33 · sous-agent agent-a80c23fe5e191c27f

~~~~text
1	// AppContainer.swift
2	// Layer: App (DI)
3	// Purpose: Composition root. The only place concrete services are chosen.
4	
5	import Foundation
6	
7	@MainActor
8	final class AppContainer {
9	    let environment: AppEnvironment
10	    let capabilities: any DeviceCapabilities
11	    let cameraAuthorization: any CameraAuthorizationService
12	    let settings: GameSettingsStore
13	    let calibrationStore: any CalibrationStore
14	    let progressStore: any ProgressStore
15	    let orientationProvider: any InterfaceOrientationProvider
16	    let isPad: Bool
17	    let launchOptions: LaunchOptions
18	
19	    /// One gaze tracker per process, shared by the setup and the game (one ARSession, started and stopped by each screen).
20	    private(set) lazy var gazeTracking: any GazeTrackingService = makeGazeTrackingService()
21	
22	    init(environment: AppEnvironment,
23	         capabilities: any DeviceCapabilities,
24	         cameraAuthorization: any CameraAuthorizationService,
25	         settings: GameSettingsStore,
26	         calibrationStore: any CalibrationStore,
27	         progressStore: any ProgressStore,
28	         orientationProvider: any InterfaceOrientationProvider,
29	         isPad: Bool,
30	         launchOptions: LaunchOptions = .none) {
31	        self.environment = environment
32	        self.capabilities = capabilities
33	        self.cameraAuthorization = cameraAuthorization
34	        self.settings = settings
35	        self.calibrationStore = calibrationStore
36	        self.progressStore = progressStore
37	        self.orientationProvider = orientationProvider
38	        self.isPad = isPad
39	        self.launchOptions = launchOptions
40	    }
41	
42	    /// The container used by the running app. On the simulator, gaze comes from the pointer (or a scripted oracle)
43	    /// because no TrueDepth camera exists there; on a device every service is real.
44	    static func live() -> AppContainer {
45	        #if DEBUG
46	        let launchOptions = LaunchOptions.parse(ProcessInfo.processInfo.arguments)
47	        #else
48	        let launchOptions = LaunchOptions.none
49	        #endif
50	        let progressStore: any ProgressStore = launchOptions.seededProgress.map {
51	            InMemoryProgressStore(progress: LaunchOptions.progress(for: $0))
52	        } ?? UserDefaultsProgressStore()
53	        #if targetEnvironment(simulator)
54	        return AppContainer(environment: .simulator,
55	                            capabilities: StaticDeviceCapabilities(supportsFaceTracking: true),
56	                            cameraAuthorization: StubCameraAuthorizationService(status: .authorized),
57	                            settings: GameSettingsStore(),
58	                            calibrationStore: UserDefaultsCalibrationStore(),
59	                            progressStore: progressStore,
60	                            orientationProvider: WindowSceneOrientationProvider(),
61	                            isPad: DeviceIdiom.isPad,
62	                            launchOptions: launchOptions)
63	        #else
64	        return AppContainer(environment: .live,
65	                            capabilities: ARKitDeviceCapabilities(),
66	                            cameraAuthorization: AVCaptureCameraAuthorizationService(),
67	                            settings: GameSettingsStore(),
68	                            calibrationStore: UserDefaultsCalibrationStore(),
69	                            progressStore: progressStore,
70	                            orientationProvider: WindowSceneOrientationProvider(),
71	                            isPad: DeviceIdiom.isPad,
72	                            launchOptions: launchOptions)
73	        #endif
74	    }
75	
76	    static func preview(supportsFaceTracking: Bool = true,
77	                        cameraStatus: CameraAuthorizationStatus = .authorized,
78	                        calibrationStore: any CalibrationStore = InMemoryCalibrationStore(),
79	                        progressStore: any ProgressStore = InMemoryProgressStore(),
80	                        launchOptions: LaunchOptions = .none) -> AppContainer {
81	        AppContainer(environment: .preview,
82	                     capabilities: StaticDeviceCapabilities(supportsFaceTracking: supportsFaceTracking),
83	                     cameraAuthorization: StubCameraAuthorizationService(status: cameraStatus),
84	                     settings: GameSettingsStore(defaults: UserDefaults(suiteName: "iris.preview.\(UUID().uuidString)") ?? .standard),
85	                     calibrationStore: calibrationStore,
86	                     progressStore: progressStore,
87	                     orientationProvider: FixedOrientationProvider(),
88	                     isPad: false,
89	                     launchOptions: launchOptions)
90	    }
91	
92	    // MARK: Services
93	
94	    private func makeGazeTrackingService() -> any GazeTrackingService {
95	        switch environment {
96	        case .live:
97	            ARKitGazeTrackingService(capabilities: capabilities, orientationProvider: orientationProvider)
98	        case .simulator, .preview:
99	            SimulatedGazeTrackingService(parkedPoint: launchOptions.parkedGaze, oracle: launchOptions.oracleGaze)
100	        }
101	    }
102	
103	    func makeAudioService() -> any AudioService {
104	        switch environment {
105	        case .live, .simulator: AVAudioEngineAudioService()
106	        case .preview: SilentAudioService()
107	        }
108	    }
109	
110	    func makeHapticFeedbackService() -> any HapticFeedbackService {
111	        switch environment {
112	        case .live, .simulator: UIKitHapticFeedbackService()
113	        case .preview: SilentHapticFeedbackService()
114	        }
115	    }
116	
117	    func makeGameClock() -> any GameClock {
118	        switch environment {
119	        case .live, .simulator: DisplayLinkGameClock()
120	        case .preview: ManualGameClock()
121	        }
122	    }
123	
124	    // MARK: Presentation
125	
126	    func makeAppCoordinator() -> AppCoordinator {
127	        AppCoordinator(container: self)
128	    }
129	
130	    func makeGameViewModel(level: LevelDefinition, navigator: any GameNavigating) -> GameViewModel {
131	        GameViewModel(level: level,
132	                      gaze: gazeTracking,
133	                      audio: makeAudioService(),
134	                      haptics: makeHapticFeedbackService(),
135	                      clock: makeGameClock(),
136	                      settings: settings,
137	                      calibrationStore: calibrationStore,
138	                      orientation: orientationProvider,
139	                      isPad: isPad,
140	                      autoplay: launchOptions.autoplay,
141	                      navigator: navigator)
142	    }
143	
144	    func makeCameraAccessViewModel(navigator: any CameraAccessNavigating) -> CameraAccessViewModel {
145	        CameraAccessViewModel(authorization: cameraAuthorization, navigator: navigator)
146	    }
147	
148	    func makeGazeSetupViewModel(intent: GazeSetupIntent, navigator: any GazeSetupNavigating) -> GazeSetupViewModel {
149	        GazeSetupViewModel(intent: intent,
150	                           gaze: gazeTracking,
151	                           calibrationStore: calibrationStore,
152	                           capabilities: capabilities,
153	                           cameraAuthorization: cameraAuthorization,
154	                           orientation: orientationProvider,
155	                           settings: settings,
156	                           isPad: isPad,
157	                           navigator: navigator)
158	    }
159	}
160	
~~~~

#### 2026-09-14 16:35:32 +0200 (14:35:32Z) · TOOL CALL · Read
`4a1b6284` · `bec4f96e` · ligne 34 · sous-agent agent-a80c23fe5e191c27f

~~~~json
{
 "file_path": "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris/App/Platform/DisplayLinkGameClock.swift"
}
~~~~

#### 2026-09-14 16:35:32 +0200 (14:35:32Z) · TOOL RESULT · Read
`4a1b6284` · `4f8ac43e` · ligne 35 · sous-agent agent-a80c23fe5e191c27f

~~~~text
1	// DisplayLinkGameClock.swift
2	// Layer: App (platform adapter)
3	// Purpose: CADisplayLink clock pinned to 60 Hz, the rate the reference engine was validated at
4	
5	import Foundation
6	import QuartzCore
7	
8	@MainActor
9	final class DisplayLinkGameClock: GameClock {
10	    private(set) var isRunning = false
11	    private var link: CADisplayLink?
12	    private var lastTimestamp: CFTimeInterval?
13	    private var onTick: (@MainActor (TimeInterval) -> Void)?
14	    private let preferredFrameRate: Float
15	
16	    init(preferredFrameRate: Float = 60) {
17	        self.preferredFrameRate = preferredFrameRate
18	    }
19	
20	    func start(_ onTick: @escaping @MainActor (TimeInterval) -> Void) {
21	        stop()
22	        self.onTick = onTick
23	        let proxy = DisplayLinkProxy(owner: self)
24	        let link = CADisplayLink(target: proxy, selector: #selector(DisplayLinkProxy.step(_:)))
25	        link.preferredFrameRateRange = CAFrameRateRange(minimum: preferredFrameRate, maximum: preferredFrameRate, preferred: preferredFrameRate)
26	        link.add(to: .main, forMode: .common)
27	        self.link = link
28	        isRunning = true
29	    }
30	
31	    func stop() {
32	        link?.invalidate()
33	        link = nil
34	        lastTimestamp = nil
35	        onTick = nil
36	        isRunning = false
37	    }
38	
39	    fileprivate func step(timestamp: CFTimeInterval, duration: CFTimeInterval) {
40	        let delta = lastTimestamp.map { timestamp - $0 } ?? duration
41	        lastTimestamp = timestamp
42	        onTick?(delta)
43	    }
44	}
45	
46	/// Breaks the retain cycle CADisplayLink would otherwise create with its target.
47	@MainActor
48	private final class DisplayLinkProxy: NSObject {
49	    private weak var owner: DisplayLinkGameClock?
50	
51	    init(owner: DisplayLinkGameClock) {
52	        self.owner = owner
53	    }
54	
55	    @objc func step(_ link: CADisplayLink) {
56	        guard let owner else {
57	            link.invalidate()
58	            return
59	        }
60	        owner.step(timestamp: link.timestamp, duration: link.duration)
61	    }
62	}
63	
~~~~

#### 2026-09-14 16:35:32 +0200 (14:35:32Z) · TOOL CALL · Read
`4a1b6284` · `319e87a8` · ligne 36 · sous-agent agent-a80c23fe5e191c27f

~~~~json
{
 "file_path": "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris/Audio/Services/AVAudioEngineAudioService.swift"
}
~~~~

#### 2026-09-14 16:35:32 +0200 (14:35:32Z) · TOOL RESULT · Read
`4a1b6284` · `1184c74e` · ligne 37 · sous-agent agent-a80c23fe5e191c27f

~~~~text
1	// AVAudioEngineAudioService.swift
2	// Layer: Audio
3	// Purpose: AVAudioEngine host for the sine synthesizer, with audio session, interruption and reset handling
4	
5	import Foundation
6	import AVFoundation
7	
8	@MainActor
9	final class AVAudioEngineAudioService: AudioService {
10	    private(set) var status: AudioStatus = .inactive {
11	        didSet { if status != oldValue { onStatusChange?(status) } }
12	    }
13	    var onStatusChange: (@MainActor (AudioStatus) -> Void)?
14	
15	    private var engine: AVAudioEngine?
16	    private var synth: SineSynth?
17	    private let observers = NotificationObserverBag()
18	    private var wantsActivation = false
19	
20	    init() {
21	        installObservers()
22	    }
23	
24	    func activate() {
25	        wantsActivation = true
26	        do {
27	            try configureSession()
28	            try startEngine()
29	            status = .active
30	        } catch {
31	            status = .unavailable(message: error.localizedDescription)
32	        }
33	    }
34	
35	    func deactivate() {
36	        wantsActivation = false
37	        synth?.stopAllProgress()
38	        engine?.stop()
39	        try? AVAudioSession.sharedInstance().setActive(false, options: [.notifyOthersOnDeactivation])
40	        status = .inactive
41	    }
42	
43	    func apply(_ cue: AudioCue) {
44	        guard let synth, status == .active else { return }
45	        switch cue {
46	        case let .progress(voice, progress): synth.setProgress(voice: voice, progress: progress)
47	        case let .stopProgress(voice): synth.stopProgress(voice: voice)
48	        case .validation: synth.triggerChime()
49	        case .loss: synth.triggerLoss()
50	        case .levelComplete: synth.triggerCompletion()
51	        case .veilleuseLow: synth.triggerPulse()
52	        case let .ambient(frequency): synth.setAmbient(frequency: frequency)
53	        }
54	    }
55	
56	    // MARK: Engine
57	
58	    private func configureSession() throws {
59	        let session = AVAudioSession.sharedInstance()
60	        try session.setCategory(.ambient, mode: .default, options: [.mixWithOthers])
61	        try session.setActive(true)
62	    }
63	
64	    private func startEngine() throws {
65	        if let engine, engine.isRunning { return }
66	        let engine = AVAudioEngine()
67	        let sampleRate = engine.outputNode.outputFormat(forBus: 0).sampleRate
68	        let effectiveRate = sampleRate > 0 ? sampleRate : 44_100
69	        let synth = SineSynth(configuration: SineSynth.Configuration(sampleRate: effectiveRate))
70	        guard let format = AVAudioFormat(standardFormatWithSampleRate: effectiveRate, channels: 1) else {
71	            throw AudioServiceError.unsupportedFormat
72	        }
73	        // Explicitly `@Sendable`: the block runs on the real-time audio thread and must not inherit the
74	        // main-actor isolation of this method. It only touches the synthesizer, which is thread-safe by design.
75	        let source = AVAudioSourceNode(format: format) { @Sendable _, _, frameCount, audioBufferList -> OSStatus in
76	            let buffers = UnsafeMutableAudioBufferListPointer(audioBufferList)
77	            guard let first = buffers.first, let data = first.mData else { return noErr }
78	            let pointer = data.bindMemory(to: Float.self, capacity: Int(frameCount))
79	            synth.render(into: UnsafeMutableBufferPointer(start: pointer, count: Int(frameCount)))
80	            for extra in buffers.dropFirst() {
81	                if let extraData = extra.mData {
82	                    extraData.copyMemory(from: data, byteCount: Int(frameCount) * MemoryLayout<Float>.size)
83	                }
84	            }
85	            return noErr
86	        }
87	        engine.attach(source)
88	        engine.connect(source, to: engine.mainMixerNode, format: format)
89	        engine.connect(engine.mainMixerNode, to: engine.outputNode, format: nil)
90	        engine.mainMixerNode.outputVolume = 1
91	        engine.prepare()
92	        try engine.start()
93	        self.engine = engine
94	        self.synth = synth
95	    }
96	
97	    private func rebuildEngine() {
98	        engine?.stop()
99	        engine = nil
100	        synth = nil
101	        guard wantsActivation else { return }
102	        activate()
103	    }
104	
105	    // MARK: Notifications
106	
107	    private func installObservers() {
108	        let center = NotificationCenter.default
109	        observers.add(center.addObserver(forName: AVAudioSession.interruptionNotification, object: nil, queue: .main) { [weak self] notification in
110	            let typeValue = notification.userInfo?[AVAudioSessionInterruptionTypeKey] as? UInt
111	            let optionsValue = notification.userInfo?[AVAudioSessionInterruptionOptionKey] as? UInt
112	            MainActor.assumeIsolated {
113	                self?.handleInterruption(typeValue: typeValue, optionsValue: optionsValue)
114	            }
115	        })
116	        observers.add(center.addObserver(forName: .AVAudioEngineConfigurationChange, object: nil, queue: .main) { [weak self] _ in
117	            MainActor.assumeIsolated { self?.rebuildEngine() }
118	        })
119	        observers.add(center.addObserver(forName: AVAudioSession.mediaServicesWereResetNotification, object: nil, queue: .main) { [weak self] _ in
120	            MainActor.assumeIsolated { self?.rebuildEngine() }
121	        })
122	    }
123	
124	    private func handleInterruption(typeValue: UInt?, optionsValue: UInt?) {
125	        guard let typeValue, let type = AVAudioSession.InterruptionType(rawValue: typeValue) else { return }
126	        switch type {
127	        case .began:
128	            synth?.stopAllProgress()
129	            engine?.pause()
130	            if status == .active { status = .interrupted }
131	        case .ended:
132	            let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue ?? 0)
133	            guard wantsActivation, options.contains(.shouldResume) || status == .interrupted else { return }
134	            activate()
135	        @unknown default:
136	            break
137	        }
138	    }
139	}
140	
141	enum AudioServiceError: Error {
142	    case unsupportedFormat
143	}
144	
~~~~

#### 2026-09-14 16:35:33 +0200 (14:35:33Z) · TOOL CALL · Read
`4a1b6284` · `f45c52eb` · ligne 38 · sous-agent agent-a80c23fe5e191c27f

~~~~json
{
 "file_path": "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris/Audio/Synth/SineSynth.swift"
}
~~~~

#### 2026-09-14 16:35:33 +0200 (14:35:33Z) · TOOL RESULT · Read
`4a1b6284` · `c9771412` · ligne 39 · sous-agent agent-a80c23fe5e191c27f

~~~~text
1	// SineSynth.swift
2	// Layer: Audio
3	// Purpose: Allocation-free sine synthesizer reproducing the reference engine's Web Audio graph
4	// (per-target crescendo, three-note chime, descending loss tone) plus the campaign sounds (completion arpeggio,
5	// veilleuse pulse, chapter drone); render side owned by the audio thread.
6	
7	import Foundation
8	import os
9	
10	final class SineSynth: @unchecked Sendable {
11	    struct Configuration: Hashable, Sendable {
12	        var sampleRate: Double
13	        /// Up to `SineSynth.maximumVoices` (one per simultaneous target).
14	        var voiceCount: Int = 3
15	        /// Web Audio gains were tuned for desktop speakers; the iPhone speaker needs a little more, ratios are kept.
16	        var masterGain: Double = 2.0
17	        /// `setTargetAtTime` time constant used for crescendo frequency and gain.
18	        var smoothingTimeConstant: Double = 0.05
19	        /// Time constant used to fade a stopped crescendo (`stopCrescendo`).
20	        var releaseTimeConstant: Double = 0.08
21	        var progressBaseFrequency: Double = 220
22	        var progressFrequencySpan: Double = 340
23	        var progressBaseGain: Double = 0.02
24	        var progressGainSpan: Double = 0.025
25	        var chimeFrequencies: [Double] = [660, 880, 1100]
26	        var chimeNoteDuration: Double = 0.12
27	        var chimeGain: Double = 0.05
28	        var lossStartFrequency: Double = 220
29	        var lossEndFrequency: Double = 120
30	        var lossDuration: Double = 0.25
31	        var lossGain: Double = 0.05
32	        var completionFrequencies: [Double] = [440, 554.37, 659.25, 880]
33	        var completionNoteDuration: Double = 0.16
34	        var completionGain: Double = 0.05
35	        var pulseFrequency: Double = 990
36	        var pulseDuration: Double = 0.06
37	        var pulseGain: Double = 0.025
38	        /// Drone gain per voice pair, far below the gameplay sounds.
39	        var ambientGain: Double = 0.012
40	        var ambientTimeConstant: Double = 0.8
41	
42	        init(sampleRate: Double) {
43	            self.sampleRate = sampleRate
44	        }
45	    }
46	
47	    struct VoiceCommand: Hashable, Sendable {
48	        var isActive = false
49	        var frequency: Double = 220
50	        var gain: Double = 0
51	    }
52	
53	    /// Fixed-size storage: copying it never touches the heap, so the render thread stays allocation-free.
54	    private struct Commands: Sendable {
55	        var voice0 = VoiceCommand()
56	        var voice1 = VoiceCommand()
57	        var voice2 = VoiceCommand()
58	        var chimeGeneration: UInt32 = 0
59	        var lossGeneration: UInt32 = 0
60	        var completionGeneration: UInt32 = 0
61	        var pulseGeneration: UInt32 = 0
62	        var ambientFrequency: Double = 110
63	        var ambientActive = false
64	
65	        subscript(voice voice: Int) -> VoiceCommand {
66	            get {
67	                switch voice {
68	                case 0: voice0
69	                case 1: voice1
70	                default: voice2
71	                }
72	            }
73	            set {
74	                switch voice {
75	                case 0: voice0 = newValue
76	                case 1: voice1 = newValue
77	                default: voice2 = newValue
78	                }
79	            }
80	        }
81	
82	        mutating func deactivateAll() {
83	            voice0.isActive = false
84	            voice1.isActive = false
85	            voice2.isActive = false
86	        }
87	    }
88	
89	    static let maximumVoices = 3
90	
91	    private struct VoiceRuntime {
92	        var phase: Double = 0
93	        var frequency: Double = 220
94	        var gain: Double = 0
95	    }
96	
97	    private struct OneShotRuntime {
98	        var startSample: Int64 = -1
99	        var phase: Double = 0
100	    }
101	
102	    let configuration: Configuration
103	    private let commands: OSAllocatedUnfairLock<Commands>
104	
105	    // Render-thread state. Arrays are allocated once and mutated in place.
106	    private var voices: [VoiceRuntime]
107	    private var lastCommands: Commands
108	    private var chime = OneShotRuntime()
109	    private var loss = OneShotRuntime()
110	    private var completion = OneShotRuntime()
111	    private var pulse = OneShotRuntime()
112	    private var ambientPhaseA = 0.0
113	    private var ambientPhaseB = 0.0
114	    private var ambientLevel = 0.0
115	    private var sampleClock: Int64 = 0
116	    private let smoothingCoefficient: Double
117	    private let releaseCoefficient: Double
118	    private let twoPiOverSampleRate: Double
119	    private let ambientCoefficient: Double
120	
121	    init(configuration: Configuration) {
122	        var configuration = configuration
123	        configuration.voiceCount = min(max(configuration.voiceCount, 1), Self.maximumVoices)
124	        self.configuration = configuration
125	        let initial = Commands()
126	        commands = OSAllocatedUnfairLock(initialState: initial)
127	        lastCommands = initial
128	        voices = Array(repeating: VoiceRuntime(), count: configuration.voiceCount)
129	        smoothingCoefficient = 1 - exp(-1 / (configuration.smoothingTimeConstant * configuration.sampleRate))
130	        releaseCoefficient = 1 - exp(-1 / (configuration.releaseTimeConstant * configuration.sampleRate))
131	        twoPiOverSampleRate = 2 * .pi / configuration.sampleRate
132	        ambientCoefficient = 1 - exp(-1 / (configuration.ambientTimeConstant * configuration.sampleRate))
133	    }
134	
135	    // MARK: Control side (any thread)
136	
137	    func setProgress(voice: Int, progress: Double) {
138	        guard voice >= 0 && voice < configuration.voiceCount else { return }
139	        let clamped = min(max(progress, 0), 1)
140	        let command = VoiceCommand(isActive: true,
141	                                   frequency: configuration.progressBaseFrequency + clamped * configuration.progressFrequencySpan,
142	                                   gain: configuration.progressBaseGain + clamped * configuration.progressGainSpan)
143	        commands.withLock { $0[voice: voice] = command }
144	    }
145	
146	    func stopProgress(voice: Int) {
147	        guard voice >= 0 && voice < configuration.voiceCount else { return }
148	        commands.withLock { $0[voice: voice].isActive = false }
149	    }
150	
151	    func stopAllProgress() {
152	        commands.withLock { $0.deactivateAll() }
153	    }
154	
155	    func triggerChime() {
156	        commands.withLock { $0.chimeGeneration &+= 1 }
157	    }
158	
159	    func triggerLoss() {
160	        commands.withLock { $0.lossGeneration &+= 1 }
161	    }
162	
163	    func triggerCompletion() {
164	        commands.withLock { $0.completionGeneration &+= 1 }
165	    }
166	
167	    func triggerPulse() {
168	        commands.withLock { $0.pulseGeneration &+= 1 }
169	    }
170	
171	    /// Starts (or retunes) the chapter drone; nil fades it out.
172	    func setAmbient(frequency: Double?) {
173	        commands.withLock { state in
174	            if let frequency {
175	                state.ambientFrequency = frequency
176	                state.ambientActive = true
177	            } else {
178	                state.ambientActive = false
179	            }
180	        }
181	    }
182	
183	    // MARK: Render side (audio thread only)
184	
185	    /// Fills `buffer` with mono samples. Never blocks: if the control lock is busy the previous commands are reused.
186	    func render(into buffer: UnsafeMutableBufferPointer<Float>) {
187	        if let fresh = commands.withLockIfAvailable({ $0 }) {
188	            if fresh.chimeGeneration != lastCommands.chimeGeneration {
189	                chime.startSample = sampleClock
190	                chime.phase = 0
191	            }
192	            if fresh.lossGeneration != lastCommands.lossGeneration {
193	                loss.startSample = sampleClock
194	                loss.phase = 0
195	            }
196	            if fresh.completionGeneration != lastCommands.completionGeneration {
197	                completion.startSample = sampleClock
198	                chime.startSample = -1
199	            }
200	            if fresh.pulseGeneration != lastCommands.pulseGeneration {
201	                pulse.startSample = sampleClock
202	            }
203	            lastCommands = fresh
204	        }
205	        let commandsNow = lastCommands
206	        let master = configuration.masterGain
207	        for frame in 0..<buffer.count {
208	            var mix = 0.0
209	            for index in voices.indices {
210	                let command = commandsNow[voice: index]
211	                var voice = voices[index]
212	                if command.isActive {
213	                    voice.frequency += (command.frequency - voice.frequency) * smoothingCoefficient
214	                    voice.gain += (command.gain - voice.gain) * smoothingCoefficient
215	                } else {
216	                    voice.gain += (0 - voice.gain) * releaseCoefficient
217	                }
218	                if voice.gain > 1e-5 {
219	                    voice.phase += voice.frequency * twoPiOverSampleRate
220	                    if voice.phase > 2 * .pi { voice.phase -= 2 * .pi }
221	                    mix += sin(voice.phase) * voice.gain
222	                }
223	                voices[index] = voice
224	            }
225	            mix += Self.phrase(&chime, sampleClock: sampleClock, sampleRate: configuration.sampleRate,
226	                               frequencies: configuration.chimeFrequencies, noteDuration: configuration.chimeNoteDuration,
227	                               gain: configuration.chimeGain)
228	            mix += Self.phrase(&completion, sampleClock: sampleClock, sampleRate: configuration.sampleRate,
229	                               frequencies: configuration.completionFrequencies, noteDuration: configuration.completionNoteDuration,
230	                               gain: configuration.completionGain)
231	            mix += renderLoss()
232	            mix += renderPulse()
233	            mix += renderAmbient(commandsNow)
234	            buffer[frame] = Float(mix * master)
235	            sampleClock += 1
236	        }
237	    }
238	
239	    /// A sequence of equal notes with a 30 percent attack and a linear release, stopping by itself.
240	    private static func phrase(_ runtime: inout OneShotRuntime, sampleClock: Int64, sampleRate: Double,
241	                               frequencies: [Double], noteDuration: Double, gain: Double) -> Double {
242	        guard runtime.startSample >= 0, !frequencies.isEmpty else { return 0 }
243	        let elapsed = Double(sampleClock - runtime.startSample) / sampleRate
244	        let total = noteDuration * Double(frequencies.count)
245	        if elapsed >= total {
246	            runtime.startSample = -1
247	            return 0
248	        }
249	        let noteIndex = min(Int(elapsed / noteDuration), frequencies.count - 1)
250	        let noteTime = elapsed - Double(noteIndex) * noteDuration
251	        let attack = noteDuration * 0.3
252	        let envelope: Double
253	        if noteTime < attack {
254	            envelope = gain * (noteTime / attack)
255	        } else {
256	            envelope = gain * (1 - (noteTime - attack) / (noteDuration - attack))
257	        }
258	        return sin(2 * .pi * frequencies[noteIndex] * noteTime) * max(envelope, 0)
259	    }
260	
261	    private func renderPulse() -> Double {
262	        guard pulse.startSample >= 0 else { return 0 }
263	        let elapsed = Double(sampleClock - pulse.startSample) / configuration.sampleRate
264	        if elapsed >= configuration.pulseDuration {
265	            pulse.startSample = -1
266	            return 0
267	        }
268	        let envelope = sin(Double.pi * elapsed / configuration.pulseDuration)
269	        return sin(2 * .pi * configuration.pulseFrequency * elapsed) * configuration.pulseGain * envelope
270	    }
271	
272	    private func renderAmbient(_ commandsNow: Commands) -> Double {
273	        let target = commandsNow.ambientActive ? configuration.ambientGain : 0
274	        ambientLevel += (target - ambientLevel) * ambientCoefficient
275	        guard ambientLevel > 1e-6 else { return 0 }
276	        ambientPhaseA += commandsNow.ambientFrequency * twoPiOverSampleRate
277	        ambientPhaseB += commandsNow.ambientFrequency * 1.5 * twoPiOverSampleRate
278	        if ambientPhaseA > 2 * .pi { ambientPhaseA -= 2 * .pi }
279	        if ambientPhaseB > 2 * .pi { ambientPhaseB -= 2 * .pi }
280	        return (sin(ambientPhaseA) * 0.6 + sin(ambientPhaseB) * 0.4) * ambientLevel
281	    }
282	
283	    private func renderLoss() -> Double {
284	        guard loss.startSample >= 0 else { return 0 }
285	        let elapsed = Double(sampleClock - loss.startSample) / configuration.sampleRate
286	        if elapsed >= configuration.lossDuration {
287	            loss.startSample = -1
288	            return 0
289	        }
290	        let progress = elapsed / configuration.lossDuration
291	        let frequency = configuration.lossStartFrequency + (configuration.lossEndFrequency - configuration.lossStartFrequency) * progress
292	        let gain = configuration.lossGain * (1 - progress)
293	        loss.phase += frequency * twoPiOverSampleRate
294	        if loss.phase > 2 * .pi { loss.phase -= 2 * .pi }
295	        return sin(loss.phase) * gain
296	    }
297	}
298	
~~~~

#### 2026-09-14 16:35:43 +0200 (14:35:43Z) · TOOL CALL · Read
`4a1b6284` · `dfe3a411` · ligne 43 · sous-agent agent-a80c23fe5e191c27f

~~~~json
{
 "file_path": "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris/Features/Game/ViewModels/GameViewModel.swift"
}
~~~~

#### 2026-09-14 16:35:43 +0200 (14:35:43Z) · TOOL RESULT · Read
`4a1b6284` · `3871e510` · ligne 44 · sous-agent agent-a80c23fe5e191c27f

~~~~text
1	// GameViewModel.swift
2	// Layer: Presentation
3	// Purpose: Owns one play session: campaign level, engine loop, gaze mapping, hints, audio, haptics, results and phases
4	
5	import Foundation
6	import Observation
7	import os
8	
9	@MainActor
10	@Observable
11	final class GameViewModel {
12	    // Coarse state read by HUD and overlays.
13	    private(set) var phase: GamePhase = .initializing
14	    private(set) var level: LevelDefinition
15	    private(set) var chapter: ChapterDefinition
16	    private(set) var hint: String?
17	    private(set) var gazeState: GazeTrackingState = .idle
18	    private(set) var audioStatus: AudioStatus = .inactive
19	    private(set) var calibrationStatus: GazeCalibrationStatus = .uncalibrated
20	
21	    // Per-frame state read by the canvas only.
22	    private(set) var snapshot: GameSceneSnapshot
23	
24	    var showsGazeIndicator: Bool {
25	        get { settings.showsGazeIndicator }
26	        set {
27	            settings.showsGazeIndicator = newValue
28	            refreshSnapshot()
29	        }
30	    }
31	
32	    var isSimulatedGaze: Bool { gaze is SimulatedGazeTrackingService }
33	
34	    /// Face absence tolerated while playing before the game pauses itself (the reference engine's FACE_LOST_TIMEOUT).
35	    static let faceLostTimeout: TimeInterval = 0.3
36	    /// Seconds before the route help or the empty-space advice appears.
37	    static let helpDelay: TimeInterval = 45
38	
39	    @ObservationIgnored private var bounds: PlayfieldBounds = .referencePhone
40	    @ObservationIgnored private var resolved: ResolvedLevel
41	    @ObservationIgnored private var session: GameSession
42	    @ObservationIgnored private var hints: HintTracker
43	    @ObservationIgnored private var hintsBegun = false
44	    @ObservationIgnored private var showsRoute = false
45	    @ObservationIgnored private var nominal: NominalDisplayGeometry?
46	    @ObservationIgnored private var mapper: GazeMapper?
47	    @ObservationIgnored private var diagnostics = GazeDiagnostics()
48	    @ObservationIgnored private var cuePolicy = AudioCuePolicy()
49	    @ObservationIgnored private var hapticPolicy = HapticCuePolicy()
50	    @ObservationIgnored private var levelInProgress = false
51	    @ObservationIgnored private var phaseBeforeSuspension: GamePhase?
52	    @ObservationIgnored private var isPrepared = false
53	    @ObservationIgnored private var faceLostDuration: TimeInterval = 0
54	    @ObservationIgnored private var sampleCounter = 0
55	    /// True while this ViewModel owns the shared gaze tracker's callbacks. Cleared by teardown so that a late
56	    /// `onDisappear` (SwiftUI transitions overlap) never stops a session another screen has just started.
57	    @ObservationIgnored private var ownsGaze = false
58	
59	    @ObservationIgnored private let gaze: any GazeTrackingService
60	    @ObservationIgnored private let audio: any AudioService
61	    @ObservationIgnored private let haptics: any HapticFeedbackService
62	    @ObservationIgnored private let clock: any GameClock
63	    @ObservationIgnored private let settings: GameSettingsStore
64	    @ObservationIgnored private let calibrationStore: any CalibrationStore
65	    @ObservationIgnored private let orientation: any InterfaceOrientationProvider
66	    @ObservationIgnored private let isPad: Bool
67	    @ObservationIgnored private let autoplay: Bool
68	    @ObservationIgnored private weak var navigator: (any GameNavigating)?
69	    @ObservationIgnored private let logger = Logger(subsystem: "net.steve-s.iris", category: "game")
70	    #if DEBUG
71	    /// PROTOTYPE (chapter I level 6): observation-only trace; nil for every other level. Never steers the game.
72	    @ObservationIgnored private(set) var oculoTrace: OculomotorTrace?
73	    /// One DEBUG line for the HUD diagnostics (shown only with the gaze indicator).
74	    private(set) var oculoStatus: String?
75	    /// Chapter X final: the JSON Lines capture, only when the app was launched with `--iris-capture`.
76	    @ObservationIgnored private var ancreCapture: AncreCapture?
77	    #endif
78	
79	    init(level: LevelDefinition,
80	         gaze: any GazeTrackingService,
81	         audio: any AudioService,
82	         haptics: any HapticFeedbackService,
83	         clock: any GameClock,
84	         settings: GameSettingsStore,
85	         calibrationStore: any CalibrationStore,
86	         orientation: any InterfaceOrientationProvider,
87	         isPad: Bool,
88	         autoplay: Bool = false,
89	         navigator: any GameNavigating) {
90	        let chapter = Self.chapter(of: level)
91	        self.level = level
92	        self.chapter = chapter
93	        let resolved = LevelResolver.resolve(level, in: .referencePhone)
94	        let session = resolved.makeSession()
95	        self.resolved = resolved
96	        self.session = session
97	        self.hints = HintTracker.forLevel(level, helpDelay: Self.helpDelay)
98	        self.snapshot = GameSceneSnapshot(session: session, resolved: resolved, showsRoute: false,
99	                                          showsGaze: settings.showsGazeIndicator, diagnostics: nil, theme: chapter.theme)
100	        self.gaze = gaze
101	        self.audio = audio
102	        self.haptics = haptics
103	        self.clock = clock
104	        self.settings = settings
105	        self.calibrationStore = calibrationStore
106	        self.orientation = orientation
107	        self.isPad = isPad
108	        self.autoplay = autoplay
109	        self.navigator = navigator
110	    }
111	
112	    // MARK: Lifecycle
113	
114	    /// Called by the view once its size is known. Builds the gaze mapper, loads the level, starts tracking and audio.
115	    func prepare(width: Double, height: Double, displayScale: Double) {
116	        let newBounds = PlayfieldBounds(width: width, height: height)
117	        let geometry = NominalDisplayGeometry.estimate(viewport: newBounds, displayScale: displayScale, isPad: isPad)
118	        if isPrepared {
119	            gaze.updateViewport(GazeViewport(bounds: bounds, nominal: geometry))
120	            return
121	        }
122	        isPrepared = true
123	        bounds = newBounds
124	        nominal = geometry
125	        reloadCalibration()
126	        loadLevel(level)
127	        wireServices()
128	        phase = .initializing
129	        gaze.start(viewport: GazeViewport(bounds: bounds, nominal: geometry))
130	        activateAudio()
131	    }
132	
133	    /// Rebuilds the mapper from the stored profile (after a recalibration or at start).
134	    func reloadCalibration() {
135	        guard let nominal else { return }
136	        let orientationName = orientation.interfaceOrientation.irisName
137	        if let profile = calibrationStore.load(), profile.isUsable(viewport: bounds, interfaceOrientation: orientationName) {
138	            mapper = GazeMapper(viewport: bounds, profile: profile)
139	            calibrationStatus = .calibrated(meanError: profile.validationMeanError, isValid: profile.isValid)
140	            logger.info("calibration loaded: valid \(profile.isValid)")
141	        } else {
142	            mapper = GazeMapper(viewport: bounds, nominal: nominal)
143	            calibrationStatus = .uncalibrated
144	            logger.info("no usable calibration, nominal mapping in use")
145	        }
146	    }
147	
148	    func viewDisappeared() {
149	        guard ownsGaze else { return }
150	        teardown()
151	    }
152	
153	    // MARK: Player intents
154	
155	    /// Tap on the scene or the main button: starts, resumes or moves on depending on the phase.
156	    func primaryAction() {
157	        switch phase {
158	        case .ready, .paused, .resuming:
159	            play()
160	        case let .levelComplete(result):
161	            if result.isCampaignEnd {
162	                finishCampaign()
163	            } else if result.hasNextLevel {
164	                playNext()
165	            } else {
166	                openChapters()
167	            }
168	        case .initializing, .playing, .interrupted, .faceLost, .suspended, .failed:
169	            break
170	        }
171	    }
172	
173	    func pause() {
174	        guard phase == .playing else { return }
175	        haltLoop()
176	        phase = .paused
177	    }
178	
179	    func restartLevel() {
180	        guard phase == .paused || phase == .playing || phase == .resuming else { return }
181	        haltLoop()
182	        loadLevel(level)
183	        phase = .ready
184	    }
185	
186	    func replay() {
187	        guard case .levelComplete = phase else { return }
188	        loadLevel(level)
189	        phase = .ready
190	    }
191	
192	    func playNext() {
193	        guard case .levelComplete = phase, let next = Self.next(after: level) else { return }
194	        let chapterChanged = next.chapter != level.chapter
195	        loadLevel(next)
196	        if chapterChanged && settings.ambienceEnabled {
197	            audio.apply(.ambient(frequency: chapter.ambientFrequency))
198	        }
199	        phase = .ready
200	    }
201	
202	    func openChapters() {
203	        teardown()
204	        navigator?.gameDidRequestChapters()
205	    }
206	
207	    func retryAfterFailure() {
208	        guard case .failed = phase, let nominal else { return }
209	        phase = .initializing
210	        if !ownsGaze { wireServices() }
211	        gaze.start(viewport: GazeViewport(bounds: bounds, nominal: nominal))
212	        activateAudio()
213	    }
214	
215	    func exit() {
216	        teardown()
217	        navigator?.gameDidRequestExit()
218	    }
219	
220	    /// Leaves the game screen for the gaze setup (recalibration) and keeps the level.
221	    func requestRecalibration() {
222	        guard phase == .paused else { return }
223	        phaseBeforeSuspension = .paused
224	        haltLoop()
225	        releaseGaze()
226	        deactivateAudio()
227	        phase = .suspended
228	        navigator?.gameDidRequestRecalibration()
229	    }
230	
231	    /// Back from the gaze setup: reload the profile and restart tracking.
232	    func resumeAfterRecalibration() {
233	        guard phase == .suspended, let nominal else { return }
234	        reloadCalibration()
235	        wireServices()
236	        phase = .initializing
237	        gaze.start(viewport: GazeViewport(bounds: bounds, nominal: nominal))
238	        activateAudio()
239	    }
240	
241	    /// Simulator and previews only: the pointer plays the role of the gaze.
242	    func simulatePointer(x: Double, y: Double, timestamp: TimeInterval) {
243	        (gaze as? SimulatedGazeTrackingService)?.inject(point: Vector2(x: x, y: y), timestamp: timestamp)
244	    }
245	
246	    // MARK: Scene phase
247	
248	    func suspend() {
249	        guard isPrepared, phase != .suspended, !isFailed else { return }
250	        phaseBeforeSuspension = phase
251	        haltLoop()
252	        gaze.pause()
253	        deactivateAudio()
254	        phase = .suspended
255	    }
256	
257	    func wake() {
258	        guard phase == .suspended, let nominal else { return }
259	        phase = .initializing
260	        if ownsGaze {
261	            gaze.resume()
262	        } else {
263	            wireServices()
264	            gaze.start(viewport: GazeViewport(bounds: bounds, nominal: nominal))
265	        }
266	        activateAudio()
267	    }
268	
269	    // MARK: Loop
270	
271	    private func play() {
272	        phase = .playing
273	        levelInProgress = true
274	        faceLostDuration = 0
275	        seedCursorIfNeeded()
276	        if !hintsBegun {
277	            hintsBegun = true
278	            hints.begin()
279	            hint = hints.current
280	        }
281	        clock.start { [weak self] deltaTime in
282	            self?.tick(deltaTime)
283	        }
284	    }
285	
286	    /// Samples already flow before the first tap, so the cursor starts exactly at the current gaze.
287	    private func seedCursorIfNeeded() {
288	        guard !session.gaze.isActive, let sample = gaze.latestSample, let point = mapper?.screenPoint(sample) else { return }
289	        session.placeGaze(at: point)
290	        refreshSnapshot()
291	    }
292	
293	    private func tick(_ deltaTime: TimeInterval) {
294	        guard phase == .playing else { return }
295	        if case .tracking(false) = gazeState {
296	            faceLostDuration += deltaTime
297	            if faceLostDuration >= Self.faceLostTimeout {
298	                haltLoop()
299	                phase = .faceLost
300	                #if DEBUG
301	                ancreCapture?.mark("faceLostWarning", session: session, phase: phase)
302	                #endif
303	                return
304	            }
305	        } else {
306	            faceLostDuration = 0
307	        }
308	        let events = session.advance(by: deltaTime)
309	        #if DEBUG
310	        oculoTrace?.observeTick(session: session, events: events)
311	        ancreCapture?.observeTick(session: session, phase: phase, events: events)
312	        #endif
313	        if settings.soundEffectsEnabled {
314	            for cue in cuePolicy.cues(for: events, at: session.elapsed) {
315	                audio.apply(cue)
316	            }
317	        }
318	        if settings.hapticsEnabled {
319	            for cue in hapticPolicy.cues(for: events, at: session.elapsed) {
320	                haptics.play(cue)
321	            }
322	        }
323	        if hints.observe(events: events, elapsed: session.elapsed) {
324	            hint = hints.current
325	        }
326	        if !showsRoute && level.requiresPushing && session.elapsed >= Self.helpDelay {
327	            showsRoute = true
328	        }
329	        refreshSnapshot()
330	        if events.contains(.levelCompleted) {
331	            completeLevel()
332	        }
333	    }
334	
335	    private func completeLevel() {
336	        haltLoop()
337	        #if DEBUG
338	        ancreCapture?.stop(reason: "level complete")
339	        #endif
340	        levelInProgress = false
341	        hint = nil
342	        let outcome = LevelOutcome(time: session.elapsed, intrusions: session.metrics.intrusions, losses: session.metrics.losses)
343	        let previous = navigator?.gameDidComplete(level: level, outcome: outcome) ?? LevelRecord()
344	        let earned = outcome.eclats(par: level.par)
345	        let next = Self.next(after: level)
346	        phase = .levelComplete(LevelResult(levelID: level.id,
347	                                           outcome: outcome,
348	                                           earned: earned,
349	                                           newlyEarned: earned.subtracting(previous.eclats),
350	                                           isNewBestTime: previous.bestTime.map { outcome.time < $0 } ?? false,
351	                                           hasNextLevel: next != nil,
352	                                           isChapterEnd: !level.isExperimental && Campaign.isLastInChapter(level),
353	                                           isCampaignEnd: !level.isExperimental && next == nil))
354	        logger.info("level \(self.level.id, privacy: .public) completed in \(outcome.time, format: .fixed(precision: 1)) s, intrusions \(outcome.intrusions), losses \(outcome.losses)")
355	    }
356	
357	    private func finishCampaign() {
358	        teardown()
359	        navigator?.gameDidFinishCampaign()
360	    }
361	
362	    /// Campaign chapters, plus the experimental chapter in DEBUG builds (prototype levels are never in the campaign).
363	    private static func chapter(of level: LevelDefinition) -> ChapterDefinition {
364	        if let chapter = Campaign.chapter(of: level) { return chapter }
365	        #if DEBUG
366	        if let chapter = BraisesPrototype.chapter(of: level) { return chapter }
367	        #endif
368	        return Campaign.chapters[0]
369	    }
370	
371	    private static func next(after level: LevelDefinition) -> LevelDefinition? {
372	        #if DEBUG
373	        if level.isExperimental { return BraisesPrototype.next(after: level) }
374	        #endif
375	        return Campaign.next(after: level)
376	    }
377	
378	    private func loadLevel(_ definition: LevelDefinition) {
379	        level = definition
380	        chapter = Self.chapter(of: definition)
381	        resolved = LevelResolver.resolve(definition, in: bounds)
382	        session = resolved.makeSession()
383	        hints = HintTracker.forLevel(definition, helpDelay: Self.helpDelay)
384	        hintsBegun = false
385	        hint = nil
386	        showsRoute = false
387	        cuePolicy.reset()
388	        hapticPolicy.reset()
389	        faceLostDuration = 0
390	        levelInProgress = false
391	        #if DEBUG
392	        if let balises = definition.balises {
393	            oculoTrace = OculomotorTrace(names: balises.balises.map(\.name))
394	        } else if let oculo = definition.oculo {
395	            oculoTrace = OculomotorTrace(names: oculo.stages.indices.map { "stage\($0 + 1)" })
396	        } else {
397	            oculoTrace = nil
398	        }
399	        oculoStatus = nil
400	        ancreCapture?.stop(reason: "another level")
401	        ancreCapture = AncreCapture(level: definition)
402	        #endif
403	        refreshSnapshot()
404	        navigator?.gameDidStart(level: definition)
405	    }
406	
407	    private func refreshSnapshot() {
408	        snapshot = GameSceneSnapshot(session: session, resolved: resolved, showsRoute: showsRoute,
409	                                     showsGaze: settings.showsGazeIndicator, diagnostics: diagnostics, theme: chapter.theme)
410	    }
411	
412	    /// Stops ticking and silences every crescendo voice; the scene stays as it is.
413	    private func haltLoop() {
414	        clock.stop()
415	        for voice in 0..<3 {
416	            audio.apply(.stopProgress(voice: voice))
417	        }
418	    }
419	
420	    private func fail(_ failure: GameFailure) {
421	        haltLoop()
422	        phase = .failed(failure)
423	    }
424	
425	    private func teardown() {
426	        haltLoop()
427	        #if DEBUG
428	        ancreCapture?.stop(reason: "left the game")
429	        #endif
430	        releaseGaze()
431	        deactivateAudio()
432	    }
433	
434	    private func releaseGaze() {
435	        guard ownsGaze else { return }
436	        ownsGaze = false
437	        gaze.onSample = nil
438	        gaze.onStateChange = nil
439	        gaze.stop()
440	    }
441	
442	    /// The engine runs when effects or ambience are wanted; the drone plays only if the ambience is wanted.
443	    private func activateAudio() {
444	        guard settings.wantsAudio else { return }
445	        audio.activate()
446	        if settings.ambienceEnabled {
447	            audio.apply(.ambient(frequency: chapter.ambientFrequency))
448	        }
449	    }
450	
451	    private func deactivateAudio() {
452	        audio.apply(.ambient(frequency: nil))
453	        audio.deactivate()
454	    }
455	
456	    // MARK: Services
457	
458	    private func wireServices() {
459	        ownsGaze = true
460	        gaze.onStateChange = { [weak self] state in
461	            self?.handleGazeState(state)
462	        }
463	        gaze.onSample = { [weak self] sample in
464	            self?.handleGazeSample(sample)
465	        }
466	        audio.onStatusChange = { [weak self] status in
467	            self?.audioStatus = status
468	        }
469	        audioStatus = audio.status
470	        gazeState = gaze.state
471	    }
472	
473	    private func handleGazeSample(_ sample: RawGazeSample) {
474	        guard let mapper else { return }
475	        let mapped = mapper.screenPoint(sample)
476	        #if DEBUG
477	        if let oculoTrace {
478	            oculoTrace.observeSample(mapped: mapped, sample: sample, bounds: bounds)
479	            if settings.showsGazeIndicator { oculoStatus = oculoTrace.statusLine }
480	        }
481	        if let ancreCapture {
482	            var faceTracked: Bool?
483	            if case let .tracking(visible) = gazeState { faceTracked = visible }
484	            ancreCapture.observeSample(session: session, phase: phase, faceTracked: faceTracked, observation: sample.observation,
485	                                       screenHead: sample.observation.map { Self.screenHead($0, mapping: mapper.axisMapping) }, mapped: mapped,
486	                                       gazeState: oculoTrace?.state.rawValue ?? (mapped == nil ? "INVALID" : "UNKNOWN"), bounds: bounds,
487	                                       timestamp: sample.timestamp)
488	        }
489	        #endif
490	        if settings.showsGazeIndicator {
491	            var edge: GazeDiagnostics.Edge?
492	            #if DEBUG
493	            edge = oculoTrace?.lastEdge.flatMap { GazeDiagnostics.Edge(rawValue: $0.rawValue.lowercased()) }
494	            #endif
495	            diagnostics = GazeDiagnostics(raw: mapper.rawScreenPoint(sample), calibrated: mapped, edge: edge)
496	            sampleCounter += 1
497	            if phase != .playing, sampleCounter.isMultiple(of: 3) {
498	                refreshSnapshot()
499	            }
500	        }
501	        guard phase == .playing, let point = mapped else { return }
502	        session.ingestGaze(point)
503	        // OCULOMOTOR EXPANSION: the stages that ask for the head read it from the same observation, oriented like the
504	        // screen by the calibration's axis mapping (the one that already places the gaze), so no axis sign is assumed.
505	        session.ingestHeadPose(sample.observation.map { Self.screenHead($0, mapping: mapper.axisMapping) })
506	    }
507	
508	    /// View-frame head angles in screen terms: yaw toward the screen's right as the player sees it, pitch toward its top.
509	    /// The mapping only swaps or flips the two in-plane axes, so the size of a head turn is unchanged.
510	    nonisolated static func screenHead(_ observation: GazeObservation, mapping: AxisMapping) -> HeadPose {
511	        let screen = mapping.screenCoordinates(of: SIMD2(observation.headYaw, observation.headPitch))
512	        return HeadPose(yaw: screen.x, pitch: screen.y)
513	    }
514	
515	    private func handleGazeState(_ state: GazeTrackingState) {
516	        gazeState = state
517	        switch state {
518	        case let .tracking(faceVisible):
519	            #if DEBUG
520	            oculoTrace?.observeFaceVisible(faceVisible)
521	            if settings.showsGazeIndicator, let oculoTrace { oculoStatus = oculoTrace.statusLine }
522	            ancreCapture?.mark(faceVisible ? "faceVisible" : "faceHidden", session: session, phase: phase, faceTracked: faceVisible)
523	            #endif
524	            if faceVisible {
525	                trackingBecameAvailable()
526	            }
527	        case .interrupted:
528	            if phase == .playing {
529	                haltLoop()
530	            }
531	            if phase == .playing || phase == .paused || phase == .ready || phase == .resuming || phase == .initializing || phase == .faceLost {
532	                phase = .interrupted
533	            }
534	        case let .unavailable(reason):
535	            fail(Self.failure(for: reason))
536	        case let .failed(message):
537	            fail(.trackingError(message: message))
538	        case .idle, .starting:
539	            break
540	        }
541	    }
542	
543	    private func trackingBecameAvailable() {
544	        switch phase {
545	        case .initializing:
546	            if let previous = phaseBeforeSuspension {
547	                phaseBeforeSuspension = nil
548	                phase = Self.phaseAfterReturn(from: previous, levelInProgress: levelInProgress)
549	            } else if autoplay {
550	                play()
551	            } else {
552	                phase = .ready
553	            }
554	        case .interrupted:
555	            phase = levelInProgress ? .resuming : .ready
556	        case .faceLost:
557	            play()
558	        case .ready, .playing, .paused, .levelComplete, .resuming, .suspended, .failed:
559	            break
560	        }
561	    }
562	
563	    private static func phaseAfterReturn(from previous: GamePhase, levelInProgress: Bool) -> GamePhase {
564	        switch previous {
565	        case .playing, .paused, .resuming, .interrupted, .faceLost:
566	            levelInProgress ? .resuming : .ready
567	        case let .levelComplete(result):
568	            .levelComplete(result)
569	        case .initializing, .ready, .suspended, .failed:
570	            .ready
571	        }
572	    }
573	
574	    private static func failure(for reason: GazeUnavailabilityReason) -> GameFailure {
575	        switch reason {
576	        case .faceTrackingUnsupported: .faceTrackingUnsupported
577	        case .cameraDenied: .cameraDenied
578	        case .cameraRestricted: .cameraRestricted
579	        }
580	    }
581	
582	    private var isFailed: Bool {
583	        if case .failed = phase { return true }
584	        return false
585	    }
586	}
587	
~~~~

#### 2026-09-14 16:35:44 +0200 (14:35:44Z) · TOOL CALL · Read
`4a1b6284` · `2dc86a15` · ligne 45 · sous-agent agent-a80c23fe5e191c27f

~~~~json
{
 "file_path": "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris/Navigation/RootView.swift"
}
~~~~

#### 2026-09-14 16:35:44 +0200 (14:35:44Z) · TOOL RESULT · Read
`4a1b6284` · `c9faa733` · ligne 46 · sous-agent agent-a80c23fe5e191c27f

~~~~text
1	// RootView.swift
2	// Layer: Presentation (Navigation)
3	// Purpose: Renders the coordinator's route and sheet, forwards scene phase changes to the running game
4	
5	import SwiftUI
6	
7	struct RootView: View {
8	    @State private var coordinator: AppCoordinator
9	    @Environment(\.scenePhase) private var scenePhase
10	    @Environment(\.accessibilityReduceMotion) private var reduceMotion
11	
12	    init(coordinator: AppCoordinator) {
13	        _coordinator = State(initialValue: coordinator)
14	    }
15	
16	    var body: some View {
17	        ZStack {
18	            switch coordinator.route {
19	            case .home:
20	                HomeView()
21	                    .transition(transition)
22	            case .cameraAccess:
23	                if let viewModel = coordinator.cameraAccessViewModel {
24	                    CameraAccessView(viewModel: viewModel)
25	                        .transition(transition)
26	                }
27	            case .gazeSetup:
28	                if let viewModel = coordinator.gazeSetupViewModel {
29	                    GazeSetupView(viewModel: viewModel)
30	                        .transition(transition)
31	                }
32	            case .chapters:
33	                ChaptersView()
34	                    .transition(transition)
35	            case .carnet:
36	                CarnetView()
37	                    .transition(transition)
38	            case .game:
39	                if let viewModel = coordinator.gameViewModel {
40	                    GameView(viewModel: viewModel)
41	                        .transition(transition)
42	                }
43	            case let .journeyComplete(summary):
44	                JourneyCompleteView(summary: summary)
45	                    .transition(transition)
46	            case let .unavailable(reason):
47	                UnavailableView(reason: reason)
48	                    .transition(transition)
49	            }
50	        }
51	        .animation(DSMotion.animation(DSMotion.slowAnimation, reduceMotion: reduceMotion), value: coordinator.route)
52	        .environment(coordinator)
53	        .preferredColorScheme(.dark)
54	        .sheet(item: sheetBinding) { sheet in
55	            switch sheet {
56	            case .settings:
57	                SettingsView()
58	                    .environment(coordinator)
59	                    .presentationBackground(DSColor.backgroundSurface)
60	                    .presentationDragIndicator(.visible)
61	            }
62	        }
63	        .onChange(of: scenePhase) { _, phase in
64	            switch phase {
65	            case .background, .inactive:
66	                if case .game = coordinator.route { coordinator.gameViewModel?.suspend() }
67	            case .active:
68	                if case .game = coordinator.route { coordinator.gameViewModel?.wake() }
69	            @unknown default:
70	                break
71	            }
72	        }
73	    }
74	
75	    private var sheetBinding: Binding<AppSheet?> {
76	        Binding(get: { coordinator.sheet }, set: { coordinator.sheet = $0 })
77	    }
78	
79	    private var transition: AnyTransition {
80	        reduceMotion ? .opacity : .opacity.combined(with: .scale(scale: 0.985))
81	    }
82	}
83	
~~~~

#### 2026-09-14 16:35:45 +0200 (14:35:45Z) · TOOL CALL · Read
`4a1b6284` · `0f3cb577` · ligne 47 · sous-agent agent-a80c23fe5e191c27f

~~~~json
{
 "file_path": "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris/Features/Game/Views/GameCanvasView.swift"
}
~~~~

#### 2026-09-14 16:35:45 +0200 (14:35:45Z) · TOOL RESULT · Read
`4a1b6284` · `a16b57a3` · ligne 48 · sous-agent agent-a80c23fe5e191c27f

~~~~text
1	// GameCanvasView.swift
2	// Layer: Presentation
3	// Purpose: Draws one scene snapshot; re-evaluated only when the snapshot changes
4	
5	import SwiftUI
6	
7	struct GameCanvasView: View {
8	    let snapshot: GameSceneSnapshot
9	    let reduceMotion: Bool
10	    private let renderer = GameSceneRenderer()
11	
12	    var body: some View {
13	        Canvas(rendersAsynchronously: false) { context, size in
14	            renderer.draw(snapshot, in: &context, size: size, reduceMotion: reduceMotion)
15	        }
16	        .accessibilityHidden(true)
17	    }
18	}
19	
20	/// Isolates the per-frame observation of `snapshot` so the rest of the game screen is not re-evaluated every tick.
21	struct GameCanvasHost: View {
22	    let viewModel: GameViewModel
23	    @Environment(\.accessibilityReduceMotion) private var reduceMotion
24	
25	    var body: some View {
26	        GameCanvasView(snapshot: viewModel.snapshot, reduceMotion: reduceMotion)
27	    }
28	}
29	
30	#Preview {
31	    if let level = Campaign.level(id: "6-5") {
32	        let bounds = PlayfieldBounds(width: 393, height: 852)
33	        let resolved = LevelResolver.resolve(level, in: bounds)
34	        ZStack {
35	            DSBackground()
36	            GameCanvasView(snapshot: GameSceneSnapshot(session: resolved.makeSession(), resolved: resolved, showsRoute: true, showsGaze: false, diagnostics: nil),
37	                           reduceMotion: false)
38	        }
39	        .ignoresSafeArea()
40	    }
41	}
42	
~~~~

#### 2026-09-14 16:35:46 +0200 (14:35:46Z) · TOOL CALL · Bash
`4a1b6284` · `9371f9e1` · ligne 49 · sous-agent agent-a80c23fe5e191c27f

~~~~bash
cd "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris"; cat Audio/Services/NotificationObserverBag.swift App/Persistence/InMemoryProgressStore.swift; grep -rn 'currentVersion\|version' Domain/Progress/*.swift | head; ls Domain/* GameEngine/*; grep -rln 'PrototypeLevelCatalog\|BraisesPrototype' --include='*.swift' . ; cat Docs/architecture.md | head -120
~~~~

#### 2026-09-14 16:35:46 +0200 (14:35:46Z) · TOOL RESULT · Bash
`4a1b6284` · `f5b38b00` · ligne 50 · sous-agent agent-a80c23fe5e191c27f

~~~~text
// NotificationObserverBag.swift
// Layer: Audio
// Purpose: Owns NotificationCenter observer tokens and removes them when its owner is deallocated

import Foundation

final class NotificationObserverBag: @unchecked Sendable {
    private let lock = NSLock()
    private var tokens: [any NSObjectProtocol] = []

    init() {}

    deinit {
        for token in tokens {
            NotificationCenter.default.removeObserver(token)
        }
    }

    func add(_ token: any NSObjectProtocol) {
        lock.withLock { tokens.append(token) }
    }
}
// InMemoryProgressStore.swift
// Layer: App (persistence adapter)
// Purpose: Volatile progress for previews, tests and debug launches

import Foundation

final class InMemoryProgressStore: ProgressStore, @unchecked Sendable {
    private let lock = NSLock()
    private var progress: CampaignProgress

    init(progress: CampaignProgress = CampaignProgress()) {
        self.progress = progress
    }

    func load() -> CampaignProgress {
        lock.withLock { progress }
    }

    func save(_ progress: CampaignProgress) {
        lock.withLock { self.progress = progress }
    }

    func reset() {
        lock.withLock { progress = CampaignProgress() }
    }
}
Domain/Progress/CampaignProgress.swift:8:    static let currentVersion = 1
Domain/Progress/CampaignProgress.swift:10:    var version: Int
Domain/Progress/CampaignProgress.swift:16:        self.version = Self.currentVersion
Domain/Campaign:
BaliseSequenceDefinition.swift
BraiseDefinition.swift
BraisesPrototype.swift
Campaign.swift
Campaign+Braises.swift
Campaign+Clairvoyance.swift
Campaign+Constellation.swift
Campaign+Courants.swift
Campaign+Echos.swift
Campaign+Eveil.swift
Campaign+FinalBraises.swift
Campaign+FinalClairvoyance.swift
Campaign+FinalConstellation.swift
Campaign+FinalCourants.swift
Campaign+FinalEchos.swift
Campaign+FinalGouffres.swift
Campaign+FinalJumelles.swift
Campaign+FinalPartage.swift
Campaign+FinalSouffles.swift
Campaign+FinalVeilleuses.swift
Campaign+FinalVoiles.swift
Campaign+Gouffres.swift
Campaign+Jumelles.swift
Campaign+Oculomoteur.swift
Campaign+OculomotorFinals.swift
Campaign+Partage.swift
Campaign+Souffles.swift
Campaign+Veilleuses.swift
Campaign+Voiles.swift
ChapterDefinition.swift
ChapterTheme.swift
CurrentDefinition.swift
EchoDefinition.swift
GameElement.swift
GouffreDefinition.swift
IrisMotion.swift
LevelDefinition.swift
LevelHint.swift
LevelPar.swift
LueurDefinition.swift
OculoDefinition.swift
SouffleDefinition.swift
Temperament.swift
VeilDefinition.swift
VeilleuseDefinition.swift

Domain/Entities:
Level.swift
LevelID.swift
Target.swift
TargetBlueprint.swift
TargetID.swift

Domain/Feedback:
FeedbackTiming.swift

Domain/Levels:
LevelDifficulty.swift
PrototypeLevelCatalog.swift

Domain/Physics:
PhysicsConstants.swift

Domain/Progress:
CampaignProgress.swift
Eclat.swift
LevelOutcome.swift
LevelRecord.swift
ProgressStore.swift

Domain/Random:
LinearCongruentialGenerator.swift

Domain/Validation:
CascadeRule.swift
TurnRule.swift
ValidationRule.swift
ValidationRules.swift
ValidationTransition.swift

Domain/ValueObjects:
HeadPose.swift
NormalizedPoint.swift
NormalizedRect.swift
PlayfieldBounds.swift
Vector2.swift

GameEngine/Campaign:
HintTracker.swift
LevelResolver.swift
ResolvedLevel.swift

GameEngine/Clock:
GameClock.swift
ManualGameClock.swift

GameEngine/Environment:
BaliseSequenceState.swift
BraiseState.swift
CurrentField.swift
EchoField.swift
GouffreField.swift
IrisPath.swift
LevelEnvironment.swift
SouffleField.swift
TwinState.swift
VeilleuseState.swift
VeilSegment.swift

GameEngine/Gaze:
GazeFilter.swift

GameEngine/Noise:
NoiseSource.swift
SilentNoise.swift
ValueNoise1D.swift

GameEngine/Oculo:
AbsenceStageState.swift
AncreStageState.swift
CoeurStageState.swift
CourantStageState.swift
CroisementStageState.swift
EtoilesStageState.swift
FilStageState.swift
JardinStageState.swift
MiroirStageState.swift
OculoStageState.swift
TournerStageState.swift

GameEngine/Physics:
TargetPhysics.swift

GameEngine/Session:
GameEvent.swift
GameSession.swift
SessionMetrics.swift
App/Platform/LaunchOptions.swift
Features/Settings/SettingsView.swift
Features/Game/ViewModels/GameViewModel.swift
Tests/IrisTests/GameEngine/GameSessionGoldenTests.swift
Tests/IrisTests/GameEngine/LevelEnvironmentTests.swift
Tests/IrisTests/GameEngine/GameSessionTests.swift
Tests/IrisTests/Campaign/BraisesPrototypeTests.swift
Tests/IrisTests/Fixtures/SessionFixture.swift
Tests/IrisTests/Domain/PrototypeLevelCatalogTests.swift
Navigation/AppCoordinator.swift
Domain/Campaign/BraisesPrototype.swift
Domain/Levels/PrototypeLevelCatalog.swift
# Architecture

## Overview
MVVM in the Presentation layer over a pure deterministic core (Domain and GameEngine) that knows nothing about ARKit, AVFoundation or SwiftUI. Platform capabilities (gaze, audio, haptics, frame clock) are protocols implemented in the AR, Audio, Haptics and App layers and injected by a single composition root. Single app target, layers enforced by folders, imports and the layer audit.

## Layer diagram
```
┌──────────────────────────────────────────────────────────────┐
│  App            IrisApp · AppContainer (composition root)    │
│                 Platform adapters: DisplayLinkGameClock,     │
│                 SystemLinks, DeviceIdiom, LaunchOptions      │
└───────────────────────────┬──────────────────────────────────┘
                            │ builds
┌───────────────────────────▼──────────────────────────────────┐
│  Presentation   Navigation (AppCoordinator, AppRoute, Root)  │
│                 Features/* (Views, ViewModels, Rendering)    │
│                 DesignSystem (Tokens, Components, Modifiers) │
└──────┬─────────────────────────────┬─────────────────────────┘
       │ uses protocols              │ depends on
┌──────▼──────────┐   ┌──────────────▼───────────────────────┐
│  AR             │   │  GameEngine (pure Swift)             │
│  GazeTracking-  │   │  GameSession · TargetPhysics · Noise │
│  Service impls, │   │  GazeFilter · GameProgression · Clock│
│  GazeProjector  │   └──────────────┬───────────────────────┘
├─────────────────┤                  │ depends on
│  Audio          │   ┌──────────────▼───────────────────────┐
│  AudioService   │   │  Domain (pure Swift)                 │
│  impls, Synth,  │   │  Target · Level · Vector2 · Rules    │
│  AudioCuePolicy │   │  PhysicsConstants · FeedbackTiming   │
├─────────────────┤   └──────────────────────────────────────┘
│  Haptics        │
│  HapticFeedback-│
│  Service impls, │
│  HapticCuePolicy│
└─────────────────┘
```
Allowed arrows: Presentation -> GameEngine, Domain, AR protocols, Audio protocols, Haptics protocols. AR, Audio and Haptics -> Domain value types and GameEngine events only. GameEngine -> Domain. Domain -> Foundation only. Haptics may import UIKit (feedback generators); it never imports SwiftUI or ARKit.

## Feature map
```
Campaign (Domain/Campaign, Domain/Progress, GameEngine/Campaign, GameEngine/Environment)
  Data:           Campaign (6 chapters, 34 LevelDefinition), GameElement, CampaignProgress, LevelRecord, LevelOutcome, Eclat
  Engine:         LevelResolver -> ResolvedLevel -> GameSession(environment), HintTracker
  Persistence:    ProgressStore (UserDefaultsProgressStore, InMemoryProgressStore)
Feature: Home        HomeView (HomeSummary from AppCoordinator)
Feature: Chapters    ChaptersView, ChapterCard, LevelNode
Feature: Carnet      CarnetView
Feature: Settings    SettingsView (sheet)
Feature: Game
  Screens:        GameView (GameCanvasView, GameHUDView, GameOverlayView)
  ViewModels:     GameViewModel (GamePhase)
  Navigation:     GameNavigating -> AppCoordinator
  Engine:         GameSession, AudioCuePolicy, HapticCuePolicy
  Services:       GazeTrackingService, AudioService, HapticFeedbackService, GameClock, GameSettingsStore
Feature: CameraAccess
  Screens:        CameraAccessView
  ViewModels:     CameraAccessViewModel
  Navigation:     CameraAccessNavigating -> AppCoordinator
  Services:       CameraAuthorizationService
Feature: GazeSetup (Gaze Engine v2)
  Screens:        GazeSetupView (GazeReadinessView, FixationTargetView, GazeVerdictView)
  ViewModels:     GazeSetupViewModel (GazeSetupPhase, GazeSetupIntent)
  Navigation:     GazeSetupNavigating -> AppCoordinator
  Engine:         GazeReadinessEvaluator, FixationSequence, RobustAggregator, AffineTransform2D, CalibrationResult,
                  ValidationResult, GazeQualityCriteria, CalibrationProfile
  Services:       GazeTrackingService (shared), CalibrationStore, InterfaceOrientationProvider
Feature: Onboarding
  Screens:        HomeView, TutorialView (no ViewModel: static content, coordinator intents only, ADR-4)
Feature: JourneyEnd
  Screens:        JourneyCompleteView (JourneySummary value)
Feature: Unavailable
  Screens:        UnavailableView (DeviceUnavailability value)
```

## Navigation topology
```
AppCoordinator.route
├── .home                      HomeView
├── .cameraAccess              CameraAccessView (explain, requesting, denied, restricted)
├── .gazeSetup(intent)         GazeSetupView: starting, readiness, calibrating, validating, insufficient, ready, failed
│                                intent firstRun (no valid profile), revalidate (stored profile), recalibrate (from pause)
├── .chapters                  ChaptersView (map, play a level)
├── .carnet                    CarnetView
├── .game                      GameView, overlays by GamePhase:
│                                initializing, ready (level intro), playing, paused, levelComplete(result),
│                                interrupted, faceLost, resuming, suspended, failed
├── sheet .settings            SettingsView
├── .journeyComplete(summary)  JourneyCompleteView
└── .unavailable(reason)       UnavailableView
```
Transitions are methods of AppCoordinator (beginJourney, cameraAccessGranted, gazeSetupCompleted, gazeSetupCancelled, startGame, gameDidRequestRecalibration, gameDidFinishJourney, gameDidRequestExit, returnHome, replayJourney). The game only starts once the gaze was validated in this process (`isGazeReady`); first launch: home, camera, gaze setup, tutorial, game; later launches: home, gaze setup (revalidation), game. GamePhase transitions are methods of GameViewModel (primaryAction, pause, restartLevel, suspend, wake, exit) plus service callbacks.

## Reference data flow
```
CADisplayLink tick (60 Hz)
 -> DisplayLinkGameClock calls GameViewModel.tick(deltaTime)
 -> GameSession.advance(by:) clamps and sub-steps, integrates targets (TargetPhysics),
    applies TurnRule, ValidationRule, CascadeRule, returns [GameEvent]
 -> AudioCuePolicy turns events into [AudioCue] (one loss tone per tick)
 -> AudioService.apply(cue) updates the lock-protected synth commands
 -> GameSceneSnapshot copied from the session, GameCanvasView redraws
 -> .levelCompleted stops the clock, GameProgression moves on, phase = .levelComplete
ARSession frame (main queue)
 -> ARKitGazeTrackingService: viewMatrix(for: real interface orientation), eyes and lookAtPoint in the view frame,
    GazeRay.planeHit (metres), eye line, gravity up, blink shapes -> RawGazeSample
 -> GameViewModel.handleGazeSample -> GazeMapper (AxisMapping, nominal frame, AffineTransform2D from the profile)
 -> GameSession.ingestGaze (GazeFilter, alpha 0.1) in points
```

## Dependency graph
```
AppContainer.live()
  capabilities        = ARKitDeviceCapabilities (simulator: StaticDeviceCapabilities(true))
  cameraAuthorization = AVCaptureCameraAuthorizationService (simulator: StubCameraAuthorizationService)
  settings            = GameSettingsStore (UserDefaults)
  gazeTracking (lazy, shared)   = ARKitGazeTrackingService (simulator/preview: SimulatedGazeTrackingService, oracle mode optional)
  calibrationStore              = UserDefaultsCalibrationStore (preview/tests: InMemoryCalibrationStore)
  orientationProvider           = WindowSceneOrientationProvider (preview/tests: FixedOrientationProvider)
  makeGazeSetupViewModel(intent:navigator:) = GazeSetupViewModel(gaze, store, capabilities, authorization, orientation, settings)
  makeAudioService()        = AVAudioEngineAudioService (preview: SilentAudioService)
~~~~

#### 2026-09-14 16:35:54 +0200 (14:35:54Z) · TOOL CALL · Bash · GIT
`4a1b6284` · `b217b1e7` · ligne 51 · sous-agent agent-a80c23fe5e191c27f

~~~~bash
cd "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris"; cat > "/private/tmp/claude-501/-Volumes-Steve-Pro-BlackSSD-Dev-App-Mobile-Iris/4a1b6284-eeb2-4ff3-9176-b7e4a3a1b4bc/scratchpad/fl.py" <<'EOF'
import re,sys,os
res=[]
for root,_,fs in os.walk('.'):
    if 'Tests' in root or '.git' in root: continue
    for f in fs:
        if not f.endswith('.swift'): continue
        p=os.path.join(root,f); L=open(p,encoding='utf8').read().split('\n')
        i=0
        while i<len(L):
            m=re.search(r'\b(func|init)\b',L[i])
            if m and not L[i].strip().startswith('//') and '{' in ''.join(L[i:i+6]):
                depth=0; started=False; j=i
                while j<len(L):
                    for c in L[j]:
                        if c=='{': depth+=1; started=True
                        elif c=='}': depth-=1
                    if started and depth<=0: break
                    j+=1
                res.append((j-i+1,p,i+1,L[i].strip()[:70]))
            i+=1
res.sort(reverse=True)
for r in res[:18]: print(r)
EOF
python3 "/private/tmp/claude-501/-Volumes-Steve-Pro-BlackSSD-Dev-App-Mobile-Iris/4a1b6284-eeb2-4ff3-9176-b7e4a3a1b4bc/scratchpad/fl.py"; wc -l GameEngine/Oculo/*.swift; grep -n 'func \|enum \|struct \|case ' GameEngine/Oculo/OculoStageState.swift GameEngine/Oculo/AncreStageState.swift | head -60
~~~~

#### 2026-09-14 16:35:56 +0200 (14:35:56Z) · TOOL RESULT · Bash · GIT
`4a1b6284` · `9458b1ba` · ligne 52 · sous-agent agent-a80c23fe5e191c27f

~~~~text
(153, './GameEngine/Session/GameSession.swift', 192, 'private mutating func tick(seconds: TimeInterval, frameFraction: Doubl')
(123, './Features/Game/Rendering/OculoSnapshot.swift', 157, 'static func scene(for stage: OculoStageState, elapsed: TimeInterval, h')
(97, './Features/Game/Rendering/GameSceneRenderer+Oculo.swift', 58, 'private func drawOculoElement(_ element: OculoElementSnapshot, time: T')
(88, './GameEngine/Campaign/LevelResolver.swift', 23, 'static func resolve(_ definition: LevelDefinition, in bounds: Playfiel')
(86, './Features/Game/Rendering/GameSceneSnapshot.swift', 211, 'init(session: GameSession, resolved: ResolvedLevel, showsRoute: Bool, ')
(76, './Features/Game/Rendering/GameSceneRenderer.swift', 13, 'func draw(_ snapshot: GameSceneSnapshot, in context: inout GraphicsCon')
(73, './AR/Calibration/GazeReadinessEvaluator.swift', 49, 'func report(supportsFaceTracking: Bool, cameraAuthorized: Bool, tracki')
(67, './GameEngine/Oculo/TournerStageState.swift', 85, 'mutating func update(_ input: OculoInput) -> OculoOutcome {')
(67, './Features/Game/Diagnostics/OculomotorTrace.swift', 210, 'func observeTick(session: GameSession, events: [GameEvent]) {')
(64, './GameEngine/Oculo/MiroirStageState.swift', 74, 'mutating func update(_ input: OculoInput) -> OculoOutcome {')
(61, './GameEngine/Oculo/AbsenceStageState.swift', 83, 'mutating func update(_ input: OculoInput) -> OculoOutcome {')
(58, './GameEngine/Oculo/EtoilesStageState.swift', 57, 'mutating func update(_ input: OculoInput) -> OculoOutcome {')
(52, './Audio/Synth/SineSynth.swift', 186, 'func render(into buffer: UnsafeMutableBufferPointer<Float>) {')
(49, './Features/Game/Rendering/GameSceneRenderer+Ancre.swift', 83, 'private func drawAncreRing(_ scene: AncreSceneSnapshot, center: CGPoin')
(49, './AR/Services/ARKitGazeTrackingService.swift', 91, 'private func process(_ frame: ARFrame) {')
(47, './Features/Game/Diagnostics/OculomotorTrace.swift', 159, 'private func transition(to newState: GazeState, mapped: Vector2?, boun')
(46, './Features/Game/Rendering/OculoSnapshot.swift', 101, 'init(sequence: OculoSequenceState, elapsed: TimeInterval, head: HeadPo')
(44, './GameEngine/Oculo/OculoStageState.swift', 74, 'mutating func update(_ input: OculoInput, targets: [Target], braisesLi')
     153 GameEngine/Oculo/AbsenceStageState.swift
     314 GameEngine/Oculo/AncreStageState.swift
      80 GameEngine/Oculo/CoeurStageState.swift
     154 GameEngine/Oculo/CourantStageState.swift
     113 GameEngine/Oculo/CroisementStageState.swift
     127 GameEngine/Oculo/EtoilesStageState.swift
      84 GameEngine/Oculo/FilStageState.swift
      86 GameEngine/Oculo/JardinStageState.swift
     145 GameEngine/Oculo/MiroirStageState.swift
     275 GameEngine/Oculo/OculoStageState.swift
     183 GameEngine/Oculo/TournerStageState.swift
    1714 total
GameEngine/Oculo/AncreStageState.swift:11:struct AncreStageState: Hashable, Sendable {
GameEngine/Oculo/AncreStageState.swift:12:    enum Phase: String, Hashable, Sendable {
GameEngine/Oculo/AncreStageState.swift:14:        case settling
GameEngine/Oculo/AncreStageState.swift:16:        case seeking
GameEngine/Oculo/AncreStageState.swift:18:        case circling
GameEngine/Oculo/AncreStageState.swift:20:        case returning
GameEngine/Oculo/AncreStageState.swift:21:        case done
GameEngine/Oculo/AncreStageState.swift:116:        case .settling: 0.1 * settleProgress
GameEngine/Oculo/AncreStageState.swift:117:        case .seeking: 0.1
GameEngine/Oculo/AncreStageState.swift:118:        case .circling: 0.1 + 0.8 * min(1, sweep / Self.finishSweep)
GameEngine/Oculo/AncreStageState.swift:119:        case .returning: 0.9 + 0.1 * returnProgress
GameEngine/Oculo/AncreStageState.swift:120:        case .done: 1
GameEngine/Oculo/AncreStageState.swift:127:    func offset(of head: HeadPose, from rest: HeadPose) -> Vector2 {
GameEngine/Oculo/AncreStageState.swift:132:    func loopAngle(of offset: Vector2) -> Double {
GameEngine/Oculo/AncreStageState.swift:137:    func offset(atSweep sweep: Double, size: Double) -> Vector2 {
GameEngine/Oculo/AncreStageState.swift:142:    static func normalized(_ degrees: Double) -> Double {
GameEngine/Oculo/AncreStageState.swift:150:    static func unwrapped(_ angle: Double, near sweep: Double) -> Double {
GameEngine/Oculo/AncreStageState.swift:156:    mutating func update(_ input: OculoInput) -> OculoOutcome {
GameEngine/Oculo/AncreStageState.swift:162:        case .settling:
GameEngine/Oculo/AncreStageState.swift:164:        case .seeking, .circling, .returning:
GameEngine/Oculo/AncreStageState.swift:175:            case .seeking: seek(current, size: size, into: &outcome)
GameEngine/Oculo/AncreStageState.swift:176:            case .circling: circle(current, size: size, seconds: input.seconds, into: &outcome)
GameEngine/Oculo/AncreStageState.swift:177:            case .returning: finish(current, size: size, seconds: input.seconds, into: &outcome)
GameEngine/Oculo/AncreStageState.swift:178:            case .settling, .done: break
GameEngine/Oculo/AncreStageState.swift:180:        case .done:
GameEngine/Oculo/AncreStageState.swift:186:    private mutating func enter(_ next: Phase) {
GameEngine/Oculo/AncreStageState.swift:191:    private mutating func trackAnchor(_ input: OculoInput) {
GameEngine/Oculo/AncreStageState.swift:204:    private mutating func settleStep(_ input: OculoInput, into outcome: inout OculoOutcome) {
GameEngine/Oculo/AncreStageState.swift:226:    private mutating func restartSettle(_ head: HeadPose?) {
GameEngine/Oculo/AncreStageState.swift:235:    private mutating func updateFocus(_ input: OculoInput, into outcome: inout OculoOutcome) {
GameEngine/Oculo/AncreStageState.swift:248:    private mutating func seek(_ current: Vector2, size: Double, into outcome: inout OculoOutcome) {
GameEngine/Oculo/AncreStageState.swift:260:    private mutating func circle(_ current: Vector2, size: Double, seconds: TimeInterval, into outcome: inout OculoOutcome) {
GameEngine/Oculo/AncreStageState.swift:275:    private mutating func advance(_ current: Vector2, size: Double, seconds: TimeInterval) {
GameEngine/Oculo/AncreStageState.swift:287:    private mutating func finish(_ current: Vector2, size: Double, seconds: TimeInterval, into outcome: inout OculoOutcome) {
GameEngine/Oculo/AncreStageState.swift:305:        case .settling, .returning, .done:
GameEngine/Oculo/AncreStageState.swift:307:        case .seeking:
GameEngine/Oculo/AncreStageState.swift:309:        case .circling:
GameEngine/Oculo/OculoStageState.swift:10:struct OculoInput: Hashable, Sendable {
GameEngine/Oculo/OculoStageState.swift:26:enum OculoChange: Hashable, Sendable {
GameEngine/Oculo/OculoStageState.swift:27:    case success
GameEngine/Oculo/OculoStageState.swift:28:    case miss
GameEngine/Oculo/OculoStageState.swift:29:    case completed
GameEngine/Oculo/OculoStageState.swift:33:struct OculoOutcome: Hashable, Sendable {
GameEngine/Oculo/OculoStageState.swift:38:struct OculoImpulse: Hashable, Sendable {
GameEngine/Oculo/OculoStageState.swift:44:enum OculoStageState: Hashable, Sendable {
GameEngine/Oculo/OculoStageState.swift:45:    case coeur(CoeurStageState)
GameEngine/Oculo/OculoStageState.swift:46:    case fil(FilStageState)
GameEngine/Oculo/OculoStageState.swift:47:    case miroir(MiroirStageState)
GameEngine/Oculo/OculoStageState.swift:48:    case etoiles(EtoilesStageState)
GameEngine/Oculo/OculoStageState.swift:49:    case jardin(JardinStageState)
GameEngine/Oculo/OculoStageState.swift:50:    case croisement(CroisementStageState)
GameEngine/Oculo/OculoStageState.swift:51:    case courant(CourantStageState)
GameEngine/Oculo/OculoStageState.swift:52:    case absence(AbsenceStageState)
GameEngine/Oculo/OculoStageState.swift:53:    case ancre(AncreStageState)
GameEngine/Oculo/OculoStageState.swift:54:    case tourner(TournerStageState)
GameEngine/Oculo/OculoStageState.swift:61:        case let .coeur(coeur): self = .coeur(CoeurStageState(definition: coeur, bounds: bounds, shortSide: shortSide))
GameEngine/Oculo/OculoStageState.swift:62:        case let .fil(fil): self = .fil(FilStageState(definition: fil, bounds: bounds, shortSide: shortSide))
GameEngine/Oculo/OculoStageState.swift:63:        case let .miroir(miroir): self = .miroir(MiroirStageState(definition: miroir, bounds: bounds, shortSide: shortSide))
GameEngine/Oculo/OculoStageState.swift:64:        case let .etoiles(etoiles): self = .etoiles(EtoilesStageState(definition: etoiles, bounds: bounds, shortSide: shortSide))
GameEngine/Oculo/OculoStageState.swift:65:        case let .jardin(jardin): self = .jardin(JardinStageState(definition: jardin, bounds: bounds, shortSide: shortSide))
~~~~

#### 2026-09-14 16:36:04 +0200 (14:36:04Z) · TOOL CALL · Bash
`4a1b6284` · `feb32ec6` · ligne 56 · sous-agent agent-a80c23fe5e191c27f

~~~~bash
cd "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris"; sed -n 1,200p GameEngine/Session/GameSession.swift | grep -n 'clamp\|min(\|maxDelta\|substep\|fixedStep\|func advance' ; grep -n 'advance\|maximum\|step' GameEngine/Session/GameSession.swift | head -20; sed -n 66,140p GameEngine/Oculo/OculoStageState.swift
~~~~

#### 2026-09-14 16:36:04 +0200 (14:36:04Z) · TOOL RESULT · Bash
`4a1b6284` · `a9702ea3` · ligne 57 · sous-agent agent-a80c23fe5e191c27f

~~~~text
14:    var maxDeltaTime: TimeInterval = 0.1
174:    /// R-14: advances the simulation by `deltaTime` seconds. The delta is clamped, then split into
176:    mutating func advance(by deltaTime: TimeInterval) -> [GameEvent] {
178:        let clamped = min(max(deltaTime, 0), maxDeltaTime)
179:        guard clamped > 0 else { return [] }
180:        let referenceFrames = clamped * physics.referenceFrameRate
181:        let substeps = max(1, Int((referenceFrames - 1e-9).rounded(.up)))
182:        let subSeconds = clamped / Double(substeps)
185:        for _ in 0..<substeps {
4:// (port of `step()`, extended by the campaign rules R-23 to R-28)
13:    /// Largest wall-clock delta accepted per `advance`; anything longer is treated as a stall.
30:    /// Impulses queued for the next integration step by the expansion mechanics (one per target). Always zero in the
31:    /// historical chapters, whose step therefore stays bit-for-bit the reference step (a zero queue is never added).
33:    /// Chapter VIII: whether each target is reported as carried, and for how many steps it has been outside every gust
167:    /// Queues an impulse (points per reference frame) that the next step adds to the target's velocity, on top of the
174:    /// R-14: advances the simulation by `deltaTime` seconds. The delta is clamped, then split into
175:    /// sub-steps no longer than one reference frame so that frame drops reproduce what 60 Hz would have done.
176:    mutating func advance(by deltaTime: TimeInterval) -> [GameEvent] {
181:        let substeps = max(1, Int((referenceFrames - 1e-9).rounded(.up)))
182:        let subSeconds = clamped / Double(substeps)
185:        for _ in 0..<substeps {
365:    /// Chapter IX: advances the rings; a front reaching a sleeping lueur within reach wakes it and launches it away
457:        case let .lit(balise, step):
458:            events.append(.baliseLit(balise: balise, step: step))
460:            events.append(.baliseLit(balise: balise, step: sequence.steps.count - 1))
471:    /// OCULOMOTOR EXPANSION: advances the current stage; when the sequence completes, latent lueurs appear.
        case let .croisement(croisement): self = .croisement(CroisementStageState(definition: croisement, bounds: bounds, shortSide: shortSide))
        case let .courant(courant): self = .courant(CourantStageState(definition: courant, bounds: bounds, shortSide: shortSide))
        case let .absence(absence): self = .absence(AbsenceStageState(definition: absence, bounds: bounds, shortSide: shortSide))
        case let .ancre(ancre): self = .ancre(AncreStageState(definition: ancre, bounds: bounds, shortSide: shortSide))
        case let .tourner(tourner): self = .tourner(TournerStageState(definition: tourner, bounds: bounds, shortSide: shortSide))
        }
    }

    mutating func update(_ input: OculoInput, targets: [Target], braisesLit: [Int]) -> OculoOutcome {
        switch self {
        case var .coeur(state):
            let outcome = state.update(input)
            self = .coeur(state)
            return outcome
        case var .fil(state):
            let outcome = state.update(input)
            self = .fil(state)
            return outcome
        case var .miroir(state):
            let outcome = state.update(input)
            self = .miroir(state)
            return outcome
        case var .etoiles(state):
            let outcome = state.update(input)
            self = .etoiles(state)
            return outcome
        case var .jardin(state):
            let outcome = state.update(input)
            self = .jardin(state)
            return outcome
        case var .croisement(state):
            let outcome = state.update(input)
            self = .croisement(state)
            return outcome
        case var .courant(state):
            let outcome = state.update(input)
            self = .courant(state)
            return outcome
        case var .absence(state):
            let outcome = state.update(input)
            self = .absence(state)
            return outcome
        case var .ancre(state):
            let outcome = state.update(input)
            self = .ancre(state)
            return outcome
        case var .tourner(state):
            let outcome = state.update(input)
            self = .tourner(state)
            return outcome
        }
    }

    var isComplete: Bool {
        switch self {
        case let .coeur(state): state.isComplete
        case let .fil(state): state.isComplete
        case let .miroir(state): state.isComplete
        case let .etoiles(state): state.isComplete
        case let .jardin(state): state.isComplete
        case let .croisement(state): state.isComplete
        case let .courant(state): state.isComplete
        case let .absence(state): state.isComplete
        case let .ancre(state): state.isComplete
        case let .tourner(state): state.isComplete
        }
    }

    /// 0...1 progress of the stage.
    var progress: Double {
        switch self {
        case let .coeur(state): state.progress
        case let .fil(state): state.progress
        case let .miroir(state): state.progress
        case let .etoiles(state): state.progress
~~~~

#### 2026-09-14 16:36:08 +0200 (14:36:08Z) · TOOL CALL · Bash
`4a1b6284` · `4d84005b` · ligne 58 · sous-agent agent-a80c23fe5e191c27f

~~~~bash
cd "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris"; head -30 Features/Game/Diagnostics/OculomotorTrace.swift; grep -n '#if\|#endif' Features/Game/Diagnostics/*.swift Domain/Campaign/BraisesPrototype.swift App/Platform/LaunchOptions.swift Navigation/AppCoordinator.swift Features/Game/Views/GameHUDView.swift Features/Settings/SettingsView.swift; tail -5 Features/Game/Diagnostics/AncreCapture.swift; grep -rn 'OculomotorTrace\b\|OculomotorTrace(' --include='*.swift' . | grep -v Tests | grep -v 'Diagnostics/OculomotorTrace.swift'; cat Domain/Levels/PrototypeLevelCatalog.swift | head -20; grep -rn 'PrototypeLevelCatalog' --include='*.swift' App Navigation Features GameEngine
~~~~

#### 2026-09-14 16:36:08 +0200 (14:36:08Z) · TOOL RESULT · Bash
`4a1b6284` · `fca53e55` · ligne 59 · sous-agent agent-a80c23fe5e191c27f

~~~~text
// OculomotorTrace.swift
// Layer: Presentation (DEBUG instrumentation)
// Purpose: PROTOTYPE (chapter I level 6): observes, never steers. Classifies every gaze sample (VALID_INSIDE,
// VALID_OUTSIDE when the mapper still produces a projection outside the viewport, INVALID otherwise), records
// viewport exits with only what was really observed, and measures each balise transition (acquisition, dwell,
// head yaw/pitch deltas). Technical figures, not clinical ones.

import Foundation
import os

@MainActor
final class OculomotorTrace {
    enum GazeState: String, Sendable {
        case validInside = "VALID_INSIDE"
        case validOutside = "VALID_OUTSIDE"
        case invalid = "INVALID"
    }

    enum Edge: String, Sendable {
        case left = "LEFT"
        case right = "RIGHT"
        case top = "TOP"
        case bottom = "BOTTOM"
    }

    /// One trip outside the viewport (a projection outside it, or no usable projection at all).
    struct Excursion: Sendable {
        let startTime: TimeInterval
        let state: GazeState
        /// Last position inside the viewport before the exit, if there was one.
Features/Game/Diagnostics/AncreCapture.swift:9:#if DEBUG
Features/Game/Diagnostics/AncreCapture.swift:190:#endif
App/Platform/LaunchOptions.swift:77:        #if DEBUG
App/Platform/LaunchOptions.swift:81:        #endif
Domain/Campaign/BraisesPrototype.swift:7:#if DEBUG
Domain/Campaign/BraisesPrototype.swift:41:#endif
Features/Game/Views/GameHUDView.swift:100:        #if DEBUG
Features/Game/Views/GameHUDView.swift:102:        #endif
Navigation/AppCoordinator.swift:109:    #if DEBUG
Navigation/AppCoordinator.swift:117:    #endif
Navigation/AppCoordinator.swift:174:        #if DEBUG
Navigation/AppCoordinator.swift:178:        #endif
Features/Settings/SettingsView.swift:45:                #if DEBUG
Features/Settings/SettingsView.swift:53:                #endif
            try? handle.write(contentsOf: data)
        }
    }
}
#endif
Features/Game/ViewModels/GameViewModel.swift:72:    @ObservationIgnored private(set) var oculoTrace: OculomotorTrace?
Features/Game/ViewModels/GameViewModel.swift:393:            oculoTrace = OculomotorTrace(names: balises.balises.map(\.name))
Features/Game/ViewModels/GameViewModel.swift:395:            oculoTrace = OculomotorTrace(names: oculo.stages.indices.map { "stage\($0 + 1)" })
// PrototypeLevelCatalog.swift
// Layer: Domain
// Purpose: The prototype's fourteen levels (historical reference for golden traces), generated exactly like the reference engine (same seeds, same order of draws)

import Foundation

enum PrototypeLevelCatalog {
    static let levelCount = 14
    /// `GAZE_ZONE_MULTIPLIER`: compensates gaze imprecision compared with a mouse cursor.
    static let gazeZoneMultiplier = 1.6
    /// `hold_time_frames = 45` at the 60 Hz reference rate.
    static let holdDuration: TimeInterval = 45.0 / 60.0
    /// `amplitude_bruit`
    static let noiseAmplitude = 0.15
    /// `randomPoint(rng, margin = 0.2)`
    static let spawnMargin = 0.2
    /// `rngFor(2000 + n * 97)`
    static let seedBase = 2000
    static let seedStride = 97
~~~~

#### 2026-09-14 16:36:10 +0200 (14:36:10Z) · TOOL CALL · Bash
`4a1b6284` · `af8f42f0` · ligne 60 · sous-agent agent-a80c23fe5e191c27f

~~~~bash
cd "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris"; cat Domain/Progress/CampaignProgress.swift; sed -n 1,60p Tests/IrisTests/Campaign/HistoricalCampaignFingerprintTests.swift; sed -n 1,40p Tests/IrisTests/Campaign/HistoricalCampaignDump.swift; ls Tools; grep -n 'def \|C1[0-9]\|C[0-9]:' Tools/audit.py 2>/dev/null | head -40
~~~~

#### 2026-09-14 16:36:10 +0200 (14:36:10Z) · TOOL RESULT · Bash
`4a1b6284` · `14a22900` · ligne 61 · sous-agent agent-a80c23fe5e191c27f

~~~~text
// CampaignProgress.swift
// Layer: Domain
// Purpose: Unlock rules and records of the campaign

import Foundation

struct CampaignProgress: Codable, Hashable, Sendable {
    static let currentVersion = 1

    var version: Int
    var records: [String: LevelRecord]
    var totalPlayTime: TimeInterval
    var encounteredElements: Set<GameElement>

    init(records: [String: LevelRecord] = [:], totalPlayTime: TimeInterval = 0, encounteredElements: Set<GameElement> = []) {
        self.version = Self.currentVersion
        self.records = records
        self.totalPlayTime = totalPlayTime
        self.encounteredElements = encounteredElements
    }

    func record(for level: LevelDefinition) -> LevelRecord {
        records[level.id] ?? LevelRecord()
    }

    func isCompleted(_ level: LevelDefinition) -> Bool {
        record(for: level).isCompleted
    }

    /// The first level is always open; any other opens once the last gating level before it (campaign order) is
    /// completed. An optional level (`gatesProgression == false`) never holds the levels after it.
    func isUnlocked(_ level: LevelDefinition, in campaign: [LevelDefinition]) -> Bool {
        guard let index = campaign.firstIndex(where: { $0.id == level.id }) else { return false }
        guard let gate = campaign[..<index].last(where: \.gatesProgression) else { return true }
        return isCompleted(gate)
    }

    func isUnlocked(_ chapter: ChapterDefinition, in campaign: [LevelDefinition]) -> Bool {
        guard let first = chapter.levels.first else { return false }
        return isUnlocked(first, in: campaign)
    }

    /// Next level to play: the first unlocked, not completed level; nil once everything is completed.
    func nextLevel(in campaign: [LevelDefinition]) -> LevelDefinition? {
        campaign.first { isUnlocked($0, in: campaign) && !isCompleted($0) }
    }

    func completedCount(in levels: [LevelDefinition]) -> Int {
        levels.filter(isCompleted).count
    }

    func eclatCount(in levels: [LevelDefinition]) -> Int {
        levels.reduce(0) { $0 + record(for: $1).eclats.count }
    }

    mutating func register(_ outcome: LevelOutcome, for level: LevelDefinition) {
        var record = record(for: level)
        record.register(outcome, par: level.par)
        records[level.id] = record
        totalPlayTime += outcome.time
    }

    mutating func encounter(_ elements: [GameElement]) {
        encounteredElements.formUnion(elements)
    }
}
// HistoricalCampaignFingerprintTests.swift
// Layer: Tests
// Purpose: Protection of the historical campaign (chapters I to VI, 34 levels) and of the frozen engine: the canonical
// dump must match its fixture byte for byte, the frozen source files must keep their checksum, and the historical
// levels must carry none of the expansion mechanics

import CryptoKit
import Foundation
import Testing
@testable import Iris

@Suite("Historical campaign protection")
struct HistoricalCampaignFingerprintTests {
    static let historicalIDs = ["1-1", "1-2", "1-3", "1-4", "1-5",
                                "2-1", "2-2", "2-3", "2-4", "2-5",
                                "3-1", "3-2", "3-3", "3-4", "3-5", "3-6",
                                "4-1", "4-2", "4-3", "4-4", "4-5", "4-6",
                                "5-1", "5-2", "5-3", "5-4", "5-5", "5-6",
                                "6-1", "6-2", "6-3", "6-4", "6-5", "6-6"]

    /// SHA-256 of the sources that the expansion must never change: the six historical chapters, the Gaze Engine,
    /// the gaze filter and the physics integrator. Any legitimate change must be deliberate and update this table.
    /// PROTOTYPE branch (chapter I level 6): `GazeTrackingService.swift` and `ARKitGazeTrackingService.swift` were
    /// re-hashed after one additive change each, an optional `observation` (head pose, eye geometry) that nothing in
    /// the gaze computation reads; no threshold, filter, mapping or state behaviour changed (README, prototype section).
    static let frozenSources: [String: String] = [
        "AR/Calibration/AffineTransform2D.swift": "358b3235b9d2601a0057da899d2fb670d89befc5e41156fe961137c8b166ffe9",
        "AR/Calibration/AxisMapping.swift": "4aafc40399ebfaaef2213f5f43185e052cefcd2b461dad03cc0079fbc775e9f7",
        "AR/Calibration/BlinkDetector.swift": "0dcece8ae830dda53afaa43751c098389d65a52eb663ac4b9bfcc9cf0d53e942",
        "AR/Calibration/CalibrationGrid.swift": "42ba061f8aef76349e0c17e8b10e6809c0d1c2dfd7ab60422f9cbb9cec1facfd",
        "AR/Calibration/CalibrationProfile.swift": "0107e1fce4f08b30ac76e242d3c8e59f14847167e8cc57031c139450ba1b1a4e",
        "AR/Calibration/CalibrationResult.swift": "29468b5255186c19a7cd085045390e122bbf9a4e4537a053de59cdfe31213518",
        "AR/Calibration/CalibrationStore.swift": "e2a3c0663811b3fd10741ee6f85871afe7ea8be67b205bdeb83d6460d1713355",
        "AR/Calibration/DeviceAxis.swift": "7c022865a8eb376245b584023b91ca36b6b12eb66c3299d92524afd150387b6a",
        "AR/Calibration/FixationSequence.swift": "8aa0a84b2ef3289de5ca8526c26e9abaf8c037b7e5c2bd135e7436bb8a29bc7e",
        "AR/Calibration/GazeMapper.swift": "d0b01b54094e84d08b8896d590b91422ce0b95522a924994da67b1b2fcece89a",
        "AR/Calibration/GazeReadinessEvaluator.swift": "8ef8ed107e36c89afbf8f9fcb50e53b5afdbe38d67c7bfd1608b5ff3f5c5dd48",
        "AR/Calibration/GazeReadinessReport.swift": "292a04167813e8746e92e570251d0944ab1aa372970ee23a5f2ac972ee0e4259",
        "AR/Calibration/NominalDisplayGeometry.swift": "12010e81c1ad9818265b3e90992adc41a5c34a3bee9b20421b6f052d4f7dbd1b",
        "AR/Calibration/NormalizedCoordinates.swift": "23d95ae7c14de0e91142e69e330a82c90006a4aca0cd4c9784d37abadfb444d9",
        "AR/Calibration/RobustAggregator.swift": "a7b66f5ed18601dd18845acfae0ec4c27cc1938d79f2c6248a3fb78983e3e7df",
        "AR/Projection/GazeRay.swift": "7e10dbfc01f549c18ae0e4575fb85e499b65fd5fb952acdf619cf69afe1d30f7",
        "AR/Services/ARKitGazeTrackingService.swift": "05f2d7f2f364c48da0b115ed55e6b15ea2b2f983cf67f0cc703a4be610fa45cc",
        "AR/Services/CameraAuthorizationService.swift": "84337ff6957b8decd5e703be995386467cc34a3310ccba4b66a8dcdf78c1f3f4",
        "AR/Services/DeviceCapabilities.swift": "aaf35bcce665d7e6cedba423948898b5994218b4f0172301f9680ff11863c3bb",
        "AR/Services/GazeTrackingService.swift": "bb319fd4e4340e51462e99045ed0b38fa54a5f7d72e93b27c8138a2b30236432",
        "AR/Services/InterfaceOrientationProvider.swift": "ca7e8439fa236446e9d3af74e66fd4a11f06868c0d108d8810f3b88c45816766",
        "AR/Services/SimulatedGazeTrackingService.swift": "d16b5dd7d0ee423ce85addf40aef0f0d21143b45daf82d05a7283a0653aa98a7",
        "Domain/Campaign/Campaign+Clairvoyance.swift": "2d9f0f2b3b4680bd1b3313667ae23b2b65504018001ca75c2bf3856ff654868d",
        "Domain/Campaign/Campaign+Courants.swift": "8151505f821032102ed440be21aff6368d765e421f36edd7552ebee4e70cfa4a",
        "Domain/Campaign/Campaign+Eveil.swift": "0b21c291944269ac775e8f2917a82b1de7cd939b5f37450d6d17561db30752e3",
        "Domain/Campaign/Campaign+Partage.swift": "13e7102e71722994256bc0f8a4cbdc507316f868b508b9e43cbf31222b9f9e71",
        "Domain/Campaign/Campaign+Veilleuses.swift": "fdb63a4e6948521543e79d6033aff37bf011a50a169f885db53bbf4a2ffa57fa",
        "Domain/Campaign/Campaign+Voiles.swift": "800f7005d9338f3cdb3885049cb1f9614f4164cdf15eec3571849af7773a02b0",
        // Human-validated chapters VII to XII and chapter I level 6 (oculomotor expansion branch): frozen as well.
        "Domain/Campaign/Campaign+Jumelles.swift": "5fae102a59f4eded604b10b9d4eb73f29ac423c57a3991a3e4ce1579f61d03e9",
        "Domain/Campaign/Campaign+Souffles.swift": "08551e3452bd051428927704889910df712d9ea8f2f0e1d5bab7bead707bb361",
        "Domain/Campaign/Campaign+Echos.swift": "4df729bf64d83c8976db098ea483e0cd3e6bc09535b27edfc8a250bf202b1c7e",
        "Domain/Campaign/Campaign+Gouffres.swift": "7b63ee242f5e9c1f57b49e3760a59e27978eb692e555beb76105a68da8bc4854",
        "Domain/Campaign/Campaign+Braises.swift": "f11acafdbb93ca18d4a5d6248aee30287781943ee00500bb3712c7d8e2e050d4",
// HistoricalCampaignDump.swift
// Layer: Tests
// Purpose: Canonical text of the 34 historical levels: every authored field, their resolution on the reference phone,
// and a scripted 8 s simulation trace; compared byte for byte to Fixtures/historical_campaign.txt

import Foundation
@testable import Iris

enum HistoricalCampaignDump {
    static let bounds = PlayfieldBounds(width: 393, height: 852)
    static let traceFrames = 480
    static let sampleEvery = 30

    static func render() -> String {
        var lines = ["historical campaign fingerprint v1 (reference phone 393 x 852, 60 Hz, scripted gaze)"]
        for chapter in Campaign.historicalChapters {
            lines.append("chapter \(chapter.number) \(chapter.numeral) name=\(chapter.name) principle=\(chapter.principle) "
                + "ambient=\(f(chapter.ambientFrequency)) theme=\(chapter.theme.rawValue) levels=\(chapter.levels.map(\.id).joined(separator: ","))")
        }
        for level in Campaign.historicalLevels {
            lines += describe(level)
            lines += describeResolved(level)
            lines += trace(level)
        }
        return lines.joined(separator: "\n") + "\n"
    }

    // MARK: Authored definition

    private static func describe(_ level: LevelDefinition) -> [String] {
        var lines = ["level \(level.id) title=\(level.title) principle=\(level.principle) introduces=\(level.introduces.map(\.rawValue).joined(separator: ","))"
            + " ordered=\(level.ordered) zone=\(f(level.zone)) force=\(f(level.repulsionForce)) attraction=\(f(level.attraction)) noise=\(f(level.noise)) hold=\(f(level.hold))"
            + " par=\(f(level.par.time))/\(level.par.intrusions) kinds=\(level.elementKinds.map(\.rawValue).sorted().joined(separator: ","))"
            + " temperaments=\(level.hasTemperaments) braises=\(level.hasBraises) pushing=\(level.requiresPushing) experimental=\(level.isExperimental)"]
        for (index, lueur) in level.lueurs.enumerated() {
            lines.append("  lueur \(index + 1) start=\(p(lueur.start)) iris=\(p(lueur.iris)) temperament=\(lueur.temperament.rawValue)"
                + " motion=\(motion(lueur.irisMotion)) route=\(lueur.route.map(p).joined(separator: ";")) braise=\(lueur.braise == nil ? "nil" : "SET")")
        }
        for current in level.currents {
            lines.append("  current area=\(f(current.area.minX)),\(f(current.area.minY)),\(f(current.area.maxX)),\(f(current.area.maxY))"
audit.py
MakeAppIcon.swift
2:"""Layer audit for Iris (layer-auditor skill, checks C1, C2, C8, C9, C10, C12 plus dead-file and TODO scans).
3:C12 locks the Apple identity: project.yml (XcodeGen source of truth), the generated pbxproj and the sources must agree on the bundle identifiers and the development team.
23:def swift_files():
30:def layer_of(path):
33:def strip_strings_and_comments(text):
39:findings = {"C1": [], "C2": [], "C8": [], "C9": [], "TODO": [], "C10": [], "C12": []}
88:# C12: Apple identity lock (README, "Apple Signing"). project.yml is the source of truth; the pbxproj is generated from it.
97:        findings["C12"].append(f"project.yml: missing `{expected.strip()}`")
99:    findings["C12"].append("project.yml: a provisioning profile is pinned; automatic signing must stay unpinned")
105:            findings["C12"].append(f"project.pbxproj: PRODUCT_BUNDLE_IDENTIFIER = {value} (regenerate with `xcodegen generate`)")
108:            findings["C12"].append(f"project.pbxproj: DEVELOPMENT_TEAM = {value} (regenerate with `xcodegen generate`)")
111:            findings["C12"].append(f"project.pbxproj: CODE_SIGN_STYLE = {value}")
113:        findings["C12"].append("project.pbxproj: a provisioning profile is pinned")
115:    findings["C12"].append("Iris.xcodeproj/project.pbxproj is missing: run `xcodegen generate`")
118:        findings["C12"].append(f"{path}: retired bundle prefix {RETIRED_PREFIX}")
120:# C10: file map vs disk
130:    findings["C10"].append(f"not in file-map.md: {missing}")
132:    findings["C10"].append(f"in file-map.md but not on disk: {stale}")
140:    findings["C10"] = []
~~~~

#### 2026-09-14 16:36:16 +0200 (14:36:16Z) · TOOL CALL · Bash
`4a1b6284` · `b68242e0` · ligne 62 · sous-agent agent-a80c23fe5e191c27f

~~~~bash
cd "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris"; echo A11Y; for d in Features DesignSystem Navigation; do echo $d $(grep -rhoE 'accessibility(Label|Hint|Hidden|Element|Value|AddTraits|SortPriority|Action)' --include='*.swift' $d | wc -l); done; grep -rn 'String(localized\|LocalizedStringKey\|NSLocalizedString\|LocalizedStringResource' --include='*.swift' . | grep -v Tests | wc -l; grep -rn 'Text("' --include='*.swift' Features Navigation DesignSystem | wc -l; grep -rn '\.font(' --include='*.swift' Features Navigation DesignSystem | grep -v DSFont | head -5; grep -rn 'Font\.custom\|\.system(size' --include='*.swift' . | grep -v Tests | head -8; grep -rn 'relativeTo\|@ScaledMetric\|dynamicTypeSize' --include='*.swift' . | grep -v Tests | head; echo HAPTIC; cat Haptics/Services/UIKitHapticFeedbackService.swift | sed -n 1,60p; echo SETTINGS; grep -rn 'UserDefaults\|forKey' Features/Settings/*.swift App -r --include='*.swift' | grep -v Persistence | head; find . -name 'GameSettingsStore.swift' | xargs grep -n 'defaults\.' | head
~~~~

#### 2026-09-14 16:36:18 +0200 (14:36:18Z) · TOOL RESULT · Bash
`4a1b6284` · `6a92d1e8` · ligne 63 · sous-agent agent-a80c23fe5e191c27f

~~~~text
A11Y
Features 32
DesignSystem 17
Navigation 0
       0
      38
DesignSystem/Components/DSButton.swift:100:        .dynamicTypeSize(.accessibility3)
HAPTIC
// UIKitHapticFeedbackService.swift
// Layer: Haptics
// Purpose: UIKit feedback generators kept alive for the session: medium impact for a validation, soft impact for a loss,
// success notification for a level; silently inert on hardware without a Taptic Engine or when System Haptics is off

import UIKit

@MainActor
final class UIKitHapticFeedbackService: HapticFeedbackService {
    private let validation = UIImpactFeedbackGenerator(style: .medium)
    private let loss = UIImpactFeedbackGenerator(style: .soft)
    private let completion = UINotificationFeedbackGenerator()

    /// Below full strength so the pulse stays a confirmation, not an event of its own.
    static let validationIntensity: CGFloat = 0.7
    /// Very light: the phone is held in the hand and looked at; a loss must never shake it.
    static let lossIntensity: CGFloat = 0.45

    func play(_ cue: HapticCue) {
        switch cue {
        case .prepare:
            validation.prepare()
        case .validation:
            validation.impactOccurred(intensity: Self.validationIntensity)
        case .loss:
            loss.impactOccurred(intensity: Self.lossIntensity)
        case .levelComplete:
            completion.notificationOccurred(.success)
        }
    }
}
SETTINGS
App/DI/AppContainer.swift:52:        } ?? UserDefaultsProgressStore()
App/DI/AppContainer.swift:58:                            calibrationStore: UserDefaultsCalibrationStore(),
App/DI/AppContainer.swift:68:                            calibrationStore: UserDefaultsCalibrationStore(),
App/DI/AppContainer.swift:84:                     settings: GameSettingsStore(defaults: UserDefaults(suiteName: "iris.preview.\(UUID().uuidString)") ?? .standard),
22:        didSet { defaults.set(showsGazeIndicator, forKey: Key.showsGazeIndicator) }
26:        didSet { defaults.set(soundEffectsEnabled, forKey: Key.soundEffectsEnabled) }
30:        didSet { defaults.set(ambienceEnabled, forKey: Key.ambienceEnabled) }
33:        didSet { defaults.set(hapticsEnabled, forKey: Key.hapticsEnabled) }
43:        showsGazeIndicator = defaults.bool(forKey: Key.showsGazeIndicator)
44:        hapticsEnabled = defaults.object(forKey: Key.hapticsEnabled) as? Bool ?? true
49:        let legacy = defaults.object(forKey: Key.legacySoundEnabled) as? Bool
50:        soundEffectsEnabled = defaults.object(forKey: Key.soundEffectsEnabled) as? Bool ?? legacy ?? true
51:        ambienceEnabled = defaults.object(forKey: Key.ambienceEnabled) as? Bool ?? legacy ?? false
53:            defaults.set(soundEffectsEnabled, forKey: Key.soundEffectsEnabled)
~~~~

#### 2026-09-14 16:36:18 +0200 (14:36:18Z) · TOOL CALL · Bash
`4a1b6284` · `d0d7ab13` · ligne 64 · sous-agent agent-a80c23fe5e191c27f

~~~~bash
cd "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris"; sed -n 1,120p Navigation/AppCoordinator.swift; sed -n 200,300p Features/Game/Rendering/GameSceneSnapshot.swift | grep -n 'map\|filter\|\[\]\|append' | head -15; grep -n 'Path\|Gradient\|map\|filter\|\[' Features/Game/Rendering/GameSceneRenderer.swift | wc -l; grep -n 'Gradient(\|\.map\|filter' Features/Game/Rendering/GameSceneRenderer.swift | head -10
~~~~

#### 2026-09-14 16:36:18 +0200 (14:36:18Z) · TOOL RESULT · Bash
`4a1b6284` · `ba03093e` · ligne 65 · sous-agent agent-a80c23fe5e191c27f

~~~~text
// AppCoordinator.swift
// Layer: Presentation (Navigation)
// Purpose: Deterministic route state machine and owner of the campaign progress

import Foundation
import Observation

@MainActor
@Observable
final class AppCoordinator {
    private(set) var route: AppRoute = .home
    var sheet: AppSheet?
    private(set) var gameViewModel: GameViewModel?
    private(set) var cameraAccessViewModel: CameraAccessViewModel?
    private(set) var gazeSetupViewModel: GazeSetupViewModel?
    /// The gaze was validated during this process lifetime; levels may start without another setup.
    private(set) var isGazeReady = false
    private(set) var progress: CampaignProgress

    @ObservationIgnored private var pendingLevel: LevelDefinition?
    @ObservationIgnored private var routeBeforeSetup: AppRoute = .home
    private let container: AppContainer

    init(container: AppContainer) {
        self.container = container
        self.progress = container.progressStore.load()
        if let route = container.launchOptions.initialRoute {
            jump(to: route)
        }
    }

    var settings: GameSettingsStore { container.settings }

    // MARK: Progress queries

    var nextLevel: LevelDefinition? {
        progress.nextLevel(in: Campaign.levels)
    }

    var homeSummary: HomeSummary {
        let levels = Campaign.levels
        let eclats = progress.eclatCount(in: levels)
        guard let next = nextLevel else {
            return HomeSummary(action: .replay, detail: nil, eclats: eclats, maxEclats: levels.count * 3)
        }
        let started = progress.completedCount(in: levels) > 0
        return HomeSummary(action: started ? .resume : .begin, detail: Self.label(for: next), eclats: eclats, maxEclats: levels.count * 3)
    }

    func isUnlocked(_ level: LevelDefinition) -> Bool {
        progress.isUnlocked(level, in: Campaign.levels)
    }

    func isUnlocked(_ chapter: ChapterDefinition) -> Bool {
        progress.isUnlocked(chapter, in: Campaign.levels)
    }

    func record(for level: LevelDefinition) -> LevelRecord {
        progress.record(for: level)
    }

    static func label(for level: LevelDefinition) -> String {
        let chapter = Campaign.chapter(of: level)
        return "\(chapter?.numeral ?? "") · \(chapter?.name ?? "") — \(level.index) · \(level.title)"
    }

    // MARK: Intents

    func continueJourney() {
        if let next = nextLevel {
            play(next)
        } else {
            openChapters()
        }
    }

    func openChapters() {
        route = .chapters
    }

    func openCarnet() {
        sheet = nil
        route = .carnet
    }

    func showSettings() {
        sheet = .settings
    }

    func dismissSheet() {
        sheet = nil
    }

    func returnHome() {
        gameViewModel = nil
        cameraAccessViewModel = nil
        gazeSetupViewModel = nil
        pendingLevel = nil
        route = .home
    }

    /// Starts a level once hardware, camera permission and gaze are ready. Locked levels are ignored.
    func play(_ level: LevelDefinition) {
        guard isUnlocked(level) else { return }
        pendingLevel = level
        proceedToLevel()
    }

    #if DEBUG
    /// EXPERIMENTAL (prototype B1): starts a prototype level outside the campaign; nothing is unlocked or recorded.
    func playPrototype(_ level: LevelDefinition) {
        guard level.isExperimental else { return }
        sheet = nil
        pendingLevel = level
        proceedToLevel()
    }
    #endif

    /// Recalibration from the settings sheet; comes back to the current route.
    func recalibrate() {
1:        baliseThreads = []
3:        routes = []
16:        lueurs = session.targets.enumerated().map { index, target in
40:        balises = []
41:        baliseThreads = []
42:        oculo = session.oculo.map { OculoSnapshot(sequence: $0, elapsed: session.elapsed, head: session.headPose) }
44:            balises = thread.positions.indices.map { index in
46:                               isLit: thread.litAt[index] != nil, litAge: thread.litAt[index].map { session.elapsed - $0 })
55:        gouffres = session.gouffres.map { GouffreSnapshot(center: $0.center, radius: $0.radius, pullRadius: $0.pullRadius) }
57:        waves = session.echo.map { echo in
58:            session.waves.map { EchoWaveSnapshot(origin: $0.origin, front: $0.front(at: session.elapsed, speed: echo.speed), reach: echo.radius) }
59:        } ?? []
60:        souffles = session.souffles.map { souffle in
75:        veilleuses = session.veilleuses.map {
89:            routes = []
      46
167:            glow.fill(circle(center, radius * 1.7), with: .radialGradient(Gradient(colors: [DSColor.statusSuccess.opacity(0.32), DSColor.statusSuccess.opacity(0)]),
225:            glow.fill(circle(center, radius * 2.4), with: .radialGradient(Gradient(colors: [DSColor.statusSuccess.opacity(0.32), DSColor.statusSuccess.opacity(0)]),
292:        glow.fill(circle(center, radius * 1.15), with: .radialGradient(Gradient(colors: [palette.glow.opacity(0.22 * presence), palette.accent.opacity(0.08 * presence), palette.accent.opacity(0)]),
321:        glow.fill(circle(center, radius), with: .radialGradient(Gradient(colors: [palette.accent.opacity(0.3), palette.accent.opacity(0)]),
355:        glow.fill(circle(center, radius * 1.9 * breath), with: .radialGradient(Gradient(colors: [palette.accent.opacity(0.14), palette.accent.opacity(0)]),
384:        context.fill(circle(center, well.pullRadius), with: .radialGradient(Gradient(colors: [DSColor.fieldAbyss.opacity(0.9), DSColor.fieldAbyss.opacity(0)]),
389:        context.fill(circle(center, well.radius), with: .radialGradient(Gradient(colors: [DSColor.fieldInk.opacity(0), palette.accent.opacity(0.22)]),
406:        context.fill(circle(center, radius), with: .radialGradient(Gradient(colors: [DSColor.lueurCore.opacity(1 - progress), palette.accent.opacity(0.4 * (1 - progress))]),
415:        glow.fill(circle(center, radius), with: .radialGradient(Gradient(colors: [palette.glow.opacity(0.35 * (1 - progress)), palette.glow.opacity(0)]),
436:            glow.fill(circle(center, height * 1.3), with: .radialGradient(Gradient(colors: [DSColor.accent.opacity(0.45 * flame.charge), DSColor.accent.opacity(0)]),
~~~~

#### 2026-09-14 16:36:37 +0200 (14:36:37Z) · TOOL CALL · Bash
`4a1b6284` · `06d83edc` · ligne 69 · sous-agent agent-a80c23fe5e191c27f

~~~~bash
cd "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris"; sed -n 120,287p Navigation/AppCoordinator.swift | grep -n 'progressStore\|func \|save' ; grep -rn 'GameProgression' --include='*.swift' . | head -3; grep -rn 'struct GameSceneSnapshot' Features; grep -rn 'Font\.\|static let' DesignSystem/Tokens/DSTypography.swift 2>/dev/null | head -8; ls DesignSystem/Tokens; grep -rn 'Bundle.main\|#filePath\|#file\b\|contentsOfFile\|SHA256' Tests/IrisTests/Campaign/HistoricalCampaignFingerprintTests.swift Tests/IrisTests/Campaign/ExpansionCampaignFingerprintTests.swift | head -8; grep -rln 'CampaignBot' Tests | wc -l; grep -rhoE '@Test|func test' Tests | sort | uniq -c; grep -rn 'XCUIApplication\|SnapshotTesting\|assertSnapshot' Tests | head -2; grep -rn 'logger\.\|Logger(' Features/Game/Diagnostics/OculomotorTrace.swift | head -3; grep -n 'Text("' Features/Game/Views/GameHUDView.swift | head -4; grep -rn 'horizontalSizeClass\|isPad' --include='*.swift' Features | head -5; sed -n 1,40p Docs/conventions.md
~~~~

#### 2026-09-14 16:36:37 +0200 (14:36:37Z) · TOOL RESULT · Bash
`4a1b6284` · `9aed039c` · ligne 70 · sous-agent agent-a80c23fe5e191c27f

~~~~text
1:    func recalibrate() {
7:    func resetProgress() {
8:        container.progressStore.reset()
9:        progress = container.progressStore.load()
14:    private func proceedToLevel() {
34:    private func openGazeSetup(intent: GazeSetupIntent) {
39:    private func presentPendingLevel() {
49:    private func persist() {
50:        container.progressStore.save(progress)
53:    private static func launchLevel(id: String) -> LevelDefinition? {
63:    private func jump(to route: AppRoute) {
81:    func cameraAccessGranted() {
90:    func cameraAccessAbandoned() {
96:    func gazeSetupCompleted(intent: GazeSetupIntent) {
116:    func gazeSetupCancelled(intent: GazeSetupIntent) {
133:    func gameDidStart(level: LevelDefinition) {
139:    func gameDidComplete(level: LevelDefinition, outcome: LevelOutcome) -> LevelRecord {
147:    func gameDidRequestChapters() {
152:    func gameDidFinishCampaign() {
160:    func gameDidRequestExit() {
164:    func gameDidRequestRecalibration() {
Features/Game/Rendering/GameSceneSnapshot.swift:155:struct GameSceneSnapshot: Hashable, Sendable {
DSColor.swift
DSFont.swift
DSMotion.swift
DSRadius.swift
DSSpacing.swift
DSThemePalette.swift
Tests/IrisTests/Campaign/HistoricalCampaignFingerprintTests.swift:69:        URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
Tests/IrisTests/Campaign/HistoricalCampaignFingerprintTests.swift:100:            let digest: String = SHA256.hash(data: data).map { String(format: "%02x", $0) }.joined()
      24
 406 @Test
Features/Game/Diagnostics/OculomotorTrace.swift:98:    private let logger = Logger(subsystem: "net.steve-s.iris", category: "oculotest")
Features/Game/Diagnostics/OculomotorTrace.swift:332:        logger.info("\(line, privacy: .public)")
Features/GazeSetup/ViewModels/GazeSetupViewModel.swift:52:    @ObservationIgnored private let isPad: Bool
Features/GazeSetup/ViewModels/GazeSetupViewModel.swift:64:         isPad: Bool,
Features/GazeSetup/ViewModels/GazeSetupViewModel.swift:74:        self.isPad = isPad
Features/GazeSetup/ViewModels/GazeSetupViewModel.swift:84:        let geometry = NominalDisplayGeometry.estimate(viewport: newBounds, displayScale: displayScale, isPad: isPad)
Features/Game/ViewModels/GameViewModel.swift:66:    @ObservationIgnored private let isPad: Bool
# Conventions

Single source of truth for this project. If code disagrees with this file, the code is wrong.

## Targets
- Minimum iOS: 17.0
- Swift: 6.0 language mode, strict concurrency: complete
- Xcode: 26.3
- Observation: `@Observable`

## Architecture
- Pattern: MVVM in the Presentation layer, layered domain core.
- Layers and the only allowed dependency direction:
  - Presentation (Features, Navigation, DesignSystem) depends on Domain and GameEngine, and on the AR and Audio service protocols.
  - AR and Audio implement service protocols consumed by Presentation; they depend on Domain value types only.
  - Domain and GameEngine depend on nothing but Foundation (no UIKit, no SwiftUI, no ARKit, no AVFoundation).
- Navigation: a single `AppCoordinator` owning an `AppRoute` state machine. Views never decide destinations; they call coordinator or ViewModel intents.
- Dependency injection: constructor injection through one `AppContainer` in `App/DI/`. No global singletons except `AppContainer` created once by the app entry point.
- Concurrency: async/await and `@MainActor` for all UI state. ARKit delegate callbacks are delivered on the main queue. The audio render callback touches only a lock-protected value type.

## Folder layout (this project, chosen by the mission brief)
```
App/            IrisApp.swift, DI/
Domain/         entities, value objects, physics constants, levels, validation rules
GameEngine/     noise, physics integrator, session, progression, gaze filter, events
AR/             GazeTrackingService protocol implementations, projector, device capabilities
Audio/          AudioService protocol implementations, synthesizer, cue policy
Navigation/     AppRoute, AppCoordinator, RootView
Features/<Name> Views, ViewModels, Components per screen
DesignSystem/   Tokens/, Components/, Modifiers/
Resources/      Assets.xcassets
Config/         Info.plist
Tests/IrisTests unit tests (Swift Testing), Fixtures/, Mocks/
Docs/           project-brief, conventions, file-map, product, architecture, domain-model, design-system, audits
```
Deviation from the skill default tree: `Core/` is replaced by `App/DI` and `Navigation/`, and `Data/` does not exist because the app has no persistence or network. Recorded as ADR-2 in architecture.md.

## Naming
| Thing | Rule | Example |
|---|---|---|
~~~~

#### 2026-09-14 16:36:39 +0200 (14:36:39Z) · TOOL CALL · Bash
`4a1b6284` · `ca30e5ad` · ligne 71 · sous-agent agent-a80c23fe5e191c27f

~~~~bash
cd "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris"; sed -n 60,140p Tests/IrisTests/Campaign/HistoricalCampaignFingerprintTests.swift; grep -n 'Hashable\|Equatable' Features/Game/Rendering/GameSceneSnapshot.swift | head -3; grep -n 'Text(\|Label(' Features/Chapters/LevelNode.swift | head; sed -n 30,60p Features/Chapters/LevelNode.swift
~~~~

#### 2026-09-14 16:36:39 +0200 (14:36:39Z) · TOOL RESULT · Bash
`4a1b6284` · `4aeb74a2` · ligne 72 · sous-agent agent-a80c23fe5e191c27f

~~~~text
        "Domain/Campaign/Campaign+Braises.swift": "f11acafdbb93ca18d4a5d6248aee30287781943ee00500bb3712c7d8e2e050d4",
        "Domain/Campaign/Campaign+Constellation.swift": "e343c0c7d44550310a293e8da1ffce4a9c6ef7b6c8376b863c5cbcbc3bc26281",
        "Domain/Campaign/Campaign+Oculomoteur.swift": "0c257f7899f7cc161be637305bb72a49d2161b27088fbe56f211d32efb989b10",
        "GameEngine/Gaze/GazeFilter.swift": "e2b8f50ec196e3013229370c5343cc117649cf39cfed291d1bb9e38f39557693",
        "GameEngine/Physics/TargetPhysics.swift": "99e15cc5116499c7bfa443742f9b9733fda80c82b457eadb56f9b2f774ca6639",
    ]

    /// Project root, derived from this file's compile-time path (Tests/IrisTests/Campaign/...).
    private static var projectRoot: URL {
        URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
    }

    @Test("the canonical dump of the 34 historical levels matches Fixtures/historical_campaign.txt byte for byte")
    func dumpMatchesFixture() throws {
        let bundle = Bundle(for: GoldenTraceBundleLocator.self)
        let url = try #require(bundle.url(forResource: "historical_campaign", withExtension: "txt"), "fixture missing from the test bundle")
        let expected = try String(contentsOf: url, encoding: .utf8)
        let actual = HistoricalCampaignDump.render()
        if actual != expected {
            let expectedLines = expected.components(separatedBy: "\n")
            let actualLines = actual.components(separatedBy: "\n")
            var report: [String] = []
            for index in 0..<max(expectedLines.count, actualLines.count) where report.count < 12 {
                let before = index < expectedLines.count ? expectedLines[index] : "<missing>"
                let after = index < actualLines.count ? actualLines[index] : "<missing>"
                if before != after {
                    report.append("line \(index + 1)\n  fixture: \(before)\n  now:     \(after)")
                }
            }
            let details: String = report.joined(separator: "\n")
            Issue.record(Comment(rawValue: "historical campaign changed (\(expectedLines.count) fixture lines, \(actualLines.count) now):\n\(details)"))
        }
        #expect(actual == expected)
    }

    @Test("the frozen sources (historical chapters, Gaze Engine, gaze filter, physics integrator) keep their checksum")
    func frozenSourcesUnchanged() throws {
        let root = Self.projectRoot
        for (path, expected) in Self.frozenSources.sorted(by: { $0.key < $1.key }) {
            let data = try Data(contentsOf: root.appendingPathComponent(path))
            let digest: String = SHA256.hash(data: data).map { String(format: "%02x", $0) }.joined()
            #expect(digest == expected, "\(path) changed")
        }
    }

    @Test("the historical chapters keep their ids, order, names, theme and carry no expansion mechanic")
    func purity() {
        #expect(Campaign.historicalLevels.map(\.id) == Self.historicalIDs)
        #expect(Campaign.historicalChapters.map(\.name) == ["éveil", "partage", "courants", "voiles", "veilleuses", "clairvoyance"])
        #expect(Campaign.historicalChapters.map(\.ambientFrequency) == [110, 123.47, 98, 130.81, 116.54, 146.83])
        #expect(Campaign.historicalChapters.allSatisfy { $0.theme == .chambreNoire && $0.isHistorical })
        for level in Campaign.historicalLevels {
            #expect(!level.hasBraises && !level.isExperimental, "\(level.id)")
            #expect(level.lueurs.allSatisfy { $0.braise == nil && $0.twin == nil && !$0.asleep }, "\(level.id)")
            #expect(!level.hasTwins && level.souffles.isEmpty && level.echo == nil && !level.hasSleepers && level.gouffres.isEmpty, "\(level.id)")
            #expect(level.balises == nil && level.oculo == nil && level.gatesProgression, "\(level.id)")
        }
        #expect(Campaign.chapters.dropFirst(6).allSatisfy { !$0.isHistorical })
    }
}
7:struct LueurSnapshot: Hashable, Sendable {
71:struct BaliseSnapshot: Hashable, Sendable {
82:struct BaliseThreadSnapshot: Hashable, Sendable {
36:                Text("\(level.index)")
52:        .accessibilityLabel("Niveau \(level.index), \(level.title)")
                    .opacity(state == .locked ? 0.35 : 1)
                if state == .next {
                    Circle()
                        .strokeBorder(DSColor.accent, lineWidth: 2)
                        .padding(-style.ringOutset)
                }
                Text("\(level.index)")
                    .font(DSFont.title3)
                    .monospacedDigit()
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .padding(DSSpacing.xs)
                    .foregroundStyle(state == .locked ? DSColor.textTertiary : DSColor.textPrimary)
            }
            .padding(style.circleInset)
            // A square no larger than the historical button, as large as the row allows.
            .frame(maxWidth: style.maximumTarget, maxHeight: style.maximumTarget)
            .aspectRatio(1, contentMode: .fit)
            .contentShape(Rectangle())
        }
        .buttonStyle(DSPressableButtonStyle())
        .disabled(state == .locked)
        .accessibilityLabel("Niveau \(level.index), \(level.title)")
        .accessibilityValue(accessibilityValue)
    }

    private var accessibilityValue: String {
        switch state {
        case .locked: "verrouillé"
        case .next: "à jouer"
        case .available: "\(eclats.count) éclats sur 3"
~~~~

#### 2026-09-14 16:36:47 +0200 (14:36:47Z) · TOOL CALL · Bash
`4a1b6284` · `374c0e7e` · ligne 76 · sous-agent agent-a80c23fe5e191c27f

~~~~bash
cd "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris"; cat DesignSystem/Tokens/DSFont.swift | head -40; sed -n 40,87p Tools/audit.py; grep -n 'GameCanvasHost\|onTapGesture\|accessibility' Features/Game/Views/GameView.swift Features/Game/Views/GameOverlayView.swift 2>/dev/null | head -12; grep -rn 'Text("[A-Za-zÀ-ÿ]' --include='*.swift' Features Navigation | wc -l; grep -rn '"[A-Z][a-zé]\+ [a-zé]\+' --include='*.swift' Domain/Campaign | wc -l
~~~~

#### 2026-09-14 16:36:47 +0200 (14:36:47Z) · TOOL RESULT · Bash
`4a1b6284` · `b65f9161` · ligne 77 · sous-agent agent-a80c23fe5e191c27f

~~~~text
// DSFont.swift
// Layer: DesignSystem
// Purpose: Typography tokens: New York serif titles in lowercase, SF for reading, all Dynamic Type aware

import SwiftUI

enum DSFont {
    /// Wordmark and hero titles ("iris", "atteint", "regard prêt").
    static let display = Font.system(.largeTitle, design: .serif).weight(.regular)
    /// Screen and level titles.
    static let title = Font.system(.title, design: .serif).weight(.regular)
    static let title2 = Font.system(.title2, design: .serif).weight(.regular)
    static let title3 = Font.system(.title3, design: .serif).weight(.regular)
    static let headline = Font.headline
    static let body = Font.body
    static let callout = Font.callout
    static let footnote = Font.footnote
    static let caption = Font.caption
    /// Small uppercase tracked labels (use with `dsEyebrowStyle`).
    static let eyebrow = Font.caption.weight(.semibold)
    /// Chapter numerals (I, II, III...).
    static let numeral = Font.system(.title3, design: .serif).weight(.regular)
    /// Numeric readouts.
    static let mono = Font.system(.body, design: .default).monospacedDigit()
}
rows = []
files = sorted(swift_files())
for path in files:
    text = open(os.path.join(ROOT, path)).read()
    layer = layer_of(path)
    imports = set(re.findall(r"^import (\w+)", text, re.M))
    for banned in FORBIDDEN.get(layer, set()):
        if banned in imports:
            findings["C1"].append(f"{path}: imports {banned}")
    if layer == "DesignSystem":
        for token in ["GameSession", "Target(", "AppCoordinator", "GameViewModel"]:
            if token in text:
                findings["C1"].append(f"{path}: references {token}")
    decls = TYPE_DECL.findall(text)
    top_level = []
    for line in text.splitlines():
        m = TYPE_DECL.match(line)
        if m and not line.startswith((" ", "\t")):
            top_level.append(m.group(2))
    name = os.path.splitext(os.path.basename(path))[0]
    primary = name.split("+")[0]
    if top_level and primary not in top_level and not name.endswith("Tests") and "+" not in name and "Fixture" not in name and "Mock" not in name:
        findings["C2"].append(f"{path}: file name does not match a top-level type {top_level}")
    code = strip_strings_and_comments(text)
    if layer in ("Presentation", "DesignSystem"):
        if re.search(r"Color\((red|hex)", code) or re.search(r"\.font\(\.system\(size:", code) and layer == "Presentation" and "Rendering" not in path:
            findings["C8"].append(f"{path}: raw colour or font literal")
    if layer != "Tests":
        for m in re.finditer(r"\btry!\s", code):
            findings["C9"].append(f"{path}: try!")
        for m in re.finditer(r"\bas!\s", code):
            findings["C9"].append(f"{path}: as!")
        for m in re.finditer(r"fatalError\(", code):
            findings["C9"].append(f"{path}: fatalError")
        for m in re.finditer(r"[\w\)\]]\!(?=[\.\s,\)\]\}]|$)", code):
            snippet = code[max(0, m.start()-25):m.end()+5].replace("\n", " ")
            if "!=" in snippet[20:30]:
                continue
            findings["C9"].append(f"{path}: force unwrap near '{snippet.strip()}'")
    for m in re.finditer(r"\bTODO\b|\bFIXME\b", text):
        findings["TODO"].append(f"{path}")
    purpose = ""
    pm = re.search(r"^// Purpose: (.*)$", text, re.M)
    if pm:
        purpose = pm.group(1).strip()
    kind = top_level and TYPE_DECL.search(text) and TYPE_DECL.search(text).group(1) or "-"
    rows.append((path, kind, layer, purpose))

Features/Game/Views/GameView.swift:15:            GameCanvasHost(viewModel: viewModel)
      27
     238
~~~~

#### 2026-09-14 16:37:36 +0200 (14:37:36Z) · TOOL CALL · Bash
`4a1b6284` · `b29d2e35` · ligne 81 · sous-agent agent-a80c23fe5e191c27f

~~~~bash
cd "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris"; grep -rln 'UserDefaultsProgressStore\|GameSceneRenderer\|AVAudioEngineAudioService\|DisplayLinkGameClock\|UserDefaultsCalibrationStore' Tests; grep -n 'enum GameElement' -A3 Domain/Campaign/GameElement.swift; grep -n 'persist()' Navigation/AppCoordinator.swift
~~~~

#### 2026-09-14 16:37:36 +0200 (14:37:36Z) · TOOL RESULT · Bash
`4a1b6284` · `cde5e0c5` · ligne 82 · sous-agent agent-a80c23fe5e191c27f

~~~~text
Tests/IrisTests/GameEngine/HintTrackerTests.swift
Tests/IrisTests/AR/CalibrationProfileTests.swift
7:enum GameElement: String, Hashable, Sendable, CaseIterable, Codable {
8-    case lueur
9-    case iris
10-    case ecran
168:    private func persist() {
255:        persist()
262:        persist()
~~~~

#### 2026-09-14 16:37:39 +0200 (14:37:39Z) · TOOL CALL · Bash
`4a1b6284` · `7f7f095c` · ligne 85 · sous-agent agent-a80c23fe5e191c27f

~~~~bash
cd "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris"; grep -n 'UserDefaultsProgressStore\|GameSceneRenderer\|AVAudioEngine\|DisplayLink\|UserDefaultsCalibrationStore' Tests/IrisTests/GameEngine/HintTrackerTests.swift Tests/IrisTests/AR/CalibrationProfileTests.swift | head -5
~~~~

#### 2026-09-14 16:37:39 +0200 (14:37:39Z) · TOOL RESULT · Bash
`4a1b6284` · `f2593d32` · ligne 86 · sous-agent agent-a80c23fe5e191c27f

~~~~text
Tests/IrisTests/GameEngine/HintTrackerTests.swift:80:        let store = UserDefaultsProgressStore(defaults: defaults)
Tests/IrisTests/AR/CalibrationProfileTests.swift:33:        let defaults = UserDefaultsCalibrationStore(defaults: UserDefaults(suiteName: "iris.tests.calibration.\(UUID().uuidString)") ?? .standard)
~~~~

### 2026-09-14 16:38:35 +0200 (14:38:35Z) · CLAUDE · REPORT
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
