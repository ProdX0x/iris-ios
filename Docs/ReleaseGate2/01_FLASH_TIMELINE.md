# 01 — Flash : chronologie et preuves

Étiquettes : **FACT** · **MEASUREMENT** · **INFERENCE** · **UNKNOWN** · **NOT REPRODUCED**.

## 1. Ce qui est rapporté

| | Flash A | Flash B |
|---|---|---|
| Heure | **~10:30**, heure française, 16 septembre 2026 | **UNKNOWN** |
| Appareil | iPhone 14 Pro | iPhone 14 Pro |
| Effet | changement très bref d'apparence de l'écran | idem, ultra-bref |
| Crash | non | non |
| Blocage / perte de progression | non | non |
| Conséquence fonctionnelle | **aucune** | **aucune** |

**FACT.** Aucun des deux épisodes n'a eu de conséquence fonctionnelle.

## 2. Tous les diagnostics que l'appareil conserve

**MEASUREMENT.** Le magasin de rapports d'incident du 14 Pro a été copié **en entier** trois fois ce soir
(`devicectl device copy from --domain-type systemCrashLogs --source .`) : 151 fichiers.

Fichiers datés du 16 septembre 2026 — **la liste est complète, il y en a deux** :

| Horodatage interne | Fichier | Processus dominant |
|---|---|---|
| 2026-09-16 04:54:47 | `JetsamEvent-2026-09-16-045447.ips` | **backboardd** |
| 2026-09-16 16:35:02 | `JetsamEvent-2026-09-16-163502.ips` | **TikTok** |

**Il n'existe aucun rapport autour de 10:30.** Ni Jetsam, ni panic, ni crash, ni watchdog, ni thermal, ni rapport
nommant Iris, `SpringBoard`, `backboardd`, `FrontBoard` ou `runningboardd`.

**Nuance obligatoire.** Un `.ips` n'existe que si le système tue un processus ou détecte une faute. Un flash qui
n'aurait tué personne ne laisse, par construction, **aucune trace**. L'absence mesurée n'est donc **pas** une preuve
que rien n'a eu lieu à 10:30.

## 3. L'événement de 16:35 — ce qu'il dit, et ce qu'il ne dit pas

**MEASUREMENT**, lu dans le fichier :

| Champ | Valeur |
|---|---|
| `largestProcess` | **TikTok**, 1128,3 Mo, `active, frontmost` |
| Mémoire libre | 22,1 Mo |
| Processus recensés | 498 |
| Tués pour pression mémoire (hors `long-idle-exit`) | **2** : `Spotlight` (`highwater`), **`SBRendererService` (`fc-thrashing`)** |
| `backboardd` | 185,5 Mo — **non tué** (pic depuis le démarrage : 1341,6 Mo) |
| `SpringBoard` | 180,6 Mo — non tué |
| **Iris** | **absent de la liste des 498 processus** |

**FACT : Iris ne tournait pas à 16:35:02.**

**INFERENCE, non prouvée :** `SBRendererService` est le service de rendu de SpringBoard. Sa mort et son
redémarrage sont un mécanisme **plausible** de bref défaut visuel à l'échelle du système. Si le flash B a eu lieu
vers 16:35, il serait alors **extérieur à Iris**. Rien ne le démontre : l'heure du flash B est inconnue.

## 4. Historique des Jetsam de cet appareil — la mise en perspective

**MEASUREMENT.** Les 16 `JetsamEvent` conservés par l'appareil, sur environ quatre semaines :

| Date | Processus dominant | backboardd | tué ? | pic backboardd | Iris présent |
|---|---|---|---|---|---|
| 08-21 04:02 | Twitter | 188 Mo | non | 962 Mo | non |
| 08-22 13:14 | **backboardd** | 571 Mo | non | 962 Mo | non |
| 08-23 11:12 | **backboardd** | 465 Mo | non | 962 Mo | non |
| 08-27 03:47 | kernel_task | 221 Mo | non | 1563 Mo | non |
| 08-27 14:15 | WebKit.WebContent | 189 Mo | non | 811 Mo | non |
| 09-03 03:38 | TikTok | 159 Mo | non | 989 Mo | non |
| 09-03 15:30 | **backboardd** | 704 Mo | non | 989 Mo | non |
| 09-05 19:10 | TikTok | 184 Mo | non | 969 Mo | non |
| 09-06 18:04 | kernel_task | 169 Mo | non | 702 Mo | non |
| 09-07 02:23 | cameracaptured | 497 Mo | non | 500 Mo | non |
| 09-07 12:36 | **backboardd** | 338 Mo | non | 474 Mo | non |
| 09-08 00:26 | **backboardd** | 502 Mo | non | 527 Mo | non |
| 09-09 19:09 | kernel_task | 209 Mo | non | 985 Mo | non |
| 09-10 14:49 | TikTok | 501 Mo | non | 985 Mo | non |
| **09-16 04:54** | **backboardd** | **3072 Mo** | **OUI (`highwater`)** | **3072 Mo** | **OUI** |
| 09-16 16:35 | TikTok | 186 Mo | non | 1342 Mo | non |

Trois faits en sortent :

1. **Le Jetsam est une routine sur cet appareil** : 16 événements en quatre semaines.
2. **`backboardd` est le processus dominant dans 6 des 16**, tous **sans Iris**. Son pic atteint régulièrement
   474 à 1563 Mo **sans Iris**, et 1342 Mo aujourd'hui même.
3. **Iris n'apparaît que dans un seul des 16** — celui du 04:54 — et c'est le seul où `backboardd` a été tué.

## 5. Tentative de reproduction

**MEASUREMENT.** Trois enregistrements instrumentés sur le 14 Pro ce soir, dont un de **11 minutes de jeu réel**
(voir document 03). Au total environ 18 minutes d'application au premier plan, dont ~12 de jeu effectif.

```
FLASH REPRODUCED DURING CONTROLLED TEST: NO  →  NOT REPRODUCED
NEW JETSAM DURING OR AFTER THE SESSIONS: NO   (magasin recopié après chaque session : toujours 151 fichiers)
APP CRASH: NO                                 (fins de session : « Time limit reached » ou exit(0) propre)
```

**NOT REPRODUCED n'est pas une preuve d'impossibilité.** Deux épisodes réels ont été observés par une personne.

## 6. Ce qui manque, et c'est la seule chose qui manque

**UNKNOWN : l'heure du flash B**, et ce que faisait Iris à ce moment (menu, calibration, jeu, pause, retour
d'arrière-plan).

Pour que le prochain épisode soit exploitable, une instrumentation **DEBUG uniquement** a été ajoutée
(`App/Diagnostics/LifecycleTrace.swift`) : elle horodate les changements de cycle de vie de scène, les
avertissements mémoire, les changements d'état thermique et les changements d'accessibilité, dans un fichier du
conteneur de l'app. Elle n'affiche rien et ne change aucun comportement ; **elle est absente de Release** (0 symbole,
vérifié sur le binaire signé).

Récupération après un futur épisode :

```sh
xcrun devicectl device copy from --device CD9242BD-9650-52C9-BBA6-A30490C6DFA8 \
  --domain-type appDataContainer --domain-identifier net.steve-s.iris \
  --source Documents/iris-lifecycle.log --destination /tmp/iris-lifecycle.log
```
