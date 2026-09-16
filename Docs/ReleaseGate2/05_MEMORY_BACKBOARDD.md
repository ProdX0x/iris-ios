# 05 — Mémoire système et `backboardd`

## 1. La limite d'outillage, énoncée d'abord

**FACT.** `backboardd` **n'a pas pu être échantillonné directement**. `xctrace` refuse
`--template "Activity Monitor" --all-processes` sur cet appareil (trois tentatives, message identique), refuse
`--attach backboardd` et refuse l'attache par pid obtenu depuis `devicectl`.

Ce qui est mesuré à la place :

1. la **mémoire système globale** pendant la session (`sysmon-system`, ~1 échantillon/s) ;
2. le champ **`lifetimeMax` de `backboardd`** dans chaque rapport Jetsam — son pic depuis le démarrage.

Toute conclusion ci-dessous s'appuie sur ces deux sources, jamais sur un échantillonnage direct de `backboardd`.

## 2. Mémoire système pendant la session de jeu de 11 minutes

**MEASUREMENT** — iPhone 14 Pro, session C, 644 échantillons.

| Grandeur | Début | Fin | Min | Max | Net |
|---|---|---|---|---|---|
| Libre | 409,5 Mo | 75,8 Mo | 24,4 Mo | 524,3 Mo | **−333,7 Mo** |
| Filaire (*wired*) | 1150,4 Mo | 1808,1 Mo | 1150,4 Mo | 2019,3 Mo | **+657,8 Mo** |
| Utilisée | 5252,8 Mo | 5586,5 Mo | 5138,0 Mo | 5637,9 Mo | +333,7 Mo |
| Compresseur | 483,7 Mo | 522,4 Mo | 483,4 Mo | 562,0 Mo | +38,6 Mo |

Moyennes par cinquième :

| | 1 | 2 | 3 | 4 | 5 | strictement croissant ? |
|---|---|---|---|---|---|---|
| Libre | 181,7 | 108,5 | 136,0 | 116,4 | 90,9 | **non** |
| Filaire | 1787,9 | 1829,8 | 1832,6 | 1832,2 | 1846,4 | **non** |
| Utilisée | 5480,6 | 5553,8 | 5526,3 | 5545,9 | 5571,4 | **non** |
| Compresseur | 546,2 | 554,8 | 529,8 | 522,7 | 522,4 | **non** (décroît) |

```
SYSTEM MEMORY MONOTONIC GROWTH WHILE IRIS RUNS: NO
```

La mémoire filaire varie de 1150 à 2019 Mo mais **oscille** : ses cinq moyennes tiennent dans 59 Mo, soit 3 %. La
mémoire libre descend puis remonte. Rien ne dessine une rampe.

**INFERENCE, non prouvée :** ces variations sont celles d'un iPhone ordinaire où d'autres applications vivent en
arrière-plan. Elles **ne peuvent pas être attribuées à Iris**, dont la mémoire résidente est restée plate à 119 Mo
sur la même fenêtre (document 03).

## 3. `backboardd` — ce que les Jetsam permettent d'affirmer

**MEASUREMENT.** Pic de `backboardd` depuis le démarrage, relevé dans les 16 Jetsam de l'appareil :

```
962 · 962 · 962 · 1563 · 811 · 989 · 989 · 969 · 702 · 500 · 474 · 527 · 985 · 985 · [3072] · 1342 Mo
```

**Quinze de ces seize relevés proviennent d'événements où Iris n'apparaît pas dans la liste des processus.**
`backboardd` atteint donc couramment 0,5 à 1,5 Go sur cet appareil **sans Iris** — et **1342 Mo aujourd'hui même**,
à 16:35, alors qu'Iris ne tournait pas.

Le seul relevé à **3072 Mo** est celui du 16 septembre à 04:54:47 : environ **le double du maximum historique**
(1563 Mo), et le seul des seize où `backboardd` a été tué (`highwater`).

```
BACKBOARDD MEMORY GROWS MONOTONICALLY WHILE IRIS RUNS: NOT MEASURED   (échantillonnage direct impossible)
BACKBOARDD KILLED DURING ANY GATE 2 SESSION: NO
IRIS-ATTRIBUTABLE BACKBOARDD GROWTH: NOT PROVEN
```

## 4. L'incident historique du 04:54:47, relu

**MEASUREMENT**, dans le fichier :

| Champ | Valeur |
|---|---|
| `largestProcess` | **backboardd**, 3072,2 Mo, tué `highwater` |
| Mémoire libre | 18,1 Mo |
| Tués hors `long-idle-exit` | 75 |
| **Iris** | **présent deux fois** : pid 8249 (65,9 Mo, `suspended`, tué `idle-exit`) et pid 8258 (79,8 Mo, `active, frontmost`, **non tué**) |

**FACT : Iris n'a pas été tuée.** C'est `backboardd` qui l'a été.

**FACT, et c'est le facteur de confusion déjà consigné au Gate 1 :** deux instances d'Iris coexistaient. Trois
variantes de l'application avaient été installées et lancées dans l'heure précédente par le travail d'ingénierie.
Ce n'est pas un état d'utilisateur.

```
IRIS WAS KILLED: NO
BACKBOARDD WAS KILLED: YES
CAUSE ATTRIBUTABLE TO IRIS: NOT PROVEN
REPRODUCED UNDER CONTROLLED CONDITIONS: NO  →  NOT REPRODUCED
```

**NOT REPRODUCED n'est pas une preuve d'impossibilité.** L'événement a eu lieu ; il n'a pas pu être refait en
conditions normales, et rien ne le relie causalement à Iris.

## 5. Ce qui resterait à faire pour aller plus loin

1. Un **appareil froid et au repos**, sans compilation ni installation préalable, pour une session de référence.
2. Une session longue (30 min et plus) pour sonder une dérive lente qu'une fenêtre de 11 minutes ne verrait pas.
3. Un moyen d'échantillonner `backboardd` — non disponible ici ; un `sysdiagnose` pendant l'incident serait la seule
   autre piste, et il a échoué sur cet appareil (`DiagnoseError error 0`).
