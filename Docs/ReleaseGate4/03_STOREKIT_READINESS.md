# 03 — État réel de StoreKit

Audit de code + mesure sur appareil, 17 septembre 2026.

## L'architecture produit, vérifiée dans le code

| Attendu | Constaté | Où |
|---|---|---|
| Téléchargement gratuit | oui — aucun paywall au lancement | `Domain/Access/AccessPolicy.swift` |
| 3 chapitres gratuits | `freeChapterCount = 3`, **une seule définition** | `Domain/Access/AccessPolicy.swift:11` |
| Déblocage = non consommable | `net.steve-s.iris.unlock.fullgame` | `Commerce/Products/StoreProductID.swift:9` |
| Accès promotionnel | `net.steve-s.iris.access.promopass` | `StoreProductID.swift:14` |
| États d'entitlement | `free` / `promotionalAccess` / `fullAccess` | `Domain/Access/AccessEntitlement.swift` |
| Priorité | `fullAccess > promotionalAccess > free` | `StoreKitEntitlementService.swift:63-84` |
| Prix jamais codé en dur | `Product.displayPrice`, rien d'autre | `StoreKitEntitlementService.swift:102` |

Les deux identifiants n'existent **qu'une fois** dans le code produit. Un test échoue si un autre fichier source
en contient un : `CommerceBoundaryTests` test C. Idem pour `freeChapterCount` (test D).

## Ce que le code fait vraiment

**Vérification.** Une transaction non vérifiée est refusée dans les trois chemins — lecture des droits, mise à
jour de fond, résultat d'achat — et n'est jamais `finish()`. Filtres supplémentaires sur une transaction vérifiée :
non révoquée, non remplacée, non expirée, identifiant connu.

**Aucune persistance locale de droit.** L'entitlement vit en mémoire et est reconstruit à chaque lecture depuis
`Transaction.currentEntitlements`. Aucun `UserDefaults`, aucun Keychain, aucun fichier. Un test bannit du code
produit les mots `hasPromo`, `isUnlockedForever`, `hasPurchased`, `premiumEnabled`, `trialStartDate`,
`promoExpiry`. **Aucun drapeau local ne peut donc survivre à une promo expirée : il n'y a pas de drapeau.**

**Aucun système maison.** Pas de licence, pas de minuterie promotionnelle, pas d'expiration calculée localement.
Le seul `expirationDate` comparé vient de la transaction vérifiée elle-même, et ne peut que *retirer* un droit.
Le code promotionnel passe par la feuille d'Apple ; un test échoue si `IRIS7D` apparaît dans une source, et exige
que le fichier de rachat ne contienne aucun `==`.

**Hors ligne.** Un achat déjà fait reste valable : `currentEntitlements` se lit sur le reçu local. Le prix
devient inconnu, le bouton d'achat se désactive, une phrase l'explique, et les chapitres gratuits restent ouverts.

**Zéro produit retourné.** Traité exactement comme hors ligne : pas de prix, pas d'achat possible, jeu gratuit
intact. C'était le cas mesuré de l'iPhone 14 Pro au Gate 1.

**Frontière de couche.** `import StoreKit` existe dans exactement trois fichiers : les deux de `Commerce/` et
`Features/Paywall/OfferCodeRedemption.swift`, qui présente la feuille de rachat d'Apple. Cette liste exacte est
épinglée par un test. À noter : c'est `CommerceBoundaryTests` qui tient cette garantie, pas `Tools/audit.py` —
la table C1 du script n'a pas d'entrée `Presentation`.

## Preuve d'exécution

Les 17 tests d'entitlement **passent pour de vrai** sur le runtime iOS 18.6 (document 02). Sur iOS 26.3 ils se
dégradent en *known issues* parce que le runtime refuse les sessions de test StoreKit — limitation d'outil, pas
défaut d'Iris.

## Les appareils : les deux sont désormais pollués

Mesure du 17 septembre 2026, lue dans `Documents/iris-storekit.log` de chaque appareil.

| | iPhone 14 Pro (`iPhone15,2`, iOS 26.5.2) | iPhone 15 Pro (`iPhone16,1`, iOS 26.6.1) |
|---|---|---|
| Gate 1 (16 sept.) | `result.count=0` · `environment=(unavailable)` · `StoreKitError/2` | `result.count=2` · `2,99 €` · `environment=Xcode` |
| **Gate 4 (17 sept., 07:15 UTC)** | **`result.count=2` · `2,99 €` · `environment=Xcode`** | `result.count=2` · `2,99 €` · `environment=Xcode` |

**L'iPhone 14 Pro a acquis à son tour un environnement de test StoreKit Xcode persistant.** C'était, au Gate 1,
le seul appareil capable de montrer ce qu'un vrai client verrait. Il ne l'est plus.

Conséquence directe : **aucun des deux appareils ne peut aujourd'hui servir de preuve d'une expérience StoreKit
réelle.** Les deux voient des produits simulés, au prix simulé, avec un `appTransaction.environment=Xcode` qui
n'a rien à voir avec la production.

### Comment vérifier l'état, et comment revenir à un environnement propre

Vérifier — sans rien modifier :

```
xcrun devicectl device copy from --device <UDID> --domain-type appDataContainer \
  --domain-identifier net.steve-s.iris --source Documents/iris-storekit.log --destination ./sk.log
```

puis lire `appTransaction.environment` : `Xcode` = environnement de test ; `Sandbox` ou `Production` = réel.
Ce fichier n'existe que dans une build **Debug** ; il ne contient ni compte Apple, ni jeton, ni reçu.

Étapes sûres, documentées par Apple, pour revenir à un environnement propre — **non exécutées ici** :

1. Désinstaller Iris de l'appareil (l'environnement de test est attaché au conteneur de l'app).
2. Dans Xcode, `Product → Scheme → Edit Scheme → Run → Options`, mettre **StoreKit Configuration** à `None`,
   puis relancer une fois depuis Xcode sur l'appareil.
3. Sur l'appareil, `Réglages → Développeur → StoreKit` (section présente quand le mode développeur est actif) :
   vérifier qu'aucune configuration locale n'est sélectionnée.
4. Réinstaller une build **Release** signée pour distribution, se connecter avec un compte **Sandbox** créé dans
   App Store Connect, et relire `appTransaction.environment`.

Aucune suppression destructive n'est proposée, et aucune n'a été tentée.

## App Store Connect

**NOT DETERMINED.** Aucun accès à App Store Connect n'a été utilisé, ni à ce Gate ni aux précédents. Rien dans le
dépôt ne prouve que `net.steve-s.iris.unlock.fullgame` ou `net.steve-s.iris.access.promopass` y existent, ni
qu'un contrat payant soit signé. Tant que ce n'est pas fait, tout appareil sain se comportera comme l'iPhone
14 Pro du Gate 1 : aucun produit, aucun prix, achat impossible.

## Points ouverts trouvés dans le code

Aucun n'est corrigé ici — le mandat l'interdit.

1. **La restauration hors ligne dit une chose que l'app n'a pas établie.** `restorePurchases()` avale l'erreur de
   `AppStore.sync()` et conclut sur le seul entitlement, donc annonce « Aucun achat à restaurer sur ce compte
   Apple » alors que l'App Store était simplement injoignable. Un client payant, hors ligne, s'entend dire que
   son compte ne contient rien. Ce comportement est actuellement épinglé par un test.
2. **Aucun rafraîchissement des droits au retour au premier plan.** Une expiration d'abonnement n'émet pas
   toujours un événement `Transaction.updates` ; un accès promotionnel expiré peut rester en mémoire jusqu'au
   prochain lancement.
3. **`PaywallCopy.promotionalAccessEnded` n'a aucun appelant.** Le joueur dont la promo se termine revient aux
   chapitres gratuits sans explication.
4. **Un prix peut devenir périmé.** Après un chargement réussi puis un échec, l'ancien `Product` reste en mémoire
   et le bouton d'achat reste actif, au lieu de l'état « prix inconnu » que la copie promet.
5. **`StaticEntitlementService.samplePrice = "4,99 €"`** est une chaîne monétaire compilée en Release, atteignable
   par aucun chemin d'exécution (elle ne sert qu'aux `#Preview`), mais présente dans le binaire.

## Verdict

```
STOREKIT — CODE : PARTIAL
```

L'architecture est correcte, centralisée, testée et désormais **prouvée à l'exécution**. Ce qui manque n'est pas
de l'architecture : c'est App Store Connect (non déterminé), un App ID explicite portant l'achat intégré
(absent), un environnement d'appareil propre (perdu sur les deux téléphones), et quatre imprécisions de
comportement dont une est visible par un client payant.
