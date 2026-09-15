# Iris — index de reprise avant /clear (2026-09-15)

Ce fichier est un **index de reprise synthétique**. L'historique réel (texte d'origine des échanges, rapports, commandes, résultats) est dans `Docs/session-archives/2026-09-15-claude-code-session/` ; la sauvegarde brute complète est hors dépôt dans `/Volumes/Steve Pro BlackSSD/Dev/Iris-Safety-Backups/2026-09-15-pre-clear/`.

> Chemins : sur ce Mac, le disque est insensible à la casse et le dépôt range sa documentation dans `Docs/`. Les chemins `docs/session-archives/…` et `docs/session-handoffs/…` demandés désignent donc `Docs/session-archives/…` et `Docs/session-handoffs/…` (casse du dossier existant, pour ne pas créer deux dossiers dans Git).

## 1. Dépôt et références Git

- Projet : `/Volumes/Steve Pro BlackSSD/Dev/App Mobile/Iris`
- Remote : `origin` = `https://github.com/ProdX0x/iris-ios.git` — dépôt **privé** (vérifié par `gh repo view` le 2026-09-15).
- Branche de travail : `feature/iris-liquid-glass-2026`
- HEAD avant le checkpoint d'archive : `4e8283dd8820c2e67fcaef2be793d5f9f54ea1ee` (`test: protect liquid glass visual variants`). Le commit `docs: archive iris claude session before context clear` qui ajoute ce fichier vient juste après ; la vérité est `git log`, puis `origin/feature/iris-liquid-glass-2026`.
- `main` : `52f20b7` (`feat: complete Iris v2 refactor and Gaze Engine v2`), non modifiée depuis le 2026-09-12.
- Chaîne de branches qui mène à l'état actuel (du plus ancien au plus récent) : `main` / `feature/iris-v2` (`52f20b7`) → `feature/iris-full-expansion` (`4bdb0ae`) → `feature/iris-oculomotor-expansion` (`93326de`) → `fix/chapter-card-adaptive-layout` (`e29cae7`) → `prototype/x7-stabilisation-head-guidance` (`3abddb7`) → `fix/x7-head-only-circling` (`b1805a6`) → `feature/iris-liquid-glass-2026`.
- Tags existants (aucun à créer) : `iris-ch1-oculomotor-human-validated-v1`, `iris-expansion-human-validated-v1`, `baseline-expansion-v1`.
- Fichiers non suivis à laisser intacts, jamais committés : `SKILL.md`, `x7_silhouette_reference.png` (copies de sécurité dans la sauvegarde hors dépôt).
- Bundle Git complet vérifié : `/Volumes/Steve Pro BlackSSD/Dev/Iris-Safety-Backups/2026-09-15-pre-clear/git/iris-pre-clear-2026-09-15.bundle`.

## 2. État produit

- Jeu iOS natif SwiftUI (XcodeGen, `project.yml`), iOS 17.0 minimum, Swift 6, bundle `net.steve-s.iris`, équipe `G4U9RG5GL7`.
- Campagne : 12 chapitres, **82 niveaux** (I–VI historiques, VII–XII extension, finals oculomoteurs optionnels 1-6 et 2-6…12-7).
- Gaze Engine v2 (ARKit TrueDepth, calibration affine, `AxisMapping`, `GazeFilter`), physique `TargetPhysics`, progression et éclats, audio et haptique.
- Documentation technique : `README.md`, `Docs/architecture.md` (ADR jusqu'à ADR-23), `Docs/design-system.md`, `Docs/conventions.md`, rapports dans `Design/`.

## 3. Travail Liquid Glass réalisé (branche `feature/iris-liquid-glass-2026`)

| Phase | Commits | Résultat |
|---|---|---|
| Phase 1 — séparation des couleurs | `c3781f7`, `a4bff43` | `DSColor.Identity / Navigation / State` (interface) et `DSColor.Chapter` (monde du jeu), `GameFieldBackground` séparé de `DSBackground`, aucun changement visuel (126 captures avant/après identiques octet pour octet). |
| Phase 2 — socle Liquid Glass | `b740654`, `25135a3` | `DesignSystem/Glass` : `DSGlassRole`, `DSGlassRendering` (natif iOS 26, repli translucide iOS 17–25, opaque sous Réduire la transparence), `DSGlassSurface`, `.dsGlass(role)`, `DSGlassGroup`, `dsGlassID` ; galerie dans la cible de tests ; aucun écran migré. |
| Phase 2B — raffinement | `65bae13`, `4e8283d` | `DSGlassRecipe` par rôle ; galerie « Sélection Iris Liquid Glass » (panneaux current/airy/balanced, chrome current/clear/balanced, action current/neutral/spectral/glassProminent, rayons 22/16 pt) ; aucun écran migré, recettes de production inchangées. |

Revue humaine des captures Phase 2 (consignée dans l'archive) : clearControl validé ; regularPanel trop opaque ; chrome trop opaque et massif ; prominentAction (capsule bronze) rejeté ; grande taille de texte validée ; les rendus opaques sous Augmenter le contraste / Réduire la transparence sont normaux.

## 4. Décision humaine Liquid Glass à appliquer désormais

**Toute l'application Iris doit adopter le Liquid Glass NATIF d'Apple, tel qu'il est prévu par les API iOS 26. On ne fabrique plus une esthétique de verre Iris concurrente.**

Principes :

- utiliser les composants Apple natifs lorsqu'ils existent ;
- utiliser le matériau et les comportements Apple ;
- ne pas fabriquer de faux Liquid Glass ;
- ne pas multiplier les recettes visuelles custom ;
- ne pas mettre du verre décoratif partout ;
- utiliser Liquid Glass comme couche fonctionnelle UI.

Formule produit : **APPLE FOURNIT LE MATÉRIAU. IRIS FOURNIT L'IDENTITÉ ET LE CONTENU.**

Les variantes Phase 2B Current / Airy / Balanced / Spectral (et la recette `DSGlassRecipe` qui les porte) restent uniquement des **expériences historiques** ; elles ne constituent pas l'architecture finale.

## 5. Éléments produit gelés

- 82 niveaux et leurs données ; gameplay ; Gaze Engine ; physique ; calibration mathématique ; progression ; audio gameplay ; haptique ; couleurs propres aux chapitres et au jeu (`DSColor.Chapter`, palettes, renderer, `GameFieldBackground`).
- Protections automatiques en place : `HistoricalCampaignFingerprintTests`, `ExpansionCampaignFingerprintTests`, `GameContentFreezeTests` (G–J), `ColorRoleBoundaryTests` (A–F), `DSGlassTests` (A–K, dont K qui fige `Navigation/*.swift` jusqu'à la phase navigation), `VisualCaptureTests` (captures hors dépôt).
- **X·7** (niveau 10-7, « l'ancre ») : Option A implémentée (`9fa4d4e`, `b1805a6`, par 82). Ne pas modifier sa mécanique pendant la mission Liquid Glass. Aucune validation humaine définitive d'Option A n'est enregistrée à ce jour : ne pas la présenter comme validée.

## 6. Navigation produit décidée

- Destinations : **Seuil**, **Chapitres**, **Carnet**.
- Réglages : secondaires.
- Ne pas ajouter artificiellement de Profil, de Progression ni de quatrième destination permanente.
- Jeu et calibration : immersifs lorsque nécessaire.

## 7. iOS et accessibilité

- iOS 26 : expérience de référence. iOS 17–25 : repli sobre et centralisé.
- Respecter Réduire la transparence, Augmenter le contraste, Réduire les animations, Dynamic Type, VoiceOver.

## 8. Narration future (direction seulement, rien d'implémenté)

`NarrationService`, `VoiceProfile`, `NarrationCue` ; désactivable (OFF) ; audio local ; indépendante des effets, de l'ambiance et de l'haptique.

## 9. Derniers résultats vérifiés (Phase 2B, journaux hors dépôt)

- Suite complète sur l'état `4e8283d` : 443 tests dans 67 suites, **440 passés, 0 échec, 3 ignorés** (tests réservés aux captures) — `…/.iris-derived-data/logs/p2b_tests.log`. Premier commit `65bae13` seul : mêmes chiffres (`p2b_commit1_tests.log`).
- Écrans de production identiques à la référence d'avant Phase 1 : 126/126 (`p2b_run.txt`). Pages de galerie Phase 2 redessinées : 5/5 identiques.
- Builds : Debug simulateur, Release appareil signé, Debug appareil signé réussis ; galerie absente du binaire Release (`p2b_run.txt`, `p2b_release.log`, `p2b_device.log`).

## 10. Environnement et méthode

- Xcode 26.3 (17C529), SDK iOS 26.2, simulateur iOS 26.3.1 ; tests sur « iPhone 17 Pro », captures simulateur sur « iPhone 17 » ; iPhone 14 Pro (iOS 26.5.2) visible pour les builds signés.
- DerivedData hors dépôt : `/Volumes/Steve Pro BlackSSD/Dev/App Mobile/.iris-derived-data/<sim|release|device>` ; captures dans `…/.iris-derived-data/phase1|phase2|phase2b`.
- Mac à 17 Go de RAM avec swap sur un disque interne presque plein : un seul `xcodebuild` et un seul simulateur à la fois.
- Captures de galerie : `DSGlassGalleryCaptureTests` avec `TEST_RUNNER_IRIS_GLASS_CAPTURE_DIR` (+ `…_SET`) et un script qui prend `simctl io screenshot` ; écrans de production : `VisualCaptureTests` avec `TEST_RUNNER_IRIS_CAPTURE_DIR`.
- Aucun push sans demande explicite ; aucun tag de validation sans décision humaine.

## 11. Prochaine mission

Migration de toute l'interface de production Iris vers le **Liquid Glass natif Apple iOS 26**, sans modifier le gameplay. Commencer par relire ce fichier, vérifier la branche et son HEAD distant, puis l'archive si un détail est nécessaire.
