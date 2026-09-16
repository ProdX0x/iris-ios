# 07 — Décision sur les trois blockers

Rappel du critère du mandat : « RESOLVED FOR RELEASE » ne veut pas dire « impossible que cela recommence ». Cela
veut dire : **les tests représentatifs ne montrent pas de défaillance attribuable à Iris qui justifie de bloquer la
publication.**

---

## 1. Performance

```
PERFORMANCE BLOCKER: RESOLVED
```

| Élément | Statut | Valeur |
|---|---|---|
| Latence ressentie, 14 Pro | **FACT (humain)** | aucune |
| Latence ressentie, 15 Pro | **FACT (humain)** | aucune |
| Mémoire résidente Iris, 11 min de jeu | **MEASUREMENT** | **plate à 119,1–119,2 Mo** de t=90 s à la fin |
| Croissance monotone Iris | **MEASUREMENT** | **NON** |
| CPU | **MEASUREMENT** | 47,4 % moyen, 59,7 % max |
| Empreinte maximale | **MEASUREMENT** | 190,7 Mo, transitoire |
| Crash pendant les sessions | **MEASUREMENT** | aucun |
| Frame pacing | **NOT MEASURED** | un seul modèle `xctrace` à la fois |

**Raisonnement.** Le blocker historique reposait sur une lenteur ressentie. L'utilisateur a retesté les deux
appareils et n'en ressent plus. Onze minutes de jeu continu instrumenté montrent une mémoire résidente
rigoureusement stable et un CPU soutenu mais cohérent pour du suivi de visage ARKit à 60 Hz. Aucune régression
n'est reproduite, ni ressentie, ni mesurée.

**Ce qui n'est pas prétendu :** le frame pacing n'a pas été mesuré, et l'appareil était en état thermique
`Serious` — hérité d'une soirée de compilations, pas attribué à Iris. Ces deux points sont consignés, aucun ne
justifie de maintenir un blocker.

---

## 2. Jetsam

```
JETSAM BLOCKER: RESOLVED FOR RELEASE
```

| Élément | Statut | Valeur |
|---|---|---|
| Iris tuée le 16-09 à 04:54 | **FACT** | **non** — c'est `backboardd` qui a été tué |
| Iris dans les 16 Jetsam de l'appareil | **MEASUREMENT** | **1 sur 16** |
| `backboardd` dominant sans Iris | **MEASUREMENT** | **6 des 16**, pics de 474 à 1563 Mo |
| Pic de `backboardd` aujourd'hui sans Iris (16:35) | **MEASUREMENT** | **1342 Mo** |
| Nouveau Jetsam après ~18 min de jeu instrumenté | **MEASUREMENT** | **aucun** (151 fichiers avant, 151 après) |
| Mémoire système croissante pendant le jeu | **MEASUREMENT** | **non**, oscillante |
| Cause attribuable à Iris | **NOT PROVEN** | |
| Reproduction en conditions contrôlées | **NOT REPRODUCED** | |

**Raisonnement.** L'appareil subit des Jetsam en routine — seize en quatre semaines, dont quatorze sans qu'Iris
tourne. `backboardd` y est fréquemment le plus gros processus et atteint couramment le gigaoctet sans Iris. Le
16 septembre à 16:35, alors qu'Iris **n'était pas lancée**, il avait déjà culminé à 1342 Mo et l'événement est
attribuable à TikTok (1128 Mo au premier plan). L'événement de 04:54 reste un point aberrant — 3072 Mo, le double
du maximum historique — survenu dans un état que personne ne reproduira : **deux instances d'Iris coexistaient**,
après l'installation et le lancement de trois variantes dans l'heure.

**Ce qui n'est pas prétendu :** que cela ne puisse pas se reproduire, ni que `backboardd` soit hors de cause. Il
n'a pas pu être échantillonné directement (limite d'outillage documentée). Ce qui est affirmé est seulement qu'**il
n'existe aucune preuve reliant Iris à cet événement**, et que des sessions représentatives n'en produisent aucun.

---

## 3. Flash

```
FLASH BLOCKER: NON-BLOCKING
```

| Élément | Statut |
|---|---|
| Impact fonctionnel | **FACT : aucun** — ni crash, ni blocage, ni perte de progression |
| Crash associé | **MEASUREMENT : aucun** |
| Nouveau Jetsam associé | **MEASUREMENT : aucun** |
| Redémarrage système associé | **NOT DETERMINED** |
| Diagnostic autour de 10:30 | **MEASUREMENT : aucun n'existe sur l'appareil** |
| Reproduction, ~18 min instrumentées | **NOT REPRODUCED** |
| Déclencheur global prouvé dans le rendu | **NO** |
| Cause | **NOT DETERMINED** |

**Raisonnement.** Deux épisodes réels, sans aucune conséquence fonctionnelle. Aucun ne laisse de trace sur
l'appareil. L'audit du rendu ne trouve aucun mécanisme d'Iris capable de produire cela, et en trouve un
**extérieur** à Iris le jour même : la mort de `SBRendererService` à 16:35, alors qu'Iris ne tournait pas.

Un défaut visuel bref, sans conséquence, non reproduit, sans cause établie et sans mécanisme identifié dans le code
ne justifie pas de bloquer une publication. Il justifie de **pouvoir l'observer la prochaine fois** : c'est ce
qu'apporte `LifecycleTrace` (DEBUG uniquement, absente de Release, vérifié).

**Ce qui n'est pas prétendu :** que le flash soit expliqué. Il ne l'est pas. `NOT DETERMINED` reste la conclusion,
et le sujet passe au Gate 3 avec un instrument pour le saisir.

---

## 4. Ce qui pourrait faire rouvrir ces décisions

- Un flash **avec** conséquence fonctionnelle (blocage, perte de progression, crash).
- Un Jetsam où **Iris** est `largestProcess`, ou où Iris est tuée en `highwater`.
- Une session longue montrant une résidence qui monte au lieu de rester plate.
- Une lenteur ressentie à nouveau, sur appareil froid.
