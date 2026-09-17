# 01 — Lignée Git de la Release Candidate

Audit du 17 septembre 2026. Aucune fusion n'a été faite, et aucune n'était nécessaire.

## Point de départ, vérifié

| | |
|---|---|
| Branche | `feature/iris-gaze-assistance-pause-copy` |
| HEAD | `42ca32ade5d35e2801b0d86e5b5552efbbc445d6` |
| `main` | `52f20b7a4838e85f5be12c202bd4b98e9693f3a7` |
| `origin/main` | `52f20b7` — identique |
| Remote | `origin` → github.com/ProdX0x/iris-ios.git |
| Tags | 4, tous historiques, aucun sur cette lignée |
| Fichiers suivis modifiés | aucun |
| Fichiers non suivis | `JetsamEvent-2026-09-16-045447.ips`, `SKILL.md`, `x7_silhouette_reference.png` — préservés, non commités |

## La question : faut-il fusionner quelque chose ?

Non. Les quatre commits de référence sont tous **ancêtres** de `42ca32a` :

| Commit | Travail | Ancêtre de HEAD |
|---|---|---|
| `d005dde` | Gate 3 — assistance au regard, apprentissage, halo, III-7 | oui |
| `e29b095` | accès à l'aide au regard depuis la pause | oui |
| `b32bab1` | microcopie finale, calibration, accessibilité | oui |
| `42ca32a` | clôture du Gate 3 après validation humaine | oui (c'est HEAD) |

`main..HEAD` : **87 commits, 0 merge**. Une seule lignée, strictement linéaire.

## Ce qui est déjà dedans

Sur les 22 branches locales, **18 sont des ancêtres de HEAD** : `main`, `feature/iris-v2`, l'expansion complète,
l'expansion oculomotrice, Liquid Glass, la monétisation, les Gates 1 et 2, les correctifs de cartes de chapitre et
de X-7, les prototypes de niveau 1-6 et de stabilisation X-7.

**Quatre branches restent dehors**, et c'est voulu :

| Branche | Commits absents |
|---|---|
| `prototype/braises` | `416feb9` |
| `prototype/braises-b-rework` | `+ ea1cfae` |
| `prototype/braises-b-ux-audio` | `+ aeafc28` |
| `prototype/braises-b-final-diagnostic` | `+ c0709d0` |

C'est l'hypothèse « Braises B », testée puis **rejetée** et délibérément absente de la ligne principale. Son
commit de clôture porte le mot : « docs: close rejected Braises B hypothesis ». Rien à y récupérer.

## Décision

```
LIGNÉE UNIQUE : oui
FUSION NÉCESSAIRE : non
FUSION EFFECTUÉE : aucune
```

Branche créée : **`release/iris-appstore-rc1`**, à partir de `42ca32a`, sans modification.
`main` n'a pas été touchée. Aucun push, aucun tag.
