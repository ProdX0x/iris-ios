# Historique chronologique des sessions Claude Code — projet Iris

Cet index ouvre l'historique **en texte d'origine**. Chaque partie reprend les entrées dans l'ordre exact du fichier de session JSONL, donc dans l'ordre chronologique ; les heures sont données en Europe/Paris (+0200) avec l'heure UTC entre parenthèses.

La session principale `f88478cc-d512-4210-bc11-758059278995` est découpée par jour local. La session distincte `4a1b6284-eeb2-4ff3-9176-b7e4a3a1b4bc` (2026-09-14, 16:32 → 16:45, audit de maturité avec deux sous-agents) s'est déroulée pendant la journée couverte par la partie 005 ; elle est rangée juste après, en partie 006, pour ne pas mêler deux conversations.

| Partie | Session | Première → dernière entrée (+0200) | Blocs | Octets | SHA-256 |
|---|---|---|---|---|---|
| [session-history-part-001.md](session-history-part-001.md) | `f88478cc-d512-4210-bc11-758059278995` | 2026-09-10 23:18:30 → 2026-09-10 23:59:55 | 106 | 559927 | `d78976c3aa518b5d7fcd103dd8aca051a0d7cccec18712c379154e8011c3c84a` |
| [session-history-part-002.md](session-history-part-002.md) | `f88478cc-d512-4210-bc11-758059278995` | 2026-09-11 00:01:40 → 2026-09-11 23:57:27 | 388 | 1466885 | `fa24696eb5e3196913d5b7bdea319bd5f73bc06f4c71f6337b4834617df901b3` |
| [session-history-part-003.md](session-history-part-003.md) | `f88478cc-d512-4210-bc11-758059278995` | 2026-09-12 00:07:26 → 2026-09-12 22:08:02 | 488 | 1841558 | `b3205d2168559bab9728f1ef0932dea97c11519f8bc90c0675061cf06dc23334` |
| [session-history-part-004.md](session-history-part-004.md) | `f88478cc-d512-4210-bc11-758059278995` | 2026-09-13 02:06:05 → 2026-09-13 03:03:53 | 159 | 338110 | `cbb29bb7b74c98b75884b8809b95381d25af7b8d0c038243bd4c0dc88ea0fc2e` |
| [session-history-part-005.md](session-history-part-005.md) | `f88478cc-d512-4210-bc11-758059278995` | 2026-09-14 00:14:00 → 2026-09-14 23:59:32 | 978 | 2524031 | `c2af59f965947d4191284ec5828b9edf9367c655f24805d362f9f70a359e220a` |
| [session-history-part-006.md](session-history-part-006.md) | `4a1b6284-eeb2-4ff3-9176-b7e4a3a1b4bc` | 2026-09-14 16:32:56 → 2026-09-14 16:38:35 | 186 | 570882 | `0f8d05dbe99ad34944abc445d761de87eefcfa8095dfe58b397a0ea7962a32ac` |
| [session-history-part-007.md](session-history-part-007.md) | `f88478cc-d512-4210-bc11-758059278995` | 2026-09-15 00:00:09 → 2026-09-15 23:26:41 | 163 | 342383 | `ca445cefab53ea2ef35cc80cb61a7017b9cac9b2538ca5710c841df6be983859` |

## Types de blocs

- `USER` : message tapé ou collé par l'utilisateur, texte intégral. `USER · DECISION` : même chose, repéré automatiquement parce qu'il contient un mot de décision (VALIDÉ, REJETÉ, verdict…) ; le repérage est une aide, pas une interprétation.
- `CLAUDE` : réponse de Claude, texte intégral. `CLAUDE · REPORT` : réponse longue (plus de 2 000 caractères) ou rapport explicite, reprise aussi dans [reports.md](reports.md).
- `TOOL CALL · <outil>` : commande ou appel d'outil exact ; `GIT`, `TEST`, `BUILD` sont ajoutés automatiquement d'après la commande.
- `TOOL RESULT · <outil>` : sortie exacte renvoyée à Claude (sans troncature).
- `NOTIFICATION` : fin de tâche d'arrière-plan ou message en file, texte intégral.
- `SUMMARY` : résumé de compaction généré par Claude Code (aussi dans [compaction-summaries.md](compaction-summaries.md)).
- `SYSTEM` : compaction, changement de modèle, date de session, récapitulatif d'absence généré.
- `COMMAND` : commande locale (`/model`, `/effort`…) et sa sortie.
- `MEMORY EDIT` : modification d'un fichier de mémoire du projet.
- `TITRE DE SESSION` : titre automatique, noté quand il change.

## Autres fichiers de l'archive

- [reports.md](reports.md) — rapports et bilans de fin de mission, texte d'origine (27 extraits).
- [compaction-summaries.md](compaction-summaries.md) — les 4 résumés de compaction.
- [prompt-history.md](prompt-history.md) — les 92 prompts du projet Iris enregistrés dans `~/.claude/history.jsonl`, y compris ceux de sessions dont la transcription n'existe plus localement.
- [memory-snapshot/](memory-snapshot/) — fichiers de mémoire du projet au moment de l'archivage.
- [tool-results/](tool-results/) — sorties d'outils trop longues que Claude Code avait enregistrées à part.
- [README.md](README.md) et [manifest.md](manifest.md) — méthode, omissions, masquages, sources, empreintes et limites.
