# Classification des connaissances

Trier ce qu'Iris a produit, pour savoir ce qui voyage et ce qui reste. La règle de tri : **une connaissance ne
devient réutilisable que si elle survit à la suppression de tous les noms propres.**

---

## A. IRIS-SPECIFIC — reste dans l'histoire d'Iris

Rien ici n'a de valeur hors du produit.

| Domaine | Contenu |
|---|---|
| Gameplay | l'attention indirecte, le regard qui repousse, poser les yeux à côté ; 12 chapitres, 82 niveaux |
| Gaze Engine | `GazeMapper`, `GazeFilter`, calibration affine 2D, calibration 9 points, rejet de clignement, vérification 5 points, `overshoot` |
| Physique | `TargetPhysics`, répulsion, attraction, `attentionZone`, `repulsionGain`, `maxSpeed`, friction |
| Campagne | `LevelDefinitions`, positions, `par`, règles de progression, X-7, III-7 |
| UX | Classique / Guidé / Visible ; l'apprentissage I-1 → I-3 ; le halo périphérique ; la phrase de calibration |
| Commerce | `net.steve_s.iris.unlock.fullgame`, `net.steve_s.iris.access.promopass`, `freeChapterCount = 3`, 2,99 € |
| Identité | `net.steve-s.iris`, équipe `G4U9RG5GL7` |
| Skill | `SKILL.md` — `iris-debug-observability`, entièrement lié au moteur de regard d'Iris |

**Ce qui en sort quand même**, une fois les noms retirés :

- une valeur de moteur déjà calculée (`isNear`, avec son hystérésis) vaut mieux qu'un seuil visuel réinventé
  dans la présentation — *ne jamais inventer un seuil quand le moteur en a déjà un* ;
- une saturation de l'indicateur là où le pipeline **cesse de mesurer** — *ne pas afficher une information que le
  système ne possède pas* ;
- un état déduit (`isCompleted("1-3")`) plutôt qu'un second drapeau — *ne pas multiplier les sources de vérité*.

---

## B. APPLE / iOS-SPECIFIC — voyage entre applications Apple

| Sujet | Ce qui a été appris |
|---|---|
| **Xcode schemes** | Le scheme est un **fichier** (`xcshareddata/xcschemes/*.xcscheme`), versionnable et hashable. Xcode en garde une copie **en mémoire** : l'éditer pendant qu'Xcode est ouvert ne garantit pas qu'il la relise. Le fermer avant d'éditer, si le résultat dépend du scheme |
| **StoreKit local** | Une `storeKitConfiguration` attachée à l'action *Run* change ce qu'un appareil physique voit. `appTransaction.environment` distingue `Xcode` / `Sandbox` / `Production` / indisponible. Un appareil contaminé n'est plus un témoin |
| **Installer hors Xcode** | `devicectl device install app` + `process launch` n'attache aucune configuration de scheme. C'est la méthode pour préserver un appareil témoin |
| **devicectl** | `copy from --domain-type appDataContainer` extrait un fichier du conteneur **sans rien modifier** : diagnostic non destructif de premier choix. `info files`, `info processes`, `info lockState` complètent. Un appareil verrouillé refuse un lancement (`FBSOpenApplicationErrorDomain error 7`) |
| **Runtimes de simulateur** | Une API peut être refusée par un runtime et fonctionner sur un autre : les 17 tests StoreKit se dégradaient en *known issues* sur iOS 26.3 et passaient réellement sur iOS 18.6. Garder un simulateur d'ancienne version comme instrument |
| **Signature** | `Apple Development` ≠ `Apple Distribution`. Un App ID générique `*` **ne peut pas** porter l'achat intégré. `get-task-allow=true` fait refuser un binaire par l'App Store. Vérifier sur le bundle construit (`codesign -dvvv`), pas dans les réglages |
| **PrivacyInfo.xcprivacy** | Vérifier sa présence **à la racine du bundle construit**, pas seulement dans le projet — surtout quand le projet est régénéré |
| **Projet généré** | Avec XcodeGen, `project.yml` est la vérité et tout réglage fait dans Xcode est écrasé. Une règle exécutable doit verrouiller l'identité (bundle, équipe) |
| **TrueDepth / ARKit** | `ARFaceTrackingConfiguration` donne transformations et blend shapes sans qu'aucune image n'ait à être conservée. `UIRequiredDeviceCapabilities` n'a pas de valeur pour « TrueDepth » : la dégradation gracieuse doit être codée |
| **Preuve d'absence dans un binaire** | `nm` et `strings` prouvent mal une absence : l'optimisation des petites chaînes de Swift (≤ 15 octets) les stocke en ligne. Un symbole à 0 occurrence est une preuve ; une chaîne courte introuvable n'en est pas une |
| **Xcode en AppleScript** | `debug` accepte une destination explicite (`platform=iOS,id=<UDID>`), ce qui permet un lancement ciblé sans dépendre de la sélection d'interface. Les enregistrements `.xcresult` nomment l'appareil réellement utilisé — une preuve, pas une intention. Xcode purge ses journaux : ne pas compter dessus pour un historique |

---

## C. REUSABLE ENGINEERING METHODOLOGY — indépendant du produit et, autant que possible, de la plateforme

Détaillé dans `AI_ASSISTED_ENGINEERING_METHOD.md`.

| Principe | Vérifié sur Iris ? |
|---|---|
| Mesurer avant de modifier | oui — chaque Gate ouvre sur une mesure |
| Nommer le niveau de preuve de chaque conclusion | oui — quatre niveaux réellement utilisés |
| Préférer une expérience réversible ; budget pour le destructif | oui — Gate 4A, cas central |
| Ne changer qu'une variable | oui — les deux tests de scheme ne diffèrent que par l'ordre |
| Prouver la restauration (hash **et** diff) | oui |
| Rapporter une ambiguïté comme ambiguë | oui — et c'est ce qui a débloqué le Gate 4A |
| Investigation différentielle sur deux systèmes | oui — Gate 1, deux appareils |
| Geler ce qui est validé, de façon exécutable | oui — table de SHA-256 |
| Rendre les règles exécutables plutôt qu'écrites | oui — `audit.py`, tests de frontière, tests de gel |
| Écrire les conditions de réouverture d'une décision | oui — Gate 2 §4 |
| Conserver les hypothèses rejetées | oui — trois discriminations échouées consignées |
| Vérifier l'ancestry avant de fusionner | oui — 18 branches sur 22 déjà dedans |
| Séparer état du projet et connaissance réutilisable | oui — ce dossier |
| Handoff autosuffisant + protocole de reprise | oui — deux handoffs |
| Ne pas supprimer ce qu'on n'a pas inventorié | oui — trois fichiers non suivis préservés du début à la fin |
| Modes LIGHT / STANDARD / DEEP | **partiellement** — Iris a surtout fonctionné en DEEP ; la graduation est une proposition, pas un acquis |
| Boucle de calibration empirique | **non** — proposée, jamais exécutée |

Les deux dernières lignes sont honnêtement marquées : elles sont raisonnables, pas démontrées.

---

## D. AI-ASSISTED DEVELOPMENT METHODOLOGY — propre au travail avec un agent

| Élément | Preuve |
|---|---|
| Mission bornée, objectif unique | toutes les missions Iris |
| Interdictions nommées et vérifiables | listes explicites, contrôlées par `git diff` en fin de mission |
| HEAD et branche attendus, arrêt en cas d'écart | pratiqué à chaque mission |
| STOP conditions écrites d'avance | Gate 4A s'est réellement arrêté au point prévu |
| Format de rapport imposé | force à répondre aux questions gênantes |
| Exiger une preuve d'outil plutôt qu'une mémoire | « interroge Git, ne te fie pas à la mémoire de la session » |
| Autorisation explicite avant toute action destructive | Gate 4A |
| Dérogation **bornée** à une interdiction | le mandat s'interdisait sa solution ; l'utilisateur a levé l'interdiction pour un test précis |
| Conserver les décisions négatives | Braises B, hypothèse rejetée, laissée hors de la lignée avec son commit de clôture |
| **Les erreurs de l'agent sont attrapées par des contrôles externes** | cinq erreurs réelles, zéro attrapée par la prudence de l'agent |
| Handoff avant réinitialisation du contexte | deux handoffs |
| Décisions réservées à l'humain | fermeture de Gate, choix entre hypothèses, validation perceptive, autorisation du destructif |

---

## E. ANDROID — à réévaluer, pas à transférer

Résumé ; détail dans `ANDROID_TRANSFER_MAP.md`.

| | |
|---|---|
| **Transférable** | la méthode (C et D), les règles de gameplay, la structure de campagne, les principes de test, le modèle de Gates |
| **À réévaluer** | précision et stabilité du regard, latence, calibration, accès caméra, performance, audio et haptique, permissions, cycle de vie |
| **Ne pas porter** | TrueDepth, StoreKit, schemes Xcode, App Store Connect, provisioning Apple, `PrivacyInfo.xcprivacy` |

---

## Taxonomie pour stocker la suite

Dix types, avec le minimum de champs utiles. Le but est de retrouver **pourquoi**, pas seulement **quoi**.

| Type | Champs minimaux |
|---|---|
| `DECISION` | question · options · retenue · raison · **niveau de preuve** · conditions de réouverture · date |
| `EVIDENCE` | mesure · commande · date · appareil ou environnement · niveau |
| `EXPERIMENT` | hypothèses concurrentes · variable · contrôles · résultat · **ce qu'il ne prouve pas** |
| `INCIDENT` | symptôme · chronologie · cause (avec niveau) · impact · statut |
| `VALIDATION` | ce qui a été jugé · par qui · **grain du verdict** · date · ce qui reste non validé |
| `NEGATIVE KNOWLEDGE` | ce qu'il ne faut pas conclure · le fait qui l'interdit |
| `OPEN QUESTION` | question · pourquoi elle n'est pas tranchée · ce qui la trancherait |
| `FROZEN AREA` | périmètre · date et raison du gel · ce qui rouvrirait · **le contrôle exécutable** |
| `PROCEDURE` | quand · étapes · contrôles · conditions d'arrêt |
| `LESSON LEARNED` | observation · leçon · **limites** · contre-exemple si connu |

Deux champs valent plus que les autres : **le niveau de preuve**, et **ce que la chose ne prouve pas**. Sans eux
la base devient un tas d'affirmations.

**Ce qu'il ne faut pas faire.** Une base d'outil, un formulaire obligatoire, un identifiant par entrée. Sur un
projet d'une personne, des documents Markdown versionnés à côté du code ont suffi — et un document versionné a
l'avantage de vieillir **visiblement**.
