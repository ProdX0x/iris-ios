# Architecture de Skills — proposition

**Rien n'est installé ni activé par ce document.** C'est une proposition à évaluer plus tard.

---

## 1. Le risque à écarter d'abord : le mega-skill

La tentation est de verser toute la méthode d'Iris dans un seul gros skill. Les problèmes sont concrets :

| Problème | Ce qu'il donne |
|---|---|
| Surcharge de contexte | des milliers de mots chargés pour une correction d'une ligne |
| Règles contradictoires | « aller vite » et « tout auditer » dans le même fichier, sans ordre de résolution |
| Instructions non pertinentes | des règles StoreKit qui s'appliquent à un projet sans achat intégré |
| Over-engineering | le mode DEEP devient le seul mode, parce que c'est le seul écrit |
| Rigidité | l'agent applique la lettre là où le projet demande autre chose |
| Confusion plateforme / méthode | « fermer Xcode avant d'éditer le scheme » n'est pas un principe d'ingénierie |
| Maintenance | une règle invalidée oblige à relire l'ensemble |

**La séparation qui compte** est celle que ce dossier applique déjà : **méthode** (indépendante de la plateforme),
**plateforme** (Apple, Android), **étude de cas** (Iris). Un skill ne doit jamais mélanger les trois.

---

## 2. Structure proposée

```
AI-Engineering-Skills/
├── methodology/
│   ├── evidence-levels/            ← le socle : niveaux de preuve
│   ├── reversible-experimentation/ ← expérience réversible + budget destructif
│   ├── release-gates/              ← Gates et modes LIGHT/STANDARD/DEEP
│   ├── frozen-subsystems/          ← gel exécutable
│   ├── git-safety/                 ← branches, hashes, restauration prouvée
│   ├── session-handoff/            ← handoff + protocole de reprise
│   └── human-validation/           ← preuve humaine vs automatisée
├── apple/
│   ├── xcode-scheme-hygiene/
│   ├── storekit-device-validation/
│   ├── physical-device-validation/
│   └── app-store-release-readiness/
├── android/                        ← vide aujourd'hui : rien n'est démontré
└── case-studies/
    └── iris/                       ← ce dossier, déplacé ou référencé
```

**Un écart assumé avec l'esquisse initiale.** `ios-project-foundation`, `swift-architecture`, `feature-builder`
et compagnie ne figurent pas ici : **ils existent déjà** dans `ios-app-skills.zip` (19 skills). Les recréer serait
dupliquer. Voir §4.

---

## 3. Noyau minimal

Si un seul skill devait exister : **`evidence-levels`**. C'est celui dont tous les autres dépendent, et celui qui
traite le risque le plus spécifique à l'IA — une prose fluide qui transforme une corrélation en cause.

Si trois : **`evidence-levels` + `reversible-experimentation` + `session-handoff`**. Preuve, sécurité de
l'expérimentation, continuité.

Au-delà de sept skills méthodologiques, la valeur marginale devient douteuse. **Ne pas en fabriquer trente.**

---

## 4. Fiches candidates

### `evidence-levels`

| | |
|---|---|
| **PURPOSE** | Attacher un niveau de preuve à chaque conclusion et empêcher qu'une corrélation devienne une cause |
| **WHEN TO USE** | Tout rapport d'investigation, d'audit ou de mesure sur lequel quelqu'un décidera |
| **WHEN NOT TO USE** | Changement trivial et réversible ; la cérémonie coûterait plus qu'elle ne rapporte |
| **INPUTS** | observations, commandes exécutées, sorties d'outils |
| **OUTPUTS** | conclusions portant `MEASURED` / `PROVEN` / `STRONGLY SUPPORTED` / `NOT PROVEN` / `NOT DETERMINED` |
| **MANDATORY CHECKS** | toute cause est-elle assortie d'un niveau ? les hypothèses concurrentes sont-elles nommées ? ce que la preuve **ne** couvre **pas** est-il écrit ? |
| **STOP CONDITIONS** | plusieurs hypothèses restent compatibles et rien ne les discrimine → rapporter l'ambiguïté, ne pas choisir |
| **EVIDENCE REQUIRED** | la commande et sa sortie, pas une paraphrase |
| **COMMON FAILURE MODES** | glisser de « n'est plus nécessaire » à « est fausse » ; confondre `NOT PROVEN` et `NOT DETERMINED` ; multiplier les niveaux |
| **RELATION** | socle de tous les autres |

### `reversible-experimentation`

| | |
|---|---|
| **PURPOSE** | Discriminer des hypothèses sans détruire ce qui permettrait encore de les tester |
| **WHEN TO USE** | Dès qu'une correction envisagée est irréversible ou détruit des données |
| **WHEN NOT TO USE** | Incident de production où l'attente coûte plus que l'erreur |
| **INPUTS** | état initial mesuré, hypothèses concurrentes, inventaire de ce qui serait détruit |
| **OUTPUTS** | une observation discriminante, un état restauré et **prouvé** restauré |
| **MANDATORY CHECKS** | sauvegarde vérifiée (hash) ; une seule variable ; restauration prouvée par hash **et** diff ; destination explicite quand plusieurs cibles existent |
| **STOP CONDITIONS** | état initial non établissable · sauvegarde non vérifiable · restauration non prouvable · l'expérience exige de franchir une interdiction · résultat ambigu |
| **EVIDENCE REQUIRED** | mesure avant, mesure après, hashes avant/pendant/après |
| **COMMON FAILURE MODES** | conclure d'une expérience contaminée ; détruire parce que c'est plus simple ; « restaurer » sans vérifier |
| **RELATION** | consomme `evidence-levels` ; alimente `release-gates` |

### `frozen-subsystems`

| | |
|---|---|
| **PURPOSE** | Protéger un sous-système validé de l'amélioration opportuniste |
| **WHEN TO USE** | Après une validation coûteuse, sur du code sans défaut connu |
| **WHEN NOT TO USE** | Code encore en construction ; geler avant validation fige des erreurs |
| **INPUTS** | liste de fichiers, date et raison du gel |
| **OUTPUTS** | un contrôle **exécutable** (hashes en test) + les conditions de réouverture |
| **MANDATORY CHECKS** | le gel est-il exécutable ? re-geler oblige-t-il à écrire pourquoi ? |
| **STOP CONDITIONS** | modification demandée sans défaut démontré → refuser et demander la preuve |
| **EVIDENCE REQUIRED** | pour rouvrir : la reproduction du défaut |
| **COMMON FAILURE MODES** | geler trop tôt, trop large, ou seulement dans un document |
| **RELATION** | contrôlé par `release-gates` |

### `session-handoff`

| | |
|---|---|
| **PURPOSE** | Rendre un projet reprenable sans mémoire conversationnelle |
| **WHEN TO USE** | Avant une réinitialisation de contexte, en fin de phase, en passant le relais |
| **WHEN NOT TO USE** | Session courte dont rien ne survivra |
| **INPUTS** | l'état réel du dépôt, interrogé — pas la mémoire de la session |
| **OUTPUTS** | un document autosuffisant + la première action de la session suivante |
| **MANDATORY CHECKS** | chaque chiffre vient-il d'un outil ? branche, HEAD, points de restauration présents ? les interdictions sont-elles écrites ? |
| **STOP CONDITIONS** | l'état réel contredit le document → signaler, ne rien corriger |
| **EVIDENCE REQUIRED** | sorties de `git`, hashes, identifiants d'appareils |
| **COMMON FAILURE MODES** | raconter la session au lieu de décrire l'état ; mélanger état du projet et méthode |
| **RELATION** | consomme `git-safety` |

### `git-safety`

| | |
|---|---|
| **PURPOSE** | Faire du dépôt un filet, et prouver les restaurations au lieu de les supposer |
| **WHEN TO USE** | Toute mission qui modifie des fichiers ou expérimente sur la configuration |
| **WHEN NOT TO USE** | Lecture seule |
| **INPUTS** | branche et HEAD attendus |
| **OUTPUTS** | branche de mission, commits bornés, diff final vérifié |
| **MANDATORY CHECKS** | HEAD vérifié **avant** ; fichiers non suivis inventoriés, jamais supprimés ; commit docs-only si la mission est un audit ; hash pour les fichiers ignorés ou sensibles |
| **STOP CONDITIONS** | HEAD ou branche inattendus · un fichier produit a changé dans une mission documentaire |
| **EVIDENCE REQUIRED** | `git diff` **et** hash — le diff seul ne dit rien d'un fichier ignoré |
| **COMMON FAILURE MODES** | fusionner sans vérifier l'ancestry ; supprimer un fichier non suivi ; prendre la discipline pour une sauvegarde |
| **RELATION** | support de tous les autres |

### `release-gates`

| | |
|---|---|
| **PURPOSE** | Décider avec des preuves si le travail peut continuer, et écrire ce qui ne l'est pas |
| **WHEN TO USE** | Effet irréversible ou externe, matériel, paiement, données, coût d'erreur élevé |
| **WHEN NOT TO USE** | Changement local couvert par les tests — **le cas le plus fréquent** |
| **INPUTS** | objectif, préconditions, critères écrits d'avance |
| **OUTPUTS** | statut, preuves, anomalies restantes, **conditions de réouverture**, point de rollback |
| **MANDATORY CHECKS** | le mode (LIGHT/STANDARD/DEEP) est-il déclaré ? les critères sont-ils antérieurs au travail ? ce qui reste ouvert est-il écrit avec son niveau ? |
| **STOP CONDITIONS** | un critère ne peut pas être évalué → `PARTIAL`, jamais `PASS` par défaut |
| **EVIDENCE REQUIRED** | les nombres réels du runner, pas des totaux reconstitués |
| **COMMON FAILURE MODES** | DEEP partout ; `PASS` global masquant un `NOT DETERMINED` ; oublier les conditions de réouverture |
| **RELATION** | orchestre les autres |

### `human-validation`

| | |
|---|---|
| **PURPOSE** | Séparer ce qu'une machine établit de ce qu'un humain seul peut juger |
| **WHEN TO USE** | Perception, ergonomie, matériel réel, confort, accessibilité, ressenti |
| **WHEN NOT TO USE** | Ce qu'un test décide mieux : présence, valeur, non-régression |
| **INPUTS** | ce qui a déjà été mesuré, pour ne pas le redemander |
| **OUTPUTS** | une checklist non cochée, puis un verdict enregistré **au grain donné** |
| **MANDATORY CHECKS** | aucun point n'est pré-coché ; le verdict est-il enregistré tel quel ; un point peut-il être « hors critère » ? |
| **STOP CONDITIONS** | aucun retour humain → `PENDING`, jamais `PASS` |
| **EVIDENCE REQUIRED** | ce que la personne a dit, pas ce qu'on en déduit |
| **COMMON FAILURE MODES** | fabriquer un détail non reçu ; prendre une installation pour un regard ; hiérarchiser les deux preuves |
| **RELATION** | consommé par `release-gates` |

---

## 5. Skills existants — compatibilité et recouvrements

**Constat vérifié.** `ios-app-skills.zip` contient 19 skills iOS ; `SwiftUI-Agent-Skill-main.zip` un plugin
`swiftui-expert-skill` ; `SKILL.md` à la racine est `iris-debug-observability`. Aucun n'a été extrait ni modifié.

| Ce qu'ils couvrent déjà | Ne pas dupliquer |
|---|---|
| `ios-project-foundation`, `architecture-designer`, `file-structure-organizer` | mise en place et structure |
| `swift-coder`, `view-generator`, `viewmodel-generator`, `domain-modeler`, `use-case-generator`, `business-logic-engine`, `data-layer-generator`, `dependency-injector`, `coordinator-navigator` | production de code par couche |
| `layer-auditor` | règles de couches — **déjà matérialisé** dans `Tools/audit.py` |
| `test-generator` | écriture de tests |
| `code-deduplicator` | déduplication |
| `ui-ux-designer`, `swiftui-component-library` | interface |
| `product-conception`, `feature-builder` | conception et assemblage |

**Analyse de lacune.** Ces 19 skills répondent à « comment construire ». Aucun ne répond à :

- **comment savoir si l'on a prouvé quelque chose** → `evidence-levels` ;
- **comment enquêter sans détruire** → `reversible-experimentation` ;
- **comment protéger ce qui est validé** → `frozen-subsystems` ;
- **comment décider qu'une étape est close** → `release-gates` ;
- **comment survivre à une perte de contexte** → `session-handoff` ;
- **ce qu'une machine ne peut pas valider** → `human-validation`.

**La méthode est une couche au-dessus, pas un remplacement.** Un skill de construction dit quoi écrire ; un skill
de méthode dit quand s'arrêter, quoi prouver et quoi ne pas toucher. Ils se composent.

**Deux frictions à vérifier avant d'assembler quoi que ce soit** — non vérifiées ici, les archives n'ayant pas été
extraites :

1. un skill de construction qui encourage le refactor opportuniste entrerait en conflit direct avec
   `frozen-subsystems`. La résolution appartient à la couche méthode ;
2. `layer-auditor` pourrait recouvrir `Tools/audit.py`. Le script gagne : il est exécutable, versionné, et déjà
   adapté au projet.

`iris-debug-observability` est entièrement Iris-specific. Il reste dans l'étude de cas — mais sa forme
(diagnostiquer avant de modifier, isolation DEBUG, ne pas redessiner le moteur sous prétexte de l'observer) est
exactement un exemple de la couche méthode appliquée à un domaine.

---

## 6. Ce qu'il ne faut pas faire ensuite

- **Ne pas** transformer ces documents en skills opérationnels tant qu'un deuxième projet ne les a pas éprouvés.
  Un projet ne valide pas une méthode.
- **Ne pas** créer un skill Android : rien n'y est démontré.
- **Ne pas** dupliquer les 19 skills iOS existants.
- **Ne pas** écrire un skill pour une règle qui n'a jamais rien attrapé.
- **Commencer petit** : `evidence-levels` seul, sur un projet réel, et observer s'il change quelque chose.
