# Carte de transfert Android

**Aucun code Android n'est écrit ni commencé.** Ce document prépare intellectuellement un chantier futur et
enregistre les options déjà envisagées. Aucune architecture n'est choisie aujourd'hui.

**Décision en vigueur :** Iris v1 reste 100 % Apple / Swift jusqu'à la publication.

---

## 1. La question préalable

Avant toute architecture, avant tout choix de langage :

> **Le matériel et les API Android permettent-ils un suivi du regard assez précis, stable et réactif pour
> préserver l'expérience d'Iris ?**

**Ne pas présumer que la réponse est oui.** Iris ne demande pas de savoir « où l'utilisateur regarde à peu
près » : la boucle de jeu repose sur une position continue, stable, à faible latence, dont le joueur ressent
l'effet de répulsion image par image. Un suivi médiocre ne donne pas un jeu médiocre — il ne donne pas de jeu.

Ce qu'Iris exige, et qu'il faudra mesurer sur Android avant tout le reste :

| Exigence | Pourquoi elle est critique |
|---|---|
| Précision angulaire suffisante pour distinguer une cible d'un vide voisin | le jeu se joue sur des écarts petits |
| Stabilité — un regard fixe ne doit pas errer | la répulsion amplifie tout tremblement |
| Latence faible et **constante** | le joueur apprend une boucle sensori-motrice ; une latence variable la casse |
| Cadence suffisante | le moteur d'Iris tourne sur des échantillons continus |
| Tenue aux mouvements de tête | validé côté Apple ; à revalider entièrement |
| Calibration atteignable en un temps acceptable | la calibration 9 points est déjà un coût d'entrée |
| Homogénéité entre appareils | Apple a deux modèles TrueDepth ; Android a un parc |

**Ce point est un go / no-go, pas une tâche d'implémentation.** Il se tranche par un prototype jetable mesuré
sur du vrai matériel, avant tout engagement d'architecture.

---

## 2. TRANSFER DIRECTLY

Transférable sans réévaluation matérielle.

| | Réserve |
|---|---|
| **La méthode** — `AI_ASSISTED_ENGINEERING_METHOD.md` en entier | aucune : elle ne parle pas de plateforme |
| Le modèle de niveaux de preuve | aucune |
| Le modèle d'expérimentation réversible | aucune |
| Le modèle de Gates, et ses trois profondeurs | aucune |
| Le gel des sous-systèmes validés | le **contrôle exécutable** devra être réécrit dans l'outillage Android |
| Handoff et protocole de reprise | aucune |
| La discipline Git | aucune |
| La séparation preuve automatisée / preuve humaine | aucune |
| **Les règles de gameplay** — attention indirecte, répulsion, guidage par le côté | c'est le produit, pas la plateforme |
| **La structure de campagne** — 12 chapitres, 82 niveaux, progression, par | données, pas code |
| Les principes de test — bots simulés, tables de gel, tests de frontière | la forme change, l'idée non |
| La discipline de copie — aucune promesse de santé, vocabulaire joueur | tenue par des tests ; à réimplémenter |
| La séparation des couches et son audit exécutable | l'outil change, la règle reste |

**Le cœur physique et mathématique est un candidat au partage** — répulsion, attraction, zone d'attention,
frottement, vitesses, résolution de niveau — parce qu'il ne dépend ni de l'affichage ni du capteur : il consomme
une position normalisée et un temps. **Mais** cela suppose que la position fournie par Android soit de qualité
comparable. Sinon le cœur est portable et inutile.

---

## 3. RE-EVALUATE ON ANDROID

À remesurer intégralement. Aucune mesure Apple ne se transfère.

| Domaine | Ce qu'il faut remesurer |
|---|---|
| **Précision du regard** | l'écart moyen a un sens différent sur un autre capteur |
| **Stabilité** | dérive, bruit, comportement aux bords |
| **Latence** | valeur **et** variance ; la variance compte davantage |
| **Calibration** | la calibration affine 2D et les 9 points doivent être revalidés, pas supposés |
| **Rejet de clignement** | dépend de ce que l'API expose |
| **Accès caméra** | frontale, profondeur ou non, formats, cadence, permissions |
| **Performance** | budget par image, chauffe, mémoire, comportement en arrière-plan |
| **Audio et haptique** | latence et vocabulaire haptique diffèrent |
| **Cycle de vie** | interruptions, multi-fenêtres, changements de configuration : modèle différent, à réapprendre |
| **Parc matériel** | Apple : deux modèles connus. Android : à caractériser, avec un plancher à définir |
| **Distribution** | Play Console, facturation, politiques de revue |
| **Confidentialité** | une caméra frontale continue est examinée de près ; les promesses doivent être revérifiables dans le code |

---

## 4. APPLE-SPECIFIC — ne pas porter directement

| | Équivalent à concevoir, pas à traduire |
|---|---|
| ARKit `ARFaceTrackingConfiguration`, TrueDepth | l'API Android équivalente n'offre pas les mêmes garanties |
| StoreKit 2, `Product.displayPrice`, `Transaction.currentEntitlements` | Google Play Billing a un autre modèle de droits et de vérification |
| Codes d'offre Apple, abonnement promotionnel | mécanique différente |
| Schemes Xcode et configuration StoreKit locale | sans objet |
| App Store Connect, provisioning, `Apple Distribution`, `get-task-allow` | sans objet |
| `PrivacyInfo.xcprivacy` | Play a sa propre déclaration de données |
| `devicectl`, `simctl`, `xctrace` | `adb` et l'outillage Android, à réapprendre |
| Liquid Glass | langage visuel propre à Apple ; l'identité d'Iris devra se redire autrement |
| Identifiants produit `net.steve-s.iris.*` | à recréer côté Play |

**Le piège le plus probable.** Traduire `StoreKitEntitlementService` ligne à ligne vers Play Billing. Ce qui se
transfère est le **contrat** — trois états de droit, priorité `fullAccess > promotionalAccess > free`, le magasin
comme autorité, aucune persistance locale d'un droit, aucun timer maison — pas l'implémentation.

---

## 5. Options d'architecture — aucune n'est choisie

| | Option | Argument | Contre-argument |
|---|---|---|---|
| **A** | iOS Swift natif + Android Kotlin natif | chaque plateforme idiomatique ; outillage IA mature des deux côtés | le moteur et la campagne existent deux fois, et divergeront |
| **B** | cœur Swift partagé + couches natives | une seule vérité pour la physique et la campagne | Swift sur Android reste à évaluer sérieusement : outillage, taille, débogage, cycle de vie |
| **C** | Kotlin Multiplatform | conçu pour ce partage, écosystème actif | le cœur existant est en Swift : réécriture, et donc revalidation complète |
| **D** | Flutter / React Native | une seule interface | **ne pas retenir sans preuve** qu'ils supportent la contrainte regard/matériel et le rendu par image |

**Aucune décision aujourd'hui.** Le choix dépend du résultat de la question préalable (§1) : si la qualité du
regard sur Android impose une implémentation très spécifique, le partage du cœur perd une partie de son intérêt.

---

## 6. Questions à trancher avant de choisir

1. **Qualité de l'API de regard** sur un échantillon représentatif d'appareils — précision, stabilité, latence,
   variance.
2. **Accès caméra** : formats, cadence, profondeur, permissions, comportement en arrière-plan.
3. **Performance** : budget par image, chauffe, mémoire, sur milieu de gamme autant que sur haut de gamme.
4. **Distribution** : politiques de revue, exigences de confidentialité pour une caméra frontale continue.
5. **Testabilité** : existe-t-il un équivalent des bots simulés et des tables de gel ?
6. **Partage du moteur** : le cœur peut-il vraiment être partagé, ou le capteur impose-t-il des divergences ?
7. **Coût de maintenance** : deux plateformes, une personne, un agent — ce qui est soutenable.
8. **Capacité de l'outillage IA** à maintenir les deux plateformes au même niveau de qualité.
9. **Isolation du code plateforme** : où passe exactement la frontière.
10. **Facturation** : `AccessEntitlement` peut-il rester le contrat commun ?
11. **Compatibilité du cœur** physique et gameplay avec une position de regard de qualité différente.
12. **Plancher matériel** : quel appareil le plus faible est encore acceptable, et comment refuser proprement les
    autres — Iris sait déjà le faire côté Apple.

---

## 7. Ce que ce document n'autorise pas

- Ne pas commencer le portage.
- Ne pas choisir d'architecture.
- Ne pas modifier Iris v1 « en prévision » d'Android : c'est de la généralisation spéculative, et elle coûte
  toujours plus cher que ce qu'elle épargne.
- Ne pas supposer que le gameplay survit au changement de capteur. Le savoir demande un prototype mesuré.
