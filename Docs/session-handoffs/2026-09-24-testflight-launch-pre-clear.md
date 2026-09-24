# Iris — continuité, 24 septembre 2026 (bêta TestFlight lancée)

Court addendum au handoff du 23 septembre
([`2026-09-23-appstore-review-pre-clear.md`](2026-09-23-appstore-review-pre-clear.md)), qui reste valable pour tout
le reste : état du binaire, invariants, systèmes gelés, exclusions de nettoyage, règle de branches.

Comme dans le précédent : **[vérifié]** = constaté dans Git ou dans une commande ; **[rapporté]** = observé par le
pilote hors session.

## 1. Git et page d'accueil du dépôt

**[vérifié]**

| Référence | SHA |
|---|---|
| `main` local et `origin/main` | `4ac625b61d4b30c72b88d0feb269de4adef0d655` |
| `release/iris-appstore-rc1` (local et distant) | `d948ff848b85b66af1afc50d64ca28e83ccb3eb4` — **figée sur le Build 2** |
| tag `iris-1.0-build2^{}` (local et distant) | `d948ff848b85b66af1afc50d64ca28e83ccb3eb4` — **figé sur le Build 2** |

Le commit `4ac625b` « docs: redesign Iris project landing page » ne contient que de la documentation :

- **`README.md` est désormais une page d'accueil produit** : accroche, bandeau de trois captures, gameplay, les douze
  chapitres, le regard, la confidentialité, la technologie, l'état du projet, la navigation documentaire ;
- **l'ancien README intégral est conservé, inchangé, dans `Docs/PROJECT_LOG.md`** (756 lignes) ;
- **six captures** issues de l'app réelle vivent dans `Docs/media/` (900 × 1955).

Arbre suivi propre ; seuls les trois fichiers non suivis historiques subsistent
(`JetsamEvent-2026-09-16-045447.ips`, `SKILL.md`, `x7_silhouette_reference.png`).

## 2. TestFlight — état nouveau

**[rapporté]**

- La **bêta TestFlight externe a été acceptée par Apple** et **lancée** auprès de testeurs externes.
- **19 personnes testent Iris** actuellement.
- **Beta App Review n'est plus « en attente »** : ne pas reprendre cette formulation.

## 3. App Store — à ne pas confondre

**[rapporté]** La version destinée à l'App Store **n'est pas encore validée**. L'acceptation TestFlight ne vaut pas
acceptation App Store ; les deux états sont distincts et doivent le rester dans toute formulation.

## 4. Retour des testeurs — problème produit prioritaire

**[rapporté]** Plusieurs testeurs indépendants disent **ne pas comprendre suffisamment comment jouer**. C'est
désormais le sujet prioritaire du produit.

Hypothèses **à vérifier dans le code**, à ne pas traiter comme des conclusions avant audit :

- le tutoriel et l'onboarding seraient trop techniques ;
- les explications sur la caméra, l'acquisition et la fréquence d'image sont probablement inutiles pour apprendre à
  jouer ;
- le principe fondateur — **le regard repousse la lueur, il faut regarder à côté pour la guider** — n'est peut-être
  pas appris par l'expérience, seulement énoncé.

## 5. Prochaine mission, après le `/clear`

**Audit en lecture seule** du parcours de découverte :

premier lancement → onboarding → tutoriel → calibration → « Comment jouer » → aides des niveaux 1 à 3.

Objectif : **reconstituer exactement ce qu'un nouveau joueur voit et comprend, dans l'ordre**, puis nommer les points
de rupture de compréhension.

**Pendant cet audit : aucune modification du gameplay, de la physique, du moteur du regard ni de la calibration.**
Aucune proposition de correction n'est mise en œuvre sans un mandat explicite qui suivra l'audit.
