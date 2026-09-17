# Iris — étude de cas

Les faits qui ont produit les principes de `AI_ASSISTED_ENGINEERING_METHOD.md`. **Ce document reste une étude de
cas** : il décrit ce qui s'est passé sur un projet, pas ce qui se passe en général.

---

## 1. Le contexte

Iris est un jeu iOS contrôlé par le regard (ARKit / TrueDepth), développé entre juillet et septembre 2026 par un
propriétaire produit travaillant avec un agent IA. Douze chapitres, 82 niveaux, 567 tests, ~350 fichiers Swift.
Aucun code n'a jamais été poussé sur un remote : `main` est resté à `52f20b7` du début à la fin.

Le projet a traversé quatre Release Gates et une sous-mission, chacun mandaté par un prompt structuré : objectif,
préconditions, interdictions, conditions d'arrêt, format de rapport imposé.

---

## 2. Étude de cas principale — Gate 4A

Le cas qui justifie à lui seul le modèle d'expérimentation réversible.

### Le problème

Le Gate 1 avait mesuré, sur l'iPhone 14 Pro, qu'aucun produit StoreKit n'était retourné :
`appTransaction.environment=(unavailable)`, `result.count=0`. C'était précieux : cet appareil montrait ce qu'un
vrai client verrait, et servait de témoin.

Trois semaines de travail plus tard, le Gate 4 a mesuré sur le **même** appareil :
`environment=Xcode`, deux produits, 2,99 €. Le témoin avait été contaminé.

### Les hypothèses concurrentes

| | Hypothèse |
|---|---|
| **A** | une configuration StoreKit attachée à l'action *Run* du scheme, active lors d'un lancement depuis Xcode |
| **B** | un état de test **persistant au niveau de l'appareil**, établi plus tôt et survivant aux réinstallations |
| **C** | un état lié à l'installation ou à la build |
| **D / E** | autre cause / cause non déterminée |

C a été écartée par mesure : la même build Debug, installée par `devicectl`, donnait `(unavailable)` au Gate 1.

### La piste initiale — et pourquoi elle était mauvaise

La première proposition de l'agent était : **désinstaller Iris de l'appareil**. Plausible — la documentation
d'Apple associe la suppression de l'app à celle de l'environnement de test.

Elle aurait détruit le profil de calibration du regard et les réglages. Et, comme la suite l'a montré, **elle
n'aurait servi à rien** : la cause n'était pas dans l'appareil.

L'inventaire préalable a par ailleurs révélé un fait qui changeait l'enjeu : le plist ne contenait **aucune
progression de campagne**. Le coût réel était plus faible qu'annoncé — ce qui est exactement le genre de chose
qu'on apprend en inventoriant avant de détruire, et jamais en détruisant.

### L'expérience — et son premier échec instructif

Variable discriminante : la configuration StoreKit du scheme. Expérience la moins invasive : la mettre à `None`,
lancer, mesurer, restaurer.

Contrôles : SHA-256 du scheme avant, pendant, après ; `git diff` ciblé montrant **seulement** la suppression
attendue ; sauvegarde des trois fichiers de l'appareil, hashée, hors du dépôt ; copie pristine du scheme pour une
restauration au bit près ; destination du lancement fixée explicitement par UDID.

**Résultat du premier test : `environment=Xcode`.** Inchangé.

Lecture facile et fausse : « l'état est persistant dans l'appareil, il faut désinstaller ». L'agent a failli s'y
arrêter — mais Xcode était **ouvert** pendant l'édition du fichier, et pouvait avoir servi un scheme gardé en
mémoire. Deux lectures restaient possibles :

| | |
|---|---|
| **B1** | « None » appliqué, l'environnement a survécu → état persistant |
| **B2** | scheme en cache, le run a ré-affirmé l'environnement → le test n'a rien montré |

Trois tentatives de discrimination ont échoué, et ont été **consignées** : le `.xcresult` ne mentionne StoreKit
dans aucun des deux runs — y compris celui qui portait la configuration, ce qui **invalide** cette piste comme
preuve ; les journaux de build contiennent la même occurrence sans rapport ; ni `devicectl` ni `simctl` n'ont de
sous-commande StoreKit.

Conclusion rendue : **NOT PROVEN**, ambiguïté nommée. C'est cette honnêteté qui a produit la suite.

### Le second test

Une seule chose a changé : **fermer Xcode avant d'éditer le fichier**, le rouvrir après.

```
Xcode ouvert pendant l'édition  →  environment=Xcode        · 2 produits · 2,99 €
Xcode fermé  pendant l'édition  →  environment=(unavailable) · 0 produit · aucun prix
```

Une troisième lecture, plus tard, par l'app lancée **sans Xcode du tout**, a confirmé `(unavailable)`.

### Le niveau de preuve retenu

```
EFFECT OF XCODE SCHEME           : STRONGLY SUPPORTED
CAUSE HISTORIQUE DE L'ACTIVATION : NOT PROVEN
```

Formulation conservée : *le comportement observé est expliqué par la configuration StoreKit du scheme, et
l'hypothèse d'un état persistant propre à l'appareil n'est plus nécessaire pour rendre compte des résultats.*

Ce qui **n'a pas** été écrit : « l'environnement était dans le scheme et pas dans l'appareil ». Le mécanisme
interne n'a jamais été observé. Et *quand* et *par qui* le premier lancement configuré a atteint l'appareil reste
inconnu : Xcode avait purgé les enregistrements qui l'auraient dit.

### Le bilan

| | |
|---|---|
| Données détruites | **aucune** |
| Désinstallation | aucune |
| Redémarrage | aucun |
| Scheme | restauré au bit près, hash identique, `git diff` vide |
| Second appareil | jamais touché — il était déconnecté |
| Résultat | appareil témoin restauré |

**La leçon généralisable :** quand une hypothèse séduisante recommande une action destructive, elle recommande
surtout de **ne plus pouvoir la tester**. L'expérience réversible ne coûtait qu'une fermeture d'application.

**Et la leçon sous la leçon :** le premier test a donné un résultat ambigu. L'avoir rapporté comme ambigu plutôt
que tranché est ce qui a rendu le second test possible.

---

## 3. Autres cas, plus brefs

### 3.1 — Une régression attrapée par un gel, pas par une relecture

En réécrivant la construction d'un snapshot de rendu, l'agent a perdu une condition qui supprimait la marque de
regard pendant les séquences « tête seule » du chapitre X. Aucune relecture ne l'a vue. Un test existant, qui
vérifiait précisément qu'aucune marque n'est dessinée là, a échoué à la première exécution.

**Leçon.** Les contrôles exécutables attrapent ce que l'attention ne voit pas. Corollaire : un test qui vérifie
une **absence** vaut souvent plus qu'un test qui vérifie une présence.

### 3.2 — Deux erreurs de décompte, toutes deux trouvées par l'humain

Un rapport a annoncé « 36 tests » avec un détail par suite qui totalisait 33. Le total était juste, le détail
faux. Une mission ultérieure a annoncé « 13 tests » avec une description qui en décrivait 12 — deux tests n'avaient
pas été nommés, et deux preuves numérotées étaient couvertes par un seul test.

Dans les deux cas, **l'utilisateur a additionné**. Dans les deux cas, la correction a consisté à mesurer
(`Test run with N tests`) et à corriger la documentation, sans jamais ajouter ni retirer un test pour faire tomber
le compte juste.

**Leçon.** Un agent produit des chiffres cohérents en apparence. Les totaux se vérifient par exécution, jamais par
relecture. Et jamais corriger la réalité pour sauver un rapport.

### 3.3 — Un parseur qui aurait inversé une conclusion

Un premier extracteur de trace de performance, écrit à coups d'expressions régulières, lisait 7 lignes sur 342.
Utilisée telle quelle, la mesure aurait produit une conclusion inverse sur la mémoire.

**Leçon.** Un instrument de mesure a besoin de sa propre validation. Un ordre de grandeur invraisemblable est le
signal le moins cher qui existe.

### 3.4 — Fermer un blocker sans en connaître la cause

Un incident de type Jetsam et des flashs visuels brefs n'ont jamais reçu de cause prouvée. Le Gate 2 les a
néanmoins déclarés non bloquants — **et a écrit, dans le même document, ce qui ferait rouvrir la décision**.

**Leçon.** On peut décider sans preuve complète, à condition de dire à quel niveau de preuve on décide et ce qui
ferait revenir en arrière. La formulation `CAUSE : NOT PROVEN` a survécu à tous les rapports ultérieurs.

### 3.5 — Une fusion évitée parce qu'elle a été vérifiée

Avant de construire une branche de release, l'agent devait « intégrer plusieurs branches ». L'audit a montré que
18 des 22 branches locales étaient **déjà** ancêtres du HEAD, et que les 4 restantes étaient une hypothèse
explicitement rejetée. Aucune fusion n'a eu lieu.

**Leçon.** « Intégrer les branches » est une tâche qu'on croit nécessaire. `git merge-base --is-ancestor` répond
en une seconde.

### 3.6 — Un mandat qui s'interdisait sa propre solution

Le Gate 4A interdisait toute modification de scheme, alors que la voie la moins invasive passait par là. L'agent
l'a signalé au lieu de contourner ; l'utilisateur a levé l'interdiction de façon bornée, et le problème s'est
résolu sans rien détruire.

**Leçon.** Un mandat peut se contredire. Le signaler est plus utile que d'obéir à la lettre ou de contourner en
silence.

### 3.7 — Un verdict humain global, enregistré comme global

L'utilisateur a validé le Gate 3 d'un seul verdict : « passé ». La checklist comptait dix-huit points. Ils ont été
marqués « ✓ ensemble », avec une note disant que le détail n'avait pas été remonté.

**Leçon.** Enregistrer un verdict humain **au grain où il a été donné**. Fabriquer un détail qu'on n'a pas reçu,
c'est fabriquer une preuve.

### 3.8 — Un point déclaré hors critère

VoiceOver n'a pas été testé pour le Gate 3. Il n'a été marqué ni passé ni échoué, mais **NOT REQUIRED FOR GATE 3**,
avec la raison — Iris se joue en regardant l'écran — et trois précisions sur ce que cela **n'autorise pas** :
aucune promesse d'accessibilité aux personnes aveugles, aucun retrait de VoiceOver, aucune dégradation de
l'existant.

**Leçon.** Un troisième état — hors critère — évite de choisir entre mentir et bloquer.

---

## 4. Negative knowledge

Ce que ce projet a appris à **ne pas** conclure. Chaque ligne vient d'un fait ci-dessus.

| Ne pas | Parce que |
|---|---|
| attribuer une cause au flash ou au Jetsam | aucune n'a jamais été démontrée ; `backboardd` a été tué, pas Iris |
| déclarer une régression de performance sans baseline mesurée | le « ralentissement » soupçonné n'a jamais été reproduit |
| détruire une donnée avant d'avoir épuisé les expériences réversibles | la désinstallation proposée aurait été inutile |
| confondre l'environnement de test et le comportement d'un vrai client | deux appareils, même binaire, deux réalités commerciales |
| prendre une installation pour une validation visuelle | installer n'est pas regarder |
| croire un total produit par un agent sans l'avoir exécuté | deux décomptes faux, tous deux trouvés par l'humain |
| conclure d'une expérience dont un cache a pu fausser l'entrée | le premier test de scheme était contaminé |
| supposer qu'une fusion est nécessaire | 18 branches sur 22 étaient déjà dedans |
| traiter « l'hypothèse n'est plus nécessaire » comme « l'hypothèse est fausse » | ce sont deux affirmations différentes |
| considérer qu'un `git diff` vide prouve une restauration | il ne dit rien d'un fichier ignoré ; le hash, si |
| supposer l'état d'un service externe non consulté | App Store Connect est resté `NOT DETERMINED` du début à la fin |
| croire qu'un code prêt signifie une archive prête | signature développement, App ID générique, `get-task-allow=true` |

---

## 5. Ce que cette étude de cas ne montre pas

- **Aucun groupe témoin.** Le projet n'a pas été mené deux fois, avec et sans méthode.
- **Le coût n'a pas été mesuré.** Le temps passé en audits et en rapports n'a jamais été comparé à ce qu'il a fait
  gagner.
- **Un seul domaine.** Application Apple, matériel spécialisé, paiements, publication. Coûts d'erreur élevés.
- **Une seule échelle.** Un humain, un agent, en série.
- **Un biais de survie.** Les règles qui ont attrapé quelque chose sont visibles ; celles qui n'ont jamais rien
  attrapé sont invisibles — et ce sont précisément celles qu'il faudrait supprimer.
