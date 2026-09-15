# Historique de session Claude Code — partie 001

Session `f88478cc-d512-4210-bc11-758059278995` · jour local 2026-09-10 (Europe/Paris, +0200) · texte d'origine, voir README.md et manifest.md pour les omissions.

### 2026-09-10 23:18:30 +0200 (21:18:30Z) · COMMAND (commande locale)
`f88478cc` · `fdf9d591` · ligne 6

~~~~text
<command-name>/effort</command-name>
            <command-message>effort</command-message>
            <command-args></command-args>
~~~~

### 2026-09-10 23:18:30 +0200 (21:18:30Z) · COMMAND (commande locale)
`f88478cc` · `a5df28d4` · ligne 7

~~~~text
<local-command-stdout>Cancelled</local-command-stdout>
~~~~

### 2026-09-10 23:18:39 +0200 (21:18:39Z) · COMMAND (commande locale)
`f88478cc` · `5bb361d3` · ligne 10

~~~~text
<command-name>/model</command-name>
            <command-message>model</command-message>
            <command-args></command-args>
~~~~

### 2026-09-10 23:18:39 +0200 (21:18:39Z) · COMMAND (commande locale)
`f88478cc` · `ab91f34a` · ligne 11

~~~~text
<local-command-stdout>Set model to `Fable 5.1` and saved as your default for new sessions</local-command-stdout>
~~~~

### 2026-09-10 23:18:52 +0200 (21:18:52Z) · COMMAND (commande locale)
`f88478cc` · `b24da1ea` · ligne 14

~~~~text
<command-name>/effort</command-name>
            <command-message>effort</command-message>
            <command-args></command-args>
~~~~

### 2026-09-10 23:18:52 +0200 (21:18:52Z) · COMMAND (commande locale)
`f88478cc` · `fd1b6126` · ligne 15

~~~~text
<local-command-stdout>Set effort level to max (this session only): Maximum capability with deepest reasoning. May use excessive tokens resulting in long response times or overthinking. Use sparingly for the hardest tasks.</local-command-stdout>
~~~~

### 2026-09-10 23:22:38 +0200 (21:22:38Z) · COMMAND (commande locale)
`f88478cc` · `b68be96e` · ligne 18

~~~~text
<command-name>/effort</command-name>
            <command-message>effort</command-message>
            <command-args></command-args>
~~~~

### 2026-09-10 23:22:38 +0200 (21:22:38Z) · COMMAND (commande locale)
`f88478cc` · `2b64b58b` · ligne 19

~~~~text
<local-command-stdout>Set effort level to xhigh (saved as your default for new sessions): Deeper reasoning than high, just below maximum (Fable 5, Opus 4.7+, Sonnet 5)</local-command-stdout>
~~~~

### 2026-09-10 23:25:51 +0200 (21:25:51Z) · USER
`f88478cc` · `e920e951` · ligne 22

~~~~markdown
xcodebuild -version
~~~~

### 2026-09-10 23:25:51 +0200 (21:25:51Z) · SYSTEM · modèle : Fable 5.1 (claude-fable-5-1)
`f88478cc` · `12eab085` · ligne 24

### 2026-09-10 23:25:51 +0200 (21:25:51Z) · SYSTEM · date de session : 2026-09-10
`f88478cc` · `3f6c9bac` · ligne 32

### (sans horodatage) · TITRE DE SESSION : Xcodebuild version check
`f88478cc` · `` · ligne 40

### 2026-09-10 23:25:53 +0200 (21:25:53Z) · CLAUDE
`f88478cc` · `c8a39332` · ligne 42

~~~~markdown
I'll run that command.
~~~~

#### 2026-09-10 23:25:54 +0200 (21:25:54Z) · TOOL CALL · Bash
`f88478cc` · `44025f59` · ligne 43 · Show installed Xcode version

~~~~bash
xcodebuild -version
~~~~

#### 2026-09-10 23:25:56 +0200 (21:25:56Z) · TOOL RESULT · Bash
`f88478cc` · `02130dd6` · ligne 44 · Show installed Xcode version

~~~~text
Xcode 26.3
Build version 17C529
~~~~

### 2026-09-10 23:25:57 +0200 (21:25:57Z) · CLAUDE
`f88478cc` · `37798a8d` · ligne 54

~~~~markdown
The installed Xcode is version 26.3, build 17C529.
~~~~

### 2026-09-10 23:26:07 +0200 (21:26:07Z) · USER
`f88478cc` · `ca353020` · ligne 57

~~~~markdown
xcode-select -p
~~~~

#### 2026-09-10 23:26:09 +0200 (21:26:09Z) · TOOL CALL · Bash
`f88478cc` · `79ad7794` · ligne 59 · Show active Xcode developer directory path

~~~~bash
xcode-select -p
~~~~

#### 2026-09-10 23:26:11 +0200 (21:26:11Z) · TOOL RESULT · Bash
`f88478cc` · `ff8e3a97` · ligne 60 · Show active Xcode developer directory path

~~~~text
/Applications/Xcode.app/Contents/Developer
~~~~

### 2026-09-10 23:26:14 +0200 (21:26:14Z) · CLAUDE
`f88478cc` · `0286bdc3` · ligne 63

~~~~markdown
The active developer directory is `/Applications/Xcode.app/Contents/Developer`, so the command-line tools are pointing at the full Xcode 26.3 install rather than a standalone Command Line Tools package.
~~~~

### 2026-09-10 23:29:20 +0200 (21:29:20Z) · USER · DECISION
`f88478cc` · `cd06e7bd` · ligne 66

~~~~markdown
# MISSION — CONSTRUIRE IRIS EN AUTONOMIE COMPLÈTE

Tu travailles en autonomie totale jusqu'à obtenir l'application iOS native **Iris** dans un état compilable, testé et cohérent.

## MODE D'EXÉCUTION

Configuration utilisée :

* **Modèle : Fable 5.1**
* **Effort : xhigh**

Utilise largement le contexte disponible lorsque cela améliore la qualité de l'implémentation.

Ne pose **AUCUNE question à l'utilisateur**.

Ne demande aucune confirmation.

Ne t'arrête jamais pour attendre une décision humaine.

Si une ambiguïté, un choix d'architecture ou une décision d'implémentation apparaît, tranche toi-même en privilégiant, dans cet ordre :

1. le moteur HTML/JavaScript de référence présent dans le dossier ;
2. les exigences fonctionnelles explicites du présent prompt ;
3. les skills disponibles ;
4. les API Apple publiques et documentées ;
5. la solution la plus robuste, maintenable et testable.

Documente dans `README.md` les choix importants, les hypothèses et les arbitrages effectués.

Si une difficulté ne peut pas être résolue exactement comme prévu, cherche une solution techniquement correcte, documente l'écart et continue.

---

# 1. SOURCE DE VÉRITÉ FONCTIONNELLE

Le dossier courant contient :

`attention-indirecte.html`

Ce fichier constitue la **source de vérité fonctionnelle du moteur de jeu existant**.

Les autres fichiers, dossiers ou archives présents peuvent notamment contenir des skills, ressources ou éléments de développement.

Ils ne doivent pas être confondus avec la spécification fonctionnelle du moteur.

Commence impérativement par :

1. inventorier le contenu du dossier courant ;
2. ouvrir `attention-indirecte.html` ;
3. le lire **intégralement** ;
4. analyser son HTML ;
5. analyser son CSS ;
6. analyser son JavaScript ;
7. relever toutes les constantes physiques ;
8. relever les règles de progression ;
9. relever les états du moteur ;
10. relever les transitions ;
11. relever les comportements visuels et sonores ;
12. comprendre précisément la mécanique avant d'écrire le moteur Swift.

**Ne modifie pas, ne déplace pas et ne supprime pas `attention-indirecte.html`.**

Il s'agit d'un moteur déjà fonctionnel et validé.

Le travail demandé est un **portage natif fidèle**, pas la conception d'un nouveau jeu.

Aucune WebView ne doit être utilisée pour exécuter ou encapsuler le jeu HTML.

Le moteur doit être réellement réimplémenté en Swift.

En cas de divergence entre le résumé fonctionnel de ce prompt et le comportement effectivement implémenté dans `attention-indirecte.html`, le code HTML/JavaScript existant prévaut pour les comportements déjà définis, sauf lorsqu'une exigence du présent prompt impose explicitement une évolution.

Avant l'implémentation principale, crée dans le README une table de correspondance :

`HTML / JavaScript → Swift`

pour les principales mécaniques, constantes, états et responsabilités.

---

# 2. APPLICATION CIBLE

Créer une application :

**Iris**

Plateforme :

**iOS natif exclusivement**

Technologies principales :

* Swift
* SwiftUI
* ARKit
* AVFoundation
* AVAudioEngine
* APIs Apple natives

Le projet Xcode doit s'appeler :

`Iris`

---

# 3. CONCEPT FONCTIONNEL

Le joueur doit réussir à faire atteindre à une ou plusieurs sphères leurs points d'arrivée.

La particularité fondamentale du jeu est la suivante :

**regarder directement une sphère la repousse.**

Le joueur doit donc maîtriser son attention et son regard afin de laisser les sphères rejoindre leur objectif sans les perturber.

---

# 4. SUIVI DU REGARD

Utilise ARKit et :

`ARFaceAnchor.lookAtPoint`

avec les appareils disposant d'une caméra TrueDepth compatible.

Le point de regard doit être correctement projeté vers les coordonnées d'écran utilisées par le moteur de jeu.

Aucune calibration manuelle ne doit être nécessaire dans le fonctionnement normal.

Applique un lissage exponentiel afin de limiter le bruit et les tremblements du signal.

Facteur de référence :

`0.10 à 0.15`

Reprends les valeurs du moteur existant lorsqu'elles sont explicitement définies.

Le suivi ARKit doit être encapsulé derrière une abstraction afin que le moteur déterministe puisse être testé sans caméra TrueDepth.

---

# 5. MOTEUR PHYSIQUE

Chaque sphère possède au minimum :

* position ;
* vitesse ;
* destination ;
* profondeur visuelle éventuelle ;
* état ;
* numéro de séquence ;
* couleur ;
* état de validation.

## Attraction

Lorsque le regard n'est pas suffisamment proche de la sphère, une force d'attraction la tire vers son point d'arrivée.

Cette attraction doit reproduire aussi fidèlement que possible celle du moteur HTML.

---

## Répulsion

Lorsque la distance entre le regard projeté et la sphère devient inférieure au seuil :

`zone_attention`

une force de répulsion doit être appliquée.

Son intensité est proportionnelle à :

`zone_attention - distance`

La sphère doit donc être repoussée dans la direction opposée au regard.

La répulsion devient plus importante à mesure que le regard se rapproche de la sphère.

---

# 6. BRUIT ORGANIQUE

Ajoute le léger mouvement organique prévu dans le moteur existant.

Utilise un bruit de type Perlin ou une implémentation mathématique équivalente adaptée au moteur natif.

Ce bruit doit rester subtil.

Il ne doit ni dominer l'attraction ni rendre les déplacements imprévisibles.

---

# 7. FRICTION, VITESSE ET FRAMERATE

Le moteur HTML constitue la référence du comportement physique.

La friction d'origine est approximativement :

`velocity *= 0.94`

par frame dans le modèle historique.

Le moteur Swift doit cependant fonctionner correctement indépendamment de la fréquence réelle de rendu.

Lors du passage à une simulation utilisant `deltaTime`, préserve autant que possible **l'équivalence du comportement original à 60 Hz**.

Ne change pas arbitrairement le ressenti du moteur sous prétexte de normaliser le temps.

Par exemple, une friction originale :

`velocity *= 0.94`

par frame à 60 Hz peut être transformée selon un principe équivalent à :

`velocity *= pow(0.94, deltaTime * 60)`

Applique le même principe aux autres paramètres historiquement dépendants de la fréquence d'image lorsque cela est mathématiquement approprié.

L'objectif est :

**indépendance au framerate sans modification perceptible du moteur validé à 60 Hz.**

La vitesse des sphères doit rester plafonnée.

Utilise les valeurs exactes du HTML lorsqu'elles existent.

---

# 8. BORDS DE L'ÉCRAN

Les sphères doivent rester dans l'espace de jeu.

Lorsqu'une sphère rencontre une limite :

* elle ne doit pas disparaître hors écran ;
* elle doit rebondir ;
* le rebond doit être amorti.

Reproduis les coefficients du moteur HTML lorsqu'ils sont disponibles.

---

# 9. VALIDATION D'UNE CIBLE

Chaque sphère possède un point d'arrivée matérialisé par un cercle ou une zone visuelle claire.

Une cible n'est pas immédiatement validée lorsqu'elle entre dans sa zone.

Elle doit rester dans la zone pendant environ :

**0,75 seconde**

de manière continue.

Si elle quitte la zone avant la fin de ce délai, la progression de validation est remise à zéro ou réagit conformément au moteur de référence.

---

# 10. ORDRE DES CIBLES

Les niveaux peuvent comporter jusqu'à :

**3 cibles simultanées**

Chaque cible possède un numéro de séquence :

`1 → 2 → 3`

Les cibles ne peuvent être validées que dans cet ordre.

Une cible peut physiquement arriver dans sa destination avant son tour.

Elle peut y rester.

Mais tant que toutes les cibles précédentes ne sont pas validées :

**sa présence ne compte pas comme validation.**

Exemple :

la cible 2 atteint son cercle avant la cible 1.

La cible 2 n'est pas validée.

La cible 1 doit être validée.

La cible 2 peut ensuite démarrer ou reprendre sa validation conformément au comportement cohérent défini dans le domaine métier.

---

# 11. MAINTIEN DES VALIDATIONS

Une cible déjà validée reste physiquement présente et peut continuer à subir un léger mouvement.

Elle dispose d'une tolérance d'environ :

**20 px**

autour de sa position ou zone de validation.

Si une cible validée sort de cette marge :

* sa validation est perdue immédiatement ;
* elle redevient active ;
* toutes les cibles de rang supérieur qui avaient déjà été validées sont également invalidées.

---

# 12. INVALIDATION EN CASCADE

L'intégrité de l'ordre doit être maintenue en permanence.

Exemple :

les cibles :

`1`
`2`
`3`

sont validées.

Si la cible 2 perd sa validation :

* 2 devient non validée ;
* 3 devient également non validée ;
* 1 reste validée.

Si la cible 1 perd sa validation :

* 1 devient non validée ;
* 2 devient non validée ;
* 3 devient non validée.

Cette règle doit appartenir au domaine métier et ne doit pas dépendre de SwiftUI.

Écris des tests automatisés couvrant explicitement ces scénarios.

---

# 13. AUDIO

Utilise :

`AVAudioEngine`

pour produire l'environnement sonore.

Privilégie une génération sonore native, notamment à base d'oscillateurs sinusoïdaux lorsque cela convient.

Aucun asset audio externe n'est obligatoire si les sons peuvent être synthétisés proprement.

Trois comportements sont nécessaires.

## Progression

Lorsqu'une cible se rapproche de sa validation et que le temps de présence progresse :

* la fréquence augmente progressivement ;
* le volume augmente progressivement.

Le joueur doit pouvoir percevoir auditivement qu'il approche de la validation.

## Validation

Lorsqu'une cible est validée :

* jouer un carillon bref ;
* tonalité positive ;
* son distinct du son de progression.

## Perte de validation

Lorsqu'une cible perd sa validation :

* son grave ;
* mouvement de hauteur descendant ;
* feedback clairement différent du carillon positif.

Le feedback sonore doit également se produire lors d'une invalidation en cascade.

Évite toutefois la superposition incontrôlée de plusieurs sons identiques lors d'une cascade.

Définis une politique sonore cohérente et documente-la.

---

# 14. PROGRESSION

Le jeu comporte exactement :

**14 niveaux**

Répartition :

* niveaux 1 à 3 : **1 cible**
* niveaux 4 à 8 : **2 cibles**
* niveaux 9 à 14 : **3 cibles**

La difficulté doit augmenter progressivement.

Elle repose notamment sur :

* diminution progressive de la zone d'attention ;
* augmentation progressive de la force de répulsion.

Utilise les valeurs exactes présentes dans le moteur HTML lorsqu'elles existent.

Ne remplace pas arbitrairement une courbe de difficulté existante par une autre.

Si certaines valeurs nécessaires ne sont pas définies dans la source :

* détermine toi-même une progression cohérente ;
* documente les valeurs choisies ;
* privilégie une progression régulière et testable.

---

# 15. DESIGN

Utilise prioritairement les skills :

* `ui-ux-designer`
* `swiftui-component-library`

L'application doit posséder une identité visuelle réellement travaillée.

Elle ne doit pas ressembler à un prototype SwiftUI standard.

Nom :

**Iris**

Univers :

**regard / perception / attention**

Direction générale :

* sombre ;
* élégante ;
* minimaliste ;
* immersive ;
* moderne ;
* distinctive.

Palette indicative :

* ambres ;
* noirs et gris très sombres ;
* tons neutres chauds ;
* vert menthe pour les validations ;
* corail pour les alertes et pertes de validation.

Le design doit rester lisible.

Évite l'accumulation gratuite d'effets.

Recherche une identité visuelle cohérente et mémorable.

---

# 16. RENDU DU JEU

Reproduis l'intention graphique du moteur de référence avec un rendu natif comprenant notamment :

* horizon ;
* sol en perspective ;
* impression de profondeur ;
* sphères avec volume ;
* éclairage radial ;
* ombres portées ;
* variation apparente d'échelle selon la profondeur ;
* animations fluides ;
* cercle ou zone d'arrivée clairement identifiable.

Les sphères doivent paraître appartenir à un espace visuel cohérent et non être de simples `Circle()` SwiftUI posés sur un écran.

Le rendu doit toutefois rester suffisamment léger pour conserver un framerate stable pendant le suivi ARKit.

---

# 17. ÉCRANS OBLIGATOIRES

Construis au minimum :

1. accueil ;
2. demande ou explication de permission caméra ;
3. règles / tutoriel ;
4. jeu ;
5. pause ;
6. fin de niveau ;
7. fin du parcours.

Ajoute également les interfaces ou états nécessaires pour :

* permission caméra refusée ;
* restriction caméra ;
* appareil sans TrueDepth compatible ;
* ARFaceTracking indisponible ;
* initialisation AR en cours ;
* interruption de session AR ;
* reprise de session ;
* passage de l'application en arrière-plan ;
* retour de l'application au premier plan ;
* erreur AR inattendue.

Aucune de ces situations ne doit provoquer un écran vide ou un crash.

---

# 18. NAVIGATION

La navigation doit être explicitement modélisée.

Évite une accumulation désorganisée de booléens SwiftUI.

Utilise le coordinator/navigation design approprié au projet.

Les transitions entre :

* accueil ;
* tutoriel ;
* jeu ;
* pause ;
* résultat ;
* niveau suivant ;
* parcours terminé ;
* erreur matérielle ;

doivent rester déterministes.

---

# 19. ARCHITECTURE

Utilise le pack :

`ios-app-skills`

Travaille avec les skills suivants dans cet ordre général :

1. `product-conception`
2. `architecture-designer`
3. `domain-modeler`
4. `data-layer-generator`
5. `use-case-generator`
6. `viewmodel-generator`
7. `view-generator`
8. `swiftui-component-library`
9. `dependency-injector`
10. `coordinator-navigator`
11. `business-logic-engine`
12. `swift-coder`
13. `file-structure-organizer`

Utilise les skills comme des outils de conception et de vérification.

Ne crée pas artificiellement des couches inutiles simplement pour pouvoir dire qu'un skill a été appliqué.

L'architecture doit rester proportionnée au projet.

Sépare clairement au minimum :

* domaine métier ;
* moteur physique ;
* règles de validation ;
* progression ;
* moteur de niveau ;
* suivi du regard ;
* intégration ARKit ;
* audio ;
* navigation ;
* ViewModels ;
* vues ;
* design system ;
* configuration.

La logique déterministe essentielle doit pouvoir fonctionner sans :

* ARKit ;
* caméra ;
* SwiftUI ;
* AVAudioEngine.

---

# 20. DÉPENDANCES

Utilise l'injection de dépendances lorsque cela permet de tester ou découpler les composants.

Exemples de services pouvant être abstraits :

* `GazeTrackingService`
* `AudioService`
* `GameClock`
* générateur de bruit ;
* moteur ou fournisseur de configuration des niveaux.

Évite les singletons globaux non nécessaires.

---

# 21. CONCURRENCE ET THREADING

Respecte les règles modernes de concurrence Swift.

Examine particulièrement :

* `@MainActor`
* callbacks ARKit ;
* mises à jour du moteur ;
* audio temps réel ;
* synchronisation des états ;
* cycles de vie des Tasks.

Les données utilisées par le moteur de jeu doivent rester cohérentes.

Évite les race conditions et les mutations concurrentes incontrôlées.

---

# 22. TESTS AUTOMATISÉS

Crée une vraie suite de tests pour les comportements déterministes.

Couvre notamment :

## Physique

* attraction vers la destination ;
* répulsion hors du regard ;
* intensité proportionnelle de la répulsion ;
* friction ;
* équivalence temporelle ;
* vitesse maximale ;
* rebonds ;
* amortissement ;
* stabilité avec plusieurs valeurs de `deltaTime`.

## Validation

* entrée dans la zone ;
* validation avant 0,75 s interdite ;
* validation après 0,75 s ;
* sortie avant validation ;
* maintien d'une cible validée ;
* perte après dépassement de la marge.

## Ordre

* cible 1 validable immédiatement ;
* cible 2 non validable avant 1 ;
* cible 3 non validable avant 1 et 2 ;
* arrivée physique hors tour autorisée ;
* validation logique hors tour interdite.

## Cascade

* perte de 3 n'affecte pas 1 et 2 ;
* perte de 2 invalide 2 et 3 ;
* perte de 1 invalide 1, 2 et 3.

## Progression

* 14 niveaux exactement ;
* niveaux 1-3 = 1 cible ;
* niveaux 4-8 = 2 cibles ;
* niveaux 9-14 = 3 cibles ;
* difficulté croissante conforme aux paramètres retenus.

---

# 23. ARKIT ET VALIDATION MATÉRIELLE

`ARFaceAnchor.lookAtPoint` dépend d'un appareil compatible TrueDepth.

Un simulateur ne constitue pas une validation fonctionnelle réelle de cette fonctionnalité.

Ne prétends jamais avoir testé physiquement le suivi du regard si aucun appareil compatible n'a réellement été utilisé.

Dans le README, utilise les statuts :

`[vérifié automatiquement]`

pour les comportements réellement couverts par les tests ;

`[vérifié par compilation]`

pour les composants réellement compilés mais non matériellement exercés ;

`[nécessite validation sur appareil TrueDepth]`

pour les fonctions nécessitant un test physique réel.

Ne transforme jamais :

`compile`

en :

`fonctionnellement testé`

si ce n'est pas le cas.

---

# 24. PERMISSION CAMÉRA

Ajoute :

`NSCameraUsageDescription`

dans la configuration de l'application.

Le message doit expliquer clairement que la caméra TrueDepth est utilisée pour détecter la direction du regard nécessaire au fonctionnement du jeu.

Le texte doit rester compréhensible pour un utilisateur non technique.

---

# 25. VIE PRIVÉE

Le traitement du regard doit rester local à l'appareil.

Ne crée :

* aucun compte utilisateur ;
* aucun serveur ;
* aucune infrastructure cloud ;
* aucun tracking analytics ;
* aucune collecte inutile des données de caméra.

Ne stocke pas de vidéo provenant de la caméra.

Ne stocke pas de représentation du visage.

Utilise uniquement les données nécessaires au fonctionnement temps réel du jeu.

---

# 26. COMPILATION CONTINUE

Ne construis pas toute l'application avant d'essayer de la compiler.

Travaille par étapes cohérentes.

Après chaque module ou groupe significatif :

1. exécute `xcodebuild` ;
2. lis les diagnostics ;
3. corrige les erreurs ;
4. recompile ;
5. vérifie que la base reste saine ;
6. puis poursuis.

Si des tests existent à ce stade, exécute-les également.

Ne laisse pas volontairement s'accumuler des dizaines d'erreurs pour les traiter à la fin.

---

# 27. WARNINGS

L'objectif est :

* zéro erreur de compilation ;
* zéro warning significatif provenant de notre propre code ;
* aucune anomalie sérieuse ignorée.

Ne perds toutefois pas un temps excessif à essayer de supprimer une notice provenant uniquement des outils Apple, de Xcode ou d'un framework système lorsqu'elle n'indique aucun défaut réel du projet.

Analyse chaque warning.

Classe-le en :

* problème réel de notre code → corriger ;
* problème d'architecture → corriger ;
* dépréciation pertinente → corriger si raisonnablement possible ;
* diagnostic externe ou notice système sans conséquence → documenter éventuellement et continuer.

Ne masque pas arbitrairement les warnings.

---

# 28. BUILDS FINAUX

À la fin, exécute réellement :

* build Debug ;
* tests ;
* build Release.

Utilise `xcodebuild`.

Consigne dans le README :

* les commandes exactes ;
* le résultat réel ;
* le nombre de tests exécutés si disponible ;
* le nombre de réussites ;
* le nombre d'échecs ;
* les éventuels tests ignorés ;
* les warnings significatifs restants.

N'invente aucun chiffre.

---

# 29. AUDIT FINAL

À la fin de l'implémentation, utilise :

* `layer-auditor`
* `code-deduplicator`

Puis effectue une revue globale portant notamment sur :

* séparation des responsabilités ;
* dépendances entre couches ;
* duplication ;
* code mort ;
* architecture ;
* conventions Swift ;
* Sendable ;
* MainActor ;
* cycles de vie ARKit ;
* interruptions ARKit ;
* cycles de vie AVAudioEngine ;
* interruptions audio ;
* Tasks ;
* références fortes ;
* fuites potentielles ;
* performances ;
* allocations dans la boucle temps réel ;
* stabilité du `deltaTime` ;
* comportement lors des chutes de framerate ;
* navigation ;
* accessibilité ;
* lisibilité ;
* contraste ;
* permissions ;
* états d'erreur.

Corrige les problèmes détectés lorsque cela améliore réellement le produit.

Recompile et relance les tests après les corrections d'audit.

---

# 30. STRUCTURE DES FICHIERS

Le projet Xcode doit être créé directement dans :

**le dossier courant**

Ne crée PAS un nouveau répertoire racine :

`./Iris/`

Le dossier courant doit directement contenir le projet Xcode.

Par exemple :

`Iris.xcodeproj`

ou la structure de projet retenue doit se trouver directement à cet emplacement.

Il est permis et souhaitable de créer des sous-dossiers internes comme :

* `App`
* `Domain`
* `GameEngine`
* `AR`
* `Audio`
* `Features`
* `DesignSystem`
* `Resources`
* `Tests`

mais pas un nouveau dossier conteneur racine `Iris/`.

---

# 31. PROTECTION DES FICHIERS EXISTANTS

Avant toute création ou modification :

* inventorie les fichiers présents ;
* distingue les fichiers préexistants des fichiers que tu crées.

Ne supprime aucun fichier préexistant sauf nécessité absolument démontrable.

Ne modifie jamais :

`attention-indirecte.html`

Ne déplace jamais :

`attention-indirecte.html`

Ne remplace jamais :

`attention-indirecte.html`

Ne détruis aucune archive ou ressource existante.

---

# 32. README AUTORITAIRE

Crée et maintiens :

`README.md`

Le README doit devenir le carnet technique autoritaire du projet.

Il doit contenir à la fin au minimum :

## Projet

* objectif d'Iris ;
* plateforme ;
* contraintes matérielles ;
* technologies.

## Source de référence

* rôle de `attention-indirecte.html` ;
* correspondance HTML/JavaScript → Swift ;
* différences volontaires éventuelles.

## Architecture

* couches ;
* responsabilités ;
* dépendances ;
* injection ;
* navigation.

## Game Engine

* unités utilisées ;
* `deltaTime` ;
* modèle physique ;
* attraction ;
* répulsion ;
* friction ;
* collisions ;
* bruit ;
* validation ;
* cascade.

## Niveaux

* 14 niveaux ;
* nombre de cibles ;
* paramètres ;
* progression de difficulté.

## Regard

* ARKit ;
* `lookAtPoint` ;
* projection ;
* filtrage ;
* disponibilité matérielle.

## Audio

* architecture AVAudioEngine ;
* sons ;
* politique lors des cascades.

## UI/UX

* identité visuelle ;
* composants principaux ;
* états d'erreur ;
* navigation.

## Confidentialité

* utilisation caméra ;
* données traitées ;
* absence de stockage vidéo ou facial.

## Tests

* tests réellement écrits ;
* tests réellement exécutés ;
* résultats réels.

## Builds

* commandes exactes ;
* Debug ;
* Release ;
* diagnostics importants.

## Validation

Classe les éléments à l'aide de :

`[vérifié automatiquement]`

`[vérifié par compilation]`

`[nécessite validation sur appareil TrueDepth]`

## Limites

Documente honnêtement ce qui ne peut pas être prouvé dans l'environnement disponible.

---

# 33. INTERDICTION DES FAUX PASS

Ne déclare jamais :

* `PASS`
* `SUCCESS`
* `VALIDÉ`
* `fonctionnel`

simplement parce que le code semble correct.

Un statut de réussite doit correspondre à une vérification réellement effectuée.

Exemples :

si `xcodebuild test` rapporte réellement 84 tests réussis :

tu peux écrire :

`84/84 PASS`

Si ARKit compile mais qu'aucun iPhone TrueDepth n'a été utilisé :

écris :

`[nécessite validation sur appareil TrueDepth]`

et non :

`AR gaze tracking PASS`.

---

# 34. GESTION DES BLOCAGES

Un blocage local ne doit pas arrêter toute la mission.

Si un point dépend :

* d'un appareil physique ;
* d'une permission externe ;
* d'une API indisponible dans le simulateur ;
* d'un environnement absent ;

isole cette limite.

Puis continue tout ce qui peut être :

* implémenté ;
* compilé ;
* testé ;
* audité.

Documente précisément la limitation dans le README.

---

# 35. PRIORITÉS EN CAS DE CONTRAINTE DE TEMPS OU DE CONTEXTE

Si tu dois arbitrer entre plusieurs travaux, priorise :

1. fidélité fonctionnelle du moteur ;
2. règles métier et tests ;
3. stabilité de compilation ;
4. architecture saine ;
5. suivi du regard ;
6. expérience de jeu ;
7. gestion des erreurs ;
8. audio ;
9. qualité visuelle ;
10. raffinements cosmétiques.

Ne sacrifie jamais les règles fondamentales du jeu pour du polish visuel.

---

# 36. CRITÈRE DE FIN DE MISSION

La mission n'est considérée comme terminée que lorsque tu as poussé le projet aussi loin que le permet réellement l'environnement disponible et que :

* le projet Xcode Iris existe directement dans le dossier courant ;
* `attention-indirecte.html` est intact ;
* son moteur a été analysé ;
* le jeu est réimplémenté nativement en Swift ;
* aucune WebView n'est utilisée comme moteur ;
* l'architecture est cohérente ;
* le suivi du regard ARKit est implémenté ;
* le moteur déterministe est découplé d'ARKit ;
* le moteur physique est fonctionnel ;
* la validation 0,75 s existe ;
* l'ordre 1 → 2 → 3 est respecté ;
* l'invalidation en cascade existe ;
* les 14 niveaux existent ;
* la difficulté progresse ;
* l'audio est implémenté ;
* les écrans principaux existent ;
* les états d'erreur existent ;
* l'identité visuelle Iris existe ;
* les tests déterministes existent ;
* les tests exécutables ont été réellement exécutés ;
* le build Debug a été réellement tenté et corrigé jusqu'à réussite si l'environnement le permet ;
* le build Release a été réellement tenté et corrigé jusqu'à réussite si l'environnement le permet ;
* l'audit final a été effectué ;
* les corrections d'audit utiles ont été appliquées ;
* le README reflète fidèlement l'état réel du projet.

Si une validation matérielle TrueDepth reste nécessaire, cela ne bloque pas la fin des autres travaux.

Implémente tout ce qui peut l'être.

Teste tout ce qui peut réellement être testé.

Compile tout ce qui peut réellement être compilé.

Documente honnêtement le reste.

**Ne pose aucune question à l'utilisateur.**

**Ne demande aucune confirmation.**

**Prends les décisions nécessaires et poursuis jusqu'au maximum raisonnablement atteignable dans la session.**

~~~~

### 2026-09-10 23:29:27 +0200 (21:29:27Z) · CLAUDE
`f88478cc` · `4d97bd3d` · ligne 75

~~~~markdown
Je démarre la mission. Première étape : inventaire du dossier, lecture intégrale de `attention-indirecte.html`, puis vérification des outils disponibles (skills, xcodegen, simulateurs).
~~~~

#### 2026-09-10 23:29:29 +0200 (21:29:29Z) · TOOL CALL · Bash · GIT
`f88478cc` · `9bb418d6` · ligne 76 · Inventory current directory contents

~~~~bash
cd "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris" && ls -la && echo "---FIND---" && find . -maxdepth 3 -not -path '*/.git/*' | head -200 && echo "---SIZES---" && du -sh * 2>/dev/null
~~~~

#### 2026-09-10 23:29:29 +0200 (21:29:29Z) · TOOL RESULT · Bash · GIT
`f88478cc` · `e1f3574d` · ligne 77 · Inventory current directory contents

~~~~text
total 1408
drwxr-xr-x   5 prodx0x  staff     160 10 sept. 23:17 .
drwx------  13 prodx0x  staff     416 10 sept. 23:11 ..
-rw-r--r--@  1 prodx0x  staff   24266 10 sept. 23:16 attention-indirecte.html
-rw-------@  1 prodx0x  staff  112405 29 août  06:55 ios-app-skills.zip
-rw-r--r--@  1 prodx0x  staff  581123  5 sept. 13:21 SwiftUI-Agent-Skill-main.zip
---FIND---
.
./ios-app-skills.zip
./attention-indirecte.html
./SwiftUI-Agent-Skill-main.zip
---SIZES---
 24K	attention-indirecte.html
112K	ios-app-skills.zip
568K	SwiftUI-Agent-Skill-main.zip
~~~~

#### 2026-09-10 23:29:31 +0200 (21:29:31Z) · TOOL CALL · Bash
`f88478cc` · `a426ed90` · ligne 81 · Read the reference HTML game engine in full

~~~~bash
cd "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris" && cat attention-indirecte.html
~~~~

#### 2026-09-10 23:29:31 +0200 (21:29:31Z) · TOOL RESULT · Bash
`f88478cc` · `b6a04a77` · ligne 82 · Read the reference HTML game engine in full

~~~~text
<!DOCTYPE html>
<html lang="fr">
<head>
<meta charset="UTF-8">
<title>Attention indirecte</title>
<style>
  html, body { margin: 0; padding: 0; background: #16171a; overflow: hidden; height: 100%; }
  canvas { display: block; cursor: none; }
  body.show-cursor canvas { cursor: default; }
</style>
</head>
<body>
<canvas id="game"></canvas>
<script src="https://cdn.jsdelivr.net/npm/webgazer@3.3.0/dist/webgazer.min.js" onerror="this.dataset.failed=1"></script>
<script>
const canvas = document.getElementById('game');
const ctx = canvas.getContext('2d');
function resize() { canvas.width = window.innerWidth; canvas.height = window.innerHeight; }
resize();
window.addEventListener('resize', resize);

// --- Curseur logique piloté EXCLUSIVEMENT par le regard (WebGazer) ---
const cursor = { x: window.innerWidth / 2, y: window.innerHeight / 2 };
let gazeActive = false;

// --- Bruit de Perlin 1D minimal (approximation par interpolation de valeurs aléatoires) ---
function makeNoise1D(seed) {
  let s = seed;
  function rand() { s = (s * 9301 + 49297) % 233280; return s / 233280; }
  const table = Array.from({length: 256}, () => rand() * 2 - 1);
  return function noise(t) {
    const i = Math.floor(t) % 256;
    const f = t - Math.floor(t);
    const a = table[i], b = table[(i + 1) % 256];
    const u = f * f * (3 - 2 * f);
    return a * (1 - u) + b * u;
  };
}

// --- Génération de niveaux (courbe de progression complète, cf. spec section 4) ---
const GAZE_ZONE_MULTIPLIER = 1.6; // compense l'imprécision du regard vs curseur souris
function rngFor(seed) {
  let s = seed;
  return () => { s = (s * 9301 + 49297) % 233280; return s / 233280; };
}
function randomPoint(rng, margin = 0.2) {
  return [margin + rng() * (1 - 2 * margin), margin + rng() * (1 - 2 * margin)];
}
function buildLevel(n) {
  const rng = rngFor(2000 + n * 97);
  let count, zone, krep, attr;
  if (n < 3) { count = 1; zone = 220; krep = 0.008; attr = 0.6; }
  else if (n < 8) { count = 2; zone = 190; krep = 0.009; attr = 0.55; }
  else { count = 3; zone = 150; krep = 0.013; attr = 0.5; }
  const targets = [];
  for (let i = 0; i < count; i++) {
    targets.push({
      seq: i + 1,
      start: randomPoint(rng),
      arrival: randomPoint(rng),
      zone_attention: zone * GAZE_ZONE_MULTIPLIER,
      k_repulsion: krep,
      attraction_passive: attr,
      amplitude_bruit: 0.15
    });
  }
  return { id: `level_${String(n + 1).padStart(2, '0')}`, hold_time_frames: 45, targets, sequential: count > 1 };
}
const TOTAL_LEVELS = 14;
const LEVELS = Array.from({ length: TOTAL_LEVELS }, (_, n) => buildLevel(n));
const SEQ_COLORS = ['#D85A30', '#378ADD', '#639922', '#D4537E', '#BA7517'];

const RADIUS_TARGET = 24;
const RADIUS_ARRIVAL = 40;
const VITESSE_MAX = 2.2;
const FRICTION = 0.94;
const MARGE_BORD = 60;
const PERTE_REBOND = 0.5;

let currentLevelIndex = 0;
let targets = [];
let levelSequential = false;
let levelTransitionFlash = 0;
let gameState = 'camera_prompt'; // 'camera_prompt' | 'calibration' | 'rules' | 'start' | 'playing' | 'paused' | 'finished'

// --- Calibration WebGazer : 6 points, couvrant les quatre coins et les bords ---
// Le coin haut-gauche est décalé pour ne pas être caché par la vignette webcam,
// mais un point gauche à mi-hauteur est nécessaire pour que le modèle apprenne aussi
// ce côté de l'écran — son absence était la cause du blocage aux extrémités gauches.
const calibPoints = [
  [0.5, 0.1], [0.9, 0.1], [0.1, 0.5], [0.5, 0.5], [0.1, 0.9], [0.9, 0.9]
];
let calibIndex = 0;
let calibClicksOnPoint = 0;
const CLICKS_NEEDED = 5;

let gazeStatus = 'chargement…';
let lastGazeTime = 0;
let consecutiveBigJumps = 0;
const FACE_LOST_TIMEOUT = 300; // ms sans donnée = visage perdu, on coupe l'attraction

function startWebgazer() {
  webgazer.setRegression('ridge')
    .setGazeListener((data) => {
      if (data && gameState === 'playing') {
        const jump = Math.hypot(data.x - cursor.x, data.y - cursor.y);
        if (jump > 300 && gazeActive) {
          consecutiveBigJumps++;
          // un saut isolé (clignement) est ignoré une ou deux frames,
          // mais un déplacement sostenu (vrai regard vers un coin) doit passer
          if (consecutiveBigJumps < 3) return;
        } else {
          consecutiveBigJumps = 0;
        }
        const alpha = 0.1; // lissage renforcé — priorité à la stabilité sur la réactivité
        cursor.x = cursor.x + (data.x - cursor.x) * alpha;
        cursor.y = cursor.y + (data.y - cursor.y) * alpha;
        gazeActive = true;
        gazeStatus = 'regard actif';
        lastGazeTime = performance.now();
      }
    })
    .saveDataAcrossSessions(false)
    .begin()
    .then(() => { gazeStatus = 'caméra ok — calibration en cours'; gameState = 'calibration'; })
    .catch(() => { gazeStatus = 'accès caméra refusé — souris/tactile'; gameState = 'rules'; });
  webgazer.showVideoPreview(true).showPredictionPoints(false);
}

function faceCurrentlyLost() {
  return gazeActive && (performance.now() - lastGazeTime > FACE_LOST_TIMEOUT);
}

canvas.addEventListener('click', (e) => {
  if (gameState !== 'calibration') return;
  const [px, py] = calibPoints[calibIndex];
  const targetX = px * canvas.width, targetY = py * canvas.height;
  const d = Math.hypot(e.clientX - targetX, e.clientY - targetY);
  if (d < 60) {
    calibClicksOnPoint++;
    if (typeof webgazer !== 'undefined') {
      webgazer.recordScreenPosition(targetX, targetY, 'click');
    }
    if (calibClicksOnPoint >= CLICKS_NEEDED) {
      calibIndex++;
      calibClicksOnPoint = 0;
      if (calibIndex >= calibPoints.length) {
        gameState = 'rules';
      }
    }
  }
});

function enterPlaying() {
  ensureAudio();
  gameState = 'playing';
}

window.addEventListener('keydown', e => {
  if (e.key === 'Escape' && gameState === 'playing') gameState = 'paused';
  else if (e.key === 'Escape' && gameState === 'paused') gameState = 'playing';
  else if (e.key.toLowerCase() === 'r' && (gameState === 'playing' || gameState === 'paused')) {
    gameState = 'calibration';
    calibIndex = 0;
    calibClicksOnPoint = 0;
    gazeStatus = 'recalibration en cours';
  }
});
window.addEventListener('click', () => {
  if (gameState === 'rules') gameState = 'start';
  else if (gameState === 'start') enterPlaying();
  else if (gameState === 'finished') { currentLevelIndex = 0; loadLevel(0); enterPlaying(); }
});
window.addEventListener('touchstart', () => {
  if (gameState === 'rules') gameState = 'start';
  else if (gameState === 'start') enterPlaying();
  else if (gameState === 'finished') { currentLevelIndex = 0; loadLevel(0); enterPlaying(); }
});

if (typeof webgazer !== 'undefined') {
  gazeStatus = 'cliquez pour activer la caméra';
  gameState = 'camera_prompt';
} else {
  gazeStatus = document.querySelector('script[src*="webgazer"]')?.dataset.failed
    ? 'script webgazer bloqué (réseau/CDN) — jeu impossible sans regard'
    : 'webgazer indisponible — jeu impossible sans regard';
  gameState = 'camera_prompt'; // reste bloqué ici, pas de repli souris
}

window.addEventListener('click', function activateCamera() {
  if (gameState === 'camera_prompt') {
    gazeStatus = 'demande d\u2019accès caméra…';
    startWebgazer();
  }
}, { once: false });

function loadLevel(index) {
  if (typeof targets !== 'undefined') targets.forEach(tg => stopCrescendo(tg));
  const level = LEVELS[index % LEVELS.length];
  targets = level.targets.map((cfg, i) => ({
    seq: cfg.seq,
    color: SEQ_COLORS[(cfg.seq - 1) % SEQ_COLORS.length],
    x: cfg.start[0] * canvas.width,
    y: cfg.start[1] * canvas.height,
    vx: 0, vy: 0,
    arrivalBaseX: cfg.arrival[0] * canvas.width,
    arrivalBaseY: cfg.arrival[1] * canvas.height,
    arrivalX: cfg.arrival[0] * canvas.width,
    arrivalY: cfg.arrival[1] * canvas.height,
    zone_attention: cfg.zone_attention,
    k_repulsion: cfg.k_repulsion,
    attraction_passive: cfg.attraction_passive,
    amplitude_bruit: cfg.amplitude_bruit,
    noise: makeNoise1D(1000 + i * 137),
    driftNoise: makeNoise1D(5000 + i * 211),
    holdFrames: 0,
    holdRequired: level.hold_time_frames,
    settled: false
  }));
  levelSequential = level.sequential;
}

loadLevel(currentLevelIndex);

// --- Audio : crescendo pendant la validation, chime à la victoire, buzz à la perte ---
let audioCtx = null;
let audioStatus = 'non initialisé';
function ensureAudio() {
  try {
    if (!audioCtx) audioCtx = new (window.AudioContext || window.webkitAudioContext)();
    if (audioCtx.state === 'suspended') {
      audioCtx.resume().then(() => { audioStatus = 'actif'; }).catch(() => { audioStatus = 'bloqué par le navigateur'; });
    } else {
      audioStatus = 'actif';
    }
  } catch (e) {
    audioStatus = 'indisponible sur ce navigateur';
  }
  return audioCtx;
}
function playChime(freqs, dur = 0.12, gainPeak = 0.05) {
  const ctxA = ensureAudio();
  freqs.forEach((f, i) => {
    const osc = ctxA.createOscillator();
    const gain = ctxA.createGain();
    osc.type = 'sine';
    osc.frequency.value = f;
    const start = ctxA.currentTime + i * dur;
    gain.gain.setValueAtTime(0, start);
    gain.gain.linearRampToValueAtTime(gainPeak, start + dur * 0.3);
    gain.gain.linearRampToValueAtTime(0, start + dur);
    osc.connect(gain).connect(ctxA.destination);
    osc.start(start);
    osc.stop(start + dur);
  });
}
function playFail() {
  const ctxA = ensureAudio();
  const osc = ctxA.createOscillator();
  const gain = ctxA.createGain();
  osc.type = 'sine';
  const start = ctxA.currentTime;
  osc.frequency.setValueAtTime(220, start);
  osc.frequency.linearRampToValueAtTime(120, start + 0.25);
  gain.gain.setValueAtTime(0.05, start);
  gain.gain.linearRampToValueAtTime(0, start + 0.25);
  osc.connect(gain).connect(ctxA.destination);
  osc.start(start);
  osc.stop(start + 0.25);
}
function ensureCrescendoOsc(target) {
  if (target._osc) return;
  const ctxA = ensureAudio();
  const osc = ctxA.createOscillator();
  const gain = ctxA.createGain();
  osc.type = 'sine';
  osc.frequency.value = 220;
  gain.gain.value = 0;
  osc.connect(gain).connect(ctxA.destination);
  osc.start();
  target._osc = osc;
  target._gain = gain;
}
function updateCrescendo(target, progress) {
  ensureCrescendoOsc(target);
  const ctxA = ensureAudio();
  target._osc.frequency.setTargetAtTime(220 + progress * 340, ctxA.currentTime, 0.05);
  target._gain.gain.setTargetAtTime(0.02 + progress * 0.025, ctxA.currentTime, 0.05);
}
function stopCrescendo(target) {
  if (!target._osc) return;
  const ctxA = ensureAudio();
  target._gain.gain.setTargetAtTime(0, ctxA.currentTime, 0.08);
  const osc = target._osc, gain = target._gain;
  setTimeout(() => { try { osc.stop(); osc.disconnect(); gain.disconnect(); } catch (e) {} }, 400);
  target._osc = null;
  target._gain = null;
}
document.addEventListener('click', () => ensureAudio());
document.addEventListener('touchstart', () => ensureAudio());

let t = 0;

function step() {
  t += 1;
  let allSettled = true;

  // Cible dont le tour est venu : la plus petite valeur de seq non encore validée.
  // Toutes les sphères dérivent normalement en permanence — rien n'est figé.
  // Seule la VALIDATION est refusée hors tour : une sphère hors-tour peut atteindre
  // sa cible mais n'y reste jamais validée tant que ce n'est pas son tour.
  let lowestUnsettledSeq = Infinity;
  if (levelSequential) {
    for (const tg of targets) if (!tg.settled) lowestUnsettledSeq = Math.min(lowestUnsettledSeq, tg.seq);
  }

  for (const target of targets) {
    const dx = target.x - cursor.x;
    const dy = target.y - cursor.y;
    const d = Math.hypot(dx, dy) || 0.0001;

    if (d < target.zone_attention) {
      const force = target.k_repulsion * (target.zone_attention - d);
      target.vx += (dx / d) * force;
      target.vy += (dy / d) * force;
    } else {
      const adx = target.arrivalX - target.x;
      const ady = target.arrivalY - target.y;
      const ad = Math.hypot(adx, ady) || 0.0001;
      target.vx += (adx / ad) * target.attraction_passive;
      target.vy += (ady / ad) * target.attraction_passive;
      target.vx += target.noise(t * 0.02) * target.amplitude_bruit;
      target.vy += target.noise(t * 0.02 + 50) * target.amplitude_bruit;
    }

    const speed = Math.hypot(target.vx, target.vy);
    if (speed > VITESSE_MAX) {
      target.vx = (target.vx / speed) * VITESSE_MAX;
      target.vy = (target.vy / speed) * VITESSE_MAX;
    }

    target.vx *= FRICTION;
    target.vy *= FRICTION;

    target.x += target.vx;
    target.y += target.vy;

    if (target.x < MARGE_BORD) { target.x = MARGE_BORD; target.vx *= -PERTE_REBOND; }
    if (target.x > canvas.width - MARGE_BORD) { target.x = canvas.width - MARGE_BORD; target.vx *= -PERTE_REBOND; }
    if (target.y < MARGE_BORD) { target.y = MARGE_BORD; target.vy *= -PERTE_REBOND; }
    if (target.y > canvas.height - MARGE_BORD) { target.y = canvas.height - MARGE_BORD; target.vy *= -PERTE_REBOND; }

    const distToArrival = Math.hypot(target.x - target.arrivalX, target.y - target.arrivalY);
    const isTargetsTurn = !levelSequential || target.settled || target.seq === lowestUnsettledSeq;
    const SETTLE_RADIUS = RADIUS_ARRIVAL - RADIUS_TARGET; // pour valider la première fois
    const WOBBLE_TOLERANCE = SETTLE_RADIUS + 20; // une fois validée, marge avant de perdre la position

    const wasSettled = target.settled;
    if (target.settled) {
      // déjà validée : on tolère un léger mouvement, mais sortir du cercle élargi invalide la position
      if (distToArrival > WOBBLE_TOLERANCE) {
        target.settled = false;
        target.holdFrames = 0;
      }
    } else if (distToArrival < SETTLE_RADIUS && isTargetsTurn) {
      target.holdFrames += 1;
      target.settled = target.holdFrames >= target.holdRequired;
    } else {
      target.holdFrames = 0; // hors tour, ou pas encore assez proche : jamais de validation
    }

    // Audio : crescendo tant que la validation progresse, chime à la validation, buzz à la perte
    if (!target.settled && target.holdFrames > 0) {
      updateCrescendo(target, target.holdFrames / target.holdRequired);
    } else {
      stopCrescendo(target);
    }
    if (target.settled && !wasSettled) {
      playChime([660, 880, 1100]);
    } else if (!target.settled && wasSettled) {
      playFail();
    }

    if (!target.settled) allSettled = false;
  }

  // Cascade : si une sphère validée redevient invalide, toute sphère de rang supérieur
  // déjà validée doit elle aussi être reprise — l'ordre 1, 2, 3… doit rester intact en permanence.
  if (levelSequential) {
    let brokenSeq = Infinity;
    for (const tg of targets) if (!tg.settled) { brokenSeq = Math.min(brokenSeq, tg.seq); break; }
    for (const tg of targets) {
      if (tg.settled && tg.seq > brokenSeq) {
        tg.settled = false;
        tg.holdFrames = 0;
        stopCrescendo(tg);
        playFail();
        allSettled = false;
      }
    }
  }

  if (allSettled) {
    currentLevelIndex += 1;
    levelTransitionFlash = 90; // ~1,5s à 60fps
    if (currentLevelIndex >= LEVELS.length) {
      gameState = 'finished';
    } else {
      loadLevel(currentLevelIndex);
    }
  }
  if (levelTransitionFlash > 0) levelTransitionFlash--;
}

function draw() {
  // Ciel + horizon
  const horizonY = canvas.height * 0.38;
  const skyGrad = ctx.createLinearGradient(0, 0, 0, horizonY);
  skyGrad.addColorStop(0, '#1b1d22');
  skyGrad.addColorStop(1, '#2a2d33');
  ctx.fillStyle = skyGrad;
  ctx.fillRect(0, 0, canvas.width, horizonY);

  const floorGrad = ctx.createLinearGradient(0, horizonY, 0, canvas.height);
  floorGrad.addColorStop(0, '#232529');
  floorGrad.addColorStop(1, '#121316');
  ctx.fillStyle = floorGrad;
  ctx.fillRect(0, horizonY, canvas.width, canvas.height - horizonY);

  // Lignes de fuite vers l'horizon (repères de profondeur, purement décoratifs)
  ctx.strokeStyle = 'rgba(255,255,255,0.05)';
  ctx.lineWidth = 1;
  const vanishX = canvas.width / 2;
  for (let i = -4; i <= 4; i++) {
    ctx.beginPath();
    ctx.moveTo(vanishX, horizonY);
    ctx.lineTo(vanishX + i * canvas.width * 0.18, canvas.height);
    ctx.stroke();
  }

  for (const target of targets) {
    // Profondeur illusoire : plus la cible est haute à l'écran, plus elle est "loin"
    const depthT = Math.max(0, Math.min(1, (target.y - horizonY) / (canvas.height - horizonY)));
    const scale = 0.55 + depthT * 0.65;
    const arrivalDepthT = Math.max(0, Math.min(1, (target.arrivalY - horizonY) / (canvas.height - horizonY)));
    const arrivalScale = 0.55 + arrivalDepthT * 0.65;

    // Ombre portée + anneau d'arrivée (au sol, aplati)
    ctx.save();
    ctx.translate(target.arrivalX, target.arrivalY);
    ctx.scale(1, 0.4);
    const progress = target.holdFrames / target.holdRequired;
    ctx.beginPath();
    ctx.arc(0, 0, RADIUS_ARRIVAL * arrivalScale, -Math.PI / 2, -Math.PI / 2 + progress * 2 * Math.PI);
    ctx.strokeStyle = '#5DCAA5';
    ctx.lineWidth = 2.5;
    ctx.stroke();
    ctx.beginPath();
    ctx.arc(0, 0, RADIUS_ARRIVAL * arrivalScale, 0, 2 * Math.PI);
    ctx.strokeStyle = 'rgba(255,255,255,0.12)';
    ctx.lineWidth = 1;
    ctx.stroke();
    ctx.restore();

    if (levelSequential) {
      ctx.beginPath();
      ctx.arc(target.arrivalX, target.arrivalY, RADIUS_ARRIVAL * arrivalScale + 6, 0, 2 * Math.PI);
      ctx.strokeStyle = target.color;
      ctx.lineWidth = 3;
      ctx.globalAlpha = 0.8;
      ctx.stroke();
      ctx.globalAlpha = 1;
      ctx.fillStyle = target.color;
      ctx.font = '11px sans-serif';
      ctx.textAlign = 'center';
      ctx.fillText(String(target.seq), target.arrivalX, target.arrivalY - RADIUS_ARRIVAL * arrivalScale - 12);
    }

    // Ombre de la sphère
    ctx.save();
    ctx.translate(target.x, target.y + RADIUS_TARGET * scale * 0.9);
    ctx.scale(1, 0.35);
    ctx.beginPath();
    ctx.arc(0, 0, RADIUS_TARGET * scale * 0.9, 0, 2 * Math.PI);
    ctx.fillStyle = 'rgba(0,0,0,0.4)';
    ctx.fill();
    ctx.restore();

    // Sphère avec éclairage radial (remplace la pulsation par un halo de vitesse)
    const speed = Math.hypot(target.vx, target.vy);
    const r = RADIUS_TARGET * scale;
    const baseColor = target.settled ? [93, 202, 165] : [180, 178, 169];
    const grad = ctx.createRadialGradient(
      target.x - r * 0.35, target.y - r * 0.35, r * 0.1,
      target.x, target.y, r
    );
    grad.addColorStop(0, `rgba(${baseColor[0] + 40},${baseColor[1] + 40},${baseColor[2] + 40},1)`);
    grad.addColorStop(1, `rgba(${baseColor[0] - 30},${baseColor[1] - 30},${baseColor[2] - 30},1)`);
    ctx.beginPath();
    ctx.arc(target.x, target.y, r, 0, 2 * Math.PI);
    ctx.fillStyle = grad;
    ctx.fill();

    if (speed > 0.3) {
      ctx.beginPath();
      ctx.arc(target.x, target.y, r + 4 + speed * 2, 0, 2 * Math.PI);
      ctx.strokeStyle = `rgba(216,90,48,${Math.min(0.5, speed * 0.15)})`;
      ctx.lineWidth = 2;
      ctx.stroke();
    }

    if (levelSequential) {
      ctx.beginPath();
      ctx.arc(target.x, target.y, r + 5, 0, 2 * Math.PI);
      ctx.strokeStyle = target.color;
      ctx.lineWidth = 3;
      ctx.stroke();
      ctx.fillStyle = '#16171a';
      ctx.font = '12px sans-serif';
      ctx.textAlign = 'center';
      ctx.textBaseline = 'middle';
      ctx.fillText(String(target.seq), target.x, target.y);
      ctx.textBaseline = 'alphabetic';
    }
  }

  if (levelSequential) {
    ctx.textAlign = 'left';
    ctx.font = '12px sans-serif';
    ctx.fillStyle = 'rgba(255,255,255,0.4)';
    ctx.fillText('la validation ne compte que dans l\'ordre 1, 2, 3…', 16, canvas.height - 80);
  }

  ctx.textAlign = 'left';
  ctx.font = '13px sans-serif';
  ctx.fillStyle = 'rgba(255,255,255,0.55)';
  const sphereWord = targets.length > 1 ? 'sphères' : 'sphère';
  ctx.fillText(`niveau ${currentLevelIndex + 1} / ${LEVELS.length} — ${targets.length} ${sphereWord}`, 16, 28);

  if (levelTransitionFlash > 0) {
    ctx.textAlign = 'center';
    ctx.font = '20px sans-serif';
    ctx.fillStyle = `rgba(93,202,165,${Math.min(1, levelTransitionFlash / 30)})`;
    ctx.fillText('niveau terminé', canvas.width / 2, 70);
  }

  ctx.textAlign = 'left';
  ctx.font = '12px sans-serif';
  ctx.fillStyle = gazeActive ? '#5DCAA5' : '#D85A30';
  ctx.fillText('mode : ' + (gazeActive ? 'regard' : gazeStatus), 16, canvas.height - 16);

  ctx.fillStyle = audioStatus === 'actif' ? '#5DCAA5' : '#D85A30';
  ctx.fillText('son : ' + audioStatus, 16, canvas.height - 36);
}

function drawOverlay(title, subtitle) {
  ctx.fillStyle = 'rgba(22,23,26,0.88)';
  ctx.fillRect(0, 0, canvas.width, canvas.height);
  ctx.fillStyle = '#EEEDFE';
  ctx.font = '28px sans-serif';
  ctx.textAlign = 'center';
  ctx.fillText(title, canvas.width / 2, canvas.height / 2 - 10);
  ctx.fillStyle = '#B4B2A9';
  ctx.font = '15px sans-serif';
  ctx.fillText(subtitle, canvas.width / 2, canvas.height / 2 + 24);
}

function drawRules() {
  ctx.fillStyle = 'rgba(22,23,26,0.94)';
  ctx.fillRect(0, 0, canvas.width, canvas.height);
  ctx.textAlign = 'center';
  const cx = canvas.width / 2;
  const cy = canvas.height / 2;
  ctx.fillStyle = '#EEEDFE';
  ctx.font = '26px sans-serif';
  ctx.fillText('attention indirecte', cx, cy - 130);

  const lines = [
    'Une cible doit atteindre son point d\u2019arrivée.',
    '',
    'Si tu la regardes ou pointes vers elle de trop près, elle s\u2019éloigne.',
    'Si tu la laisses tranquille, elle dérive doucement vers son but.',
    '',
    'Pas de chronomètre, pas de vies, pas de score.',
    'La difficulté augmente avec le nombre de cibles à ignorer',
    'en même temps — la seule compétence est de répartir',
    'son attention sans jamais la fixer.',
    '',
    'Suivi du regard. Échap pour mettre en pause. R pour recalibrer à tout moment.'
  ];
  ctx.fillStyle = '#D3D1C7';
  ctx.font = '15px sans-serif';
  lines.forEach((line, i) => ctx.fillText(line, cx, cy - 80 + i * 24));

  ctx.fillStyle = '#5DCAA5';
  ctx.font = '15px sans-serif';
  ctx.fillText('cliquez ou touchez l\u2019écran pour continuer', cx, cy + 220);
}

function drawCalibration() {
  ctx.fillStyle = '#16171a';
  ctx.fillRect(0, 0, canvas.width, canvas.height);
  ctx.textAlign = 'center';
  ctx.fillStyle = '#EEEDFE';
  ctx.font = '22px sans-serif';
  ctx.fillText('calibration du regard', canvas.width / 2, 60);
  ctx.fillStyle = '#B4B2A9';
  ctx.font = '14px sans-serif';
  ctx.fillText('fixez le point et cliquez dessus 5 fois', canvas.width / 2, 90);

  calibPoints.forEach(([px, py], i) => {
    const x = px * canvas.width, y = py * canvas.height;
    ctx.beginPath();
    ctx.arc(x, y, 18, 0, 2 * Math.PI);
    ctx.fillStyle = i === calibIndex ? '#D85A30' : 'rgba(255,255,255,0.15)';
    ctx.fill();
    if (i === calibIndex) {
      ctx.beginPath();
      ctx.arc(x, y, 18, -Math.PI / 2, -Math.PI / 2 + (calibClicksOnPoint / CLICKS_NEEDED) * 2 * Math.PI);
      ctx.strokeStyle = '#5DCAA5';
      ctx.lineWidth = 3;
      ctx.stroke();
    }
  });
}

function drawCameraPrompt() {
  ctx.fillStyle = '#16171a';
  ctx.fillRect(0, 0, canvas.width, canvas.height);
  ctx.textAlign = 'center';
  ctx.fillStyle = '#EEEDFE';
  ctx.font = '22px sans-serif';
  ctx.fillText('attention indirecte', canvas.width / 2, canvas.height / 2 - 20);
  ctx.fillStyle = '#B4B2A9';
  ctx.font = '15px sans-serif';
  ctx.fillText('cliquez pour autoriser la caméra', canvas.width / 2, canvas.height / 2 + 12);
}

function loop() {
  document.body.classList.toggle('show-cursor', gameState !== 'playing');
  if (gameState === 'camera_prompt') {
    drawCameraPrompt();
  } else if (gameState === 'calibration') {
    drawCalibration();
  } else if (gameState === 'playing') {
    step();
    draw();
  } else if (gameState === 'rules') {
    drawRules();
  } else if (gameState === 'start') {
    draw();
    drawOverlay('attention indirecte', 'cliquez ou touchez l\u2019écran pour commencer \u2014 échap = pause');
  } else if (gameState === 'paused') {
    draw();
    drawOverlay('pause', 'échap pour reprendre');
  } else if (gameState === 'finished') {
    draw();
    drawOverlay('parcours terminé', 'cliquez pour recommencer');
  }
  requestAnimationFrame(loop);
}
loop();
</script>
</body>
</html>
~~~~

#### 2026-09-10 23:34:05 +0200 (21:34:05Z) · TOOL CALL · Bash
`f88478cc` · `32c74a58` · ligne 94 · Extract skill archives to scratchpad and list contents

~~~~bash
SP="/private/tmp/claude-501/-Volumes-Steve-Pro-BlackSSD-Dev-App-Mobile-Iris/f88478cc-d512-4210-bc11-758059278995/scratchpad"; mkdir -p "$SP/skills" && cd "$SP/skills" && unzip -q -o "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris/ios-app-skills.zip" -d ios-app-skills && unzip -q -o "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris/SwiftUI-Agent-Skill-main.zip" -d swiftui-agent-skill && echo "=== ios-app-skills ===" && find ios-app-skills -type f | sort && echo "=== swiftui-agent-skill (dirs) ===" && find swiftui-agent-skill -maxdepth 3 -type d | sort && echo "=== swiftui md files ===" && find swiftui-agent-skill -type f -name "*.md" | sort | head -100 && echo "=== counts ===" && find swiftui-agent-skill -type f | wc -l
~~~~

#### 2026-09-10 23:34:07 +0200 (21:34:07Z) · TOOL RESULT · Bash
`f88478cc` · `7669a9ce` · ligne 101 · Extract skill archives to scratchpad and list contents

~~~~text
=== ios-app-skills ===
ios-app-skills/ios-app-skills/.claude-plugin/marketplace.json
ios-app-skills/ios-app-skills/.gitignore
ios-app-skills/ios-app-skills/ALL-SKILLS.md
ios-app-skills/ios-app-skills/CONTRIBUTING.md
ios-app-skills/ios-app-skills/LICENSE
ios-app-skills/ios-app-skills/README.md
ios-app-skills/ios-app-skills/skills/architecture-designer/SKILL.md
ios-app-skills/ios-app-skills/skills/business-logic-engine/SKILL.md
ios-app-skills/ios-app-skills/skills/code-deduplicator/SKILL.md
ios-app-skills/ios-app-skills/skills/coordinator-navigator/SKILL.md
ios-app-skills/ios-app-skills/skills/data-layer-generator/SKILL.md
ios-app-skills/ios-app-skills/skills/dependency-injector/SKILL.md
ios-app-skills/ios-app-skills/skills/domain-modeler/SKILL.md
ios-app-skills/ios-app-skills/skills/feature-builder/SKILL.md
ios-app-skills/ios-app-skills/skills/file-structure-organizer/SKILL.md
ios-app-skills/ios-app-skills/skills/ios-project-foundation/references/conventions-template.md
ios-app-skills/ios-app-skills/skills/ios-project-foundation/SKILL.md
ios-app-skills/ios-app-skills/skills/layer-auditor/SKILL.md
ios-app-skills/ios-app-skills/skills/product-conception/SKILL.md
ios-app-skills/ios-app-skills/skills/swift-coder/SKILL.md
ios-app-skills/ios-app-skills/skills/swiftui-component-library/SKILL.md
ios-app-skills/ios-app-skills/skills/test-generator/SKILL.md
ios-app-skills/ios-app-skills/skills/ui-ux-designer/SKILL.md
ios-app-skills/ios-app-skills/skills/use-case-generator/SKILL.md
ios-app-skills/ios-app-skills/skills/view-generator/SKILL.md
ios-app-skills/ios-app-skills/skills/viewmodel-generator/SKILL.md
ios-app-skills/ios-app-skills/validate-skills.sh
ios-app-skills/ios-app-skills/VERSIONS.md
=== swiftui-agent-skill (dirs) ===
swiftui-agent-skill
swiftui-agent-skill/SwiftUI-Agent-Skill-main
swiftui-agent-skill/SwiftUI-Agent-Skill-main/.agents
swiftui-agent-skill/SwiftUI-Agent-Skill-main/.agents/skills
swiftui-agent-skill/SwiftUI-Agent-Skill-main/.claude-plugin
swiftui-agent-skill/SwiftUI-Agent-Skill-main/.codex-plugin
swiftui-agent-skill/SwiftUI-Agent-Skill-main/.cursor-plugin
swiftui-agent-skill/SwiftUI-Agent-Skill-main/.github
swiftui-agent-skill/SwiftUI-Agent-Skill-main/.github/scripts
swiftui-agent-skill/SwiftUI-Agent-Skill-main/.github/workflows
swiftui-agent-skill/SwiftUI-Agent-Skill-main/agents
swiftui-agent-skill/SwiftUI-Agent-Skill-main/assets
swiftui-agent-skill/SwiftUI-Agent-Skill-main/skills
swiftui-agent-skill/SwiftUI-Agent-Skill-main/skills/swiftui-expert-skill
swiftui-agent-skill/SwiftUI-Agent-Skill-main/tests
=== swiftui md files ===
swiftui-agent-skill/SwiftUI-Agent-Skill-main/.agents/skills/update-swiftui-apis/references/scan-manifest.md
swiftui-agent-skill/SwiftUI-Agent-Skill-main/.agents/skills/update-swiftui-apis/SKILL.md
swiftui-agent-skill/SwiftUI-Agent-Skill-main/.github/copilot-instructions.md
swiftui-agent-skill/SwiftUI-Agent-Skill-main/AGENTS.md
swiftui-agent-skill/SwiftUI-Agent-Skill-main/CONTRIBUTING.md
swiftui-agent-skill/SwiftUI-Agent-Skill-main/INSTALLATION.md
swiftui-agent-skill/SwiftUI-Agent-Skill-main/README.md
swiftui-agent-skill/SwiftUI-Agent-Skill-main/skills/swiftui-expert-skill/references/accessibility-patterns.md
swiftui-agent-skill/SwiftUI-Agent-Skill-main/skills/swiftui-expert-skill/references/animation-advanced.md
swiftui-agent-skill/SwiftUI-Agent-Skill-main/skills/swiftui-expert-skill/references/animation-basics.md
swiftui-agent-skill/SwiftUI-Agent-Skill-main/skills/swiftui-expert-skill/references/animation-transitions.md
swiftui-agent-skill/SwiftUI-Agent-Skill-main/skills/swiftui-expert-skill/references/charts-accessibility.md
swiftui-agent-skill/SwiftUI-Agent-Skill-main/skills/swiftui-expert-skill/references/charts.md
swiftui-agent-skill/SwiftUI-Agent-Skill-main/skills/swiftui-expert-skill/references/focus-patterns.md
swiftui-agent-skill/SwiftUI-Agent-Skill-main/skills/swiftui-expert-skill/references/image-optimization.md
swiftui-agent-skill/SwiftUI-Agent-Skill-main/skills/swiftui-expert-skill/references/latest-apis.md
swiftui-agent-skill/SwiftUI-Agent-Skill-main/skills/swiftui-expert-skill/references/layout-best-practices.md
swiftui-agent-skill/SwiftUI-Agent-Skill-main/skills/swiftui-expert-skill/references/liquid-glass.md
swiftui-agent-skill/SwiftUI-Agent-Skill-main/skills/swiftui-expert-skill/references/list-patterns.md
swiftui-agent-skill/SwiftUI-Agent-Skill-main/skills/swiftui-expert-skill/references/localization.md
swiftui-agent-skill/SwiftUI-Agent-Skill-main/skills/swiftui-expert-skill/references/macos-scenes.md
swiftui-agent-skill/SwiftUI-Agent-Skill-main/skills/swiftui-expert-skill/references/macos-views.md
swiftui-agent-skill/SwiftUI-Agent-Skill-main/skills/swiftui-expert-skill/references/macos-window-styling.md
swiftui-agent-skill/SwiftUI-Agent-Skill-main/skills/swiftui-expert-skill/references/performance-patterns.md
swiftui-agent-skill/SwiftUI-Agent-Skill-main/skills/swiftui-expert-skill/references/previews.md
swiftui-agent-skill/SwiftUI-Agent-Skill-main/skills/swiftui-expert-skill/references/scroll-patterns.md
swiftui-agent-skill/SwiftUI-Agent-Skill-main/skills/swiftui-expert-skill/references/sheet-navigation-patterns.md
swiftui-agent-skill/SwiftUI-Agent-Skill-main/skills/swiftui-expert-skill/references/soft-deprecation.md
swiftui-agent-skill/SwiftUI-Agent-Skill-main/skills/swiftui-expert-skill/references/state-management.md
swiftui-agent-skill/SwiftUI-Agent-Skill-main/skills/swiftui-expert-skill/references/text-patterns.md
swiftui-agent-skill/SwiftUI-Agent-Skill-main/skills/swiftui-expert-skill/references/trace-analysis.md
swiftui-agent-skill/SwiftUI-Agent-Skill-main/skills/swiftui-expert-skill/references/trace-recording.md
swiftui-agent-skill/SwiftUI-Agent-Skill-main/skills/swiftui-expert-skill/references/view-structure.md
swiftui-agent-skill/SwiftUI-Agent-Skill-main/skills/swiftui-expert-skill/SKILL.md
=== counts ===
      66
Shell cwd was reset to /Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris
~~~~

#### 2026-09-10 23:34:12 +0200 (21:34:12Z) · TOOL CALL · Bash
`f88478cc` · `72d07ddf` · ligne 106 · Show sizes and README of ios-app-skills pack

~~~~bash
SP="/private/tmp/claude-501/-Volumes-Steve-Pro-BlackSSD-Dev-App-Mobile-Iris/f88478cc-d512-4210-bc11-758059278995/scratchpad/skills/ios-app-skills/ios-app-skills"; cd "$SP" && wc -c ALL-SKILLS.md README.md skills/*/SKILL.md && echo "=====README=====" && cat README.md
~~~~

#### 2026-09-10 23:34:12 +0200 (21:34:12Z) · TOOL RESULT · Bash
`f88478cc` · `f83fc1b8` · ligne 107 · Show sizes and README of ios-app-skills pack

~~~~text
  135440 ALL-SKILLS.md
   18184 README.md
    9202 skills/architecture-designer/SKILL.md
    4727 skills/business-logic-engine/SKILL.md
    5684 skills/code-deduplicator/SKILL.md
    6128 skills/coordinator-navigator/SKILL.md
    6448 skills/data-layer-generator/SKILL.md
    7026 skills/dependency-injector/SKILL.md
    6383 skills/domain-modeler/SKILL.md
    6711 skills/feature-builder/SKILL.md
    6762 skills/file-structure-organizer/SKILL.md
    9874 skills/ios-project-foundation/SKILL.md
    5885 skills/layer-auditor/SKILL.md
    6226 skills/product-conception/SKILL.md
    5262 skills/swift-coder/SKILL.md
    6902 skills/swiftui-component-library/SKILL.md
    7310 skills/test-generator/SKILL.md
    8207 skills/ui-ux-designer/SKILL.md
    5538 skills/use-case-generator/SKILL.md
    7411 skills/view-generator/SKILL.md
    7968 skills/viewmodel-generator/SKILL.md
  283278 total
=====README=====
# iOS App Skills for AI Agents

19 Claude skills to build professional iOS apps from product idea to tested, audited code. MVVM in Presentation, Clean Architecture across Domain, Data and Presentation, Coordinators for navigation, a single composition root for dependency injection, and a file registry that makes duplication structurally impossible.

Built by [ProdX0x](https://github.com/prodx0x). Modelled on the structure of [charlie947/social-media-skills](https://github.com/charlie947/social-media-skills): foundation-first, auto-start, explicit dependencies, zero duplication.

**Contributions welcome.** Open a PR or an issue.

## What are Skills?

Skills are markdown files that give AI agents specialised workflows for specific tasks. When you install these in your project, Claude recognises when you are working on an iOS task and applies the right layer rules, naming conventions, file locations and quality gates.

## How Skills Work Together

Every skill reads shared context. `ios-project-foundation` is the foundation. Every other skill checks `Docs/conventions.md` and `Docs/file-map.md` first, and writes back to `file-map.md` every time it creates a file.

```
                 ┌──────────────────────────────────────────────┐
                 │           ios-project-foundation             │
                 │  Docs/project-brief.md · conventions.md ·    │
                 │  file-map.md   (read by every skill below)   │
                 └──────────────────────┬───────────────────────┘
                                        │
          ┌─────────────────────────────┼─────────────────────────────┐
          ▼                             ▼                             ▼
┌──────────────────┐        ┌──────────────────────┐        ┌──────────────────┐
│ product-         │        │ architecture-        │        │ ui-ux-designer   │
│  conception      │───────▶│  designer            │        │ design-system.md │
│ product.md       │        │ architecture.md      │        │ Tokens/          │
│ Features/*.md    │        └──────────┬───────────┘        └────────┬─────────┘
└────────┬─────────┘                   │                             │
         │              ┌──────────────▼───────────┐                 │
         │              │ file-structure-organizer │                 │
         │              │ folders + stubs          │                 │
         │              └──────────────┬───────────┘                 │
         ▼                             ▼                             ▼
┌─────────────────────┐   ┌─────────────────────┐   ┌──────────────────────────┐
│ Domain              │   │ Data                │   │ Presentation             │
├─────────────────────┤   ├─────────────────────┤   ├──────────────────────────┤
│ domain-modeler      │──▶│ data-layer-generator│   │ swiftui-component-library│
│ business-logic-     │   │                     │   │ viewmodel-generator      │
│  engine             │   └──────────┬──────────┘   │ view-generator           │
│ use-case-generator  │              │              │ coordinator-navigator    │
└──────────┬──────────┘              │              └────────────┬─────────────┘
           │                         ▼                           │
           │              ┌─────────────────────┐                │
           └─────────────▶│ dependency-injector │◀───────────────┘
                          │ Core/DI/AppContainer│
                          └──────────┬──────────┘
                                     ▼
        ┌──────────────┬─────────────┴──────────────┬──────────────────┐
        ▼              ▼                            ▼                  ▼
┌──────────────┐ ┌──────────────┐          ┌───────────────────┐ ┌──────────────┐
│ swift-coder  │ │test-generator│          │ code-deduplicator │ │layer-auditor │
└──────────────┘ └──────────────┘          └───────────────────┘ └──────────────┘
                                     ▲
                 ┌───────────────────┴───────────────────┐
                 │            feature-builder            │
                 │  orchestrates all 13 stages, gated    │
                 └───────────────────────────────────────┘
```

See each skill's `SKILL.md` for trigger phrases, inputs, outputs and dependencies.

## Available Skills

<!-- SKILLS:START -->
| Skill | Description |
|---|---|
| [ios-project-foundation](skills/ios-project-foundation/) | Interview to `Docs/project-brief.md`, `conventions.md` and `file-map.md`. The foundation every other skill reads. |
| [product-conception](skills/product-conception/) | Personas, jobs to be done, prioritised feature table, flows, acceptance criteria. Writes `product.md` and one spec per feature. |
| [architecture-designer](skills/architecture-designer/) | Layer diagram, feature to module map, navigation topology, data flow, ADRs. Writes `architecture.md`. |
| [file-structure-organizer](skills/file-structure-organizer/) | Generates the full folder tree and compilable stubs, audits misplaced files, registers everything. |
| [domain-modeler](skills/domain-modeler/) | Entities with typed IDs, value objects, typed errors, repository protocols. Pure Swift. Writes `domain-model.md`. |
| [business-logic-engine](skills/business-logic-engine/) | Business rules as entity methods and domain services, each with a rule ID. Extracts rules buried in ViewModels. |
| [use-case-generator](skills/use-case-generator/) | One protocol plus one default implementation per user action, single `execute`. |
| [data-layer-generator](skills/data-layer-generator/) | Repository implementations, remote and local data sources, DTOs, SwiftData models, mappers, error mapping. |
| [viewmodel-generator](skills/viewmodel-generator/) | `@MainActor @Observable` ViewModels with a single Phase enum, actions, presentation models, navigation intents. |
| [view-generator](skills/view-generator/) | SwiftUI views bound to a ViewModel, tokens and DS components only, three previews minimum. |
| [coordinator-navigator](skills/coordinator-navigator/) | Route enums, feature coordinators, AppCoordinator, tabs, modals, deep links. No navigation in views. |
| [ui-ux-designer](skills/ui-ux-designer/) | Semantic tokens, component inventory, text wireframes, HIG and accessibility rules. Writes `design-system.md`. |
| [swiftui-component-library](skills/swiftui-component-library/) | Implements `DS`-prefixed components with variants, states, accessibility and previews. Promotes shared components. |
| [swift-coder](skills/swift-coder/) | Minimal targeted edits and bug fixes with a before and after plan. Reuses existing code before writing new. |
| [code-deduplicator](skills/code-deduplicator/) | Exact, near and semantic duplicates plus dead code. Factorises into the right layer. Keeps `file-map.md` truthful. |
| [dependency-injector](skills/dependency-injector/) | Single `AppContainer`, typed factories, live, preview and test environments. Audits bypasses. |
| [test-generator](skills/test-generator/) | Swift Testing unit tests citing rule and AC IDs, hand-written mocks, fixtures, XCTest UI flows. |
| [layer-auditor](skills/layer-auditor/) | 11 consistency checks between layers, docs and disk. PASS or FAIL report with a fix plan mapped to skills. |
| [feature-builder](skills/feature-builder/) | Runs all 13 stages for one feature in order, gated, resumable, closed only on audit PASS. |
<!-- SKILLS:END -->

## Installation

### Option 1: Claude Code plugin marketplace

```bash
# Add the marketplace
/plugin marketplace add prodx0x/ios-app-skills

# Install the plugin
/plugin install ios-app-skills
```

### Option 2: Clone and copy

```bash
git clone https://github.com/prodx0x/ios-app-skills.git
cp -r ios-app-skills/skills/* ~/.claude/skills/
```

### Option 3: Individual skill upload (Claude Desktop)

```bash
cd ios-app-skills/skills
zip -r ios-project-foundation.skill ios-project-foundation
# Upload ios-project-foundation.skill through Customise skills in the Claude app
```

### Option 4: Git submodule

```bash
git submodule add https://github.com/prodx0x/ios-app-skills.git .agents/ios-app-skills
```

Then reference skills from `.agents/ios-app-skills/skills/`.

### Option 5: Project-local (Claude Code)

```bash
mkdir -p .claude/skills
cp -r ios-app-skills/skills/* .claude/skills/
```

Skills then travel with the Xcode project in git.

## Usage

Run `ios-project-foundation` first. Every other skill needs `Docs/conventions.md` and `Docs/file-map.md`.

Recommended first run on a new app:

```
"set up my iOS project"        → ios-project-foundation
"define the product"           → product-conception
"design the architecture"      → architecture-designer
"design the UI"                → ui-ux-designer
"generate the file structure"  → file-structure-organizer
"wire the dependencies"        → dependency-injector (bootstrap)
"build feature Invoices"       → feature-builder (everything else, gated)
```

Trigger phrases per skill (English and French both work):

```
"set up my iOS project" / "nouveau projet iOS"                → ios-project-foundation
"define the product" / "cadre les fonctionnalités"            → product-conception
"design the architecture" / "conçois l'architecture"          → architecture-designer
"generate the file structure" / "génère l'arborescence"       → file-structure-organizer
"model the domain" / "modélise le domaine"                    → domain-modeler
"write the business rules" / "règles métier"                  → business-logic-engine
"generate the use cases" / "génère les use cases"             → use-case-generator
"generate the data layer" / "implémente le repository"        → data-layer-generator
"generate the viewmodel for X" / "génère le viewmodel"        → viewmodel-generator
"generate the view for X" / "construis l'écran"               → view-generator
"wire the navigation" / "câble la navigation"                 → coordinator-navigator
"design the UI" / "design system" / "palette"                 → ui-ux-designer
"build the component library" / "composant réutilisable"      → swiftui-component-library
"fix this bug" / "corrige ce bug" / "implémente"              → swift-coder
"dedupe" / "trouve les doublons" / "code mort"                → code-deduplicator
"wire the dependencies" / "injection de dépendances"          → dependency-injector
"generate tests" / "génère les tests"                         → test-generator
"audit the layers" / "vérifie la cohérence"                   → layer-auditor
"build feature X" / "implémente X de bout en bout"            → feature-builder
```

## Skill Categories

### Foundation
- `ios-project-foundation` — interview, conventions, file registry

### Product and architecture
- `product-conception` — personas, features, acceptance criteria
- `architecture-designer` — layers, modules, navigation, ADRs
- `file-structure-organizer` — tree, stubs, audits misplaced files

### Domain
- `domain-modeler` — entities, value objects, errors, repository protocols
- `business-logic-engine` — rules with IDs, entity methods, domain services
- `use-case-generator` — protocol plus default implementation per action

### Data
- `data-layer-generator` — repositories, data sources, DTOs, mappers

### Presentation
- `viewmodel-generator` — Phase state, actions, presentation models
- `view-generator` — SwiftUI bound to ViewModel, previews
- `coordinator-navigator` — routes, coordinators, deep links

### Design
- `ui-ux-designer` — tokens, inventory, wireframes
- `swiftui-component-library` — DS components

### Implementation and quality
- `swift-coder` — targeted edits and fixes
- `code-deduplicator` — duplicates and dead code
- `dependency-injector` — AppContainer and environments
- `test-generator` — unit, mocks, UI tests
- `layer-auditor` — consistency verdict

### Orchestration
- `feature-builder` — 13 gated stages per feature

## Shared context files

All written to `Docs/` at the project root. Never scattered.

| File | Written by | Read by |
|---|---|---|
| `project-brief.md` | ios-project-foundation | all |
| `conventions.md` | ios-project-foundation | all |
| `file-map.md` | ios-project-foundation, then every skill | all |
| `product.md`, `Features/<Name>.md` | product-conception | architecture, domain, presentation, tests, feature-builder |
| `architecture.md` | architecture-designer | file-structure, data, DI, navigation, auditor |
| `domain-model.md` | domain-modeler, business-logic-engine, use-case-generator | data, presentation, tests |
| `design-system.md` | ui-ux-designer | component library, view-generator |
| `dedup-log.md` | code-deduplicator | code-deduplicator |
| `audit-<date>.md` | layer-auditor | feature-builder |

## Reference project layout

The tree every skill targets. Defined once in `Docs/conventions.md`.

```
<AppName>/
├── App/
│   ├── <AppName>App.swift
│   └── Resources/ (Assets.xcassets, Localizable.xcstrings)
├── Core/
│   ├── DI/          AppContainer.swift, AppEnvironment.swift, Registry.swift, AppContainer+<Feature>.swift
│   ├── Navigation/  AppCoordinator.swift, AppRoute.swift, AppCoordinatorView.swift, DeepLinkParser.swift
│   ├── Networking/  HTTPClient.swift
│   ├── Extensions/  <Type>+<Concern>.swift
│   └── Utilities/
├── DesignSystem/
│   ├── Tokens/      DSColor.swift, DSFont.swift, DSSpacing.swift, DSRadius.swift, DSMotion.swift
│   ├── Components/  DSButton.swift, DSScreen.swift, DSEmptyState.swift, ...
│   └── Modifiers/
├── Domain/
│   ├── Entities/<Feature>/      <Entity>.swift, <Entity>ID.swift
│   ├── ValueObjects/            Money.swift, Email.swift, ...
│   ├── Repositories/<Feature>/  <Noun>Repository.swift
│   ├── UseCases/<Feature>/      <Verb><Noun>UseCase.swift, Default<Verb><Noun>UseCase.swift
│   ├── Services/<Feature>/      <Name>Calculator.swift, <Name>Policy.swift
│   └── Errors/                  <Noun>Error.swift
├── Data/
│   ├── Repositories/<Feature>/         <Noun>RepositoryImpl.swift
│   ├── DataSources/Remote/<Feature>/   <Noun>RemoteDataSource.swift, URLSession<Noun>RemoteDataSource.swift
│   ├── DataSources/Local/<Feature>/    <Noun>LocalDataSource.swift, SwiftData<Noun>LocalDataSource.swift, <Noun>Model.swift
│   ├── DTOs/<Feature>/                 <Noun>DTO.swift
│   └── Mappers/<Feature>/              <Noun>Mapper.swift
├── Features/
│   └── <Feature>/
│       ├── Presentation/
│       │   ├── Views/        <Screen>View.swift
│       │   ├── ViewModels/   <Screen>ViewModel.swift, <Screen>+Models.swift, <Screen>ViewModel+Preview.swift
│       │   └── Components/   feature-only subviews
│       └── Coordinator/      <Feature>Route.swift, <Feature>Modal.swift, <Feature>Navigating.swift,
│                             <Feature>Coordinator.swift, <Feature>CoordinatorView.swift
├── Tests/
│   ├── UnitTests/
│   │   ├── Domain/<Feature>/, Data/<Feature>/, Presentation/<Feature>/
│   │   ├── Mocks/      Mock<Protocol>.swift
│   │   └── Fixtures/   <Entity>+Fixture.swift
│   └── UITests/        <Flow>UITests.swift
└── Docs/
    ├── project-brief.md, conventions.md, file-map.md
    ├── product.md, architecture.md, domain-model.md, design-system.md
    ├── dedup-log.md, audit-<date>.md
    └── Features/<Feature>.md
```

## Prerequisites

No external service. Skills use the tools available in Claude Code or Cowork: file read and write, shell (`xcodebuild`, `swift build`, `git`), and AskUserQuestion. Xcode 16 or later is recommended for folder-synchronised groups so that generated folders appear in the project without manual linking.

## Contributing

PRs and issues welcome. See [CONTRIBUTING.md](CONTRIBUTING.md). Run `./validate-skills.sh` before submitting.

## License

[MIT](LICENSE).
Shell cwd was reset to /Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris
~~~~

#### 2026-09-10 23:34:22 +0200 (21:34:22Z) · TOOL CALL · Bash
`f88478cc` · `5c14c2f7` · ligne 118 · Read foundation, product, architecture and UI/UX skills

~~~~bash
SP="/private/tmp/claude-501/-Volumes-Steve-Pro-BlackSSD-Dev-App-Mobile-Iris/f88478cc-d512-4210-bc11-758059278995/scratchpad/skills/ios-app-skills/ios-app-skills/skills"; for s in ios-project-foundation product-conception architecture-designer ui-ux-designer; do echo "################ $s ################"; cat "$SP/$s/SKILL.md"; done; echo "################ conventions-template ################"; cat "$SP/ios-project-foundation/references/conventions-template.md"
~~~~

#### 2026-09-10 23:34:23 +0200 (21:34:23Z) · TOOL RESULT · Bash
`f88478cc` · `58fea6b1` · ligne 119 · Read foundation, product, architecture and UI/UX skills

~~~~text
<persisted-output>
Output too large (37.5KB). Full output saved to: /Users/prodx0x/.claude/projects/-Volumes-Steve-Pro-BlackSSD-Dev-App-Mobile-Iris/f88478cc-d512-4210-bc11-758059278995/tool-results/bu8118ifr.txt

Preview (first 2KB):
################ ios-project-foundation ################
---
name: ios-project-foundation
description: >
  Build the shared context files for an iOS project from a short interview. Produces project-brief.md, conventions.md and file-map.md inside Docs/. This is the foundation every other iOS skill reads before writing a single line of Swift. Use this skill at the start of any new iOS or SwiftUI project, or when onboarding Claude onto an existing Xcode project. Trigger whenever the user says "set up my iOS project", "init the project context", "onboard me on this app", "start a new iOS app", "create the project foundation", "nouveau projet iOS", "initialise le projet", "pose les fondations", "configure les conventions", or opens a project folder that has no Docs/project-brief.md. Always produces three files saved into Docs/ at the project root.
---

# iOS Project Foundation

## CRITICAL: Auto-start on load

The moment this skill is loaded, installed, uploaded, or triggered, you MUST immediately run Step 1 below. Your very next message to the user is the interview. Nothing else.

Do NOT:
- Summarise this skill
- Describe what files it creates
- Explain how it works
- Ask if the user wants to run it
- Confirm installation

Do THIS:
- Go straight to Step 1
- Send the interview as your first and only response

## Step 1. Detect existing project

Before asking anything, scan the working directory:

1. Look for `*.xcodeproj`, `*.xcworkspace` or `Package.swift`. Note the project name.
2. Look for `Docs/project-brief.md`, `Docs/conventions.md`, `Docs/file-map.md`.
3. If all three exist, read them and say:

> Foundation already exists. Tell me what to update (brief, conventions or file map), or say "rebuild" to start over.

Then stop and wait.

4. If a Swift project exists but no Docs/ files, note every top-level folder and count `.swift` files. You will need this in Step 4. Then continue to Step 2.
5. If nothing exists, continue to Step 2.

...
</persisted-output>
~~~~

#### 2026-09-10 23:34:26 +0200 (21:34:26Z) · TOOL CALL · Read
`f88478cc` · `57f7d0ec` · ligne 129

~~~~json
{
 "file_path": "/Users/prodx0x/.claude/projects/-Volumes-Steve-Pro-BlackSSD-Dev-App-Mobile-Iris/f88478cc-d512-4210-bc11-758059278995/tool-results/bu8118ifr.txt"
}
~~~~

#### 2026-09-10 23:34:26 +0200 (21:34:26Z) · TOOL RESULT · Read
`f88478cc` · `95adc996` · ligne 130

~~~~text
1	################ ios-project-foundation ################
2	---
3	name: ios-project-foundation
4	description: >
5	  Build the shared context files for an iOS project from a short interview. Produces project-brief.md, conventions.md and file-map.md inside Docs/. This is the foundation every other iOS skill reads before writing a single line of Swift. Use this skill at the start of any new iOS or SwiftUI project, or when onboarding Claude onto an existing Xcode project. Trigger whenever the user says "set up my iOS project", "init the project context", "onboard me on this app", "start a new iOS app", "create the project foundation", "nouveau projet iOS", "initialise le projet", "pose les fondations", "configure les conventions", or opens a project folder that has no Docs/project-brief.md. Always produces three files saved into Docs/ at the project root.
6	---
7	
8	# iOS Project Foundation
9	
10	## CRITICAL: Auto-start on load
11	
12	The moment this skill is loaded, installed, uploaded, or triggered, you MUST immediately run Step 1 below. Your very next message to the user is the interview. Nothing else.
13	
14	Do NOT:
15	- Summarise this skill
16	- Describe what files it creates
17	- Explain how it works
18	- Ask if the user wants to run it
19	- Confirm installation
20	
21	Do THIS:
22	- Go straight to Step 1
23	- Send the interview as your first and only response
24	
25	## Step 1. Detect existing project
26	
27	Before asking anything, scan the working directory:
28	
29	1. Look for `*.xcodeproj`, `*.xcworkspace` or `Package.swift`. Note the project name.
30	2. Look for `Docs/project-brief.md`, `Docs/conventions.md`, `Docs/file-map.md`.
31	3. If all three exist, read them and say:
32	
33	> Foundation already exists. Tell me what to update (brief, conventions or file map), or say "rebuild" to start over.
34	
35	Then stop and wait.
36	
37	4. If a Swift project exists but no Docs/ files, note every top-level folder and count `.swift` files. You will need this in Step 4. Then continue to Step 2.
38	5. If nothing exists, continue to Step 2.
39	
40	## Step 2. Run the project interview
41	
42	You MUST call the AskUserQuestion tool. Do not type the questions as chat text. AskUserQuestion supports a maximum of 4 questions per call, so send two calls: Batch 1 first, wait for answers, then Batch 2.
43	
44	### Batch 1 (your very first action, no text before it)
45	
46	```json
47	[
48	  {
49	    "question": "What is the app and what does it do in one sentence?",
50	    "header": "App",
51	    "multiSelect": false,
52	    "options": [
53	      {"label": "Utility", "description": "Solves one clear task (converter, tracker, calculator)"},
54	      {"label": "Content", "description": "Reads, browses or consumes content (feed, reader, catalogue)"},
55	      {"label": "Social or community", "description": "Users interact with each other"},
56	      {"label": "Business tool", "description": "Internal or professional workflow"}
57	    ]
58	  },
59	  {
60	    "question": "Minimum iOS version and Swift toolchain?",
61	    "header": "Targets",
62	    "multiSelect": false,
63	    "options": [
64	      {"label": "iOS 17+, Swift 6", "description": "Observation framework, strict concurrency. Recommended."},
65	      {"label": "iOS 16+, Swift 5.10", "description": "NavigationStack available, ObservableObject required"},
66	      {"label": "iOS 18+, Swift 6", "description": "Latest APIs only"}
67	    ]
68	  },
69	  {
70	    "question": "Where does the data live?",
71	    "header": "Data",
72	    "multiSelect": true,
73	    "options": [
74	      {"label": "Local only", "description": "SwiftData or file storage, no server"},
75	      {"label": "CloudKit", "description": "Apple sync, no custom backend"},
76	      {"label": "REST or GraphQL API", "description": "Custom backend over HTTPS"},
77	      {"label": "Firebase or Supabase", "description": "Third-party BaaS"}
78	    ]
79	  },
80	  {
81	    "question": "Third-party dependencies policy?",
82	    "header": "Dependencies",
83	    "multiSelect": false,
84	    "options": [
85	      {"label": "Zero third-party", "description": "Apple frameworks only. Recommended for App Store review speed."},
86	      {"label": "SPM allowed, minimal", "description": "One or two vetted packages maximum"},
87	      {"label": "SPM allowed, pragmatic", "description": "Whatever ships faster"}
88	    ]
89	  }
90	]
91	```
92	
93	### Batch 2 (send immediately after Batch 1 answers, no commentary between)
94	
95	```json
96	[
97	  {
98	    "question": "Who is the user and what is their main frustration today?",
99	    "header": "User",
100	    "multiSelect": false,
101	    "options": [
102	      {"label": "Consumer", "description": "General public, App Store discovery"},
103	      {"label": "Prosumer", "description": "Power users who pay for quality"},
104	      {"label": "Internal team", "description": "Enterprise or TestFlight distribution"}
105	    ]
106	  },
107	  {
108	    "question": "Monetisation?",
109	    "header": "Business",
110	    "multiSelect": false,
111	    "options": [
112	      {"label": "Free", "description": "No payment logic"},
113	      {"label": "One-time purchase", "description": "Paid upfront or single IAP"},
114	      {"label": "Subscription", "description": "StoreKit 2 subscription tiers"},
115	      {"label": "Undecided", "description": "Design the architecture to allow it later"}
116	    ]
117	  },
118	  {
119	    "question": "Code style preferences?",
120	    "header": "Style",
121	    "multiSelect": true,
122	    "options": [
123	      {"label": "Strict access control", "description": "Everything private unless proven otherwise"},
124	      {"label": "Protocol-first", "description": "Every dependency behind a protocol"},
125	      {"label": "Async/await only", "description": "No Combine, no completion handlers"},
126	      {"label": "Localisation from day one", "description": "String Catalog, no hardcoded copy"}
127	    ]
128	  }
129	]
130	```
131	
132	After both batches, ask in chat for the app name and bundle identifier if not already detected from an existing `.xcodeproj`. Then move to Step 3.
133	
134	## Step 3. Write Docs/project-brief.md
135	
136	Create `Docs/project-brief.md`. Use this exact structure:
137	
138	```
139	# Project Brief
140	
141	## App
142	[Name, one-sentence purpose, category from question 1]
143	
144	## Bundle
145	[Bundle identifier, minimum iOS version, Swift version, Xcode version]
146	
147	## User
148	[2 to 3 sentences on who uses this and the frustration it removes]
149	
150	## Core promise
151	[One sentence: what the user gets that they cannot get elsewhere]
152	
153	## Data
154	[Where data lives, sync strategy, offline expectations]
155	
156	## Business model
157	[From question 6, plus what it implies for architecture: StoreKit, entitlements, feature gating]
158	
159	## Dependency policy
160	[From question 4, with the allowed list if any]
161	
162	## Non-goals
163	[3 things this app will NOT do in version 1]
164	```
165	
166	Keep it under 300 words. Every line must be something a later skill would reference when making a decision.
167	
168	## Step 4. Write Docs/conventions.md
169	
170	Create `Docs/conventions.md`. This is the single source of truth for naming, layering and style. Every other skill reads it before generating code.
171	
172	Load `references/conventions-template.md` from this skill folder. Fill every placeholder from the interview answers. Do not leave any `[...]` placeholder in the output. The template already encodes the non-negotiable architecture:
173	
174	- MVVM for presentation
175	- Clean Architecture in three layers: Domain, Data, Presentation
176	- Coordinators for navigation
177	- Constructor injection through a single `AppContainer`
178	- One type per file, file name equals type name
179	
180	If the user chose iOS 16, replace `@Observable` with `ObservableObject` and `@Published` throughout the template and note it in the Observation section.
181	
182	Keep conventions.md under 600 words. Rules, not prose.
183	
184	## Step 5. Write Docs/file-map.md
185	
186	Create `Docs/file-map.md`. This is the anti-duplication registry. Every skill that creates a file MUST append a row here. Every skill that is about to create a file MUST search this table first.
187	
188	```
189	# File Map
190	
191	Registry of every source file in the project. One row per file. Updated by every skill that creates or deletes a file. Search this table before creating anything.
192	
193	| Path | Type | Layer | Purpose | Created by |
194	|---|---|---|---|---|
195	```
196	
197	If an existing project was detected in Step 1, walk every `.swift` file and add one row per file. Infer Layer from the folder (Domain, Data, Presentation, Core, DesignSystem, App, Tests, Unknown). Infer Purpose from the primary type declaration. Set Created by to `existing`. Flag any file that contains more than one top-level type with `[multi-type]` in the Purpose column.
198	
199	## Step 6. Confirm and hand off
200	
201	Tell the user:
202	
203	> Foundation is in place. Three files are now in Docs/: project-brief.md, conventions.md and file-map.md. Every iOS skill reads these before doing anything. Edit them anytime.
204	>
205	> Next steps, in order:
206	>
207	> - Say "define the product" to run product-conception and write the feature list
208	> - Say "design the architecture" to run architecture-designer
209	> - Say "build feature [name]" to run feature-builder end to end
210	>
211	> Each of these is a separate skill. Pick one and go.
212	
213	## What this skill produces
214	
215	Three files in `Docs/` at the project root:
216	
217	1. `project-brief.md`: what the app is, for whom, data strategy, business model, dependency policy
218	2. `conventions.md`: naming, layering, file rules, style rules, the contract every other skill obeys
219	3. `file-map.md`: the registry of every source file, the anti-duplication mechanism
220	
221	## Dependencies
222	
223	- None. This is the foundation skill.
224	- `references/conventions-template.md` in this skill folder.
225	
226	## Rules
227	
228	- When this skill triggers, go straight to Step 1. No summary, no preamble.
229	- Always detect an existing project before interviewing. Never overwrite existing Docs/ files without the user saying "rebuild".
230	- Always put the three files in `Docs/`. Never in the project root, never in the Xcode group, never scattered.
231	- Never leave a placeholder in conventions.md.
232	- Never invent a bundle identifier. Ask.
233	- Keep project-brief.md under 300 words and conventions.md under 600 words.
234	- Never use em dashes in any output file.
235	- British English in skill files. Code identifiers and comments in English. User-facing copy in the language the user writes in.
236	################ product-conception ################
237	---
238	name: product-conception
239	description: >
240	  Turn an app idea into a scoped product definition: user personas, jobs to be done, feature list with priorities, user flows and acceptance criteria. Produces Docs/product.md and one Docs/Features/<name>.md stub per feature. Use this skill whenever the user says "define the product", "scope the app", "what features should this have", "write the product spec", "list the features", "MVP scope", "définis le produit", "cadre les fonctionnalités", "spec produit", "quelles fonctionnalités", or describes an app idea and wants it structured before any architecture or code. Requires ios-project-foundation to have run first.
241	---
242	
243	# Product Conception
244	
245	## Prerequisites check
246	
247	The moment this skill triggers, check for `Docs/project-brief.md` and `Docs/conventions.md`.
248	
249	If either is missing, tell the user:
250	
251	> Product conception builds on the project foundation. Say "set up my iOS project" to run ios-project-foundation first, then come back here.
252	
253	Then stop.
254	
255	If both exist, read them fully, then check for `Docs/product.md`. If it exists, read it and go to Step 5 (update mode). Otherwise go straight to Step 1.
256	
257	## Step 1. Gather the idea
258	
259	Call AskUserQuestion:
260	
261	```json
262	[
263	  {
264	    "question": "How much of the product is already decided?",
265	    "header": "Maturity",
266	    "multiSelect": false,
267	    "options": [
268	      {"label": "Just an idea", "description": "One sentence, help me shape it"},
269	      {"label": "Rough feature list", "description": "I will paste bullet points"},
270	      {"label": "Detailed spec", "description": "I will paste a document or notes"},
271	      {"label": "Existing app", "description": "Reverse-engineer from the codebase"}
272	    ]
273	  },
274	  {
275	    "question": "Scope target for version 1?",
276	    "header": "Scope",
277	    "multiSelect": false,
278	    "options": [
279	      {"label": "Tiny MVP", "description": "3 to 5 features, ship in weeks"},
280	      {"label": "Solid v1", "description": "6 to 10 features"},
281	      {"label": "Full product", "description": "Everything, phased"}
282	    ]
283	  }
284	]
285	```
286	
287	Wait for the paste if applicable. If "Existing app", walk `Features/` and `Domain/UseCases/` and infer the feature list from folder names and use case names.
288	
289	## Step 2. Define personas and jobs
290	
291	From the brief and the idea, write:
292	
293	- 1 to 3 personas. Name, one-line context, primary frustration, success moment.
294	- For each persona, 2 to 4 jobs to be done in the format: "When [situation], I want to [motivation], so I can [outcome]."
295	
296	Present them in chat. Call AskUserQuestion to confirm which persona is primary. Do not proceed without confirmation.
297	
298	## Step 3. Build the feature list
299	
300	Derive features from the jobs. For each feature produce:
301	
302	| Field | Rule |
303	|---|---|
304	| Name | PascalCase noun, becomes the folder name under `Features/` |
305	| Job served | Which JTBD it fulfils |
306	| Priority | P0 (v1 blocker), P1 (v1 nice), P2 (later) |
307	| Screens | List of screens, each one future View |
308	| Data touched | Entities read or written |
309	| Depends on | Other features that must exist first |
310	
311	Respect the scope from Step 1. Tiny MVP means P0 only, maximum 5 features. Present the table. Call AskUserQuestion:
312	
313	```json
314	[
315	  {
316	    "question": "Feature list looks right?",
317	    "header": "Confirm",
318	    "multiSelect": false,
319	    "options": [
320	      {"label": "Approve", "description": "Write the files"},
321	      {"label": "Cut features", "description": "I will tell you which to remove"},
322	      {"label": "Add features", "description": "I will tell you what is missing"}
323	    ]
324	  }
325	]
326	```
327	
328	Iterate until approved. Maximum 3 rounds.
329	
330	## Step 4. Write the files
331	
332	### Docs/product.md
333	
334	```
335	# Product
336	
337	## Personas
338	[Name: context. Frustration. Success moment.] x1 to 3. Mark the primary one.
339	
340	## Jobs to be done
341	[Grouped by persona, "When... I want... so I can..." format]
342	
343	## Feature list
344	[The approved table from Step 3, sorted by priority then dependency order]
345	
346	## User flows
347	[For each P0 feature: numbered steps from entry point to success state. Max 8 steps each.]
348	
349	## Out of scope for v1
350	[Explicit list. Include anything the user mentioned and then cut.]
351	
352	## Open questions
353	[Anything unresolved that architecture-designer must decide]
354	```
355	
356	### Docs/Features/<Name>.md, one per feature
357	
358	```
359	# Feature: <Name>
360	
361	Status: specified
362	Priority: <P0|P1|P2>
363	Depends on: <feature names or none>
364	
365	## Job
366	[The JTBD this serves, one line]
367	
368	## Screens
369	[One line per screen: ScreenName. What the user sees. What they can do.]
370	
371	## Acceptance criteria
372	[Given / When / Then, 3 to 6 criteria]
373	
374	## Entities
375	[Entities this feature reads or writes. Names only. domain-modeler owns the definitions.]
376	
377	## Notes
378	[Edge cases, platform constraints, anything the implementer must know]
379	```
380	
381	Register every created file in `Docs/file-map.md` with Layer `Docs`.
382	
383	## Step 5. Update mode
384	
385	If `Docs/product.md` already existed, ask what changed (new feature, cut feature, priority change, new persona). Apply the change to `product.md` and to the affected `Docs/Features/<Name>.md`. Never regenerate untouched features. Bump the Status line of a changed feature to `respecified`.
386	
387	## Step 6. Hand off
388	
389	Tell the user:
390	
391	> Product is defined. Docs/product.md and one spec per feature in Docs/Features/ are written.
392	>
393	> Next: say "design the architecture" to run architecture-designer. It reads the feature list and decides modules, data flow and technical choices.
394	
395	## What this skill produces
396	
397	1. `Docs/product.md`: personas, jobs, feature table, flows, scope boundaries
398	2. `Docs/Features/<Name>.md`: one spec stub per feature, consumed by every downstream skill
399	
400	## Dependencies
401	
402	- Requires: `Docs/project-brief.md`, `Docs/conventions.md` (ios-project-foundation)
403	- Feeds: architecture-designer, domain-modeler, feature-builder
404	
405	## Rules
406	
407	- Always read project-brief.md before proposing anything. Respect the non-goals listed there.
408	- Always confirm the primary persona and the feature list before writing files.
409	- Never write a feature without at least 3 acceptance criteria.
410	- Never define entity fields here. Names only. domain-modeler owns the shapes.
411	- Never exceed the scope chosen in Step 1.
412	- Feature names are PascalCase and become folder names. No spaces, no accents.
413	- Never use em dashes in any output file.
414	################ architecture-designer ################
415	---
416	name: architecture-designer
417	description: >
418	  Design the technical architecture of the iOS app: layer boundaries, module map, data flow, navigation topology, dependency graph and every technical decision recorded as an ADR. Produces Docs/architecture.md with text diagrams. Use this skill whenever the user says "design the architecture", "how should I structure this app", "architecture decisions", "which pattern for", "MVVM setup", "clean architecture for this app", "conçois l'architecture", "structure de l'app", "décisions techniques", "quel pattern", or before any code is written on a new project. Requires ios-project-foundation. Reads Docs/product.md if present.
419	---
420	
421	# Architecture Designer
422	
423	## Prerequisites check
424	
425	Check for `Docs/project-brief.md` and `Docs/conventions.md`. If missing, say:
426	
427	> Architecture needs the foundation. Say "set up my iOS project" first.
428	
429	Then stop.
430	
431	If present, read both. Read `Docs/product.md` and every `Docs/Features/*.md` if they exist. If `Docs/architecture.md` already exists, read it and go to Step 6 (amend mode). Otherwise go straight to Step 1.
432	
433	## Step 1. Gather constraints
434	
435	Call AskUserQuestion:
436	
437	```json
438	[
439	  {
440	    "question": "Modularisation level?",
441	    "header": "Modules",
442	    "multiSelect": false,
443	    "options": [
444	      {"label": "Single target, folder layers", "description": "One app target, layers enforced by folders and conventions. Fastest to iterate."},
445	      {"label": "SPM local packages per layer", "description": "Domain, Data, DesignSystem as local packages. Compiler-enforced boundaries."},
446	      {"label": "SPM packages per feature", "description": "Each feature its own package. For teams of 3+."}
447	    ]
448	  },
449	  {
450	    "question": "Persistence engine?",
451	    "header": "Storage",
452	    "multiSelect": false,
453	    "options": [
454	      {"label": "SwiftData", "description": "iOS 17+, @Model, CloudKit ready"},
455	      {"label": "Core Data", "description": "Broad compatibility"},
456	      {"label": "Files or UserDefaults", "description": "Small state only"},
457	      {"label": "None", "description": "Stateless or remote only"}
458	    ]
459	  },
460	  {
461	    "question": "Navigation complexity?",
462	    "header": "Navigation",
463	    "multiSelect": false,
464	    "options": [
465	      {"label": "Single stack", "description": "One NavigationStack, linear flows"},
466	      {"label": "Tabs with stacks", "description": "TabView, one stack per tab"},
467	      {"label": "Deep links and modals", "description": "Tabs, sheets, full screen covers, URL routing"}
468	    ]
469	  }
470	]
471	```
472	
473	If `product.md` is missing, also ask the user to list the 3 to 5 main features in chat.
474	
475	## Step 2. Draw the layer diagram
476	
477	Produce the layer diagram in a plain code block. Adapt names to this project. The arrows are the only allowed dependencies.
478	
479	```
480	┌─────────────────────────────────────────────────────────────┐
481	│  App                                                        │
482	│  <AppName>App.swift  ·  AppContainer (composition root)     │
483	└───────────────────────────┬─────────────────────────────────┘
484	                            │ builds
485	┌───────────────────────────▼─────────────────────────────────┐
486	│  Presentation (MVVM)                                        │
487	│  Features/<Name>/  Views → ViewModels → Coordinators        │
488	│  DesignSystem/     Tokens, Components, Modifiers            │
489	└───────────────────────────┬─────────────────────────────────┘
490	                            │ depends on
491	┌───────────────────────────▼─────────────────────────────────┐
492	│  Domain (pure Swift)                                        │
493	│  Entities · ValueObjects · UseCases · Repository protocols  │
494	└───────────────────────────▲─────────────────────────────────┘
495	                            │ implements
496	┌───────────────────────────┴─────────────────────────────────┐
497	│  Data                                                       │
498	│  RepositoryImpl · Remote/Local DataSources · DTOs · Mappers │
499	└─────────────────────────────────────────────────────────────┘
500	```
501	
502	## Step 3. Map features to modules
503	
504	For every feature in `product.md`, produce one block:
505	
506	```
507	Feature: <Name>
508	  Screens:        <ViewA>, <ViewB>
509	  ViewModels:     <ViewA>ViewModel, <ViewB>ViewModel
510	  Coordinator:    <Name>Coordinator, routes: [.list, .detail(id), .create]
511	  Use cases:      Fetch<Noun>sUseCase, Create<Noun>UseCase
512	  Repositories:   <Noun>Repository (protocol) ← <Noun>RepositoryImpl
513	  Data sources:   <Noun>RemoteDataSource, <Noun>LocalDataSource
514	  Entities:       <Noun>
515	  Cross-feature:  reads <OtherNoun> via <OtherNoun>Repository (never via another feature's ViewModel)
516	```
517	
518	Detect shared entities: any entity used by two or more features is flagged `[shared]` and must be owned by exactly one feature folder in Domain. Record the owner.
519	
520	## Step 4. Draw the navigation and data flow
521	
522	**Navigation topology** as a text tree:
523	
524	```
525	AppCoordinator
526	├── Tab: <TabName> → <Feature>Coordinator
527	│   ├── <ListView>
528	│   └── <DetailView>(id)
529	├── Tab: ...
530	└── Modal: <OnboardingCoordinator> (presented once)
531	```
532	
533	**One data flow** end to end, for the most important P0 feature:
534	
535	```
536	User tap
537	 → <View>.onTapGesture calls viewModel.load()
538	 → <ViewModel>.load() calls fetchUseCase.execute()
539	 → Default<Fetch>UseCase calls repository.fetchAll()
540	 → <RepositoryImpl> calls remoteDataSource.fetch() then localDataSource.save()
541	 → <Mapper>.toDomain(dto) returns [<Entity>]
542	 → ViewModel sets state = .loaded(items)
543	 → View re-renders
544	```
545	
546	## Step 5. Record decisions and write Docs/architecture.md
547	
548	Every choice is an ADR. Minimum set: modularisation, persistence, networking, navigation, DI, concurrency, error handling, localisation, testing strategy. Format:
549	
550	```
551	### ADR-<n>: <Title>
552	Status: accepted
553	Context: [one or two sentences]
554	Decision: [one sentence]
555	Consequences: [what this forces, what it forbids]
556	```
557	
558	Write `Docs/architecture.md`:
559	
560	```
561	# Architecture
562	
563	## Overview
564	[3 sentences: pattern, layers, modularisation level]
565	
566	## Layer diagram
567	[Step 2 block]
568	
569	## Feature map
570	[Step 3 blocks]
571	
572	## Navigation topology
573	[Step 4 tree]
574	
575	## Reference data flow
576	[Step 4 flow]
577	
578	## Dependency graph
579	[Text list: which concrete type is injected where. AppContainer builds X with Y and Z.]
580	
581	## Decisions
582	[All ADRs]
583	
584	## Forbidden
585	[Explicit list: Views importing Data, Domain importing SwiftUI, ViewModels calling other ViewModels, singletons outside AppContainer, and anything project-specific]
586	```
587	
588	Register the file in `Docs/file-map.md`. Update the Architecture section of `Docs/conventions.md` only if a decision changed something there (for example ObservableObject mode). Never rewrite conventions.md wholesale.
589	
590	## Step 6. Amend mode
591	
592	If `architecture.md` existed, ask what changed. Add a new ADR with Status `accepted` and mark the superseded ADR as `superseded by ADR-<n>`. Never delete an ADR. Update only the affected diagram sections.
593	
594	## Step 7. Hand off
595	
596	Tell the user:
597	
598	> Architecture is written in Docs/architecture.md with [n] decisions recorded.
599	>
600	> Next: say "generate the file structure" to run file-structure-organizer, which turns this into real folders and stub files. Or say "build feature [name]" to run feature-builder.
601	
602	## What this skill produces
603	
604	1. `Docs/architecture.md`: diagrams, feature map, navigation, data flow, ADRs, forbidden list
605	
606	## Dependencies
607	
608	- Requires: `Docs/project-brief.md`, `Docs/conventions.md`
609	- Reads if present: `Docs/product.md`, `Docs/Features/*.md`
610	- Feeds: file-structure-organizer, domain-modeler, coordinator-navigator, dependency-injector
611	
612	## Rules
613	
614	- Always produce diagrams in plain code blocks. Never as images.
615	- Always record every choice as an ADR. A decision not written down does not exist.
616	- Never introduce a fourth layer. Domain, Data, Presentation, plus App and Core as infrastructure.
617	- Never let a feature depend on another feature's Presentation. Cross-feature access goes through Domain.
618	- Never contradict conventions.md. If a decision requires changing it, say so explicitly and edit only that section.
619	- Never propose a third-party package if the dependency policy in project-brief.md is "zero".
620	- Never use em dashes in any output file.
621	################ ui-ux-designer ################
622	---
623	name: ui-ux-designer
624	description: >
625	  Design the visual and interaction system of the app: design tokens (colour, typography, spacing, radius, motion), component inventory, screen wireframes as text, and interaction rules following Apple Human Interface Guidelines. Produces Docs/design-system.md and DesignSystem/Tokens/ files. Use this skill whenever the user says "design the UI", "design system", "tokens", "colour palette", "typography", "wireframe", "how should this screen look", "UX for", "conçois l'interface", "design system", "palette", "typographie", "maquette", "à quoi doit ressembler", or before view-generator runs for the first time. Requires ios-project-foundation. Reads Docs/product.md.
626	---
627	
628	# UI/UX Designer
629	
630	## Prerequisites check
631	
632	Check for `Docs/project-brief.md` and `Docs/conventions.md`. If missing, say:
633	
634	> The design system follows the product brief. Run ios-project-foundation first.
635	
636	Then stop. If present, read both plus `Docs/product.md`, `Docs/Features/*.md` and `Docs/design-system.md` if present. If `design-system.md` exists, go to Step 6 (extend mode). Otherwise go straight to Step 1.
637	
638	## Step 1. Gather direction
639	
640	Call AskUserQuestion:
641	
642	```json
643	[
644	  {
645	    "question": "Visual direction?",
646	    "header": "Direction",
647	    "multiSelect": false,
648	    "options": [
649	      {"label": "Native Apple", "description": "System colours, SF fonts, standard controls. Fastest, always HIG compliant."},
650	      {"label": "Native with brand accent", "description": "System base, one brand colour, custom components where it matters"},
651	      {"label": "Custom branded", "description": "Full palette, custom type scale, bespoke components"}
652	    ]
653	  },
654	  {
655	    "question": "Brand inputs?",
656	    "header": "Brand",
657	    "multiSelect": false,
658	    "options": [
659	      {"label": "I have hex codes and fonts", "description": "I will paste them"},
660	      {"label": "I have a reference app or screenshots", "description": "I will describe or paste"},
661	      {"label": "Propose for me", "description": "Derive from the product brief"}
662	    ]
663	  },
664	  {
665	    "question": "Appearance support?",
666	    "header": "Appearance",
667	    "multiSelect": true,
668	    "options": [
669	      {"label": "Light and dark", "description": "Both, semantic colours required"},
670	      {"label": "Dynamic Type", "description": "Full range including accessibility sizes"},
671	      {"label": "Reduce Motion", "description": "Every animation has a reduced variant"},
672	      {"label": "iPad layouts", "description": "Size class aware"}
673	    ]
674	  }
675	]
676	```
677	
678	Wait for pasted inputs if applicable.
679	
680	## Step 2. Define tokens
681	
682	Present the token set in chat. Every token is semantic, never named after its value.
683	
684	```
685	Colour (light / dark)
686	  ds.background.primary      #FFFFFF / #000000
687	  ds.background.secondary    #F2F2F7 / #1C1C1E
688	  ds.text.primary            #000000 / #FFFFFF
689	  ds.text.secondary          #3C3C43 99% / #EBEBF5 60%
690	  ds.accent                  <brand> / <brand adjusted>
691	  ds.status.success / warning / danger / info
692	
693	Typography (Dynamic Type mapped)
694	  ds.font.largeTitle   → .largeTitle, bold
695	  ds.font.title        → .title2, semibold
696	  ds.font.body         → .body
697	  ds.font.caption      → .caption
698	
699	Spacing (4pt grid)
700	  ds.space.xs 4 · s 8 · m 16 · l 24 · xl 32 · xxl 48
701	
702	Radius
703	  ds.radius.s 6 · m 12 · l 20 · pill 999
704	
705	Motion
706	  ds.motion.fast 0.15s · standard 0.25s · slow 0.4s, easeInOut
707	  Reduce Motion: cross-fade only
708	```
709	
710	Call AskUserQuestion to approve. Maximum 3 rounds.
711	
712	## Step 3. Component inventory
713	
714	From the screens in `Docs/Features/*.md`, list every reusable component the app needs. Prefix `DS`. For each: name, purpose, variants, states, which screens use it.
715	
716	```
717	| Component | Purpose | Variants | States | Used by |
718	|---|---|---|---|---|
719	| DSScreen | Page container, title, background, safe areas | plain, grouped | none | every screen |
720	| DSButton | Primary action | primary, secondary, destructive, ghost | enabled, disabled, loading | Form, Detail |
721	| DSEmptyState | No content placeholder | with action, without | none | List screens |
722	| DSErrorState | Failure with retry | inline, fullscreen | none | every loading screen |
723	| DSLoadingView | Progress placeholder | inline, fullscreen | none | every loading screen |
724	| DSCard | Grouped content block | elevated, flat | none | Dashboard, Detail |
725	| DSTextField | Text input with validation | default, secure, multiline | idle, focused, error | Form |
726	| DSBadge | Status label | success, warning, danger, neutral | none | Rows |
727	```
728	
729	A component earns a row only if two or more screens use it, or if it encodes a rule (validation display, loading). Feature-only components stay in the feature folder and are not listed here.
730	
731	## Step 4. Wireframes
732	
733	For each P0 screen, a text wireframe:
734	
735	```
736	┌─────────────────────────────┐
737	│ ‹ Back        Invoices   [+]│  DSScreen title, toolbar
738	├─────────────────────────────┤
739	│ 🔍 Search                   │  .searchable
740	├─────────────────────────────┤
741	│ ▢ Acme Corp      €1,200  ● │  InvoiceRow: title, amount, DSBadge
742	│ ▢ Globex         €340    ● │
743	│ ...                         │
744	├─────────────────────────────┤
745	│ (empty) DSEmptyState        │  when no invoices
746	└─────────────────────────────┘
747	```
748	
749	Plus interaction notes per screen: tap targets, swipe actions, haptics, transitions, empty and error behaviour.
750	
751	## Step 5. Write the files
752	
753	`Docs/design-system.md`:
754	
755	```
756	# Design System
757	
758	## Direction
759	[From Step 1, 2 sentences]
760	
761	## Tokens
762	[Step 2 block, final]
763	
764	## Components
765	[Step 3 table]
766	
767	## Wireframes
768	[Step 4, one per P0 screen]
769	
770	## Interaction rules
771	[Haptics policy, animation policy, loading policy, error display policy, empty state policy]
772	
773	## Accessibility
774	[Dynamic Type range, VoiceOver labelling rule, contrast minimum 4.5:1, Reduce Motion behaviour, minimum tap target 44pt]
775	
776	## HIG references
777	[Which HIG patterns each screen type follows]
778	```
779	
780	Token files, one per category, under `DesignSystem/Tokens/`:
781	
782	```swift
783	// DSColor.swift
784	// Layer: DesignSystem
785	// Purpose: Semantic colour tokens, light and dark
786	
787	import SwiftUI
788	
789	enum DSColor {
790	    static let backgroundPrimary = Color("ds.background.primary", bundle: .main)
791	    static let textPrimary = Color("ds.text.primary", bundle: .main)
792	    static let accent = Color("ds.accent", bundle: .main)
793	}
794	```
795	
796	Colour values go into `App/Resources/Assets.xcassets` as colour sets with light and dark appearances. Never hex literals in Swift. `DSFont`, `DSSpacing`, `DSRadius`, `DSMotion` follow the same pattern with static constants.
797	
798	Register every file in `Docs/file-map.md`.
799	
800	## Step 6. Extend mode
801	
802	If `design-system.md` exists, ask what to add: a token, a component row, a wireframe. Add only that. Never rename an existing token. If a token must change value, change it in the asset catalogue and note the date in the doc.
803	
804	## Step 7. Hand off
805	
806	Tell the user:
807	
808	> Design system is written: [n] tokens, [n] components inventoried, [n] wireframes. Say "build the component library" to run swiftui-component-library and implement the DS components.
809	
810	## What this skill produces
811	
812	1. `Docs/design-system.md`
813	2. `DesignSystem/Tokens/DSColor.swift`, `DSFont.swift`, `DSSpacing.swift`, `DSRadius.swift`, `DSMotion.swift`
814	3. Colour sets in the asset catalogue
815	
816	## Dependencies
817	
818	- Requires: `Docs/project-brief.md`, `Docs/conventions.md`
819	- Reads if present: `Docs/product.md`, `Docs/Features/*.md`
820	- Feeds: swiftui-component-library, view-generator
821	
822	## Rules
823	
824	- Always name tokens semantically. Never `blue500`, always `accent` or `status.info`.
825	- Always provide light and dark values for every colour.
826	- Always map typography to Dynamic Type styles. Never fixed point sizes as the primary scale.
827	- Never put hex literals in Swift files.
828	- Never inventory a component used by only one screen.
829	- Every interactive element meets 44pt and 4.5:1 contrast.
830	- Never use em dashes in any output file.
831	################ conventions-template ################
832	# Conventions
833	
834	Single source of truth for this project. Every skill reads this file before generating code. If code disagrees with this file, the code is wrong.
835	
836	## Targets
837	- Minimum iOS: [version]
838	- Swift: [version], strict concurrency: [complete | minimal]
839	- Xcode: [version]
840	- Observation: [@Observable | ObservableObject]
841	
842	## Architecture
843	- Pattern: MVVM in the Presentation layer, Clean Architecture across three layers.
844	- Layers and the only allowed dependency direction:
845	  - Presentation depends on Domain
846	  - Data depends on Domain
847	  - Domain depends on nothing (no UIKit, no SwiftUI, no Foundation networking, no SwiftData)
848	- Navigation: Coordinators. Views never push other views. Views emit intents, coordinators decide.
849	- Dependency injection: constructor injection. One `AppContainer` in `Core/DI/`. No global singletons except `AppContainer.shared` used only at the composition root.
850	- Concurrency: async/await only. No Combine. No completion handlers. Every ViewModel is `@MainActor`.
851	
852	## Folder layout
853	```
854	App/                 entry point, AppDelegate, Info.plist, Resources/
855	Core/                DI/, Navigation/, Extensions/, Utilities/
856	DesignSystem/        Tokens/, Components/, Modifiers/
857	Domain/              Entities/, ValueObjects/, Repositories/, UseCases/, Errors/
858	Data/                Repositories/, DataSources/Remote/, DataSources/Local/, DTOs/, Mappers/
859	Features/<Name>/     Presentation/Views/, Presentation/ViewModels/, Presentation/Components/, Coordinator/
860	Tests/               UnitTests/<Layer>/, UITests/
861	Docs/                project-brief.md, conventions.md, architecture.md, domain-model.md, design-system.md, file-map.md, Features/
862	```
863	- Domain and Data are grouped by feature inside each subfolder: `Domain/UseCases/<Feature>/`, `Data/Repositories/<Feature>/`.
864	- Feature-only UI components live in `Features/<Name>/Presentation/Components/`. If a component is used by two features, it moves to `DesignSystem/Components/`.
865	
866	## Naming
867	| Thing | Rule | Example |
868	|---|---|---|
869	| Entity | Noun, no suffix | `Invoice` |
870	| Value object | Noun, no suffix | `Money` |
871	| Repository protocol | `<Noun>Repository` | `InvoiceRepository` |
872	| Repository impl | `<Noun>RepositoryImpl` | `InvoiceRepositoryImpl` |
873	| Use case protocol | `<Verb><Noun>UseCase` | `CreateInvoiceUseCase` |
874	| Use case impl | `Default<Verb><Noun>UseCase` | `DefaultCreateInvoiceUseCase` |
875	| Data source | `<Noun><Remote|Local>DataSource` | `InvoiceRemoteDataSource` |
876	| DTO | `<Noun>DTO` | `InvoiceDTO` |
877	| Mapper | `<Noun>Mapper` | `InvoiceMapper` |
878	| ViewModel | `<Screen>ViewModel` | `InvoiceListViewModel` |
879	| View | `<Screen>View` | `InvoiceListView` |
880	| Coordinator | `<Feature>Coordinator` | `InvoicesCoordinator` |
881	| Route enum | `<Feature>Route` | `InvoicesRoute` |
882	| Domain error | `<Noun>Error` | `InvoiceError` |
883	| Test | `<TypeUnderTest>Tests` | `CreateInvoiceUseCaseTests` |
884	| Mock | `Mock<Protocol>` | `MockInvoiceRepository` |
885	
886	## File rules
887	- One top-level type per file. File name equals type name. `InvoiceListViewModel.swift` contains `InvoiceListViewModel` and nothing else.
888	- Extensions of a type live in `<Type>+<Concern>.swift` next to the type.
889	- No file over 300 lines. Split by concern.
890	- No `Utils.swift`, `Helpers.swift`, `Extensions.swift` catch-all files.
891	- Every new file is registered in `Docs/file-map.md`.
892	
893	## Code style
894	- Access control: [strict | default]. Default to `private` and widen only when needed.
895	- Every dependency is a protocol. Concrete types are injected, never instantiated inside a consumer.
896	- Use cases expose one `execute` method.
897	- ViewModels expose state as stored properties and actions as methods. No `@Published` unless ObservableObject mode.
898	- Views are dumb: read state, call actions, render. No business logic, no formatting logic beyond presentation.
899	- No force unwrap. No `try!`. No `as!`.
900	- Errors: typed domain errors. Never `Error` alone at a public boundary.
901	- Strings: [String Catalog only | hardcoded allowed]. No user-facing string literal in a View if catalog mode.
902	- No `TODO` left in generated code. Unfinished work goes in Docs/Features/<name>.md.
903	
904	## Testing
905	- Unit tests: Swift Testing (`@Test`, `#expect`). One test file per type.
906	- UI tests: XCTest. One test class per critical user flow.
907	- Every use case has a test. Every ViewModel has a test. Every mapper has a test.
908	- Mocks are hand-written, live in `Tests/UnitTests/Mocks/`, one per protocol.
909	
910	## Dependencies
911	- Policy: [zero | minimal | pragmatic]
912	- Allowed packages: [list or "none"]
913	
914	## Localisation
915	- [String Catalog from day one | English only for v1]
916	- Base language: [en | fr]
917	
~~~~

#### 2026-09-10 23:34:33 +0200 (21:34:33Z) · TOOL CALL · Bash
`f88478cc` · `2a692ff3` · ligne 141 · Read domain, use-case, data, viewmodel, view and coordinator skills

~~~~bash
SP="/private/tmp/claude-501/-Volumes-Steve-Pro-BlackSSD-Dev-App-Mobile-Iris/f88478cc-d512-4210-bc11-758059278995/scratchpad/skills/ios-app-skills/ios-app-skills/skills"; for s in domain-modeler business-logic-engine use-case-generator data-layer-generator viewmodel-generator view-generator coordinator-navigator; do echo "################ $s ################"; cat "$SP/$s/SKILL.md"; done
~~~~

#### 2026-09-10 23:34:34 +0200 (21:34:34Z) · TOOL RESULT · Bash
`f88478cc` · `ebe4f8c5` · ligne 142 · Read domain, use-case, data, viewmodel, view and coordinator skills

~~~~text
<persisted-output>
Output too large (43.9KB). Full output saved to: /Users/prodx0x/.claude/projects/-Volumes-Steve-Pro-BlackSSD-Dev-App-Mobile-Iris/f88478cc-d512-4210-bc11-758059278995/tool-results/blq0xt03i.txt

Preview (first 2KB):
################ domain-modeler ################
---
name: domain-modeler
description: >
  Model the Domain layer: entities, value objects, invariants, typed errors and repository protocols, as pure Swift with no framework imports. Produces Docs/domain-model.md plus one file per type under Domain/. Use this skill whenever the user says "model the domain", "define the entities", "what are the models", "create the data model", "domain layer", "value objects", "repository protocol", "modélise le domaine", "définis les entités", "crée les modèles", "couche domaine", or when any skill needs an entity that does not exist yet. Requires ios-project-foundation. Reads Docs/Features/*.md and Docs/architecture.md.
---

# Domain Modeler

## Prerequisites check

Check for `Docs/conventions.md` and `Docs/file-map.md`. If missing, say:

> Domain modelling needs the foundation. Say "set up my iOS project" first.

Then stop. If present, read both, then read `Docs/architecture.md`, every `Docs/Features/*.md` and `Docs/domain-model.md` if they exist. Go straight to Step 1.

## Step 1. Scope the modelling

Call AskUserQuestion:

```json
[
  {
    "question": "What should I model?",
    "header": "Scope",
    "multiSelect": false,
    "options": [
      {"label": "Whole product", "description": "Every entity named across Docs/Features/*.md"},
      {"label": "One feature", "description": "Only the entities of one feature spec"},
      {"label": "One entity", "description": "I will describe it in chat"}
    ]
  }
]
```

Collect the entity names from the chosen scope. Before designing anything, search `Docs/file-map.md` and `Domain/Entities/` for each name. Split the list into `existing` and `new`. Existing entities are read, never regenerated. Only extend them if a feature spec needs a field they lack, and say so.

## Step 2. Design each entity

For every new entity, decide and write in chat:

| Aspect | Rule |
|---|---|
...
</persisted-output>
~~~~

#### 2026-09-10 23:34:37 +0200 (21:34:37Z) · TOOL CALL · Read
`f88478cc` · `82abd207` · ligne 152

~~~~json
{
 "file_path": "/Users/prodx0x/.claude/projects/-Volumes-Steve-Pro-BlackSSD-Dev-App-Mobile-Iris/f88478cc-d512-4210-bc11-758059278995/tool-results/blq0xt03i.txt"
}
~~~~

#### 2026-09-10 23:34:37 +0200 (21:34:37Z) · TOOL RESULT · Read
`f88478cc` · `232a7fad` · ligne 153

~~~~text
1	################ domain-modeler ################
2	---
3	name: domain-modeler
4	description: >
5	  Model the Domain layer: entities, value objects, invariants, typed errors and repository protocols, as pure Swift with no framework imports. Produces Docs/domain-model.md plus one file per type under Domain/. Use this skill whenever the user says "model the domain", "define the entities", "what are the models", "create the data model", "domain layer", "value objects", "repository protocol", "modélise le domaine", "définis les entités", "crée les modèles", "couche domaine", or when any skill needs an entity that does not exist yet. Requires ios-project-foundation. Reads Docs/Features/*.md and Docs/architecture.md.
6	---
7	
8	# Domain Modeler
9	
10	## Prerequisites check
11	
12	Check for `Docs/conventions.md` and `Docs/file-map.md`. If missing, say:
13	
14	> Domain modelling needs the foundation. Say "set up my iOS project" first.
15	
16	Then stop. If present, read both, then read `Docs/architecture.md`, every `Docs/Features/*.md` and `Docs/domain-model.md` if they exist. Go straight to Step 1.
17	
18	## Step 1. Scope the modelling
19	
20	Call AskUserQuestion:
21	
22	```json
23	[
24	  {
25	    "question": "What should I model?",
26	    "header": "Scope",
27	    "multiSelect": false,
28	    "options": [
29	      {"label": "Whole product", "description": "Every entity named across Docs/Features/*.md"},
30	      {"label": "One feature", "description": "Only the entities of one feature spec"},
31	      {"label": "One entity", "description": "I will describe it in chat"}
32	    ]
33	  }
34	]
35	```
36	
37	Collect the entity names from the chosen scope. Before designing anything, search `Docs/file-map.md` and `Domain/Entities/` for each name. Split the list into `existing` and `new`. Existing entities are read, never regenerated. Only extend them if a feature spec needs a field they lack, and say so.
38	
39	## Step 2. Design each entity
40	
41	For every new entity, decide and write in chat:
42	
43	| Aspect | Rule |
44	|---|---|
45	| Kind | `struct` by default. `final class` only with a written reason (identity semantics, reference sharing). |
46	| Identity | `let id: <Entity>ID` where `<Entity>ID` is a typed wrapper around UUID or String. Never bare `UUID` as a field type. |
47	| Fields | Named, typed, minimal. No optional unless absence is a real state. |
48	| Value objects | Any field with validation rules (email, money, percentage, phone) becomes a value object with a failable or throwing initialiser. |
49	| Invariants | Rules that must always hold. Enforced in the initialiser or a mutating method. Listed explicitly. |
50	| Conformances | `Equatable`, `Hashable`, `Sendable`, `Identifiable`. `Codable` only if the entity itself crosses a boundary, otherwise DTOs handle it. |
51	| Relationships | By ID reference, never by embedding another entity unless composition is intrinsic. |
52	
53	Flag shared entities (used by two or more features) and assign one owning feature folder.
54	
55	## Step 3. Design errors and repository protocols
56	
57	For each feature in scope, one `<Noun>Error` enum in `Domain/Errors/`:
58	
59	```swift
60	enum InvoiceError: Error, Equatable, Sendable {
61	    case notFound(InvoiceID)
62	    case invalidAmount
63	    case alreadyPaid
64	    case storage(underlying: String)
65	}
66	```
67	
68	For each aggregate root, one repository protocol in `Domain/Repositories/<Feature>/`:
69	
70	```swift
71	protocol InvoiceRepository: Sendable {
72	    func fetchAll() async throws(InvoiceError) -> [Invoice]
73	    func fetch(id: InvoiceID) async throws(InvoiceError) -> Invoice
74	    func save(_ invoice: Invoice) async throws(InvoiceError)
75	    func delete(id: InvoiceID) async throws(InvoiceError)
76	}
77	```
78	
79	Use typed throws when Swift 6 is set in conventions.md. Otherwise plain `throws` with the error documented.
80	
81	Present all entities, value objects, errors and protocols in chat as Swift. Call AskUserQuestion to approve. Iterate, maximum 3 rounds.
82	
83	## Step 4. Write the files
84	
85	One file per type, at the path dictated by conventions.md:
86	
87	- `Domain/Entities/<Feature>/<Entity>.swift`
88	- `Domain/Entities/<Feature>/<Entity>ID.swift`
89	- `Domain/ValueObjects/<ValueObject>.swift`
90	- `Domain/Errors/<Noun>Error.swift`
91	- `Domain/Repositories/<Feature>/<Noun>Repository.swift`
92	
93	File header on every file:
94	
95	```swift
96	// <Name>.swift
97	// Layer: Domain
98	// Purpose: <one line>
99	```
100	
101	Only `import Foundation`. Nothing else. Every file must compile alone.
102	
103	Register each file in `Docs/file-map.md`. If a stub already existed from file-structure-organizer, fill it in place. Never create a sibling.
104	
105	## Step 5. Write Docs/domain-model.md
106	
107	```
108	# Domain Model
109	
110	## Entities
111	[One block per entity: name, owning feature, fields with types, invariants, relationships by ID]
112	
113	## Value objects
114	[Name, wrapped type, validation rule, example valid and invalid values]
115	
116	## Errors
117	[One enum per feature, every case with the situation that raises it]
118	
119	## Repositories
120	[One protocol per aggregate, method signatures, which error each can throw]
121	
122	## Glossary
123	[Ubiquitous language: every domain word, one definition. Used by every skill to name things identically.]
124	```
125	
126	If the file existed, merge: add new sections, update changed ones, never drop existing entries.
127	
128	## Step 6. Hand off
129	
130	Tell the user:
131	
132	> Domain is modelled: [n] entities, [n] value objects, [n] error types, [n] repository protocols. Docs/domain-model.md is the reference.
133	>
134	> Next: say "generate the use cases" to run use-case-generator, or "write the business rules" for business-logic-engine.
135	
136	## What this skill produces
137	
138	1. Pure Swift files under `Domain/`, one type each
139	2. `Docs/domain-model.md` with the glossary every other skill uses
140	
141	## Dependencies
142	
143	- Requires: `Docs/conventions.md`, `Docs/file-map.md`
144	- Reads if present: `Docs/architecture.md`, `Docs/Features/*.md`, `Docs/domain-model.md`
145	- Feeds: use-case-generator, business-logic-engine, data-layer-generator, viewmodel-generator, test-generator
146	
147	## Rules
148	
149	- Always search file-map.md and Domain/ before designing an entity. Existing entities are extended, never duplicated.
150	- Always use typed IDs. Never `UUID` or `String` as an identity field type.
151	- Never import SwiftUI, UIKit, SwiftData, CoreData, Combine or any networking framework in Domain.
152	- Never put formatting, persistence or networking concerns in an entity.
153	- Never make a repository protocol expose DTOs. Domain types only.
154	- Every value object has at least one documented invalid input.
155	- Every glossary term is used verbatim by downstream skills. No synonyms.
156	- Never use em dashes in any output file.
157	################ business-logic-engine ################
158	---
159	name: business-logic-engine
160	description: >
161	  Extract and implement business rules as pure, testable domain services and entity methods. Turns acceptance criteria and product rules into Swift logic that lives in Domain, never in ViewModels or Views. Produces Domain/Services/ files and a rules table in Docs/domain-model.md. Use this skill whenever the user says "write the business rules", "implement the logic for", "validation rules", "calculation logic", "domain service", "the rule is", "règles métier", "logique métier", "implémente la règle", "calcul de", "validation de", or when a use case needs a rule that spans several entities. Requires domain-modeler.
162	---
163	
164	# Business Logic Engine
165	
166	## Prerequisites check
167	
168	Check for `Docs/conventions.md` and `Docs/domain-model.md`. If either is missing, say:
169	
170	> Business rules attach to entities. Run domain-modeler first ("model the domain").
171	
172	Then stop. If present, read both, plus `Docs/Features/*.md` and `Docs/file-map.md`. Go straight to Step 1.
173	
174	## Step 1. Collect the rules
175	
176	Call AskUserQuestion:
177	
178	```json
179	[
180	  {
181	    "question": "Where do the rules come from?",
182	    "header": "Source",
183	    "multiSelect": false,
184	    "options": [
185	      {"label": "Feature specs", "description": "Extract from acceptance criteria in Docs/Features/*.md"},
186	      {"label": "I will describe them", "description": "I will type the rules in chat"},
187	      {"label": "Existing code", "description": "Find rules currently buried in ViewModels or Views and move them"}
188	    ]
189	  }
190	]
191	```
192	
193	If "Existing code": grep `Features/` for `if`, `guard`, `switch`, arithmetic and `Date` logic inside ViewModels and Views. List every candidate rule with its file and line. These are extraction targets.
194	
195	## Step 2. Write the rules table
196	
197	Every rule gets an ID and a home before any code:
198	
199	```
200	| ID | Rule (plain language) | Inputs | Output | Home | Feature |
201	|---|---|---|---|---|---|
202	| R-01 | An invoice cannot be paid twice | Invoice.status | InvoiceError.alreadyPaid | Invoice.markPaid() | Invoices |
203	| R-02 | Total = sum(lines) + VAT, rounded to 2 decimals | [InvoiceLine], VATRate | Money | InvoiceTotalCalculator | Invoices |
204	```
205	
206	Home decision:
207	- Rule touches one entity's own state: entity method (mutating or computed)
208	- Rule touches several entities or needs a policy: domain service in `Domain/Services/<Feature>/<Name>.swift`
209	- Rule is a pure calculation: `struct <Name>Calculator` with a single `calculate` method, stateless
210	
211	Call AskUserQuestion to approve the table. Iterate, maximum 3 rounds.
212	
213	## Step 3. Implement
214	
215	Entity methods are added to the existing entity file, or to `<Entity>+Rules.swift` next to it if the entity file would exceed 150 lines.
216	
217	Domain services:
218	
219	```swift
220	// InvoiceTotalCalculator.swift
221	// Layer: Domain
222	// Purpose: R-02 invoice total with VAT
223	
224	import Foundation
225	
226	struct InvoiceTotalCalculator: Sendable {
227	    func calculate(lines: [InvoiceLine], vatRate: VATRate) -> Money {
228	        let subtotal = lines.reduce(Money.zero) { $0 + $1.amount }
229	        return subtotal.applying(vatRate).rounded(scale: 2)
230	    }
231	}
232	```
233	
234	Every rule implementation carries its rule ID in the Purpose line. No rule without an ID. No ID without a test (test-generator reads this table).
235	
236	If a rule needs data the entity does not have, stop and say which field is missing. Do not add fields silently. Send the user to domain-modeler.
237	
238	## Step 4. Remove extracted duplicates
239	
240	If Step 1 found rules in ViewModels or Views: after the domain implementation exists, replace the original code with a call to the domain method. Show every replacement as before and after in chat before applying. Never leave the old logic in place.
241	
242	## Step 5. Update Docs/domain-model.md
243	
244	Add or update a `## Business rules` section with the approved table. Register new files in `Docs/file-map.md`.
245	
246	## Step 6. Hand off
247	
248	Tell the user:
249	
250	> [n] rules implemented in Domain, all traceable by ID. Say "generate the use cases" to wire them, or "generate tests" to cover every rule.
251	
252	## What this skill produces
253	
254	1. Entity methods and domain services under `Domain/`
255	2. `## Business rules` table in `Docs/domain-model.md`
256	
257	## Dependencies
258	
259	- Requires: `Docs/domain-model.md` (domain-modeler), `Docs/conventions.md`
260	- Feeds: use-case-generator, test-generator, code-deduplicator
261	
262	## Rules
263	
264	- Always give every rule an ID before implementing it.
265	- Always keep rules in Domain. Never in a ViewModel, never in a View, never in Data.
266	- Never add a field to an entity here. Redirect to domain-modeler.
267	- Never import anything but Foundation.
268	- Domain services are stateless structs. If it needs state, it is an entity.
269	- Never leave extracted logic duplicated at its original site.
270	- Never use em dashes in any output file.
271	################ use-case-generator ################
272	---
273	name: use-case-generator
274	description: >
275	  Generate use cases (interactors) for the Domain layer: one protocol plus one default implementation per user action, orchestrating repositories and business rules. Produces Domain/UseCases/<Feature>/ files. Use this skill whenever the user says "generate the use cases", "create a use case for", "interactor", "application logic for", "wire the domain", "génère les use cases", "crée un use case", "cas d'utilisation", or when viewmodel-generator needs an action that has no use case yet. Requires domain-modeler.
276	---
277	
278	# Use Case Generator
279	
280	## Prerequisites check
281	
282	Check for `Docs/conventions.md` and `Docs/domain-model.md`. If missing, say:
283	
284	> Use cases orchestrate entities and repositories. Run domain-modeler first.
285	
286	Then stop. If present, read both plus `Docs/Features/*.md`, `Docs/file-map.md`, and the `## Business rules` table if it exists. Go straight to Step 1.
287	
288	## Step 1. Scope
289	
290	Call AskUserQuestion:
291	
292	```json
293	[
294	  {
295	    "question": "Which use cases?",
296	    "header": "Scope",
297	    "multiSelect": false,
298	    "options": [
299	      {"label": "All for one feature", "description": "Derive from the feature spec's screens and acceptance criteria"},
300	      {"label": "One use case", "description": "I will name the action"},
301	      {"label": "Whole product", "description": "Every feature in Docs/Features/"}
302	    ]
303	  }
304	]
305	```
306	
307	## Step 2. Derive the use case list
308	
309	From the acceptance criteria and screens, list every user-initiated or system-initiated action. Naming per conventions.md: `<Verb><Noun>UseCase`. Allowed verbs: Fetch, Create, Update, Delete, Search, Sync, Validate, Submit, Toggle, Export, Import. Propose a new verb only with a reason.
310	
311	Before listing, search `Docs/file-map.md` and `Domain/UseCases/` for each name. Mark existing ones. Existing use cases are never regenerated.
312	
313	Present:
314	
315	```
316	| Use case | Input | Output | Repositories | Rules applied | Error |
317	|---|---|---|---|---|---|
318	| FetchInvoicesUseCase | none | [Invoice] | InvoiceRepository | none | InvoiceError |
319	| CreateInvoiceUseCase | CreateInvoiceInput | Invoice | InvoiceRepository, ClientRepository | R-02 | InvoiceError |
320	```
321	
322	Call AskUserQuestion to approve. Maximum 3 rounds.
323	
324	## Step 3. Generate
325	
326	One protocol and one implementation per use case. Two files.
327	
328	`Domain/UseCases/<Feature>/<Verb><Noun>UseCase.swift`:
329	
330	```swift
331	// CreateInvoiceUseCase.swift
332	// Layer: Domain
333	// Purpose: Create an invoice for a client applying R-02
334	
335	import Foundation
336	
337	protocol CreateInvoiceUseCase: Sendable {
338	    func execute(_ input: CreateInvoiceInput) async throws(InvoiceError) -> Invoice
339	}
340	
341	struct CreateInvoiceInput: Sendable, Equatable {
342	    let clientID: ClientID
343	    let lines: [InvoiceLine]
344	    let vatRate: VATRate
345	}
346	```
347	
348	`Domain/UseCases/<Feature>/Default<Verb><Noun>UseCase.swift`:
349	
350	```swift
351	// DefaultCreateInvoiceUseCase.swift
352	// Layer: Domain
353	// Purpose: Default implementation of CreateInvoiceUseCase
354	
355	import Foundation
356	
357	struct DefaultCreateInvoiceUseCase: CreateInvoiceUseCase {
358	    private let invoices: InvoiceRepository
359	    private let clients: ClientRepository
360	    private let calculator: InvoiceTotalCalculator
361	
362	    init(invoices: InvoiceRepository, clients: ClientRepository, calculator: InvoiceTotalCalculator) {
363	        self.invoices = invoices
364	        self.clients = clients
365	        self.calculator = calculator
366	    }
367	
368	    func execute(_ input: CreateInvoiceInput) async throws(InvoiceError) -> Invoice {
369	        _ = try await clients.fetch(id: input.clientID).mapError(InvoiceError.init)
370	        let total = calculator.calculate(lines: input.lines, vatRate: input.vatRate)
371	        let invoice = Invoice(id: InvoiceID(), clientID: input.clientID, lines: input.lines, total: total, status: .draft)
372	        try await invoices.save(invoice)
373	        return invoice
374	    }
375	}
376	```
377	
378	Rules for the body:
379	- One `execute` method. Exactly one.
380	- All dependencies are protocols, injected via `init`.
381	- Input is a dedicated `<Verb><Noun>Input` struct when more than one parameter. Defined in the protocol file.
382	- No formatting, no UI state, no logging framework.
383	- Cross-feature reads go through the other feature's repository protocol, never its use case, unless composition is explicit in architecture.md.
384	
385	If a use case needs a rule not in the rules table, stop and redirect to business-logic-engine. If it needs a repository method that does not exist, stop and redirect to domain-modeler.
386	
387	## Step 4. Register
388	
389	Append every file to `Docs/file-map.md`. Add a `## Use cases` section to `Docs/domain-model.md` with the approved table if not present, or merge rows.
390	
391	## Step 5. Hand off
392	
393	Tell the user:
394	
395	> [n] use cases generated under Domain/UseCases/. Say "generate the data layer" to implement the repositories, or "generate the viewmodel for [screen]" to consume them.
396	
397	## What this skill produces
398	
399	1. `Domain/UseCases/<Feature>/<Name>UseCase.swift` (protocol and input)
400	2. `Domain/UseCases/<Feature>/Default<Name>UseCase.swift` (implementation)
401	3. `## Use cases` table in `Docs/domain-model.md`
402	
403	## Dependencies
404	
405	- Requires: `Docs/domain-model.md`, `Docs/conventions.md`
406	- Feeds: viewmodel-generator, dependency-injector, test-generator
407	
408	## Rules
409	
410	- Always search file-map.md before naming a use case.
411	- Always one protocol plus one default implementation. Never a concrete class alone.
412	- Never put UI concerns, formatting, or navigation in a use case.
413	- Never instantiate a repository inside a use case.
414	- Never let a use case call a ViewModel or a coordinator.
415	- Never use em dashes in any output file.
416	################ data-layer-generator ################
417	---
418	name: data-layer-generator
419	description: >
420	  Implement the Data layer for a feature: repository implementations, remote and local data sources, DTOs and mappers, honouring the repository protocols in Domain. Produces Data/ files. Use this skill whenever the user says "generate the data layer", "implement the repository", "API client for", "persistence for", "SwiftData model for", "CloudKit for", "mapper", "DTO", "génère la couche data", "implémente le repository", "client API", "persistance", or when dependency-injector finds a repository protocol with no implementation. Requires domain-modeler and architecture-designer.
421	---
422	
423	# Data Layer Generator
424	
425	## Prerequisites check
426	
427	Check for `Docs/conventions.md`, `Docs/domain-model.md` and `Docs/architecture.md`. If any is missing, say:
428	
429	> The data layer implements Domain protocols under the persistence decisions in architecture.md. Run domain-modeler and architecture-designer first.
430	
431	Then stop. If present, read all three plus `Docs/file-map.md`. Go straight to Step 1.
432	
433	## Step 1. Scope and sources
434	
435	Call AskUserQuestion:
436	
437	```json
438	[
439	  {
440	    "question": "Which repository?",
441	    "header": "Scope",
442	    "multiSelect": false,
443	    "options": [
444	      {"label": "All for one feature", "description": "Every repository protocol of the feature"},
445	      {"label": "One repository", "description": "I will name it"},
446	      {"label": "Whole product", "description": "Every protocol without an implementation"}
447	    ]
448	  },
449	  {
450	    "question": "Data sources for this scope?",
451	    "header": "Sources",
452	    "multiSelect": true,
453	    "options": [
454	      {"label": "Remote", "description": "REST/GraphQL per architecture.md networking ADR"},
455	      {"label": "Local", "description": "SwiftData/CoreData/files per persistence ADR"},
456	      {"label": "Remote with local cache", "description": "Both, remote is source of truth"},
457	      {"label": "In-memory", "description": "For prototypes and previews"}
458	    ]
459	  }
460	]
461	```
462	
463	If Remote is chosen and no API contract is in the project (`Docs/api.md` or an OpenAPI file), ask the user to paste the endpoints and one sample JSON per endpoint. Do not invent field names.
464	
465	Search `Docs/file-map.md` and `Data/` for every target type name. Existing implementations are never regenerated.
466	
467	## Step 2. Design per repository
468	
469	For each repository protocol, present in chat:
470	
471	```
472	InvoiceRepository
473	  Impl:        InvoiceRepositoryImpl
474	  Remote:      InvoiceRemoteDataSource (protocol) ← URLSessionInvoiceRemoteDataSource
475	  Local:       InvoiceLocalDataSource (protocol) ← SwiftDataInvoiceLocalDataSource
476	  DTOs:        InvoiceDTO (Codable), InvoiceLineDTO
477	  Model:       InvoiceModel (@Model, SwiftData) if local
478	  Mapper:      InvoiceMapper (DTO ↔ Invoice, Model ↔ Invoice)
479	  Strategy:    remote first, write-through cache, local on offline
480	  Error map:   URLError → InvoiceError.network, DecodingError → InvoiceError.corruptData
481	```
482	
483	Call AskUserQuestion to approve. Maximum 3 rounds.
484	
485	## Step 3. Generate
486	
487	Files, one type each, under the paths from conventions.md:
488	
489	- `Data/DTOs/<Feature>/<Noun>DTO.swift`: `Codable`, `Sendable`, field names match the API exactly, `CodingKeys` when they differ from Swift style
490	- `Data/DataSources/Remote/<Feature>/<Noun>RemoteDataSource.swift`: protocol
491	- `Data/DataSources/Remote/<Feature>/URLSession<Noun>RemoteDataSource.swift`: implementation using the shared `HTTPClient` from `Core/Networking/` (create it once if absent, register it)
492	- `Data/DataSources/Local/<Feature>/<Noun>LocalDataSource.swift`: protocol
493	- `Data/DataSources/Local/<Feature>/<Engine><Noun>LocalDataSource.swift`: implementation
494	- `Data/DataSources/Local/<Feature>/<Noun>Model.swift`: `@Model` class if SwiftData
495	- `Data/Mappers/<Feature>/<Noun>Mapper.swift`: static pure functions `toDomain` and `toDTO` / `toModel`
496	- `Data/Repositories/<Feature>/<Noun>RepositoryImpl.swift`
497	
498	Repository implementation shape:
499	
500	```swift
501	// InvoiceRepositoryImpl.swift
502	// Layer: Data
503	// Purpose: InvoiceRepository over remote API with local cache
504	
505	import Foundation
506	
507	final class InvoiceRepositoryImpl: InvoiceRepository {
508	    private let remote: InvoiceRemoteDataSource
509	    private let local: InvoiceLocalDataSource
510	    private let mapper: InvoiceMapper
511	
512	    init(remote: InvoiceRemoteDataSource, local: InvoiceLocalDataSource, mapper: InvoiceMapper = InvoiceMapper()) {
513	        self.remote = remote
514	        self.local = local
515	        self.mapper = mapper
516	    }
517	
518	    func fetchAll() async throws(InvoiceError) -> [Invoice] {
519	        do {
520	            let dtos = try await remote.fetchAll()
521	            let invoices = dtos.map(mapper.toDomain)
522	            try await local.replaceAll(invoices.map(mapper.toModel))
523	            return invoices
524	        } catch let error as URLError where error.code == .notConnectedToInternet {
525	            return try await local.fetchAll().map(mapper.toDomain)
526	        } catch {
527	            throw InvoiceError.storage(underlying: String(describing: error))
528	        }
529	    }
530	}
531	```
532	
533	Rules for bodies:
534	- Every external error is mapped to the feature's domain error. Nothing else crosses the boundary.
535	- Mappers are pure. No async, no side effects, tested by test-generator.
536	- No business rule in Data. If a rule is needed, redirect to business-logic-engine.
537	- SwiftData `@Model` classes never leave Data. Domain sees entities only.
538	
539	## Step 4. Register and document
540	
541	Append every file to `Docs/file-map.md`. Add a `## Data strategy` section per feature to `Docs/architecture.md` with the Step 2 block.
542	
543	## Step 5. Hand off
544	
545	Tell the user:
546	
547	> Data layer for [scope] is implemented and mapped to domain errors. Say "wire the dependencies" to register everything in AppContainer, or "generate tests" for mapper and repository tests.
548	
549	## What this skill produces
550	
551	1. DTOs, data sources, models, mappers and repository implementations under `Data/`
552	2. `## Data strategy` blocks in `Docs/architecture.md`
553	
554	## Dependencies
555	
556	- Requires: `Docs/domain-model.md`, `Docs/architecture.md`, `Docs/conventions.md`
557	- Feeds: dependency-injector, test-generator
558	
559	## Rules
560	
561	- Always honour the exact repository protocol signature. Never change a Domain protocol from here.
562	- Always map external errors to the domain error enum.
563	- Never expose a DTO or @Model outside Data.
564	- Never invent API field names. Ask for a sample payload.
565	- Never put caching policy in a use case. It belongs in the repository implementation.
566	- Never use em dashes in any output file.
567	################ viewmodel-generator ################
568	---
569	name: viewmodel-generator
570	description: >
571	  Generate MVVM ViewModels for SwiftUI screens: observable state, explicit actions, use case orchestration, error to user-message mapping and navigation intents sent to a coordinator. Produces Features/<Name>/Presentation/ViewModels/ files. Use this skill whenever the user says "generate the viewmodel", "viewmodel for [screen]", "screen state", "MVVM for this view", "génère le viewmodel", "état de l'écran", "logique de présentation", or when view-generator needs a ViewModel that does not exist. Requires use-case-generator output for the actions the screen needs.
572	---
573	
574	# ViewModel Generator
575	
576	## Prerequisites check
577	
578	Check for `Docs/conventions.md` and `Docs/domain-model.md`. If missing, say:
579	
580	> ViewModels consume use cases. Run domain-modeler and use-case-generator first.
581	
582	Then stop. If present, read both plus `Docs/Features/<Feature>.md`, `Docs/architecture.md`, `Docs/file-map.md`. Note the Observation mode in conventions.md (`@Observable` or `ObservableObject`). Go straight to Step 1.
583	
584	## Step 1. Identify the screen
585	
586	Call AskUserQuestion:
587	
588	```json
589	[
590	  {
591	    "question": "Which screen?",
592	    "header": "Screen",
593	    "multiSelect": false,
594	    "options": [
595	      {"label": "Pick from feature spec", "description": "I will choose from the Screens list in Docs/Features/"},
596	      {"label": "Describe a new screen", "description": "Not yet in a spec, I will describe it"},
597	      {"label": "All screens of a feature", "description": "Generate every ViewModel of one feature"}
598	    ]
599	  }
600	]
601	```
602	
603	For each target screen, search `Docs/file-map.md` for `<Screen>ViewModel`. If it exists, read it and switch to extend mode: only add missing state or actions, never rewrite.
604	
605	## Step 2. Design the state and actions
606	
607	Present in chat before writing:
608	
609	```
610	InvoiceListViewModel
611	  State:
612	    phase: Phase (.idle | .loading | .loaded([InvoiceRowItem]) | .empty | .failed(message: String))
613	    searchQuery: String
614	    isRefreshing: Bool
615	  Derived:
616	    filteredItems: [InvoiceRowItem]   (computed, no stored duplicate)
617	  Actions:
618	    load()          → FetchInvoicesUseCase
619	    refresh()       → FetchInvoicesUseCase
620	    delete(id:)     → DeleteInvoiceUseCase
621	    select(id:)     → coordinator.navigate(.detail(id))   [navigation intent]
622	    tapCreate()     → coordinator.navigate(.create)       [navigation intent]
623	  Presentation models:
624	    InvoiceRowItem (id, title, amountText, statusBadge)  built from Invoice in Presentation, not in Domain
625	  Error mapping:
626	    InvoiceError.notFound → "This invoice no longer exists."
627	    InvoiceError.storage  → "Could not load invoices. Pull to retry."
628	```
629	
630	Rules for the design:
631	- State is a single `Phase` enum for the main content plus flat properties for controls. Never several booleans that can contradict (`isLoading` and `hasError` both true).
632	- Every use case the screen needs must exist. If one is missing, stop and redirect to use-case-generator.
633	- Navigation is an intent sent to a coordinator protocol. The ViewModel never knows the destination View.
634	- Presentation models (row items, formatted strings) are structs in `Features/<Name>/Presentation/ViewModels/<Screen>+Models.swift` or a dedicated file if reused across screens of the feature.
635	
636	Call AskUserQuestion to approve. Maximum 3 rounds.
637	
638	## Step 3. Generate
639	
640	`@Observable` mode (iOS 17+):
641	
642	```swift
643	// InvoiceListViewModel.swift
644	// Layer: Presentation
645	// Purpose: State and actions for the invoice list screen
646	
647	import Foundation
648	import Observation
649	
650	@MainActor
651	@Observable
652	final class InvoiceListViewModel {
653	    enum Phase: Equatable {
654	        case idle, loading, empty
655	        case loaded([InvoiceRowItem])
656	        case failed(message: String)
657	    }
658	
659	    private(set) var phase: Phase = .idle
660	    var searchQuery = ""
661	    private(set) var isRefreshing = false
662	
663	    var filteredItems: [InvoiceRowItem] {
664	        guard case .loaded(let items) = phase else { return [] }
665	        guard !searchQuery.isEmpty else { return items }
666	        return items.filter { $0.title.localizedCaseInsensitiveContains(searchQuery) }
667	    }
668	
669	    private let fetchInvoices: FetchInvoicesUseCase
670	    private let deleteInvoice: DeleteInvoiceUseCase
671	    private weak var coordinator: (any InvoicesNavigating)?
672	
673	    init(fetchInvoices: FetchInvoicesUseCase, deleteInvoice: DeleteInvoiceUseCase, coordinator: any InvoicesNavigating) {
674	        self.fetchInvoices = fetchInvoices
675	        self.deleteInvoice = deleteInvoice
676	        self.coordinator = coordinator
677	    }
678	
679	    func load() async {
680	        phase = .loading
681	        await fetch()
682	    }
683	
684	    func refresh() async {
685	        isRefreshing = true
686	        defer { isRefreshing = false }
687	        await fetch()
688	    }
689	
690	    func delete(id: InvoiceID) async {
691	        do {
692	            try await deleteInvoice.execute(id)
693	            await fetch()
694	        } catch {
695	            phase = .failed(message: Self.message(for: error))
696	        }
697	    }
698	
699	    func select(id: InvoiceID) {
700	        coordinator?.navigate(to: .detail(id))
701	    }
702	
703	    func tapCreate() {
704	        coordinator?.navigate(to: .create)
705	    }
706	
707	    private func fetch() async {
708	        do {
709	            let invoices = try await fetchInvoices.execute()
710	            phase = invoices.isEmpty ? .empty : .loaded(invoices.map(InvoiceRowItem.init))
711	        } catch {
712	            phase = .failed(message: Self.message(for: error))
713	        }
714	    }
715	
716	    private static func message(for error: InvoiceError) -> String {
717	        switch error {
718	        case .notFound: String(localized: "invoice.error.notFound")
719	        case .storage: String(localized: "invoice.error.storage")
720	        default: String(localized: "error.generic")
721	        }
722	    }
723	}
724	```
725	
726	`ObservableObject` mode (iOS 16): same structure with `final class X: ObservableObject`, `@Published private(set) var`, and no `import Observation`.
727	
728	Rules for the body:
729	- `@MainActor` always.
730	- Setters of state are `private(set)`. Only the ViewModel mutates its state.
731	- No `import SwiftUI`. Foundation and Observation only.
732	- No direct repository access. Use cases only.
733	- No `Task { }` inside the ViewModel. Actions are `async`, the View owns the task.
734	- Strings come from the String Catalog when conventions.md says catalog mode.
735	
736	Write `<Screen>+Models.swift` for presentation models, with `init(_ entity:)` mapping from the domain entity. Number and date formatting happens here, once.
737	
738	## Step 4. Coordinator protocol
739	
740	If `Features/<Name>/Coordinator/<Name>Navigating.swift` does not exist, create it with the routes the ViewModel needs and register it. coordinator-navigator will implement it. Never implement navigation in this skill.
741	
742	```swift
743	protocol InvoicesNavigating: AnyObject {
744	    func navigate(to route: InvoicesRoute)
745	}
746	```
747	
748	## Step 5. Register and hand off
749	
750	Append every file to `Docs/file-map.md`. Update the Screens section of `Docs/Features/<Name>.md` with `ViewModel: done`.
751	
752	Tell the user:
753	
754	> [n] ViewModel(s) generated. Say "generate the view for [screen]" to build the SwiftUI view, or "generate tests" to cover the state transitions.
755	
756	## What this skill produces
757	
758	1. `Features/<Name>/Presentation/ViewModels/<Screen>ViewModel.swift`
759	2. `Features/<Name>/Presentation/ViewModels/<Screen>+Models.swift`
760	3. `Features/<Name>/Coordinator/<Name>Navigating.swift` if absent
761	
762	## Dependencies
763	
764	- Requires: `Docs/conventions.md`, `Docs/domain-model.md`, use cases from use-case-generator
765	- Feeds: view-generator, coordinator-navigator, dependency-injector, test-generator
766	
767	## Rules
768	
769	- Always design state and actions in chat and get approval before generating.
770	- Always one Phase enum for main content. Never contradictory booleans.
771	- Never import SwiftUI in a ViewModel.
772	- Never call a repository, a data source or another ViewModel.
773	- Never create a Task inside the ViewModel.
774	- Never hold a destination View. Navigation is an intent.
775	- Never format in the View what the ViewModel can format in a presentation model.
776	- Never use em dashes in any output file.
777	################ view-generator ################
778	---
779	name: view-generator
780	description: >
781	  Generate SwiftUI views bound to an existing ViewModel, using only DesignSystem tokens and components, with previews for every state. Produces Features/<Name>/Presentation/Views/ files. Use this skill whenever the user says "generate the view", "build the screen", "SwiftUI for [screen]", "make the UI for", "génère la vue", "construis l'écran", "fais l'interface de", "écran SwiftUI", or after viewmodel-generator finishes a screen. Requires viewmodel-generator and ui-ux-designer output (Docs/design-system.md).
782	---
783	
784	# View Generator
785	
786	## Prerequisites check
787	
788	Check for `Docs/conventions.md`, `Docs/design-system.md` and the target `<Screen>ViewModel.swift`. If any is missing, say which one:
789	
790	> Views bind to a ViewModel and use the design system. Run [viewmodel-generator | ui-ux-designer] first.
791	
792	Then stop. If all present, read them plus `Docs/Features/<Feature>.md` and `Docs/file-map.md`. Go straight to Step 1.
793	
794	## Step 1. Identify the screen and layout
795	
796	Read the ViewModel's `Phase` enum and actions. Then call AskUserQuestion:
797	
798	```json
799	[
800	  {
801	    "question": "Layout pattern?",
802	    "header": "Layout",
803	    "multiSelect": false,
804	    "options": [
805	      {"label": "List", "description": "Scrollable list with rows, search, pull to refresh"},
806	      {"label": "Detail", "description": "Single item, sections, actions bar"},
807	      {"label": "Form", "description": "Inputs, validation feedback, submit"},
808	      {"label": "Dashboard", "description": "Cards and summary blocks"}
809	    ]
810	  },
811	  {
812	    "question": "Design reference?",
813	    "header": "Reference",
814	    "multiSelect": false,
815	    "options": [
816	      {"label": "Design system only", "description": "Compose from DesignSystem/Components"},
817	      {"label": "I will paste a wireframe or screenshot", "description": "Match a mockup"},
818	      {"label": "Mirror an existing screen", "description": "Same structure as a screen already in the app"}
819	    ]
820	  }
821	]
822	```
823	
824	Search `Docs/file-map.md` for `<Screen>View`. If it exists, switch to extend mode.
825	
826	## Step 2. Map states to UI
827	
828	Present a table before writing:
829	
830	```
831	| Phase | UI |
832	|---|---|
833	| .idle / .loading | DSLoadingView (design system) |
834	| .empty | DSEmptyState(title:, action:) |
835	| .loaded(items) | List of InvoiceRow inside DSScreen |
836	| .failed(message) | DSErrorState(message:, retry:) |
837	```
838	
839	List every design system component the view will use. For each, confirm it exists in `DesignSystem/Components/` via `file-map.md`. If one is missing, stop and redirect to swiftui-component-library. Never inline a component the design system should own.
840	
841	Call AskUserQuestion to approve. Maximum 3 rounds.
842	
843	## Step 3. Generate
844	
845	```swift
846	// InvoiceListView.swift
847	// Layer: Presentation
848	// Purpose: Invoice list screen bound to InvoiceListViewModel
849	
850	import SwiftUI
851	
852	struct InvoiceListView: View {
853	    @State private var viewModel: InvoiceListViewModel
854	
855	    init(viewModel: InvoiceListViewModel) {
856	        _viewModel = State(initialValue: viewModel)
857	    }
858	
859	    var body: some View {
860	        DSScreen(title: String(localized: "invoices.title")) {
861	            content
862	        }
863	        .searchable(text: $viewModel.searchQuery)
864	        .refreshable { await viewModel.refresh() }
865	        .toolbar {
866	            ToolbarItem(placement: .primaryAction) {
867	                DSIconButton(icon: .plus, label: String(localized: "invoices.create")) {
868	                    viewModel.tapCreate()
869	                }
870	            }
871	        }
872	        .task { await viewModel.load() }
873	    }
874	
875	    @ViewBuilder
876	    private var content: some View {
877	        switch viewModel.phase {
878	        case .idle, .loading:
879	            DSLoadingView()
880	        case .empty:
881	            DSEmptyState(title: String(localized: "invoices.empty"), actionTitle: String(localized: "invoices.create")) {
882	                viewModel.tapCreate()
883	            }
884	        case .loaded:
885	            List(viewModel.filteredItems) { item in
886	                InvoiceRow(item: item)
887	                    .contentShape(Rectangle())
888	                    .onTapGesture { viewModel.select(id: item.id) }
889	                    .swipeActions { deleteButton(for: item.id) }
890	            }
891	            .listStyle(.plain)
892	        case .failed(let message):
893	            DSErrorState(message: message) {
894	                Task { await viewModel.load() }
895	            }
896	        }
897	    }
898	
899	    private func deleteButton(for id: InvoiceID) -> some View {
900	        Button(role: .destructive) {
901	            Task { await viewModel.delete(id: id) }
902	        } label: {
903	            Label(String(localized: "common.delete"), systemImage: "trash")
904	        }
905	    }
906	}
907	
908	#Preview("Loaded") {
909	    InvoiceListView(viewModel: .preview(phase: .loaded(InvoiceRowItem.samples)))
910	}
911	
912	#Preview("Empty") {
913	    InvoiceListView(viewModel: .preview(phase: .empty))
914	}
915	
916	#Preview("Failed") {
917	    InvoiceListView(viewModel: .preview(phase: .failed(message: "Could not load invoices.")))
918	}
919	```
920	
921	For `ObservableObject` mode: `@StateObject private var viewModel` and `_viewModel = StateObject(wrappedValue:)`.
922	
923	Feature-only subviews (`InvoiceRow`) go in `Features/<Name>/Presentation/Components/`, one file each. If a subview is generic (no feature type in its signature), it belongs in `DesignSystem/Components/` instead, and you redirect to swiftui-component-library.
924	
925	Previews need a `.preview(phase:)` factory. Create `Features/<Name>/Presentation/ViewModels/<Screen>ViewModel+Preview.swift` with mock use cases from `Tests/UnitTests/Mocks/` if they exist, otherwise minimal inline stubs marked `#if DEBUG`.
926	
927	Rules for the body:
928	- No colours, fonts, spacing literals. Tokens only (`DSColor`, `DSFont`, `DSSpacing`).
929	- No business logic. No formatting. No `if` on domain values beyond switching on Phase.
930	- No `NavigationLink` with a destination. Navigation is `viewModel.select(...)`.
931	- Every user-facing string via `String(localized:)` when catalog mode. Add the keys to `Localizable.xcstrings` with base-language values.
932	- `body` under 40 lines. Extract `@ViewBuilder` properties.
933	- Accessibility: every interactive element has a label. Every image has a description or is decorative.
934	
935	## Step 4. Register and hand off
936	
937	Append every file to `Docs/file-map.md`. Add new localisation keys to the String Catalog. Update `Docs/Features/<Name>.md` Screens section with `View: done`.
938	
939	Tell the user:
940	
941	> [Screen]View generated with [n] previews. Say "wire the navigation" for coordinator-navigator, or "generate UI tests" for test-generator.
942	
943	## What this skill produces
944	
945	1. `Features/<Name>/Presentation/Views/<Screen>View.swift`
946	2. `Features/<Name>/Presentation/Components/<Row|Card|Section>.swift` as needed
947	3. `Features/<Name>/Presentation/ViewModels/<Screen>ViewModel+Preview.swift`
948	4. String Catalog keys
949	
950	## Dependencies
951	
952	- Requires: `<Screen>ViewModel.swift` (viewmodel-generator), `Docs/design-system.md` (ui-ux-designer), `DesignSystem/Components/` (swiftui-component-library)
953	- Feeds: coordinator-navigator, test-generator
954	
955	## Rules
956	
957	- Always map every Phase case to a UI. A missing case is a bug.
958	- Always use design system tokens and components. Never a raw `Color`, `Font` or numeric padding.
959	- Never put navigation destinations in a View.
960	- Never put logic in a View beyond switching on state.
961	- Never inline a reusable component. Redirect to swiftui-component-library.
962	- Always ship at least three previews: loaded, empty, failed.
963	- Never use em dashes in any output file.
964	################ coordinator-navigator ################
965	---
966	name: coordinator-navigator
967	description: >
968	  Implement navigation with the Coordinator pattern on top of NavigationStack: route enums, feature coordinators, AppCoordinator, tab and modal management, deep link routing, all outside the Views. Produces Core/Navigation/ and Features/<Name>/Coordinator/ files. Use this skill whenever the user says "wire the navigation", "coordinator for", "add a route", "deep link", "navigate from X to Y", "tab bar setup", "câble la navigation", "coordinateur", "ajoute une route", "lien profond", "navigation entre écrans", or when a ViewModel emits a navigation intent with no coordinator implementation. Requires architecture-designer (navigation topology) and viewmodel-generator (Navigating protocols).
969	---
970	
971	# Coordinator Navigator
972	
973	## Prerequisites check
974	
975	Check for `Docs/conventions.md` and `Docs/architecture.md`. If missing, say:
976	
977	> Navigation follows the topology in architecture.md. Run architecture-designer first.
978	
979	Then stop. If present, read both, plus `Docs/file-map.md` and every `Features/*/Coordinator/*Navigating.swift`. Go straight to Step 1.
980	
981	## Step 1. Scope
982	
983	Call AskUserQuestion:
984	
985	```json
986	[
987	  {
988	    "question": "What to wire?",
989	    "header": "Scope",
990	    "multiSelect": false,
991	    "options": [
992	      {"label": "App root", "description": "AppCoordinator, tabs, root stack, first launch"},
993	      {"label": "One feature", "description": "Routes and coordinator for one feature"},
994	      {"label": "Add a route", "description": "One new destination in an existing coordinator"},
995	      {"label": "Deep links", "description": "URL scheme and universal links to routes"}
996	    ]
997	  }
998	]
999	```
1000	
1001	Search `Docs/file-map.md` for existing `AppCoordinator`, `<Feature>Coordinator`, `<Feature>Route`. Existing coordinators are extended, never rewritten.
1002	
1003	## Step 2. Define routes
1004	
1005	For the feature, one `enum <Feature>Route: Hashable` with one case per destination, carrying only IDs or value types, never entities:
1006	
1007	```swift
1008	// InvoicesRoute.swift
1009	// Layer: Presentation
1010	// Purpose: Every destination reachable inside the Invoices feature
1011	
1012	import Foundation
1013	
1014	enum InvoicesRoute: Hashable {
1015	    case list
1016	    case detail(InvoiceID)
1017	    case create
1018	    case edit(InvoiceID)
1019	}
1020	```
1021	
1022	Sheets and full-screen covers get their own enum `enum <Feature>Modal: Identifiable`. Present the routes and the presentation style (push, sheet, cover) per route in a table. Call AskUserQuestion to approve.
1023	
1024	## Step 3. Generate the feature coordinator
1025	
1026	```swift
1027	// InvoicesCoordinator.swift
1028	// Layer: Presentation
1029	// Purpose: Owns the Invoices navigation stack and builds its screens
1030	
1031	import SwiftUI
1032	import Observation
1033	
1034	@MainActor
1035	@Observable
1036	final class InvoicesCoordinator: InvoicesNavigating {
1037	    var path = NavigationPath()
1038	    var modal: InvoicesModal?
1039	
1040	    private let container: AppContainer
1041	
1042	    init(container: AppContainer) {
1043	        self.container = container
1044	    }
1045	
1046	    func navigate(to route: InvoicesRoute) {
1047	        switch route {
1048	        case .list: path = NavigationPath()
1049	        case .detail(let id): path.append(InvoicesRoute.detail(id))
1050	        case .create: modal = .create
1051	        case .edit(let id): path.append(InvoicesRoute.edit(id))
1052	        }
1053	    }
1054	
1055	    func pop() { if !path.isEmpty { path.removeLast() } }
1056	    func dismissModal() { modal = nil }
1057	
1058	    @ViewBuilder
1059	    func view(for route: InvoicesRoute) -> some View {
1060	        switch route {
1061	        case .list: InvoiceListView(viewModel: container.makeInvoiceListViewModel(coordinator: self))
1062	        case .detail(let id): InvoiceDetailView(viewModel: container.makeInvoiceDetailViewModel(id: id, coordinator: self))
1063	        case .create: InvoiceFormView(viewModel: container.makeInvoiceFormViewModel(mode: .create, coordinator: self))
1064	        case .edit(let id): InvoiceFormView(viewModel: container.makeInvoiceFormViewModel(mode: .edit(id), coordinator: self))
1065	        }
1066	    }
1067	}
1068	```
1069	
1070	Plus a root view `Features/<Name>/Coordinator/<Feature>CoordinatorView.swift` that owns the `NavigationStack(path:)`, `.navigationDestination(for: <Feature>Route.self)` and `.sheet(item:)` bindings, and nothing else.
1071	
1072	The `container.make...` factories must exist. If not, stop and redirect to dependency-injector with the exact list of factories needed.
1073	
1074	## Step 4. Generate the app coordinator
1075	
1076	`Core/Navigation/AppCoordinator.swift`: owns `selectedTab`, one child coordinator per tab (from the topology in architecture.md), the onboarding or auth gate, and `handle(url:)` for deep links. `Core/Navigation/AppRoute.swift`: top-level routes (tab selection, global modals). `App/<AppName>App.swift` instantiates `AppCoordinator(container: .shared)` once and renders `AppCoordinatorView`.
1077	
1078	Deep links: `handle(url:)` parses the URL into an `AppRoute` and forwards to the right child coordinator. Parsing lives in `Core/Navigation/DeepLinkParser.swift`, pure and testable.
1079	
1080	## Step 5. Register and hand off
1081	
1082	Append every file to `Docs/file-map.md`. Update the Navigation topology in `Docs/architecture.md` if a route was added.
1083	
1084	Tell the user:
1085	
1086	> Navigation wired for [scope]. [n] routes, [n] modals. Say "wire the dependencies" if factories are missing, or "generate UI tests" to cover the flows.
1087	
1088	## What this skill produces
1089	
1090	1. `Features/<Name>/Coordinator/<Feature>Route.swift`, `<Feature>Modal.swift`, `<Feature>Coordinator.swift`, `<Feature>CoordinatorView.swift`
1091	2. `Core/Navigation/AppCoordinator.swift`, `AppRoute.swift`, `AppCoordinatorView.swift`, `DeepLinkParser.swift`
1092	
1093	## Dependencies
1094	
1095	- Requires: `Docs/architecture.md`, `*Navigating.swift` protocols (viewmodel-generator), `AppContainer` factories (dependency-injector)
1096	- Feeds: test-generator, feature-builder
1097	
1098	## Rules
1099	
1100	- Always one route enum per feature. Routes carry IDs, never entities.
1101	- Always build screens through AppContainer factories. Never `SomeViewModel(...)` inline in a coordinator.
1102	- Never let a View hold a NavigationPath or a destination.
1103	- Never let a coordinator call a use case or a repository.
1104	- Never let two coordinators reference each other directly. Parent to child only, child talks up through a protocol.
1105	- Never use em dashes in any output file.
1106	
~~~~

#### 2026-09-10 23:34:41 +0200 (21:34:41Z) · TOOL CALL · Bash
`f88478cc` · `1a9dfcee` · ligne 154 · Concatenate remaining skill files into one scratch file

~~~~bash
SP="/private/tmp/claude-501/-Volumes-Steve-Pro-BlackSSD-Dev-App-Mobile-Iris/f88478cc-d512-4210-bc11-758059278995/scratchpad/skills/ios-app-skills/ios-app-skills/skills"; for s in swiftui-component-library dependency-injector swift-coder file-structure-organizer test-generator layer-auditor code-deduplicator business-logic-engine; do echo "################ $s ################"; cat "$SP/$s/SKILL.md"; done > "/private/tmp/claude-501/-Volumes-Steve-Pro-BlackSSD-Dev-App-Mobile-Iris/f88478cc-d512-4210-bc11-758059278995/scratchpad/skills/batch3.txt"; wc -c "/private/tmp/claude-501/-Volumes-Steve-Pro-BlackSSD-Dev-App-Mobile-Iris/f88478cc-d512-4210-bc11-758059278995/scratchpad/skills/batch3.txt"
~~~~

#### 2026-09-10 23:34:42 +0200 (21:34:42Z) · TOOL RESULT · Bash
`f88478cc` · `6d24cf9d` · ligne 155 · Concatenate remaining skill files into one scratch file

~~~~text
   49982 /private/tmp/claude-501/-Volumes-Steve-Pro-BlackSSD-Dev-App-Mobile-Iris/f88478cc-d512-4210-bc11-758059278995/scratchpad/skills/batch3.txt
~~~~

#### 2026-09-10 23:34:45 +0200 (21:34:45Z) · TOOL CALL · Bash
`f88478cc` · `1544a216` · ligne 156 · Check project generation tools, simulators, SDKs and devices

~~~~bash
echo "=== xcodegen ==="; which xcodegen tuist 2>&1; echo "=== ruby xcodeproj gem ==="; ruby -e 'require "xcodeproj"; puts "xcodeproj gem OK"' 2>&1 | head -2; echo "=== swift ==="; swift --version 2>&1 | head -2; echo "=== simulators ==="; xcrun simctl list devices available 2>/dev/null | grep -E "iPhone|iPad" | head -30; echo "=== runtimes ==="; xcrun simctl list runtimes 2>/dev/null | head -20; echo "=== sdks ==="; xcodebuild -showsdks 2>/dev/null | grep -i ios; echo "=== python pillow ==="; python3 -c "import PIL; print('PIL ok')" 2>&1 | head -1; echo "=== connected devices ==="; xcrun xctrace list devices 2>/dev/null | head -15
~~~~

#### 2026-09-10 23:34:54 +0200 (21:34:54Z) · TOOL RESULT · Bash
`f88478cc` · `fc435530` · ligne 163 · Check project generation tools, simulators, SDKs and devices

~~~~text
=== xcodegen ===
/opt/homebrew/bin/xcodegen
tuist not found
=== ruby xcodeproj gem ===
xcodeproj gem OK
=== swift ===
swift-driver version: 1.127.15 Apple Swift version 6.2.4 (swiftlang-6.2.4.1.4 clang-1700.6.4.2)
Target: arm64-apple-macosx26.0
=== simulators ===
    iPhone 17 Pro (C051CA11-78BB-41FA-BBA0-9D46165D1F86) (Shutdown) 
    iPhone 17 (B04E7E00-9369-42E0-B9DA-E496BE01588D) (Shutdown) 
=== runtimes ===
== Runtimes ==
iOS 18.4 (18.4 - 22E238) - com.apple.CoreSimulator.SimRuntime.iOS-18-4
iOS 18.6 (18.6 - 22G86) - com.apple.CoreSimulator.SimRuntime.iOS-18-6
iOS 26.3 (26.3.1 - 23D8133) - com.apple.CoreSimulator.SimRuntime.iOS-26-3
tvOS 26.2 (26.2 - 23K51) - com.apple.CoreSimulator.SimRuntime.tvOS-26-2
=== sdks ===
iOS SDKs:
	iOS 26.2                      	-sdk iphoneos26.2
iOS Simulator SDKs:
	Simulator - iOS 26.2          	-sdk iphonesimulator26.2
=== python pillow ===
Traceback (most recent call last):
=== connected devices ===
== Devices ==
Mac Mini (7BB081C7-3B10-51C2-B9EA-19BD98EB2795)
Séjour TV (26.6) (00008110-001209393A84401E)
The Grey (26.6.1) (00008130-000819961498001C)
iPhone Steve. (26.5.2) (00008120-0016341A2187C01E)

== Devices Offline ==
iPad de Priscille (17.7.11) (92978bf1ac2387057cbaaf4e7d2b0454a99bf253)
iPhone SE Stéphane (26.6.1) (00008030-001C48AE0283802E)

== Simulators ==
Apple TV 4K (3rd generation) Simulator (26.2) (4DC11762-475C-4381-83F7-1B32009490F7)
iPhone 17 (26.3.1) (B04E7E00-9369-42E0-B9DA-E496BE01588D)
iPhone 17 Pro (26.3.1) (C051CA11-78BB-41FA-BBA0-9D46165D1F86)
~~~~

#### 2026-09-10 23:35:10 +0200 (21:35:10Z) · TOOL CALL · Read
`f88478cc` · `99bb6579` · ligne 168

~~~~json
{
 "file_path": "/private/tmp/claude-501/-Volumes-Steve-Pro-BlackSSD-Dev-App-Mobile-Iris/f88478cc-d512-4210-bc11-758059278995/scratchpad/skills/batch3.txt"
}
~~~~

#### 2026-09-10 23:35:10 +0200 (21:35:10Z) · TOOL RESULT · Read
`f88478cc` · `88c24e4e` · ligne 169

~~~~text
1	################ swiftui-component-library ################
2	---
3	name: swiftui-component-library
4	description: >
5	  Implement the reusable SwiftUI components inventoried in Docs/design-system.md, one file per component under DesignSystem/Components/, with variants, states, accessibility and previews, using tokens only. Also promotes a feature-local component to the design system when a second feature needs it. Use this skill whenever the user says "build the component library", "create the DS components", "make a reusable button", "component for", "promote this component", "shared component", "crée les composants", "bibliothèque de composants", "composant réutilisable", "factorise ce composant", or when view-generator reports a missing DS component. Requires ui-ux-designer.
6	---
7	
8	# SwiftUI Component Library
9	
10	## Prerequisites check
11	
12	Check for `Docs/design-system.md` and `DesignSystem/Tokens/`. If missing, say:
13	
14	> Components are built from tokens. Run ui-ux-designer first ("design the UI").
15	
16	Then stop. If present, read `design-system.md`, `Docs/conventions.md`, `Docs/file-map.md`. Go straight to Step 1.
17	
18	## Step 1. Scope
19	
20	Call AskUserQuestion:
21	
22	```json
23	[
24	  {
25	    "question": "What to build?",
26	    "header": "Scope",
27	    "multiSelect": false,
28	    "options": [
29	      {"label": "Whole inventory", "description": "Every component in design-system.md not yet implemented"},
30	      {"label": "One component", "description": "I will name it"},
31	      {"label": "Promote from a feature", "description": "Move a Features/*/Presentation/Components/ file into DesignSystem"},
32	      {"label": "Add a variant", "description": "Extend an existing DS component"}
33	    ]
34	  }
35	]
36	```
37	
38	Cross-check the inventory against `Docs/file-map.md`. Components already in `DesignSystem/Components/` are never regenerated. If the user names a component absent from the inventory, add the row to `design-system.md` first (redirect to ui-ux-designer extend mode or do it inline if trivial and say so).
39	
40	## Step 2. Design the API
41	
42	For each component, present its public API before writing:
43	
44	```
45	DSButton
46	  init(_ title: String, variant: Variant = .primary, isLoading: Bool = false, action: @escaping () -> Void)
47	  Variant: primary, secondary, destructive, ghost
48	  Disabled: via .disabled() environment, styled automatically
49	  Sizing: full width by default, .dsButtonCompact() modifier for inline
50	  Accessibility: title is the label, isLoading sets .accessibilityValue("Loading")
51	```
52	
53	API rules:
54	- Small, explicit initialisers. No configuration bag with 12 optionals.
55	- Variants are nested enums.
56	- Style follows the SwiftUI `ButtonStyle` / `ViewModifier` idiom where it fits, so consumers can `.buttonStyle(.dsPrimary)`.
57	- No callbacks with domain types. Strings, IDs, closures only.
58	
59	Call AskUserQuestion to approve. Maximum 3 rounds.
60	
61	## Step 3. Implement
62	
63	```swift
64	// DSButton.swift
65	// Layer: DesignSystem
66	// Purpose: Primary action button with variants and loading state
67	
68	import SwiftUI
69	
70	struct DSButton: View {
71	    enum Variant { case primary, secondary, destructive, ghost }
72	
73	    private let title: String
74	    private let variant: Variant
75	    private let isLoading: Bool
76	    private let action: () -> Void
77	
78	    @Environment(\.isEnabled) private var isEnabled
79	
80	    init(_ title: String, variant: Variant = .primary, isLoading: Bool = false, action: @escaping () -> Void) {
81	        self.title = title
82	        self.variant = variant
83	        self.isLoading = isLoading
84	        self.action = action
85	    }
86	
87	    var body: some View {
88	        Button(action: action) {
89	            ZStack {
90	                Text(title).opacity(isLoading ? 0 : 1)
91	                if isLoading { ProgressView().tint(foreground) }
92	            }
93	            .font(DSFont.body.weight(.semibold))
94	            .frame(maxWidth: .infinity, minHeight: 44)
95	            .padding(.horizontal, DSSpacing.m)
96	            .background(background, in: RoundedRectangle(cornerRadius: DSRadius.m))
97	            .foregroundStyle(foreground)
98	        }
99	        .disabled(isLoading || !isEnabled)
100	        .opacity(isEnabled ? 1 : 0.4)
101	        .accessibilityLabel(title)
102	        .accessibilityValue(isLoading ? Text("Loading") : Text(""))
103	    }
104	
105	    private var background: Color {
106	        switch variant {
107	        case .primary: DSColor.accent
108	        case .secondary: DSColor.backgroundSecondary
109	        case .destructive: DSColor.statusDanger
110	        case .ghost: .clear
111	        }
112	    }
113	
114	    private var foreground: Color {
115	        switch variant {
116	        case .primary, .destructive: DSColor.textOnAccent
117	        case .secondary, .ghost: DSColor.textPrimary
118	        }
119	    }
120	}
121	
122	#Preview("Variants") {
123	    VStack(spacing: DSSpacing.m) {
124	        DSButton("Primary") {}
125	        DSButton("Secondary", variant: .secondary) {}
126	        DSButton("Destructive", variant: .destructive) {}
127	        DSButton("Ghost", variant: .ghost) {}
128	        DSButton("Loading", isLoading: true) {}
129	        DSButton("Disabled") {}.disabled(true)
130	    }
131	    .padding()
132	}
133	```
134	
135	Every component file:
136	- Tokens only. Zero literal colours, fonts, or numeric spacing.
137	- One preview showing every variant and state, plus one preview with `.dynamicTypeSize(.accessibility3)` and one with `.preferredColorScheme(.dark)`.
138	- Accessibility label, value and traits set where the default is not enough.
139	- No dependency on Domain or any feature. `import SwiftUI` only.
140	
141	Modifiers go in `DesignSystem/Modifiers/<Name>Modifier.swift` with a `View` extension in the same file.
142	
143	## Step 4. Promote mode
144	
145	When promoting a feature component:
146	1. Read the feature file. Strip every feature type from its signature (replace `InvoiceRowItem` with strings and closures).
147	2. Create the DS version with the `DS` prefix.
148	3. Replace the feature component with a thin wrapper that maps the feature model to the DS component, or delete it if the wrapper would be trivial and update the View directly.
149	4. Show before and after in chat. Apply after approval.
150	5. Update `file-map.md`: new DS file, deleted or modified feature file.
151	
152	## Step 5. Register and hand off
153	
154	Append every file to `Docs/file-map.md`. Mark each row of the inventory in `design-system.md` with `Status: implemented`.
155	
156	Tell the user:
157	
158	> [n] components implemented under DesignSystem/Components/ with previews. Say "generate the view for [screen]" to use them.
159	
160	## What this skill produces
161	
162	1. `DesignSystem/Components/DS<Name>.swift`, one per component
163	2. `DesignSystem/Modifiers/<Name>Modifier.swift` as needed
164	3. Status updates in `Docs/design-system.md`
165	
166	## Dependencies
167	
168	- Requires: `Docs/design-system.md`, `DesignSystem/Tokens/` (ui-ux-designer)
169	- Feeds: view-generator
170	
171	## Rules
172	
173	- Always `DS` prefix. Always one component per file.
174	- Always tokens. Never literals.
175	- Never import Domain or a feature type into DesignSystem.
176	- Never regenerate an existing component. Extend with a variant.
177	- Every component ships with variant, dark mode and accessibility-size previews.
178	- Never use em dashes in any output file.
179	################ dependency-injector ################
180	---
181	name: dependency-injector
182	description: >
183	  Build and maintain the composition root: a single AppContainer with typed factories for repositories, use cases, ViewModels and coordinators, environment-specific wiring (live, preview, test) and no service locator lookups. Produces Core/DI/ files. Use this skill whenever the user says "wire the dependencies", "dependency injection", "container", "how do I inject", "factory for", "preview container", "test container", "câble les dépendances", "injection de dépendances", "conteneur", "comment injecter", or when coordinator-navigator or view-generator reports a missing factory. Requires use-case-generator and data-layer-generator output.
184	---
185	
186	# Dependency Injector
187	
188	## Prerequisites check
189	
190	Check for `Docs/conventions.md`, `Docs/architecture.md` and `Docs/file-map.md`. If missing, say:
191	
192	> DI wires what the architecture defines. Run architecture-designer first.
193	
194	Then stop. If present, read all three. Read `Core/DI/AppContainer.swift` if it exists. Go straight to Step 1.
195	
196	## Step 1. Scope
197	
198	Call AskUserQuestion:
199	
200	```json
201	[
202	  {
203	    "question": "What to wire?",
204	    "header": "Scope",
205	    "multiSelect": false,
206	    "options": [
207	      {"label": "Bootstrap the container", "description": "Create AppContainer and the environment variants for the first time"},
208	      {"label": "One feature", "description": "Add factories for every type of one feature"},
209	      {"label": "Missing factories", "description": "Scan for make... calls that do not exist and add them"},
210	      {"label": "Audit", "description": "Find direct instantiations that bypass the container"}
211	    ]
212	  }
213	]
214	```
215	
216	## Step 2. Build the dependency graph
217	
218	From `file-map.md`, collect for the scope every protocol and its implementation, every use case and its `init` parameters, every ViewModel and its `init`, every coordinator. Present the graph:
219	
220	```
221	InvoiceListViewModel
222	  ← FetchInvoicesUseCase        = DefaultFetchInvoicesUseCase
223	      ← InvoiceRepository       = InvoiceRepositoryImpl
224	          ← InvoiceRemoteDataSource = URLSessionInvoiceRemoteDataSource ← HTTPClient
225	          ← InvoiceLocalDataSource  = SwiftDataInvoiceLocalDataSource  ← ModelContainer
226	  ← DeleteInvoiceUseCase        = DefaultDeleteInvoiceUseCase ← InvoiceRepository
227	  ← InvoicesNavigating          = InvoicesCoordinator (passed by the coordinator itself)
228	```
229	
230	Lifetimes:
231	- Shared, one instance per app: `HTTPClient`, `ModelContainer`, repositories, data sources. Stored as `lazy var` or `let` in the container.
232	- Transient, one per screen: use cases (cheap structs), ViewModels. Built by factory methods.
233	- Coordinators: owned by their parent coordinator, not by the container. The container builds them on request from the parent.
234	
235	Flag any type that cannot be resolved (missing implementation). Redirect to data-layer-generator or use-case-generator with the exact type name. Do not stub.
236	
237	Call AskUserQuestion to approve. Maximum 3 rounds.
238	
239	## Step 3. Generate
240	
241	`Core/DI/AppContainer.swift`:
242	
243	```swift
244	// AppContainer.swift
245	// Layer: Core
246	// Purpose: Composition root. The only place concrete types are chosen.
247	
248	import Foundation
249	import SwiftData
250	
251	@MainActor
252	final class AppContainer {
253	    static let shared = AppContainer(environment: .live)
254	
255	    let environment: AppEnvironment
256	
257	    init(environment: AppEnvironment) {
258	        self.environment = environment
259	    }
260	
261	    // MARK: Shared infrastructure
262	    lazy var httpClient: HTTPClient = environment.makeHTTPClient()
263	    lazy var modelContainer: ModelContainer = environment.makeModelContainer()
264	}
265	```
266	
267	`Core/DI/AppEnvironment.swift`: `enum AppEnvironment { case live, preview, test }` with the infrastructure factories per case (live URLSession vs stub client, on-disk vs in-memory ModelContainer).
268	
269	`Core/DI/AppContainer+<Feature>.swift`, one extension per feature:
270	
271	```swift
272	// AppContainer+Invoices.swift
273	// Layer: Core
274	// Purpose: Factories for the Invoices feature
275	
276	import Foundation
277	
278	extension AppContainer {
279	    // MARK: Data (shared)
280	    var invoiceRepository: InvoiceRepository {
281	        registry.resolve(InvoiceRepository.self) {
282	            InvoiceRepositoryImpl(
283	                remote: URLSessionInvoiceRemoteDataSource(client: httpClient),
284	                local: SwiftDataInvoiceLocalDataSource(container: modelContainer)
285	            )
286	        }
287	    }
288	
289	    // MARK: Domain (transient)
290	    func makeFetchInvoicesUseCase() -> FetchInvoicesUseCase {
291	        DefaultFetchInvoicesUseCase(invoices: invoiceRepository)
292	    }
293	
294	    // MARK: Presentation (transient)
295	    func makeInvoiceListViewModel(coordinator: any InvoicesNavigating) -> InvoiceListViewModel {
296	        InvoiceListViewModel(
297	            fetchInvoices: makeFetchInvoicesUseCase(),
298	            deleteInvoice: makeDeleteInvoiceUseCase(),
299	            coordinator: coordinator
300	        )
301	    }
302	
303	    func makeInvoicesCoordinator() -> InvoicesCoordinator {
304	        InvoicesCoordinator(container: self)
305	    }
306	}
307	```
308	
309	`Core/DI/Registry.swift`: a tiny typed cache (`resolve(_:factory:)`) keyed by `ObjectIdentifier`, used only for shared lifetimes, private to the container. No global lookup API. No string keys.
310	
311	Preview and test:
312	- `AppContainer.preview` static in `Core/DI/AppContainer+Preview.swift` under `#if DEBUG`, using in-memory data sources and sample data from `Tests/UnitTests/Mocks/` or DesignSystem sample fixtures.
313	- Test targets build `AppContainer(environment: .test)` and override repositories through a `override<T>(_:with:)` method available only in `.test` and `.preview`.
314	
315	## Step 4. Audit mode
316	
317	Grep the project for `RepositoryImpl(`, `DataSource(`, `UseCase(`, `ViewModel(`, `Coordinator(` outside `Core/DI/`, previews and tests. Each hit is a bypass. Report the table and replace with a factory call after approval.
318	
319	## Step 5. Register and hand off
320	
321	Append every file to `Docs/file-map.md`. Write or update the `## Dependency graph` section of `Docs/architecture.md` with the Step 2 graph.
322	
323	Tell the user:
324	
325	> Container wired for [scope]: [n] shared instances, [n] factories. Say "wire the navigation" for coordinator-navigator, or "generate tests" to use the test container.
326	
327	## What this skill produces
328	
329	1. `Core/DI/AppContainer.swift`, `AppEnvironment.swift`, `Registry.swift`, `AppContainer+Preview.swift`
330	2. `Core/DI/AppContainer+<Feature>.swift` per feature
331	3. `## Dependency graph` in `Docs/architecture.md`
332	
333	## Dependencies
334	
335	- Requires: `Docs/architecture.md`, `Docs/conventions.md`, implementations from data-layer-generator and use-case-generator
336	- Feeds: coordinator-navigator, view-generator previews, test-generator
337	
338	## Rules
339	
340	- Always one composition root. Never a second container, never a global service locator.
341	- Always constructor injection. Never property injection, never `@Environment` for domain services.
342	- Never expose concrete types from factories. Return the protocol.
343	- Never instantiate a domain or data type outside `Core/DI/`, previews or tests.
344	- Never stub a missing implementation. Redirect.
345	- Never use em dashes in any output file.
346	################ swift-coder ################
347	---
348	name: swift-coder
349	description: >
350	  Write or modify Swift code inside an existing file with strict respect for Docs/conventions.md: minimal targeted edits, layer rules, naming, no duplication, no dead code. The general-purpose implementation skill used when no specialised generator applies, and for bug fixes. Use this skill whenever the user says "write the code for", "implement this function", "fix this bug", "refactor this", "add this method", "why does this crash", "écris le code", "implémente", "corrige ce bug", "refactore", "ajoute cette méthode", "pourquoi ça plante", or pastes Swift code asking for changes. Requires ios-project-foundation.
351	---
352	
353	# Swift Coder
354	
355	## Prerequisites check
356	
357	Check for `Docs/conventions.md` and `Docs/file-map.md`. If missing, say:
358	
359	> I write code against the project conventions. Run ios-project-foundation first, or say "no conventions" to proceed with Apple defaults for this one task.
360	
361	If the user says "no conventions", proceed with Swift API Design Guidelines and note that nothing is registered. Otherwise read both files plus `Docs/architecture.md` and `Docs/domain-model.md` if present. Go straight to Step 1.
362	
363	## Step 1. Locate the change
364	
365	Call AskUserQuestion:
366	
367	```json
368	[
369	  {
370	    "question": "What kind of change?",
371	    "header": "Change",
372	    "multiSelect": false,
373	    "options": [
374	      {"label": "Bug fix", "description": "Something is wrong, minimal targeted fix"},
375	      {"label": "New function or method", "description": "Add behaviour to an existing type"},
376	      {"label": "Refactor", "description": "Same behaviour, better structure"},
377	      {"label": "Explain or diagnose", "description": "No edit yet, tell me what is happening"}
378	    ]
379	  }
380	]
381	```
382	
383	Ask for the file path or the pasted code if not given. Read the whole file. Read every type it references that lives in the project.
384	
385	Before proposing anything, search `Docs/file-map.md` and grep the codebase for a function or type that already does what is being asked. If one exists, propose reusing it instead of writing new code. State the path.
386	
387	## Step 2. Plan the edit
388	
389	Output a plan before touching anything:
390	
391	```
392	File: Features/Invoices/Presentation/ViewModels/InvoiceListViewModel.swift
393	Change 1 (line 42): guard on empty query before filtering
394	  Before: return items.filter { $0.title.contains(searchQuery) }
395	  After:  guard !searchQuery.isEmpty else { return items }
396	          return items.filter { $0.title.localizedCaseInsensitiveContains(searchQuery) }
397	Reason: R-07, empty query returns everything, and search must be case insensitive
398	Layer check: Presentation, allowed
399	Duplication check: no existing filter helper in file-map.md
400	```
401	
402	For bug fixes: only lines that cause the bug. If you notice an unrelated improvement, list it under `Not applied` with one line each. Never apply it.
403	
404	For new code: state which layer it belongs to per conventions.md. If it does not belong in the target file, say where it goes and stop, or redirect to the specialised skill (viewmodel-generator, use-case-generator, data-layer-generator, swiftui-component-library).
405	
406	Call AskUserQuestion to approve the plan. No edit before approval.
407	
408	## Step 3. Apply
409	
410	Use targeted string replacement per change. Never rewrite the whole file for a partial change. Keep the file header comment. Keep existing formatting.
411	
412	After applying, run a self-check on the edited file:
413	
414	| Check | Rule |
415	|---|---|
416	| Layer | No forbidden import for the file's layer |
417	| Naming | Matches the Naming table |
418	| Access | `private` by default |
419	| Safety | No force unwrap, no `try!`, no `as!` |
420	| Concurrency | `@MainActor` where UI state is touched, `Sendable` where crossing actors |
421	| Size | File under 300 lines, function under 40 lines |
422	| Dead code | No unused variable, parameter, import or function introduced |
423	| Strings | Catalog keys in catalog mode |
424	
425	Report any violation you had to accept and why.
426	
427	## Step 4. Diagnose mode
428	
429	For "Explain or diagnose": read the code and the call sites. Answer in this order: what happens, why, the exact line, the fix in one sentence. Then offer to apply it via Bug fix mode. No edit.
430	
431	## Step 5. Register and hand off
432	
433	If a new file was created (only when the plan justified it), append to `Docs/file-map.md`. If a rule was implemented, add its ID to the `## Business rules` table in `domain-model.md`.
434	
435	Tell the user:
436	
437	> Applied [n] change(s) to [file]. [Not applied: list]. Say "generate tests" to cover this, or "dedupe" to check for duplicates across the project.
438	
439	## What this skill produces
440	
441	1. Targeted edits in existing files
442	2. Rarely, a new file registered in `Docs/file-map.md`
443	
444	## Dependencies
445	
446	- Requires: `Docs/conventions.md`, `Docs/file-map.md`
447	- Reads if present: `Docs/architecture.md`, `Docs/domain-model.md`
448	- Feeds: test-generator, code-deduplicator
449	
450	## Rules
451	
452	- Always plan with before and after per change, and get approval, before editing.
453	- Always search for existing code that does the job before writing new code.
454	- Never touch lines unrelated to the requested change. Mention, do not apply.
455	- Never move logic across layers silently. Say it and redirect.
456	- Never introduce a catch-all file.
457	- Never leave a TODO. Unfinished work goes in Docs/Features/<name>.md.
458	- Never use em dashes in any output file.
459	################ file-structure-organizer ################
460	---
461	name: file-structure-organizer
462	description: >
463	  Generate the complete folder tree and stub files of the iOS project from Docs/architecture.md, and register every file in Docs/file-map.md. Also audits an existing project and moves misplaced files to their correct layer. Use this skill whenever the user says "generate the file structure", "create the folders", "scaffold the project", "organise my files", "where should this file go", "clean up the project tree", "audit the structure", "génère l'arborescence", "crée les dossiers", "range les fichiers", "où mettre ce fichier", "nettoie l'arbo". Requires ios-project-foundation and architecture-designer.
464	---
465	
466	# File Structure Organiser
467	
468	## Prerequisites check
469	
470	Check for `Docs/conventions.md` and `Docs/architecture.md`. If either is missing, say:
471	
472	> The tree is generated from the architecture. Run ios-project-foundation then architecture-designer first.
473	
474	Then stop. If both exist, read them fully plus `Docs/file-map.md`. Go straight to Step 1.
475	
476	## Step 1. Choose mode
477	
478	Call AskUserQuestion:
479	
480	```json
481	[
482	  {
483	    "question": "What do you need?",
484	    "header": "Mode",
485	    "multiSelect": false,
486	    "options": [
487	      {"label": "Scaffold from scratch", "description": "Create every folder and stub file from architecture.md"},
488	      {"label": "Scaffold one feature", "description": "Create only Features/<Name> and its Domain and Data folders"},
489	      {"label": "Audit existing tree", "description": "Find misplaced files and propose moves"},
490	      {"label": "Place one file", "description": "Tell me where a given type belongs"}
491	    ]
492	  }
493	]
494	```
495	
496	## Step 2. Build the target tree
497	
498	Derive the tree from the Folder layout section of `conventions.md` and the Feature map of `architecture.md`. One folder per feature under `Features/`, and matching feature subfolders under `Domain/UseCases/`, `Domain/Entities/`, `Domain/Repositories/`, `Data/Repositories/`, `Data/DataSources/`, `Data/DTOs/`, `Data/Mappers/`.
499	
500	Print the full tree in a plain code block before creating anything:
501	
502	```
503	<AppName>/
504	├── App/
505	│   ├── <AppName>App.swift
506	│   └── Resources/
507	│       ├── Assets.xcassets/
508	│       └── Localizable.xcstrings
509	├── Core/
510	│   ├── DI/
511	│   │   ├── AppContainer.swift
512	│   │   └── AppContainer+<Feature>.swift
513	│   ├── Navigation/
514	│   │   ├── AppCoordinator.swift
515	│   │   └── AppRoute.swift
516	│   ├── Extensions/
517	│   └── Utilities/
518	├── DesignSystem/
519	│   ├── Tokens/
520	│   ├── Components/
521	│   └── Modifiers/
522	├── Domain/
523	│   ├── Entities/<Feature>/
524	│   ├── ValueObjects/
525	│   ├── Repositories/<Feature>/
526	│   ├── UseCases/<Feature>/
527	│   └── Errors/
528	├── Data/
529	│   ├── Repositories/<Feature>/
530	│   ├── DataSources/Remote/<Feature>/
531	│   ├── DataSources/Local/<Feature>/
532	│   ├── DTOs/<Feature>/
533	│   └── Mappers/<Feature>/
534	├── Features/
535	│   └── <Feature>/
536	│       ├── Presentation/
537	│       │   ├── Views/
538	│       │   ├── ViewModels/
539	│       │   └── Components/
540	│       └── Coordinator/
541	├── Tests/
542	│   ├── UnitTests/
543	│   │   ├── Domain/<Feature>/
544	│   │   ├── Data/<Feature>/
545	│   │   ├── Presentation/<Feature>/
546	│   │   └── Mocks/
547	│   └── UITests/
548	└── Docs/
549	```
550	
551	Call AskUserQuestion to approve the tree. Do not create anything before approval.
552	
553	## Step 3. Create folders and stubs
554	
555	For every folder: create it. Add a `.gitkeep` only in folders that would otherwise be empty.
556	
557	For every file named in the Feature map of `architecture.md`: create a stub with the correct type declaration, a one-line doc comment stating its layer and purpose, and nothing else. Stub template:
558	
559	```swift
560	// <FileName>.swift
561	// Layer: <Domain|Data|Presentation|Core|App>
562	// Purpose: <one line from architecture.md>
563	
564	import Foundation
565	
566	<protocol|struct|final class|enum> <TypeName> {
567	}
568	```
569	
570	Stubs never contain logic. Downstream skills fill them. A stub must compile.
571	
572	Do not create stubs for files that already exist in `file-map.md`. If a file exists at the wrong path, go to Step 5 instead of creating a duplicate.
573	
574	## Step 4. Register everything
575	
576	Append one row per created file to `Docs/file-map.md`:
577	
578	```
579	| Features/Invoices/Presentation/ViewModels/InvoiceListViewModel.swift | class | Presentation | Screen state and actions for invoice list | file-structure-organizer |
580	```
581	
582	Sort the table by Path after appending.
583	
584	## Step 5. Audit mode
585	
586	Walk every `.swift` file. For each, check:
587	
588	1. Path matches the layer implied by the type name suffix (`ViewModel` in `Features/*/Presentation/ViewModels/`, `RepositoryImpl` in `Data/Repositories/`, and so on per the Naming table in conventions.md)
589	2. File name equals the primary type name
590	3. Exactly one top-level type per file
591	4. No forbidden import for its layer (`import SwiftUI` in Domain, `import Data` in Presentation)
592	5. File is present in `file-map.md`
593	
594	Output a table of violations:
595	
596	```
597	| File | Violation | Proposed fix |
598	|---|---|---|
599	```
600	
601	Call AskUserQuestion to approve moves. Apply approved moves with `git mv` when in a git repo, plain move otherwise. Update the Xcode project only if using folder-synchronised groups (Xcode 16+). Otherwise tell the user which groups to re-link. Update `file-map.md` for every move.
602	
603	## Step 6. Place one file mode
604	
605	Ask for the type name and its responsibility in one line. Answer with the exact path, the reason (which rule in conventions.md), and whether a file with that name already exists in `file-map.md`. If it exists, say so and stop. Never create a second file with the same type name.
606	
607	## Step 7. Hand off
608	
609	Tell the user:
610	
611	> Tree is in place with [n] folders and [n] stub files, all registered in Docs/file-map.md.
612	>
613	> Next: say "model the domain" to run domain-modeler, or "build feature [name]" to run feature-builder.
614	
615	## What this skill produces
616	
617	1. The complete folder tree under the project root
618	2. Compilable stub files, one type each
619	3. Updated `Docs/file-map.md`
620	
621	## Dependencies
622	
623	- Requires: `Docs/conventions.md`, `Docs/architecture.md`, `Docs/file-map.md`
624	- Feeds: every code-generating skill
625	
626	## Rules
627	
628	- Always print the tree and get approval before creating anything.
629	- Always check file-map.md before creating a file. A type name that already exists is never created again.
630	- Never put logic in a stub.
631	- Never create catch-all files (Utils, Helpers, Extensions, Constants).
632	- Never create a folder that conventions.md does not define. Propose a conventions change instead.
633	- Never move a file without approval.
634	- Never use em dashes in any output file.
635	################ test-generator ################
636	---
637	name: test-generator
638	description: >
639	  Generate unit tests (Swift Testing) for use cases, business rules, mappers, ViewModels and coordinators, plus UI tests (XCTest) for critical user flows, with hand-written mocks, one test file per type, under Tests/. Use this skill whenever the user says "generate tests", "write tests for", "unit test", "UI test", "cover this", "mock for", "test coverage", "génère les tests", "écris les tests", "test unitaire", "test UI", "couvre ce code", "mock pour", or at the end of every feature-builder run. Requires ios-project-foundation and the code under test.
640	---
641	
642	# Test Generator
643	
644	## Prerequisites check
645	
646	Check for `Docs/conventions.md` and `Docs/file-map.md`. If missing, say:
647	
648	> Tests follow the project conventions. Run ios-project-foundation first.
649	
650	Then stop. If present, read both, plus `Docs/domain-model.md` (rules table) and `Docs/Features/*.md` (acceptance criteria). Go straight to Step 1.
651	
652	## Step 1. Scope
653	
654	Call AskUserQuestion:
655	
656	```json
657	[
658	  {
659	    "question": "What to test?",
660	    "header": "Scope",
661	    "multiSelect": false,
662	    "options": [
663	      {"label": "One feature", "description": "Every use case, rule, mapper, ViewModel and flow of one feature"},
664	      {"label": "One type", "description": "I will name it"},
665	      {"label": "Uncovered only", "description": "Every type in file-map.md without a matching <Type>Tests file"},
666	      {"label": "UI flows", "description": "XCTest UI tests for the P0 user flows in Docs/product.md"}
667	    ]
668	  }
669	]
670	```
671	
672	Search `Tests/` and `file-map.md` for existing `<Type>Tests` and `Mock<Protocol>`. Existing tests are extended, never rewritten. Existing mocks are reused.
673	
674	## Step 2. Plan the cases
675	
676	Present a case table before writing:
677	
678	```
679	CreateInvoiceUseCaseTests
680	| Case | Given | When | Then | Rule / AC |
681	|---|---|---|---|---|
682	| creates draft with computed total | client exists, 2 lines, 20% VAT | execute | invoice.status == .draft, total == 120.00 | R-02 |
683	| throws when client missing | clients.fetch throws notFound | execute | throws InvoiceError.clientNotFound | AC-3 |
684	| does not save on failure | repository.save throws | execute | throws, saveCallCount == 1, no partial state | AC-4 |
685	```
686	
687	Sources for cases:
688	- Every rule ID in the `## Business rules` table gets at least one test
689	- Every acceptance criterion in the feature spec gets at least one test
690	- Every `Phase` transition of a ViewModel gets one test
691	- Every mapper gets a round trip test and a malformed input test
692	- Every coordinator route gets a test that `navigate(to:)` mutates `path` or `modal` as expected
693	
694	Call AskUserQuestion to approve. Maximum 3 rounds.
695	
696	## Step 3. Generate mocks
697	
698	One mock per protocol in `Tests/UnitTests/Mocks/Mock<Protocol>.swift`:
699	
700	```swift
701	// MockInvoiceRepository.swift
702	// Layer: Tests
703	// Purpose: Recording mock for InvoiceRepository
704	
705	import Foundation
706	@testable import <AppName>
707	
708	final class MockInvoiceRepository: InvoiceRepository, @unchecked Sendable {
709	    var fetchAllResult: Result<[Invoice], InvoiceError> = .success([])
710	    var saveResult: Result<Void, InvoiceError> = .success(())
711	    private(set) var saveCalls: [Invoice] = []
712	    private(set) var deleteCalls: [InvoiceID] = []
713	
714	    func fetchAll() async throws(InvoiceError) -> [Invoice] { try fetchAllResult.get() }
715	    func fetch(id: InvoiceID) async throws(InvoiceError) -> Invoice {
716	        guard let found = try fetchAllResult.get().first(where: { $0.id == id }) else { throw .notFound(id) }
717	        return found
718	    }
719	    func save(_ invoice: Invoice) async throws(InvoiceError) { saveCalls.append(invoice); try saveResult.get() }
720	    func delete(id: InvoiceID) async throws(InvoiceError) { deleteCalls.append(id) }
721	}
722	```
723	
724	Mocks record calls and return configurable results. No logic. No third-party mocking library.
725	
726	Fixtures: `Tests/UnitTests/Fixtures/<Entity>+Fixture.swift` with `static func fixture(...)` using sensible defaults, one per entity, reused by previews through `#if DEBUG` when conventions allow.
727	
728	## Step 4. Generate unit tests
729	
730	Swift Testing, one file per type, path mirrors the source layer:
731	
732	```swift
733	// CreateInvoiceUseCaseTests.swift
734	// Layer: Tests
735	// Purpose: R-02 and AC-3, AC-4 of Invoices
736	
737	import Testing
738	@testable import <AppName>
739	
740	@Suite("CreateInvoiceUseCase")
741	struct CreateInvoiceUseCaseTests {
742	    private let invoices = MockInvoiceRepository()
743	    private let clients = MockClientRepository()
744	
745	    private func makeSUT() -> DefaultCreateInvoiceUseCase {
746	        DefaultCreateInvoiceUseCase(invoices: invoices, clients: clients, calculator: InvoiceTotalCalculator())
747	    }
748	
749	    @Test("creates a draft with the computed total (R-02)")
750	    func createsDraft() async throws {
751	        clients.fetchResult = .success(.fixture())
752	        let sut = makeSUT()
753	
754	        let invoice = try await sut.execute(.fixture(vatRate: .percent(20)))
755	
756	        #expect(invoice.status == .draft)
757	        #expect(invoice.total == Money(120, currency: .eur))
758	        #expect(invoices.saveCalls.count == 1)
759	    }
760	
761	    @Test("throws when the client does not exist (AC-3)")
762	    func throwsWhenClientMissing() async {
763	        clients.fetchResult = .failure(.notFound(.fixture))
764	        let sut = makeSUT()
765	
766	        await #expect(throws: InvoiceError.clientNotFound) {
767	            try await sut.execute(.fixture())
768	        }
769	        #expect(invoices.saveCalls.isEmpty)
770	    }
771	}
772	```
773	
774	ViewModel tests run with `@MainActor` on the suite and assert `phase` after each action. Coordinator tests assert `path.count` and `modal`.
775	
776	Test rules:
777	- Arrange, act, assert with blank lines between. One behaviour per test.
778	- Test names describe behaviour and cite the rule or AC ID.
779	- No sleeping, no timers. Async is awaited.
780	- No test touches the network, the disk or the keychain. `AppEnvironment.test` only.
781	
782	## Step 5. Generate UI tests
783	
784	XCTest, `Tests/UITests/<Flow>UITests.swift`, one class per P0 flow from `product.md`. Use accessibility identifiers set by view-generator (`ds.<screen>.<element>`). If identifiers are missing, list them and redirect to view-generator before writing the test. Launch with `-uiTesting` argument so the app uses `AppEnvironment.test` seeded data.
785	
786	## Step 6. Register and hand off
787	
788	Append every file to `Docs/file-map.md`. Add a `## Test coverage` section to `Docs/Features/<Name>.md` listing rule IDs and AC IDs covered.
789	
790	Tell the user:
791	
792	> [n] test files, [n] mocks, [n] fixtures generated. Run `xcodebuild test -scheme <AppName>` or the Xcode test navigator. Say "audit the layers" to finish the feature with layer-auditor.
793	
794	## What this skill produces
795	
796	1. `Tests/UnitTests/<Layer>/<Feature>/<Type>Tests.swift`
797	2. `Tests/UnitTests/Mocks/Mock<Protocol>.swift`
798	3. `Tests/UnitTests/Fixtures/<Entity>+Fixture.swift`
799	4. `Tests/UITests/<Flow>UITests.swift`
800	
801	## Dependencies
802	
803	- Requires: `Docs/conventions.md`, `Docs/file-map.md`, the code under test
804	- Reads: `Docs/domain-model.md` rules table, `Docs/Features/*.md` acceptance criteria
805	- Feeds: feature-builder completion gate
806	
807	## Rules
808	
809	- Always one test file per type, mirroring the source path.
810	- Always cite the rule or AC ID in the test name.
811	- Never use a mocking library. Hand-written recording mocks only.
812	- Never rewrite an existing test file. Append cases.
813	- Never touch network, disk or keychain in unit tests.
814	- Never use em dashes in any output file.
815	################ layer-auditor ################
816	---
817	name: layer-auditor
818	description: >
819	  Verify total consistency between layers and documentation: every import respects the dependency direction, every protocol has one implementation registered in the container, every ViewModel maps every error, every screen in a spec has a View and a ViewModel, every rule has a test, and Docs/file-map.md equals the disk. Produces Docs/audit-<date>.md with a pass or fail verdict. Use this skill whenever the user says "audit the layers", "check consistency", "is the architecture respected", "what is missing", "pre-release check", "review the project", "audite les couches", "vérifie la cohérence", "l'architecture est-elle respectée", "qu'est-ce qui manque", "revue du projet", or as the final gate of feature-builder. Requires ios-project-foundation and architecture-designer.
820	---
821	
822	# Layer Auditor
823	
824	## Prerequisites check
825	
826	Check for `Docs/conventions.md`, `Docs/architecture.md` and `Docs/file-map.md`. If missing, say:
827	
828	> The audit checks code against architecture.md and conventions.md. Run the foundation skills first.
829	
830	Then stop. If present, read all three plus `Docs/domain-model.md`, `Docs/design-system.md`, every `Docs/Features/*.md`. Go straight to Step 1.
831	
832	## Step 1. Scope
833	
834	Call AskUserQuestion:
835	
836	```json
837	[
838	  {
839	    "question": "Audit scope?",
840	    "header": "Scope",
841	    "multiSelect": false,
842	    "options": [
843	      {"label": "Whole project", "description": "Every check, every file"},
844	      {"label": "One feature", "description": "Vertical slice from spec to tests"},
845	      {"label": "Docs versus disk", "description": "Only file-map.md synchronisation"}
846	    ]
847	  }
848	]
849	```
850	
851	## Step 2. Run the checks
852	
853	Each check produces pass, warn or fail with a list of offenders.
854	
855	**C1. Dependency direction**
856	Grep every file's imports. Domain: only Foundation. Data: never SwiftUI, never a Features type. Presentation: never a Data type (`Impl`, `DTO`, `DataSource`, `Model` @Model). DesignSystem: never Domain, never Features. Fail on any violation.
857	
858	**C2. One type per file, name equals file**
859	Parse top-level declarations. Fail on mismatch.
860	
861	**C3. Protocol coverage**
862	Every `Repository`, `UseCase`, `DataSource`, `Navigating` protocol has exactly one non-mock implementation and one factory or property in `Core/DI/`. Warn on zero implementations, fail on two.
863	
864	**C4. Spec to code**
865	For each `Docs/Features/<Name>.md`, every screen listed has `<Screen>View.swift` and `<Screen>ViewModel.swift` in file-map.md, every entity listed exists in `Domain/Entities/`, every acceptance criterion ID appears in at least one test name. Fail on missing view or viewmodel, warn on missing test.
866	
867	**C5. Rules to tests**
868	Every rule ID in the `## Business rules` table appears in at least one test name. Warn on gaps.
869	
870	**C6. Error mapping**
871	Every `case` of every domain error enum is handled in at least one ViewModel `message(for:)` or equivalent, or falls into a documented default. Warn on unmapped cases.
872	
873	**C7. Navigation**
874	Every `<Feature>Route` case is handled in `view(for:)`. Every `navigate(to:)` call in ViewModels targets an existing case. No `NavigationLink(destination:)` anywhere in Features. Fail on any.
875	
876	**C8. Design system**
877	No `Color(red:`, `Color(hex:`, `.font(.system(size:`, or numeric padding literals in Features or DesignSystem/Components. Warn.
878	
879	**C9. Safety**
880	No `!` force unwrap on optionals outside tests and previews, no `try!`, no `as!`, no `fatalError` outside preconditions in `AppEnvironment`. Fail.
881	
882	**C10. Registry**
883	file-map.md rows equal the set of `.swift` files on disk, minus build artefacts. Fail on drift, and list both directions.
884	
885	**C11. Dead documentation**
886	Every ADR referenced in code comments exists. Every feature spec with `Status: specified` older than the newest code file in its folder is flagged as possibly stale. Warn.
887	
888	## Step 3. Write the report
889	
890	`Docs/audit-<YYYY-MM-DD>.md`:
891	
892	```
893	# Audit <date>
894	
895	Scope: <scope>
896	Verdict: PASS | FAIL (<n> fails, <n> warns)
897	
898	| Check | Result | Offenders |
899	|---|---|---|
900	| C1 Dependency direction | pass | |
901	| C3 Protocol coverage | fail | ClientRepository: no implementation |
902	| ... | | |
903	
904	## Fix plan
905	[Ordered list: offender, responsible skill, one-line action]
906	1. ClientRepository has no implementation → data-layer-generator → "generate the data layer for Clients"
907	2. AC-4 of Invoices untested → test-generator → "generate tests for CreateInvoiceUseCase"
908	```
909	
910	Register the report in `Docs/file-map.md` with Layer `Docs`.
911	
912	## Step 4. Offer fixes
913	
914	Call AskUserQuestion:
915	
916	```json
917	[
918	  {
919	    "question": "Next?",
920	    "header": "Fix",
921	    "multiSelect": false,
922	    "options": [
923	      {"label": "Fix C10 now", "description": "Synchronise file-map.md with disk immediately"},
924	      {"label": "Walk the fix plan", "description": "Trigger each responsible skill in order"},
925	      {"label": "Stop here", "description": "I will handle it"}
926	    ]
927	  }
928	]
929	```
930	
931	C10 is the only check this skill fixes itself. Everything else is delegated to the responsible skill by name. Never patch code from the auditor.
932	
933	## Step 5. Hand off
934	
935	Tell the user:
936	
937	> Audit written to Docs/audit-<date>.md. Verdict: [PASS | FAIL]. [n] items in the fix plan, each mapped to the skill that owns it.
938	
939	## What this skill produces
940	
941	1. `Docs/audit-<date>.md` with verdict, table and ordered fix plan
942	2. Optionally, a synchronised `Docs/file-map.md`
943	
944	## Dependencies
945	
946	- Requires: `Docs/conventions.md`, `Docs/architecture.md`, `Docs/file-map.md`
947	- Reads: `Docs/domain-model.md`, `Docs/design-system.md`, `Docs/Features/*.md`
948	- Delegates to: every generator skill, code-deduplicator
949	
950	## Rules
951	
952	- Always run every check in scope. Never skip a check because it is slow.
953	- Always name the responsible skill for every offender.
954	- Never edit source code from this skill. Only file-map.md.
955	- A FAIL verdict blocks feature-builder from declaring a feature done.
956	- Never use em dashes in any output file.
957	################ code-deduplicator ################
958	---
959	name: code-deduplicator
960	description: >
961	  Detect and eliminate duplicated code and dead code across the project: identical or near-identical functions, repeated view fragments, parallel types, unused files, unreferenced symbols. Factorises into the correct layer, deletes what is dead, and keeps Docs/file-map.md truthful. Use this skill whenever the user says "dedupe", "find duplicates", "remove dead code", "clean up", "factorise", "this looks copied", "unused files", "déduplique", "trouve les doublons", "supprime le code mort", "nettoie", "factorise", "fichiers inutilisés", or at the end of every feature-builder run. Requires ios-project-foundation.
962	---
963	
964	# Code Deduplicator
965	
966	## Prerequisites check
967	
968	Check for `Docs/conventions.md` and `Docs/file-map.md`. If missing, say:
969	
970	> Deduplication works against the file map. Run ios-project-foundation first.
971	
972	Then stop. If present, read both. Go straight to Step 1.
973	
974	## Step 1. Scope
975	
976	Call AskUserQuestion:
977	
978	```json
979	[
980	  {
981	    "question": "Where to look?",
982	    "header": "Scope",
983	    "multiSelect": false,
984	    "options": [
985	      {"label": "Whole project", "description": "Every .swift file"},
986	      {"label": "One feature", "description": "Features/<Name> plus its Domain and Data folders"},
987	      {"label": "One layer", "description": "Domain, Data, Presentation or DesignSystem"},
988	      {"label": "Since last run", "description": "Files changed after the last entry in Docs/dedup-log.md"}
989	    ]
990	  }
991	]
992	```
993	
994	## Step 2. Scan
995	
996	Run four passes and collect findings. Use grep, ripgrep or a script in `scripts/` if the project is large.
997	
998	**Pass A. Exact and near duplicates**
999	- Functions with identical bodies modulo whitespace and identifier names
1000	- View bodies with the same modifier chain and structure
1001	- Types with the same stored properties under different names (`InvoiceRowItem` vs `InvoiceCellModel`)
1002	- Extensions declaring the same helper on the same type in two files
1003	
1004	**Pass B. Semantic duplicates**
1005	- Two mappers converting the same pair of types
1006	- Two error to message tables for the same error enum
1007	- Formatting logic (dates, money, percentages) implemented in more than one place
1008	- Validation of the same value object in a ViewModel and in Domain
1009	
1010	**Pass C. Dead code**
1011	- Files in `file-map.md` that no longer exist on disk, and files on disk absent from `file-map.md`
1012	- Types with zero references outside their own file (excluding App entry, previews, tests)
1013	- Functions, properties, parameters and imports never used
1014	- Feature folders whose spec is `Status: cut` in `Docs/product.md`
1015	- Commented-out code blocks over 5 lines
1016	
1017	**Pass D. Layer leaks that create duplication**
1018	- A rule implemented in Domain and again in a ViewModel guard
1019	- A DTO used directly by a View instead of the entity
1020	
1021	## Step 3. Report
1022	
1023	Output one table before changing anything:
1024	
1025	```
1026	| ID | Kind | Location A | Location B | Proposed action | Target layer |
1027	|---|---|---|---|---|---|
1028	| D-01 | near duplicate | InvoiceListViewModel.swift:88 | InvoiceDetailViewModel.swift:61 | extract InvoiceError+Message.swift | Presentation |
1029	| D-02 | semantic | Invoice+Formatting.swift | InvoiceRow.swift:22 | keep Domain? no, move to InvoiceRowItem | Presentation |
1030	| X-01 | dead file | Core/Utilities/Legacy.swift | | delete | |
1031	| X-02 | unused func | InvoiceMapper.swift:40 toLegacyDTO | | delete | |
1032	```
1033	
1034	Target layer follows conventions.md:
1035	- Formatting for display: Presentation model (`<Screen>+Models.swift`)
1036	- Rule or calculation: Domain (business-logic-engine owns it, redirect if new)
1037	- Generic view fragment: DesignSystem (swiftui-component-library owns it, redirect if it needs design)
1038	- Generic Swift helper on a Foundation type: `Core/Extensions/<Type>+<Concern>.swift`, one concern per file, never a catch-all
1039	
1040	Call AskUserQuestion with three options: apply all, choose by ID, cancel. Wait.
1041	
1042	## Step 4. Apply
1043	
1044	For each approved item:
1045	1. Create the single canonical implementation at the target path (or reuse the surviving one).
1046	2. Replace every duplicate call site with a call to the canonical one. Show before and after per site.
1047	3. Delete the duplicate definitions and dead files with `git rm` when in a git repo.
1048	4. Update `Docs/file-map.md`: add the canonical file, remove deleted files.
1049	5. If tests exist for a deleted symbol, delete or redirect them and say so.
1050	
1051	Build check: if a build command is available (`xcodebuild` or `swift build`), run it. If not, list every touched file so the user can build.
1052	
1053	## Step 5. Log
1054	
1055	Append to `Docs/dedup-log.md` (create with a title if absent):
1056	
1057	```
1058	## <date>
1059	Scope: <scope>
1060	Applied: D-01, D-02, X-01
1061	Skipped: X-02 (user kept it)
1062	Files touched: <n>. Lines removed: <n>.
1063	```
1064	
1065	## Step 6. Hand off
1066	
1067	Tell the user:
1068	
1069	> Removed [n] duplicates and [n] dead items. file-map.md is in sync with disk. Say "generate tests" to cover the factorised code, or "audit the layers" to run layer-auditor.
1070	
1071	## What this skill produces
1072	
1073	1. Factorised canonical implementations in the correct layer
1074	2. Deleted duplicate and dead code
1075	3. `Docs/dedup-log.md` entry and a synchronised `Docs/file-map.md`
1076	
1077	## Dependencies
1078	
1079	- Requires: `Docs/conventions.md`, `Docs/file-map.md`
1080	- May redirect to: business-logic-engine, swiftui-component-library
1081	- Feeds: test-generator, layer-auditor
1082	
1083	## Rules
1084	
1085	- Always report the full table and get approval before deleting anything.
1086	- Never factorise into a catch-all file. One concern per file.
1087	- Never move a rule into Presentation to make deduplication easier. Domain wins.
1088	- Never delete a file referenced by the Xcode project without stating that the reference must be removed.
1089	- Always keep file-map.md equal to the disk after the run.
1090	- Never use em dashes in any output file.
1091	################ business-logic-engine ################
1092	---
1093	name: business-logic-engine
1094	description: >
1095	  Extract and implement business rules as pure, testable domain services and entity methods. Turns acceptance criteria and product rules into Swift logic that lives in Domain, never in ViewModels or Views. Produces Domain/Services/ files and a rules table in Docs/domain-model.md. Use this skill whenever the user says "write the business rules", "implement the logic for", "validation rules", "calculation logic", "domain service", "the rule is", "règles métier", "logique métier", "implémente la règle", "calcul de", "validation de", or when a use case needs a rule that spans several entities. Requires domain-modeler.
1096	---
1097	
1098	# Business Logic Engine
1099	
1100	## Prerequisites check
1101	
1102	Check for `Docs/conventions.md` and `Docs/domain-model.md`. If either is missing, say:
1103	
1104	> Business rules attach to entities. Run domain-modeler first ("model the domain").
1105	
1106	Then stop. If present, read both, plus `Docs/Features/*.md` and `Docs/file-map.md`. Go straight to Step 1.
1107	
1108	## Step 1. Collect the rules
1109	
1110	Call AskUserQuestion:
1111	
1112	```json
1113	[
1114	  {
1115	    "question": "Where do the rules come from?",
1116	    "header": "Source",
1117	    "multiSelect": false,
1118	    "options": [
1119	      {"label": "Feature specs", "description": "Extract from acceptance criteria in Docs/Features/*.md"},
1120	      {"label": "I will describe them", "description": "I will type the rules in chat"},
1121	      {"label": "Existing code", "description": "Find rules currently buried in ViewModels or Views and move them"}
1122	    ]
1123	  }
1124	]
1125	```
1126	
1127	If "Existing code": grep `Features/` for `if`, `guard`, `switch`, arithmetic and `Date` logic inside ViewModels and Views. List every candidate rule with its file and line. These are extraction targets.
1128	
1129	## Step 2. Write the rules table
1130	
1131	Every rule gets an ID and a home before any code:
1132	
1133	```
1134	| ID | Rule (plain language) | Inputs | Output | Home | Feature |
1135	|---|---|---|---|---|---|
1136	| R-01 | An invoice cannot be paid twice | Invoice.status | InvoiceError.alreadyPaid | Invoice.markPaid() | Invoices |
1137	| R-02 | Total = sum(lines) + VAT, rounded to 2 decimals | [InvoiceLine], VATRate | Money | InvoiceTotalCalculator | Invoices |
1138	```
1139	
1140	Home decision:
1141	- Rule touches one entity's own state: entity method (mutating or computed)
1142	- Rule touches several entities or needs a policy: domain service in `Domain/Services/<Feature>/<Name>.swift`
1143	- Rule is a pure calculation: `struct <Name>Calculator` with a single `calculate` method, stateless
1144	
1145	Call AskUserQuestion to approve the table. Iterate, maximum 3 rounds.
1146	
1147	## Step 3. Implement
1148	
1149	Entity methods are added to the existing entity file, or to `<Entity>+Rules.swift` next to it if the entity file would exceed 150 lines.
1150	
1151	Domain services:
1152	
1153	```swift
1154	// InvoiceTotalCalculator.swift
1155	// Layer: Domain
1156	// Purpose: R-02 invoice total with VAT
1157	
1158	import Foundation
1159	
1160	struct InvoiceTotalCalculator: Sendable {
1161	    func calculate(lines: [InvoiceLine], vatRate: VATRate) -> Money {
1162	        let subtotal = lines.reduce(Money.zero) { $0 + $1.amount }
1163	        return subtotal.applying(vatRate).rounded(scale: 2)
1164	    }
1165	}
1166	```
1167	
1168	Every rule implementation carries its rule ID in the Purpose line. No rule without an ID. No ID without a test (test-generator reads this table).
1169	
1170	If a rule needs data the entity does not have, stop and say which field is missing. Do not add fields silently. Send the user to domain-modeler.
1171	
1172	## Step 4. Remove extracted duplicates
1173	
1174	If Step 1 found rules in ViewModels or Views: after the domain implementation exists, replace the original code with a call to the domain method. Show every replacement as before and after in chat before applying. Never leave the old logic in place.
1175	
1176	## Step 5. Update Docs/domain-model.md
1177	
1178	Add or update a `## Business rules` section with the approved table. Register new files in `Docs/file-map.md`.
1179	
1180	## Step 6. Hand off
1181	
1182	Tell the user:
1183	
1184	> [n] rules implemented in Domain, all traceable by ID. Say "generate the use cases" to wire them, or "generate tests" to cover every rule.
1185	
1186	## What this skill produces
1187	
1188	1. Entity methods and domain services under `Domain/`
1189	2. `## Business rules` table in `Docs/domain-model.md`
1190	
1191	## Dependencies
1192	
1193	- Requires: `Docs/domain-model.md` (domain-modeler), `Docs/conventions.md`
1194	- Feeds: use-case-generator, test-generator, code-deduplicator
1195	
1196	## Rules
1197	
1198	- Always give every rule an ID before implementing it.
1199	- Always keep rules in Domain. Never in a ViewModel, never in a View, never in Data.
1200	- Never add a field to an entity here. Redirect to domain-modeler.
1201	- Never import anything but Foundation.
1202	- Domain services are stateless structs. If it needs state, it is an entity.
1203	- Never leave extracted logic duplicated at its original site.
1204	- Never use em dashes in any output file.
1205	
~~~~

#### 2026-09-10 23:35:12 +0200 (21:35:12Z) · TOOL CALL · Bash
`f88478cc` · `3b35f3b3` · ligne 170 · Read the SwiftUI expert skill and state management reference

~~~~bash
SP="/private/tmp/claude-501/-Volumes-Steve-Pro-BlackSSD-Dev-App-Mobile-Iris/f88478cc-d512-4210-bc11-758059278995/scratchpad/skills/swiftui-agent-skill/SwiftUI-Agent-Skill-main"; cat "$SP/skills/swiftui-expert-skill/SKILL.md"; echo "################ state-management ################"; cat "$SP/skills/swiftui-expert-skill/references/state-management.md" | head -250
~~~~

#### 2026-09-10 23:35:12 +0200 (21:35:12Z) · TOOL RESULT · Bash
`f88478cc` · `e6d2f91b` · ligne 171 · Read the SwiftUI expert skill and state management reference

~~~~text
---
name: swiftui-expert-skill
description: Use when writing, reviewing, or refactoring SwiftUI code for iOS or macOS, including state management and `@Observable` data flow, view composition and invalidation/performance, lists and `ForEach` identity, environment usage, localization, animations, Liquid Glass adoption, migrating soft-deprecated APIs, or Instruments `.trace` capture/analysis for hangs, hitches, CPU hotspots, or
  excessive view updates.
---

# SwiftUI Expert Skill

## Operating Rules

- Consult `references/latest-apis.md` at the start of every task to avoid deprecated APIs
- Prefer native SwiftUI APIs over UIKit/AppKit bridging unless bridging is necessary
- Focus on correctness and performance; do not enforce specific architectures (MVVM, VIPER, etc.)
- Encourage separating business logic from views for testability without mandating how
- Follow Apple's Human Interface Guidelines and API design patterns
- Only adopt Liquid Glass when explicitly requested by the user (see `references/liquid-glass.md`)
- Present performance optimizations as suggestions, not requirements
- Use `#available` gating with sensible fallbacks for version-specific APIs

## Task Workflow

### Review existing SwiftUI code
- Read the code under review and identify which topics apply
- Flag deprecated APIs (compare against `references/latest-apis.md`)
- Run the Topic Router below for each relevant topic
- Validate `#available` gating and fallback paths for iOS 26+ features

### Improve existing SwiftUI code
- Audit current implementation against the Topic Router topics
- Replace deprecated APIs with modern equivalents from `references/latest-apis.md`
- Refactor hot paths to reduce unnecessary state updates
- Extract complex view bodies into separate subviews
- Suggest image downsampling when `UIImage(data:)` is encountered (optional optimization, see `references/image-optimization.md`)

### Implement new SwiftUI feature
- Design data flow first: identify owned vs injected state
- Structure views for optimal diffing (extract subviews early)
- Apply correct animation patterns (implicit vs explicit, transitions)
- Use `Button` for all tappable elements; add accessibility grouping and labels
- Gate version-specific APIs with `#available` and provide fallbacks

### Record a new Instruments trace
Trigger when the user asks to "record a trace", "profile the app", "capture a session", etc. Full reference: `references/trace-recording.md`.

1. **Confirm target** — attach to a running app, launch an app, or record all processes? If the user didn't say, ask. List connected devices when useful:
   ```bash
   python3 "${SKILL_DIR}/scripts/record_trace.py" --list-devices
   ```
2. **Pick a template based on target kind** — the `SwiftUI` template populates the SwiftUI lane on any **real device**: a physical iOS/iPadOS device **or the host Mac**. The only exception is the **iOS Simulator**, where the SwiftUI lane comes back empty — switch to `--template "Time Profiler"` in that case (still gives Time Profiler + Hangs + Animation Hitches). Always check `--list-devices`: `simulators` kind → `Time Profiler`; `devices` kind (real devices and the host Mac) → default `SwiftUI`. Full decision table in `references/trace-recording.md`.
3. **Start the recording**. For agent-driven sessions where the user says "I'll tell you when I'm done", start in the background and use a stop-file:
   ```bash
   python3 "${SKILL_DIR}/scripts/record_trace.py" \
       --device "<name|udid>" --attach "<AppName>" \
       --stop-file /tmp/stop-trace --output ~/Desktop/session.trace
   ```
   For interactive sessions, just tell the user to press Ctrl+C when done.
4. **Signal stop** — when the user says they've finished exercising the app, `touch /tmp/stop-trace`. The script cleanly SIGINTs xctrace and waits up to 60s for finalisation.
5. **Analyse** the resulting trace (flow into the "Trace-driven improvement" workflow below).

### Trace-driven improvement (Instruments `.trace` provided)
Trigger whenever the user's request references a `.trace` file. A target SwiftUI source file is **optional** — if given, cite specific lines; if not, recommend where to look based on view names and symbols the trace already reveals.

Full reference: `references/trace-analysis.md`. Summary of the composition pattern:

1. **Scope the analysis.** Ask yourself: does the user want the whole trace, or a slice?
   - "focus on X / after X / between X and Y / during X" → **resolve to a window first** (see step 2).
   - No scoping cue → analyse the whole trace.
2. **Resolve a window (only if the user scoped).** The parser exposes two discovery modes:
   ```bash
   # Find a log that marks the start/end of the region of interest:
   python3 "${SKILL_DIR}/scripts/analyze_trace.py" --trace <path> \
       --list-logs --log-message-contains "loaded feed" --log-limit 5
   # Or list os_signpost intervals (paired begin/end), filterable by name:
   python3 "${SKILL_DIR}/scripts/analyze_trace.py" --trace <path> \
       --list-signposts --signpost-name-contains "ImageDecode"
   ```
   Both modes accept `--window START_MS:END_MS` to scope discovery. Pick the `time_ms` (for logs) or `start_ms`/`end_ms` (for signposts) that match the user's description. Build a window like `--window 10400:11700`.
3. **Run the main analysis** (with or without `--window`):
   ```bash
   python3 "${SKILL_DIR}/scripts/analyze_trace.py" --trace <path> \
       --json-only --top 10 [--window START_MS:END_MS]
   ```
4. **Interpret with `references/trace-analysis.md`** — key diagnostics:
   - `main_running_coverage_pct` inside each correlation (<25% = blocked; ≥75% = CPU-bound).
   - `swiftui-causes.top_sources` reveals *why* updates keep happening — high-edge-count sources like `UserDefaultObserver.send()` or wide `EnvironmentWriter` entries are structural invalidation bugs. Fixing one often collapses many downstream hot views.
5. **When a specific view shows as expensive, ask who's invalidating it.** Use `--fanin-for "<view name>"` to get the ranked list of source nodes driving the updates.
6. **Optionally ground in source.** If the user pointed at a file, read it and match view names / user-code symbols against identifiers there. If not, recommend which files to open based on the view names SwiftUI reported.
7. **Return a prioritised plan.** Cite evidence (coverage %, hot symbol, overlapping view, log timestamp, cause-graph edges) and route each recommendation to a Topic Router reference.
8. Only edit code if the user asked for edits.

### Topic Router

Consult the reference file for each topic relevant to the current task:

| Topic | Reference |
|-------|-----------|
| State management | `references/state-management.md` |
| View composition | `references/view-structure.md` |
| Performance | `references/performance-patterns.md` |
| Lists and ForEach | `references/list-patterns.md` |
| Layout | `references/layout-best-practices.md` |
| Sheets and navigation | `references/sheet-navigation-patterns.md` |
| ScrollView, scroll position, and scroll geometry | `references/scroll-patterns.md` |
| Focus management | `references/focus-patterns.md` |
| Animations (basics) | `references/animation-basics.md` |
| Animations (transitions) | `references/animation-transitions.md` |
| Animations (advanced) | `references/animation-advanced.md` |
| Accessibility | `references/accessibility-patterns.md` |
| Swift Charts | `references/charts.md` |
| Charts accessibility | `references/charts-accessibility.md` |
| Image optimization | `references/image-optimization.md` |
| Liquid Glass (iOS 26+) | `references/liquid-glass.md` |
| macOS scenes | `references/macos-scenes.md` |
| macOS window styling | `references/macos-window-styling.md` |
| macOS views | `references/macos-views.md` |
| Text patterns | `references/text-patterns.md` |
| Localization | `references/localization.md` |
| Deprecated API lookup | `references/latest-apis.md` |
| Handling soft-deprecated APIs | `references/soft-deprecation.md` |
| Previews | `references/previews.md` |
| Instruments trace analysis | `references/trace-analysis.md` |
| Instruments trace recording | `references/trace-recording.md` |

## Correctness Checklist

These are hard rules -- violations are always bugs:

- [ ] `@State` properties are `private`
- [ ] `@Binding` only where a child modifies parent state
- [ ] Passed values never declared as `@State` or `@StateObject` (they ignore updates)
- [ ] `@StateObject` for view-owned objects; `@ObservedObject` for injected
- [ ] iOS 17+: `@State` with `@Observable`; `@Bindable` for injected observables needing bindings
- [ ] `ForEach` uses stable identity (never `.indices`/`\.offset`; id outlives the view and isn't derived from mutable content)
- [ ] Constant number of views per `ForEach` element; `List` rows are unary
- [ ] No closures stored in custom `@Environment`/`@FocusedValue` keys
- [ ] Custom `@Entry` default values are stable (no `Model()`/`Date()`/`UUID()` expressions)
- [ ] `.animation(_:value:)` always includes the `value` parameter
- [ ] `@FocusState` properties are `private`
- [ ] No redundant `@FocusState` writes inside tap gesture handlers on `.focusable()` views
- [ ] iOS 26+ APIs gated with `#available` and fallback provided
- [ ] `import Charts` present in files using chart types
- [ ] Previews use self-contained mock data; no dependency on live services or network

## References

- `references/latest-apis.md` -- **Read first for every task.** Deprecated-to-modern API transitions (iOS 15+ through iOS 26+)
- `references/state-management.md` -- Property wrappers, data flow, `@Observable` migration
- `references/view-structure.md` -- View extraction, container patterns, `@ViewBuilder`
- `references/performance-patterns.md` -- Hot-path optimization, update control, `_logChanges()`
- `references/list-patterns.md` -- ForEach identity, Table (iOS 16+), inline filtering pitfalls
- `references/layout-best-practices.md` -- Layout patterns, GeometryReader alternatives
- `references/accessibility-patterns.md` -- VoiceOver, Dynamic Type, grouping, traits
- `references/animation-basics.md` -- Implicit/explicit animations, timing, performance
- `references/animation-transitions.md` -- View transitions, `matchedGeometryEffect`, `Animatable`
- `references/animation-advanced.md` -- Phase/keyframe animations (iOS 17+), `@Animatable` macro (iOS 26+)
- `references/charts.md` -- Swift Charts marks, axes, selection, styling, Chart3D (iOS 26+)
- `references/charts-accessibility.md` -- Charts VoiceOver, Audio Graph, fallback strategies
- `references/sheet-navigation-patterns.md` -- Sheets, NavigationSplitView, Inspector
- `references/scroll-patterns.md` -- ScrollViewReader, scroll geometry, programmatic scrolling, target behaviors
- `references/focus-patterns.md` -- Focus state, focusable views, focused values, default focus, common pitfalls
- `references/image-optimization.md` -- AsyncImage, downsampling, caching
- `references/liquid-glass.md` -- iOS 26+ Liquid Glass effects and fallback patterns
- `references/macos-scenes.md` -- Settings, MenuBarExtra, WindowGroup, multi-window
- `references/macos-window-styling.md` -- Toolbar styles, window sizing, Commands
- `references/macos-views.md` -- HSplitView, Table, PasteButton, AppKit interop
- `references/previews.md` -- `#Preview` macro, `@Previewable` (iOS 18+), preview traits, mock data patterns for self-contained previews
- `references/text-patterns.md` -- Text initializer selection, verbatim vs localized
- `references/localization.md` -- String Catalogs, `#bundle` for packages, `LocalizedStringResource`, locale-aware formatting, RTL layout, translator comments
- `references/soft-deprecation.md` -- How to behave with soft-deprecated APIs (when to migrate, scoping rule, don't migrate during unrelated edits)
- `references/trace-analysis.md` -- Parse Instruments `.trace` files via `scripts/analyze_trace.py`; interpret main-thread coverage, high-severity SwiftUI updates, hitch narratives, and map findings back to source files
- `references/trace-recording.md` -- Record a new trace via `scripts/record_trace.py`: attach to a running app, launch one fresh, or capture a manually-stopped session; supports stop-file for agent-driven flows
################ state-management ################
# SwiftUI State Management Reference

## Table of Contents

- [Property Wrapper Selection Guide](#property-wrapper-selection-guide)
- [@State](#state)
- [Property Wrappers Inside @Observable Classes](#property-wrappers-inside-observable-classes)
- [Make @Observable Property Types Equatable](#make-observable-property-types-equatable)
- [@Observable Dependency Granularity](#observable-dependency-granularity)
- [@Binding](#binding)
- [@FocusState](#focusstate)
- [@StateObject vs @ObservedObject (Legacy - Pre-iOS 17)](#stateobject-vs-observedobject-legacy---pre-ios-17)
- [Don't Pass Values as @State](#dont-pass-values-as-state)
- [@Bindable (iOS 17+)](#bindable-ios-17)
- [let vs var for Passed Values](#let-vs-var-for-passed-values)
- [Environment and Preferences](#environment-and-preferences)
- [Decision Flowchart](#decision-flowchart)
- [State Privacy Rules](#state-privacy-rules)
- [Avoid Nested ObservableObject](#avoid-nested-observableobject)
- [Key Principles](#key-principles)

## Property Wrapper Selection Guide

| Wrapper | Use When | Notes |
|---------|----------|-------|
| `@State` | Internal view state that triggers updates | Must be `private` |
| `@Binding` | Child view needs to modify parent's state | Don't use for read-only |
| `@Bindable` | iOS 17+: View receives `@Observable` object and needs bindings | For injected observables |
| `let` | Read-only value passed from parent | Simplest option |
| `var` | Read-only value that child observes via `.onChange()` | For reactive reads |

**Legacy (Pre-iOS 17):**
| Wrapper | Use When | Notes |
|---------|----------|-------|
| `@StateObject` | View owns an `ObservableObject` instance | Use `@State` with `@Observable` instead |
| `@ObservedObject` | View receives an `ObservableObject` from outside | Never create inline |

## @State

Always mark `@State` properties as `private`. Use for internal view state that triggers UI updates.

```swift
// Correct
@State private var isAnimating = false
@State private var selectedTab = 0
```

**Why Private?** Marking state as `private` makes it clear what's created by the view versus what's passed in. It also prevents accidentally passing initial values that will be ignored (see "Don't Pass Values as @State" below).

### iOS 17+ with @Observable (Preferred)

**Always prefer `@Observable` over `ObservableObject`.** With iOS 17's `@Observable` macro, use `@State` instead of `@StateObject`:

```swift
@Observable
@MainActor  // Always mark @Observable classes with @MainActor
final class DataModel {
    var name = "Some Name"
    var count = 0
}

struct MyView: View {
    @State private var model = DataModel()  // Use @State, not @StateObject

    var body: some View {
        VStack {
            TextField("Name", text: $model.name)
            Stepper("Count: \(model.count)", value: $model.count)
        }
    }
}
```

**Critical**: When a view *owns* an `@Observable` object, always use `@State` -- not `let`. Without `@State`, SwiftUI may recreate the instance when a parent view redraws, losing accumulated state. `@State` tells SwiftUI to preserve the instance across view redraws. Using `@State` also provides bindings directly (no need for `@Bindable`).

**Note**: You may want to mark `@Observable` classes with `@MainActor` to ensure thread safety with SwiftUI, unless your project or package uses Default Actor Isolation set to `MainActor`—in which case, the explicit attribute is redundant and can be omitted.

## Property Wrappers Inside @Observable Classes

**Critical**: The `@Observable` macro transforms stored properties to add observation tracking. Property wrappers (like `@AppStorage`, `@SceneStorage`, `@Query`) also transform properties with their own storage. These two transformations conflict, causing a compiler error.

**Always annotate property-wrapper properties with `@ObservationIgnored` inside `@Observable` classes.**

```swift
@Observable
@MainActor
final class SettingsModel {
    // WRONG - compiler error: property wrappers conflict with @Observable
    // @AppStorage("username") var username = ""

    // CORRECT - @ObservationIgnored prevents the conflict
    @ObservationIgnored @AppStorage("username") var username = ""
    @ObservationIgnored @AppStorage("isDarkMode") var isDarkMode = false

    // Regular stored properties work fine with @Observable
    var isLoading = false
}
```

This applies to **any** property wrapper used inside an `@Observable` class, including but not limited to:
- `@AppStorage`
- `@SceneStorage`
- `@Query` (SwiftData)

**Note**: Since `@ObservationIgnored` disables observation tracking for that property, SwiftUI won't detect changes through the Observation framework. However, property wrappers like `@AppStorage` already notify SwiftUI of changes through their own mechanisms (e.g., UserDefaults KVO), so views still update correctly.

**Never remove `@ObservationIgnored`** from property-wrapper properties in `@Observable` classes — doing so causes a compiler error.

## Make @Observable Property Types Equatable

The `@Observable` macro generates a setter that **skips invalidation when the new value equals the current one** — but only when it can compare them, which means only when the property's type is `Equatable`. Without that conformance, every assignment notifies observing views, even when the value is identical. This is an easy win for properties written frequently with the same value (polling, streaming updates, timers).

```swift
// AVOID: not Equatable — every assignment invalidates, even no-op writes
enum DeliveryStatus { case placed, preparing, shipped, delivered }

// PREFER: Equatable lets the generated setter short-circuit redundant writes
enum DeliveryStatus: Equatable { case placed, preparing, shipped, delivered }
```

This applies to collection properties too: an `Array`/`Set`/`Dictionary` is only `Equatable` when its element type is, so a non-`Equatable` element defeats the short-circuit for the whole collection. (The check is emitted into the generated setter as user code, so it applies on every OS that supports `@Observable` when built with current Xcode.)

This is distinct from `Equatable` *views* (see `references/performance-patterns.md`): that conformance lets SwiftUI skip a view's body; this one lets the model skip notifying observers in the first place.

## @Observable Dependency Granularity

Observation tracks reads at the **property** level, not the field level — so reading any part of a compound property establishes a dependency on the whole thing. Three common traps and their fixes:

- **A computed property establishes dependencies transitively.** `var currentUser: User? { users.first { $0.id == currentID } }` reads `users` in its body, so any view reading `currentUser` depends on the entire `users` array. Renaming the access doesn't change what observation tracks.
- **A struct-typed stored property drags the whole struct.** A view reading `session.user.name` depends on `session.user`; editing any other field of `user` invalidates it.
- **An array/collection read drags the whole collection.** Reading one element establishes a dependency on the entire stored collection.

```swift
// PREFER: cache derived values as stored properties, kept in sync in didSet
@MainActor @Observable
final class AppState {
    var users: [User] = [] { didSet { recomputeCurrentUser() } }
    var currentID: User.ID? { didSet { recomputeCurrentUser() } }

    private(set) var currentUser: User?
    private func recomputeCurrentUser() { currentUser = users.first { $0.id == currentID } }
}
```

For struct-typed properties, expose the fields the views actually read as individual properties on the model (each is then tracked separately). When many rows each observe several fields of their element, model each element as its own `@Observable` and have the parent **persist** the instances — see the per-item view model pattern in `references/performance-patterns.md`. Reading several already-narrow properties from one model is fine and does not need splitting.

## @Binding

Use only when child view needs to **modify** parent's state. If child only reads the value, use `let` instead.

```swift
// Parent
struct ParentView: View {
    @State private var isSelected = false

    var body: some View {
        ChildView(isSelected: $isSelected)
    }
}

// Child - will modify the value
struct ChildView: View {
    @Binding var isSelected: Bool

    var body: some View {
        Button("Toggle") {
            isSelected.toggle()
        }
    }
}
```

### When NOT to use @Binding

- **Don't use `@Binding` for read-only values.** If the child only displays the value and never modifies it, use `let` instead. `@Binding` adds unnecessary overhead and implies a write contract that doesn't exist.

### Declare a Binding with @Binding, Not a Plain Property

A binding you react to must be `@Binding var x: T`. SwiftUI subscribes only to `DynamicProperty` properties (`@State`, `@Binding`, `@Environment`, …); a binding held in an undecorated property (`let x: Binding<T>`) is just a value it never looks inside, so external changes to the bound value don't re-evaluate the view.

```swift
struct SelectionBadge: View {
    // let selection: Binding<Item?>   // WRONG - untracked; external changes missed
    @Binding var selection: Item?      // CORRECT - DynamicProperty, tracked

    var body: some View { Text(selection?.name ?? "None") }
}
```

Debug builds can mask this with extra graph passes, so it often fails only in Release. It bites hardest in `UIViewRepresentable`/`NSViewRepresentable`, where the missing re-evaluation means `updateUIView(_:context:)` never runs (e.g. a presented controller that won't dismiss when its bound item is reset).

### Prefer KeyPath Bindings Over Closure Bindings

When you need a binding into a model, prefer a KeyPath/subscript-based binding over a hand-written `Binding(get:set:)` closure. A closure binding allocates a new closure each time `body` runs and can't be compared, which can trigger unnecessary invalidations.

```swift
// BAD - closure binding: heap allocation each body pass, defeats comparison
let binding = Binding(
    get: { model[scoreFor: player] },
    set: { model[scoreFor: player] = $0 }
)
PlayerScoreRow(player: player, score: binding)

// GOOD - project through a subscript with @Bindable
@Bindable var model = model
PlayerScoreRow(player: player, score: $model[scoreFor: player])
```

If no suitable subscript exists, add one (a labeled subscript reads as a clean projection into the model). Reserve closure bindings for cases where no key path or subscript can express the transform.

## @FocusState

See `references/focus-patterns.md` for comprehensive focus management guidance including `@FocusState`, `@FocusedValue`, `.focusable()`, default focus, and common pitfalls.

Always mark `@FocusState` as `private`.

## @StateObject vs @ObservedObject (Legacy - Pre-iOS 17)

**Note**: Always prefer `@Observable` with `@State` for iOS 17+.

The key distinction is **ownership**: `@StateObject` when the view **creates and owns** the object; `@ObservedObject` when the view **receives** it from outside.

```swift
// View creates it → @StateObject
@StateObject private var viewModel = MyViewModel()

// View receives it → @ObservedObject
@ObservedObject var viewModel: MyViewModel
```

**Never** create an `ObservableObject` inline with `@ObservedObject` -- it recreates the instance on every view update.

### @StateObject instantiation in View's initializer

Prefer storing the `@StateObject` in the parent view and passing it down. If you must create one in a custom initializer, pass the expression directly to `StateObject(wrappedValue:)` so the `@autoclosure` prevents redundant allocations:

```swift
// Inside a View's init(movie:):
// WRONG — assigning to a local first defeats @autoclosure
let vm = MovieDetailsViewModel(movie: movie)
_viewModel = StateObject(wrappedValue: vm)

// CORRECT — inline expression defers creation
_viewModel = StateObject(wrappedValue: MovieDetailsViewModel(movie: movie))
```

**Modern Alternative**: Use `@Observable` with `@State` instead.

## Don't Pass Values as @State
~~~~

#### 2026-09-10 23:35:13 +0200 (21:35:13Z) · TOOL CALL · Bash
`f88478cc` · `e708a13c` · ligne 173 · Check code signing identities, xcodegen version and connected devices

~~~~bash
echo "=== signing identities ==="; security find-identity -v -p codesigning 2>&1 | head -10; echo "=== xcodegen version ==="; xcodegen --version; echo "=== device details ==="; xcrun devicectl list devices 2>/dev/null | head -12
~~~~

#### 2026-09-10 23:35:17 +0200 (21:35:17Z) · TOOL RESULT · Bash
`f88478cc` · `cd171100` · ligne 180 · Check code signing identities, xcodegen version and connected devices

~~~~text
=== signing identities ===
  1) 8F64140AD42A212BC2F71324B43037C6D5C0A47F "Apple Development: Stéphane SAULNIER (NKN63DTRM4)"
  2) 5DBA7A011768D5366552727FE5F0C6FC4A3FDF5A "Developer ID Application: Stéphane SAULNIER (G4U9RG5GL7)"
  3) D9B3FDE0BADEC18BE60472E4482334F217892A03 "Apple Development: Stéphane SAULNIER (NKN63DTRM4)"
  4) F0677401E7D9EEC827C03CC65CD79467625789A1 "Apple Distribution: Stéphane SAULNIER (G4U9RG5GL7)"
     4 valid identities found
=== xcodegen version ===
Version: 2.45.4
=== device details ===
Name                 Hostname                              Identifier                             State                Model                                       
------------------   -----------------------------------   ------------------------------------   ------------------   --------------------------------------------
Séjour TV            Sejour-TV.coredevice.local            7A7AFC39-E31F-5599-95AC-8EA83CC7FE4D   available (paired)   Apple TV 4K (3rd generation) (AppleTV14,1)  
The Grey             The-Grey.coredevice.local             21ABC186-DEFC-59C7-9671-85E4FA69DA9A   available (paired)   iPhone 15 Pro (iPhone16,1)                  
iPad de Priscille    iPad-de-Priscille.coredevice.local    42AB57B3-BB5A-56CF-A721-05235432564A   unavailable          iPad Pro (10.5-inch) (Model A1701) (iPad7,3)
iPhone SE Stéphane   iPhone-SE-Stephane.coredevice.local   B9D57E7E-7069-5E47-ABA1-73A3668B571E   unavailable          iPhone SE (iPhone12,8)                      
iPhone Steve.        iPhone-Steve.coredevice.local         CD9242BD-9650-52C9-BBA6-A30490C6DFA8   available (paired)   iPhone 14 Pro (iPhone15,2)
~~~~

#### 2026-09-10 23:35:33 +0200 (21:35:33Z) · TOOL CALL · Bash
`f88478cc` · `fbc0cde7` · ligne 186 · List SwiftUI reference file sizes

~~~~bash
SP="/private/tmp/claude-501/-Volumes-Steve-Pro-BlackSSD-Dev-App-Mobile-Iris/f88478cc-d512-4210-bc11-758059278995/scratchpad/skills/swiftui-agent-skill/SwiftUI-Agent-Skill-main/skills/swiftui-expert-skill/references"; wc -c "$SP"/*.md | sort -n | tail -30
~~~~

#### 2026-09-10 23:35:33 +0200 (21:35:33Z) · TOOL RESULT · Bash
`f88478cc` · `cb598896` · ligne 187 · List SwiftUI reference file sizes

~~~~text
    1405 /private/tmp/claude-501/-Volumes-Steve-Pro-BlackSSD-Dev-App-Mobile-Iris/f88478cc-d512-4210-bc11-758059278995/scratchpad/skills/swiftui-agent-skill/SwiftUI-Agent-Skill-main/skills/swiftui-expert-skill/references/text-patterns.md
    3002 /private/tmp/claude-501/-Volumes-Steve-Pro-BlackSSD-Dev-App-Mobile-Iris/f88478cc-d512-4210-bc11-758059278995/scratchpad/skills/swiftui-agent-skill/SwiftUI-Agent-Skill-main/skills/swiftui-expert-skill/references/soft-deprecation.md
    5939 /private/tmp/claude-501/-Volumes-Steve-Pro-BlackSSD-Dev-App-Mobile-Iris/f88478cc-d512-4210-bc11-758059278995/scratchpad/skills/swiftui-agent-skill/SwiftUI-Agent-Skill-main/skills/swiftui-expert-skill/references/trace-recording.md
    6073 /private/tmp/claude-501/-Volumes-Steve-Pro-BlackSSD-Dev-App-Mobile-Iris/f88478cc-d512-4210-bc11-758059278995/scratchpad/skills/swiftui-agent-skill/SwiftUI-Agent-Skill-main/skills/swiftui-expert-skill/references/accessibility-patterns.md
    6291 /private/tmp/claude-501/-Volumes-Steve-Pro-BlackSSD-Dev-App-Mobile-Iris/f88478cc-d512-4210-bc11-758059278995/scratchpad/skills/swiftui-agent-skill/SwiftUI-Agent-Skill-main/skills/swiftui-expert-skill/references/charts-accessibility.md
    6865 /private/tmp/claude-501/-Volumes-Steve-Pro-BlackSSD-Dev-App-Mobile-Iris/f88478cc-d512-4210-bc11-758059278995/scratchpad/skills/swiftui-agent-skill/SwiftUI-Agent-Skill-main/skills/swiftui-expert-skill/references/animation-basics.md
    6944 /private/tmp/claude-501/-Volumes-Steve-Pro-BlackSSD-Dev-App-Mobile-Iris/f88478cc-d512-4210-bc11-758059278995/scratchpad/skills/swiftui-agent-skill/SwiftUI-Agent-Skill-main/skills/swiftui-expert-skill/references/layout-best-practices.md
    7373 /private/tmp/claude-501/-Volumes-Steve-Pro-BlackSSD-Dev-App-Mobile-Iris/f88478cc-d512-4210-bc11-758059278995/scratchpad/skills/swiftui-agent-skill/SwiftUI-Agent-Skill-main/skills/swiftui-expert-skill/references/image-optimization.md
    7626 /private/tmp/claude-501/-Volumes-Steve-Pro-BlackSSD-Dev-App-Mobile-Iris/f88478cc-d512-4210-bc11-758059278995/scratchpad/skills/swiftui-agent-skill/SwiftUI-Agent-Skill-main/skills/swiftui-expert-skill/references/animation-transitions.md
    8327 /private/tmp/claude-501/-Volumes-Steve-Pro-BlackSSD-Dev-App-Mobile-Iris/f88478cc-d512-4210-bc11-758059278995/scratchpad/skills/swiftui-agent-skill/SwiftUI-Agent-Skill-main/skills/swiftui-expert-skill/references/previews.md
    8815 /private/tmp/claude-501/-Volumes-Steve-Pro-BlackSSD-Dev-App-Mobile-Iris/f88478cc-d512-4210-bc11-758059278995/scratchpad/skills/swiftui-agent-skill/SwiftUI-Agent-Skill-main/skills/swiftui-expert-skill/references/macos-window-styling.md
    8903 /private/tmp/claude-501/-Volumes-Steve-Pro-BlackSSD-Dev-App-Mobile-Iris/f88478cc-d512-4210-bc11-758059278995/scratchpad/skills/swiftui-agent-skill/SwiftUI-Agent-Skill-main/skills/swiftui-expert-skill/references/focus-patterns.md
    9297 /private/tmp/claude-501/-Volumes-Steve-Pro-BlackSSD-Dev-App-Mobile-Iris/f88478cc-d512-4210-bc11-758059278995/scratchpad/skills/swiftui-agent-skill/SwiftUI-Agent-Skill-main/skills/swiftui-expert-skill/references/macos-scenes.md
    9920 /private/tmp/claude-501/-Volumes-Steve-Pro-BlackSSD-Dev-App-Mobile-Iris/f88478cc-d512-4210-bc11-758059278995/scratchpad/skills/swiftui-agent-skill/SwiftUI-Agent-Skill-main/skills/swiftui-expert-skill/references/localization.md
   10839 /private/tmp/claude-501/-Volumes-Steve-Pro-BlackSSD-Dev-App-Mobile-Iris/f88478cc-d512-4210-bc11-758059278995/scratchpad/skills/swiftui-agent-skill/SwiftUI-Agent-Skill-main/skills/swiftui-expert-skill/references/scroll-patterns.md
   10873 /private/tmp/claude-501/-Volumes-Steve-Pro-BlackSSD-Dev-App-Mobile-Iris/f88478cc-d512-4210-bc11-758059278995/scratchpad/skills/swiftui-agent-skill/SwiftUI-Agent-Skill-main/skills/swiftui-expert-skill/references/sheet-navigation-patterns.md
   10874 /private/tmp/claude-501/-Volumes-Steve-Pro-BlackSSD-Dev-App-Mobile-Iris/f88478cc-d512-4210-bc11-758059278995/scratchpad/skills/swiftui-agent-skill/SwiftUI-Agent-Skill-main/skills/swiftui-expert-skill/references/macos-views.md
   11345 /private/tmp/claude-501/-Volumes-Steve-Pro-BlackSSD-Dev-App-Mobile-Iris/f88478cc-d512-4210-bc11-758059278995/scratchpad/skills/swiftui-agent-skill/SwiftUI-Agent-Skill-main/skills/swiftui-expert-skill/references/animation-advanced.md
   11899 /private/tmp/claude-501/-Volumes-Steve-Pro-BlackSSD-Dev-App-Mobile-Iris/f88478cc-d512-4210-bc11-758059278995/scratchpad/skills/swiftui-agent-skill/SwiftUI-Agent-Skill-main/skills/swiftui-expert-skill/references/liquid-glass.md
   13225 /private/tmp/claude-501/-Volumes-Steve-Pro-BlackSSD-Dev-App-Mobile-Iris/f88478cc-d512-4210-bc11-758059278995/scratchpad/skills/swiftui-agent-skill/SwiftUI-Agent-Skill-main/skills/swiftui-expert-skill/references/performance-patterns.md
   14415 /private/tmp/claude-501/-Volumes-Steve-Pro-BlackSSD-Dev-App-Mobile-Iris/f88478cc-d512-4210-bc11-758059278995/scratchpad/skills/swiftui-agent-skill/SwiftUI-Agent-Skill-main/skills/swiftui-expert-skill/references/trace-analysis.md
   15801 /private/tmp/claude-501/-Volumes-Steve-Pro-BlackSSD-Dev-App-Mobile-Iris/f88478cc-d512-4210-bc11-758059278995/scratchpad/skills/swiftui-agent-skill/SwiftUI-Agent-Skill-main/skills/swiftui-expert-skill/references/list-patterns.md
   17219 /private/tmp/claude-501/-Volumes-Steve-Pro-BlackSSD-Dev-App-Mobile-Iris/f88478cc-d512-4210-bc11-758059278995/scratchpad/skills/swiftui-agent-skill/SwiftUI-Agent-Skill-main/skills/swiftui-expert-skill/references/charts.md
   18096 /private/tmp/claude-501/-Volumes-Steve-Pro-BlackSSD-Dev-App-Mobile-Iris/f88478cc-d512-4210-bc11-758059278995/scratchpad/skills/swiftui-agent-skill/SwiftUI-Agent-Skill-main/skills/swiftui-expert-skill/references/latest-apis.md
   21237 /private/tmp/claude-501/-Volumes-Steve-Pro-BlackSSD-Dev-App-Mobile-Iris/f88478cc-d512-4210-bc11-758059278995/scratchpad/skills/swiftui-agent-skill/SwiftUI-Agent-Skill-main/skills/swiftui-expert-skill/references/state-management.md
   29540 /private/tmp/claude-501/-Volumes-Steve-Pro-BlackSSD-Dev-App-Mobile-Iris/f88478cc-d512-4210-bc11-758059278995/scratchpad/skills/swiftui-agent-skill/SwiftUI-Agent-Skill-main/skills/swiftui-expert-skill/references/view-structure.md
  282143 total
~~~~

#### 2026-09-10 23:35:36 +0200 (21:35:36Z) · TOOL CALL · Bash
`f88478cc` · `d2f218e2` · ligne 189 · Concatenate key SwiftUI references into a scratch file

~~~~bash
SP="/private/tmp/claude-501/-Volumes-Steve-Pro-BlackSSD-Dev-App-Mobile-Iris/f88478cc-d512-4210-bc11-758059278995/scratchpad/skills/swiftui-agent-skill/SwiftUI-Agent-Skill-main/skills/swiftui-expert-skill/references"; OUT="/private/tmp/claude-501/-Volumes-Steve-Pro-BlackSSD-Dev-App-Mobile-Iris/f88478cc-d512-4210-bc11-758059278995/scratchpad/skills/swiftui-refs.txt"; for f in latest-apis performance-patterns view-structure accessibility-patterns animation-basics previews; do echo "################ $f ################"; cat "$SP/$f.md"; done > "$OUT"; wc -c "$OUT"
~~~~

#### 2026-09-10 23:35:37 +0200 (21:35:37Z) · TOOL RESULT · Bash
`f88478cc` · `c269e28c` · ligne 190 · Concatenate key SwiftUI references into a scratch file

~~~~text
   82427 /private/tmp/claude-501/-Volumes-Steve-Pro-BlackSSD-Dev-App-Mobile-Iris/f88478cc-d512-4210-bc11-758059278995/scratchpad/skills/swiftui-refs.txt
~~~~

#### 2026-09-10 23:35:39 +0200 (21:35:39Z) · TOOL CALL · Read
`f88478cc` · `b22a83eb` · ligne 199

~~~~json
{
 "file_path": "/private/tmp/claude-501/-Volumes-Steve-Pro-BlackSSD-Dev-App-Mobile-Iris/f88478cc-d512-4210-bc11-758059278995/scratchpad/skills/swiftui-refs.txt"
}
~~~~

#### 2026-09-10 23:35:40 +0200 (21:35:40Z) · TOOL RESULT · Read
`f88478cc` · `1f9df475` · ligne 200

~~~~text
1	################ latest-apis ################
2	# Latest SwiftUI APIs Reference
3	
4	> Based on a comparison of Apple's documentation using the Sosumi MCP, we found the latest recommended APIs to use.
5	
6	> This file lists *what* the modern replacements are. For *how to behave* when you find a soft-deprecated API — when to migrate, when to leave it alone, and the scoping rule for unrelated edits — see `references/soft-deprecation.md`. To refresh this list after a new SDK release, run the maintenance skill at `.agents/skills/update-swiftui-apis/SKILL.md`.
7	
8	## Table of Contents
9	- [Always Use (iOS 15+)](#always-use-ios-15)
10	- [When Targeting iOS 16+](#when-targeting-ios-16)
11	- [When Targeting iOS 17+](#when-targeting-ios-17)
12	- [When Targeting iOS 18+](#when-targeting-ios-18)
13	- [When Targeting iOS 26+](#when-targeting-ios-26)
14	
15	---
16	
17	## Always Use (iOS 15+)
18	
19	These APIs have been deprecated long enough that there is no reason to use the old variants.
20	
21	### Compact Replacements
22	
23	These replacements have minimal API shape changes. Most are near-direct swaps; a few require an additional parameter or structural adjustment:
24	
25	- **`navigationTitle(_:)`** instead of `navigationBarTitle(_:)`
26	- **`toolbar { ToolbarItem(...) }`** instead of `navigationBarItems(...)` (structural change)
27	- **`toolbarVisibility(.hidden, for: .navigationBar)`** instead of `navigationBarHidden(_:)`
28	- **`statusBarHidden(_:)`** instead of `statusBar(hidden:)`
29	- **`ignoresSafeArea(_:edges:)`** instead of `edgesIgnoringSafeArea(_:)`
30	- **`preferredColorScheme(_:)`** instead of `colorScheme(_:)`
31	- **`foregroundStyle(_:)`** instead of `foregroundColor(_:)` (e.g., `.foregroundStyle(.primary)`)
32	- **`clipShape(.rect(cornerRadius:))`** instead of `cornerRadius()`
33	- **`textInputAutocapitalization(_:)`** instead of `autocapitalization(_:)` (note: `.never` replaces `.none`)
34	- **`animation(_:value:)`** instead of `animation(_:)` (adds required `value:` parameter; back-deploys to iOS 13+)
35	
36	### Lists and Forms
37	
38	**Use trailing-closure `Section` initializers instead of the positional header/footer View initializers.**
39	
40	The single-title form is still current and should not be treated as deprecated:
41	
42	```swift
43	// Current - single-title LocalizedStringKey initializer
44	Section("Settings") {
45	    Toggle("Notifications", isOn: .constant(true))
46	}
47	
48	// Replacement - content/header/footer trailing-closure initializer
49	Section {
50	    Toggle("Notifications", isOn: .constant(true))
51	} header: {
52	    Text("Settings")
53	} footer: {
54	    Text("Changes apply immediately.")
55	}
56	
57	// Deprecated/renamed - positional header/footer View arguments
58	Section(header: Text("Settings"), footer: Text("Changes apply immediately.")) {
59	    Toggle("Notifications", isOn: .constant(true))
60	}
61	
62	Section(header: Text("Settings")) {
63	    Toggle("Notifications", isOn: .constant(true))
64	}
65	
66	Section(footer: Text("Changes apply immediately.")) {
67	    Toggle("Notifications", isOn: .constant(true))
68	}
69	```
70	
71	### Presentation
72	
73	- **Always use `.confirmationDialog(_:isPresented:actions:message:)`** instead of `actionSheet(...)`.
74	- **Always use `.alert(_:isPresented:actions:message:)`** instead of `alert(isPresented:content:)`.
75	
76	Both take a title `String`, `isPresented: Binding<Bool>`, an `actions` builder with `Button` items (supporting `role: .destructive` / `.cancel`), and an optional `message` builder:
77	
78	```swift
79	.alert("Delete Item?", isPresented: $showAlert) {
80	    Button("Delete", role: .destructive) { deleteItem() }
81	    Button("Cancel", role: .cancel) { }
82	} message: {
83	    Text("This action cannot be undone.")
84	}
85	```
86	
87	### Text Input
88	
89	**Always use `onSubmit(of:_:)` and `focused(_:equals:)` instead of `TextField` `onEditingChanged`/`onCommit` callbacks.**
90	
91	```swift
92	@FocusState private var isFocused: Bool
93	
94	TextField("Search", text: $query)
95	    .focused($isFocused)
96	    .onSubmit { performSearch() }
97	```
98	
99	### Accessibility
100	
101	**Always use dedicated accessibility modifiers instead of the generic `accessibility(...)` variants.** Use `.accessibilityLabel()`, `.accessibilityValue()`, `.accessibilityHint()`, `.accessibilityAddTraits()`, `.accessibilityHidden()` instead of `.accessibility(label:)`, `.accessibility(value:)`, etc.
102	
103	### Custom Environment / Container Values
104	
105	**Always use the `@Entry` macro instead of manual `EnvironmentKey` conformance.** The `@Entry` macro was introduced in Xcode 16 and back-deploys to all OS versions.
106	
107	```swift
108	// Modern — one line replaces ~10 lines of EnvironmentKey boilerplate
109	extension EnvironmentValues {
110	    @Entry var myCustomValue: String = "Default value"
111	}
112	```
113	
114	### Styling
115	
116	**Always use `Button` instead of `onTapGesture()` unless you need tap location or count.**
117	
118	```swift
119	Button("Tap me") { performAction() }
120	
121	// Use onTapGesture only when you need location or count
122	Image("photo")
123	    .onTapGesture(count: 2) { handleDoubleTap() }
124	```
125	
126	---
127	
128	## When Targeting iOS 16+
129	
130	### Navigation
131	
132	**Use `NavigationStack` (or `NavigationSplitView`) instead of `NavigationView`.** Value-based `NavigationLink(value:)` with `.navigationDestination(for:)` replaces destination-based links.
133	
134	```swift
135	NavigationStack {
136	    List(items) { item in
137	        NavigationLink(value: item) { Text(item.name) }
138	    }
139	    .navigationDestination(for: Item.self) { DetailView(item: $0) }
140	}
141	```
142	
143	### Simple Renames
144	
145	- **`tint(_:)`** instead of `accentColor(_:)`
146	- **`autocorrectionDisabled(_:)`** instead of `disableAutocorrection(_:)`
147	
148	### Clipboard
149	
150	**Prefer `PasteButton` for user-initiated paste UI** to avoid paste prompts. It handles permissions automatically. Use `UIPasteboard` only when you need programmatic or non-`Transferable` clipboard access (triggers the paste permission prompt).
151	
152	```swift
153	PasteButton(payloadType: String.self) { strings in
154	    pastedText = strings.first ?? ""
155	}
156	```
157	
158	---
159	
160	## When Targeting iOS 17+
161	
162	### State Management
163	
164	- **Prefer `@Observable` over `ObservableObject` for new code.** Use `@State` instead of `@StateObject`; use `@Bindable` instead of `@ObservedObject`. See `state-management.md` for full `@Observable` migration patterns.
165	
166	### Events
167	
168	**Use `onChange(of:initial:_:)` or `onChange(of:) { }` instead of `onChange(of:perform:)`.**
169	
170	The deprecated variant passes only the new value. The modern variants provide either both old and new values, or a no-parameter closure.
171	
172	- **No-parameter** (most common): `.onChange(of: value) { doSomething() }`
173	- **Old and new values**: `.onChange(of: value) { old, new in ... }`
174	- **With initial trigger**: `.onChange(of: value, initial: true) { ... }`
175	- **Deprecated**: `.onChange(of: value) { newValue in ... }` — single-parameter closure
176	
177	### Sensory Feedback
178	
179	**Prefer `sensoryFeedback(_:trigger:)` and related overloads instead of `UIImpactFeedbackGenerator`, `UISelectionFeedbackGenerator`, and `UINotificationFeedbackGenerator` in SwiftUI views.**
180	
181	Attach haptics declaratively to the view that owns the state change, rather than imperatively firing UIKit generators inside button actions.
182	
183	```swift
184	@State private var isFavorite = false
185	
186	Button("Favorite", systemImage: isFavorite ? "heart.fill" : "heart") {
187	    isFavorite.toggle()
188	}
189	.sensoryFeedback(.selection, trigger: isFavorite)
190	```
191	
192	Use the conditional overload when feedback should fire only for specific transitions:
193	
194	```swift
195	.sensoryFeedback(.selection, trigger: phase) { old, new in
196	    old == .inactive || new == .expanded
197	}
198	```
199	
200	### Gestures
201	
202	- **`MagnifyGesture`** instead of `MagnificationGesture` (access magnitude via `value.magnification`)
203	- **`RotateGesture`** instead of `RotationGesture` (access angle via `value.rotation`)
204	
205	### Layout
206	
207	**Consider `containerRelativeFrame()` or `visualEffect()` as alternatives to `GeometryReader` for sizing and position-based effects.** `GeometryReader` is not deprecated and remains necessary for many measurement-based layouts.
208	
209	```swift
210	Image("hero")
211	    .resizable()
212	    .containerRelativeFrame(.horizontal) { length, axis in length * 0.8 }
213	```
214	
215	- **`visualEffect { content, geometry in ... }`** — position-based effects (parallax, offsets) without a `GeometryReader` wrapper.
216	- **`onGeometryChange(for:of:action:)`** — react to geometry changes of a specific view; useful for driving state/effects. `GeometryReader` is still better when layout itself depends on geometry. Note the two-closure shape:
217	  ```swift
218	  .onGeometryChange(for: CGFloat.self) { proxy in proxy.size.height } action: { newHeight in height = newHeight }
219	  ```
220	- **`.coordinateSpace(.named("scroll"))`** instead of `.coordinateSpace(name: "scroll")`.
221	
222	---
223	
224	## When Targeting iOS 18+
225	
226	### Tabs
227	
228	**Use the `Tab` API instead of `tabItem(_:)`.**
229	
230	```swift
231	TabView {
232	    Tab("Home", systemImage: "house") { HomeView() }
233	    Tab("Search", systemImage: "magnifyingglass") { SearchView() }
234	    Tab("Profile", systemImage: "person") { ProfileView() }
235	}
236	```
237	
238	When using `Tab(role:)`, all tabs must use the `Tab` syntax. Mixing `Tab(role:)` with `.tabItem()` causes compilation errors.
239	
240	### Previews
241	
242	**Use `@Previewable` for dynamic properties in previews.**
243	
244	```swift
245	// Modern (iOS 18+)
246	#Preview {
247	    @Previewable @State var isOn = false
248	    Toggle("Setting", isOn: $isOn)
249	}
250	```
251	
252	---
253	
254	## When Targeting iOS 26+
255	
256	For Liquid Glass APIs (`glassEffect`, `GlassEffectContainer`, glass button styles), see [liquid-glass.md](liquid-glass.md).
257	
258	### Scroll Edge Effects
259	
260	**Use `scrollEdgeEffectStyle(_:for:)` to configure scroll edge behavior.**
261	
262	```swift
263	ScrollView {
264	    // content
265	}
266	.scrollEdgeEffectStyle(.soft, for: .top)
267	```
268	
269	### Background Extension
270	
271	**Use `backgroundExtensionEffect()` for edge-extending blurred backgrounds.**
272	
273	Views behind a Liquid Glass sidebar can appear clipped. This modifier mirrors and blurs content outside the safe area so artwork remains visible.
274	
275	```swift
276	Image("hero")
277	    .backgroundExtensionEffect()
278	```
279	
280	> Source: "Build a SwiftUI app with the new design" (WWDC25, session 323)
281	
282	### Tab Bar
283	
284	**Use `tabBarMinimizeBehavior(_:)` to control tab bar minimization on scroll.**
285	
286	```swift
287	TabView {
288	    // tabs
289	}
290	.tabBarMinimizeBehavior(.onScrollDown)
291	```
292	
293	**Use `tabViewBottomAccessory` for persistent controls above the tab bar.** Read `tabViewBottomAccessoryPlacement` from the environment to adapt content when the accessory collapses into the tab bar area.
294	
295	```swift
296	TabView {
297	    // tabs
298	}
299	.tabViewBottomAccessory {
300	    NowPlayingBar()
301	}
302	```
303	
304	**Use `Tab(role: .search)` for a dedicated search tab.** The tab separates from the rest and morphs into a search field when selected.
305	
306	```swift
307	TabView {
308	    Tab("Home", systemImage: "house") { HomeView() }
309	    Tab("Profile", systemImage: "person") { ProfileView() }
310	    Tab(role: .search) { SearchResultsView() }
311	}
312	```
313	
314	> Source: "What's new in SwiftUI" (WWDC25, session 256) and "Build a SwiftUI app with the new design" (WWDC25, session 323)
315	
316	### Toolbars
317	
318	**Use `ToolbarSpacer` to control grouping of toolbar items.** Fixed spacers visually separate related groups; flexible spacers push items apart.
319	
320	```swift
321	.toolbar {
322	    ToolbarItem(placement: .topBarTrailing) {
323	        Button("Up", systemImage: "chevron.up") { }
324	    }
325	    ToolbarItem(placement: .topBarTrailing) {
326	        Button("Down", systemImage: "chevron.down") { }
327	    }
328	    ToolbarSpacer(.fixed)
329	    ToolbarItem(placement: .topBarTrailing) {
330	        Button("Settings", systemImage: "gear") { }
331	    }
332	}
333	```
334	
335	**Use `sharedBackgroundVisibility(.hidden)` to remove the glass group background from an individual toolbar item.**
336	
337	```swift
338	ToolbarItem(placement: .topBarTrailing) {
339	    Image(systemName: "person.circle.fill")
340	        .sharedBackgroundVisibility(.hidden)
341	}
342	```
343	
344	**Use `badge(_:)` on toolbar item content to display an indicator.**
345	
346	```swift
347	ToolbarItem(placement: .topBarTrailing) {
348	    Button("Notifications", systemImage: "bell") { }
349	        .badge(unreadCount)
350	}
351	```
352	
353	> Source: "Build a SwiftUI app with the new design" (WWDC25, session 323)
354	
355	### Search
356	
357	**Use `searchToolbarBehavior(.minimizable)` to opt into a minimized search button.** The system may automatically minimize search into a toolbar button depending on available space. Use this modifier to explicitly opt in.
358	
359	```swift
360	NavigationStack {
361	    ContentView()
362	        .searchable(text: $query)
363	        .searchToolbarBehavior(.minimizable)
364	}
365	```
366	
367	> Source: "Build a SwiftUI app with the new design" (WWDC25, session 323)
368	
369	### Animations
370	
371	**Use `@Animatable` macro instead of manual `animatableData` declarations.** The macro auto-synthesizes `animatableData` from all animatable properties. Use `@AnimatableIgnored` to exclude specific properties.
372	
373	```swift
374	@Animatable
375	struct Wedge: Shape {
376	    var startAngle: Angle
377	    var endAngle: Angle
378	    @AnimatableIgnored var drawClockwise: Bool
379	
380	    func path(in rect: CGRect) -> Path { /* ... */ }
381	}
382	```
383	
384	> Source: "What's new in SwiftUI" (WWDC25, session 256)
385	
386	### Presentations
387	
388	**Use `navigationZoomTransition` to morph sheets out of their source view.** Toolbar items and buttons can serve as the transition source.
389	
390	```swift
391	.toolbar {
392	    ToolbarItem {
393	        Button("Add", systemImage: "plus") { showSheet = true }
394	            .navigationTransitionSource(id: "addSheet", namespace: namespace)
395	    }
396	}
397	.sheet(isPresented: $showSheet) {
398	    AddItemView()
399	        .navigationTransitionDestination(id: "addSheet", namespace: namespace)
400	}
401	```
402	
403	> Source: "Build a SwiftUI app with the new design" (WWDC25, session 323)
404	
405	### Controls
406	
407	**Use `controlSize(.extraLarge)` for extra-large prominent action buttons.**
408	
409	```swift
410	Button("Get Started") { }
411	    .buttonStyle(.borderedProminent)
412	    .controlSize(.extraLarge)
413	```
414	
415	**Use `concentric` corner style for buttons that match their container's corners.**
416	
417	```swift
418	Button("Confirm") { }
419	    .clipShape(.rect(cornerRadius: 12, style: .concentric))
420	```
421	
422	**Sliders now support tick marks and a neutral value.**
423	
424	```swift
425	Slider(value: $speed, in: 0.5...2.0, step: 0.25) {
426	    Text("Speed")
427	} ticks: {
428	    SliderTick(value: 0.6)
429	    SliderTick(value: 0.9)
430	}
431	.sliderNeutralValue(1.0)
432	```
433	
434	> Source: "Build a SwiftUI app with the new design" (WWDC25, session 323)
435	
436	### Rich Text
437	
438	**Use `TextEditor` with an `AttributedString` binding for rich text editing.** Supports bold, italic, underline, strikethrough, custom fonts, foreground/background colors, paragraph styles, and Genmoji.
439	
440	```swift
441	@State private var text: AttributedString = "Hello, world!"
442	
443	var body: some View {
444	    TextEditor(text: $text)
445	}
446	```
447	
448	> Source: "Cook up a rich text experience in SwiftUI with AttributedString" (WWDC25, session 280)
449	
450	### Web Content
451	
452	**Use `WebView` to display web content.** For richer interaction, create a `WebPage` observable model.
453	
454	```swift
455	// Simple URL display
456	WebView(url: URL(string: "https://example.com")!)
457	
458	// With observable model
459	@State private var page = WebPage()
460	
461	WebView(page)
462	    .onAppear { page.load(URLRequest(url: myURL)) }
463	    .navigationTitle(page.title ?? "")
464	```
465	
466	> Source: "Meet WebKit for SwiftUI" (WWDC25, session 231)
467	
468	### Drag and Drop
469	
470	**Use `dragContainer` for multi-item drag operations.** Combine with `DragConfiguration` for custom drag behavior and `onDragSessionUpdated` to observe events.
471	
472	```swift
473	PhotoGrid(photos: photos)
474	    .dragContainer(for: Photo.self) { selection in
475	        return selection.map { $0.transferable }
476	    }
477	    .onDragSessionUpdated { session in
478	        if session.phase == .endedWithDelete {
479	            deleteSelectedPhotos()
480	        }
481	    }
482	```
483	
484	> Source: "What's new in SwiftUI" (WWDC25, session 256)
485	
486	### Scene Bridging
487	
488	**UIKit and AppKit lifecycle apps can now request SwiftUI scenes.** This enables using SwiftUI-only scene types like `MenuBarExtra` and `ImmersiveSpace` from imperative lifecycle apps via `UIApplication.shared.activateSceneSession(for:errorHandler:)`.
489	
490	> Source: "What's new in SwiftUI" (WWDC25, session 256)
491	
492	---
493	
494	## Quick Lookup Table
495	
496	| Deprecated | Recommended | Since |
497	|-----------|-------------|-------|
498	| `navigationBarTitle(_:)` | `navigationTitle(_:)` | iOS 15+ |
499	| `navigationBarItems(...)` | `toolbar { ToolbarItem(...) }` | iOS 15+ |
500	| `navigationBarHidden(_:)` | `toolbarVisibility(.hidden, for: .navigationBar)` | iOS 15+ |
501	| `statusBar(hidden:)` | `statusBarHidden(_:)` | iOS 15+ |
502	| `edgesIgnoringSafeArea(_:)` | `ignoresSafeArea(_:edges:)` | iOS 15+ |
503	| `colorScheme(_:)` | `preferredColorScheme(_:)` | iOS 15+ |
504	| `foregroundColor(_:)` | `foregroundStyle(_:)` | iOS 15+ |
505	| `cornerRadius(_:)` | `clipShape(.rect(cornerRadius:))` | iOS 15+ |
506	| `actionSheet(...)` | `confirmationDialog(...)` | iOS 15+ |
507	| `alert(isPresented:content:)` | `alert(_:isPresented:actions:message:)` | iOS 15+ |
508	| `autocapitalization(_:)` | `textInputAutocapitalization(_:)` | iOS 15+ |
509	| `accessibility(label:)` etc. | `accessibilityLabel()` etc. | iOS 15+ |
510	| `TextField` `onCommit`/`onEditingChanged` | `onSubmit` + `focused` | iOS 15+ |
511	| `animation(_:)` (no value) | `animation(_:value:)` | Back-deploys (iOS 13+) |
512	| `Section(header:content:)` | `Section(content:header:)` | Future-deprecated |
513	| `Section(footer:content:)` | `Section(content:footer:)` | Future-deprecated |
514	| `Section(header:footer:content:)` | `Section(content:header:footer:)` | Future-deprecated |
515	| Manual `EnvironmentKey` | `@Entry` macro | Back-deploys (Xcode 16+) |
516	| `NavigationView` | `NavigationStack` / `NavigationSplitView` | iOS 16+ |
517	| `accentColor(_:)` | `tint(_:)` | iOS 16+ |
518	| `disableAutocorrection(_:)` | `autocorrectionDisabled(_:)` | iOS 16+ |
519	| `UIPasteboard.general` | `PasteButton` | iOS 16+ |
520	| `onChange(of:perform:)` | `onChange(of:) { }` or `onChange(of:) { old, new in }` | iOS 17+ |
521	| `UIImpactFeedbackGenerator` / `UISelectionFeedbackGenerator` / `UINotificationFeedbackGenerator` | `sensoryFeedback(_:trigger:)` | iOS 17+ |
522	| `MagnificationGesture` | `MagnifyGesture` | iOS 17+ |
523	| `RotationGesture` | `RotateGesture` | iOS 17+ |
524	| `coordinateSpace(name:)` | `coordinateSpace(.named(...))` | iOS 17+ |
525	| `ObservableObject` | `@Observable` | iOS 17+ |
526	| `tabItem(_:)` | `Tab` API | iOS 18+ |
527	| Manual `animatableData` | `@Animatable` macro | iOS 26+ |
528	| `presentationBackground(_:)` on sheets | Default Liquid Glass sheet material | iOS 26+ |
529	| Custom toolbar background hacks | `scrollEdgeEffectStyle(_:for:)` | iOS 26+ |
530	################ performance-patterns ################
531	# SwiftUI Performance Patterns Reference
532	
533	## Table of Contents
534	
535	- [Performance Optimization](#performance-optimization)
536	- [Anti-Patterns](#anti-patterns)
537	- [Summary Checklist](#summary-checklist)
538	
539	## Performance Optimization
540	
541	### 1. Avoid Redundant State Updates
542	
543	SwiftUI doesn't compare values before triggering updates:
544	
545	```swift
546	// BAD - triggers update even if value unchanged
547	.onReceive(publisher) { value in
548	    self.currentValue = value  // Always triggers body re-evaluation
549	}
550	
551	// GOOD - only update when different
552	.onReceive(publisher) { value in
553	    if self.currentValue != value {
554	        self.currentValue = value
555	    }
556	}
557	```
558	
559	### 2. Optimize Hot Paths
560	
561	Hot paths are frequently executed code (scroll handlers, animations, gestures):
562	
563	```swift
564	// BAD - updates state on every scroll position change
565	.onPreferenceChange(ScrollOffsetKey.self) { offset in
566	    shouldShowTitle = offset.y <= -32  // Fires constantly during scroll!
567	}
568	
569	// GOOD - only update when threshold crossed
570	.onPreferenceChange(ScrollOffsetKey.self) { offset in
571	    let shouldShow = offset.y <= -32
572	    if shouldShow != shouldShowTitle {
573	        shouldShowTitle = shouldShow  // Fires only when crossing threshold
574	    }
575	}
576	```
577	
578	### 3. Pass Only What Views Need
579	
580	**Avoid passing large "config" or "context" objects.** Pass only the specific values each view needs.
581	
582	```swift
583	// Good - pass specific values
584	ThemeSelector(theme: config.theme)
585	FontSizeSlider(fontSize: config.fontSize)
586	
587	// Avoid - passing entire config (creates broad dependency)
588	ThemeSelector(config: config)  // Notified of ALL config changes
589	```
590	
591	With `ObservableObject`, any `@Published` change triggers all observers. With `@Observable`, views update only when accessed properties change, but passing entire objects still creates broader dependencies than necessary.
592	
593	### 4. Use Equatable Views
594	
595	For views with expensive bodies, conform to `Equatable`:
596	
597	```swift
598	struct ExpensiveView: View, Equatable {
599	    let data: SomeData
600	
601	    static func == (lhs: Self, rhs: Self) -> Bool {
602	        lhs.data.id == rhs.data.id  // Custom equality check
603	    }
604	
605	    var body: some View {
606	        // Expensive computation
607	    }
608	}
609	
610	// Usage
611	ExpensiveView(data: data)
612	    .equatable()  // Use custom equality
613	```
614	
615	**Caution**: If you add new state or dependencies to your view, remember to update your `==` function!
616	
617	### 5. POD Views for Fast Diffing
618	
619	**POD (Plain Old Data) views use `memcmp` for fastest diffing.** A view is POD if it only contains simple value types and no property wrappers.
620	
621	```swift
622	// POD view - fastest diffing
623	struct FastView: View {
624	    let title: String
625	    let count: Int
626	    
627	    var body: some View {
628	        Text("\(title): \(count)")
629	    }
630	}
631	
632	// Non-POD view - uses reflection or custom equality
633	struct SlowerView: View {
634	    let title: String
635	    @State private var isExpanded = false  // Property wrapper makes it non-POD
636	    
637	    var body: some View {
638	        Text(title)
639	    }
640	}
641	```
642	
643	**Advanced Pattern**: Wrap expensive non-POD views in POD parent views:
644	
645	```swift
646	// POD wrapper for fast diffing
647	struct ExpensiveView: View {
648	    let value: Int
649	    
650	    var body: some View {
651	        ExpensiveViewInternal(value: value)
652	    }
653	}
654	
655	// Internal view with state
656	private struct ExpensiveViewInternal: View {
657	    let value: Int
658	    @State private var item: Item?
659	    
660	    var body: some View {
661	        // Expensive rendering
662	    }
663	}
664	```
665	
666	**Why**: The POD parent uses fast `memcmp` comparison. Only when `value` changes does the internal view get diffed.
667	
668	### 6. Lazy Loading
669	
670	Use lazy containers for large collections:
671	
672	```swift
673	// BAD - creates all views immediately
674	ScrollView {
675	    VStack {
676	        ForEach(items) { item in
677	            ExpensiveRow(item: item)
678	        }
679	    }
680	}
681	
682	// GOOD - creates views on demand
683	ScrollView {
684	    LazyVStack {
685	        ForEach(items) { item in
686	            ExpensiveRow(item: item)
687	        }
688	    }
689	}
690	```
691	
692	**iOS 26+ note**: Nested scroll views containing lazy stacks now automatically defer loading their children until they are about to appear, matching the behavior of top-level lazy stacks. This benefits patterns like horizontal photo carousels inside a vertical scroll view.
693	
694	> Source: "What's new in SwiftUI" (WWDC25, session 256)
695	
696	### 7. Task Cancellation
697	
698	Cancel async work when view disappears:
699	
700	```swift
701	struct DataView: View {
702	    @State private var data: [Item] = []
703	
704	    var body: some View {
705	        List(data) { item in
706	            Text(item.name)
707	        }
708	        .task {
709	            // Automatically cancelled when view disappears
710	            data = await fetchData()
711	        }
712	    }
713	}
714	```
715	
716	### 8. Debug View Updates
717	
718	**Use `Self._printChanges()` or `Self._logChanges()` to debug unexpected view updates.**
719	
720	```swift
721	struct DebugView: View {
722	    @State private var count = 0
723	    @State private var name = ""
724	    
725	    var body: some View {
726	        #if DEBUG
727	        let _ = Self._logChanges()  // Xcode 15.1+: logs to com.apple.SwiftUI subsystem
728	        #endif
729	        
730	        VStack {
731	            Text("Count: \(count)")
732	            Text("Name: \(name)")
733	        }
734	    }
735	}
736	```
737	
738	- `Self._printChanges()`: Prints which properties changed to standard output.
739	- `Self._logChanges()` (iOS 17+): Logs to the `com.apple.SwiftUI` subsystem with category "Changed Body Properties", using `os_log` for structured output.
740	
741	Both print `@self` when the view value itself changed and `@identity` when the view's persistent data was recycled.
742	
743	**Why**: This helps identify which state changes are causing view updates. Isolating redraw triggers into single-responsibility subviews is often the fix -- extracting a subview means SwiftUI can skip its body when its inputs haven't changed.
744	
745	### 9. Eliminate Unnecessary Dependencies
746	
747	**Narrow state scope to reduce update fan-out.** Instead of passing an entire `@Observable` model to a row view (which creates a dependency on all accessed properties), pass only the specific values the view needs as `let` properties.
748	
749	```swift
750	// Bad - broad dependency on entire model
751	struct ItemRow: View {
752	    @Environment(AppModel.self) private var model
753	    let item: Item
754	    var body: some View { Text(item.name).foregroundStyle(model.theme.primaryColor) }
755	}
756	
757	// Good - narrow dependency
758	struct ItemRow: View {
759	    let item: Item
760	    let themeColor: Color
761	    var body: some View { Text(item.name).foregroundStyle(themeColor) }
762	}
763	```
764	
765	**Avoid storing frequently-changing values in the environment.** Every write to *any* environment key forces every view that reads *any* key in that subtree to be checked. So a high-frequency value (scroll offset, window/container size, drag translation, per-frame animation progress, timer ticks, hover location) flowing into an `@Entry` or `.environment(\.key, value)` becomes an invalidation storm.
766	
767	Instead, hold the value in an `@Observable` model and expose a **coarsened** value — a boolean threshold rather than the raw measurement — so views invalidate only when crossing a meaningful boundary:
768	
769	```swift
770	@MainActor @Observable
771	final class ViewportModel {
772	    var width: CGFloat = 0 { didSet { isWide = width > 600 } }
773	    private(set) var isWide = false   // readers invalidate only when this flips
774	}
775	```
776	
777	The same shape applies per row in a list: storing the raw offset on a model and having every row read it still invalidates all visible rows every frame. Give each item its own `@Observable` whose properties track only that item's derived state (e.g. `isVisible`), so each row invalidates at most twice (enter/leave) regardless of scroll speed — see item #10 below.
778	
779	For purely visual effects driven by scroll position (opacity, scale, rotation), prefer `scrollTransition` or `visualEffect(in:)` — they push the per-frame work to the renderer and skip body re-evaluation entirely. Reach for the `@Observable` + coarsening pattern only when the scroll-derived value must drive non-rendering logic (model updates, prefetches, sibling state).
780	
781	> Source: "Optimize SwiftUI performance with Instruments" (WWDC25, session 306)
782	
783	### 10. @Observable Dependency Granularity
784	
785	**Consider per-item `@Observable` state holders (one per row/item) to narrow update scope.** When multiple list items share a dependency on the same `@Observable` array, changing one element causes all items to re-evaluate their bodies.
786	
787	```swift
788	// BAD - all item views depend on the full favorites array
789	@Observable
790	class ModelData {
791	    var favorites: [Landmark] = []
792	
793	    func isFavorite(_ landmark: Landmark) -> Bool {
794	        favorites.contains(landmark)
795	    }
796	}
797	
798	struct LandmarkRow: View {
799	    let landmark: Landmark
800	    @Environment(ModelData.self) private var model
801	
802	    var body: some View {
803	        HStack {
804	            Text(landmark.name)
805	            if model.isFavorite(landmark) {
806	                Image(systemName: "heart.fill")
807	            }
808	        }
809	    }
810	}
811	
812	// GOOD - each item has its own observable view model
813	@Observable
814	class LandmarkViewModel {
815	    var isFavorite: Bool = false
816	}
817	
818	struct LandmarkRow: View {
819	    let landmark: Landmark
820	    let viewModel: LandmarkViewModel
821	
822	    var body: some View {
823	        HStack {
824	            Text(landmark.name)
825	            if viewModel.isFavorite {
826	                Image(systemName: "heart.fill")
827	            }
828	        }
829	    }
830	}
831	```
832	
833	**Why**: With the bad pattern, toggling one favorite marks the entire array as changed, causing every `LandmarkRow` to re-run its body. With per-item view models, only the toggled item's body runs.
834	
835	> Source: "Optimize SwiftUI performance with Instruments" (WWDC25, session 306)
836	
837	### 11. Off-Main-Thread Closures
838	
839	**SwiftUI may call certain closures on a background thread for performance.** These closures must be `Sendable` and should avoid accessing `@MainActor`-isolated state directly. Instead, capture needed values in the closure's capture list.
840	
841	Closures that may run off the main thread:
842	- `Shape.path(in:)`
843	- `visualEffect` closure
844	- `Layout` protocol methods
845	- `onGeometryChange` transform closure
846	
847	```swift
848	// BAD - accessing @MainActor state directly
849	.visualEffect { content, geometry in
850	    content.blur(radius: self.pulse ? 5 : 0)  // Compiler error: @MainActor isolated
851	}
852	
853	// GOOD - capture the value
854	.visualEffect { [pulse] content, geometry in
855	    content.blur(radius: pulse ? 5 : 0)
856	}
857	```
858	
859	> Source: "Explore concurrency in SwiftUI" (WWDC25, session 266)
860	
861	### 12. Common Performance Issues
862	
863	**Be aware of common performance bottlenecks in SwiftUI:**
864	
865	- View invalidation storms from broad state changes
866	- Unstable identity in lists causing excessive diffing
867	- Heavy work in `body` (formatting, sorting, image decoding)
868	- Layout thrash from deep stacks or preference chains
869	
870	**When performance issues arise**, suggest the user profile with Instruments (SwiftUI template) to identify specific bottlenecks.
871	
872	## Anti-Patterns
873	
874	### 1. Creating Objects in Body
875	
876	```swift
877	// BAD - creates new formatter every body call
878	var body: some View {
879	    let formatter = DateFormatter()
880	    formatter.dateStyle = .long
881	    return Text(formatter.string(from: date))
882	}
883	
884	// GOOD - static or stored formatter
885	private static let dateFormatter: DateFormatter = {
886	    let f = DateFormatter()
887	    f.dateStyle = .long
888	    return f
889	}()
890	
891	var body: some View {
892	    Text(Self.dateFormatter.string(from: date))
893	}
894	```
895	
896	### 2. Heavy Computation in Body
897	
898	**Keep view body simple and pure.** Avoid side effects, dispatching, or complex logic.
899	
900	```swift
901	// BAD - sorts array every body call
902	var body: some View {
903	    List(items.sorted { $0.name < $1.name }) { item in Text(item.name) }
904	}
905	
906	// GOOD - compute once, update via onChange or a computed property in the model
907	@State private var sortedItems: [Item] = []
908	
909	var body: some View {
910	    List(sortedItems) { item in Text(item.name) }
911	        .onChange(of: items) { _, newItems in
912	            sortedItems = newItems.sorted { $0.name < $1.name }
913	        }
914	}
915	```
916	
917	Move sorting, filtering, and formatting into models or computed properties. The `body` should be a pure structural representation of state.
918	
919	### 3. Unnecessary State
920	
921	```swift
922	// BAD - derived state stored separately
923	@State private var items: [Item] = []
924	@State private var itemCount: Int = 0  // Unnecessary!
925	
926	// GOOD - compute derived values
927	@State private var items: [Item] = []
928	
929	var itemCount: Int { items.count }  // Computed property
930	```
931	
932	## Summary Checklist
933	
934	- [ ] State updates check for value changes before assigning
935	- [ ] Hot paths minimize state updates
936	- [ ] Pass only needed values to views (avoid large config objects)
937	- [ ] Large lists use `LazyVStack`/`LazyHStack`
938	- [ ] No object creation in `body`
939	- [ ] Heavy computation moved out of `body`
940	- [ ] Body kept simple and pure (no side effects)
941	- [ ] Derived state computed, not stored
942	- [ ] Use `Self._logChanges()` or `Self._printChanges()` to debug unexpected updates
943	- [ ] Equatable conformance for expensive views (when appropriate)
944	- [ ] Consider POD view wrappers for advanced optimization
945	- [ ] Consider using granular @Observable dependencies for list items (smaller observable units per row when it measurably reduces updates)
946	- [ ] Frequently-changing values not stored in the environment
947	- [ ] Sendable closures (Shape, visualEffect, Layout) capture values instead of accessing @MainActor state
948	################ view-structure ################
949	# SwiftUI View Structure Reference
950	
951	## Table of Contents
952	
953	- [View Structure Principles](#view-structure-principles)
954	- [View File Structure (optional readability suggestion)](#view-file-structure-optional-readability-suggestion)
955	- [Struct or Method / Computed Property?](#struct-or-method--computed-property)
956	- [Prefer Modifiers Over Conditional Views](#prefer-modifiers-over-conditional-views)
957	- [Extract Subviews, Not Computed Properties](#extract-subviews-not-computed-properties)
958	- [@ViewBuilder](#viewbuilder)
959	- [Keep View Body Simple and Avoid High-Cost Operations](#keep-view-body-simple-and-avoid-high-cost-operations)
960	- [Keep View `init` Cheap](#keep-view-init-cheap)
961	- [Single-Child Group](#single-child-group)
962	- [When to Extract Subviews](#when-to-extract-subviews)
963	- [Container View Pattern](#container-view-pattern)
964	- [Utilize Lazy Containers for Large Data Sets](#utilize-lazy-containers-for-large-data-sets)
965	- [ZStack vs overlay/background](#zstack-vs-overlaybackground)
966	- [Compositing Group Before Clipping](#compositing-group-before-clipping)
967	- [Split State-Driven Parts into Custom View Types](#split-state-driven-parts-into-custom-view-types)
968	- [Reusable Styling with ViewModifier](#reusable-styling-with-viewmodifier)
969	- [Skeleton Loading with Redacted Views](#skeleton-loading-with-redacted-views)
970	- [AnyView](#anyview)
971	- [UIViewRepresentable Essentials](#uiviewrepresentable-essentials)
972	- [Troubleshooting](#troubleshooting)
973	- [Summary Checklist](#summary-checklist)
974	
975	## View Structure Principles
976	
977	SwiftUI's diffing algorithm compares view hierarchies to determine what needs updating. Proper view composition directly impacts performance.
978	
979	## View File Structure (optional readability suggestion)
980	
981	Property ordering has no effect on correctness or performance, so treat this as a personal/team readability preference rather than a rule. Some developers find a consistent order easier to scan — for example, environment, then state, then passed-in properties, then `init`, body, and helper subviews. Adopt it only if your team wants the consistency; never reorder existing code solely to match it.
982	
983	```swift
984	struct ContentView: View {
985	    // MARK: - Environment Properties
986	    @Environment(\.colorScheme) var colorScheme
987	
988	    // MARK: - State Properties
989	    @Binding var isToggled: Bool
990	    @State private var viewModel: SomeViewModel
991	
992	    // MARK: - Private Properties
993	    private let title: String = "SwiftUI Guide"
994	
995	    // MARK: - Initializer (if needed)
996	    init(isToggled: Binding<Bool>) {
997	        self._isToggled = isToggled
998	    }
999	
1000	    // MARK: - Body
1001	    var body: some View {
1002	        VStack {
1003	            header
1004	            content
1005	        }
1006	    }
1007	
1008	    // MARK: - Computed Subviews
1009	    private var header: some View {
1010	        Text(title).font(.largeTitle).padding()
1011	    }
1012	
1013	    private var content: some View {
1014	        VStack {
1015	            Text("Counter: \(counter)")
1016	        }
1017	    }
1018	}
1019	```
1020	
1021	## Struct or Method / Computed Property?
1022	
1023	If a `View` is intended to be reusable across multiple screens, encapsulate it within a separate `struct`. If its usage is confined to a single context, it can be declared as a function or computed property within the containing `View`.
1024	
1025	However, if a view maintains state using `@State`, `@Binding`, `@ObservedObject`, `@Environment`, `@StateObject`, or similar wrappers, it should generally be a separate `struct`.
1026	
1027	- For simple, static views: a computed property is acceptable.
1028	- For views requiring parameters: a method is more appropriate, but only when those parameters are stable. If parameters change per-call (e.g. inside a `ForEach` where each call receives a different item), prefer a separate `struct` so SwiftUI can diff inputs and skip body evaluation.
1029	- For reusable, stateful, or logically independent UI sections: prefer a dedicated `struct`.
1030	
1031	```swift
1032	struct ContentView: View {
1033	    var titleView: some View {
1034	        Text("Hello from Property")
1035	            .font(.largeTitle)
1036	            .foregroundColor(.blue)
1037	    }
1038	
1039	    func messageView(text: String, color: Color) -> some View {
1040	        Text(text)
1041	            .font(.title)
1042	            .foregroundColor(color)
1043	            .padding()
1044	    }
1045	
1046	    var body: some View {
1047	        VStack {
1048	            titleView
1049	            messageView(text: "Hello from Method", color: .red)
1050	        }
1051	    }
1052	}
1053	```
1054	
1055	## Prefer Modifiers Over Conditional Views
1056	
1057	**Prefer "no-effect" modifiers over conditionally including views.** When you introduce a branch, consider whether you're representing multiple views or two states of the same view.
1058	
1059	### Use Opacity Instead of Conditional Inclusion
1060	
1061	```swift
1062	// Good - same view, different states
1063	SomeView()
1064	    .opacity(isVisible ? 1 : 0)
1065	
1066	// Avoid - creates/destroys view identity
1067	if isVisible {
1068	    SomeView()
1069	}
1070	```
1071	
1072	**Why**: Conditional view inclusion can cause loss of state, poor animation performance, and breaks view identity. Using modifiers maintains view identity across state changes.
1073	
1074	### When Conditionals Are Appropriate
1075	
1076	Use conditionals when you truly have **different views**, not different states:
1077	
1078	```swift
1079	// Correct - fundamentally different views
1080	if isLoggedIn {
1081	    DashboardView()
1082	} else {
1083	    LoginView()
1084	}
1085	
1086	// Correct - optional content
1087	if let user {
1088	    UserProfileView(user: user)
1089	}
1090	```
1091	
1092	### Conditional View Modifier Extensions Break Identity
1093	
1094	A common pattern is an `if`-based `View` extension for conditional modifiers. This changes the view's return type between branches, which destroys view identity and breaks animations:
1095	
1096	```swift
1097	// Problematic -- different return types per branch
1098	extension View {
1099	    @ViewBuilder func `if`<T: View>(_ condition: Bool, transform: (Self) -> T) -> some View {
1100	        if condition {
1101	            transform(self)  // Returns T
1102	        } else {
1103	            self              // Returns Self
1104	        }
1105	    }
1106	}
1107	```
1108	
1109	Prefer applying the modifier directly with a ternary or always-present modifier:
1110	
1111	```swift
1112	// Good -- same view identity maintained
1113	Text("Hello")
1114	    .opacity(isHighlighted ? 1 : 0.5)
1115	
1116	// Good -- modifier always present, value changes
1117	Text("Hello")
1118	    .foregroundStyle(isError ? .red : .primary)
1119	```
1120	
1121	When writing new code, never reach for a `.if` modifier. When reviewing existing code that already uses one, point out the identity/animation risk and show the ternary alternative, but don't silently refactor it as part of an unrelated change — swapping it can alter behavior (state resets, transition timing) and belongs in its own focused edit.
1122	
1123	## Extract Subviews, Not Computed Properties
1124	
1125	A view is SwiftUI's unit of invalidation. When an input changes, SwiftUI re-runs the body of the smallest enclosing **view type** that depends on it — every conditional, modifier chain, and string interpolation in that body, even if only one leaf actually depends on what changed. A computed property or `@ViewBuilder` helper is inlined into the parent's body, so it shares the parent's invalidation boundary and does not reduce update cost; it only reorganizes the code. A separate `View` type with narrow inputs becomes its own boundary and re-runs only when its own inputs change.
1126	
1127	This is why "split your body for readability" is also a performance tool — but only when you split into real `View` types, not computed properties.
1128	
1129	### The Problem with @ViewBuilder Functions
1130	
1131	When you use `@ViewBuilder` functions or computed properties for complex views, the entire function re-executes on every parent state change:
1132	
1133	```swift
1134	// BAD - re-executes complexSection() on every tap
1135	struct ParentView: View {
1136	    @State private var count = 0
1137	
1138	    var body: some View {
1139	        VStack {
1140	            Button("Tap: \(count)") { count += 1 }
1141	            complexSection()  // Re-executes every tap!
1142	        }
1143	    }
1144	
1145	    @ViewBuilder
1146	    func complexSection() -> some View {
1147	        // Complex views that re-execute unnecessarily
1148	        ForEach(0..<100) { i in
1149	            HStack {
1150	                Image(systemName: "star")
1151	                Text("Item \(i)")
1152	                Spacer()
1153	                Text("Detail")
1154	            }
1155	        }
1156	    }
1157	}
1158	```
1159	
1160	### The Solution: Separate Structs
1161	
1162	Extract to separate `struct` views. SwiftUI can skip their `body` when inputs don't change:
1163	
1164	```swift
1165	// GOOD - ComplexSection body SKIPPED when its inputs don't change
1166	struct ParentView: View {
1167	    @State private var count = 0
1168	
1169	    var body: some View {
1170	        VStack {
1171	            Button("Tap: \(count)") { count += 1 }
1172	            ComplexSection()  // Body skipped during re-evaluation
1173	        }
1174	    }
1175	}
1176	
1177	struct ComplexSection: View {
1178	    var body: some View {
1179	        ForEach(0..<100) { i in
1180	            HStack {
1181	                Image(systemName: "star")
1182	                Text("Item \(i)")
1183	                Spacer()
1184	                Text("Detail")
1185	            }
1186	        }
1187	    }
1188	}
1189	```
1190	
1191	### Why This Works
1192	
1193	1. SwiftUI compares the `ComplexSection` struct (which has no properties)
1194	2. Since nothing changed, SwiftUI skips calling `ComplexSection.body`
1195	3. The complex view code never executes unnecessarily
1196	
1197	### Multi-section detail views
1198	
1199	The most common place this rule gets dropped is a detail screen with several distinct sections — `header + gallery + description + reviews`, `header + ingredients + steps`, `hero + specs + related`. The tempting shape is one big view with `private var header: some View`, `private var gallery: some View`, and so on. That shape shares one invalidation boundary, so a change that affects one section re-evaluates all of them. Factor each named section into its own `View` type that takes only the fields it renders, and keep the parent thin — it just composes the sections.
1200	
1201	```swift
1202	// PREFER: each section is its own type with narrow inputs.
1203	struct ProductDetailView: View {
1204	    let product: Product
1205	
1206	    var body: some View {
1207	        ScrollView {
1208	            VStack(alignment: .leading, spacing: 24) {
1209	                ProductHeader(name: product.name, price: product.price)
1210	                ProductGallery(images: product.imageURLs)
1211	                ProductDescription(text: product.descriptionText)
1212	                ProductReviews(average: product.averageStars, count: product.reviewCount)
1213	            }
1214	            .padding()
1215	        }
1216	    }
1217	}
1218	```
1219	
1220	This generalizes to every `*DetailView`: one `View` type per section, narrow inputs each, a thin parent that composes them. Small `@ViewBuilder` fragments reused two or three times within the same body are still fine — the rule targets factoring done for organization or to manage body length, where a real `View` type does the right thing.
1221	
1222	## @ViewBuilder
1223	
1224	Use `@ViewBuilder` functions for small, simple sections (a few views, no expensive computation) that don't affect performance. They work particularly well for static content that doesn't depend on any `@State` or `@Binding`, since SwiftUI won't need to diff them independently. Extract to a separate `struct` when the section is complex, depends on state, or needs to be skipped during re-evaluation.
1225	
1226	The `@ViewBuilder` attribute is only required when a function or computed property returns multiple different views conditionally, for example through `if` or `switch`:
1227	
1228	```swift
1229	@ViewBuilder
1230	private var conditionalView: some View {
1231	    if isExpanded {
1232	        VStack {
1233	            Text("Expanded View")
1234	            Image(systemName: "star")
1235	        }
1236	    } else {
1237	        Text("Collapsed View")
1238	    }
1239	}
1240	```
1241	
1242	If every branch returns the same concrete type, `@ViewBuilder` is unnecessary:
1243	
1244	```swift
1245	var conditionalText: some View {
1246	    if Bool.random() {
1247	        Text("Hello")
1248	    } else {
1249	        Text("World")
1250	    }
1251	}
1252	```
1253	
1254	Prefer `@ViewBuilder` when:
1255	
1256	- there is conditional branching between multiple view types
1257	- extracting a separate `struct` would not provide meaningful separation
1258	
1259	## Keep View Body Simple and Avoid High-Cost Operations
1260	
1261	Refrain from performing complex operations within the `body` of your view. Instead of passing a ready-to-use sequence with filtering, mapping, or sorting directly into `ForEach`, prepare the sequence outside the body.
1262	
1263	```swift
1264	// Avoid such things ...
1265	var body: some View {
1266	    List {
1267	        ForEach(model.values.filter { $0 > 0 }, id: \.self) {
1268	            Text(String($0))
1269	                .padding()
1270	        }
1271	    }
1272	}
1273	```
1274	
1275	Prefer:
1276	
1277	```swift
1278	struct FilteredListView: View {
1279	    private let filteredValues: [Int]
1280	
1281	    init(values: [Int]) {
1282	        self.filteredValues = values.filter { $0 > 0 } // Perform filtering once
1283	    }
1284	
1285	    var body: some View {
1286	        List {
1287	            content
1288	        }
1289	    }
1290	
1291	    private var content: some View {
1292	        ForEach(filteredValues, id: \.self) { value in
1293	            Text(String(value))
1294	                .padding()
1295	        }
1296	    }
1297	}
1298	```
1299	
1300	The reason this matters is that the system can call `body` multiple times during a single layout phase. Complex body computation makes those calls more expensive than necessary.
1301	
1302	General guidance:
1303	
1304	- avoid filtering, sorting, and mapping inline in `body`
1305	- avoid constructing expensive formatters in `body`
1306	- avoid heavy branching in large view trees
1307	- move data preparation into the model layer or dedicated helpers
1308	
1309	## Keep View `init` Cheap
1310	
1311	A view's `init` runs every time the parent re-evaluates its body, which can be many times per second for views inside `List`, `LazyVStack`, scroll containers, or animated parents. Treat `init` as a constant-time copy of inputs into stored properties. Don't decode JSON, build a `DateFormatter`, touch the file system, or allocate large structures there — that work repeats on every parent body pass even when the inputs are identical.
1312	
1313	```swift
1314	// AVOID: decoding and formatting on every init
1315	init(rawJSON: Data, date: Date) {
1316	    self.summary = try! JSONDecoder().decode(WeatherSummary.self, from: rawJSON)
1317	    let formatter = DateFormatter()
1318	    formatter.dateStyle = .medium
1319	    self.formattedDate = formatter.string(from: date)
1320	}
1321	
1322	// PREFER: take already-prepared values; format lazily in body
1323	let summary: WeatherSummary
1324	let date: Date
1325	
1326	var body: some View {
1327	    VStack {
1328	        Text(summary.headline)
1329	        Text(date, format: .dateTime.day().month().year())  // cached, locale-aware
1330	    }
1331	}
1332	```
1333	
1334	If a derived value genuinely needs to be computed once and kept, store it on an `@State`-owned `@Observable` model or compute it asynchronously in `.task` — not in `init`. `init` is not a one-time setup hook; it runs as often as the parent's body does.
1335	
1336	## Single-Child Group
1337	
1338	`Group { SomeView() }` — a `Group` with exactly one concrete child — wraps the view in an extra `Group<SomeView>` type for no visual benefit. Every modifier chained after it must be type-checked against that wrapper, adding avoidable type-checking overhead in long chains. Drop the `Group` and chain modifiers directly on the child.
1339	
1340	```swift
1341	// AVOID: single concrete child wrapped in Group
1342	Group { Text(status) }
1343	    .padding(.horizontal, 8)
1344	    .background(.thinMaterial, in: Capsule())
1345	
1346	// PREFER: chain directly on the child
1347	Text(status)
1348	    .padding(.horizontal, 8)
1349	    .background(.thinMaterial, in: Capsule())
1350	```
1351	
1352	The rule is specifically about one concrete view. A `Group` whose content is a `ForEach`, multiple sibling views, or an `if`/`else` (which produces `_ConditionalContent`) is doing real work — applying a shared modifier across siblings or both branches — and is fine.
1353	
1354	## When to Extract Subviews
1355	
1356	Extract complex views into separate subviews when:
1357	- The view has multiple logical sections or responsibilities
1358	- The view contains reusable components
1359	- The view body becomes difficult to read or understand
1360	- You need to isolate state changes for performance
1361	- The view is becoming large (keep views small for better performance)
1362	- The section may evolve independently over time
1363	
1364	## Container View Pattern
1365	
1366	### Avoid Closure-Based Content
1367	
1368	Closures can't be compared, causing unnecessary re-renders:
1369	
1370	```swift
1371	// BAD - closure prevents SwiftUI from skipping updates
1372	struct MyContainer<Content: View>: View {
1373	    let content: () -> Content
1374	
1375	    var body: some View {
1376	        VStack {
1377	            Text("Header")
1378	            content()  // Always called, can't compare closures
1379	        }
1380	    }
1381	}
1382	
1383	// Usage forces re-render on every parent update
1384	MyContainer {
1385	    ExpensiveView()
1386	}
1387	```
1388	
1389	### Use @ViewBuilder Property Instead
1390	
1391	```swift
1392	// GOOD - view can be compared
1393	struct MyContainer<Content: View>: View {
1394	    @ViewBuilder let content: Content
1395	
1396	    var body: some View {
1397	        VStack {
1398	            Text("Header")
1399	            content  // SwiftUI can compare and skip if unchanged
1400	        }
1401	    }
1402	}
1403	
1404	// Usage - SwiftUI can diff ExpensiveView
1405	MyContainer {
1406	    ExpensiveView()
1407	}
1408	```
1409	
1410	## Utilize Lazy Containers for Large Data Sets
1411	
1412	When displaying extensive lists or grids, prefer `LazyVStack`, `LazyHStack`, `LazyVGrid`, or `LazyHGrid`. These containers load views only when they appear on the screen, reducing memory usage and improving performance.
1413	
1414	```swift
1415	struct ContentView: View {
1416	    let items = Array(0..<1000)
1417	
1418	    var body: some View {
1419	        ScrollView {
1420	            LazyVStack {
1421	                ForEach(items, id: \.self) { item in
1422	                    Text("Item \(item)")
1423	                }
1424	            }
1425	        }
1426	    }
1427	}
1428	```
1429	
1430	Prefer lazy containers when:
1431	
1432	- rendering large collections
1433	- row views are non-trivial
1434	- memory usage matters
1435	- the content is inside `ScrollView`
1436	
1437	## ZStack vs overlay/background
1438	
1439	Use `ZStack` to **compose multiple peer views** that should be layered together and jointly define layout.
1440	
1441	Prefer `overlay` / `background` when you’re **decorating a primary view**.  
1442	Not primarily because they don’t affect layout size, but because they **express intent and improve readability**: the view being modified remains the clear layout anchor.
1443	
1444	A key difference is **size proposal behavior**:
1445	- In `overlay` / `background`, the child view implicitly adopts the size proposed to the parent when it doesn’t define its own size, making decorative attachments feel natural and predictable.
1446	- In `ZStack`, each child participates independently in layout, and no implicit size inheritance exists. This makes it better suited for peer composition, but less intuitive for simple decoration.
1447	
1448	Use `ZStack` (or another container) when the “decoration” **must explicitly participate in layout sizing**—for example, when reserving space, extending tappable/visible bounds, or preventing overlap with neighboring views.
1449	
1450	### Examples
1451	
1452	```swift
1453	// GOOD - decoration via overlay (layout anchored to button)
1454	Button("Continue") { }
1455	    .overlay(alignment: .trailing) {
1456	        Image(systemName: "lock.fill").padding(.trailing, 8)
1457	    }
1458	
1459	// BAD - ZStack when overlay suffices (layout no longer anchored to button)
1460	ZStack(alignment: .trailing) {
1461	    Button("Continue") { }
1462	    Image(systemName: "lock.fill").padding(.trailing, 8)
1463	}
1464	
1465	// GOOD - background shape takes parent size
1466	HStack(spacing: 12) { Text("Inbox"); Text("Next") }
1467	    .background { Capsule().strokeBorder(.blue, lineWidth: 2) }
1468	```
1469	
1470	## Compositing Group Before Clipping
1471	
1472	**Always add `.compositingGroup()` before `.clipShape()` when clipping layered views (`.overlay` or `.background`).** Without it, each layer is antialiased separately and then composited. Where antialiased edges overlap — typically at rounded corners — you get visible color fringes (semi-transparent pixels of different colors blending together).
1473	
1474	```swift
1475	let shape = RoundedRectangle(cornerRadius: 16)
1476	
1477	// BAD - each layer antialiased separately, producing color fringes at corners
1478	Color.red
1479	    .overlay(.white, in: shape)
1480	    .clipShape(shape)
1481	    .frame(width: 200, height: 150)
1482	
1483	// GOOD - layers composited first, antialiasing applied once during clipping
1484	Color.red
1485	    .overlay(.white, in: .rect)
1486	    .compositingGroup()
1487	    .clipShape(shape)
1488	    .frame(width: 200, height: 150)
1489	```
1490	
1491	`.compositingGroup()` forces all child layers to be rendered into a single offscreen buffer before the clip is applied. This means antialiasing only happens once — on the final composited result — eliminating the fringe artifacts.
1492	
1493	## Split State-Driven Parts into Custom View Types
1494	
1495	Large views often depend on multiple independent state sources. If a single view body depends on all of them, then any state change can cause the entire body to re-evaluate.
1496	
1497	```swift
1498	struct BigAndComplicatedView: View {
1499	    @State private var counter = 0
1500	    @State private var isToggled = false
1501	    @StateObject private var viewModel = SomeViewModel()
1502	
1503	    let title = "Big and Complicated View"
1504	
1505	    var body: some View {
1506	        VStack {
1507	            Text(title)
1508	                .font(.largeTitle)
1509	
1510	            Text("Counter: \(counter)")
1511	                .font(.title)
1512	
1513	            Toggle("Enable Feature", isOn: $isToggled)
1514	                .padding()
1515	
1516	            Button("Increment Counter") {
1517	                counter += 1
1518	            }
1519	
1520	            Text("ViewModel Data: \(viewModel.data)")
1521	                .padding()
1522	
1523	            Button("Fetch Data") {
1524	                viewModel.fetchData()
1525	            }
1526	        }
1527	    }
1528	}
1529	```
1530	
1531	### Better: Split Into Smaller Components
1532	
1533	```swift
1534	struct BigAndComplicatedView: View {
1535	    @State private var counter = 0
1536	    @State private var isToggled = false
1537	    @StateObject private var viewModel = SomeViewModel()
1538	
1539	    var body: some View {
1540	        VStack {
1541	            titleView
1542	            CounterView(counter: $counter)
1543	            ToggleView(isToggled: $isToggled)
1544	            ViewModelDataView(data: viewModel.data) {
1545	                viewModel.updateData()
1546	            }
1547	            .equatable()
1548	        }
1549	    }
1550	
1551	    private var titleView: some View {
1552	        Text("Big and Complicated View")
1553	            .font(.largeTitle)
1554	    }
1555	}
1556	```
1557	
1558	Why this is better:
1559	
1560	- changing `counter` only affects `CounterView`
1561	- toggling only affects `ToggleView`
1562	- updating the model data only affects `ViewModelDataView`
1563	
1564	### Notes on Equatable
1565	
1566	Using `Equatable` for a view is not a universal best practice, but it can be useful in targeted cases where:
1567	
1568	- the input is small and well-defined
1569	- the comparison logic is meaningful
1570	- you want to reduce unnecessary body evaluation for a specific subtree
1571	
1572	Do not use `Equatable` as a blanket optimization technique.
1573	
1574	## Reusable Styling with ViewModifier
1575	
1576	Extract repeated modifier combinations into a `ViewModifier` struct. Expose via a `View` extension for autocompletion:
1577	
1578	```swift
1579	private struct CardStyle: ViewModifier {
1580	    func body(content: Content) -> some View {
1581	        content
1582	            .padding()
1583	            .background(Color(.secondarySystemBackground))
1584	            .clipShape(.rect(cornerRadius: 12))
1585	    }
1586	}
1587	
1588	extension View {
1589	    func cardStyle() -> some View {
1590	        modifier(CardStyle())
1591	    }
1592	}
1593	```
1594	
1595	### Custom ButtonStyle
1596	
1597	Use the `ButtonStyle` protocol for reusable button designs. Use `PrimitiveButtonStyle` only when you need custom interaction handling (e.g., simultaneous gestures):
1598	
1599	```swift
1600	struct PrimaryButtonStyle: ButtonStyle {
1601	    func makeBody(configuration: Configuration) -> some View {
1602	        configuration.label
1603	            .bold()
1604	            .foregroundStyle(.white)
1605	            .padding(.horizontal, 16)
1606	            .padding(.vertical, 8)
1607	            .background(Color.accentColor)
1608	            .clipShape(Capsule())
1609	            .scaleEffect(configuration.isPressed ? 0.95 : 1)
1610	            .animation(.smooth, value: configuration.isPressed)
1611	    }
1612	}
1613	```
1614	
1615	### Discoverability with Static Member Lookup
1616	
1617	Make custom styles and modifiers discoverable via leading-dot syntax:
1618	
1619	```swift
1620	extension ButtonStyle where Self == PrimaryButtonStyle {
1621	    static var primary: PrimaryButtonStyle { .init() }
1622	}
1623	
1624	// Usage: .buttonStyle(.primary)
1625	```
1626	
1627	This pattern works for any SwiftUI style protocol (`ButtonStyle`, `ListStyle`, `ToggleStyle`, etc.).
1628	
1629	## Skeleton Loading with Redacted Views
1630	
1631	Use `.redacted(reason: .placeholder)` to show skeleton views while data loads. Use `.unredacted()` to opt out specific views:
1632	
1633	```swift
1634	VStack(alignment: .leading) {
1635	    Text(article?.title ?? String(repeating: "X", count: 20))
1636	        .font(.headline)
1637	    Text(article?.author ?? String(repeating: "X", count: 12))
1638	        .font(.subheadline)
1639	    Text("SwiftLee")
1640	        .font(.caption)
1641	        .unredacted()
1642	}
1643	.redacted(reason: article == nil ? .placeholder : [])
1644	```
1645	
1646	Apply `.redacted` on a container to redact all children at once.
1647	
1648	## AnyView
1649	
1650	`AnyView` is type erasure. SwiftUI uses structural identity based on type information to determine when views should be updated.
1651	
1652	```swift
1653	private var nameView: some View {
1654	    if isEditable {
1655	        TextField("Your name", text: $name)
1656	    } else {
1657	        Text(name)
1658	    }
1659	}
1660	```
1661	
1662	Avoid patterns like:
1663	
1664	```swift
1665	private var nameView: some View {
1666	    if isEditable {
1667	        return AnyView(TextField("Your name", text: $name))
1668	    } else {
1669	        return AnyView(Text(name))
1670	    }
1671	}
1672	```
1673	
1674	Because `AnyView` erases type information, SwiftUI loses some optimization opportunities. Prefer `@ViewBuilder` or conditional branches with concrete view types.
1675	
1676	Use `AnyView` only when type erasure is truly necessary for API design.
1677	
1678	## UIViewRepresentable Essentials
1679	
1680	When bridging UIKit views into SwiftUI:
1681	
1682	- `makeUIView(context:)` is called **once** to create the UIKit view
1683	- `updateUIView(_:context:)` is called on **every SwiftUI redraw** to sync state
1684	- The representable struct itself is **recreated on every redraw** -- avoid heavy work in its init
1685	- Use a `Coordinator` for delegate callbacks and two-way communication
1686	
1687	```swift
1688	struct MapView: UIViewRepresentable {
1689	    let coordinate: CLLocationCoordinate2D
1690	
1691	    func makeUIView(context: Context) -> MKMapView {
1692	        let map = MKMapView()
1693	        map.delegate = context.coordinator
1694	        return map
1695	    }
1696	
1697	    func updateUIView(_ map: MKMapView, context: Context) {
1698	        map.setCenter(coordinate, animated: true)
1699	    }
1700	
1701	    func makeCoordinator() -> Coordinator { Coordinator() }
1702	
1703	    class Coordinator: NSObject, MKMapViewDelegate { }
1704	}
1705	```
1706	
1707	## Troubleshooting
1708	
1709	### Debug SwiftUI Renderings
1710	
1711	> See `references/performance-patterns.md` (item #8) for the `_printChanges()` vs `_logChanges()` comparison and the `@self`/`@identity` output meaning. The snippets below show the call sites.
1712	
1713	If it is needed to debug render cycles and read console output you can leverage the `_printChanges()` or `_logChanges()` methods on `View`. These methods print information about when the view is being evaluated and what changes are triggering updates. This can be very helpful when your view body is called multiple times and you want to know why.
1714	
1715	```swift
1716	struct ContentView: View {
1717	    @State private var counter: Int = 99
1718	
1719	    init() {
1720	        print(Self.self, #function)
1721	    }
1722	
1723	    var body: some View {
1724	        let _ = Self._printChanges()
1725	
1726	        VStack {
1727	            Text("Counter: \(counter)")
1728	            Button {
1729	                counter += 1
1730	            } label: {
1731	                Text("Counter +1")
1732	            }
1733	            .buttonStyle(.borderedProminent)
1734	        }
1735	        .padding()
1736	    }
1737	}
1738	```
1739	
~~~~

#### 2026-09-10 23:35:45 +0200 (21:35:45Z) · TOOL CALL · Read
`f88478cc` · `764f6c6d` · ligne 212

~~~~json
{
 "file_path": "/private/tmp/claude-501/-Volumes-Steve-Pro-BlackSSD-Dev-App-Mobile-Iris/f88478cc-d512-4210-bc11-758059278995/scratchpad/skills/swiftui-refs.txt",
 "offset": 1740,
 "limit": 900
}
~~~~

#### 2026-09-10 23:35:45 +0200 (21:35:45Z) · TOOL RESULT · Read
`f88478cc` · `e448bbcb` · ligne 213

~~~~text
1740	As an alternative to `Self._printChanges()`, you can use `_logChanges()`
1741	
1742	```swift
1743	struct ContentView: View {
1744	    @State private var counter: Int = 99
1745	
1746	    var body: some View {
1747	        let _ = Self._logChanges()
1748	
1749	        VStack {
1750	            Text("Counter: \(counter)")
1751	            Button {
1752	                counter += 1
1753	            } label: {
1754	                Text("Counter +1")
1755	            }
1756	            .buttonStyle(.borderedProminent)
1757	        }
1758	        .padding()
1759	    }
1760	}
1761	```
1762	
1763	Use these tools only for debugging and remove them from production code.
1764	
1765	### Handling "The Compiler Is Unable to Type-Check This Expression in Reasonable Time"
1766	
1767	If you encounter:
1768	
1769	> The compiler is unable to type-check this expression in reasonable time; try breaking up the expression into distinct sub-expressions
1770	
1771	it is often caused by overly complex view structures or expressions.
1772	
1773	Ways to fix it:
1774	
1775	- break large expressions into smaller computed values
1776	- extract subviews
1777	- split long modifier chains
1778	- simplify nested generics and builders
1779	- avoid huge inline closures
1780	
1781	## Summary Checklist
1782	
1783	- [ ] Prefer modifiers over conditional views for state changes
1784	- [ ] Avoid `if`-based conditional modifier extensions (they break view identity)
1785	- [ ] Extract complex views into separate subviews, not computed properties
1786	- [ ] Keep views small for readability and performance
1787	- [ ] Use `@ViewBuilder` only where it actually adds value
1788	- [ ] Avoid heavy filtering, mapping, sorting, or formatter creation inside `body`
1789	- [ ] Keep view `init` cheap (no decoding/formatting/allocation; it runs on every parent body pass)
1790	- [ ] Avoid single-child `Group { OneView() }` (chain modifiers directly on the child)
1791	- [ ] Use lazy containers for large data sets
1792	- [ ] Container views use `@ViewBuilder let content: Content`
1793	- [ ] Prefer `overlay` / `background` for decoration and `ZStack` for peer composition
1794	- [ ] `.compositingGroup()` before `.clipShape()` on layered views to avoid antialiasing fringes
1795	- [ ] Split state-heavy areas into smaller view types
1796	- [ ] Extract repeated styling into `ViewModifier` or `ButtonStyle`
1797	- [ ] Expose reusable styles via static member lookup when it improves discoverability
1798	- [ ] Use `.redacted(reason: .placeholder)` for loading skeletons
1799	- [ ] Avoid `AnyView` unless type erasure is truly needed
1800	- [ ] In `UIViewRepresentable`, keep heavy work out of struct init
1801	- [ ] Use `_printChanges()` / `_logChanges()` to debug rendering behavior
1802	- [ ] Break up overly complex expressions when the compiler struggles
1803	################ accessibility-patterns ################
1804	# SwiftUI Accessibility Patterns Reference
1805	
1806	## Table of Contents
1807	
1808	- [Core Principle](#core-principle)
1809	- [Dynamic Type and @ScaledMetric](#dynamic-type-and-scaledmetric)
1810	- [Accessibility Traits](#accessibility-traits)
1811	- [Decorative Images](#decorative-images)
1812	- [Element Grouping](#element-grouping)
1813	- [Custom Controls](#custom-controls)
1814	- [Summary Checklist](#summary-checklist)
1815	
1816	## Core Principle
1817	
1818	Prefer `Button` over `onTapGesture` for tappable elements. `Button` provides VoiceOver support, focus handling, and proper traits for free.
1819	
1820	## Dynamic Type and @ScaledMetric
1821	
1822	System text styles scale with Dynamic Type automatically. Prefer built-in styles like `.largeTitle`, `.title`, `.title2`, `.title3`, `.headline`, `.subheadline`, `.body`, `.callout`, `.footnote`, `.caption`, and `.caption2` when they fit your UI:
1823	
1824	```swift
1825	VStack(alignment: .leading) {
1826	    Text("Inbox")
1827	        .font(.title2)
1828	    Text("3 unread messages")
1829	        .font(.body)
1830	    Text("Updated just now")
1831	        .font(.caption)
1832	}
1833	```
1834	
1835	For custom fonts, use a Dynamic Type-aware font initializer so the text still follows the user's preferred content size:
1836	
1837	```swift
1838	VStack(alignment: .leading) {
1839	    Text("Article")
1840	        .font(.custom("SourceSerif4-Semibold", size: 28, relativeTo: .title2))
1841	    Text("Body copy")
1842	        .font(.custom("SourceSerif4-Regular", size: 17))
1843	}
1844	```
1845	
1846	`Font.custom(_:size:relativeTo:)` lets you match a specific text style. `Font.custom(_:size:)` scales relative to the body style. Avoid fixed-size custom fonts for primary content that should respond to Dynamic Type.
1847	
1848	For non-text numeric values like padding, spacing, and image sizes, use `@ScaledMetric`:
1849	
1850	```swift
1851	struct ProfileHeader: View {
1852	    @ScaledMetric private var avatarSize = 60.0
1853	    @ScaledMetric private var spacing = 12.0
1854	
1855	    var body: some View {
1856	        HStack(spacing: spacing) {
1857	            Image("avatar")
1858	                .resizable()
1859	                .frame(width: avatarSize, height: avatarSize)
1860	            Text("Username")
1861	        }
1862	    }
1863	}
1864	```
1865	
1866	Specify a `relativeTo` text style when the value should track a specific Dynamic Type style, including for images or icons that should stay proportional to nearby text:
1867	
1868	```swift
1869	struct StatusRow: View {
1870	    @ScaledMetric(relativeTo: .body) private var iconSize = 18.0
1871	
1872	    var body: some View {
1873	        HStack(spacing: 8) {
1874	            Image(systemName: "checkmark.circle.fill")
1875	                .font(.system(size: iconSize))
1876	            Text("Synced")
1877	                .font(.custom("AvenirNext-Regular", size: 17, relativeTo: .body))
1878	        }
1879	    }
1880	}
1881	```
1882	
1883	## Accessibility Traits
1884	
1885	Use `accessibilityAddTraits` and `accessibilityRemoveTraits` for state-driven traits:
1886	
1887	```swift
1888	Text(item.title)
1889	    .accessibilityAddTraits(item.isSelected ? [.isSelected, .isButton] : .isButton)
1890	```
1891	
1892	Use `.disabled(true)` to make VoiceOver announce "Dimmed" for non-interactive elements.
1893	
1894	## Decorative Images
1895	
1896	Use `Image(decorative:bundle:)` when an asset image is purely visual and should not appear in the accessibility tree.
1897	
1898	```swift
1899	Image(decorative: "confetti")
1900	```
1901	
1902	This is appropriate for backgrounds, flourishes, and icons that do not add meaning beyond nearby text.
1903	
1904	If the image conveys information, keep it accessible and provide a clear label:
1905	
1906	```swift
1907	Image("receipt")
1908	    .accessibilityLabel("Receipt")
1909	```
1910	
1911	For non-asset images, such as SF Symbols, hide decorative content with `accessibilityHidden(true)` instead:
1912	
1913	```swift
1914	Image(systemName: "sparkles")
1915	    .accessibilityHidden(true)
1916	```
1917	
1918	## Element Grouping
1919	
1920	### .combine -- Auto-join child labels
1921	
1922	```swift
1923	HStack {
1924	    Image(systemName: "star.fill")
1925	    Text("Favorites")
1926	    Text("(\(count))")
1927	}
1928	.accessibilityElement(children: .combine)
1929	```
1930	
1931	VoiceOver reads all child labels as one element, separated by commas.
1932	
1933	### .ignore -- Manual label for container
1934	
1935	```swift
1936	HStack {
1937	    Text(item.name)
1938	    Spacer()
1939	    Text(item.price)
1940	}
1941	.accessibilityElement(children: .ignore)
1942	.accessibilityLabel("\(item.name), \(item.price)")
1943	```
1944	
1945	### .contain -- Semantic grouping
1946	
1947	```swift
1948	HStack {
1949	    ForEach(tabs) { tab in
1950	        TabButton(tab: tab)
1951	    }
1952	}
1953	.accessibilityElement(children: .contain)
1954	.accessibilityLabel("Tab bar")
1955	```
1956	
1957	VoiceOver announces the container name when focus enters/exits.
1958	
1959	## Custom Controls
1960	
1961	### Adjustable controls (increment/decrement)
1962	
1963	```swift
1964	PageControl(selectedIndex: $selectedIndex, pageCount: pageCount)
1965	    .accessibilityElement()
1966	    .accessibilityValue("Page \(selectedIndex + 1) of \(pageCount)")
1967	    .accessibilityAdjustableAction { direction in
1968	        switch direction {
1969	        case .increment:
1970	            guard selectedIndex < pageCount - 1 else { break }
1971	            selectedIndex += 1
1972	        case .decrement:
1973	            guard selectedIndex > 0 else { break }
1974	            selectedIndex -= 1
1975	        @unknown default:
1976	            break
1977	        }
1978	    }
1979	```
1980	
1981	### Representing custom views as native controls
1982	
1983	When a custom view should behave like a native control for accessibility:
1984	
1985	```swift
1986	HStack {
1987	    Text(label)
1988	    Toggle("", isOn: $isOn)
1989	}
1990	.accessibilityRepresentation {
1991	    Toggle(label, isOn: $isOn)
1992	}
1993	```
1994	
1995	### Label-content pairing
1996	
1997	```swift
1998	@Namespace private var ns
1999	
2000	HStack {
2001	    Text("Volume")
2002	        .accessibilityLabeledPair(role: .label, id: "volume", in: ns)
2003	    Slider(value: $volume)
2004	        .accessibilityLabeledPair(role: .content, id: "volume", in: ns)
2005	}
2006	```
2007	
2008	## Summary Checklist
2009	
2010	- [ ] Use `Button` instead of `onTapGesture` for tappable elements
2011	- [ ] Use built-in text styles or Dynamic Type-aware custom fonts for text
2012	- [ ] Use `@ScaledMetric` for custom values that should scale with Dynamic Type
2013	- [ ] Mark purely decorative images as decorative or hidden from accessibility
2014	- [ ] Group related elements with `accessibilityElement(children:)`
2015	- [ ] Provide `accessibilityLabel` when default labels are unclear
2016	- [ ] Use `accessibilityRepresentation` for custom controls
2017	- [ ] Use `accessibilityAdjustableAction` for increment/decrement controls
2018	- [ ] Ensure navigation flow is logical when using VoiceOver grouping
2019	################ animation-basics ################
2020	# SwiftUI Animation Basics
2021	
2022	Core animation concepts, implicit vs explicit animations, timing curves, and performance patterns.
2023	
2024	## Table of Contents
2025	- [Core Concepts](#core-concepts)
2026	- [Implicit Animations](#implicit-animations)
2027	- [Explicit Animations](#explicit-animations)
2028	- [Animation Placement](#animation-placement)
2029	- [Selective Animation](#selective-animation)
2030	- [Timing Curves](#timing-curves)
2031	- [Animation Performance](#animation-performance)
2032	- [Disabling Animations](#disabling-animations)
2033	- [Debugging](#debugging)
2034	
2035	---
2036	
2037	## Core Concepts
2038	
2039	State changes trigger view updates. SwiftUI provides mechanisms to animate these changes.
2040	
2041	**Animation Process:**
2042	1. State change triggers view tree re-evaluation
2043	2. SwiftUI compares new tree to current render tree
2044	3. Animatable properties are identified and interpolated (~60 fps)
2045	
2046	**Key Characteristics:**
2047	- Animations are additive and cancelable
2048	- Always start from current render tree state
2049	- Blend smoothly when interrupted
2050	
2051	---
2052	
2053	## Implicit Animations
2054	
2055	Use `.animation(_:value:)` to animate when a specific value changes.
2056	
2057	```swift
2058	// GOOD - uses value parameter
2059	Rectangle()
2060	    .frame(width: isExpanded ? 200 : 100, height: 50)
2061	    .animation(.spring, value: isExpanded)
2062	    .onTapGesture { isExpanded.toggle() }
2063	
2064	// BAD - deprecated, animates all changes unexpectedly
2065	Rectangle()
2066	    .frame(width: isExpanded ? 200 : 100, height: 50)
2067	    .animation(.spring)  // Deprecated!
2068	```
2069	
2070	---
2071	
2072	## Explicit Animations
2073	
2074	Use `withAnimation` for event-driven state changes.
2075	
2076	```swift
2077	// GOOD - explicit animation
2078	Button("Toggle") {
2079	    withAnimation(.spring) {
2080	        isExpanded.toggle()
2081	    }
2082	}
2083	
2084	// BAD - no animation context
2085	Button("Toggle") {
2086	    isExpanded.toggle()  // Abrupt change
2087	}
2088	```
2089	
2090	**When to use which:**
2091	- **Implicit**: Animations tied to specific value changes, precise view tree scope
2092	- **Explicit**: Event-driven animations (button taps, gestures)
2093	
2094	---
2095	
2096	## Animation Placement
2097	
2098	Place animation modifiers after the properties they should animate.
2099	
2100	```swift
2101	// GOOD - animation after properties
2102	Rectangle()
2103	    .frame(width: isExpanded ? 200 : 100, height: 50)
2104	    .foregroundStyle(isExpanded ? .blue : .red)
2105	    .animation(.default, value: isExpanded)  // Animates both
2106	
2107	// BAD - animation before properties
2108	Rectangle()
2109	    .animation(.default, value: isExpanded)  // Too early!
2110	    .frame(width: isExpanded ? 200 : 100, height: 50)
2111	```
2112	
2113	---
2114	
2115	## Selective Animation
2116	
2117	Animate only specific properties using multiple animation modifiers or scoped animations.
2118	
2119	```swift
2120	// GOOD - selective animation
2121	Rectangle()
2122	    .frame(width: isExpanded ? 200 : 100, height: 50)
2123	    .animation(.spring, value: isExpanded)  // Animate size
2124	    .foregroundStyle(isExpanded ? .blue : .red)
2125	    .animation(nil, value: isExpanded)  // Don't animate color
2126	
2127	// iOS 17+ scoped animation
2128	Rectangle()
2129	    .foregroundStyle(isExpanded ? .blue : .red)  // Not animated
2130	    .animation(.spring) {
2131	        $0.frame(width: isExpanded ? 200 : 100, height: 50)  // Animated
2132	    }
2133	```
2134	
2135	---
2136	
2137	## Timing Curves
2138	
2139	### Built-in Curves
2140	
2141	| Curve | Use Case |
2142	|-------|----------|
2143	| `.spring` | Interactive elements, most UI |
2144	| `.easeInOut` | Appearance changes |
2145	| `.bouncy` | Playful feedback (iOS 17+) |
2146	| `.linear` | Progress indicators only |
2147	
2148	### Modifiers
2149	
2150	```swift
2151	.animation(.default.speed(2.0), value: flag)  // 2x faster
2152	.animation(.default.delay(0.5), value: flag)  // Delayed start
2153	.animation(.default.repeatCount(3, autoreverses: true), value: flag)
2154	```
2155	
2156	### Good vs Bad Timing
2157	
2158	```swift
2159	// GOOD - appropriate timing for interaction type
2160	Button("Tap") {
2161	    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
2162	        isActive.toggle()
2163	    }
2164	}
2165	.scaleEffect(isActive ? 0.95 : 1.0)
2166	
2167	// BAD - too slow for button feedback
2168	Button("Tap") {
2169	    withAnimation(.easeInOut(duration: 1.0)) {  // Way too slow!
2170	        isActive.toggle()
2171	    }
2172	}
2173	
2174	// BAD - linear feels robotic
2175	Rectangle()
2176	    .animation(.linear(duration: 0.5), value: isActive)  // Mechanical
2177	```
2178	
2179	---
2180	
2181	## Animation Performance
2182	
2183	### Prefer Transforms Over Layout
2184	
2185	```swift
2186	// GOOD - GPU accelerated transforms
2187	Rectangle()
2188	    .frame(width: 100, height: 100)
2189	    .scaleEffect(isActive ? 1.5 : 1.0)  // Fast
2190	    .offset(x: isActive ? 50 : 0)        // Fast
2191	    .rotationEffect(.degrees(isActive ? 45 : 0))  // Fast
2192	    .animation(.spring, value: isActive)
2193	
2194	// BAD - layout changes are expensive
2195	Rectangle()
2196	    .frame(width: isActive ? 150 : 100, height: isActive ? 150 : 100)  // Expensive
2197	    .padding(isActive ? 50 : 0)  // Expensive
2198	```
2199	
2200	### Narrow Animation Scope
2201	
2202	```swift
2203	// GOOD - animation scoped to specific subview
2204	VStack {
2205	    HeaderView()  // Not affected
2206	    ExpandableContent(isExpanded: isExpanded)
2207	        .animation(.spring, value: isExpanded)  // Only this
2208	    FooterView()  // Not affected
2209	}
2210	
2211	// BAD - animation at root
2212	VStack {
2213	    HeaderView()
2214	    ExpandableContent(isExpanded: isExpanded)
2215	    FooterView()
2216	}
2217	.animation(.spring, value: isExpanded)  // Animates everything
2218	```
2219	
2220	### Avoid Animation in Hot Paths
2221	
2222	```swift
2223	// GOOD - gate by threshold
2224	.onPreferenceChange(ScrollOffsetKey.self) { offset in
2225	    let shouldShow = offset.y < -50
2226	    if shouldShow != showTitle {  // Only when crossing threshold
2227	        withAnimation(.easeOut(duration: 0.2)) {
2228	            showTitle = shouldShow
2229	        }
2230	    }
2231	}
2232	
2233	// BAD - animating every scroll change
2234	.onPreferenceChange(ScrollOffsetKey.self) { offset in
2235	    withAnimation {  // Fires constantly!
2236	        self.offset = offset.y
2237	    }
2238	}
2239	```
2240	
2241	---
2242	
2243	## Disabling Animations
2244	
2245	```swift
2246	// GOOD - disable with transaction
2247	Text("Count: \(count)")
2248	    .transaction { $0.animation = nil }
2249	
2250	// GOOD - disable from parent context
2251	DataView()
2252	    .transaction { $0.disablesAnimations = true }
2253	
2254	// BAD - hacky zero duration
2255	Text("Count: \(count)")
2256	    .animation(.linear(duration: 0), value: count)  // Hacky
2257	```
2258	
2259	---
2260	
2261	## Debugging
2262	
2263	```swift
2264	// Slow down for inspection
2265	#if DEBUG
2266	.animation(.linear(duration: 3.0).speed(0.2), value: isExpanded)
2267	#else
2268	.animation(.spring, value: isExpanded)
2269	#endif
2270	
2271	// Debug modifier to log values
2272	struct AnimationDebugModifier: ViewModifier, Animatable {
2273	    var value: Double
2274	    var animatableData: Double {
2275	        get { value }
2276	        set {
2277	            value = newValue
2278	            print("Animation: \(newValue)")
2279	        }
2280	    }
2281	    func body(content: Content) -> some View {
2282	        content.opacity(value)
2283	    }
2284	}
2285	```
2286	
2287	---
2288	
2289	## Quick Reference
2290	
2291	### Do
2292	- Use `.animation(_:value:)` with value parameter
2293	- Use `withAnimation` for event-driven animations
2294	- Prefer transforms over layout changes
2295	- Scope animations narrowly
2296	- Choose appropriate timing curves
2297	
2298	### Don't
2299	- Use deprecated `.animation(_:)` without value
2300	- Animate layout properties in hot paths
2301	- Apply broad animations at root level
2302	- Use linear timing for UI (feels robotic)
2303	- Animate on every frame in scroll handlers
2304	################ previews ################
2305	# SwiftUI Previews Reference
2306	
2307	## Table of Contents
2308	
2309	- [Preview Macro](#preview-macro)
2310	- [Preview with Mock Data](#preview-with-mock-data)
2311	- [@Previewable Property Wrappers](#previewable-property-wrappers)
2312	- [Common Diagnostics](#common-diagnostics)
2313	- [Summary Checklist](#summary-checklist)
2314	
2315	---
2316	
2317	## Preview Macro
2318	
2319	The `#Preview` macro (Swift 5.9+, Xcode 15+) is the modern way to declare previews. The legacy `PreviewProvider` protocol still works; prefer `#Preview` for new code because it's less verbose and supports inline traits.
2320	
2321	### Basic Usage
2322	
2323	```swift
2324	// Modern: #Preview macro
2325	#Preview {
2326	    ContentView()
2327	}
2328	
2329	// Named preview
2330	#Preview("Dark Mode") {
2331	    ContentView()
2332	        .preferredColorScheme(.dark)
2333	}
2334	
2335	// Legacy: PreviewProvider — still valid, but verbose for new code
2336	struct ContentView_Previews: PreviewProvider {
2337	    static var previews: some View {
2338	        ContentView()
2339	    }
2340	}
2341	```
2342	
2343	### Multiple Previews
2344	
2345	Declare one `#Preview` per meaningful state so each renders independently in the canvas:
2346	
2347	```swift
2348	#Preview("Default") {
2349	    SettingsRow(title: "Notifications", isOn: true)
2350	}
2351	
2352	#Preview("Off State") {
2353	    SettingsRow(title: "Notifications", isOn: false)
2354	}
2355	
2356	#Preview("Long Title") {
2357	    SettingsRow(title: "Enable Push Notifications for All Events", isOn: true)
2358	}
2359	```
2360	
2361	### Preview Traits
2362	
2363	Traits configure the preview environment without modifying the view itself:
2364	
2365	```swift
2366	// Fixed size
2367	#Preview(traits: .fixedLayout(width: 300, height: 100)) {
2368	    CompactBanner(message: "Welcome")
2369	}
2370	
2371	// Size that fits content
2372	#Preview(traits: .sizeThatFitsLayout) {
2373	    BadgeView(count: 5)
2374	}
2375	
2376	// Landscape orientation
2377	#Preview(traits: .landscapeLeft) {
2378	    DashboardView()
2379	}
2380	```
2381	
2382	### Previewing Inside NavigationStack
2383	
2384	Wrap previewed destinations in their navigation container so toolbar items, titles, and back buttons render correctly:
2385	
2386	```swift
2387	#Preview {
2388	    NavigationStack {
2389	        DetailView(item: .sample)
2390	    }
2391	}
2392	```
2393	
2394	---
2395	
2396	## Preview with Mock Data
2397	
2398	Previews must compile and render without external dependencies. Live services, network calls, and disk I/O make previews slow, flaky, or broken; use self-contained sample data instead.
2399	
2400	### Static Sample Data
2401	
2402	Expose sample values as static properties on the model itself so any preview can reuse them without reconstructing values inline:
2403	
2404	```swift
2405	struct Item: Identifiable {
2406	    let id: UUID
2407	    var name: String
2408	    var price: Double
2409	}
2410	
2411	extension Item {
2412	    static let sample = Item(id: UUID(), name: "Widget", price: 9.99)
2413	
2414	    static let samples: [Item] = [
2415	        Item(id: UUID(), name: "Widget", price: 9.99),
2416	        Item(id: UUID(), name: "Gadget", price: 19.99),
2417	        Item(id: UUID(), name: "Doohickey", price: 4.99),
2418	    ]
2419	}
2420	
2421	#Preview {
2422	    ItemListView(items: Item.samples)
2423	}
2424	```
2425	
2426	### Mock Observable Models
2427	
2428	For views driven by an `@Observable` model (see `state-management.md` for fundamentals), expose pre-configured instances on the model itself:
2429	
2430	```swift
2431	@Observable
2432	@MainActor
2433	final class CartModel {
2434	    var items: [Item] = []
2435	    var isLoading = false
2436	
2437	    static var preview: CartModel {
2438	        let model = CartModel()
2439	        model.items = Item.samples
2440	        return model
2441	    }
2442	
2443	    static var emptyPreview: CartModel {
2444	        CartModel()
2445	    }
2446	
2447	    static var loadingPreview: CartModel {
2448	        let model = CartModel()
2449	        model.isLoading = true
2450	        return model
2451	    }
2452	}
2453	
2454	#Preview("With Items") {
2455	    CartView()
2456	        .environment(CartModel.preview)
2457	}
2458	
2459	#Preview("Empty") {
2460	    CartView()
2461	        .environment(CartModel.emptyPreview)
2462	}
2463	
2464	#Preview("Loading") {
2465	    CartView()
2466	        .environment(CartModel.loadingPreview)
2467	}
2468	```
2469	
2470	### Preview with Environment Dependencies
2471	
2472	Inject any environment values the view depends on so the preview reflects a realistic runtime context:
2473	
2474	```swift
2475	#Preview {
2476	    OrderDetailView(order: .sample)
2477	        .environment(CartModel.preview)
2478	        .environment(\.locale, Locale(identifier: "ja_JP"))
2479	        .environment(\.dynamicTypeSize, .xxxLarge)
2480	}
2481	```
2482	
2483	### Mocking Async Data Sources
2484	
2485	When a view depends on a network or data service, give the dependency a protocol abstraction so previews can inject a synchronous mock that returns sample data immediately. This is one approach — adapt it to whatever pattern the surrounding codebase already uses.
2486	
2487	```swift
2488	protocol DataFetching {
2489	    func fetchItems() async throws -> [Item]
2490	}
2491	
2492	struct LiveDataFetcher: DataFetching {
2493	    let url: URL
2494	
2495	    func fetchItems() async throws -> [Item] {
2496	        let (data, _) = try await URLSession.shared.data(from: url)
2497	        return try JSONDecoder().decode([Item].self, from: data)
2498	    }
2499	}
2500	
2501	struct MockDataFetcher: DataFetching {
2502	    var result: Result<[Item], Error> = .success(Item.samples)
2503	
2504	    func fetchItems() async throws -> [Item] {
2505	        try result.get()
2506	    }
2507	}
2508	
2509	#Preview {
2510	    ItemListView(fetcher: MockDataFetcher())
2511	}
2512	
2513	#Preview("Error State") {
2514	    ItemListView(fetcher: MockDataFetcher(result: .failure(URLError(.notConnectedToInternet))))
2515	}
2516	```
2517	
2518	---
2519	
2520	## @Previewable Property Wrappers
2521	
2522	`@Previewable` (iOS 18+, Xcode 16+) lets you use `@State`, `@FocusState`, and other property wrappers directly inside a `#Preview` block, removing the need for a wrapper view to host interactive state.
2523	
2524	### Interactive State
2525	
2526	```swift
2527	// @Previewable: interactive toggle inline in the preview
2528	#Preview {
2529	    @Previewable @State var isOn = false
2530	    Toggle("Notifications", isOn: $isOn)
2531	}
2532	
2533	// Without @Previewable: requires a wrapper view
2534	struct TogglePreviewWrapper: View {
2535	    @State private var isOn = false
2536	    var body: some View {
2537	        Toggle("Notifications", isOn: $isOn)
2538	    }
2539	}
2540	
2541	#Preview {
2542	    TogglePreviewWrapper()
2543	}
2544	```
2545	
2546	### Multiple Interactive Controls
2547	
2548	```swift
2549	#Preview {
2550	    @Previewable @State var name = "Alice"
2551	    @Previewable @State var age = 25.0
2552	
2553	    VStack {
2554	        TextField("Name", text: $name)
2555	        Slider(value: $age, in: 0...100, step: 1) {
2556	            Text("Age: \(Int(age))")
2557	        }
2558	        Text("Hello, \(name)! Age: \(Int(age))")
2559	    }
2560	    .padding()
2561	}
2562	```
2563	
2564	### @Previewable with @FocusState
2565	
2566	When seeding initial focus inside a preview, prefer `.defaultFocus` over writing to `@FocusState` from `.onAppear`. `.onAppear` can race the initial render and the focus assignment may be lost. See `focus-patterns.md` for the underlying rationale.
2567	
2568	```swift
2569	#Preview {
2570	    @Previewable @FocusState var isFocused: Bool
2571	
2572	    TextField("Search", text: .constant(""))
2573	        .focused($isFocused)
2574	        .defaultFocus($isFocused, true)
2575	}
2576	```
2577	
2578	### Fallback for Pre-iOS 18 Targets
2579	
2580	If the project's minimum deployment target is below iOS 18, `@Previewable` is unavailable. Fall back to a wrapper view:
2581	
2582	```swift
2583	private struct SliderPreview: View {
2584	    @State private var value = 0.5
2585	    var body: some View {
2586	        CustomSlider(value: $value)
2587	    }
2588	}
2589	
2590	#Preview {
2591	    SliderPreview()
2592	}
2593	```
2594	
2595	---
2596	
2597	## Common Diagnostics
2598	
2599	| Symptom | Cause | Fix |
2600	|---|---|---|
2601	| `#Preview` body type mismatch | The closure returns a non-`View` type | Make sure the final expression is a `View` |
2602	| `@Previewable` only available in iOS 18+ | Using `@Previewable` with a lower deployment target | Use a wrapper view, or gate with `#available` |
2603	| Preview crashes with "missing environment" | An `@Environment(SomeType.self)` value is not injected | Add `.environment(SomeType.preview)` to the preview |
2604	| Preview hangs or renders blank | View depends on async data that never resolves | Inject a mock that returns immediately with sample data |
2605	| `@MainActor`-isolated model accessed from non-isolated context | A preview helper touches main-actor-only API off the main actor | Mark the helper or the preview body `@MainActor` |
2606	
2607	---
2608	
2609	## Summary Checklist
2610	
2611	- [ ] Prefer `#Preview` for new previews; `PreviewProvider` is still valid for older code
2612	- [ ] Provide a named preview for each meaningful state (default, empty, error, loading)
2613	- [ ] Use `@Previewable` for interactive previews when targeting iOS 18+; wrapper views otherwise
2614	- [ ] Expose static `.sample` / `.preview` data on models so previews don't reconstruct values inline
2615	- [ ] Inject mock services through a protocol when a view depends on async data
2616	- [ ] Never depend on live network or disk I/O in a preview
2617	- [ ] Prefer `.defaultFocus` over `.onAppear` writes when seeding `@FocusState` in previews
2618	
~~~~

#### 2026-09-10 23:35:46 +0200 (21:35:46Z) · TOOL CALL · ToolSearch
`f88478cc` · `ff380fa9` · ligne 214

~~~~json
{
 "query": "select:WebFetch,WebSearch",
 "max_results": 2
}
~~~~

#### 2026-09-10 23:35:46 +0200 (21:35:46Z) · TOOL RESULT · ToolSearch
`f88478cc` · `071560b2` · ligne 215


#### 2026-09-10 23:35:50 +0200 (21:35:50Z) · TOOL CALL · WebFetch
`f88478cc` · `4d8c6b6b` · ligne 224

~~~~json
{
 "url": "https://developer.apple.com/documentation/arkit/arfaceanchor",
 "prompt": "Extract precisely: (1) the definition of the face coordinate system (where is the origin, which direction do +x, +y, +z point relative to the user's face — the user's right or left, up, toward camera?), (2) the description of lookAtPoint (what is it, in which coordinate space, units), (3) leftEyeTransform/rightEyeTransform descriptions, (4) anything about the front camera image being mirrored or the world coordinate handedness in face tracking. Quote the exact sentences."
}
~~~~

#### 2026-09-10 23:35:52 +0200 (21:35:52Z) · TOOL CALL · WebFetch
`f88478cc` · `d76700a1` · ligne 225

~~~~json
{
 "url": "https://developer.apple.com/documentation/arkit/arcamera/viewmatrix(for:)",
 "prompt": "Extract the full description of viewMatrix(for:) including what the orientation parameter means and what coordinate space the result maps to. Also mention any note about the camera's default (landscape right) orientation convention."
}
~~~~

#### 2026-09-10 23:35:53 +0200 (21:35:53Z) · TOOL RESULT · WebFetch
`f88478cc` · `b02f06f2` · ligne 226

~~~~text
The server returned HTTP 404 Not Found.

The response body was not retrieved. If this URL requires authentication, use an authenticated tool (e.g. `gh` for GitHub, or an MCP-provided fetch tool) instead of WebFetch.
~~~~

#### 2026-09-10 23:35:55 +0200 (21:35:55Z) · TOOL RESULT · WebFetch
`f88478cc` · `70c643d8` · ligne 227

~~~~text
I appreciate your detailed request, but I need to be honest: **the web page content provided contains only a page title ("ARFaceAnchor | Apple Developer Documentation") with no actual documentation body text.**

To extract the specific technical details you're asking for—the face coordinate system definition, lookAtPoint description, eye transform specifications, and information about camera mirroring/handedness—I would need the actual documentation content, which isn't included in what you've provided.

**To get this information, you would need to:**

1. Visit the actual Apple Developer Documentation page for ARFaceAnchor
2. Copy the full documentation content (not just the title)
3. Provide that complete text

Alternatively, if you can access Apple's ARKit documentation directly, these details are typically found in:
- The "Overview" or "Discussion" section for the coordinate system
- Property descriptions for `lookAtPoint`, `leftEyeTransform`, and `rightEyeTransform`
- "See Also" or related sections discussing coordinate spaces and camera properties

Would you be able to provide the full documentation content?
~~~~

#### 2026-09-10 23:35:55 +0200 (21:35:55Z) · TOOL CALL · WebFetch
`f88478cc` · `c1a91416` · ligne 228

~~~~json
{
 "url": "https://developer.apple.com/documentation/arkit/arfacetrackingconfiguration",
 "prompt": "Extract: whether the front camera image / world coordinates are mirrored in face tracking (any sentence mentioning 'mirror' or 'as if looking in a mirror'), the isSupported/supportedNumberOfTrackedFaces details, worldAlignment notes, the maximum frame rate / video formats, and the note about the camera's coordinate system orientation (which direction is +x/+y in world space when the device is held in portrait). Quote exact sentences."
}
~~~~

#### 2026-09-10 23:35:57 +0200 (21:35:57Z) · TOOL CALL · WebFetch
`f88478cc` · `e80a1e11` · ligne 229

~~~~json
{
 "url": "https://developer.apple.com/documentation/arkit/arfaceanchor/lookatpoint",
 "prompt": "Quote the complete documentation text for lookAtPoint, including the coordinate space, how it's estimated (from eye transforms), and any usage notes."
}
~~~~

#### 2026-09-10 23:35:58 +0200 (21:35:58Z) · TOOL CALL · WebFetch
`f88478cc` · `4f8c7cf8` · ligne 230

~~~~json
{
 "url": "https://developer.apple.com/documentation/arkit/arcamera/transform",
 "prompt": "Quote the full description of ARCamera.transform, especially the note about the coordinate system orientation (landscape-right, which axes point where) and how to account for interface orientation."
}
~~~~

#### 2026-09-10 23:35:59 +0200 (21:35:59Z) · TOOL RESULT · WebFetch
`f88478cc` · `8dda0aaf` · ligne 231

~~~~text
I don't have access to the actual web page content you're referring to. The content area between the dashes appears to be empty - it only shows the page title "ARFaceTrackingConfiguration | Apple Developer Documentation" but no actual documentation text.

To provide you with the specific information you're requesting, I would need:

1. **Mirror/coordinate system details** - sentences about whether front camera images are mirrored
2. **isSupported/supportedNumberOfTrackedFaces** - API availability and limitations
3. **worldAlignment notes** - coordinate space information
4. **Frame rate/video formats** - maximum supported rates and format options
5. **Camera coordinate system orientation** - which direction is +x/+y in portrait mode

Could you please provide the actual documentation content from the Apple Developer page? You can:
- Copy and paste the full text content
- Share the relevant sections that contain these technical details
- Or provide a link so I can understand the context better

Once you share the actual content, I'll be happy to extract and quote the exact sentences addressing each of your requirements.
~~~~

#### 2026-09-10 23:35:59 +0200 (21:35:59Z) · TOOL RESULT · WebFetch
`f88478cc` · `432fb601` · ligne 232

~~~~text
I appreciate your request, but I need to let you know that the web page content provided only contains the title "lookAtPoint | Apple Developer Documentation" and doesn't include the actual documentation text, details about coordinate space, how it's estimated, usage notes, or any other substantive content.

To provide you with the complete documentation for `lookAtPoint`, I would need:

1. The full documentation page content
2. Details about the coordinate system
3. Information on how it's estimated from eye transforms
4. Usage notes and examples

**Could you please provide the complete page content** from the Apple Developer Documentation? Once you share that, I'll be able to quote the complete documentation text including all the details you're asking for.

Alternatively, if you're looking for this information, you can visit: `https://developer.apple.com/documentation/` and search for "lookAtPoint" to access the full documentation directly.
~~~~

#### 2026-09-10 23:36:01 +0200 (21:36:01Z) · TOOL RESULT · WebFetch
`f88478cc` · `8023300e` · ligne 233

~~~~text
I appreciate your request, but I'm unable to provide the full description of `ARCamera.transform` from the Apple Developer Documentation. 

The web page content you've shared only contains the page title ("transform | Apple Developer Documentation") without the actual documentation body, description, notes about coordinate system orientation, or details about landscape-right orientation and interface orientation handling.

To get this information, you would need to:

1. **Visit the official Apple Developer Documentation** directly at: https://developer.apple.com/documentation/arkit/arcamera/transform
2. **Check the ARKit documentation** for `ARCamera.transform` which should contain:
   - The full property description
   - Notes about coordinate system orientation (landscape-right reference frame)
   - Axis orientation details
   - Information about accounting for interface orientation changes

If you can share the actual documentation content (the body text, not just the page title), I'd be happy to quote and explain the relevant sections about coordinate system orientation and interface orientation considerations.
~~~~

#### 2026-09-10 23:36:08 +0200 (21:36:08Z) · TOOL CALL · Bash
`f88478cc` · `1059378e` · ligne 238 · Read ARFaceAnchor header documentation from the iOS SDK

~~~~bash
SDK=$(xcrun --sdk iphoneos --show-sdk-path); H="$SDK/System/Library/Frameworks/ARKit.framework/Headers"; ls "$H" | head -50; echo "=========== ARFaceAnchor.h ==========="; cat "$H/ARFaceAnchor.h"
~~~~

#### 2026-09-10 23:36:10 +0200 (21:36:10Z) · TOOL RESULT · Bash
`f88478cc` · `6d2d0aeb` · ligne 239 · Read ARFaceAnchor header documentation from the iOS SDK

~~~~text
ARAnchor.h
ARAppClipCodeAnchor.h
ARBody2D.h
ARBodyAnchor.h
ARCamera.h
ARCoachingOverlayView.h
ARCollaborationData.h
ARConfiguration.h
ARDepthData.h
AREnvironmentProbeAnchor.h
ARError.h
ARFaceAnchor.h
ARFaceGeometry.h
ARFrame.h
ARGeoAnchor.h
ARGeoTrackingTypes.h
ARHitTestResult.h
ARImageAnchor.h
ARKit.h
ARKitCore.h
ARKitFoundation.h
ARKitUI.h
ARLightEstimate.h
ARMatteGenerator.h
ARMeshAnchor.h
ARMeshGeometry.h
ARObjectAnchor.h
ARParticipantAnchor.h
ARPlaneAnchor.h
ARPlaneDetectionTypes.h
ARPlaneGeometry.h
ARPointCloud.h
ARRaycastQuery.h
ARRaycastResult.h
ARReferenceImage.h
ARReferenceObject.h
ARSCNFaceGeometry.h
ARSCNPlaneGeometry.h
ARSCNView.h
ARSession.h
ARSkeleton.h
ARSkeletonDefinition.h
ARSKView.h
ARTrackedRaycast.h
ARTrackingStatusTypes.h
ARVideoFormat.h
ARWorldMap.h
=========== ARFaceAnchor.h ===========
#if (defined(USE_ARKIT_PUBLIC_HEADERS) && USE_ARKIT_PUBLIC_HEADERS) || !__has_include(<ARKitCore/ARFaceAnchor.h>)
//
//  ARFaceAnchor.h
//  ARKit
//
//  Copyright © 2016-2021 Apple Inc. All rights reserved.
//

#import <ARKit/ARAnchor.h>
#import <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Blend shape locations of a face geometry.
 @discussion Each location defines an area of the face that can be displaced with a provided coefficient.
 blend shape activation  by ARKit.
 @note Blend shapes are computed based on the captured image. For example, if the detected person has a closed right eye, the eye on the left side of
 the captured image will appear closed and reported as blend shape activation  by ARKit.
 @see -[ARFrame capturedImage]
 */
typedef NSString *ARBlendShapeLocation NS_STRING_ENUM NS_SWIFT_NAME(ARFaceAnchor.BlendShapeLocation) API_AVAILABLE(ios(11.0));
FOUNDATION_EXTERN ARBlendShapeLocation const ARBlendShapeLocationBrowDownLeft API_AVAILABLE(ios(11.0));
FOUNDATION_EXTERN ARBlendShapeLocation const ARBlendShapeLocationBrowDownRight API_AVAILABLE(ios(11.0));
FOUNDATION_EXTERN ARBlendShapeLocation const ARBlendShapeLocationBrowInnerUp API_AVAILABLE(ios(11.0));
FOUNDATION_EXTERN ARBlendShapeLocation const ARBlendShapeLocationBrowOuterUpLeft API_AVAILABLE(ios(11.0));
FOUNDATION_EXTERN ARBlendShapeLocation const ARBlendShapeLocationBrowOuterUpRight API_AVAILABLE(ios(11.0));
FOUNDATION_EXTERN ARBlendShapeLocation const ARBlendShapeLocationCheekPuff API_AVAILABLE(ios(11.0));
FOUNDATION_EXTERN ARBlendShapeLocation const ARBlendShapeLocationCheekSquintLeft API_AVAILABLE(ios(11.0));
FOUNDATION_EXTERN ARBlendShapeLocation const ARBlendShapeLocationCheekSquintRight API_AVAILABLE(ios(11.0));
FOUNDATION_EXTERN ARBlendShapeLocation const ARBlendShapeLocationEyeBlinkLeft API_AVAILABLE(ios(11.0));
FOUNDATION_EXTERN ARBlendShapeLocation const ARBlendShapeLocationEyeBlinkRight API_AVAILABLE(ios(11.0));
FOUNDATION_EXTERN ARBlendShapeLocation const ARBlendShapeLocationEyeLookDownLeft API_AVAILABLE(ios(11.0));
FOUNDATION_EXTERN ARBlendShapeLocation const ARBlendShapeLocationEyeLookDownRight API_AVAILABLE(ios(11.0));
FOUNDATION_EXTERN ARBlendShapeLocation const ARBlendShapeLocationEyeLookInLeft API_AVAILABLE(ios(11.0));
FOUNDATION_EXTERN ARBlendShapeLocation const ARBlendShapeLocationEyeLookInRight API_AVAILABLE(ios(11.0));
FOUNDATION_EXTERN ARBlendShapeLocation const ARBlendShapeLocationEyeLookOutLeft API_AVAILABLE(ios(11.0));
FOUNDATION_EXTERN ARBlendShapeLocation const ARBlendShapeLocationEyeLookOutRight API_AVAILABLE(ios(11.0));
FOUNDATION_EXTERN ARBlendShapeLocation const ARBlendShapeLocationEyeLookUpLeft API_AVAILABLE(ios(11.0));
FOUNDATION_EXTERN ARBlendShapeLocation const ARBlendShapeLocationEyeLookUpRight API_AVAILABLE(ios(11.0));
FOUNDATION_EXTERN ARBlendShapeLocation const ARBlendShapeLocationEyeSquintLeft API_AVAILABLE(ios(11.0));
FOUNDATION_EXTERN ARBlendShapeLocation const ARBlendShapeLocationEyeSquintRight API_AVAILABLE(ios(11.0));
FOUNDATION_EXTERN ARBlendShapeLocation const ARBlendShapeLocationEyeWideLeft API_AVAILABLE(ios(11.0));
FOUNDATION_EXTERN ARBlendShapeLocation const ARBlendShapeLocationEyeWideRight API_AVAILABLE(ios(11.0));
FOUNDATION_EXTERN ARBlendShapeLocation const ARBlendShapeLocationJawForward API_AVAILABLE(ios(11.0));
FOUNDATION_EXTERN ARBlendShapeLocation const ARBlendShapeLocationJawLeft API_AVAILABLE(ios(11.0));
FOUNDATION_EXTERN ARBlendShapeLocation const ARBlendShapeLocationJawOpen API_AVAILABLE(ios(11.0));
FOUNDATION_EXTERN ARBlendShapeLocation const ARBlendShapeLocationJawRight API_AVAILABLE(ios(11.0));
FOUNDATION_EXTERN ARBlendShapeLocation const ARBlendShapeLocationMouthClose API_AVAILABLE(ios(11.0));
FOUNDATION_EXTERN ARBlendShapeLocation const ARBlendShapeLocationMouthDimpleLeft API_AVAILABLE(ios(11.0));
FOUNDATION_EXTERN ARBlendShapeLocation const ARBlendShapeLocationMouthDimpleRight API_AVAILABLE(ios(11.0));
FOUNDATION_EXTERN ARBlendShapeLocation const ARBlendShapeLocationMouthFrownLeft API_AVAILABLE(ios(11.0));
FOUNDATION_EXTERN ARBlendShapeLocation const ARBlendShapeLocationMouthFrownRight API_AVAILABLE(ios(11.0));
FOUNDATION_EXTERN ARBlendShapeLocation const ARBlendShapeLocationMouthFunnel API_AVAILABLE(ios(11.0));
FOUNDATION_EXTERN ARBlendShapeLocation const ARBlendShapeLocationMouthLeft API_AVAILABLE(ios(11.0));
FOUNDATION_EXTERN ARBlendShapeLocation const ARBlendShapeLocationMouthLowerDownLeft API_AVAILABLE(ios(11.0));
FOUNDATION_EXTERN ARBlendShapeLocation const ARBlendShapeLocationMouthLowerDownRight API_AVAILABLE(ios(11.0));
FOUNDATION_EXTERN ARBlendShapeLocation const ARBlendShapeLocationMouthPressLeft API_AVAILABLE(ios(11.0));
FOUNDATION_EXTERN ARBlendShapeLocation const ARBlendShapeLocationMouthPressRight API_AVAILABLE(ios(11.0));
FOUNDATION_EXTERN ARBlendShapeLocation const ARBlendShapeLocationMouthPucker API_AVAILABLE(ios(11.0));
FOUNDATION_EXTERN ARBlendShapeLocation const ARBlendShapeLocationMouthRight API_AVAILABLE(ios(11.0));
FOUNDATION_EXTERN ARBlendShapeLocation const ARBlendShapeLocationMouthRollLower API_AVAILABLE(ios(11.0));
FOUNDATION_EXTERN ARBlendShapeLocation const ARBlendShapeLocationMouthRollUpper API_AVAILABLE(ios(11.0));
FOUNDATION_EXTERN ARBlendShapeLocation const ARBlendShapeLocationMouthShrugLower API_AVAILABLE(ios(11.0));
FOUNDATION_EXTERN ARBlendShapeLocation const ARBlendShapeLocationMouthShrugUpper API_AVAILABLE(ios(11.0));
FOUNDATION_EXTERN ARBlendShapeLocation const ARBlendShapeLocationMouthSmileLeft API_AVAILABLE(ios(11.0));
FOUNDATION_EXTERN ARBlendShapeLocation const ARBlendShapeLocationMouthSmileRight API_AVAILABLE(ios(11.0));
FOUNDATION_EXTERN ARBlendShapeLocation const ARBlendShapeLocationMouthStretchLeft API_AVAILABLE(ios(11.0));
FOUNDATION_EXTERN ARBlendShapeLocation const ARBlendShapeLocationMouthStretchRight API_AVAILABLE(ios(11.0));
FOUNDATION_EXTERN ARBlendShapeLocation const ARBlendShapeLocationMouthUpperUpLeft API_AVAILABLE(ios(11.0));
FOUNDATION_EXTERN ARBlendShapeLocation const ARBlendShapeLocationMouthUpperUpRight API_AVAILABLE(ios(11.0));
FOUNDATION_EXTERN ARBlendShapeLocation const ARBlendShapeLocationNoseSneerLeft API_AVAILABLE(ios(11.0));
FOUNDATION_EXTERN ARBlendShapeLocation const ARBlendShapeLocationNoseSneerRight API_AVAILABLE(ios(11.0));
FOUNDATION_EXTERN ARBlendShapeLocation const ARBlendShapeLocationTongueOut API_AVAILABLE(ios(12.0));

@class ARFaceGeometry;

/**
 An anchor representing a face and its geometry.
 */
API_AVAILABLE(ios(11.0))
NS_SWIFT_SENDABLE
@interface ARFaceAnchor : ARAnchor <ARTrackable>

/**
 The face geometry updated based on the computed blend shapes.
 */
@property (nonatomic, strong, readonly) ARFaceGeometry *geometry;

/**
 The left eye’s rotation and translation relative to the anchor’s origin.
 */
@property (nonatomic, assign, readonly) simd_float4x4 leftEyeTransform API_AVAILABLE(ios(12.0));

/**
 The right eye’s rotation and translation relative to the anchor’s origin.
 */
@property (nonatomic, assign, readonly) simd_float4x4 rightEyeTransform API_AVAILABLE(ios(12.0));

/**
 Look-at point relative to the anchor’s origin.
 */
@property (nonatomic, assign, readonly) simd_float3 lookAtPoint API_AVAILABLE(ios(12.0));

/**
 A dictionary of blend shape coefficients for each blend shape location.
 @discussion Blend shapes coefficients define the amount of displacement of a neutral shape at a specific location on the face.
 */
@property (nonatomic, strong, readonly) NSDictionary<ARBlendShapeLocation, NSNumber*> *blendShapes;

/** Unavailable */
- (instancetype)initWithTransform:(simd_float4x4)transform NS_UNAVAILABLE;
- (instancetype)initWithName:(NSString *)name transform:(simd_float4x4)transform NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
#else
#import <ARKitCore/ARFaceAnchor.h> 
#endif // #if (defined(USE_ARKIT_PUBLIC_HEADERS) \&\& USE_ARKIT_PUBLIC_HEADERS) || !__has_include(<ARKitCore/ARFaceAnchor.h>)
~~~~

#### 2026-09-10 23:36:10 +0200 (21:36:10Z) · TOOL CALL · Bash
`f88478cc` · `3d71b0d4` · ligne 241 · Read ARCamera and ARFaceTrackingConfiguration header docs

~~~~bash
SDK=$(xcrun --sdk iphoneos --show-sdk-path); H="$SDK/System/Library/Frameworks/ARKit.framework/Headers"; echo "=========== ARCamera.h ==========="; cat "$H/ARCamera.h"; echo "=========== ARFaceTrackingConfiguration (from ARConfiguration.h) ==========="; grep -n -B5 -A60 "interface ARFaceTrackingConfiguration" "$H/ARConfiguration.h" | head -120
~~~~

#### 2026-09-10 23:36:12 +0200 (21:36:12Z) · TOOL RESULT · Bash
`f88478cc` · `4a66c5b6` · ligne 242 · Read ARCamera and ARFaceTrackingConfiguration header docs

~~~~text
=========== ARCamera.h ===========
#if (defined(USE_ARKIT_PUBLIC_HEADERS) && USE_ARKIT_PUBLIC_HEADERS) || !__has_include(<ARKitCore/ARCamera.h>)
//
//  ARCamera.h
//  ARKit
//
//  Copyright © 2016-2021 Apple Inc. All rights reserved.
//

#import <TargetConditionals.h>

#import <ARKit/ARTrackingStatusTypes.h>
#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>
#import <simd/simd.h>

NS_ASSUME_NONNULL_BEGIN

/**
 A model representing the camera and its parameters.
 */
API_AVAILABLE(ios(11.0))
NS_SWIFT_SENDABLE
@interface ARCamera : NSObject <NSCopying>

/**
 The transformation matrix that defines the camera’s rotation and translation in world coordinates.
 */
@property (nonatomic, readonly) simd_float4x4 transform;

/**
 The camera’s orientation defined as Euler angles.

 @dicussion The order of components in this vector matches the axes of rotation:
               1. Pitch (the x component) is the rotation about the node’s x-axis (in radians)
               2. Yaw   (the y component) is the rotation about the node’s y-axis (in radians)
               3. Roll  (the z component) is the rotation about the node’s z-axis (in radians)
            ARKit applies these rotations in the following order:
               1. first roll
               2. then pitch
               3. then yaw
 */
@property (nonatomic, readonly) simd_float3 eulerAngles;

/**
 The tracking state of the camera.
 */
@property (nonatomic, readonly) ARTrackingState trackingState NS_REFINED_FOR_SWIFT;

/**
 The reason for the camera’s current tracking state.
 */
@property (nonatomic, readonly) ARTrackingStateReason trackingStateReason NS_REFINED_FOR_SWIFT;

/**
 The camera intrinsics.
 @discussion The matrix has the following contents:
 fx 0   px
 0  fy  py
 0  0   1
 fx and fy are the focal length in pixels.
 px and py are the coordinates of the principal point in pixels.
 The origin is at the center of the upper-left pixel.
 */
@property (nonatomic, readonly) simd_float3x3 intrinsics;

/**
 The camera image resolution in pixels.
 */
@property (nonatomic, readonly) CGSize imageResolution;

/**
 The camera exposure duration in seconds.
 */
@property (nonatomic, readonly) NSTimeInterval exposureDuration API_AVAILABLE(ios(13.0));

/**
 The camera exposure offset in EV (exposure value) units.
 */
@property (nonatomic, readonly) float exposureOffset API_AVAILABLE(ios(13.0));

/**
 The projection matrix of the camera.
 @discussion The projection matrix assumes no far clipping plane limit.
*/
@property (nonatomic, readonly) simd_float4x4 projectionMatrix;


typedef NS_ENUM(NSInteger, UIInterfaceOrientation);

/**
 Creates a projection matrix for the camera given rendering parameters.

 @discussion The projection matrix returned provides an aspect fill for the provided viewport size and orientation.
 If zFar is set to 0, an infinite projection matrix will be returned.
 @param orientation Viewport orientation.
 @param viewportSize Viewport size.
 @param zNear Near depth limit.
 @param zFar Far depth limit.
 */
- (simd_float4x4)projectionMatrixForOrientation:(UIInterfaceOrientation)orientation
                                   viewportSize:(CGSize)viewportSize
                                          zNear:(CGFloat)zNear
                                           zFar:(CGFloat)zFar;

/**
 Project a 3D point in world coordinate system into 2D viewport space.

 @param point 3D point in world coordinate system.
 @param orientation Viewport orientation.
 @param viewportSize Viewport (or image) size.
 @return 2D point in viewport coordinate system with origin at top-left.
 */
- (CGPoint)projectPoint:(simd_float3)point orientation:(UIInterfaceOrientation)orientation viewportSize:(CGSize)viewportSize;

/**
 Unproject a 2D point from the viewport onto a plane in 3D world coordinates.

 @discussion A 2D point in the viewport coordinate space can refer to any point along a line segment
 in the 3D coordinate space. Unprojecting calculates the 3D position of the point along this line segment that intersects the provided plane.
 @param point A point in the viewport coordinate system with origin at top-left.
 @param planeTransform The transform used to define the coordinate system of the plane.
 The coordinate system’s positive Y axis is assumed to be the normal of the plane.
 @return 3D position in world coordinates or a NAN values if unprojection is not possible.
 */
- (simd_float3)unprojectPoint:(CGPoint)point
       ontoPlaneWithTransform:(simd_float4x4)planeTransform
                  orientation:(UIInterfaceOrientation)orientation
                 viewportSize:(CGSize)viewportSize API_AVAILABLE(ios(12.0))NS_REFINED_FOR_SWIFT;

/**
 Returns the view matrix for the camera with a given interface orientation.

 @discussion The view matrix can be used to transform geometry from world space into camera space for a given orientation.
 @param orientation The interface orientation that will be used to render the camera’s view.
 */
- (simd_float4x4)viewMatrixForOrientation:(UIInterfaceOrientation)orientation;


/** Unavailable */
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
#else
#import <ARKitCore/ARCamera.h> 
#endif // #if (defined(USE_ARKIT_PUBLIC_HEADERS) \&\& USE_ARKIT_PUBLIC_HEADERS) || !__has_include(<ARKitCore/ARCamera.h>)=========== ARFaceTrackingConfiguration (from ARConfiguration.h) ===========
361- @discussion Face tracking uses the front facing camera to track the face in 3D providing details on the topology and expression of the face.
362- A detected face will be added to the session as an ARFaceAnchor object which contains information about head pose, mesh, eye pose, and blend shape
363- coefficients. If light estimation is enabled the detected face will be treated as a light probe and used to estimate the direction of incoming light.
364- */
365-API_AVAILABLE(ios(11.0))
366:@interface ARFaceTrackingConfiguration : ARConfiguration
367-
368-/**
369- Maximum number of faces which can be tracked simultaneously.
370- */
371-@property (class, nonatomic, readonly) NSInteger supportedNumberOfTrackedFaces API_AVAILABLE(ios(13.0));
372-
373-/**
374- Maximum number of faces to track simultaneously.
375- @discussion Setting the maximum number of tracked faces will limit the number of faces that can be tracked in a given frame.
376- If more than the maximum is visible, only the faces already being tracked will continue to track until tracking is lost or another face is removed.
377- Default value is one.
378- */
379-@property (nonatomic, assign) NSInteger maximumNumberOfTrackedFaces API_AVAILABLE(ios(13.0));
380-
381-/**
382- Indicates whether world tracking can be enabled on this device.
383- */
384-@property (class, nonatomic, readonly) BOOL supportsWorldTracking API_AVAILABLE(ios(13.0));
385-
386-/**
387- Enable or disable World Tracking. Disabled by default.
388-
389- @discussion When enabled, ARSession uses the back facing camera to track the device's orientation and position in the world. The camera transform and
390- the ARFaceAnchor transform will be in the world coordinate space.
391- */
392-@property (nonatomic, assign, getter=isWorldTrackingEnabled) BOOL worldTrackingEnabled API_AVAILABLE(ios(13.0));
393-
394-- (instancetype)init;
395-+ (instancetype)new NS_SWIFT_UNAVAILABLE("Use init() instead");
396-
397-@end
398-
399-/**
400- A configuration for running image tracking.
401-
402- @discussion Image tracking provides 6 degrees of freedom tracking of known images. Four images may be tracked simultaneously.
403- */
404-API_AVAILABLE(ios(12.0))
405-@interface ARImageTrackingConfiguration : ARConfiguration
406-
407-/**
408- Enable or disable continuous auto focus.
409- @discussion Enabled by default.
410- */
411-@property (nonatomic, assign, getter=isAutoFocusEnabled) BOOL autoFocusEnabled;
412-
413-/**
414- Images to track in the scene.
415- */
416-@property (nonatomic, copy) NSSet<ARReferenceImage *> *trackingImages;
417-
418-/**
419- Maximum number of images to track simultaneously.
420- @discussion Setting the maximum number of tracked images will limit the number of images that can be tracked in a given frame.
421- If more than the maximum is visible, only the images already being tracked will continue to track until tracking is lost or another image is removed.
422- Default value is one.
423- */
424-@property (nonatomic, assign) NSInteger maximumNumberOfTrackedImages;
425-
426-- (instancetype)init;
~~~~

#### 2026-09-10 23:36:12 +0200 (21:36:12Z) · TOOL CALL · WebFetch
`f88478cc` · `0a487228` · ligne 244

~~~~json
{
 "url": "https://developer.apple.com/tutorials/data/documentation/arkit/arfaceanchor.json",
 "prompt": "This is Apple's documentation JSON. Extract and quote all text describing the face coordinate system (origin location, direction of +x, +y, +z axes relative to the user's face), the lookAtPoint, leftEyeTransform/rightEyeTransform, and any mention of mirroring. Quote exact sentences."
}
~~~~

#### 2026-09-10 23:36:14 +0200 (21:36:14Z) · TOOL CALL · WebFetch
`f88478cc` · `68888779` · ligne 245

~~~~json
{
 "url": "https://developer.apple.com/tutorials/data/documentation/arkit/arfaceanchor/lookatpoint.json",
 "prompt": "This is Apple's documentation JSON for lookAtPoint. Quote all the descriptive text (abstract and discussion) exactly."
}
~~~~

#### 2026-09-10 23:36:15 +0200 (21:36:15Z) · TOOL CALL · WebFetch
`f88478cc` · `40403083` · ligne 246

~~~~json
{
 "url": "https://developer.apple.com/tutorials/data/documentation/arkit/arcamera/transform.json",
 "prompt": "This is Apple's documentation JSON for ARCamera.transform. Quote all the descriptive text (abstract and discussion) exactly, especially anything about landscape-right orientation, axis directions, and interface orientation."
}
~~~~

#### 2026-09-10 23:36:17 +0200 (21:36:17Z) · TOOL CALL · WebFetch
`f88478cc` · `948dc98d` · ligne 247

~~~~json
{
 "url": "https://developer.apple.com/tutorials/data/documentation/arkit/arfacetrackingconfiguration.json",
 "prompt": "This is Apple's documentation JSON. Quote all descriptive text (abstract, overview, discussion) exactly, especially anything about mirroring of the front camera, world coordinate orientation in face tracking, isSupported, frame rate, worldAlignment."
}
~~~~

#### 2026-09-10 23:36:17 +0200 (21:36:17Z) · TOOL RESULT · WebFetch
`f88478cc` · `fef23f06` · ligne 248

~~~~text
# ARFaceAnchor.lookAtPoint Documentation

## Abstract
"A position in face coordinate space estimating the direction of the face's gaze."

## Discussion
"This vector abstracts from the leftEyeTransform and rightEyeTransform matrices to estimate what point, relative to the face, the user's eyes are focused upon. For example:

- "If the user is looking to the left, the vector has a positive x-axis component."
- "If the user is focused on a nearby object, the vector's length is shorter."
- "If the user is focused on a faraway object, the vector's length is longer."

## Declaration
```swift
var lookAtPoint: simd_float3 { get }
```

## Availability
- iOS 12.0+
- iPadOS 12.0+
~~~~

#### 2026-09-10 23:36:17 +0200 (21:36:17Z) · TOOL RESULT · WebFetch
`f88478cc` · `ae9372e0` · ligne 255

~~~~text
# Face Coordinate System and Eye Tracking in ARFaceAnchor

## Face Coordinate System

**Origin and Axis Directions:**

> "This transform matrix creates a face coordinates system for positioning other elements relative to the face. Units of face coordinate space are in meters, with the origin centered behind the face as indicated in the figure below."

> "The coordinate system is right-handed—the positive x direction points to the viewer's right (that is, the face's own left), the positive y direction points up (relative to the face itself, not to the world), and the positive z direction points outward from the face (toward the viewer)."

## Eye Tracking Properties

**leftEyeTransform:**
> "A transform matrix indicating the position and orientation of the face's left eye."

**rightEyeTransform:**
> "A transform matrix indicating the position and orientation of the face's right eye."

**lookAtPoint:**
> "A position in face coordinate space estimating the direction of the face's gaze."

## Important Note on Face Tracking Configuration

> "When you track faces using ARFaceTrackingConfiguration, ARKit can track multiple faces simultaneously."

The documentation does **not** explicitly mention mirroring in the provided content, though the coordinate system description clarifies the left/right orientation relative to the viewer versus the face itself.
~~~~

#### 2026-09-10 23:36:20 +0200 (21:36:20Z) · TOOL RESULT · WebFetch
`f88478cc` · `b8333186` · ligne 256

~~~~text
# ARCamera.transform Documentation

## Abstract
"The position and orientation of the camera in world coordinate space."

## Discussion

**World Coordinate Space:**
"World coordinate space in ARKit always follows a right-handed convention, but is oriented based on the session configuration. For details, see Understanding World Tracking."

**Camera Space and Device Orientation:**
"This transform creates a local coordinate space for the camera that is constant with respect to device orientation. In camera space, the x-axis points to the right when the device is in landscapeLeft orientation—that is, the x-axis always points along the long axis of the device, from the front-facing camera toward the Home button. The y-axis points upward (with respect to landscapeLeft orientation), and the z-axis points away from the device on the screen side."

## Declaration
```swift
var transform: simd_float4x4 { get }
```

## Key Points
- Returns a 4x4 matrix (`simd_float4x4`) representing camera position and orientation
- The coordinate system is device-orientation-independent
- Reference orientation is **landscapeLeft** (device held upright with front-facing camera on left)
- **X-axis**: Points along device's long axis toward Home button
- **Y-axis**: Points upward (relative to landscapeLeft)
- **Z-axis**: Points away from device screen
~~~~

#### 2026-09-10 23:36:24 +0200 (21:36:24Z) · TOOL RESULT · WebFetch
`f88478cc` · `65fca753` · ligne 257

~~~~text
# ARFaceTrackingConfiguration

## Overview

**"A configuration that tracks facial movement and expressions using the front camera."**

`ARFaceTrackingConfiguration` is a class in ARKit that enables face tracking in AR sessions. When initialized, it detects faces within 3 meters of the device's front camera and creates `ARFaceAnchor` objects containing facial position, orientation, topology, and expression data.

## Key Capabilities

### Face Detection & Tracking
**"A face-tracking configuration detects faces within 3 meters of the device's front camera. When ARKit detects a face, it creates an `ARFaceAnchor` object that provides information about a person's facial position, orientation, topology, and expressions."**

### Device Support Requirements
**"Face tracking supports devices with Apple Neural Engine in iOS 14 and iPadOS 14 and requires a device with a TrueDepth camera on iOS 13 and iPadOS 13 and earlier. To determine whether the device supports face tracking, call `isSupported` on `ARFaceTrackingConfiguration` before attempting to use this configuration."**

### Light Estimation
When enabled, **"a face-tracking configuration estimates directional and environmental lighting (an `ARDirectionalLightEstimate` object) by referring to the detected face as a light probe."**

## Key Properties

- **`maximumNumberOfTrackedFaces`**: The number of faces to track during the session
- **`supportedNumberOfTrackedFaces`**: The maximum number of faces the framework can track
- **`isWorldTrackingEnabled`**: **"A Boolean value that instructs a session to provide the app with the device's six degrees of freedom pose during a face-tracking session"**
- **`supportsWorldTracking`**: Indicates if the device supports world tracking with facial features
- **`isEnvironmentTexturingEnabled`**: Enable or disable environment texturing

## Privacy Considerations

⚠️ **"Because face tracking provides your app with personal facial information, your app must include a privacy policy describing to users how you intend to use face tracking and face data."**
~~~~

#### 2026-09-10 23:41:31 +0200 (21:41:31Z) · TOOL CALL · Bash
`f88478cc` · `b73f9089` · ligne 262 · Compute reference LCG and level values with Python for Swift tests

~~~~bash
cd "/private/tmp/claude-501/-Volumes-Steve-Pro-BlackSSD-Dev-App-Mobile-Iris/f88478cc-d512-4210-bc11-758059278995/scratchpad" && cat > ref_levels.py <<'EOF'
# Independent reproduction of the JS level generator / LCG to obtain reference values for Swift tests.
def rng_for(seed):
    s = [seed]
    def r():
        s[0] = (s[0] * 9301 + 49297) % 233280
        return s[0] / 233280
    return r

def random_point(rng, margin=0.2):
    return [margin + rng() * (1 - 2 * margin), margin + rng() * (1 - 2 * margin)]

def build_level(n):
    rng = rng_for(2000 + n * 97)
    if n < 3: count, zone, krep, attr = 1, 220, 0.008, 0.6
    elif n < 8: count, zone, krep, attr = 2, 190, 0.009, 0.55
    else: count, zone, krep, attr = 3, 150, 0.013, 0.5
    targets = []
    for i in range(count):
        targets.append(dict(seq=i+1, start=random_point(rng), arrival=random_point(rng), zone=zone*1.6, krep=krep, attr=attr))
    return targets

print("LCG seed 2000 first 6 values:")
r = rng_for(2000)
print([repr(r()) for _ in range(6)])
print("LCG seed 1000 first 4 values (noise table seed of target 0):")
r = rng_for(1000)
print([repr(r()) for _ in range(4)])
for n in range(14):
    lv = build_level(n)
    print(f"level {n+1}: count={len(lv)} zone={lv[0]['zone']} krep={lv[0]['krep']} attr={lv[0]['attr']}")
    for t in lv:
        print("   seq", t['seq'], "start", [repr(v) for v in t['start']], "arrival", [repr(v) for v in t['arrival']])

# noise table for seed 1000 (first 5 entries): rand()*2-1
def make_noise_table(seed):
    r = rng_for(seed)
    return [r()*2-1 for _ in range(256)]
tbl = make_noise_table(1000)
print("noise table seed 1000 [0..4]:", [repr(v) for v in tbl[:5]])
# noise(0.5) = lerp(tbl[0], tbl[1], smoothstep(0.5)=0.5)
u = 0.5*0.5*(3-2*0.5)
print("noise(0.5) seed 1000:", repr(tbl[0]*(1-u)+tbl[1]*u))
print("noise(255.25) seed 1000:", end=" ")
f=0.25; u=f*f*(3-2*f); print(repr(tbl[255]*(1-u)+tbl[0]*u))
EOF
python3 ref_levels.py; echo "node:"; which node || echo "no node"
~~~~

#### 2026-09-10 23:41:33 +0200 (21:41:33Z) · TOOL RESULT · Bash
`f88478cc` · `3133f708` · ligne 269 · Compute reference LCG and level values with Python for Swift tests

~~~~text
LCG seed 2000 first 6 values:
['0.9524048353909464', '0.5286951303155006', '0.6047282235939644', '0.7885288065843621', '0.31775120027434844', '0.6152349108367627']
LCG seed 1000 first 4 values (noise table seed of target 0):
['0.08186299725651577', '0.6190586419753087', '0.07575017146776405', '0.7636659807956104']
level 1: count=1 zone=352.0 krep=0.008 attr=0.6
   seq 1 start ['0.7714429012345678', '0.5172170781893004'] arrival ['0.5628369341563786', '0.6731172839506172']
level 2: count=1 zone=352.0 krep=0.008 attr=0.6
   seq 1 start ['0.6919084362139918', '0.5671579218106997'] arrival ['0.6626234567901235', '0.5875643004115226']
level 3: count=1 zone=352.0 krep=0.008 attr=0.6
   seq 1 start ['0.6123739711934156', '0.6170987654320987'] arrival ['0.7624099794238683', '0.5020113168724281']
level 4: count=2 zone=304.0 krep=0.009 attr=0.55
   seq 1 start ['0.5328395061728395', '0.667039609053498'] arrival ['0.2621965020576132', '0.4164583333333334']
   seq 2 start ['0.6057510288065844', '0.2171116255144033'] arrival ['0.4820216049382716', '0.20974022633744857']
level 5: count=2 zone=304.0 krep=0.009 attr=0.55
   seq 1 start ['0.4533050411522634', '0.7169804526748971'] arrival ['0.361983024691358', '0.3309053497942387']
   seq 2 start ['0.4774511316872428', '0.2997685185185185'] arrival ['0.6737834362139918', '0.5865329218106996']
level 6: count=2 zone=304.0 krep=0.009 attr=0.55
   seq 1 start ['0.37377057613168724', '0.7669212962962964'] arrival ['0.4617695473251029', '0.24535236625514406']
   seq 2 start ['0.3491512345679012', '0.38242541152263376'] arrival ['0.26554526748971197', '0.36332561728395063']
level 7: count=2 zone=304.0 krep=0.009 attr=0.55
   seq 1 start ['0.29423611111111114', '0.21686213991769548'] arrival ['0.5615560699588478', '0.7597993827160494']
   seq 2 start ['0.22085133744855967', '0.465082304526749'] arrival ['0.4573070987654321', '0.7401183127572017']
level 8: count=2 zone=304.0 krep=0.009 attr=0.55
   seq 1 start ['0.214701646090535', '0.26680298353909465'] arrival ['0.6613425925925925', '0.6742463991769547']
   seq 2 start ['0.6925514403292181', '0.5477391975308642'] arrival ['0.6490689300411523', '0.5169110082304527']
level 9: count=3 zone=240.0 krep=0.013 attr=0.5
   seq 1 start ['0.7351671810699587', '0.3167438271604939'] arrival ['0.7611291152263373', '0.58869341563786']
   seq 2 start ['0.5642515432098765', '0.6303960905349795'] arrival ['0.24083076131687242', '0.2937037037037037']
   seq 3 start ['0.6649408436213992', '0.5415792181069958'] arrival ['0.3551003086419753', '0.5147633744855967']
level 10: count=3 zone=240.0 krep=0.013 attr=0.5
   seq 1 start ['0.6556327160493827', '0.36668467078189304'] arrival ['0.2609156378600823', '0.5031404320987654']
   seq 2 start ['0.43595164609053494', '0.7130529835390946'] arrival ['0.43259259259259264', '0.6704963991769548']
   seq 3 start ['0.613801440329218', '0.6939891975308642'] arrival ['0.7203189300411523', '0.2131610082304527']
level 11: count=3 zone=240.0 krep=0.013 attr=0.5
   seq 1 start ['0.5760982510288066', '0.4166255144032922'] arrival ['0.3607021604938272', '0.4175874485596708']
   seq 2 start ['0.3076517489711934', '0.7957098765432098'] arrival ['0.6243544238683127', '0.4472890946502058']
   seq 3 start ['0.562662037037037', '0.2463991769547325'] arrival ['0.48553755144032923', '0.5115586419753086']
level 12: count=3 zone=240.0 krep=0.013 attr=0.5
   seq 1 start ['0.4965637860082305', '0.4665663580246914'] arrival ['0.460488683127572', '0.33203446502057615']
   seq 2 start ['0.7793518518518519', '0.2783667695473251'] arrival ['0.21611625514403293', '0.2240817901234568']
   seq 3 start ['0.511522633744856', '0.3988091563786008'] arrival ['0.2507561728395062', '0.20995627572016462']
level 13: count=3 zone=240.0 krep=0.013 attr=0.5
   seq 1 start ['0.41702932098765433', '0.5165072016460905'] arrival ['0.5602752057613168', '0.2464814814814815']
   seq 2 start ['0.6510519547325102', '0.36102366255144036'] arrival ['0.4078780864197531', '0.6008744855967079']
   seq 3 start ['0.4603832304526749', '0.5512191358024692'] arrival ['0.6159747942386831', '0.5083539094650206']
level 14: count=3 zone=240.0 krep=0.013 attr=0.5
   seq 1 start ['0.3374948559670782', '0.5664480452674897'] arrival ['0.6600617283950616', '0.7609284979423867']
   seq 2 start ['0.5227520576131688', '0.4436805555555556'] arrival ['0.5996399176954732', '0.3776671810699589']
   seq 3 start ['0.4092438271604938', '0.7036291152263374'] arrival ['0.3811934156378601', '0.20675154320987654']
noise table seed 1000 [0..4]: ['-0.8362740054869684', '0.23811728395061738', '-0.8484996570644718', '0.5273319615912209', '-0.8627829218106996']
noise(0.5) seed 1000: -0.2990783607681755
noise(255.25) seed 1000: 0.6082789459019204
node:
/usr/local/bin/node
Shell cwd was reset to /Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris
~~~~

#### 2026-09-10 23:43:02 +0200 (21:43:02Z) · TOOL CALL · Bash
`f88478cc` · `2b9e0124` · ligne 275 · Generate golden engine traces from a faithful Node extraction of the JS engine

~~~~bash
cd "/private/tmp/claude-501/-Volumes-Steve-Pro-BlackSSD-Dev-App-Mobile-Iris/f88478cc-d512-4210-bc11-758059278995/scratchpad" && cat > golden.js <<'EOF'
// Faithful extraction of the physics/validation core of attention-indirecte.html (no canvas, no audio).
// Produces golden traces used by the Swift test-suite to prove the port is numerically equivalent.
function makeNoise1D(seed) {
  let s = seed;
  function rand() { s = (s * 9301 + 49297) % 233280; return s / 233280; }
  const table = Array.from({length: 256}, () => rand() * 2 - 1);
  return function noise(t) {
    const i = Math.floor(t) % 256;
    const f = t - Math.floor(t);
    const a = table[i], b = table[(i + 1) % 256];
    const u = f * f * (3 - 2 * f);
    return a * (1 - u) + b * u;
  };
}
const GAZE_ZONE_MULTIPLIER = 1.6;
function rngFor(seed) { let s = seed; return () => { s = (s * 9301 + 49297) % 233280; return s / 233280; }; }
function randomPoint(rng, margin = 0.2) { return [margin + rng() * (1 - 2 * margin), margin + rng() * (1 - 2 * margin)]; }
function buildLevel(n) {
  const rng = rngFor(2000 + n * 97);
  let count, zone, krep, attr;
  if (n < 3) { count = 1; zone = 220; krep = 0.008; attr = 0.6; }
  else if (n < 8) { count = 2; zone = 190; krep = 0.009; attr = 0.55; }
  else { count = 3; zone = 150; krep = 0.013; attr = 0.5; }
  const targets = [];
  for (let i = 0; i < count; i++) {
    targets.push({ seq: i + 1, start: randomPoint(rng), arrival: randomPoint(rng), zone_attention: zone * GAZE_ZONE_MULTIPLIER, k_repulsion: krep, attraction_passive: attr, amplitude_bruit: 0.15 });
  }
  return { id: `level_${String(n + 1).padStart(2, '0')}`, hold_time_frames: 45, targets, sequential: count > 1 };
}
const RADIUS_TARGET = 24, RADIUS_ARRIVAL = 40, VITESSE_MAX = 2.2, FRICTION = 0.94, MARGE_BORD = 60, PERTE_REBOND = 0.5;

function run(levelIndex, canvas, cursorAt, frames) {
  const level = buildLevel(levelIndex);
  const targets = level.targets.map((cfg, i) => ({
    seq: cfg.seq, x: cfg.start[0] * canvas.width, y: cfg.start[1] * canvas.height, vx: 0, vy: 0,
    arrivalX: cfg.arrival[0] * canvas.width, arrivalY: cfg.arrival[1] * canvas.height,
    zone_attention: cfg.zone_attention, k_repulsion: cfg.k_repulsion, attraction_passive: cfg.attraction_passive,
    amplitude_bruit: cfg.amplitude_bruit, noise: makeNoise1D(1000 + i * 137), holdFrames: 0, holdRequired: level.hold_time_frames, settled: false
  }));
  const levelSequential = level.sequential;
  let t = 0;
  const trace = [];
  const events = [];
  for (let frame = 1; frame <= frames; frame++) {
    const cursor = cursorAt(frame);
    t += 1;
    let allSettled = true;
    let lowestUnsettledSeq = Infinity;
    if (levelSequential) { for (const tg of targets) if (!tg.settled) lowestUnsettledSeq = Math.min(lowestUnsettledSeq, tg.seq); }
    for (const target of targets) {
      const dx = target.x - cursor.x, dy = target.y - cursor.y;
      const d = Math.hypot(dx, dy) || 0.0001;
      if (d < target.zone_attention) {
        const force = target.k_repulsion * (target.zone_attention - d);
        target.vx += (dx / d) * force; target.vy += (dy / d) * force;
      } else {
        const adx = target.arrivalX - target.x, ady = target.arrivalY - target.y;
        const ad = Math.hypot(adx, ady) || 0.0001;
        target.vx += (adx / ad) * target.attraction_passive; target.vy += (ady / ad) * target.attraction_passive;
        target.vx += target.noise(t * 0.02) * target.amplitude_bruit;
        target.vy += target.noise(t * 0.02 + 50) * target.amplitude_bruit;
      }
      const speed = Math.hypot(target.vx, target.vy);
      if (speed > VITESSE_MAX) { target.vx = (target.vx / speed) * VITESSE_MAX; target.vy = (target.vy / speed) * VITESSE_MAX; }
      target.vx *= FRICTION; target.vy *= FRICTION;
      target.x += target.vx; target.y += target.vy;
      if (target.x < MARGE_BORD) { target.x = MARGE_BORD; target.vx *= -PERTE_REBOND; }
      if (target.x > canvas.width - MARGE_BORD) { target.x = canvas.width - MARGE_BORD; target.vx *= -PERTE_REBOND; }
      if (target.y < MARGE_BORD) { target.y = MARGE_BORD; target.vy *= -PERTE_REBOND; }
      if (target.y > canvas.height - MARGE_BORD) { target.y = canvas.height - MARGE_BORD; target.vy *= -PERTE_REBOND; }
      const distToArrival = Math.hypot(target.x - target.arrivalX, target.y - target.arrivalY);
      const isTargetsTurn = !levelSequential || target.settled || target.seq === lowestUnsettledSeq;
      const SETTLE_RADIUS = RADIUS_ARRIVAL - RADIUS_TARGET;
      const WOBBLE_TOLERANCE = SETTLE_RADIUS + 20;
      const wasSettled = target.settled;
      if (target.settled) { if (distToArrival > WOBBLE_TOLERANCE) { target.settled = false; target.holdFrames = 0; } }
      else if (distToArrival < SETTLE_RADIUS && isTargetsTurn) { target.holdFrames += 1; target.settled = target.holdFrames >= target.holdRequired; }
      else { target.holdFrames = 0; }
      if (target.settled && !wasSettled) events.push({frame, type: 'validated', seq: target.seq});
      else if (!target.settled && wasSettled) events.push({frame, type: 'lost', seq: target.seq});
      if (!target.settled) allSettled = false;
    }
    if (levelSequential) {
      let brokenSeq = Infinity;
      for (const tg of targets) if (!tg.settled) { brokenSeq = Math.min(brokenSeq, tg.seq); break; }
      for (const tg of targets) { if (tg.settled && tg.seq > brokenSeq) { tg.settled = false; tg.holdFrames = 0; events.push({frame, type: 'cascade', seq: tg.seq}); allSettled = false; } }
    }
    trace.push(targets.map(tg => ({x: tg.x, y: tg.y, vx: tg.vx, vy: tg.vy, hold: tg.holdFrames, settled: tg.settled})));
    if (allSettled) { events.push({frame, type: 'levelCompleted'}); break; }
  }
  return { levelIndex, canvas, frames: trace.length, trace, events };
}
const canvas = { width: 390, height: 844 };
const scenarioA = run(0, canvas, f => (f <= 120 || f > 240) ? {x: 60, y: 60} : {x: 230, y: 560}, 420);
const scenarioB = run(8, canvas, f => ({x: 60, y: 60}), 900);
const fs = require('fs');
fs.writeFileSync('golden_level1_scripted.json', JSON.stringify(scenarioA));
fs.writeFileSync('golden_level9_far.json', JSON.stringify(scenarioB));
console.log('A frames', scenarioA.frames, 'events', JSON.stringify(scenarioA.events));
console.log('A frame1', JSON.stringify(scenarioA.trace[0]));
console.log('A frame120', JSON.stringify(scenarioA.trace[119]));
console.log('A last', JSON.stringify(scenarioA.trace[scenarioA.frames-1]));
console.log('B frames', scenarioB.frames, 'events', JSON.stringify(scenarioB.events));
console.log('B last', JSON.stringify(scenarioB.trace[scenarioB.frames-1]));
EOF
node golden.js && ls -la golden_*.json
~~~~

#### 2026-09-10 23:43:04 +0200 (21:43:04Z) · TOOL RESULT · Bash
`f88478cc` · `935a563e` · ligne 276 · Generate golden engine traces from a faithful Node extraction of the JS engine

~~~~text
A frames 113 events [{"frame":113,"type":"validated","seq":1},{"frame":113,"type":"levelCompleted"}]
A frame1 [{"x":300.44839007114757,"y":437.06228635521705,"vx":-0.41434141033385014,"vy":0.5310723634474802,"hold":0,"settled":false}]
A frame120 undefined
A last [{"x":220.44865691156656,"y":569.0579367399899,"vx":-0.28561025214083097,"vy":0.08066220076252771,"hold":45,"settled":true}]
B frames 900 events [{"frame":151,"type":"validated","seq":1}]
B last [{"x":297.13366142205206,"y":497.1613842059723,"vx":0.3003361865659169,"vy":0.34189001596806173,"hold":45,"settled":true},{"x":100.23008788248923,"y":294.5814421177278,"vx":0.019297229200540274,"vy":0.027001453647987707,"hold":0,"settled":false},{"x":138.86709584247288,"y":433.9159562526402,"vx":-0.20590622449198862,"vy":0.2897182176489995,"hold":0,"settled":false}]
-rw-r--r--  1 prodx0x  wheel   14044 10 sept. 23:43 golden_level1_scripted.json
-rw-r--r--  1 prodx0x  wheel  331498 10 sept. 23:43 golden_level9_far.json
Shell cwd was reset to /Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris
~~~~

#### 2026-09-10 23:43:33 +0200 (21:43:33Z) · TOOL CALL · Bash
`f88478cc` · `aae43314` · ligne 278 · Write project brief, conventions and file-map foundation docs

~~~~bash
cd "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris" && mkdir -p Docs/Features && cat > Docs/project-brief.md <<'EOF'
# Project Brief

## App
Iris. A native iOS game where the player guides spheres to their arrival points by not looking at them: a direct gaze repels a sphere, indirect attention lets it drift home. Category: utility-style single-purpose game (perception, attention).

## Bundle
Bundle identifier `com.prodx0x.iris`. Minimum iOS 17.0. Swift 6 language mode, strict concurrency complete. Xcode 26.3 (build 17C529), iOS SDK 26.2.

## User
A curious iPhone owner with a Face ID device who wants a short, calm, unusual game session. The frustration removed: every gaze-driven experience they tried needed a clunky calibration or a browser and a webcam. Iris starts in seconds, needs no calibration and runs fully on device.

## Core promise
The only skill is distributing attention without fixing it. Looking at a sphere pushes it away; leaving it alone lets it arrive. Fourteen levels, no timer, no lives, no score.

## Data
No persistence beyond the running session. No account, no server, no analytics. Gaze data is consumed in real time and never stored. No video, no face representation is written anywhere.

## Business model
Free. No StoreKit, no entitlements, no feature gating.

## Dependency policy
Zero third-party. Apple frameworks only: SwiftUI, ARKit, AVFoundation, AVAudioEngine, Observation.

## Reference engine
`attention-indirecte.html` at the project root is the functional source of truth (constants, physics, validation, cascade, audio, rendering intent). It is never modified, moved or replaced. The Swift engine is a native re-implementation, not a WebView.

## Non-goals
- No manual gaze calibration flow.
- No multiplayer, leaderboard or cloud sync.
- No landscape orientation in v1 (portrait only keeps gaze projection deterministic).
EOF
cat > Docs/conventions.md <<'EOF'
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
| Entity | Noun, no suffix | `Target` |
| Value object | Noun, no suffix | `Vector2` |
| Service protocol | `<Noun>Service` | `GazeTrackingService` |
| Service impl | `<Tech><Noun>Service` | `ARKitGazeTrackingService` |
| Rule | `<Noun>Rule` or `<Noun>Rules` | `CascadeRule` |
| ViewModel | `<Screen>ViewModel` | `GameViewModel` |
| View | `<Screen>View` | `HomeView` |
| Coordinator | `AppCoordinator` | |
| Route enum | `AppRoute` | |
| Test | `<TypeUnderTest>Tests` | `CascadeRuleTests` |
| Mock | `Mock<Protocol>` | `MockAudioService` |
| DS component | `DS<Name>` | `DSButton` |

## File rules
- One top-level type per file. File name equals type name. Small private helper types may live next to their only consumer.
- No file over 300 lines. Split by concern.
- No catch-all files.
- Every new file is registered in `Docs/file-map.md`.

## Code style
- Access control: `private` by default, widen only when needed.
- Every external capability (gaze, audio, ticking) is a protocol. Concrete types are injected.
- ViewModels expose state as `private(set)` stored properties and actions as methods. No `import SwiftUI` in ViewModels.
- Views are dumb: read state, call actions, render with tokens and DS components.
- No force unwrap, no `try!`, no `as!`.
- User-facing copy in French, hardcoded (no catalog in v1). Code identifiers and comments in English.
- No `TODO` left in code.

## Testing
- Unit tests: Swift Testing (`@Test`, `#expect`). One test file per type.
- Golden traces generated from the reference JavaScript engine live in `Tests/IrisTests/Fixtures/`.
- Mocks are hand-written in `Tests/IrisTests/Mocks/`.
- No test touches network, disk (beyond bundle fixtures), camera or audio hardware.

## Dependencies
- Policy: zero third-party. Allowed packages: none.

## Localisation
- French only for v1. Base language: fr.
EOF
cat > Docs/file-map.md <<'EOF'
# File Map

Registry of every source file in the project. One row per file. Updated by every skill that creates or deletes a file. Search this table before creating anything.

| Path | Type | Layer | Purpose | Created by |
|---|---|---|---|---|
EOF
echo "docs written"; ls Docs
~~~~

#### 2026-09-10 23:43:35 +0200 (21:43:35Z) · TOOL RESULT · Bash
`f88478cc` · `776ddd34` · ligne 285 · Write project brief, conventions and file-map foundation docs

~~~~text
docs written
conventions.md
Features
file-map.md
project-brief.md
~~~~

#### 2026-09-10 23:46:24 +0200 (21:46:24Z) · TOOL CALL · Bash
`f88478cc` · `811cda1f` · ligne 292 · Regenerate golden traces with repulsion phase and full 1-2-3 ordering, copy into test fixtures

~~~~bash
cd "/private/tmp/claude-501/-Volumes-Steve-Pro-BlackSSD-Dev-App-Mobile-Iris/f88478cc-d512-4210-bc11-758059278995/scratchpad" && python3 - <<'EOF'
import re
src = open('golden.js').read()
src = src.replace("const scenarioA = run(0, canvas, f => (f <= 120 || f > 240) ? {x: 60, y: 60} : {x: 230, y: 560}, 420);",
                  "const scenarioA = run(0, canvas, f => (f <= 150) ? {x: 230, y: 560} : {x: 60, y: 60}, 600);")
src = src.replace("const scenarioB = run(8, canvas, f => ({x: 60, y: 60}), 900);",
                  "const scenarioB = run(8, canvas, f => ({x: 330, y: 784}), 1200);")
open('golden.js','w').write(src)
EOF
node golden.js && mkdir -p "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris/Tests/IrisTests/Fixtures" && cp golden_level1_scripted.json golden_level9_far.json "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris/Tests/IrisTests/Fixtures/" && cp golden.js "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris/Tests/IrisTests/Fixtures/golden_generator.js" && ls -la "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris/Tests/IrisTests/Fixtures/"
~~~~

#### 2026-09-10 23:46:26 +0200 (21:46:26Z) · TOOL RESULT · Bash
`f88478cc` · `55b7bbd3` · ligne 299 · Regenerate golden traces with repulsion phase and full 1-2-3 ordering, copy into test fixtures

~~~~text
A frames 393 events [{"frame":393,"type":"validated","seq":1},{"frame":393,"type":"levelCompleted"}]
A frame1 [{"x":301.64747426388163,"y":435.16390515895955,"vx":0.7847427824001975,"vy":-1.3673088328100074,"hold":0,"settled":false}]
A frame120 [{"x":320.8759552300843,"y":228.75091094791154,"vx":-0.7445212125343678,"vy":0.6980043147807872,"hold":0,"settled":false}]
A last [{"x":219.08567476002602,"y":567.3151571356335,"vx":-0.00485886260956006,"vy":-1.1412045458735456,"hold":45,"settled":true}]
B frames 241 events [{"frame":151,"type":"validated","seq":1},{"frame":196,"type":"validated","seq":2},{"frame":241,"type":"validated","seq":3},{"frame":241,"type":"levelCompleted"}]
B last [{"x":296.2160284814024,"y":497.55977520276974,"vx":-0.008265080973438586,"vy":-0.09701622500383872,"hold":45,"settled":true},{"x":93.482388442536,"y":247.90901792746254,"vx":0.565019546813623,"vy":0.6535039854001713,"hold":45,"settled":true},{"x":138.02102843692987,"y":434.2254932362383,"vx":-1.0217004660620106,"vy":-0.37921226805401953,"hold":45,"settled":true}]
total 288
drwxr-xr-x  5 prodx0x  staff    160 10 sept. 23:46 .
drwxr-xr-x  3 prodx0x  staff     96 10 sept. 23:46 ..
-rw-r--r--  1 prodx0x  staff   6459 10 sept. 23:46 golden_generator.js
-rw-r--r--  1 prodx0x  staff  46909 10 sept. 23:46 golden_level1_scripted.json
-rw-r--r--  1 prodx0x  staff  88645 10 sept. 23:46 golden_level9_far.json
Shell cwd was reset to /Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris
~~~~

#### 2026-09-10 23:48:18 +0200 (21:48:18Z) · TOOL CALL · Bash
`f88478cc` · `509a9a75` · ligne 304 · Write project.yml, Info.plist, asset catalog colors and render the app icon

~~~~bash
cd "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris" && mkdir -p Config Resources/Assets.xcassets Tools && cat > project.yml <<'EOF'
name: Iris
options:
  bundleIdPrefix: com.prodx0x
  deploymentTarget:
    iOS: "17.0"
  xcodeVersion: "26.3"
  createIntermediateGroups: true
  generateEmptyDirectories: false
  groupSortPosition: top
  developmentLanguage: fr
settings:
  base:
    SWIFT_VERSION: "6.0"
    SWIFT_STRICT_CONCURRENCY: complete
    IPHONEOS_DEPLOYMENT_TARGET: "17.0"
    TARGETED_DEVICE_FAMILY: "1,2"
    DEVELOPMENT_TEAM: NKN63DTRM4
    CODE_SIGN_STYLE: Automatic
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
      - path: Navigation
      - path: Features
      - path: DesignSystem
      - path: Resources
    settings:
      base:
        PRODUCT_BUNDLE_IDENTIFIER: com.prodx0x.iris
        PRODUCT_NAME: Iris
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
        PRODUCT_BUNDLE_IDENTIFIER: com.prodx0x.iris.tests
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
EOF
cat > Config/Info.plist <<'EOF'
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
EOF
python3 - <<'EOF'
import json, os
root = "Resources/Assets.xcassets"
def write(path, obj):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "w") as f: json.dump(obj, f, indent=2)
write(f"{root}/Contents.json", {"info": {"author": "xcode", "version": 1}})
def hexrgb(h, alpha=1.0):
    h = h.lstrip('#'); r, g, b = int(h[0:2],16), int(h[2:4],16), int(h[4:6],16)
    return {"alpha": f"{alpha:.3f}", "blue": f"0x{b:02X}", "green": f"0x{g:02X}", "red": f"0x{r:02X}"}
def colorset(name, hexval, alpha=1.0):
    comp = hexrgb(hexval, alpha)
    write(f"{root}/{name}.colorset/Contents.json", {
        "colors": [
            {"color": {"color-space": "srgb", "components": comp}, "idiom": "universal"},
            {"appearances": [{"appearance": "luminosity", "value": "dark"}], "color": {"color-space": "srgb", "components": comp}, "idiom": "universal"},
        ],
        "info": {"author": "xcode", "version": 1}})
palette = {
    "AccentColor": "#E7A43B",
    "LaunchBackground": "#0F1013",
    "ds.background.primary": "#0F1013",
    "ds.background.surface": "#16171A",
    "ds.background.elevated": "#1F2126",
    "ds.text.primary": "#EEEDFE",
    "ds.text.secondary": "#B4B2A9",
    "ds.text.tertiary": "#7E7C74",
    "ds.text.onAccent": "#14110A",
    "ds.text.warm": "#D3D1C7",
    "ds.accent": "#E7A43B",
    "ds.accent.deep": "#B8791C",
    "ds.status.success": "#5DCAA5",
    "ds.status.danger": "#D85A30",
    "ds.status.info": "#378ADD",
    "ds.line.subtle": "#2A2C33",
    "ds.scene.skyTop": "#1B1D22",
    "ds.scene.skyHorizon": "#2A2D33",
    "ds.scene.floorNear": "#232529",
    "ds.scene.floorFar": "#121316",
    "ds.scene.sphere": "#B4B2A9",
    "ds.scene.sphereValidated": "#5DCAA5",
    "ds.sequence.1": "#D85A30",
    "ds.sequence.2": "#378ADD",
    "ds.sequence.3": "#639922",
    "ds.sequence.4": "#D4537E",
    "ds.sequence.5": "#BA7517",
}
for name, hexval in palette.items(): colorset(name, hexval)
write(f"{root}/AppIcon.appiconset/Contents.json", {
    "images": [{"filename": "AppIcon.png", "idiom": "universal", "platform": "ios", "size": "1024x1024"}],
    "info": {"author": "xcode", "version": 1}})
print("colorsets:", len(palette))
EOF
cat > Tools/MakeAppIcon.swift <<'EOF'
// MakeAppIcon.swift
// Tooling (macOS, not part of the app target)
// Purpose: Render the Iris app icon (an amber iris on a dark ground) as a 1024x1024 PNG with CoreGraphics.
// Usage: swift Tools/MakeAppIcon.swift Resources/Assets.xcassets/AppIcon.appiconset/AppIcon.png

import Foundation
import CoreGraphics
import ImageIO
import UniformTypeIdentifiers

let arguments = CommandLine.arguments
guard arguments.count >= 2 else {
    FileHandle.standardError.write(Data("usage: MakeAppIcon <output.png>\n".utf8))
    exit(1)
}
let side = 1024.0
let colorSpace = CGColorSpaceCreateDeviceRGB()
guard let context = CGContext(data: nil, width: Int(side), height: Int(side), bitsPerComponent: 8, bytesPerRow: 0,
                              space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else {
    FileHandle.standardError.write(Data("cannot create context\n".utf8))
    exit(1)
}
func rgb(_ r: Double, _ g: Double, _ b: Double, _ a: Double = 1) -> CGColor {
    CGColor(colorSpace: colorSpace, components: [r, g, b, a]) ?? CGColor(gray: 0, alpha: 1)
}
func hex(_ value: UInt32, alpha: Double = 1) -> CGColor {
    rgb(Double((value >> 16) & 0xFF) / 255, Double((value >> 8) & 0xFF) / 255, Double(value & 0xFF) / 255, alpha)
}
let center = CGPoint(x: side / 2, y: side / 2)

// Ground: deep warm black with a faint amber glow rising from the bottom (horizon feeling).
context.setFillColor(hex(0x0F1013))
context.fill(CGRect(x: 0, y: 0, width: side, height: side))
if let glow = CGGradient(colorsSpace: colorSpace, colors: [hex(0xE7A43B, alpha: 0.22), hex(0xE7A43B, alpha: 0.0)] as CFArray, locations: [0, 1]) {
    context.drawRadialGradient(glow, startCenter: CGPoint(x: side / 2, y: side * 0.30), startRadius: 0,
                               endCenter: CGPoint(x: side / 2, y: side * 0.30), endRadius: side * 0.75, options: [])
}
// Horizon hairline.
context.setStrokeColor(hex(0xFFFFFF, alpha: 0.06))
context.setLineWidth(3)
context.move(to: CGPoint(x: 0, y: side * 0.34))
context.addLine(to: CGPoint(x: side, y: side * 0.34))
context.strokePath()

// Iris: outer amber halo, ring, fibres, pupil.
let outerRadius = side * 0.34
if let halo = CGGradient(colorsSpace: colorSpace, colors: [hex(0xE7A43B, alpha: 0.55), hex(0xE7A43B, alpha: 0.0)] as CFArray, locations: [0, 1]) {
    context.drawRadialGradient(halo, startCenter: center, startRadius: outerRadius * 0.92, endCenter: center, endRadius: outerRadius * 1.28, options: [])
}
if let iris = CGGradient(colorsSpace: colorSpace,
                         colors: [hex(0x2A1A08), hex(0xB8791C), hex(0xE7A43B), hex(0xF3C46B)] as CFArray,
                         locations: [0.0, 0.45, 0.85, 1.0]) {
    context.saveGState()
    context.addEllipse(in: CGRect(x: center.x - outerRadius, y: center.y - outerRadius, width: outerRadius * 2, height: outerRadius * 2))
    context.clip()
    context.drawRadialGradient(iris, startCenter: center, startRadius: 0, endCenter: center, endRadius: outerRadius, options: [])
    context.restoreGState()
}
// Fibres.
context.saveGState()
context.setLineWidth(2.2)
for index in 0..<96 {
    let angle = Double(index) / 96 * .pi * 2
    let jitter = sin(Double(index) * 12.9898) * 0.5 + 0.5
    let inner = outerRadius * (0.42 + jitter * 0.08)
    let outer = outerRadius * (0.96 - jitter * 0.06)
    context.setStrokeColor(hex(0x14110A, alpha: 0.22 + jitter * 0.2))
    context.move(to: CGPoint(x: center.x + cos(angle) * inner, y: center.y + sin(angle) * inner))
    context.addLine(to: CGPoint(x: center.x + cos(angle) * outer, y: center.y + sin(angle) * outer))
    context.strokePath()
}
context.restoreGState()
// Outer rim.
context.setStrokeColor(hex(0x14110A, alpha: 0.9))
context.setLineWidth(10)
context.strokeEllipse(in: CGRect(x: center.x - outerRadius, y: center.y - outerRadius, width: outerRadius * 2, height: outerRadius * 2))
// Pupil.
let pupilRadius = outerRadius * 0.40
context.setFillColor(hex(0x0B0B0E))
context.fillEllipse(in: CGRect(x: center.x - pupilRadius, y: center.y - pupilRadius, width: pupilRadius * 2, height: pupilRadius * 2))
// Specular highlight (top-left, matching the in-game sphere lighting).
if let spec = CGGradient(colorsSpace: colorSpace, colors: [hex(0xFFFFFF, alpha: 0.85), hex(0xFFFFFF, alpha: 0.0)] as CFArray, locations: [0, 1]) {
    let specCenter = CGPoint(x: center.x - pupilRadius * 0.45, y: center.y + pupilRadius * 0.45)
    context.drawRadialGradient(spec, startCenter: specCenter, startRadius: 0, endCenter: specCenter, endRadius: pupilRadius * 0.42, options: [])
}
guard let image = context.makeImage() else { exit(1) }
let url = URL(fileURLWithPath: arguments[1])
guard let destination = CGImageDestinationCreateWithURL(url as CFURL, UTType.png.identifier as CFString, 1, nil) else { exit(1) }
CGImageDestinationAddImage(destination, image, nil)
guard CGImageDestinationFinalize(destination) else { exit(1) }
print("wrote \(url.path)")
EOF
swift Tools/MakeAppIcon.swift Resources/Assets.xcassets/AppIcon.appiconset/AppIcon.png && ls -la Resources/Assets.xcassets/AppIcon.appiconset/ && sips -g pixelWidth -g pixelHeight -g hasAlpha Resources/Assets.xcassets/AppIcon.appiconset/AppIcon.png
~~~~

#### 2026-09-10 23:48:20 +0200 (21:48:20Z) · TOOL RESULT · Bash
`f88478cc` · `c434462d` · ligne 305 · Write project.yml, Info.plist, asset catalog colors and render the app icon

~~~~text
colorsets: 27
wrote /Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris/Resources/Assets.xcassets/AppIcon.appiconset/AppIcon.png
total 2080
drwxr-xr-x   4 prodx0x  staff      128 10 sept. 23:48 .
drwxr-xr-x  31 prodx0x  staff      992 10 sept. 23:48 ..
-rw-r--r--   1 prodx0x  staff  1058379 10 sept. 23:48 AppIcon.png
-rw-r--r--   1 prodx0x  staff      202 10 sept. 23:48 Contents.json
/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris/Resources/Assets.xcassets/AppIcon.appiconset/AppIcon.png
  pixelWidth: 1024
  pixelHeight: 1024
  hasAlpha: yes
~~~~

#### 2026-09-10 23:50:21 +0200 (21:50:21Z) · TOOL CALL · Bash
`f88478cc` · `46545877` · ligne 307 · Write Domain, GameEngine, audio policy and placeholder app sources

~~~~bash
cd "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris" && mkdir -p Domain/ValueObjects Domain/Entities Domain/Physics Domain/Validation Domain/Levels Domain/Random GameEngine/Noise GameEngine/Physics GameEngine/Session GameEngine/Gaze Audio/Policy App
cat > Domain/ValueObjects/Vector2.swift <<'EOF'
// Vector2.swift
// Layer: Domain
// Purpose: Two-dimensional vector in playfield points (the reference engine's canvas pixels)

import Foundation

struct Vector2: Hashable, Sendable {
    var x: Double
    var y: Double

    init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }

    static let zero = Vector2(x: 0, y: 0)

    var length: Double { (x * x + y * y).squareRoot() }

    func distance(to other: Vector2) -> Double { (self - other).length }

    static func + (lhs: Vector2, rhs: Vector2) -> Vector2 { Vector2(x: lhs.x + rhs.x, y: lhs.y + rhs.y) }
    static func - (lhs: Vector2, rhs: Vector2) -> Vector2 { Vector2(x: lhs.x - rhs.x, y: lhs.y - rhs.y) }
    static func * (lhs: Vector2, rhs: Double) -> Vector2 { Vector2(x: lhs.x * rhs, y: lhs.y * rhs) }
    static func / (lhs: Vector2, rhs: Double) -> Vector2 { Vector2(x: lhs.x / rhs, y: lhs.y / rhs) }
    static func += (lhs: inout Vector2, rhs: Vector2) { lhs = lhs + rhs }
}
EOF
cat > Domain/ValueObjects/PlayfieldBounds.swift <<'EOF'
// PlayfieldBounds.swift
// Layer: Domain
// Purpose: Size of the game space in points; the reference engine used the browser window size

import Foundation

struct PlayfieldBounds: Hashable, Sendable {
    var width: Double
    var height: Double

    init(width: Double, height: Double) {
        self.width = width
        self.height = height
    }

    var center: Vector2 { Vector2(x: width / 2, y: height / 2) }

    /// A portrait iPhone playfield used by tests, previews and golden traces.
    static let referencePhone = PlayfieldBounds(width: 390, height: 844)
}
EOF
cat > Domain/ValueObjects/NormalizedPoint.swift <<'EOF'
// NormalizedPoint.swift
// Layer: Domain
// Purpose: Resolution-independent position (0...1 on both axes), resolved against the playfield at load time

import Foundation

struct NormalizedPoint: Hashable, Sendable {
    var x: Double
    var y: Double

    init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }

    func absolute(in bounds: PlayfieldBounds) -> Vector2 {
        Vector2(x: x * bounds.width, y: y * bounds.height)
    }
}
EOF
cat > Domain/Entities/TargetID.swift <<'EOF'
// TargetID.swift
// Layer: Domain
// Purpose: Typed identity of a target inside a level; the sequence number is unique per level

import Foundation

struct TargetID: Hashable, Sendable, Comparable {
    let sequence: Int

    init(sequence: Int) {
        self.sequence = sequence
    }

    static func < (lhs: TargetID, rhs: TargetID) -> Bool { lhs.sequence < rhs.sequence }
}
EOF
cat > Domain/Entities/TargetBlueprint.swift <<'EOF'
// TargetBlueprint.swift
// Layer: Domain
// Purpose: Static description of one target of a level (the reference engine's level target config)

import Foundation

struct TargetBlueprint: Hashable, Sendable {
    /// Validation order, 1-based (`seq` in the reference engine).
    let sequence: Int
    let start: NormalizedPoint
    let arrival: NormalizedPoint
    /// Gaze distance under which the sphere is repelled (`zone_attention`, points).
    let attentionZone: Double
    /// Repulsion gain (`k_repulsion`), points per frame per point of intrusion.
    let repulsionGain: Double
    /// Attraction impulse toward the arrival (`attraction_passive`), points per frame.
    let passiveAttraction: Double
    /// Organic drift amplitude (`amplitude_bruit`), points per frame.
    let noiseAmplitude: Double

    init(sequence: Int, start: NormalizedPoint, arrival: NormalizedPoint, attentionZone: Double,
         repulsionGain: Double, passiveAttraction: Double, noiseAmplitude: Double) {
        self.sequence = sequence
        self.start = start
        self.arrival = arrival
        self.attentionZone = attentionZone
        self.repulsionGain = repulsionGain
        self.passiveAttraction = passiveAttraction
        self.noiseAmplitude = noiseAmplitude
    }
}
EOF
cat > Domain/Entities/LevelID.swift <<'EOF'
// LevelID.swift
// Layer: Domain
// Purpose: Typed identity of a level (`level_01` ... `level_14` in the reference engine)

import Foundation

struct LevelID: Hashable, Sendable, CustomStringConvertible {
    let raw: String

    init(raw: String) {
        self.raw = raw
    }

    init(number: Int) {
        let padded = number < 10 ? "0\(number)" : "\(number)"
        self.raw = "level_\(padded)"
    }

    var description: String { raw }
}
EOF
cat > Domain/Entities/Level.swift <<'EOF'
// Level.swift
// Layer: Domain
// Purpose: One of the fourteen levels: its targets, hold duration and sequencing mode

import Foundation

struct Level: Hashable, Sendable, Identifiable {
    let id: LevelID
    /// 1-based level number shown to the player.
    let number: Int
    let targets: [TargetBlueprint]
    /// Continuous presence required inside the arrival zone before validation (0.75 s, 45 frames at 60 Hz).
    let holdDuration: TimeInterval
    /// When true, validation only counts in sequence order 1, 2, 3.
    let isSequential: Bool

    init(id: LevelID, number: Int, targets: [TargetBlueprint], holdDuration: TimeInterval, isSequential: Bool) {
        self.id = id
        self.number = number
        self.targets = targets
        self.holdDuration = holdDuration
        self.isSequential = isSequential
    }

    var targetCount: Int { targets.count }
}
EOF
cat > Domain/Entities/Target.swift <<'EOF'
// Target.swift
// Layer: Domain
// Purpose: Runtime state of one sphere: position, velocity, destination, hold progress and validation

import Foundation

struct Target: Identifiable, Hashable, Sendable {
    let id: TargetID
    var position: Vector2
    var velocity: Vector2
    let arrival: Vector2
    let attentionZone: Double
    let repulsionGain: Double
    let passiveAttraction: Double
    let noiseAmplitude: Double
    /// Continuous time required inside the arrival zone before validation.
    let requiredHoldTime: TimeInterval
    /// Continuous time spent inside the arrival zone while it is this target's turn.
    var holdTime: TimeInterval
    var isValidated: Bool

    init(id: TargetID, position: Vector2, velocity: Vector2 = .zero, arrival: Vector2, attentionZone: Double,
         repulsionGain: Double, passiveAttraction: Double, noiseAmplitude: Double, requiredHoldTime: TimeInterval,
         holdTime: TimeInterval = 0, isValidated: Bool = false) {
        self.id = id
        self.position = position
        self.velocity = velocity
        self.arrival = arrival
        self.attentionZone = attentionZone
        self.repulsionGain = repulsionGain
        self.passiveAttraction = passiveAttraction
        self.noiseAmplitude = noiseAmplitude
        self.requiredHoldTime = requiredHoldTime
        self.holdTime = holdTime
        self.isValidated = isValidated
    }

    init(blueprint: TargetBlueprint, bounds: PlayfieldBounds, holdDuration: TimeInterval) {
        self.init(id: TargetID(sequence: blueprint.sequence),
                  position: blueprint.start.absolute(in: bounds),
                  arrival: blueprint.arrival.absolute(in: bounds),
                  attentionZone: blueprint.attentionZone,
                  repulsionGain: blueprint.repulsionGain,
                  passiveAttraction: blueprint.passiveAttraction,
                  noiseAmplitude: blueprint.noiseAmplitude,
                  requiredHoldTime: holdDuration)
    }

    var sequence: Int { id.sequence }
    var speed: Double { velocity.length }
    var distanceToArrival: Double { position.distance(to: arrival) }

    /// 0...1 progress toward validation (`holdFrames / holdRequired` in the reference engine).
    var validationProgress: Double {
        guard requiredHoldTime > 0 else { return 1 }
        return min(1, holdTime / requiredHoldTime)
    }

    /// True while the target accumulates presence but is not validated yet (drives the audio crescendo).
    var isHolding: Bool { !isValidated && holdTime > 0 }
}
EOF
cat > Domain/Physics/PhysicsConstants.swift <<'EOF'
// PhysicsConstants.swift
// Layer: Domain
// Purpose: Physical constants of the reference engine, expressed per 60 Hz reference frame

import Foundation

struct PhysicsConstants: Hashable, Sendable {
    /// `RADIUS_TARGET`: drawn sphere radius, points.
    var targetRadius: Double = 24
    /// `RADIUS_ARRIVAL`: arrival ring radius, points.
    var arrivalRadius: Double = 40
    /// `VITESSE_MAX`: speed cap, points per reference frame.
    var maxSpeed: Double = 2.2
    /// `FRICTION`: velocity multiplier applied once per reference frame.
    var friction: Double = 0.94
    /// `MARGE_BORD`: inset of the playable area, points.
    var edgeMargin: Double = 60
    /// `PERTE_REBOND`: velocity kept (and reversed) after touching an edge.
    var bounceLoss: Double = 0.5
    /// Frame rate at which the reference engine was validated; every per-frame quantity is defined at this rate.
    var referenceFrameRate: Double = 60

    init() {}

    var referenceFrameDuration: TimeInterval { 1 / referenceFrameRate }

    static let reference = PhysicsConstants()
}
EOF
cat > Domain/Validation/ValidationRules.swift <<'EOF'
// ValidationRules.swift
// Layer: Domain
// Purpose: Distances governing validation and its loss (R-08, R-10)

import Foundation

struct ValidationRules: Hashable, Sendable {
    /// `SETTLE_RADIUS = RADIUS_ARRIVAL - RADIUS_TARGET`: distance to the arrival under which presence counts.
    var settleRadius: Double
    /// Extra tolerance granted once validated (`WOBBLE_TOLERANCE = SETTLE_RADIUS + 20`).
    var wobbleMargin: Double
    /// Floating point slack when comparing accumulated hold time with the required duration.
    var holdEpsilon: TimeInterval

    init(settleRadius: Double, wobbleMargin: Double = 20, holdEpsilon: TimeInterval = 1e-6) {
        self.settleRadius = settleRadius
        self.wobbleMargin = wobbleMargin
        self.holdEpsilon = holdEpsilon
    }

    var wobbleTolerance: Double { settleRadius + wobbleMargin }

    static func reference(physics: PhysicsConstants = .reference) -> ValidationRules {
        ValidationRules(settleRadius: physics.arrivalRadius - physics.targetRadius)
    }

    static let reference = ValidationRules.reference()
}
EOF
cat > Domain/Validation/ValidationTransition.swift <<'EOF'
// ValidationTransition.swift
// Layer: Domain
// Purpose: Outcome of applying the validation rule to one target during one tick

import Foundation

enum ValidationTransition: Hashable, Sendable {
    case unchanged
    case validated
    case lost
}
EOF
cat > Domain/Validation/TurnRule.swift <<'EOF'
// TurnRule.swift
// Layer: Domain
// Purpose: R-09 sequence rule: validation only counts for the lowest unvalidated sequence number

import Foundation

enum TurnRule {
    /// Lowest sequence number among unvalidated targets, or nil when every target is validated.
    static func lowestUnvalidatedSequence(in targets: [Target]) -> Int? {
        targets.lazy.filter { !$0.isValidated }.map(\.sequence).min()
    }

    /// A target may accumulate presence when the level is not sequential, when it is already validated
    /// (it keeps its place), or when it carries the lowest unvalidated sequence number.
    static func isTurn(of target: Target, lowestUnvalidated: Int?, isSequential: Bool) -> Bool {
        !isSequential || target.isValidated || target.sequence == lowestUnvalidated
    }
}
EOF
cat > Domain/Validation/ValidationRule.swift <<'EOF'
// ValidationRule.swift
// Layer: Domain
// Purpose: R-08 continuous 0.75 s presence and R-10 wobble tolerance loss, applied to one target per tick

import Foundation

struct ValidationRule: Hashable, Sendable {
    let rules: ValidationRules

    init(rules: ValidationRules = .reference) {
        self.rules = rules
    }

    /// Mirrors the reference engine: a validated target loses its place beyond the wobble tolerance;
    /// an unvalidated target accumulates presence only inside the settle radius and only on its turn;
    /// anything else resets the accumulated presence to zero.
    func apply(to target: inout Target, isTurn: Bool, elapsed: TimeInterval) -> ValidationTransition {
        let distance = target.distanceToArrival
        let wasValidated = target.isValidated
        if target.isValidated {
            if distance > rules.wobbleTolerance {
                target.isValidated = false
                target.holdTime = 0
            }
        } else if distance < rules.settleRadius && isTurn {
            target.holdTime += elapsed
            target.isValidated = target.holdTime >= target.requiredHoldTime - rules.holdEpsilon
        } else {
            target.holdTime = 0
        }
        if target.isValidated && !wasValidated { return .validated }
        if !target.isValidated && wasValidated { return .lost }
        return .unchanged
    }
}
EOF
cat > Domain/Validation/CascadeRule.swift <<'EOF'
// CascadeRule.swift
// Layer: Domain
// Purpose: R-11 cascade: losing a validation invalidates every validated target of higher rank

import Foundation

enum CascadeRule {
    /// Invalidates every validated target whose sequence is greater than the first unvalidated one
    /// (array order, which is sequence order). Returns the sequences that were invalidated, in array order.
    @discardableResult
    static func apply(to targets: inout [Target]) -> [Int] {
        guard let broken = targets.first(where: { !$0.isValidated })?.sequence else { return [] }
        var invalidated: [Int] = []
        for index in targets.indices where targets[index].isValidated && targets[index].sequence > broken {
            targets[index].isValidated = false
            targets[index].holdTime = 0
            invalidated.append(targets[index].sequence)
        }
        return invalidated
    }
}
EOF
cat > Domain/Random/LinearCongruentialGenerator.swift <<'EOF'
// LinearCongruentialGenerator.swift
// Layer: Domain
// Purpose: Deterministic generator identical to the reference engine's `rngFor` / `makeNoise1D` (9301, 49297, 233280)

import Foundation

struct LinearCongruentialGenerator: Hashable, Sendable {
    private var state: Int

    init(seed: Int) {
        state = seed
    }

    /// Next value in 0..<1, bit-for-bit equal to the JavaScript sequence for the seeds used by the engine.
    mutating func next() -> Double {
        state = (state * 9301 + 49297) % 233280
        return Double(state) / 233280
    }
}
EOF
cat > Domain/Levels/LevelDifficulty.swift <<'EOF'
// LevelDifficulty.swift
// Layer: Domain
// Purpose: Difficulty band parameters exactly as defined by the reference engine's `buildLevel`

import Foundation

struct LevelDifficulty: Hashable, Sendable {
    let targetCount: Int
    /// Base attention zone before the gaze multiplier (220, 190, 150).
    let baseAttentionZone: Double
    let repulsionGain: Double
    let passiveAttraction: Double

    init(targetCount: Int, baseAttentionZone: Double, repulsionGain: Double, passiveAttraction: Double) {
        self.targetCount = targetCount
        self.baseAttentionZone = baseAttentionZone
        self.repulsionGain = repulsionGain
        self.passiveAttraction = passiveAttraction
    }

    /// Levels 1-3: one target. Levels 4-8: two targets. Levels 9-14: three targets.
    static func band(forLevelIndex index: Int) -> LevelDifficulty {
        if index < 3 {
            return LevelDifficulty(targetCount: 1, baseAttentionZone: 220, repulsionGain: 0.008, passiveAttraction: 0.6)
        } else if index < 8 {
            return LevelDifficulty(targetCount: 2, baseAttentionZone: 190, repulsionGain: 0.009, passiveAttraction: 0.55)
        } else {
            return LevelDifficulty(targetCount: 3, baseAttentionZone: 150, repulsionGain: 0.013, passiveAttraction: 0.5)
        }
    }
}
EOF
cat > Domain/Levels/LevelCatalog.swift <<'EOF'
// LevelCatalog.swift
// Layer: Domain
// Purpose: The fourteen levels, generated exactly like the reference engine (same seeds, same order of draws)

import Foundation

enum LevelCatalog {
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

    static let all: [Level] = (0..<levelCount).map(level(at:))

    static func level(at index: Int) -> Level {
        let difficulty = LevelDifficulty.band(forLevelIndex: index)
        var generator = LinearCongruentialGenerator(seed: seedBase + index * seedStride)
        var targets: [TargetBlueprint] = []
        for targetIndex in 0..<difficulty.targetCount {
            let start = randomPoint(&generator)
            let arrival = randomPoint(&generator)
            targets.append(TargetBlueprint(sequence: targetIndex + 1,
                                           start: start,
                                           arrival: arrival,
                                           attentionZone: difficulty.baseAttentionZone * gazeZoneMultiplier,
                                           repulsionGain: difficulty.repulsionGain,
                                           passiveAttraction: difficulty.passiveAttraction,
                                           noiseAmplitude: noiseAmplitude))
        }
        return Level(id: LevelID(number: index + 1),
                     number: index + 1,
                     targets: targets,
                     holdDuration: holdDuration,
                     isSequential: difficulty.targetCount > 1)
    }

    private static func randomPoint(_ generator: inout LinearCongruentialGenerator) -> NormalizedPoint {
        let x = spawnMargin + generator.next() * (1 - 2 * spawnMargin)
        let y = spawnMargin + generator.next() * (1 - 2 * spawnMargin)
        return NormalizedPoint(x: x, y: y)
    }
}
EOF
cat > GameEngine/Noise/NoiseSource.swift <<'EOF'
// NoiseSource.swift
// Layer: GameEngine
// Purpose: One-dimensional organic noise abstraction so the engine can be driven by deterministic or silent noise

import Foundation

protocol NoiseSource: Sendable {
    /// Value in -1...1 for the given continuous time.
    func value(at time: Double) -> Double
}
EOF
cat > GameEngine/Noise/ValueNoise1D.swift <<'EOF'
// ValueNoise1D.swift
// Layer: GameEngine
// Purpose: Port of `makeNoise1D`: 256 random values, smoothstep interpolation (Perlin-like value noise)

import Foundation

struct ValueNoise1D: NoiseSource, Hashable {
    private static let tableSize = 256
    private let table: [Double]

    init(seed: Int) {
        var generator = LinearCongruentialGenerator(seed: seed)
        table = (0..<Self.tableSize).map { _ in generator.next() * 2 - 1 }
    }

    func value(at time: Double) -> Double {
        let floored = time.rounded(.down)
        let base = Int(floored)
        let index = ((base % Self.tableSize) + Self.tableSize) % Self.tableSize
        let fraction = time - floored
        let a = table[index]
        let b = table[(index + 1) % Self.tableSize]
        let u = fraction * fraction * (3 - 2 * fraction)
        return a * (1 - u) + b * u
    }
}
EOF
cat > GameEngine/Noise/SilentNoise.swift <<'EOF'
// SilentNoise.swift
// Layer: GameEngine
// Purpose: Zero noise, used by tests and previews that need fully predictable motion

import Foundation

struct SilentNoise: NoiseSource, Hashable {
    init() {}

    func value(at time: Double) -> Double { 0 }
}
EOF
cat > GameEngine/Physics/TargetPhysics.swift <<'EOF'
// TargetPhysics.swift
// Layer: GameEngine
// Purpose: R-01...R-07 frame-rate independent integration of one target, equivalent to the reference engine at 60 Hz

import Foundation

struct TargetPhysics: Hashable, Sendable {
    let constants: PhysicsConstants
    let bounds: PlayfieldBounds

    init(constants: PhysicsConstants = .reference, bounds: PlayfieldBounds) {
        self.constants = constants
        self.bounds = bounds
    }

    /// Advances `target` by `frameFraction` reference frames (1.0 is exactly one 60 Hz frame of the original engine).
    /// - R-01 attraction toward the arrival when the gaze is outside the attention zone
    /// - R-02 repulsion proportional to `attentionZone - distance` when the gaze is inside it
    /// - R-03 organic noise only while attracted (as in the reference engine)
    /// - R-04 speed cap, R-05 friction `pow(friction, frameFraction)`, R-06 integration, R-07 damped bounce
    func integrate(_ target: inout Target, gaze: Vector2, noise: (Double) -> Double, frameTime: Double, frameFraction: Double) {
        let fromGaze = target.position - gaze
        let gazeDistance = nonZero(fromGaze.length)
        if gazeDistance < target.attentionZone {
            let force = target.repulsionGain * (target.attentionZone - gazeDistance)
            target.velocity += (fromGaze / gazeDistance) * (force * frameFraction)
        } else {
            let toArrival = target.arrival - target.position
            let arrivalDistance = nonZero(toArrival.length)
            target.velocity += (toArrival / arrivalDistance) * (target.passiveAttraction * frameFraction)
            target.velocity.x += noise(frameTime * 0.02) * target.noiseAmplitude * frameFraction
            target.velocity.y += noise(frameTime * 0.02 + 50) * target.noiseAmplitude * frameFraction
        }

        let speed = target.velocity.length
        if speed > constants.maxSpeed {
            target.velocity = target.velocity / speed * constants.maxSpeed
        }

        target.velocity = target.velocity * pow(constants.friction, frameFraction)
        target.position += target.velocity * frameFraction
        bounce(&target)
    }

    private func bounce(_ target: inout Target) {
        let margin = constants.edgeMargin
        if target.position.x < margin {
            target.position.x = margin
            target.velocity.x *= -constants.bounceLoss
        }
        if target.position.x > bounds.width - margin {
            target.position.x = bounds.width - margin
            target.velocity.x *= -constants.bounceLoss
        }
        if target.position.y < margin {
            target.position.y = margin
            target.velocity.y *= -constants.bounceLoss
        }
        if target.position.y > bounds.height - margin {
            target.position.y = bounds.height - margin
            target.velocity.y *= -constants.bounceLoss
        }
    }

    /// The reference engine replaces a zero distance by 0.0001 (`Math.hypot(...) || 0.0001`).
    private func nonZero(_ distance: Double) -> Double {
        distance == 0 ? 0.0001 : distance
    }
}
EOF
cat > GameEngine/Gaze/GazeFilter.swift <<'EOF'
// GazeFilter.swift
// Layer: GameEngine
// Purpose: R-13 port of the reference gaze listener: exponential smoothing (alpha 0.1) and sustained-jump gating

import Foundation

struct GazeFilter: Hashable, Sendable {
    /// `alpha = 0.1`: stability over reactivity.
    var smoothing: Double
    /// A raw sample farther than this from the cursor is a "big jump" (blink or glitch).
    var jumpThreshold: Double
    /// Number of consecutive big jumps needed before the jump is trusted as a real gaze move.
    var sustainedJumpCount: Int

    private(set) var position: Vector2
    private(set) var isActive: Bool
    private var consecutiveBigJumps: Int

    init(initialPosition: Vector2, smoothing: Double = 0.1, jumpThreshold: Double = 300, sustainedJumpCount: Int = 3) {
        self.position = initialPosition
        self.smoothing = smoothing
        self.jumpThreshold = jumpThreshold
        self.sustainedJumpCount = sustainedJumpCount
        self.isActive = false
        self.consecutiveBigJumps = 0
    }

    /// Feeds one raw sample. Returns false when the sample was ignored as an isolated big jump.
    @discardableResult
    mutating func ingest(_ raw: Vector2) -> Bool {
        let jump = raw.distance(to: position)
        if jump > jumpThreshold && isActive {
            consecutiveBigJumps += 1
            if consecutiveBigJumps < sustainedJumpCount { return false }
        } else {
            consecutiveBigJumps = 0
        }
        position = position + (raw - position) * smoothing
        isActive = true
        return true
    }

    /// Places the cursor exactly, bypassing smoothing (used by tests, golden traces and previews).
    mutating func place(at point: Vector2) {
        position = point
        isActive = true
        consecutiveBigJumps = 0
    }
}
EOF
cat > GameEngine/Session/GameEvent.swift <<'EOF'
// GameEvent.swift
// Layer: GameEngine
// Purpose: Facts produced by one engine tick, consumed by audio, haptics and presentation

import Foundation

enum LossCause: Hashable, Sendable {
    /// The validated sphere drifted beyond the wobble tolerance.
    case drift
    /// A lower-ranked sphere lost its validation (R-11).
    case cascade
}

enum GameEvent: Hashable, Sendable {
    case validationProgressed(sequence: Int, progress: Double)
    case validationProgressStopped(sequence: Int)
    case targetValidated(sequence: Int)
    case targetLost(sequence: Int, cause: LossCause)
    case levelCompleted
}
EOF
cat > GameEngine/Session/GameSession.swift <<'EOF'
// GameSession.swift
// Layer: GameEngine
// Purpose: Deterministic per-level simulation: physics, validation, cascade and events (port of `step()`)

import Foundation

struct GameSession: Sendable {
    let level: Level
    let bounds: PlayfieldBounds
    let physics: PhysicsConstants
    let validation: ValidationRules
    /// Largest wall-clock delta accepted per `advance`; anything longer is treated as a stall.
    var maxDeltaTime: TimeInterval = 0.1

    private(set) var targets: [Target]
    private(set) var gaze: GazeFilter
    /// Accumulated reference frames (`t` in the reference engine), drives the noise time.
    private(set) var frameTime: Double = 0
    private(set) var elapsed: TimeInterval = 0
    private(set) var isComplete = false

    private let noiseSources: [any NoiseSource]
    private let integrator: TargetPhysics
    private let validationRule: ValidationRule

    init(level: Level,
         bounds: PlayfieldBounds,
         physics: PhysicsConstants = .reference,
         validation: ValidationRules? = nil,
         initialGaze: Vector2? = nil,
         noiseSources: [any NoiseSource]? = nil) {
        self.level = level
        self.bounds = bounds
        self.physics = physics
        let rules = validation ?? ValidationRules.reference(physics: physics)
        self.validation = rules
        self.targets = level.targets.map { Target(blueprint: $0, bounds: bounds, holdDuration: level.holdDuration) }
        self.gaze = GazeFilter(initialPosition: initialGaze ?? bounds.center)
        self.noiseSources = noiseSources ?? level.targets.indices.map { ValueNoise1D(seed: 1000 + $0 * 137) }
        self.integrator = TargetPhysics(constants: physics, bounds: bounds)
        self.validationRule = ValidationRule(rules: rules)
    }

    var allValidated: Bool { targets.allSatisfy(\.isValidated) }

    /// Smoothed gaze input (what the reference engine's gaze listener did).
    mutating func ingestGaze(_ point: Vector2) {
        gaze.ingest(point)
    }

    /// Exact gaze placement without smoothing (tests, golden traces, previews).
    mutating func placeGaze(at point: Vector2) {
        gaze.place(at: point)
    }

    /// Replaces the runtime targets; used by tests and previews to stage a scene.
    mutating func replaceTargets(_ newTargets: [Target]) {
        targets = newTargets
        isComplete = false
    }

    /// R-14: advances the simulation by `deltaTime` seconds. The delta is clamped, then split into
    /// sub-steps no longer than one reference frame so that frame drops reproduce what 60 Hz would have done.
    mutating func advance(by deltaTime: TimeInterval) -> [GameEvent] {
        guard !isComplete else { return [] }
        let clamped = min(max(deltaTime, 0), maxDeltaTime)
        guard clamped > 0 else { return [] }
        let referenceFrames = clamped * physics.referenceFrameRate
        let substeps = max(1, Int((referenceFrames - 1e-9).rounded(.up)))
        let subSeconds = clamped / Double(substeps)
        let frameFraction = subSeconds * physics.referenceFrameRate
        var events: [GameEvent] = []
        for _ in 0..<substeps {
            events += tick(seconds: subSeconds, frameFraction: frameFraction)
            if isComplete { break }
        }
        return events
    }

    private mutating func tick(seconds: TimeInterval, frameFraction: Double) -> [GameEvent] {
        frameTime += frameFraction
        elapsed += seconds
        var events: [GameEvent] = []
        var everyTargetValidated = true
        let lowestUnvalidated = level.isSequential ? TurnRule.lowestUnvalidatedSequence(in: targets) : nil
        let cursor = gaze.position

        for index in targets.indices {
            var target = targets[index]
            let wasHolding = target.isHolding
            let noise = noiseSources[index]
            integrator.integrate(&target, gaze: cursor, noise: { noise.value(at: $0) }, frameTime: frameTime, frameFraction: frameFraction)
            let isTurn = TurnRule.isTurn(of: target, lowestUnvalidated: lowestUnvalidated, isSequential: level.isSequential)
            let transition = validationRule.apply(to: &target, isTurn: isTurn, elapsed: seconds)

            if target.isHolding {
                events.append(.validationProgressed(sequence: target.sequence, progress: target.validationProgress))
            } else if wasHolding {
                events.append(.validationProgressStopped(sequence: target.sequence))
            }
            switch transition {
            case .validated: events.append(.targetValidated(sequence: target.sequence))
            case .lost: events.append(.targetLost(sequence: target.sequence, cause: .drift))
            case .unchanged: break
            }
            if !target.isValidated { everyTargetValidated = false }
            targets[index] = target
        }

        if level.isSequential {
            let cascaded = CascadeRule.apply(to: &targets)
            for sequence in cascaded {
                events.append(.targetLost(sequence: sequence, cause: .cascade))
            }
            if !cascaded.isEmpty { everyTargetValidated = false }
        }

        if everyTargetValidated {
            isComplete = true
            events.append(.levelCompleted)
        }
        return events
    }
}
EOF
cat > GameEngine/Session/GameProgression.swift <<'EOF'
// GameProgression.swift
// Layer: GameEngine
// Purpose: R-12 progression through the fourteen levels

import Foundation

struct GameProgression: Hashable, Sendable {
    enum Outcome: Hashable, Sendable {
        case nextLevel(Level)
        case journeyFinished
    }

    let levels: [Level]
    private(set) var currentIndex: Int
    private(set) var isFinished: Bool

    init(levels: [Level] = LevelCatalog.all) {
        self.levels = levels.isEmpty ? LevelCatalog.all : levels
        self.currentIndex = 0
        self.isFinished = false
    }

    var levelCount: Int { levels.count }
    var currentLevel: Level { levels[currentIndex] }
    var currentNumber: Int { currentIndex + 1 }
    var isLastLevel: Bool { currentIndex == levels.count - 1 }

    /// Moves to the next level, or marks the journey as finished after the last one.
    mutating func completeCurrentLevel() -> Outcome {
        let next = currentIndex + 1
        guard next < levels.count else {
            isFinished = true
            return .journeyFinished
        }
        currentIndex = next
        return .nextLevel(levels[next])
    }

    mutating func restart() {
        currentIndex = 0
        isFinished = false
    }
}
EOF
cat > Audio/Policy/AudioCue.swift <<'EOF'
// AudioCue.swift
// Layer: Audio
// Purpose: Sound intents derived from game events, independent from AVAudioEngine

import Foundation

enum AudioCue: Hashable, Sendable {
    /// Crescendo voice for one target (voice index is `sequence - 1`).
    case progress(voice: Int, progress: Double)
    case stopProgress(voice: Int)
    case validation
    case loss
}
EOF
cat > Audio/Policy/AudioCuePolicy.swift <<'EOF'
// AudioCuePolicy.swift
// Layer: Audio
// Purpose: Sound policy: crescendo per target, one chime per validation, one loss tone per tick with a retrigger guard

import Foundation

struct AudioCuePolicy: Hashable, Sendable {
    /// Minimum spacing between two loss tones, so cascades spread over consecutive ticks do not stutter.
    var lossRetriggerInterval: TimeInterval
    private var lastLossTime: TimeInterval

    init(lossRetriggerInterval: TimeInterval = 0.15) {
        self.lossRetriggerInterval = lossRetriggerInterval
        self.lastLossTime = -.infinity
    }

    /// Converts the events of one tick into cues. Several losses in the same tick (drift plus cascade)
    /// collapse into a single loss tone.
    mutating func cues(for events: [GameEvent], at time: TimeInterval) -> [AudioCue] {
        var cues: [AudioCue] = []
        var lossRequested = false
        for event in events {
            switch event {
            case let .validationProgressed(sequence, progress):
                cues.append(.progress(voice: sequence - 1, progress: progress))
            case let .validationProgressStopped(sequence):
                cues.append(.stopProgress(voice: sequence - 1))
            case .targetValidated:
                cues.append(.validation)
            case .targetLost:
                lossRequested = true
            case .levelCompleted:
                break
            }
        }
        if lossRequested && time - lastLossTime >= lossRetriggerInterval {
            cues.append(.loss)
            lastLossTime = time
        }
        return cues
    }

    mutating func reset() {
        lastLossTime = -.infinity
    }
}
EOF
cat > App/IrisApp.swift <<'EOF'
// IrisApp.swift
// Layer: App
// Purpose: Application entry point

import SwiftUI

@main
struct IrisApp: App {
    var body: some Scene {
        WindowGroup {
            Text("Iris")
        }
    }
}
EOF
echo "sources written"; find Domain GameEngine Audio App -name "*.swift" | wc -l
~~~~

#### 2026-09-10 23:50:23 +0200 (21:50:23Z) · TOOL RESULT · Bash
`f88478cc` · `7e521c55` · ligne 308 · Write Domain, GameEngine, audio policy and placeholder app sources

~~~~text
sources written
      28
~~~~

#### 2026-09-10 23:53:27 +0200 (21:53:27Z) · TOOL CALL · Bash
`f88478cc` · `368958d2` · ligne 309 · Write test fixtures and the deterministic test suite (domain, engine, audio policy)

~~~~bash
cd "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris" && mkdir -p Tests/IrisTests/Domain Tests/IrisTests/GameEngine Tests/IrisTests/Audio Tests/IrisTests/Fixtures Tests/IrisTests/Mocks
cat > Tests/IrisTests/Fixtures/SessionFixture.swift <<'EOF'
// SessionFixture.swift
// Layer: Tests
// Purpose: Helpers to stage deterministic sessions (no noise, explicit positions)

import Foundation
@testable import Iris

enum SessionFixture {
    static let bounds = PlayfieldBounds.referencePhone
    static let frame: TimeInterval = 1.0 / 60.0
    /// A gaze point far from every staged target (bottom-right corner, inside the playfield).
    static let farGaze = Vector2(x: 330, y: 784)

    struct Placement {
        var start: Vector2
        var arrival: Vector2
    }

    static func level(placements: [Placement],
                      sequential: Bool? = nil,
                      attentionZone: Double = 240,
                      repulsionGain: Double = 0.013,
                      passiveAttraction: Double = 0.5,
                      noiseAmplitude: Double = 0) -> Level {
        let targets = placements.enumerated().map { index, placement in
            TargetBlueprint(sequence: index + 1,
                            start: NormalizedPoint(x: placement.start.x / bounds.width, y: placement.start.y / bounds.height),
                            arrival: NormalizedPoint(x: placement.arrival.x / bounds.width, y: placement.arrival.y / bounds.height),
                            attentionZone: attentionZone,
                            repulsionGain: repulsionGain,
                            passiveAttraction: passiveAttraction,
                            noiseAmplitude: noiseAmplitude)
        }
        return Level(id: LevelID(raw: "fixture"), number: 1, targets: targets,
                     holdDuration: LevelCatalog.holdDuration, isSequential: sequential ?? (placements.count > 1))
    }

    /// Session without noise, gaze parked far away.
    static func session(level: Level, gaze: Vector2 = farGaze) -> GameSession {
        var session = GameSession(level: level, bounds: bounds,
                                  noiseSources: level.targets.map { _ in SilentNoise() })
        session.placeGaze(at: gaze)
        return session
    }

    /// Single target already resting on its arrival point.
    static func restingSession(at point: Vector2 = Vector2(x: 200, y: 500)) -> GameSession {
        session(level: level(placements: [Placement(start: point, arrival: point)]))
    }

    /// Three targets, each resting on its own arrival point, sequential rules.
    static func tripleRestingSession() -> GameSession {
        let points = [Vector2(x: 120, y: 300), Vector2(x: 200, y: 500), Vector2(x: 280, y: 400)]
        return session(level: level(placements: points.map { Placement(start: $0, arrival: $0) }, sequential: true))
    }

    @discardableResult
    static func run(_ session: inout GameSession, frames: Int, dt: TimeInterval = frame) -> [GameEvent] {
        var events: [GameEvent] = []
        for _ in 0..<frames { events += session.advance(by: dt) }
        return events
    }

    /// Runs frames until the first target is validated (or the frame budget runs out).
    @discardableResult
    static func runUntilValidated(_ session: inout GameSession, sequence: Int, maxFrames: Int = 600) -> Int {
        for frame in 1...maxFrames {
            let events = session.advance(by: frame == 0 ? 0 : SessionFixture.frame)
            if events.contains(.targetValidated(sequence: sequence)) { return frame }
        }
        return -1
    }
}

extension Target {
    /// Copy of the target moved to `position`, keeping every other property.
    func moved(to newPosition: Vector2) -> Target {
        var copy = self
        copy.position = newPosition
        return copy
    }

    func validatedCopy() -> Target {
        var copy = self
        copy.isValidated = true
        copy.holdTime = requiredHoldTime
        return copy
    }
}
EOF
cat > Tests/IrisTests/Fixtures/GoldenTrace.swift <<'EOF'
// GoldenTrace.swift
// Layer: Tests
// Purpose: Decodes the golden traces produced by the reference JavaScript engine (Fixtures/golden_generator.js)

import Foundation

struct GoldenTrace: Decodable {
    struct Canvas: Decodable {
        let width: Double
        let height: Double
    }

    struct Sample: Decodable {
        let x: Double
        let y: Double
        let vx: Double
        let vy: Double
        let hold: Int
        let settled: Bool
    }

    struct Event: Decodable {
        let frame: Int
        let type: String
        let seq: Int?
    }

    let levelIndex: Int
    let canvas: Canvas
    let frames: Int
    let trace: [[Sample]]
    let events: [Event]

    static func load(named name: String) throws -> GoldenTrace {
        let bundle = Bundle(for: GoldenTraceBundleLocator.self)
        guard let url = bundle.url(forResource: name, withExtension: "json") else {
            throw GoldenTraceError.missing(name)
        }
        return try JSONDecoder().decode(GoldenTrace.self, from: Data(contentsOf: url))
    }
}

enum GoldenTraceError: Error {
    case missing(String)
}

final class GoldenTraceBundleLocator {}
EOF
cat > Tests/IrisTests/Domain/LinearCongruentialGeneratorTests.swift <<'EOF'
// LinearCongruentialGeneratorTests.swift
// Layer: Tests
// Purpose: The generator reproduces the reference JavaScript sequence exactly

import Testing
@testable import Iris

@Suite("LinearCongruentialGenerator")
struct LinearCongruentialGeneratorTests {
    @Test("reproduces the JavaScript sequence for seed 2000 (level 1 seed)")
    func seed2000MatchesJavaScript() {
        var generator = LinearCongruentialGenerator(seed: 2000)
        let expected = [0.9524048353909464, 0.5286951303155006, 0.6047282235939644,
                        0.7885288065843621, 0.31775120027434844, 0.6152349108367627]

        for value in expected {
            #expect(abs(generator.next() - value) < 1e-15)
        }
    }

    @Test("reproduces the JavaScript sequence for seed 1000 (noise table of target 0)")
    func seed1000MatchesJavaScript() {
        var generator = LinearCongruentialGenerator(seed: 1000)
        let expected = [0.08186299725651577, 0.6190586419753087, 0.07575017146776405, 0.7636659807956104]

        for value in expected {
            #expect(abs(generator.next() - value) < 1e-15)
        }
    }

    @Test("values stay inside 0..<1")
    func valuesStayInRange() {
        var generator = LinearCongruentialGenerator(seed: 42)

        for _ in 0..<5000 {
            let value = generator.next()
            #expect(value >= 0 && value < 1)
        }
    }
}
EOF
cat > Tests/IrisTests/GameEngine/ValueNoise1DTests.swift <<'EOF'
// ValueNoise1DTests.swift
// Layer: Tests
// Purpose: R-03 organic noise port: table values, smoothstep interpolation, wrap-around, subtle range

import Testing
@testable import Iris

@Suite("ValueNoise1D")
struct ValueNoise1DTests {
    private let noise = ValueNoise1D(seed: 1000)

    @Test("integer times return the raw table values of the JavaScript engine")
    func integerTimesMatchTable() {
        #expect(abs(noise.value(at: 0) - (-0.8362740054869684)) < 1e-15)
        #expect(abs(noise.value(at: 1) - 0.23811728395061738) < 1e-15)
        #expect(abs(noise.value(at: 2) - (-0.8484996570644718)) < 1e-15)
    }

    @Test("half-way values use smoothstep interpolation exactly like the reference")
    func halfwayMatchesReference() {
        #expect(abs(noise.value(at: 0.5) - (-0.2990783607681755)) < 1e-15)
    }

    @Test("the table wraps around after 256 entries")
    func wrapsAround() {
        #expect(abs(noise.value(at: 255.25) - 0.6082789459019204) < 1e-15)
        #expect(abs(noise.value(at: 256) - noise.value(at: 0)) < 1e-15)
    }

    @Test("values stay within -1...1 and vary smoothly")
    func rangeAndContinuity() {
        var previous = noise.value(at: 0)
        var step = 0.0
        while step < 300 {
            let value = noise.value(at: step)
            #expect(value >= -1 && value <= 1)
            #expect(abs(value - previous) < 0.2)
            previous = value
            step += 0.02
        }
    }

    @Test("same seed gives the same sequence, different seeds differ")
    func determinism() {
        let twin = ValueNoise1D(seed: 1000)
        let other = ValueNoise1D(seed: 1137)

        #expect(twin == noise)
        #expect(other.value(at: 3.3) != noise.value(at: 3.3))
    }
}
EOF
cat > Tests/IrisTests/Domain/LevelCatalogTests.swift <<'EOF'
// LevelCatalogTests.swift
// Layer: Tests
// Purpose: R-12 progression data: fourteen levels, target counts, difficulty curve and exact reference geometry

import Testing
@testable import Iris

@Suite("LevelCatalog")
struct LevelCatalogTests {
    @Test("exactly fourteen levels, numbered 1 to 14")
    func fourteenLevels() {
        #expect(LevelCatalog.all.count == 14)
        #expect(LevelCatalog.levelCount == 14)
        #expect(LevelCatalog.all.map(\.number) == Array(1...14))
        #expect(LevelCatalog.all[0].id.raw == "level_01")
        #expect(LevelCatalog.all[13].id.raw == "level_14")
    }

    @Test("levels 1-3 have one target, 4-8 two, 9-14 three")
    func targetCounts() {
        for level in LevelCatalog.all {
            let expected = level.number <= 3 ? 1 : (level.number <= 8 ? 2 : 3)
            #expect(level.targetCount == expected, "level \(level.number)")
            #expect(level.isSequential == (expected > 1))
            #expect(level.targets.map(\.sequence) == Array(1...expected))
        }
    }

    @Test("difficulty parameters follow the reference bands with the 1.6 gaze multiplier")
    func difficultyBands() {
        let first = LevelCatalog.all[0].targets[0]
        #expect(first.attentionZone == 220 * 1.6)
        #expect(first.repulsionGain == 0.008)
        #expect(first.passiveAttraction == 0.6)

        let middle = LevelCatalog.all[5].targets[1]
        #expect(middle.attentionZone == 190 * 1.6)
        #expect(middle.repulsionGain == 0.009)
        #expect(middle.passiveAttraction == 0.55)

        let last = LevelCatalog.all[13].targets[2]
        #expect(last.attentionZone == 150 * 1.6)
        #expect(last.repulsionGain == 0.013)
        #expect(last.passiveAttraction == 0.5)
        #expect(last.noiseAmplitude == 0.15)
    }

    @Test("difficulty increases: attention zone never grows, repulsion never shrinks")
    func difficultyIsMonotonic() {
        let levels = LevelCatalog.all
        for index in 1..<levels.count {
            #expect(levels[index].targets[0].attentionZone <= levels[index - 1].targets[0].attentionZone)
            #expect(levels[index].targets[0].repulsionGain >= levels[index - 1].targets[0].repulsionGain)
            #expect(levels[index].targetCount >= levels[index - 1].targetCount)
        }
        #expect(levels[0].targets[0].attentionZone > levels[13].targets[0].attentionZone)
        #expect(levels[0].targets[0].repulsionGain < levels[13].targets[0].repulsionGain)
    }

    @Test("hold duration is 0.75 s (45 frames at 60 Hz) on every level")
    func holdDuration() {
        for level in LevelCatalog.all {
            #expect(abs(level.holdDuration - 0.75) < 1e-12)
        }
    }

    @Test("spawn and arrival points stay inside the 0.2 margin")
    func pointsInsideMargin() {
        for level in LevelCatalog.all {
            for target in level.targets {
                for point in [target.start, target.arrival] {
                    #expect(point.x >= 0.2 && point.x <= 0.8)
                    #expect(point.y >= 0.2 && point.y <= 0.8)
                }
            }
        }
    }

    @Test("level 1 and level 9 geometry equals the reference generator output")
    func exactGeometry() {
        let level1 = LevelCatalog.all[0].targets[0]
        #expect(abs(level1.start.x - 0.7714429012345678) < 1e-12)
        #expect(abs(level1.start.y - 0.5172170781893004) < 1e-12)
        #expect(abs(level1.arrival.x - 0.5628369341563786) < 1e-12)
        #expect(abs(level1.arrival.y - 0.6731172839506172) < 1e-12)

        let level9 = LevelCatalog.all[8].targets
        #expect(abs(level9[0].start.x - 0.7351671810699587) < 1e-12)
        #expect(abs(level9[1].arrival.x - 0.24083076131687242) < 1e-12)
        #expect(abs(level9[2].arrival.y - 0.5147633744855967) < 1e-12)
    }
}
EOF
cat > Tests/IrisTests/GameEngine/TargetPhysicsTests.swift <<'EOF'
// TargetPhysicsTests.swift
// Layer: Tests
// Purpose: R-01...R-07 and R-14: attraction, repulsion, friction, cap, bounce and frame-rate independence

import Testing
@testable import Iris

@Suite("TargetPhysics")
struct TargetPhysicsTests {
    private let physics = TargetPhysics(bounds: .referencePhone)

    private func target(at position: Vector2, arrival: Vector2, zone: Double = 240) -> Target {
        Target(id: TargetID(sequence: 1), position: position, arrival: arrival, attentionZone: zone,
               repulsionGain: 0.013, passiveAttraction: 0.5, noiseAmplitude: 0.15, requiredHoldTime: 0.75)
    }

    private func silent(_ time: Double) -> Double { 0 }

    @Test("R-01 a sphere out of gaze reach is attracted toward its arrival")
    func attractionTowardArrival() {
        var sphere = target(at: Vector2(x: 100, y: 400), arrival: Vector2(x: 300, y: 400))
        let farGaze = Vector2(x: 330, y: 800)

        physics.integrate(&sphere, gaze: farGaze, noise: silent, frameTime: 1, frameFraction: 1)

        #expect(sphere.velocity.x > 0)
        #expect(abs(sphere.velocity.y) < 1e-12)
        #expect(sphere.position.x > 100)
        #expect(abs(sphere.velocity.x - 0.5 * 0.94) < 1e-12)
    }

    @Test("R-02 a sphere under the gaze is pushed away from it")
    func repulsionAwayFromGaze() {
        var sphere = target(at: Vector2(x: 200, y: 400), arrival: Vector2(x: 100, y: 400))
        let gaze = Vector2(x: 150, y: 400)

        physics.integrate(&sphere, gaze: gaze, noise: silent, frameTime: 1, frameFraction: 1)

        #expect(sphere.velocity.x > 0, "pushed away from the gaze, even though the arrival is on the other side")
        #expect(sphere.position.x > 200)
    }

    @Test("R-02 repulsion grows as the gaze gets closer (proportional to zone - distance)")
    func repulsionIsProportional() {
        let expectedFar = 0.013 * (240 - 200) * 0.94
        let expectedNear = 0.013 * (240 - 50) * 0.94
        var far = target(at: Vector2(x: 200, y: 400), arrival: Vector2(x: 100, y: 400))
        var near = far

        physics.integrate(&far, gaze: Vector2(x: 0, y: 400), noise: silent, frameTime: 1, frameFraction: 1)
        physics.integrate(&near, gaze: Vector2(x: 150, y: 400), noise: silent, frameTime: 1, frameFraction: 1)

        #expect(abs(far.velocity.x - expectedFar) < 1e-12)
        #expect(abs(near.velocity.x - expectedNear) < 1e-12)
        #expect(near.velocity.x > far.velocity.x)
    }

    @Test("R-02 exactly at the attention zone boundary the sphere is attracted, just inside it is repelled")
    func zoneBoundary() {
        var atBoundary = target(at: Vector2(x: 240, y: 400), arrival: Vector2(x: 0, y: 400))
        var inside = target(at: Vector2(x: 239.9, y: 400), arrival: Vector2(x: 0, y: 400))

        physics.integrate(&atBoundary, gaze: Vector2(x: 0, y: 400), noise: silent, frameTime: 1, frameFraction: 1)
        physics.integrate(&inside, gaze: Vector2(x: 0, y: 400), noise: silent, frameTime: 1, frameFraction: 1)

        #expect(atBoundary.velocity.x < 0, "attracted toward the arrival at x = 0")
        #expect(inside.velocity.x > 0, "repelled away from the gaze at x = 0")
    }

    @Test("R-03 noise only acts while the sphere is attracted, never inside the attention zone")
    func noiseOnlyWhenAttracted() {
        var attracted = target(at: Vector2(x: 200, y: 200), arrival: Vector2(x: 200, y: 600))
        var repelled = target(at: Vector2(x: 200, y: 200), arrival: Vector2(x: 200, y: 600))
        let loudNoise: (Double) -> Double = { _ in 1 }

        physics.integrate(&attracted, gaze: Vector2(x: 330, y: 800), noise: loudNoise, frameTime: 1, frameFraction: 1)
        physics.integrate(&repelled, gaze: Vector2(x: 200, y: 150), noise: loudNoise, frameTime: 1, frameFraction: 1)

        #expect(abs(attracted.velocity.x - 0.15 * 0.94) < 1e-12, "noise amplitude 0.15 on x while attracted")
        #expect(abs(repelled.velocity.x) < 1e-12, "no noise while repelled")
    }

    @Test("R-04 speed never exceeds 2.2 points per reference frame")
    func speedCap() {
        var sphere = target(at: Vector2(x: 200, y: 400), arrival: Vector2(x: 100, y: 400))
        sphere.velocity = Vector2(x: 50, y: 50)

        physics.integrate(&sphere, gaze: Vector2(x: 330, y: 800), noise: silent, frameTime: 1, frameFraction: 1)

        #expect(sphere.speed <= 2.2 + 1e-12)
        #expect(abs(sphere.speed - 2.2 * 0.94) < 1e-9, "capped to 2.2 then friction 0.94 like the reference")
    }

    @Test("R-05 friction multiplies velocity by 0.94 per reference frame once the sphere rests on its arrival")
    func frictionDecay() {
        var sphere = target(at: Vector2(x: 200, y: 400), arrival: Vector2(x: 200, y: 400))
        sphere.velocity = Vector2(x: 1, y: 0)

        physics.integrate(&sphere, gaze: Vector2(x: 330, y: 800), noise: silent, frameTime: 1, frameFraction: 1)

        #expect(abs(sphere.velocity.x - 0.94) < 1e-9)
    }

    @Test("R-14 two half frames of friction equal one full frame (pow(0.94, dt * 60))")
    func frictionTimeEquivalence() {
        var whole = target(at: Vector2(x: 200, y: 400), arrival: Vector2(x: 200, y: 400))
        whole.velocity = Vector2(x: 1, y: 0)
        var halves = whole

        physics.integrate(&whole, gaze: Vector2(x: 330, y: 800), noise: silent, frameTime: 1, frameFraction: 1)
        physics.integrate(&halves, gaze: Vector2(x: 330, y: 800), noise: silent, frameTime: 0.5, frameFraction: 0.5)
        physics.integrate(&halves, gaze: Vector2(x: 330, y: 800), noise: silent, frameTime: 1, frameFraction: 0.5)

        #expect(abs(whole.velocity.x - halves.velocity.x) < 1e-9)
    }

    @Test("R-07 a sphere crossing the edge is clamped to the 60 pt margin and bounces with half its speed")
    func bounceIsDamped() {
        var sphere = target(at: Vector2(x: 61, y: 400), arrival: Vector2(x: -500, y: 400))
        sphere.velocity = Vector2(x: -2, y: 0)

        physics.integrate(&sphere, gaze: Vector2(x: 330, y: 800), noise: silent, frameTime: 1, frameFraction: 1)

        #expect(sphere.position.x == 60)
        #expect(sphere.velocity.x > 0, "velocity reversed")
        let expectedBeforeBounce = (-2 - 0.5) * 0.94
        #expect(abs(sphere.velocity.x - (-expectedBeforeBounce * 0.5)) < 1e-9, "bounce keeps 50 percent")
    }

    @Test("R-07 every edge keeps the sphere inside the playable area")
    func allEdges() {
        let corners = [Vector2(x: 0, y: 0), Vector2(x: 390, y: 0), Vector2(x: 0, y: 844), Vector2(x: 390, y: 844)]
        for corner in corners {
            var sphere = target(at: corner, arrival: corner)
            sphere.velocity = Vector2(x: corner.x == 0 ? -2 : 2, y: corner.y == 0 ? -2 : 2)

            physics.integrate(&sphere, gaze: Vector2(x: 195, y: 422), noise: silent, frameTime: 1, frameFraction: 1)

            #expect(sphere.position.x >= 60 && sphere.position.x <= 330)
            #expect(sphere.position.y >= 60 && sphere.position.y <= 784)
        }
    }

    @Test("R-14 one simulated second lands on the same trajectory at 30, 60 and 120 Hz")
    func frameRateIndependence() {
        let rates: [Double] = [30, 60, 120]
        var finals: [Vector2] = []
        for rate in rates {
            var sphere = target(at: Vector2(x: 100, y: 300), arrival: Vector2(x: 300, y: 600))
            let fraction = 60 / rate
            var frameTime = 0.0
            for _ in 0..<Int(rate) {
                frameTime += fraction
                physics.integrate(&sphere, gaze: Vector2(x: 330, y: 800), noise: silent, frameTime: frameTime, frameFraction: fraction)
            }
            finals.append(sphere.position)
        }
        let reference = finals[1]
        for position in finals {
            #expect(position.distance(to: reference) < 6, "within a few points after one second of cruise")
        }
    }

    @Test("R-14 the integrator stays finite and bounded for many deltaTime values")
    func stabilityAcrossDeltaTimes() {
        for fraction in [0.05, 0.25, 0.5, 1.0, 1.5, 2.0, 3.0] {
            var sphere = target(at: Vector2(x: 100, y: 300), arrival: Vector2(x: 300, y: 600))
            for step in 0..<600 {
                physics.integrate(&sphere, gaze: Vector2(x: 200, y: 450), noise: { sin($0) }, frameTime: Double(step) * fraction, frameFraction: fraction)
                #expect(sphere.position.x.isFinite && sphere.position.y.isFinite)
                #expect(sphere.position.x >= 60 && sphere.position.x <= 330)
                #expect(sphere.position.y >= 60 && sphere.position.y <= 784)
                #expect(sphere.speed <= 2.2 * fraction + 1e-9 || sphere.speed <= 2.2 + 1e-9)
            }
        }
    }
}
EOF
cat > Tests/IrisTests/Domain/ValidationRuleTests.swift <<'EOF'
// ValidationRuleTests.swift
// Layer: Tests
// Purpose: R-08 continuous 0.75 s presence and R-10 wobble tolerance, at rule and session level

import Testing
@testable import Iris

@Suite("ValidationRule")
struct ValidationRuleTests {
    private let frame = SessionFixture.frame

    @Test("R-08 entering the arrival zone starts accumulating presence")
    func enteringStartsHold() {
        var session = SessionFixture.restingSession()

        let events = SessionFixture.run(&session, frames: 1)

        #expect(session.targets[0].holdTime > 0)
        #expect(session.targets[0].isValidated == false)
        #expect(events.contains(.validationProgressed(sequence: 1, progress: session.targets[0].validationProgress)))
    }

    @Test("R-08 the target is not validated after 44 frames (0.733 s)")
    func notValidatedBeforeHoldDuration() {
        var session = SessionFixture.restingSession()

        let events = SessionFixture.run(&session, frames: 44)

        #expect(session.targets[0].isValidated == false)
        #expect(!events.contains(.targetValidated(sequence: 1)))
        #expect(session.targets[0].validationProgress < 1)
    }

    @Test("R-08 the target is validated on the 45th consecutive frame (0.75 s)")
    func validatedAfterHoldDuration() {
        var session = SessionFixture.restingSession()

        SessionFixture.run(&session, frames: 44)
        let events = session.advance(by: frame)

        #expect(session.targets[0].isValidated)
        #expect(events.contains(.targetValidated(sequence: 1)))
        #expect(events.contains(.levelCompleted))
    }

    @Test("R-08 validation also happens at 120 Hz and 30 Hz after 0.75 s of wall time")
    func validationIsTimeBased() {
        for rate in [30.0, 120.0] {
            var session = SessionFixture.restingSession()
            let dt = 1 / rate
            var validatedAt: Double?
            for step in 1...Int(rate) {
                if session.advance(by: dt).contains(.targetValidated(sequence: 1)) {
                    validatedAt = Double(step) * dt
                    break
                }
            }
            #expect(validatedAt != nil)
            if let validatedAt {
                #expect(abs(validatedAt - 0.75) < dt + 1e-9, "rate \(rate)")
            }
        }
    }

    @Test("R-08 leaving the zone before validation resets the progress to zero")
    func leavingResetsProgress() {
        var session = SessionFixture.restingSession()
        SessionFixture.run(&session, frames: 30)
        #expect(session.targets[0].holdTime > 0)

        let outside = session.targets[0].moved(to: session.targets[0].arrival + Vector2(x: 17, y: 0))
        session.replaceTargets([outside])
        let events = session.advance(by: frame)

        #expect(session.targets[0].holdTime == 0)
        #expect(events.contains(.validationProgressStopped(sequence: 1)))
    }

    @Test("R-08 presence counts only strictly inside the 16 pt settle radius")
    func settleRadius() {
        let rule = ValidationRule()
        var inside = Target(id: TargetID(sequence: 1), position: Vector2(x: 15.9, y: 0), arrival: .zero, attentionZone: 1,
                            repulsionGain: 0, passiveAttraction: 0, noiseAmplitude: 0, requiredHoldTime: 0.75)
        var edge = inside.moved(to: Vector2(x: 16, y: 0))

        _ = rule.apply(to: &inside, isTurn: true, elapsed: frame)
        _ = rule.apply(to: &edge, isTurn: true, elapsed: frame)

        #expect(inside.holdTime > 0)
        #expect(edge.holdTime == 0)
    }

    @Test("R-10 a validated target keeps its validation while wobbling within 36 pt")
    func validatedTargetTolerance() {
        var session = SessionFixture.restingSession()
        SessionFixture.run(&session, frames: 45)
        #expect(session.targets[0].isValidated)

        let wobbling = session.targets[0].moved(to: session.targets[0].arrival + Vector2(x: 35, y: 0))
        session.replaceTargets([wobbling])
        let events = session.advance(by: frame)

        #expect(session.targets[0].isValidated)
        #expect(!events.contains(.targetLost(sequence: 1, cause: .drift)))
    }

    @Test("R-10 beyond the 36 pt tolerance the validation is lost immediately")
    func validatedTargetLoss() {
        var session = SessionFixture.restingSession()
        SessionFixture.run(&session, frames: 45)

        let drifted = session.targets[0].moved(to: session.targets[0].arrival + Vector2(x: 37, y: 0))
        session.replaceTargets([drifted])
        let events = session.advance(by: frame)

        #expect(session.targets[0].isValidated == false)
        #expect(session.targets[0].holdTime == 0)
        #expect(events.contains(.targetLost(sequence: 1, cause: .drift)))
    }

    @Test("progress reported by events climbs from 1/45 to 1")
    func progressEvents() {
        var session = SessionFixture.restingSession()
        var lastProgress = 0.0
        for _ in 0..<45 {
            for event in session.advance(by: frame) {
                if case let .validationProgressed(_, progress) = event {
                    #expect(progress > lastProgress)
                    lastProgress = progress
                }
            }
        }
        #expect(lastProgress > 0.97)
    }
}
EOF
cat > Tests/IrisTests/Domain/SequenceOrderTests.swift <<'EOF'
// SequenceOrderTests.swift
// Layer: Tests
// Purpose: R-09 targets validate only in order 1, 2, 3; physical arrival out of turn is allowed but never counts

import Testing
@testable import Iris

@Suite("SequenceOrder")
struct SequenceOrderTests {
    private let frame = SessionFixture.frame

    @Test("R-09 target 1 is validatable immediately")
    func firstTargetValidatesImmediately() {
        var session = SessionFixture.tripleRestingSession()

        let events = SessionFixture.run(&session, frames: 45)

        #expect(events.contains(.targetValidated(sequence: 1)))
        #expect(session.targets[0].isValidated)
    }

    @Test("R-09 target 2 cannot be validated before target 1")
    func secondWaitsForFirst() {
        var session = SessionFixture.tripleRestingSession()
        let farFromArrival = session.targets[0].moved(to: Vector2(x: 300, y: 700))
        session.replaceTargets([farFromArrival, session.targets[1], session.targets[2]])

        let events = SessionFixture.run(&session, frames: 90)

        #expect(!events.contains(.targetValidated(sequence: 2)))
        #expect(session.targets[1].isValidated == false)
        #expect(session.targets[1].holdTime == 0, "presence out of turn never accumulates")
    }

    @Test("R-09 target 3 cannot be validated before 1 and 2")
    func thirdWaitsForFirstTwo() {
        var session = SessionFixture.tripleRestingSession()
        session.replaceTargets([session.targets[0].validatedCopy(),
                                session.targets[1].moved(to: Vector2(x: 300, y: 700)),
                                session.targets[2]])

        let events = SessionFixture.run(&session, frames: 90)

        #expect(!events.contains(.targetValidated(sequence: 3)))
        #expect(session.targets[2].isValidated == false)
        #expect(session.targets[0].isValidated, "target 1 keeps its validation")
    }

    @Test("R-09 physical arrival out of turn is allowed: the sphere stays in its ring without validating")
    func physicalArrivalOutOfTurn() {
        var session = SessionFixture.tripleRestingSession()
        session.replaceTargets([session.targets[0].moved(to: Vector2(x: 300, y: 700)), session.targets[1], session.targets[2]])

        SessionFixture.run(&session, frames: 120)

        #expect(session.targets[1].distanceToArrival < 16, "target 2 physically rests on its arrival")
        #expect(session.targets[1].isValidated == false)
    }

    @Test("R-09 once target 1 is validated, target 2 starts its own 0.75 s and then target 3")
    func orderedValidation() {
        var session = SessionFixture.tripleRestingSession()
        var order: [Int] = []

        for _ in 0..<200 {
            for event in session.advance(by: frame) {
                if case let .targetValidated(sequence) = event { order.append(sequence) }
            }
            if session.isComplete { break }
        }

        #expect(order == [1, 2, 3])
        #expect(session.isComplete)
    }

    @Test("R-09 lowest unvalidated sequence and turn evaluation")
    func turnRule() {
        let session = SessionFixture.tripleRestingSession()
        let targets = [session.targets[0].validatedCopy(), session.targets[1], session.targets[2]]

        let lowest = TurnRule.lowestUnvalidatedSequence(in: targets)

        #expect(lowest == 2)
        #expect(TurnRule.isTurn(of: targets[0], lowestUnvalidated: lowest, isSequential: true), "validated keeps its place")
        #expect(TurnRule.isTurn(of: targets[1], lowestUnvalidated: lowest, isSequential: true))
        #expect(!TurnRule.isTurn(of: targets[2], lowestUnvalidated: lowest, isSequential: true))
        #expect(TurnRule.isTurn(of: targets[2], lowestUnvalidated: lowest, isSequential: false), "non sequential levels ignore order")
        #expect(TurnRule.lowestUnvalidatedSequence(in: targets.map { $0.validatedCopy() }) == nil)
    }
}
EOF
cat > Tests/IrisTests/Domain/CascadeRuleTests.swift <<'EOF'
// CascadeRuleTests.swift
// Layer: Tests
// Purpose: R-11 losing a validation invalidates every higher rank, never a lower one

import Testing
@testable import Iris

@Suite("CascadeRule")
struct CascadeRuleTests {
    private let frame = SessionFixture.frame

    private func fullyValidatedSession() -> GameSession {
        var session = SessionFixture.tripleRestingSession()
        session.replaceTargets(session.targets.map { $0.validatedCopy() })
        return session
    }

    @Test("R-11 rule level: losing 3 leaves 1 and 2 validated")
    func ruleLosingThird() {
        let session = fullyValidatedSession()
        var targets = session.targets
        targets[2].isValidated = false

        let invalidated = CascadeRule.apply(to: &targets)

        #expect(invalidated.isEmpty)
        #expect(targets.map(\.isValidated) == [true, true, false])
    }

    @Test("R-11 rule level: losing 2 invalidates 2 and 3, keeps 1")
    func ruleLosingSecond() {
        let session = fullyValidatedSession()
        var targets = session.targets
        targets[1].isValidated = false

        let invalidated = CascadeRule.apply(to: &targets)

        #expect(invalidated == [3])
        #expect(targets.map(\.isValidated) == [true, false, false])
        #expect(targets[2].holdTime == 0)
    }

    @Test("R-11 rule level: losing 1 invalidates 1, 2 and 3")
    func ruleLosingFirst() {
        let session = fullyValidatedSession()
        var targets = session.targets
        targets[0].isValidated = false

        let invalidated = CascadeRule.apply(to: &targets)

        #expect(invalidated == [2, 3])
        #expect(targets.map(\.isValidated) == [false, false, false])
    }

    @Test("R-11 session level: target 3 drifting out does not affect 1 and 2")
    func sessionLosingThird() {
        var session = fullyValidatedSession()
        let drifted = session.targets[2].moved(to: session.targets[2].arrival + Vector2(x: 40, y: 0))
        session.replaceTargets([session.targets[0], session.targets[1], drifted])

        let events = session.advance(by: frame)

        #expect(session.targets.map(\.isValidated) == [true, true, false])
        #expect(events.contains(.targetLost(sequence: 3, cause: .drift)))
        #expect(!events.contains(.targetLost(sequence: 2, cause: .cascade)))
    }

    @Test("R-11 session level: target 2 drifting out invalidates 2 and 3, keeps 1")
    func sessionLosingSecond() {
        var session = fullyValidatedSession()
        let drifted = session.targets[1].moved(to: session.targets[1].arrival + Vector2(x: 0, y: 40))
        session.replaceTargets([session.targets[0], drifted, session.targets[2]])

        let events = session.advance(by: frame)

        #expect(session.targets.map(\.isValidated) == [true, false, false])
        #expect(events.contains(.targetLost(sequence: 2, cause: .drift)))
        #expect(events.contains(.targetLost(sequence: 3, cause: .cascade)))
        #expect(!session.isComplete)
    }

    @Test("R-11 session level: target 1 drifting out invalidates everything")
    func sessionLosingFirst() {
        var session = fullyValidatedSession()
        let drifted = session.targets[0].moved(to: session.targets[0].arrival + Vector2(x: -40, y: 0))
        session.replaceTargets([drifted, session.targets[1], session.targets[2]])

        let events = session.advance(by: frame)

        #expect(session.targets.map(\.isValidated) == [false, false, false])
        #expect(events.contains(.targetLost(sequence: 1, cause: .drift)))
        #expect(events.contains(.targetLost(sequence: 2, cause: .cascade)))
        #expect(events.contains(.targetLost(sequence: 3, cause: .cascade)))
    }

    @Test("R-11 after a cascade, higher targets must wait again for their turn")
    func cascadeRestoresOrder() {
        var session = fullyValidatedSession()
        let drifted = session.targets[0].moved(to: Vector2(x: 300, y: 700))
        session.replaceTargets([drifted, session.targets[1], session.targets[2]])

        SessionFixture.run(&session, frames: 60)

        #expect(session.targets[1].isValidated == false)
        #expect(session.targets[1].holdTime == 0, "target 2 rests on its arrival but is not its turn")
        #expect(session.targets[2].isValidated == false)
    }

    @Test("R-11 on a non sequential level nothing cascades")
    func noCascadeWhenNotSequential() {
        var session = SessionFixture.restingSession()
        SessionFixture.run(&session, frames: 45)
        #expect(session.targets[0].isValidated)
        #expect(session.level.isSequential == false)
    }
}
EOF
cat > Tests/IrisTests/GameEngine/GameSessionGoldenTests.swift <<'EOF'
// GameSessionGoldenTests.swift
// Layer: Tests
// Purpose: The Swift engine reproduces the reference JavaScript engine frame by frame (golden traces)

import Testing
import Foundation
@testable import Iris

@Suite("GameSession golden traces")
struct GameSessionGoldenTests {
    private let tolerance = 1e-6

    private func compare(_ session: GameSession, with samples: [GoldenTrace.Sample], frame: Int) {
        #expect(session.targets.count == samples.count)
        for (target, sample) in zip(session.targets, samples) {
            #expect(abs(target.position.x - sample.x) < tolerance, "x frame \(frame) seq \(target.sequence)")
            #expect(abs(target.position.y - sample.y) < tolerance, "y frame \(frame) seq \(target.sequence)")
            #expect(abs(target.velocity.x - sample.vx) < tolerance, "vx frame \(frame) seq \(target.sequence)")
            #expect(abs(target.velocity.y - sample.vy) < tolerance, "vy frame \(frame) seq \(target.sequence)")
            #expect(Int((target.holdTime * 60).rounded()) == sample.hold, "hold frame \(frame) seq \(target.sequence)")
            #expect(target.isValidated == sample.settled, "settled frame \(frame) seq \(target.sequence)")
        }
    }

    @Test("level 1 scripted gaze: repulsion, bounces, then attraction and validation match the reference")
    func level1Scripted() throws {
        let golden = try GoldenTrace.load(named: "golden_level1_scripted")
        var session = GameSession(level: LevelCatalog.all[golden.levelIndex],
                                  bounds: PlayfieldBounds(width: golden.canvas.width, height: golden.canvas.height))
        var validatedFrame: Int?
        var completedFrame: Int?

        for frame in 1...golden.frames {
            session.placeGaze(at: frame <= 150 ? Vector2(x: 230, y: 560) : Vector2(x: 60, y: 60))
            let events = session.advance(by: 1.0 / 60.0)
            compare(session, with: golden.trace[frame - 1], frame: frame)
            if events.contains(.targetValidated(sequence: 1)) { validatedFrame = frame }
            if events.contains(.levelCompleted) { completedFrame = frame }
        }

        let goldenValidated = golden.events.first { $0.type == "validated" }?.frame
        let goldenCompleted = golden.events.first { $0.type == "levelCompleted" }?.frame
        #expect(validatedFrame == goldenValidated)
        #expect(completedFrame == goldenCompleted)
        #expect(session.isComplete)
    }

    @Test("level 9 with a parked gaze: three spheres validate in order 1, 2, 3 exactly like the reference")
    func level9Ordered() throws {
        let golden = try GoldenTrace.load(named: "golden_level9_far")
        var session = GameSession(level: LevelCatalog.all[golden.levelIndex],
                                  bounds: PlayfieldBounds(width: golden.canvas.width, height: golden.canvas.height))
        var validations: [(frame: Int, sequence: Int)] = []

        for frame in 1...golden.frames {
            session.placeGaze(at: Vector2(x: 330, y: 784))
            for event in session.advance(by: 1.0 / 60.0) {
                if case let .targetValidated(sequence) = event { validations.append((frame, sequence)) }
            }
            compare(session, with: golden.trace[frame - 1], frame: frame)
        }

        let goldenValidations = golden.events.filter { $0.type == "validated" }.map { ($0.frame, $0.seq ?? -1) }
        #expect(validations.map(\.sequence) == goldenValidations.map(\.1))
        #expect(validations.map(\.frame) == goldenValidations.map(\.0))
        #expect(session.isComplete)
    }
}
EOF
cat > Tests/IrisTests/GameEngine/GameSessionTests.swift <<'EOF'
// GameSessionTests.swift
// Layer: Tests
// Purpose: R-12 and R-14 session behaviour: completion, delta clamping, sub-stepping, gaze handling

import Testing
@testable import Iris

@Suite("GameSession")
struct GameSessionTests {
    private let frame = SessionFixture.frame

    @Test("loading a level places every target at its start with zero velocity")
    func loadsLevel() {
        let session = GameSession(level: LevelCatalog.all[8], bounds: .referencePhone)

        #expect(session.targets.count == 3)
        #expect(session.targets.map(\.sequence) == [1, 2, 3])
        #expect(session.targets.allSatisfy { $0.velocity == .zero })
        #expect(session.targets.allSatisfy { !$0.isValidated && $0.holdTime == 0 })
        #expect(abs(session.targets[0].position.x - 0.7351671810699587 * 390) < 1e-9)
        #expect(session.gaze.position == PlayfieldBounds.referencePhone.center)
    }

    @Test("R-12 the level completes when every target is validated and then stops advancing")
    func completion() {
        var session = SessionFixture.restingSession()

        let events = SessionFixture.run(&session, frames: 45)
        let after = session.advance(by: frame)

        #expect(events.last == .levelCompleted)
        #expect(session.isComplete)
        #expect(after.isEmpty)
    }

    @Test("R-14 a long stall is clamped to 0.1 s and split into 60 Hz sub-steps")
    func stallClamp() {
        var stalled = SessionFixture.restingSession()
        var smooth = SessionFixture.restingSession()

        _ = stalled.advance(by: 2.0)
        SessionFixture.run(&smooth, frames: 6)

        #expect(abs(stalled.elapsed - 0.1) < 1e-12)
        #expect(abs(stalled.frameTime - 6) < 1e-9)
        #expect(abs(stalled.targets[0].holdTime - smooth.targets[0].holdTime) < 1e-9)
    }

    @Test("R-14 a 30 Hz frame equals two 60 Hz frames exactly")
    func thirtyHertzEqualsTwoFrames() {
        var slow = SessionFixture.session(level: LevelCatalog.all[0])
        var fast = SessionFixture.session(level: LevelCatalog.all[0])

        for _ in 0..<120 {
            _ = slow.advance(by: 1.0 / 30.0)
            _ = fast.advance(by: frame)
            _ = fast.advance(by: frame)
        }

        #expect(slow.targets[0].position.distance(to: fast.targets[0].position) < 1e-6)
        #expect(abs(slow.frameTime - fast.frameTime) < 1e-9)
    }

    @Test("R-14 a 120 Hz run stays close to the 60 Hz run")
    func hundredTwentyHertzIsClose() {
        var half = SessionFixture.session(level: LevelCatalog.all[0])
        var whole = SessionFixture.session(level: LevelCatalog.all[0])

        for _ in 0..<180 {
            _ = half.advance(by: 1.0 / 120.0)
            _ = half.advance(by: 1.0 / 120.0)
            _ = whole.advance(by: frame)
        }

        #expect(half.targets[0].position.distance(to: whole.targets[0].position) < 8)
    }

    @Test("zero or negative deltas do nothing")
    func nonPositiveDelta() {
        var session = SessionFixture.restingSession()

        #expect(session.advance(by: 0).isEmpty)
        #expect(session.advance(by: -1).isEmpty)
        #expect(session.elapsed == 0)
    }

    @Test("R-13 ingested gaze is smoothed toward the raw sample")
    func gazeSmoothing() {
        var session = SessionFixture.session(level: LevelCatalog.all[0], gaze: Vector2(x: 100, y: 100))

        session.ingestGaze(Vector2(x: 200, y: 100))

        #expect(abs(session.gaze.position.x - 110) < 1e-9)
    }
}
EOF
cat > Tests/IrisTests/GameEngine/GazeFilterTests.swift <<'EOF'
// GazeFilterTests.swift
// Layer: Tests
// Purpose: R-13 exponential smoothing and sustained-jump gating of the reference gaze listener

import Testing
@testable import Iris

@Suite("GazeFilter")
struct GazeFilterTests {
    @Test("the first sample activates the filter and moves 10 percent of the way")
    func firstSample() {
        var filter = GazeFilter(initialPosition: Vector2(x: 0, y: 0))

        let accepted = filter.ingest(Vector2(x: 100, y: 0))

        #expect(accepted)
        #expect(filter.isActive)
        #expect(abs(filter.position.x - 10) < 1e-12)
    }

    @Test("repeated samples converge exponentially (alpha 0.1)")
    func convergence() {
        var filter = GazeFilter(initialPosition: .zero)
        for _ in 0..<60 { filter.ingest(Vector2(x: 100, y: 50)) }

        let expected = 100 * (1 - pow(0.9, 60))
        #expect(abs(filter.position.x - expected) < 1e-9)
        #expect(abs(filter.position.y - expected / 2) < 1e-9)
    }

    @Test("an isolated big jump (blink) is ignored twice, the third consecutive one is trusted")
    func jumpGating() {
        var filter = GazeFilter(initialPosition: .zero)
        filter.ingest(Vector2(x: 0, y: 0))

        #expect(filter.ingest(Vector2(x: 500, y: 0)) == false)
        #expect(filter.position.x == 0)
        #expect(filter.ingest(Vector2(x: 500, y: 0)) == false)
        #expect(filter.ingest(Vector2(x: 500, y: 0)) == true)
        #expect(abs(filter.position.x - 50) < 1e-12)
    }

    @Test("a small sample between jumps resets the jump counter")
    func jumpCounterReset() {
        var filter = GazeFilter(initialPosition: .zero)
        filter.ingest(.zero)

        #expect(filter.ingest(Vector2(x: 500, y: 0)) == false)
        #expect(filter.ingest(Vector2(x: 1, y: 0)) == true)
        #expect(filter.ingest(Vector2(x: 500, y: 0)) == false)
        #expect(filter.ingest(Vector2(x: 500, y: 0)) == false)
    }

    @Test("jumps are never gated before the filter is active")
    func inactiveFilterAcceptsJumps() {
        var filter = GazeFilter(initialPosition: .zero)

        #expect(filter.ingest(Vector2(x: 900, y: 900)))
    }

    @Test("placing the cursor bypasses smoothing")
    func placement() {
        var filter = GazeFilter(initialPosition: .zero)

        filter.place(at: Vector2(x: 42, y: 24))

        #expect(filter.position == Vector2(x: 42, y: 24))
        #expect(filter.isActive)
    }
}
EOF
cat > Tests/IrisTests/GameEngine/GameProgressionTests.swift <<'EOF'
// GameProgressionTests.swift
// Layer: Tests
// Purpose: R-12 progression across the fourteen levels

import Testing
@testable import Iris

@Suite("GameProgression")
struct GameProgressionTests {
    @Test("starts at level 1 of 14")
    func start() {
        let progression = GameProgression()

        #expect(progression.levelCount == 14)
        #expect(progression.currentNumber == 1)
        #expect(progression.currentLevel.targetCount == 1)
        #expect(!progression.isFinished)
    }

    @Test("completing a level moves to the next one until the journey finishes after level 14")
    func advance() {
        var progression = GameProgression()
        var visited = [progression.currentNumber]

        while true {
            switch progression.completeCurrentLevel() {
            case let .nextLevel(level):
                visited.append(level.number)
                continue
            case .journeyFinished:
                break
            }
            break
        }

        #expect(visited == Array(1...14))
        #expect(progression.isFinished)
        #expect(progression.isLastLevel)
    }

    @Test("restart goes back to level 1")
    func restart() {
        var progression = GameProgression()
        _ = progression.completeCurrentLevel()
        _ = progression.completeCurrentLevel()

        progression.restart()

        #expect(progression.currentNumber == 1)
        #expect(!progression.isFinished)
    }

    @Test("an empty level list falls back to the catalog")
    func emptyFallsBack() {
        let progression = GameProgression(levels: [])

        #expect(progression.levelCount == 14)
    }
}
EOF
cat > Tests/IrisTests/Audio/AudioCuePolicyTests.swift <<'EOF'
// AudioCuePolicyTests.swift
// Layer: Tests
// Purpose: Sound policy: crescendo per target, chime on validation, one loss tone per cascade

import Testing
@testable import Iris

@Suite("AudioCuePolicy")
struct AudioCuePolicyTests {
    @Test("progress events map to per-target crescendo voices")
    func progressMapping() {
        var policy = AudioCuePolicy()

        let cues = policy.cues(for: [.validationProgressed(sequence: 2, progress: 0.5),
                                     .validationProgressStopped(sequence: 1)], at: 0)

        #expect(cues == [.progress(voice: 1, progress: 0.5), .stopProgress(voice: 0)])
    }

    @Test("a validation plays the chime")
    func validation() {
        var policy = AudioCuePolicy()

        #expect(policy.cues(for: [.targetValidated(sequence: 1)], at: 0) == [.validation])
    }

    @Test("a cascade in one tick produces a single loss tone")
    func cascadeCoalesced() {
        var policy = AudioCuePolicy()

        let cues = policy.cues(for: [.targetLost(sequence: 1, cause: .drift),
                                     .targetLost(sequence: 2, cause: .cascade),
                                     .targetLost(sequence: 3, cause: .cascade)], at: 1)

        #expect(cues == [.loss])
    }

    @Test("losses closer than the retrigger interval do not stack")
    func retriggerGuard() {
        var policy = AudioCuePolicy(lossRetriggerInterval: 0.15)

        let first = policy.cues(for: [.targetLost(sequence: 3, cause: .drift)], at: 1.0)
        let tooSoon = policy.cues(for: [.targetLost(sequence: 2, cause: .drift)], at: 1.05)
        let later = policy.cues(for: [.targetLost(sequence: 1, cause: .drift)], at: 1.2)

        #expect(first == [.loss])
        #expect(tooSoon.isEmpty)
        #expect(later == [.loss])
    }

    @Test("level completion is silent for the policy (handled by presentation)")
    func levelCompletedSilent() {
        var policy = AudioCuePolicy()

        #expect(policy.cues(for: [.levelCompleted], at: 0).isEmpty)
    }
}
EOF
echo "tests written"; find Tests -name "*.swift" | wc -l
~~~~

#### 2026-09-10 23:53:29 +0200 (21:53:29Z) · TOOL RESULT · Bash
`f88478cc` · `fc7732cd` · ligne 310 · Write test fixtures and the deterministic test suite (domain, engine, audio policy)

~~~~text
tests written
      14
~~~~

#### 2026-09-10 23:53:43 +0200 (21:53:43Z) · TOOL CALL · Bash
`f88478cc` · `273a990d` · ligne 321 · Regenerate the app icon without alpha and create a small preview

~~~~bash
cd "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris" && sed -i '' 's/bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue/bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue/' Tools/MakeAppIcon.swift && swift Tools/MakeAppIcon.swift Resources/Assets.xcassets/AppIcon.appiconset/AppIcon.png && sips -g hasAlpha Resources/Assets.xcassets/AppIcon.appiconset/AppIcon.png && sips -s format png -z 256 256 Resources/Assets.xcassets/AppIcon.appiconset/AppIcon.png --out "/private/tmp/claude-501/-Volumes-Steve-Pro-BlackSSD-Dev-App-Mobile-Iris/f88478cc-d512-4210-bc11-758059278995/scratchpad/icon_preview.png" >/dev/null && echo preview ok
~~~~

#### 2026-09-10 23:53:45 +0200 (21:53:45Z) · TOOL CALL · Bash · BUILD
`f88478cc` · `4f0adfc2` · ligne 322 · Generate the Xcode project and run the first Debug build on the simulator

~~~~bash
cd "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris" && xcodegen generate 2>&1 | tail -5 && ls && echo "=== BUILD ===" && xcodebuild -project Iris.xcodeproj -scheme Iris -destination 'platform=iOS Simulator,name=iPhone 17 Pro' -configuration Debug build 2>&1 | grep -E "error:|warning:|BUILD|Compiling|note: " | grep -v "note: Using" | head -60
~~~~

#### 2026-09-10 23:53:45 +0200 (21:53:45Z) · TOOL RESULT · Bash
`f88478cc` · `955ded94` · ligne 323 · Regenerate the app icon without alpha and create a small preview

~~~~text
wrote /Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris/Resources/Assets.xcassets/AppIcon.appiconset/AppIcon.png
/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris/Resources/Assets.xcassets/AppIcon.appiconset/AppIcon.png
  hasAlpha: no
preview ok
~~~~

#### 2026-09-10 23:53:47 +0200 (21:53:47Z) · TOOL RESULT · Bash · BUILD
`f88478cc` · `5e9464ff` · ligne 324 · Generate the Xcode project and run the first Debug build on the simulator

~~~~text
4 Spec validations errors:
	- Target "Iris" has a missing source directory "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris/AR"
	- Target "Iris" has a missing source directory "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris/Navigation"
	- Target "Iris" has a missing source directory "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris/Features"
	- Target "Iris" has a missing source directory "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris/DesignSystem"
App
attention-indirecte.html
Audio
Config
Docs
Domain
GameEngine
ios-app-skills.zip
project.yml
Resources
SwiftUI-Agent-Skill-main.zip
Tests
Tools
=== BUILD ===
xcodebuild: error: 'Iris.xcodeproj' does not exist.
~~~~

#### 2026-09-10 23:53:51 +0200 (21:53:51Z) · TOOL CALL · Bash · BUILD
`f88478cc` · `71511daa` · ligne 328 · Create remaining source folders, regenerate the project and build

~~~~bash
cd "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris" && mkdir -p AR Navigation Features DesignSystem && touch AR/.gitkeep Navigation/.gitkeep Features/.gitkeep DesignSystem/.gitkeep && xcodegen generate 2>&1 | tail -3 && echo "=== BUILD ===" && xcodebuild -project Iris.xcodeproj -scheme Iris -destination 'platform=iOS Simulator,name=iPhone 17 Pro' -configuration Debug build 2>&1 | grep -E "error:|warning:|BUILD|note: " | grep -v "note: Using\|note: Building\|note: Planning" | head -60
~~~~

#### 2026-09-10 23:53:52 +0200 (21:53:52Z) · TOOL CALL · Read
`f88478cc` · `093aecc9` · ligne 329

~~~~json
{
 "file_path": "/private/tmp/claude-501/-Volumes-Steve-Pro-BlackSSD-Dev-App-Mobile-Iris/f88478cc-d512-4210-bc11-758059278995/scratchpad/icon_preview.png"
}
~~~~

#### 2026-09-10 23:55:59 +0200 (21:55:59Z) · TOOL RESULT · Bash · BUILD
`f88478cc` · `a0c2017f` · ligne 330 · Create remaining source folders, regenerate the project and build

~~~~text
⚙️  Generating project...
⚙️  Writing project...
Created project at /Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris/Iris.xcodeproj
=== BUILD ===
note: Target dependency graph (1 target)
note: Emplaced /Users/prodx0x/Library/Developer/Xcode/DerivedData/Iris-hbvpozvvubiwdsgixqcdikegxrtj/Build/Products/Debug-iphonesimulator/Iris.app/AppIcon76x76@2x~ipad.png (in target 'Iris' from project 'Iris')
note: Emplaced /Users/prodx0x/Library/Developer/Xcode/DerivedData/Iris-hbvpozvvubiwdsgixqcdikegxrtj/Build/Products/Debug-iphonesimulator/Iris.app/Assets.car (in target 'Iris' from project 'Iris')
note: Emplaced /Users/prodx0x/Library/Developer/Xcode/DerivedData/Iris-hbvpozvvubiwdsgixqcdikegxrtj/Build/Products/Debug-iphonesimulator/Iris.app/AppIcon60x60@2x.png (in target 'Iris' from project 'Iris')
2026-09-10 23:55:58.852 appintentsmetadataprocessor[2171:54442] warning: Metadata extraction skipped. No AppIntents.framework dependency found.
** BUILD SUCCEEDED **
~~~~

#### 2026-09-10 23:55:59 +0200 (21:55:59Z) · TOOL RESULT · Read
`f88478cc` · `ca6413dc` · ligne 332

[IMAGE omise : image/png, 96124 caractères base64, sha256 8e35be1b14ffa266…]

#### 2026-09-10 23:58:21 +0200 (21:58:21Z) · TOOL CALL · Bash · TEST
`f88478cc` · `7735ad27` · ligne 343 · Run the unit test suite on the simulator

~~~~bash
cd "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris" && xcodebuild -project Iris.xcodeproj -scheme Iris -destination 'platform=iOS Simulator,name=iPhone 17 Pro' -configuration Debug test 2>&1 | tee "/private/tmp/claude-501/-Volumes-Steve-Pro-BlackSSD-Dev-App-Mobile-Iris/f88478cc-d512-4210-bc11-758059278995/scratchpad/test1.log" | grep -E "error:|warning:|Test run|Test Suite|passed after|failed after|Executed|✘|✔|TEST " | grep -v "note:" | tail -80
~~~~

#### 2026-09-10 23:58:30 +0200 (21:58:30Z) · TOOL RESULT · Bash · TEST
`f88478cc` · `9be6512f` · ligne 344 · Run the unit test suite on the simulator

~~~~text
2026-09-10 23:58:29.586 appintentsmetadataprocessor[2238:56685] warning: Metadata extraction skipped. No AppIntents.framework dependency found.
/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris/Tests/IrisTests/GameEngine/TargetPhysicsTests.swift:169:84: error: cannot find 'sin' in scope
/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris/Tests/IrisTests/GameEngine/TargetPhysicsTests.swift:169:84: error: cannot find 'sin' in scope
** TEST FAILED **
~~~~

#### 2026-09-10 23:59:54 +0200 (21:59:54Z) · TOOL CALL · Bash
`f88478cc` · `6fe9fe42` · ligne 345 · Write design system tokens, modifiers and components; add sphere shading colours

~~~~bash
cd "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris" && rm -f DesignSystem/.gitkeep && mkdir -p DesignSystem/Tokens DesignSystem/Components DesignSystem/Modifiers
python3 - <<'EOF'
import json, os
root = "Resources/Assets.xcassets"
def hexrgb(h, alpha=1.0):
    h = h.lstrip('#'); r, g, b = int(h[0:2],16), int(h[2:4],16), int(h[4:6],16)
    return {"alpha": f"{alpha:.3f}", "blue": f"0x{b:02X}", "green": f"0x{g:02X}", "red": f"0x{r:02X}"}
def colorset(name, hexval):
    comp = hexrgb(hexval)
    path = f"{root}/{name}.colorset/Contents.json"
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "w") as f:
        json.dump({"colors": [
            {"color": {"color-space": "srgb", "components": comp}, "idiom": "universal"},
            {"appearances": [{"appearance": "luminosity", "value": "dark"}], "color": {"color-space": "srgb", "components": comp}, "idiom": "universal"}],
            "info": {"author": "xcode", "version": 1}}, f, indent=2)
# Sphere shading derived from the reference engine: base +40 (light) / -30 (dark) per channel.
extra = {
    "ds.scene.sphereLight": "#DCDAD1",          # 180+40,178+40,169+40
    "ds.scene.sphereDark": "#96948B",           # 180-30,178-30,169-30
    "ds.scene.sphereValidatedLight": "#85F2CD", # 93+40,202+40,165+40
    "ds.scene.sphereValidatedDark": "#3FAC87",  # 93-30,202-30,165-30
    "ds.scene.shadow": "#000000",
    "ds.scene.ring": "#FFFFFF",
    "ds.scene.label": "#16171A",
}
for k, v in extra.items(): colorset(k, v)
print("extra colorsets", len(extra))
EOF
cat > DesignSystem/Tokens/DSColor.swift <<'EOF'
// DSColor.swift
// Layer: DesignSystem
// Purpose: Semantic colour tokens of the Iris identity (values live in the asset catalogue)

import SwiftUI

enum DSColor {
    // Grounds
    static let backgroundPrimary = Color("ds.background.primary")
    static let backgroundSurface = Color("ds.background.surface")
    static let backgroundElevated = Color("ds.background.elevated")

    // Text
    static let textPrimary = Color("ds.text.primary")
    static let textSecondary = Color("ds.text.secondary")
    static let textTertiary = Color("ds.text.tertiary")
    static let textOnAccent = Color("ds.text.onAccent")
    static let textWarm = Color("ds.text.warm")

    // Accent (amber) and status
    static let accent = Color("ds.accent")
    static let accentDeep = Color("ds.accent.deep")
    static let statusSuccess = Color("ds.status.success")
    static let statusDanger = Color("ds.status.danger")
    static let statusInfo = Color("ds.status.info")
    static let lineSubtle = Color("ds.line.subtle")

    // Game scene (ported from the reference engine palette)
    static let sceneSkyTop = Color("ds.scene.skyTop")
    static let sceneSkyHorizon = Color("ds.scene.skyHorizon")
    static let sceneFloorNear = Color("ds.scene.floorNear")
    static let sceneFloorFar = Color("ds.scene.floorFar")
    static let sceneSphere = Color("ds.scene.sphere")
    static let sceneSphereLight = Color("ds.scene.sphereLight")
    static let sceneSphereDark = Color("ds.scene.sphereDark")
    static let sceneSphereValidated = Color("ds.scene.sphereValidated")
    static let sceneSphereValidatedLight = Color("ds.scene.sphereValidatedLight")
    static let sceneSphereValidatedDark = Color("ds.scene.sphereValidatedDark")
    static let sceneShadow = Color("ds.scene.shadow")
    static let sceneRing = Color("ds.scene.ring")
    static let sceneLabel = Color("ds.scene.label")

    /// Sequence colours (`SEQ_COLORS`), 1-based, wrapping after five.
    static func sequence(_ sequence: Int) -> Color {
        let index = ((sequence - 1) % 5 + 5) % 5 + 1
        return Color("ds.sequence.\(index)")
    }
}
EOF
cat > DesignSystem/Tokens/DSFont.swift <<'EOF'
// DSFont.swift
// Layer: DesignSystem
// Purpose: Typography tokens: serif display for the Iris voice, system text for reading, all Dynamic Type aware

import SwiftUI

enum DSFont {
    /// Wordmark and hero titles ("iris", "parcours terminé").
    static let display = Font.system(.largeTitle, design: .serif).weight(.medium)
    /// Screen titles.
    static let title = Font.system(.title, design: .serif).weight(.regular)
    /// Section titles and overlay headings.
    static let title2 = Font.system(.title2, design: .serif).weight(.regular)
    /// Emphasised body.
    static let headline = Font.headline
    static let body = Font.body
    static let callout = Font.callout
    static let footnote = Font.footnote
    static let caption = Font.caption
    /// Small uppercase tracked labels (use with `dsEyebrowStyle`).
    static let eyebrow = Font.caption.weight(.semibold)
    /// Numeric readouts.
    static let mono = Font.system(.caption, design: .monospaced)
}
EOF
cat > DesignSystem/Tokens/DSSpacing.swift <<'EOF'
// DSSpacing.swift
// Layer: DesignSystem
// Purpose: Spacing scale on a 4 pt grid

import SwiftUI

enum DSSpacing {
    static let xxs: CGFloat = 2
    static let xs: CGFloat = 4
    static let s: CGFloat = 8
    static let m: CGFloat = 16
    static let l: CGFloat = 24
    static let xl: CGFloat = 32
    static let xxl: CGFloat = 48
    static let xxxl: CGFloat = 72
    /// Horizontal page gutter.
    static let gutter: CGFloat = 24
}
EOF
cat > DesignSystem/Tokens/DSRadius.swift <<'EOF'
// DSRadius.swift
// Layer: DesignSystem
// Purpose: Corner radius scale

import SwiftUI

enum DSRadius {
    static let s: CGFloat = 8
    static let m: CGFloat = 14
    static let l: CGFloat = 22
    static let pill: CGFloat = 999
}
EOF
cat > DesignSystem/Tokens/DSMotion.swift <<'EOF'
// DSMotion.swift
// Layer: DesignSystem
// Purpose: Motion tokens; every animation has a Reduce Motion variant (cross-fade only)

import SwiftUI

enum DSMotion {
    static let fast: Double = 0.15
    static let standard: Double = 0.28
    static let slow: Double = 0.45
    static let breath: Double = 2.6

    static let standardAnimation = Animation.easeInOut(duration: standard)
    static let slowAnimation = Animation.easeInOut(duration: slow)
    static let spring = Animation.spring(response: 0.35, dampingFraction: 0.82)
    static let breathAnimation = Animation.easeInOut(duration: breath).repeatForever(autoreverses: true)

    /// Picks the animation honouring the accessibility setting.
    static func animation(_ animation: Animation, reduceMotion: Bool) -> Animation {
        reduceMotion ? .easeInOut(duration: fast) : animation
    }
}
EOF
cat > DesignSystem/Modifiers/DSEyebrowStyle.swift <<'EOF'
// DSEyebrowStyle.swift
// Layer: DesignSystem
// Purpose: Small uppercase tracked label style used for section markers and HUD readouts

import SwiftUI

struct DSEyebrowStyle: ViewModifier {
    let tint: Color

    func body(content: Content) -> some View {
        content
            .font(DSFont.eyebrow)
            .textCase(.uppercase)
            .tracking(2)
            .foregroundStyle(tint)
    }
}

extension View {
    func dsEyebrowStyle(tint: Color = DSColor.textSecondary) -> some View {
        modifier(DSEyebrowStyle(tint: tint))
    }
}
EOF
cat > DesignSystem/Modifiers/DSGlow.swift <<'EOF'
// DSGlow.swift
// Layer: DesignSystem
// Purpose: Soft coloured glow used for the iris mark and validated states

import SwiftUI

struct DSGlow: ViewModifier {
    let color: Color
    let radius: CGFloat
    let opacity: Double

    func body(content: Content) -> some View {
        content
            .shadow(color: color.opacity(opacity), radius: radius)
            .shadow(color: color.opacity(opacity * 0.5), radius: radius * 2.2)
    }
}

extension View {
    func dsGlow(_ color: Color = DSColor.accent, radius: CGFloat = 12, opacity: Double = 0.55) -> some View {
        modifier(DSGlow(color: color, radius: radius, opacity: opacity))
    }
}
EOF
cat > DesignSystem/Components/DSBackground.swift <<'EOF'
// DSBackground.swift
// Layer: DesignSystem
// Purpose: The Iris atmosphere: deep ground, amber glow rising from the horizon, hairline horizon

import SwiftUI

struct DSBackground: View {
    enum Intensity {
        case calm
        case vivid
    }

    let intensity: Intensity

    init(intensity: Intensity = .calm) {
        self.intensity = intensity
    }

    var body: some View {
        ZStack {
            DSColor.backgroundPrimary
            RadialGradient(colors: [DSColor.accent.opacity(glowOpacity), DSColor.accent.opacity(0)],
                           center: UnitPoint(x: 0.5, y: 0.34), startRadius: 0, endRadius: 520)
            VStack(spacing: 0) {
                Spacer()
                Rectangle()
                    .fill(DSColor.sceneRing.opacity(0.06))
                    .frame(height: 1)
                Rectangle()
                    .fill(LinearGradient(colors: [DSColor.sceneFloorNear.opacity(0.6), DSColor.backgroundPrimary],
                                         startPoint: .top, endPoint: .bottom))
                    .frame(maxHeight: .infinity)
            }
            .frame(maxHeight: .infinity)
            .padding(.top, horizonOffset)
        }
        .ignoresSafeArea()
        .accessibilityHidden(true)
    }

    private var glowOpacity: Double {
        switch intensity {
        case .calm: 0.16
        case .vivid: 0.28
        }
    }

    private var horizonOffset: CGFloat {
        switch intensity {
        case .calm: 560
        case .vivid: 470
        }
    }
}

#Preview("Calm") {
    DSBackground()
}

#Preview("Vivid") {
    DSBackground(intensity: .vivid)
}
EOF
cat > DesignSystem/Components/DSScreen.swift <<'EOF'
// DSScreen.swift
// Layer: DesignSystem
// Purpose: Page container: atmosphere background, safe-area aware column, consistent gutters

import SwiftUI

struct DSScreen<Content: View>: View {
    private let intensity: DSBackground.Intensity
    private let scrolls: Bool
    @ViewBuilder private let content: Content

    init(intensity: DSBackground.Intensity = .calm, scrolls: Bool = true, @ViewBuilder content: () -> Content) {
        self.intensity = intensity
        self.scrolls = scrolls
        self.content = content()
    }

    var body: some View {
        ZStack {
            DSBackground(intensity: intensity)
            if scrolls {
                ScrollView(showsIndicators: false) {
                    column
                }
            } else {
                column
            }
        }
        .preferredColorScheme(.dark)
    }

    private var column: some View {
        VStack(alignment: .leading, spacing: DSSpacing.l) {
            content
        }
        .frame(maxWidth: 560, alignment: .leading)
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.horizontal, DSSpacing.gutter)
        .padding(.top, DSSpacing.xl)
        .padding(.bottom, DSSpacing.xxl)
    }
}

#Preview {
    DSScreen {
        Text("iris").font(DSFont.display).foregroundStyle(DSColor.textPrimary)
        Text("attention indirecte").dsEyebrowStyle()
    }
}
EOF
cat > DesignSystem/Components/DSButton.swift <<'EOF'
// DSButton.swift
// Layer: DesignSystem
// Purpose: Primary, secondary and ghost actions with press feedback, 52 pt minimum height

import SwiftUI

struct DSButton: View {
    enum Variant {
        case primary
        case secondary
        case ghost
    }

    private let title: String
    private let systemImage: String?
    private let variant: Variant
    private let action: () -> Void

    @Environment(\.isEnabled) private var isEnabled

    init(_ title: String, systemImage: String? = nil, variant: Variant = .primary, action: @escaping () -> Void) {
        self.title = title
        self.systemImage = systemImage
        self.variant = variant
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: DSSpacing.s) {
                if let systemImage {
                    Image(systemName: systemImage)
                        .accessibilityHidden(true)
                }
                Text(title)
            }
            .font(DSFont.headline)
            .frame(maxWidth: .infinity, minHeight: 52)
            .padding(.horizontal, DSSpacing.l)
            .foregroundStyle(foreground)
            .background(background, in: Capsule())
            .overlay(Capsule().strokeBorder(border, lineWidth: 1))
        }
        .buttonStyle(DSPressableButtonStyle())
        .opacity(isEnabled ? 1 : 0.4)
        .accessibilityLabel(title)
    }

    private var background: Color {
        switch variant {
        case .primary: DSColor.accent
        case .secondary: DSColor.backgroundElevated
        case .ghost: .clear
        }
    }

    private var foreground: Color {
        switch variant {
        case .primary: DSColor.textOnAccent
        case .secondary: DSColor.textPrimary
        case .ghost: DSColor.textSecondary
        }
    }

    private var border: Color {
        switch variant {
        case .primary: .clear
        case .secondary: DSColor.lineSubtle
        case .ghost: .clear
        }
    }
}

struct DSPressableButtonStyle: ButtonStyle {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed && !reduceMotion ? 0.97 : 1)
            .opacity(configuration.isPressed ? 0.85 : 1)
            .animation(DSMotion.animation(DSMotion.spring, reduceMotion: reduceMotion), value: configuration.isPressed)
    }
}

#Preview("Variants") {
    VStack(spacing: DSSpacing.m) {
        DSButton("Commencer", systemImage: "eye") {}
        DSButton("Reprendre", variant: .secondary) {}
        DSButton("Quitter", variant: .ghost) {}
        DSButton("Désactivé") {}.disabled(true)
    }
    .padding()
    .background(DSColor.backgroundPrimary)
}

#Preview("Accessibility size") {
    DSButton("Commencer", systemImage: "eye") {}
        .padding()
        .background(DSColor.backgroundPrimary)
        .dynamicTypeSize(.accessibility3)
}
EOF
cat > DesignSystem/Components/DSCard.swift <<'EOF'
// DSCard.swift
// Layer: DesignSystem
// Purpose: Elevated surface with hairline border for grouped content and overlays

import SwiftUI

struct DSCard<Content: View>: View {
    enum Style {
        case flat
        case elevated
        case glass
    }

    private let style: Style
    @ViewBuilder private let content: Content

    init(style: Style = .elevated, @ViewBuilder content: () -> Content) {
        self.style = style
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.m) {
            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(DSSpacing.l)
        .background(background, in: RoundedRectangle(cornerRadius: DSRadius.l, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: DSRadius.l, style: .continuous).strokeBorder(DSColor.lineSubtle, lineWidth: 1))
    }

    private var background: Color {
        switch style {
        case .flat: DSColor.backgroundSurface
        case .elevated: DSColor.backgroundElevated
        case .glass: DSColor.backgroundSurface.opacity(0.88)
        }
    }
}

#Preview {
    VStack(spacing: DSSpacing.m) {
        DSCard { Text("Carte élevée").foregroundStyle(DSColor.textPrimary) }
        DSCard(style: .flat) { Text("Carte plate").foregroundStyle(DSColor.textPrimary) }
    }
    .padding()
    .background(DSColor.backgroundPrimary)
}
EOF
cat > DesignSystem/Components/DSBadge.swift <<'EOF'
// DSBadge.swift
// Layer: DesignSystem
// Purpose: Small status pill (success, danger, info, neutral, accent)

import SwiftUI

struct DSBadge: View {
    enum Tone {
        case neutral
        case accent
        case success
        case danger
        case info
    }

    private let text: String
    private let tone: Tone

    init(_ text: String, tone: Tone = .neutral) {
        self.text = text
        self.tone = tone
    }

    var body: some View {
        Text(text)
            .font(DSFont.eyebrow)
            .textCase(.uppercase)
            .tracking(1.2)
            .foregroundStyle(foreground)
            .padding(.horizontal, DSSpacing.s + DSSpacing.xs)
            .padding(.vertical, DSSpacing.xs + DSSpacing.xxs)
            .background(foreground.opacity(0.14), in: Capsule())
    }

    private var foreground: Color {
        switch tone {
        case .neutral: DSColor.textSecondary
        case .accent: DSColor.accent
        case .success: DSColor.statusSuccess
        case .danger: DSColor.statusDanger
        case .info: DSColor.statusInfo
        }
    }
}

#Preview {
    HStack {
        DSBadge("neutre")
        DSBadge("ambre", tone: .accent)
        DSBadge("validé", tone: .success)
        DSBadge("perdu", tone: .danger)
        DSBadge("info", tone: .info)
    }
    .padding()
    .background(DSColor.backgroundPrimary)
}
EOF
cat > DesignSystem/Components/DSStatusRow.swift <<'EOF'
// DSStatusRow.swift
// Layer: DesignSystem
// Purpose: Icon, title, detail and a coloured state dot; used for capability and permission lists

import SwiftUI

struct DSStatusRow: View {
    enum State {
        case pending
        case ok
        case warning
        case error
    }

    private let systemImage: String
    private let title: String
    private let detail: String?
    private let state: State

    init(systemImage: String, title: String, detail: String? = nil, state: State) {
        self.systemImage = systemImage
        self.title = title
        self.detail = detail
        self.state = state
    }

    var body: some View {
        HStack(alignment: .top, spacing: DSSpacing.m) {
            Image(systemName: systemImage)
                .font(DSFont.headline)
                .foregroundStyle(DSColor.accent)
                .frame(width: DSSpacing.l)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: DSSpacing.xs) {
                Text(title)
                    .font(DSFont.body)
                    .foregroundStyle(DSColor.textPrimary)
                if let detail {
                    Text(detail)
                        .font(DSFont.footnote)
                        .foregroundStyle(DSColor.textSecondary)
                }
            }
            Spacer(minLength: DSSpacing.s)
            Circle()
                .fill(dotColor)
                .frame(width: DSSpacing.s + DSSpacing.xxs, height: DSSpacing.s + DSSpacing.xxs)
                .padding(.top, DSSpacing.xs + DSSpacing.xxs)
                .accessibilityHidden(true)
        }
        .accessibilityElement(children: .combine)
        .accessibilityValue(stateLabel)
    }

    private var dotColor: Color {
        switch state {
        case .pending: DSColor.textTertiary
        case .ok: DSColor.statusSuccess
        case .warning: DSColor.accent
        case .error: DSColor.statusDanger
        }
    }

    private var stateLabel: String {
        switch state {
        case .pending: "en attente"
        case .ok: "disponible"
        case .warning: "attention"
        case .error: "indisponible"
        }
    }
}

#Preview {
    VStack(spacing: DSSpacing.m) {
        DSStatusRow(systemImage: "faceid", title: "Caméra TrueDepth", detail: "Détection du regard", state: .ok)
        DSStatusRow(systemImage: "camera", title: "Accès caméra", detail: "Refusé dans Réglages", state: .error)
        DSStatusRow(systemImage: "speaker.wave.2", title: "Son", state: .pending)
    }
    .padding()
    .background(DSColor.backgroundPrimary)
}
EOF
cat > DesignSystem/Components/DSIrisMark.swift <<'EOF'
// DSIrisMark.swift
// Layer: DesignSystem
// Purpose: The Iris emblem: concentric amber rings around a dark pupil, optionally breathing

import SwiftUI

struct DSIrisMark: View {
    private let size: CGFloat
    private let isBreathing: Bool

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var breath = false

    init(size: CGFloat = 120, isBreathing: Bool = false) {
        self.size = size
        self.isBreathing = isBreathing
    }

    var body: some View {
        ZStack {
            Circle()
                .fill(RadialGradient(colors: [DSColor.accent.opacity(0.35), DSColor.accent.opacity(0)],
                                     center: .center, startRadius: size * 0.3, endRadius: size * 0.75))
                .frame(width: size * 1.5, height: size * 1.5)
            Circle()
                .strokeBorder(AngularGradient(colors: [DSColor.accentDeep, DSColor.accent, DSColor.accentDeep, DSColor.accent, DSColor.accentDeep],
                                              center: .center), lineWidth: size * 0.16)
                .frame(width: size, height: size)
            Circle()
                .strokeBorder(DSColor.accent.opacity(0.35), lineWidth: 1)
                .frame(width: size * 0.62, height: size * 0.62)
            Circle()
                .fill(DSColor.backgroundPrimary)
                .frame(width: size * 0.42, height: size * 0.42)
                .overlay(alignment: .topLeading) {
                    Circle()
                        .fill(DSColor.textPrimary.opacity(0.85))
                        .frame(width: size * 0.09, height: size * 0.09)
                        .offset(x: size * 0.1, y: size * 0.1)
                }
        }
        .scaleEffect(breath ? 1.04 : 1)
        .opacity(breath ? 1 : 0.92)
        .frame(width: size * 1.5, height: size * 1.5)
        .onAppear {
            guard isBreathing, !reduceMotion else { return }
            withAnimation(DSMotion.breathAnimation) { breath = true }
        }
        .accessibilityHidden(true)
    }
}

#Preview {
    VStack(spacing: DSSpacing.xl) {
        DSIrisMark(size: 140, isBreathing: true)
        DSIrisMark(size: 48)
    }
    .padding()
    .background(DSColor.backgroundPrimary)
}
EOF
cat > DesignSystem/Components/DSProgressRing.swift <<'EOF'
// DSProgressRing.swift
// Layer: DesignSystem
// Purpose: Circular progress used for journey completion and hold progress readouts

import SwiftUI

struct DSProgressRing: View {
    private let progress: Double
    private let tint: Color
    private let lineWidth: CGFloat
    private let label: String?

    init(progress: Double, tint: Color = DSColor.statusSuccess, lineWidth: CGFloat = 6, label: String? = nil) {
        self.progress = progress
        self.tint = tint
        self.lineWidth = lineWidth
        self.label = label
    }

    var body: some View {
        ZStack {
            Circle()
                .stroke(DSColor.lineSubtle, lineWidth: lineWidth)
            Circle()
                .trim(from: 0, to: min(max(progress, 0), 1))
                .stroke(tint, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(DSMotion.standardAnimation, value: progress)
            if let label {
                Text(label)
                    .font(DSFont.title2)
                    .foregroundStyle(DSColor.textPrimary)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(label ?? "progression")
        .accessibilityValue("\(Int((progress * 100).rounded())) pour cent")
    }
}

#Preview {
    DSProgressRing(progress: 0.7, label: "14 / 14")
        .frame(width: 140, height: 140)
        .padding()
        .background(DSColor.backgroundPrimary)
}
EOF
cat > DesignSystem/Components/DSOverlayPanel.swift <<'EOF'
// DSOverlayPanel.swift
// Layer: DesignSystem
// Purpose: Dimmed full-screen veil with a centred title, subtitle and actions (the reference engine's overlays)

import SwiftUI

struct DSOverlayPanel<Actions: View>: View {
    private let title: String
    private let subtitle: String?
    private let tint: Color
    private let dim: Double
    @ViewBuilder private let actions: Actions

    init(title: String, subtitle: String? = nil, tint: Color = DSColor.textPrimary, dim: Double = 0.88,
         @ViewBuilder actions: () -> Actions) {
        self.title = title
        self.subtitle = subtitle
        self.tint = tint
        self.dim = dim
        self.actions = actions()
    }

    var body: some View {
        ZStack {
            DSColor.backgroundSurface.opacity(dim)
                .ignoresSafeArea()
            VStack(spacing: DSSpacing.l) {
                VStack(spacing: DSSpacing.s) {
                    Text(title)
                        .font(DSFont.title)
                        .foregroundStyle(tint)
                        .multilineTextAlignment(.center)
                    if let subtitle {
                        Text(subtitle)
                            .font(DSFont.callout)
                            .foregroundStyle(DSColor.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                }
                actions
            }
            .frame(maxWidth: 420)
            .padding(.horizontal, DSSpacing.gutter)
        }
        .accessibilityAddTraits(.isModal)
    }
}

#Preview {
    DSOverlayPanel(title: "pause", subtitle: "touchez pour reprendre") {
        DSButton("Reprendre") {}
        DSButton("Quitter", variant: .ghost) {}
    }
    .background(DSColor.backgroundPrimary)
}
EOF
echo "design system written"; find DesignSystem -name "*.swift" | wc -l
~~~~

#### 2026-09-10 23:59:55 +0200 (21:59:55Z) · TOOL RESULT · Bash
`f88478cc` · `9f61ac0d` · ligne 352 · Write design system tokens, modifiers and components; add sphere shading colours

~~~~text
extra colorsets 7
design system written
      16
~~~~
