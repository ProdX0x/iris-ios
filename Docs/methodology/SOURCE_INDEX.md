# Index des sources

Les documents de `Docs/methodology/` ne recopient pas l'historique d'Iris : ils y renvoient. Voici les sources
réellement lues pour l'extraction du 17 septembre 2026, et **pourquoi chacune a de la valeur méthodologique**.

## Rapports de Release Gate

| Chemin | Type | Thème | Intérêt méthodologique |
|---|---|---|---|
| `Docs/ReleaseGate1/02_STOREKIT_DEVICE_DIFFERENTIAL.md` | mesure | StoreKit, deux appareils | **Investigation différentielle** : deux appareils, même binaire, même méthode d'installation et de lancement, une seule variable libre. Contient aussi des rétractations explicites de conclusions non prouvées |
| `Docs/ReleaseGate1/08_RELEASE_GATE_1_REPORT.md` | rapport | audit release | Quatre questions, chacune close à un niveau de preuve nommé ; section « Ce qui bloque encore » |
| `Docs/ReleaseGate2/05_MEMORY_BACKBOARDD.md` | mesure | mémoire, Jetsam | Ce qu'une mesure établit vraiment quand le processus tué n'est pas le nôtre |
| `Docs/ReleaseGate2/07_STABILITY_DECISION.md` | décision | trois blockers | **Le plus proche d'un ADR du dépôt.** Décide *sans* avoir prouvé la cause, et écrit en §4 « ce qui pourrait faire rouvrir ces décisions » |
| `Docs/ReleaseGate2/01_FLASH_TIMELINE.md` | incident | flash | Chronologie d'un incident dont la cause n'a jamais été établie |
| `Docs/ReleaseGate3/07_HUMAN_VALIDATION_CHECKLIST.md` | validation | checklist humaine | Sépare ce que la machine a mesuré de ce qu'un humain doit juger ; le verdict humain est enregistré **tel qu'il a été donné** (global), sans inventer de résultat ligne par ligne |
| `Docs/ReleaseGate3/11_GATE3_HUMAN_FINAL_VALIDATION.md` | clôture | Gate 3 | Un point explicitement déclaré **hors critère** plutôt que passé : VoiceOver |
| `Docs/ReleaseGate4/01_GIT_RELEASE_LINEAGE.md` | audit | lignée Git | Prouve qu'aucune fusion n'était nécessaire **avant** d'en faire une |
| `Docs/ReleaseGate4/02_RELEASE_BUILD_AND_TESTS.md` | mesure | builds, tests | Distingue « le code est prêt » de « l'archive est prête » |
| `Docs/ReleaseGate4/03_STOREKIT_READINESS.md` | audit | StoreKit | Sépare le code (auditable) de l'état externe (non déterminé) |
| `Docs/ReleaseGate4/08_GATE4_REPORT.md` | rapport | Gate 4 | Quatre états distincts au lieu d'un « prêt / pas prêt » |
| `Docs/ReleaseGate4/09_STOREKIT_DEVICE_CLEANUP.md` | expérience | Gate 4A | **La source principale du modèle d'expérimentation réversible.** Contient les deux tests, leurs contrôles, et trois tentatives de discrimination qui ont échoué et sont consignées |

## Handoffs et archives de session

| Chemin | Intérêt |
|---|---|
| `Docs/session-handoffs/2026-09-17-gate4a-pre-clear.md` | Le modèle de handoff le plus complet du dépôt ; contient le protocole de reprise |
| `Docs/session-handoffs/2026-09-15-liquid-glass-pre-clear.md` | Handoff antérieur — montre que la pratique est répétée, pas ponctuelle |
| `Docs/session-archives/2026-09-15-claude-code-session/` | Archive verbatim d'une session : `prompt-history.md`, `reports.md`, `compaction-summaries.md`, `manifest.md`, `memory-snapshot` |
| `Docs/ReleaseGate2/09_GATE_3_HANDOFF.md` | Handoff de Gate à Gate, pas seulement de session à session |

## Outils et contrats du dépôt

| Chemin | Intérêt |
|---|---|
| `Tools/audit.py` | Règles de couches exécutables (C1, C2, C8, C9, C10, C12) plutôt qu'écrites dans un document que personne ne relit |
| `Tests/IrisTests/Campaign/GameContentFreezeTests.swift` | **Le gel par SHA-256.** Re-geler un hash oblige à écrire pourquoi, dans le fichier de test |
| `Tests/IrisTests/Commerce/CommerceBoundaryTests.swift` | Frontières de couche et vocabulaire interdit vérifiés par des tests, y compris dans la documentation App Store |
| `project.yml` | Source de vérité générée ; verrouille l'identité Apple, contrôlée par `audit.py` C12 |
| `README.md` | Carnet technique du projet |

## Skills présents localement

| Chemin | État |
|---|---|
| `SKILL.md` (racine, non suivi) | **Existe.** `iris-debug-observability` — skill de diagnostic du regard, entièrement Iris-specific. Lu en lecture seule, non modifié |
| `ios-app-skills.zip` (racine, non suivi) | **Existe.** 19 skills iOS : `ios-project-foundation`, `architecture-designer`, `feature-builder`, `code-deduplicator`, `layer-auditor`, `test-generator`, `swift-coder`, `domain-modeler`, `viewmodel-generator`, `view-generator`, `coordinator-navigator`, `dependency-injector`, `data-layer-generator`, `business-logic-engine`, `use-case-generator`, `file-structure-organizer`, `ui-ux-designer`, `swiftui-component-library`, `product-conception`. Listé sans extraction |
| `SwiftUI-Agent-Skill-main.zip` (racine, non suivi) | **Existe.** Plugin `swiftui-expert-skill` avec `AGENTS.md`, `plugin.json`. Listé sans extraction |
| `skills/`, `.skill/`, `.claude/`, `agents/`, `prompts/` dans le dépôt | **absents** |
| `~/.claude/skills` | **absent** |

```
SOURCE SKILLS ARCHIVES = AVAILABLE (archivées, non extraites, non modifiées)
```

## Ce qui n'a pas été utilisé, et pourquoi

`Docs/product.md` et `Docs/project-brief.md` sont **périmés** — ils annoncent 14 niveaux et « Free. No StoreKit ».
Ils sont cités ici comme exemple de dérive documentaire, pas comme source.

Les fichiers de `Design/` décrivent l'intention produit d'Iris ; ils sont Iris-specific et n'ont pas de matière
méthodologique généralisable.
