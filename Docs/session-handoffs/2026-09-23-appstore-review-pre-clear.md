# Iris — reprise de session, 23 septembre 2026 (Build 1.0 (2) en revue App Store)

Ce document est autosuffisant : une session Claude qui le lit doit pouvoir reprendre le projet sans rien savoir
d'autre. Il remplace, pour tout ce qui concerne la release, le handoff du 17 septembre (`2026-09-17-gate4a-pre-clear.md`),
qui reste valable pour l'histoire des gates mais dont plusieurs états sont périmés — à commencer par la formulation
« caméra TrueDepth », remplacée dans le Build 2 par « suivi facial ARKit ».

Deux natures de faits cohabitent ici, et elles sont distinguées à chaque fois :

- **[vérifié]** — constaté dans Git, dans le code, dans le binaire ou dans une commande exécutée le 23 septembre 2026 ;
- **[rapporté]** — observé par le pilote dans App Store Connect, sur un appareil physique ou dans un courriel Apple,
  donc non vérifiable depuis une session Claude.

---

## 1. Ce qu'est Iris

Un **jeu iOS d'attention indirecte contrôlé par le regard** : le regard *repousse* les sphères, donc pour guider une
lueur jusqu'à son iris il faut poser les yeux **à côté**. Le regard est estimé par le **suivi facial ARKit avec la
caméra frontale** — jamais par « TrueDepth », formulation retirée du produit au Build 2 parce qu'elle était fausse
(l'iPhone SE, sans TrueDepth, joue parfaitement).

Douze chapitres, 82 niveaux. Chapitres I à III gratuits pour toujours (19 niveaux) ; IV à XII par **un achat unique**.

**Iris est un jeu.** Aucune promesse de santé, de rééducation ou de bénéfice cognitif, ni dans l'app, ni dans les
métadonnées. Un test automatique relit chaque `.md` de `Docs/AppStore/` contre 22 sous-chaînes interdites.

---

## 2. Où en est la release

- **Version commerciale 1.0, build 2.** Nom App Store : Iris Ways. Bundle `net.steve-s.iris`, équipe `G4U9RG5GL7`.
- **[vérifié]** L'archive livrée est `~/Library/Developer/Xcode/Archives/2026-09-22/Iris 22-09-2026, 23.13.xcarchive` :
  `CFBundleShortVersionString` 1.0, `CFBundleVersion` 2, arm64, signée Apple Distribution, `get-task-allow` à false.
  Ses chaînes compilées FR/EN ne contiennent plus aucune occurrence de TrueDepth ni de Face ID.
- **[rapporté]** Le Build 2 a été validé et téléversé vers App Store Connect le 22 septembre.
- **[rapporté]** La revue a d'abord été arrêtée par un contrôle automatisé d'App Review : **lien des Conditions
  d'utilisation (EULA) absent des métadonnées App Store**. Ce n'était pas un défaut du binaire.
- **[vérifié]** L'audit du binaire confirme que l'app elle-même contient bien les deux liens légaux, atteignables en
  deux gestes depuis l'accueil : Réglages → « À propos & informations légales » → « Politique de confidentialité »
  (`https://www.steve-s.net/iris/privacy-iris/`) et « Conditions d'utilisation »
  (`https://www.apple.com/legal/internet-services/itunes/dev/stdeula/`). Définis dans
  `Features/About/AboutCopy.swift:31` et `:36`, ouverts par `Features/About/AboutView.swift:90`, accessibles sans
  achat et sur un appareil sans suivi facial. **Aucun Build 3 n'est requis pour ce motif.**
- **[rapporté]** Correction faite côté métadonnées : le lien vers l'EULA standard d'Apple a été ajouté à la
  description App Store, et une réponse a été envoyée à App Review.
- **[rapporté]** La resoumission est actuellement **bloquée par une erreur technique d'App Store Connect**
  (« unexpected error »). Une demande de support Apple a été préparée ; **son envoi effectif n'est pas vérifiable
  depuis cette session** — à reconfirmer au moment de la reprise.
- **[rapporté]** **TestFlight externe : le Build 1.0 (2) est en attente de Beta App Review. Ne pas le retirer.**

### À faire côté Apple, encore ouvert

1. Débloquer la resoumission (support Apple) puis resoumettre **le Build 2 existant**, sans nouveau binaire.
2. Images des achats intégrés, 1024 × 1024, pour « Iris Full Game » et « Iris Promotional Access » : toujours
   absentes, d'où les vignettes grises dans la feuille de paiement et la feuille de code.
3. Notes App Review : reprendre le paragraphe compatibilité/confidentialité en formulation ARKit.
4. Métadonnées et mots-clés : retirer les mentions TrueDepth restantes (`Docs/AppStore/APP_STORE_METADATA_*.md`,
   `APP_REVIEW_NOTES_*.md`, `PRIVACY_RELEASE_NOTES.md`), qui ne sont pas encore alignées sur le Build 2.
5. Test d'acquisition sur compte propre (voir §5).

---

## 3. Git — l'état exact, vérifié le 23 septembre

```
commit de référence  d948ff848b85b66af1afc50d64ca28e83ccb3eb4   « chore: update Iris app icon »
parent               bbe387a553e797e73c6f1a9d7a82a8481418c80f   « fix: harden unsupported-device gaze flow »
```

**[vérifié]** Trois références convergent désormais sur ce même commit, local et serveur :

| Référence | SHA |
|---|---|
| `main` (local et `origin/main`) | `d948ff848b85b66af1afc50d64ca28e83ccb3eb4` |
| `release/iris-appstore-rc1` (local et distant) | `d948ff848b85b66af1afc50d64ca28e83ccb3eb4` |
| tag annoté `iris-1.0-build2^{}` (local et distant) | `d948ff848b85b66af1afc50d64ca28e83ccb3eb4` |

- **`main` a été avancée par fast-forward pur** (`52f20b7` → `d948ff8`), sans merge commit, sans rebase, sans squash,
  sans amend, sans force-push. Le HEAD n'a qu'un seul parent.
- **Aucun commit référencé uniquement en local** : 0 commit atteignable depuis une branche ou un tag local qui ne le
  soit pas depuis une référence d'`origin`. Les 73 commits qui n'existaient que sur ce disque ont été poussés le
  23 septembre, avec 7 branches d'étape (`audit/*`, `feature/iris-gaze-assistance-*`, `feature/iris-monetization-release`,
  `feature/iris-liquid-glass-2026`).
- **Aucun commit non référencé (« unreachable ») contenant du travail perdu** : `git fsck --unreachable --no-reflogs`
  ne renvoie que 5 blobs, tous identifiés (icône RGBA avant conversion, `Contents.json` reformaté par Xcode, une image
  d'itération, une note de session, le blob vide). Aucun commit, aucun arbre.
- **Branche courante : `main`.** Le contenu du disque est identique à celui de la branche release, puisque les deux
  pointent sur `d948ff8`.
- Dépôt distant : `ProdX0x/iris-ios` (privé). Les 5 tags locaux existent tous à l'identique sur GitHub.

### Fichiers non suivis — à conserver, ne jamais stager ni supprimer

```
JetsamEvent-2026-09-16-045447.ips   179 874 o
SKILL.md                             18 763 o   ← skill « iris-debug-observability », n'existe nulle part ailleurs
x7_silhouette_reference.png       1 284 587 o
```

### Règle de branches pour la suite — importante

**Ne pas travailler sur `main` ni sur `release/iris-appstore-rc1`.** Ces deux branches marquent le binaire soumis à
Apple. La refonte design et tout ce qui vise la 1.1 doivent partir d'une **nouvelle branche créée depuis `main` à
`d948ff8`**, par exemple :

```bash
git checkout -b feature/<nom-explicite> d948ff848b85b66af1afc50d64ca28e83ccb3eb4
```

---

## 4. Ce que le Build 2 a corrigé par rapport au Build 1

Deux commits de contenu, plus l'icône :

1. **`bbe387a` « fix: harden unsupported-device gaze flow »** — 18 fichiers.
   - **Le blocage confirmé physiquement sur l'iPad Pro 10,5** : Réglages → « Recalibrer le regard » → « regard
     indisponible » → « Réessayer » laissait l'écran figé sur « démarrage du suivi du regard… » sans issue.
     Deux causes : `AppCoordinator.recalibrate()` n'avait pas la garde `supportsFaceTracking` de `proceedToLevel()`,
     et le service ARKit réaffectait la même valeur `.unavailable`, avalée par la déduplication du `didSet`.
   - Correctifs, dans trois fichiers gelés autorisés par le pilote : garde dans `AppCoordinator.recalibrate()`
     (`Navigation/AppCoordinator.swift:211-214`), lecture de l'état terminal après `gaze.start()`
     (`Features/GazeSetup/ViewModels/GazeSetupViewModel.swift:156-161`, **la déduplication globale est conservée**),
     et titre du diagnostic « Caméra TrueDepth » → « Suivi facial » (`AR/Calibration/GazeReadinessReport.swift:28`).
   - **Textes TrueDepth faux, remplacés** : `NSCameraUsageDescription` FR/EN, `camera.trueDepth.title`,
     `gazeReadiness.check.faceTracking.title`, `camera.unsupported.message`, `unavailable.detail`,
     `unavailable.devices.label`, `unavailable.devices.detail`.
   - 4 tests de régression ajoutés (première entrée, « Réessayer », retour d'arrière-plan, coordinateur) et
     3 empreintes gelées mises à jour.
2. **`d948ff8` « chore: update Iris app icon »** — l'icône seule. Elle était arrivée en RGBA (canal alpha uniformément
   opaque) ; elle a été réencodée en RGB avec **preuve que le raster RGB décodé est identique avant et après**
   (SHA-256 `6c66cc09…`), 1024 × 1024, `hasAlpha: no`.

---

## 5. Appareils et tests physiques

| Appareil | Identifiant | OS | État |
|---|---|---|---|
| iPhone 14 Pro | iPhone15,2 | 26.5.2 | **[rapporté]** calibration et gameplay PASS |
| iPhone 15 Pro | iPhone16,1 | 27.0 | **[rapporté]** calibration et gameplay PASS ; code promo sandbox échangé |
| iPhone SE (probablement iPhone12,8) | — | 26.6.1 | **[rapporté]** joue sans TrueDepth : la preuve que l'ancienne formulation était fausse |
| iPad Pro 10,5" | iPad7,3 (A10X) | iPadOS 17.7.11 | **[rapporté]** installable en mode compatibilité iPhone, suivi facial indisponible : **comportement « non pris en charge » PASS** |
| iPad mini 2 | — | iPadOS 12.5.8 | non compatible (iOS 17 minimum) — ne pas retester |

**[rapporté]** TestFlight physique fonctionnel sur les iPhone.

**Reste ouvert — test sur compte propre** : sur l'iPad non pris en charge, vérifier physiquement qu'aucune acquisition
neuve n'est possible (ni achat Full Game, ni échange de code), la restauration restant disponible. Le compte utilisé
jusqu'ici détient déjà l'accès promotionnel, ce qui masque le mode « restauration seule ». Protocole recommandé :
compte Sandbox neuf ou historique effacé, connecté via Réglages → Développeur, après déconnexion du compte de
Contenu multimédia et achats ; repli : attendre l'expiration de la promo.

---

## 6. StoreKit, promo et Product IDs — à ne pas « corriger »

- Bundle ID **`net.steve-s.iris`** (tiret) ; Product IDs **`net.steve_s.iris.unlock.fullgame`** et
  **`net.steve_s.iris.access.promopass`** (tiret bas). **La différence est voulue** : le formulaire App Store Connect
  a refusé le tiret dans un identifiant de produit.
- Full Game : non consommable, 2,99 €, **seul achat direct de l'app**. Le prix vient de l'App Store ; Iris n'en écrit
  jamais aucun.
- Promotional Access : abonnement hebdomadaire 0,99 € qui **n'est jamais vendu dans Iris** — il ne sert que de
  véhicule à l'offre « Iris 3-Day Promotional Access » (3 jours gratuits, sans renouvellement à la fin).
  « Utiliser un code d'accès » ouvre la feuille native d'Apple ; Iris ne lit, ne stocke ni ne valide aucun code.
  Le code personnalisé IRIS3D ne pourra être créé qu'après approbation de l'abonnement.
- Sur un appareil sans suivi facial : aucune acquisition neuve possible (garde `allowsNewAcquisitions`,
  commit `ece5e71`), droits existants reconnus, restauration toujours disponible.

---

## 7. Confidentialité — état établi par audit de code

Aucune image de caméra, aucune donnée de visage ni de regard n'est enregistrée ou transmise : 0 usage de
`capturedImage`, de données de profondeur, de capture photo ou vidéo, 0 API réseau, 0 SDK tiers, 0 outil d'analyse.
Persistés localement : profil de calibration, progression, préférences, indicateur d'introduction vue.
Manifeste de confidentialité embarqué : aucun suivi, aucune donnée collectée.

---

## 8. Le site steve-s.net — support et confidentialité

- Dépôt **`ProdX0x/prodx0x-wonderland`**, branche `main`, GitHub Pages (CNAME `steve-s.net`).
  Clone local : `/Volumes/Steve Pro BlackSSD/Dev/ProdX0x-Wonderland-3D/prodx0x-wonderland-prototype`.
- Quatre pages, chacune un fichier HTML autonome avec son CSS en ligne :
  `iris/index.html`, `en/iris/index.html`, `iris/privacy-iris/index.html`, `en/iris/privacy-iris/index.html`.
- **[vérifié]** Commit **`93a2d8b9a59515bb4237973997167e87ad512e1e`** poussé le 23 septembre : les deux pages
  **françaises** ont été alignées sur les faits du Build 2 (ARKit et non TrueDepth, achat unique propre au Full Game,
  section accès promotionnel, section appareils non pris en charge, pont entre stockage local et déclaration
  « aucune donnée collectée ») et **le lien EULA d'Apple a été ajouté** en section et en pied de page.
  Les deux pages **anglaises** étaient déjà conformes : laissées octet pour octet.
- L'attention à garder : **chaque build depuis l'IDE Xcode resalit les deux catalogues de chaînes du dépôt iOS**
  (voir §10) ; c'est sans rapport avec le site, mais c'est le piège récurrent avant un commit.

---

## 9. Systèmes gelés et invariants de travail

- **134 fichiers gelés** par empreinte SHA-256, réparties dans quatre suites (`GameContentFreezeTests` 71,
  `HistoricalCampaignFingerprintTests` 37, `OculoAncreTests` 20, `DSGlassTests` 6). Contrôle rapide sans compilation :
  script `frozen_check.py` (recréable en dix lignes : lire les paires `"chemin": "sha"` des quatre fichiers de test,
  comparer au SHA-256 réel). **Toute modification d'un fichier gelé exige l'autorisation explicite du pilote, et la
  revue humaine du diff exact — une empreinte qui passe ne vaut pas validation.**
- **Jamais `git add .` ni `git add -A`** : chaque fichier est nommé.
- **Jamais `xcodegen`** sans autorisation : `project.yml` est la source de vérité, le pbxproj est édité à la main
  quand il faut (2 lignes pour le numéro de build).
- Les commits du dépôt iOS finissent par le trailer `Co-Authored-By: Claude Opus 5 (1M context) <noreply@anthropic.com>`.
- **Après tout build depuis l'IDE Xcode**, vérifier `git status` : Xcode réécrit `Resources/InfoPlist.xcstrings` et
  `Resources/Localizable.xcstrings` en y ajoutant des clés extraites automatiquement (`CFBundleDisplayName`,
  `%@`, `diagnostics (debug)`…). Ce bruit ne doit jamais être commité ; il se restaure par
  `git restore --source=<commit> --worktree -- Resources/InfoPlist.xcstrings Resources/Localizable.xcstrings`.
- Ne pas perturber le simulateur `TidyBuddy-Foundation-iOS18` : il appartient à un autre projet.

---

## 10. Construire et tester

```bash
# Destination de référence, suite complète (simulateur Iris-69, iOS 26.3)
xcodebuild -project Iris.xcodeproj -scheme Iris \
  -destination 'platform=iOS Simulator,id=ED9684A0-BF2E-4277-8554-E07ABDA95BAF' \
  -derivedDataPath "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/.iris-derived-data/sim" \
  build-for-testing
xcodebuild ... -testLanguage fr -testRegion FR test-without-building
# Référence au 23 septembre : 682 tests, 89 suites, 0 échec, 20 problèmes connus (StoreKit), 5 ignorés (captures)

# Tests StoreKit RÉELS — seulement sur un runtime iOS 18.x (iOS 26 refuse les sessions de test locales)
xcodebuild ... -destination 'platform=iOS Simulator,id=AEF94BBD-D8D0-4A39-82EA-6C3B6504E5B5' \
  -only-testing:IrisTests/StoreKitEntitlementTests -only-testing:IrisTests/CommerceBoundaryTests \
  -only-testing:IrisTests/AccessPolicyTests -only-testing:IrisTests/AccessGatingTests test
# Référence : 60 tests, 4 suites, 0 échec, 0 problème connu

# Build Release local signé (pas une archive)
xcodebuild -project Iris.xcodeproj -scheme Iris -configuration Release \
  -destination 'generic/platform=iOS' -derivedDataPath "…/.iris-derived-data/build2-release-signed" clean build
```

Le disque interne du Mac est presque plein : **toujours** sortir le DerivedData sur le SSD externe. Une seule
commande `xcodebuild` à la fois, un seul simulateur allumé.

---

## 11. Audit disque du 23 septembre — avant nettoyage

Disque interne : 228 Go, **19 Go libres**. SSD externe : 876 Go libres. Environ **64 Go récupérables en sécurité**,
dont ~49,6 Go sur le disque interne.

**SAFE_TO_DELETE** — iOS DeviceSupport (27 Go, se régénère à la connexion des appareils) ; runtime simulateur
**iOS 18.4** (11,7 Go, aucun simulateur ne l'utilise — à retirer par Xcode → Réglages → Platforms) ; simulateurs
`Iris-4I-review` et `Iris-4H-review` (6 Go) ; tvOS DeviceSupport (3 Go) ; DerivedData interne (1,2 Go) ;
`UserData/Previews` (656 Mo) ; sur le SSD, les anciens `.iris-derived-data` (~9 Go) et le `.iris-derived-data` caché
dans `Iris Version/` (5,3 Go).

**KEEP** — runtimes iOS 26.3 et 18.6 avec leurs simulateurs `Iris-69` et `Iris-SK-18` ; les deux archives Iris du
22 septembre (Build 1 et **Build 2 avec ses dSYM**) ; le dépôt et son `.git` ; `Dev/Iris-Safety-Backups/` ; Xcode.

**NEEDS_REVIEW** — archives GramGramTV 1.1 (4) et (5) (450 Mo, autre app) ; simulateur TidyBuddy (2,3 Go) ;
`UserData/CodingAssistant` (258 Mo) ; `.iris-en8/` (280 Mo) ; `.iris-gate-iap/` (36 Mo) ; les zip de `Iris Version/`.

### Exclusions absolues du nettoyage

- **`~/.claude/` en entier**, et d'abord
  `~/.claude/projects/-Volumes-Steve-Pro-BlackSSD-Dev-App-Mobile-Iris/memory/` (mémoire longue du projet),
  `~/.claude/skills/`, `~/.claude/plugins/`, `~/.claude/settings.json`.
  Les transcripts `*.jsonl` du même dossier (249 Mo) sont supprimables techniquement, mais c'est l'historique complet
  des mandats : à traiter comme une décision, pas comme du cache.
- **Le dépôt Iris en entier, `.git` compris.**
- **`SKILL.md`** à la racine du dépôt : non versionné, unique.
- **Les archives Build 1 et Build 2** du 22 septembre.
- **`Dev/Iris-Safety-Backups/`.**

---

## 12. Où lire la suite

- `README.md` — carnet technique autoritaire du projet.
- `Docs/AppStore/` — métadonnées, notes App Review, checklist, produits StoreKit (**pas encore réalignés sur ARKit**).
- `Docs/session-handoffs/2026-09-17-gate4a-pre-clear.md` — histoire des gates, appareils, décisions UX.
- `Docs/methodology/` — méthode de travail, architecture des skills, classification des connaissances.
- `Tools/AgentSkills/Engineering-Agent-Skill/` — la bibliothèque de méthode, versionnée.

---

# NEXT SESSION — FIRST ACTION

1. **Lire ce fichier en entier**, puis `git log --oneline -5` et `git status --short`.
2. Vérifier que rien n'a bougé :
   `git rev-parse main release/iris-appstore-rc1 'iris-1.0-build2^{}'` doit donner trois fois
   `d948ff848b85b66af1afc50d64ca28e83ccb3eb4`, et `git status` ne doit montrer que les 3 fichiers non suivis.
3. Si les deux catalogues `Resources/*.xcstrings` apparaissent modifiés : c'est le bruit de l'IDE Xcode, à restaurer,
   jamais à commiter.
4. **Demander au pilote l'état réel côté Apple** : la resoumission est-elle débloquée ? le support a-t-il répondu ?
   le Build 2 est-il passé en Beta App Review externe ? Ne rien supposer.
5. **Ne rien développer sans mandat explicite.** Aucune initiative de refonte, aucun nettoyage disque, aucun commit,
   aucun push, aucune action App Store Connect sans autorisation.
6. Pour tout nouveau travail produit : créer une branche depuis `main` à `d948ff8` — ne jamais travailler directement
   sur `main` ni sur `release/iris-appstore-rc1`.

## Action suivante recommandée, quand le pilote la demandera

Débloquer la resoumission du Build 2 (support Apple), puis fournir les deux images d'achat intégré 1024 × 1024 et
réaligner `Docs/AppStore/` sur la formulation ARKit. Aucun de ces trois points n'exige un nouveau binaire.
