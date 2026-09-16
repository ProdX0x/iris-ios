# 07 — Épisode de flash / changement brutal de couleur : inventaire des preuves

Mandat : **ne rien modifier au rendu**. Recenser, préserver, conclure honnêtement.

---

## 1. Ce qui est rapporté

**OBSERVATION** (rapport humain, non horodaté) : sur l'iPhone 14 Pro, un nouvel épisode de flash / changement
brutal de couleur, **sans plantage de l'application** cette fois.

Aucune heure n'a été communiquée. **UNKNOWN : l'heure de l'épisode.** Sans elle, aucune corrélation avec un
journal n'est possible, même si un journal existait.

## 2. Recherche de nouvelles preuves — ce qui a été fait

| Piste | Commande | Résultat |
|---|---|---|
| Rapports d'incident iPhone synchronisés sur le Mac | `ls ~/Library/Logs/CrashReporter/MobileDevice/` | **répertoire vide** — aucun appareil n'y a déposé de rapport |
| Tout fichier `.ips` récent sur le Mac | `find ~/Library/Logs ~/Downloads ~/Desktop <dépôt> -name "*.ips" -newermt 2026-09-16` | 7 fichiers, **tous macOS** (`TypeToSiriWidgetExtension`, `ExcUserFault_Xcode`, `ExcUserFault_TestFlightServiceExtension`) ; **aucun venant d'un iPhone**, sauf le JetsamEvent déjà connu |
| Diagnostic complet de l'appareil | `xcrun devicectl device sysdiagnose --device <14 Pro>` | **échec** : `CoreDeviceCLISupport.DiagnoseError error 0` — aucun fichier produit |
| Journal de la console pendant un lancement | `devicectl device process launch --console` | ne transmet que la sortie standard du processus, **pas** `os_log` ; aucun événement graphique système n'y apparaît |

**NEW EVIDENCE FOUND : NO.**
**NEW JETSAM/CRASH REPORT : NO** (côté Mac ; l'appareil n'a pas été consulté, voir §4).

## 3. Preuve précédente — préservée et revérifiée

Le fichier `JetsamEvent-2026-09-16-045447.ips` déposé par l'utilisateur à la racine du dépôt est **intact,
non suivi par Git, non modifié, non déplacé**. Relu pour ce document :

| Champ | Valeur |
|---|---|
| `bug_type` | `298` (Jetsam) |
| `os_version` | `iPhone OS 26.5.2 (23F84)` — **la version exacte de l'iPhone 14 Pro** |
| `timestamp` | `2026-09-16 04:54:47 +0200` |
| `largestProcess` | **`backboardd`** |
| `pageSize` | 16384 octets |
| pages libres au moment du relevé | 1156 → **≈ 18,9 Mo** |

**Fait à retenir, et il oriente la suite :** lors de l'incident du 16 septembre à 04:54, **Iris n'avait pas planté
non plus**. C'est `backboardd` — le serveur d'affichage du système — qui a été tué. Un flash suivi d'un
rallumage de l'interface sans plantage de l'app est exactement la signature d'un redémarrage de `backboardd`.

**INFERENCE, explicitement non prouvée :** le nouvel épisode pourrait être du même genre. Si c'est le cas, il aura
laissé **un nouveau `JetsamEvent-…​.ips` sur l'appareil**, et non un rapport de plantage d'Iris — ce qui explique
qu'aucun rapport d'Iris n'existe. **Cela ne peut pas être affirmé sans le fichier.**

## 4. La seule action qui peut trancher, et elle est humaine

Le `sysdiagnose` a échoué et, même réussi, il collecte des données personnelles (Apple lui-même prévient qu'il
contient nom, numéros de série, position des deux derniers jours, adresses IP, adresse e-mail). Il n'a pas été
insisté.

La voie sûre est celle déjà employée pour le fichier précédent :

> Sur l'iPhone 14 Pro : **Réglages → Confidentialité et sécurité → Analyse et améliorations → Données d'analyse**.
> Chercher un fichier dont le nom commence par **`JetsamEvent-2026-09-16-`** (ou une date ultérieure) **postérieur
> à 04:54:47**. S'il existe, le partager tel quel.

Chercher également, dans la même liste, tout fichier au nom de `backboardd`, `SpringBoard` ou `Iris` daté du jour.

## 5. Conclusion

```
FLASH INCIDENT CAUSE: NOT DETERMINED
```

Rien n'a été modifié dans le rendu. Ni `DSSpectralEnvironment`, ni le Liquid Glass, ni les dégradés, ni
CoreAnimation, ni les overlays n'ont été touchés — conformément au §16 du mandat. Le sujet est renvoyé au
Release Gate 2, avec une donnée d'entrée précise : **chercher un Jetsam de `backboardd`, pas un plantage d'Iris.**
