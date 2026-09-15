# Archive de la session Claude Code — Iris, 2026-09-15 (avant /clear)

Archive de préservation des échanges réels entre l'utilisateur et Claude Code sur le projet Iris, du 2026-09-10 au 2026-09-15. Elle **ne remplace pas** l'historique par une synthèse : les messages, rapports, commandes et résultats y sont repris **mot pour mot** depuis les fichiers de session de Claude Code. La synthèse de reprise est à part : [`Docs/session-handoffs/2026-09-15-liquid-glass-pre-clear.md`](../../session-handoffs/2026-09-15-liquid-glass-pre-clear.md).

## Par où commencer

1. Reprendre le travail : le fichier de reprise ci-dessus.
2. Retrouver une décision ou un résultat : [reports.md](reports.md), puis [session-history.md](session-history.md) et ses parties.
3. Comprendre ce que Claude savait après chaque compaction : [compaction-summaries.md](compaction-summaries.md).
4. Vérifier l'intégrité ou retrouver le brut : [manifest.md](manifest.md).

## Comment l'archive a été produite

- Source : instantané brut des fichiers de session pris le 2026-09-15 à 21:28 UTC (23:28 +0200) dans `/Volumes/Steve Pro BlackSSD/Dev/Iris-Safety-Backups/2026-09-15-pre-clear/raw-claude-sessions/snapshots/2026-09-15T2128Z/`, après une première copie brute prise à 21:23 UTC.
- Conversion automatique en Markdown, dans l'ordre du fichier. Chaque texte est placé dans un bloc délimité (`~~~~`) pour être reproduit tel quel, sans reformulation. Les étiquettes (USER, CLAUDE, REPORT, GIT, TEST, BUILD, DECISION…) sont ajoutées automatiquement pour la navigation.
- Aucune troncature : chaque message, commande et sortie est complet.

## Ce qui a été retiré, et pourquoi

Tout reste disponible dans la copie brute locale ; rien de ce qui suit n'est dans Git :

- **Blocs de réflexion interne de Claude** (698) : raisonnement de travail, non destiné à l'utilisateur.
- **Images** (115, 28626044 caractères base64) : captures d'écran lues par Claude, remplacées par une mention avec leur empreinte courte. Les captures de référence du projet sont indexées dans le manifeste.
- **Bruit technique répété** : rappels automatiques (jetons restants, rappels de regroupement, notes d'audience), métadonnées d'état (mode, permissions, pont de session, titres répétés, instantanés d'historique de fichiers), invite système complète, contexte de session (qui contient l'adresse e-mail), listes d'outils et de connecteurs, légendes d'images. Le décompte exact est dans le manifeste.

## Masquages

- Adresse e-mail personnelle : 2 occurrence(s), remplacée(s) par `[REDACTED_EMAIL]`.
- Jetons locaux de session (`peerToken`) et empreintes des fichiers `.key` de `~/.claude/sessions` : 9 occurrence(s), remplacée(s) par `[REDACTED_SECRET]`.
- Aucun jeton d'API, jeton GitHub, clé privée, certificat, mot de passe ou en-tête d'autorisation réel n'a été trouvé (recherche avant et après conversion ; les faux positifs sont décrits dans le manifeste).

## Limites

- Deux sessions Iris citées dans `~/.claude/history.jsonl` n'ont plus de transcription locale, et 29 des 58 collages référencés ne sont plus dans le cache : **NOT AVAILABLE IN LOCAL CLAUDE SESSION STORAGE**. Rien n'a été reconstitué de mémoire.
- La fin de la mission d'archivage (commit, push, vérifications finales, rapport) est postérieure à l'instantané ; elle figure dans l'instantané final conservé localement.
