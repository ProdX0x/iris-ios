# 02 — Protocole de mesure de performance

## 1. Instruments réellement disponibles

**FACT.** `xcrun xctrace list templates` sur cette machine (Xcode 26.3, 17C529) :

```
Activity Monitor · Allocations · Animation Hitches · App Launch · Audio System Trace · CPU Counters ·
CPU Profiler · Core ML · Data Persistence · File Activity · Game Memory · Game Performance ·
Game Performance Overview · Leaks · Logging · Metal System Trace · Network · Power Profiler ·
Processor Trace · RealityKit Trace · Swift Concurrency · SwiftUI · System Trace · Tailspin · Time Profiler
```

Aucun nom n'a été supposé : seuls des modèles de cette liste ont été utilisés.

## 2. Ce que l'appareil accepte, et ce qu'il refuse — mesuré

| Forme | Résultat |
|---|---|
| `--template "Activity Monitor" --all-processes` | **refusé** : « An unknown problem is preventing this device from recording » (reproduit 3 fois) |
| `--template "Activity Monitor" --launch -- net.steve-s.iris` | **refusé**, même message |
| `--template "Activity Monitor" --attach Iris` | **fonctionne** |
| `--template "Time Profiler" --attach Iris` | **fonctionne** |
| `--template "Animation Hitches" --attach Iris` | **fonctionne** |
| `--attach <pid>` sur un pid obtenu par `devicectl` | **échoue** : « Cannot find process for provided pid » |
| `--attach backboardd` | **échoue** : « Cannot find process matching name » |

**Conséquence, et c'est une limite réelle de cette mission :** `backboardd` **ne peut pas être échantillonné
directement** avec l'outillage disponible. La mémoire système globale l'est, elle (`sysmon-system`), et sert de
mesure de substitution — en le disant.

## 3. La seule séquence qui fonctionne

`xctrace` ne retrouve le processus que s'il vient d'être lancé dans la **même** commande :

```sh
xcrun devicectl device process launch --device <CoreDevice-UUID> --terminate-existing net.steve-s.iris \
  && sleep 5 \
  && xcrun xctrace record --device <UDID-matériel> --template "Activity Monitor" --attach Iris \
       --time-limit 11m --no-prompt --output session.trace
```

Lancer l'app puis enregistrer dans une commande séparée échoue (« Cannot find process matching name: Iris »),
mesuré deux fois. L'app est donc **relancée** au début de chaque mesure : le scénario commence par un lancement
propre, ce que demande le protocole de toute façon.

## 4. Ce que la trace contient

Tables exploitées, et leur cadence mesurée : `sysmon-process` (Iris, **~1 échantillon/s**), `sysmon-system`
(mémoire système, même cadence), `device-thermal-state-intervals` (état thermique et sa durée).

Colonnes mémoire disponibles pour Iris : `memory-physical-footprint`, `memory-resident-size`, `memory-anonymous`,
`memory-compressed`, `memory-purgeable`, `memory-real-private`, `memory-real-shared`, `memory-virtual-size`.

Lecture : `Docs`-hors-dépôt `analyse2.py` (répertoire de travail de session) résout la table id/ref de `xctrace` —
un analyseur naïf par expressions régulières **perd des lignes** : la première version en a lu 7 au lieu de 342. Ce
piège est consigné parce qu'il aurait faussé toutes les conclusions.

## 5. Le scénario humain demandé

Lancement propre · calibration complète · Seuil · Chapitres · un niveau gratuit (chapitres I–III) joué réellement ·
pause puis reprise · retour Chapitres · un second niveau gratuit joué · retour Seuil. Durée visée : 10 à 12 minutes.

Contraintes respectées : aucune installation pendant la mesure, aucun changement de bundle id, aucune autre variante
d'Iris lancée, aucun stress artificiel.

## 6. Comment on vérifie qu'un humain a réellement joué

**Ce point est décisif** : une app laissée ouverte n'est pas une session, et le protocole interdit de la présenter
comme telle. Une signature mesurée permet de trancher sans témoignage.

**MEASUREMENT — run de contrôle**, app forcée sur l'écran de jeu avec ARKit (`--iris-route game --iris-level 1-1`),
60 s : empreinte 36–70 Mo, **jusqu'à 14 threads**, CPU jusqu'à **26 %**.

**MEASUREMENT — app au repos sur le Seuil**, 351 s : empreinte **constante à 24,6 Mo**, **6 threads**, CPU ≤ 10,4 %.

Critère retenu : **threads ≥ 10 et empreinte > 36 Mo ⇒ session AR active**. Il a servi à rejeter une première
mesure (document 03, §1) où aucun jeu n'avait eu lieu.

## 7. Variables de contexte entre les deux appareils (§9 bis)

| | iPhone 14 Pro | iPhone 15 Pro |
|---|---|---|
| Environnement StoreKit | aucun (`appTransaction.environment` indisponible) | **`Xcode`** persistant |
| Droit commercial observé | `free` | `fullAccess` simulé |

Les deux téléphones ne sont donc **pas** dans un état commercial identique. Le scénario n'utilise que des chapitres
gratuits (I–III) et ne touche ni paywall, ni achat, ni restauration, ni contenu réservé au `fullAccess`. Cet écart
est consigné comme contexte ; **aucun effet sur CPU, mémoire ou rendu ne lui est attribué**, faute de mesure.

Le 15 Pro ne représente pas l'état commercial d'un utilisateur de production tant que son environnement de test
n'est pas purgé.
