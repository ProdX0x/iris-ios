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
| Rapports d'incident iPhone synchronisés sur le Mac | `ls ~/Library/Logs/CrashReporter/MobileDevice/` | **répertoire vide** |
| Tout fichier `.ips` récent sur le Mac | `find … -name "*.ips" -newermt 2026-09-16` | 7 fichiers, **tous macOS** ; aucun venant d'un iPhone |
| Diagnostic complet de l'appareil | `devicectl device sysdiagnose` | **échec** : `CoreDeviceCLISupport.DiagnoseError error 0` |
| **Magasin de rapports d'incident de l'iPhone 14 Pro lui-même** | `devicectl device copy from --domain-type systemCrashLogs --source .` | **succès : 149 fichiers récupérés** |

La quatrième piste est celle qui tranche. **MEASUREMENT**, 16 septembre 2026 : le magasin de rapports d'incident de
l'appareil a été copié en entier et inventorié.

| Recherche dans les 149 fichiers | Résultat |
|---|---|
| Fichiers datés du **2026-09-16** | **exactement un** : `JetsamEvent-2026-09-16-045447.ips` — celui déjà connu |
| `JetsamEvent-…` postérieur à 04:54:47 | **aucun** |
| Rapport d'incident nommant **Iris** | **aucun** |
| Rapport nommant `backboardd` ou `SpringBoard` | **aucun** |
| Jetsam les plus récents avant celui-ci | 2026-09-10, 09-09, 09-08, 09-07 (×2), 09-06, 09-05 |

```
NEW EVIDENCE FOUND: NO
NEW JETSAM/CRASH REPORT: NO   (recherche exhaustive sur l'appareil, pas seulement sur le Mac)
```

**Nuance indispensable.** « Aucun nouveau rapport » ne veut pas dire « rien ne s'est passé ». Un `JetsamEvent`
n'est écrit que si le noyau tue un processus pour cause de mémoire. Un flash qui n'aurait tué aucun processus ne
laisse, par construction, aucun rapport. L'absence mesurée ici **écarte une seule hypothèse** — celle d'un nouveau
jetsam — et n'en confirme aucune.

**Note de confidentialité.** Les 149 fichiers récupérés concernent tout l'appareil, pas seulement Iris, et
contiennent des informations personnelles. Ils ont été gardés hors du dépôt, dans le répertoire de travail
temporaire de la session, et **ne sont pas versionnés**. Seul l'inventaire ci-dessus est conservé.

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

## 4. Ce qui reste à faire, et qui est humain

La recherche automatique est **terminée et exhaustive** pour ce que l'appareil conserve : il n'y a rien de nouveau.
Ce qui manque n'est donc plus un fichier, c'est **l'heure de l'épisode**.

> Demande à la personne qui l'a observé : **à quelle heure, à la minute près si possible, le flash est-il survenu**,
> et **que faisait Iris à ce moment** (menu, calibration, jeu, mise en pause, retour d'arrière-plan) ?

Avec une heure, la corrélation redevient possible au Gate 2 — par exemple par un `xctrace` enregistré pendant une
session de jeu, ou par le journal unifié de l'appareil restreint à cette fenêtre. Sans elle, aucune corrélation ne
peut être tentée, même sur des données qui existeraient.

## 5. Conclusion

```
FLASH INCIDENT CAUSE: NOT DETERMINED
```

Rien n'a été modifié dans le rendu. Ni `DSSpectralEnvironment`, ni le Liquid Glass, ni les dégradés, ni
CoreAnimation, ni les overlays n'ont été touchés — conformément au §16 du mandat. Le sujet est renvoyé au
Release Gate 2, avec une donnée d'entrée précise : **chercher un Jetsam de `backboardd`, pas un plantage d'Iris.**
