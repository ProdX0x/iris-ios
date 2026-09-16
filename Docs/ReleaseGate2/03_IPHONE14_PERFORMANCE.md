# 03 — Performance mesurée : iPhone 14 Pro

Appareil : `iPhone15,2`, iOS 26.5.2 (23F84). Build : Iris 1.0 (1) Debug, commit de Gate 2, installée par
`devicectl`. Instrument : Activity Monitor attaché à Iris, ~1 échantillon/s.

## 1. Trois enregistrements, dont un seul est une vraie session

| # | Début | Durée | Fin | Verdict |
|---|---|---|---|---|
| A | 20:33:39 | 351 s | « Target app exited », `exit(0)` | **rejeté** — aucun jeu |
| B | 20:44:24 | 394 s | « Target app exited », `exit(0)` | **partiel** — 64 s de jeu seulement |
| **C** | **21:11:11** | **661 s** | **« Time limit reached »** | **retenu** — jeu continu |

**Pourquoi A a été rejeté — MEASUREMENT, pas impression :** empreinte **constante à 24,6 Mo sur les 342
échantillons**, 6 threads, CPU ≤ 10,4 %, mémoire résidente *décroissante* de 74,7 à 31,2 Mo. C'est la signature
d'une application posée sur un écran statique. Le protocole interdit de présenter cela comme une session ; elle est
écartée.

**B** montre 5 minutes de repos puis ~64 s de jeu réel (threads 10→17, CPU jusqu'à 62,5 %, empreinte jusqu'à
107,5 Mo). Trop court pour conclure sur une croissance ; conservé comme mesure secondaire.

## 2. Session C — la mesure retenue

**MEASUREMENT**, 661 s (11 min 1 s), 644 échantillons, fin par expiration du délai (l'app n'est ni sortie ni tombée).

### Iris

| Grandeur | Valeur |
|---|---|
| Empreinte physique initiale | **36,3 Mo** |
| Empreinte physique finale | **93,8 Mo** |
| Empreinte physique maximale | **190,7 Mo** (à t = 562 s) |
| Empreinte minimale | 35,9 Mo |
| **Mémoire résidente** | 84,9 → **119,2 Mo**, max 123,0 Mo |
| Mémoire anonyme | ~37 Mo, stable |
| Mémoire compressée | ~1,5 Mo, stable |
| CPU moyen / maximum | **47,4 % / 59,7 %** |
| Threads | 6 au lancement → 14 à 16 en jeu |

### Le profil dans le temps — moyennes par tranche de 45 s

| t (s) | CPU moy. | empreinte moy. | empreinte max | résident moy. | threads |
|---|---|---|---|---|---|
| 0 | 28,0 | 57,7 | 157,4 | 97,0 | 15 |
| 45 | 45,5 | 105,7 | 172,5 | 115,0 | 16 |
| 90 | 47,8 | 109,4 | 164,2 | **118,8** | 14 |
| 135 | 49,8 | 107,2 | 186,8 | **119,1** | 14 |
| 180 | 49,3 | 102,4 | 155,9 | **119,1** | 15 |
| 225 | 49,1 | 105,3 | 179,3 | **119,0** | 15 |
| 270 | 48,8 | 114,1 | 173,3 | **119,1** | 15 |
| 315 | 50,9 | 99,0 | 152,6 | **119,2** | 15 |
| 360 | 48,4 | 111,5 | 189,1 | **119,2** | 15 |
| 405 | 49,0 | 97,3 | 122,8 | **119,1** | 14 |
| 450 | 47,8 | 131,3 | 183,6 | **119,2** | 15 |
| 495 | 49,6 | 130,9 | 178,7 | **119,1** | 15 |
| 540 | 48,2 | 131,1 | 190,7 | **119,2** | 14 |
| 585 | 48,9 | 127,4 | 174,7 | **119,2** | 16 |
| 630 | 48,7 | 110,4 | 190,0 | **119,2** | 15 |

## 3. Croissance monotone ?

```
MONOTONIC MEMORY GROWTH (Iris): NO
```

**Fondement, et il faut être précis parce qu'une lecture grossière dit le contraire.**

Découpée en cinq blocs égaux, la moyenne de l'empreinte monte : 90,5 → 105,7 → 108,8 → 115,9 → 125,9 Mo, ce qui
**paraît** strictement croissant. Ce n'est qu'un artefact : le premier bloc contient le démarrage, où l'app est à
36 Mo.

À la résolution de 45 s, l'empreinte **oscille sans tendance** entre 97 et 131 Mo, et la dernière tranche (110,4)
est **plus basse** que celles de t = 450, 495 et 540 (≈ 131). Sur les 90 dernières secondes elle fait 165,5 → 190,0
→ 93,8 Mo : elle varie de plus de 100 Mo en une minute et demie, dans les deux sens.

**Le signal décisif est la mémoire résidente : 119,1–119,2 Mo, plate à 0,1 Mo près, de t = 90 s jusqu'à la fin** —
soit 9 minutes et demie de jeu continu sans le moindre gain. Les mémoires anonyme (~37 Mo) et compressée (~1,5 Mo)
sont tout aussi stables.

**INFERENCE, raisonnable :** l'oscillation de l'empreinte physique avec une résidence plate correspond à des
allocations graphiques transitoires comptées dans l'empreinte (tampons caméra ARKit, redessins de `Canvas`),
allouées puis rendues. Rien dans ces chiffres ne décrit une fuite.

## 4. Thermique

**MEASUREMENT.** `Fair` pendant les 125 premières secondes, puis **`Serious` pendant les 536 suivantes**.

**À ne pas sur-interpréter.** L'appareil avait servi toute la soirée à des compilations, installations et
enregistrements répétés ; la session B, juste avant, le laissait déjà en `Serious`. **Aucune mesure n'attribue cet
état à Iris seul.** Il faudrait une mesure sur appareil froid, au repos depuis plusieurs dizaines de minutes.
Statut : **NOT DETERMINED**.

## 5. Frame pacing

```
FRAME PACING: NOT MEASURED
HITCHES: NOT MEASURED
```

L'instrument `Animation Hitches` fonctionne sur cet appareil (vérifié, 12 s), mais `xctrace` n'enregistre qu'un
modèle à la fois : il aurait fallu une seconde session humaine de 10 minutes. La priorité de ce Gate étant la
croissance mémoire (§12), c'est Activity Monitor qui a été retenu. La donnée humaine correspondante existe par
ailleurs : **aucune latence ressentie**.

## 6. Crash, Jetsam

**MEASUREMENT.** Après chacune des trois sessions, le magasin de rapports d'incident de l'appareil a été recopié
entièrement : **151 fichiers avant, 151 après**. Aucun nouveau Jetsam, aucun crash d'Iris, aucun rapport système
nouveau. La session C s'est terminée par expiration du délai, pas par la mort de l'app.
