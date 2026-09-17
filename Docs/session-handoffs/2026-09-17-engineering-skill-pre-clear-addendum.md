# Addendum — Engineering Agent Skill, 17 septembre 2026

Ce document **complète** le handoff pré-clear ; il ne le remplace pas.

> **Le handoff Iris reste la référence autoritative pour le produit :**
> `Docs/session-handoffs/2026-09-17-gate4a-pre-clear.md`
>
> Tout ce qui concerne l'état d'Iris — branche, HEAD, Gates, appareils, systèmes gelés, interdictions — s'y
> trouve, et rien ici ne le modifie.

## Ce qui s'est ajouté depuis

| | |
|---|---|
| Commit de la méthodologie | `6957a775277d42fce7cec0f8aca0d6a4377ca6b4` |
| **SKILL_BUILD_COMMIT** | `6f858589358365a7c4671ab5c2b728c17f065bd5` |
| Commit de cet addendum | le suivant, sur la même branche |
| Branche | `release/iris-appstore-rc1` — inchangée |

## Ce qui a été construit

Un paquet de skills pour agents IA, **sans rapport avec le produit Iris** : il porte la méthode, pas le jeu.

| | |
|---|---|
| Source | `Tools/AgentSkills/Engineering-Agent-Skill/` |
| Version | 1.0.0 |
| Fichiers | 78 |
| Skills | `engineering-expert-skill` · `ios-release-evidence-skill` · `extract-validated-lessons` |
| Outils | 6 scripts Python, lecture seule, sans réseau |
| Tests | **69, tous verts** |
| Scénarios d'évaluation | 10 |

### Le livrable

```
ZIP     ~/Desktop/Engineering-Agent-Skill-v1.0.0.zip
Taille  119 032 octets
SHA-256 5a759e66567ccf884c7d93996ef1c874b3db65267044559537a0d1903f476172
```

Vérifié en le rouvrant : 79 entrées, aucune corruption, et les quatre répertoires cachés présents
(`.agents`, `.claude-plugin`, `.codex-plugin`, `.cursor-plugin`). `RELEASE-MANIFEST.json` y consigne un SHA-256
par fichier et le commit source.

Le ZIP **n'est pas** dans le dépôt. L'arbre source est la vérité Git ; le ZIP est le livrable reproductible.

## Ce qui n'a pas été touché

```
Code produit Iris .......... aucun changement
Projet Xcode / project.yml . aucun changement
Gaze Engine, StoreKit, UX ... aucun changement
Xcode ....................... non ouvert
Appareils ................... aucun contact — ni 14 Pro, ni 15 Pro
SKILL.md racine (non suivi) . lu seulement, non modifié, non commité
Archives ZIP sources ........ extraites dans un dossier temporaire, jamais modifiées
Tags ........................ aucun créé, déplacé ni supprimé
main ........................ inchangé
Push ........................ aucun
```

Le diff des deux commits ne contient que `Tools/AgentSkills/Engineering-Agent-Skill/` et ce document.

## Le skill n'est pas activé

Volontairement. Rien n'a été copié dans `~/.claude`, `~/.codex` ou la configuration de Cursor ; aucun plugin n'a
été activé ; le comportement de la session n'a pas changé ; le skill n'a pas été injecté dans le travail sur
Iris.

`INSTALLATION.md` décrit les trois environnements et marque chacun **STRUCTURALLY SUPPORTED — pas RUNTIME
VERIFIED**. L'installation est une décision séparée, à prendre après examen.

## Première action après `/clear`

1. Lire `Docs/session-handoffs/2026-09-17-gate4a-pre-clear.md` — l'état d'Iris.
2. Lire cet addendum.
3. Lire `Tools/AgentSkills/Engineering-Agent-Skill/README.md` — ce qu'est le skill.
4. Vérifier l'état réel : `pwd`, racine Git, branche, HEAD, `git status`, `git diff`.
5. Comparer avec les documents. **En cas d'écart : signaler, ne rien corriger.**
6. Attendre la mission explicite.

Les interdictions du handoff Iris restent intégralement en vigueur — en particulier : **ne pas lancer Iris depuis
Xcode sur l'iPhone 14 Pro** tant que le scheme référence `Config/Iris.storekit`.
