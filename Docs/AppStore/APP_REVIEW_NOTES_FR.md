# Iris — notes pour l'App Review

## Ce qu'est Iris

Iris est un **jeu** contrôlé par le regard. La caméra avant TrueDepth sert à estimer la direction du regard du
joueur ; ce regard **repousse** les sphères à l'écran. Le joueur doit donc apprendre à regarder *à côté* de ce qu'il
veut déplacer, pour l'amener jusqu'à sa cible.

Iris ne promet aucun effet de santé, aucun soin, aucun bénéfice médical. C'est un jeu d'adresse et d'attention.

## Comment tester rapidement

1. **Premier lancement** : quatre écrans expliquent la mécanique. Ils peuvent être passés (bouton « Passer »), et
   revus à tout moment par « Comment jouer » (écran d'accueil, et réglages).
2. **Autorisation caméra** : demandée au premier niveau seulement. Le texte affiché est celui de
   `NSCameraUsageDescription`.
3. **Calibration** : une courte séquence de fixations. Elle se refait depuis Réglages → Recalibrer le regard.
4. **Un appareil avec caméra TrueDepth est nécessaire** (`UIRequiredDeviceCapabilities` contient
   `front-facing-camera`, et le jeu vérifie `ARFaceTrackingConfiguration.isSupported`). Sur un appareil sans
   TrueDepth, Iris affiche un écran d'indisponibilité au lieu de démarrer.
5. **Tenue** : iPhone à hauteur des yeux, à une longueur de bras, lumière régulière.

## Modèle commercial

- L'app est **gratuite** au téléchargement.
- Les **chapitres I, II et III** (19 niveaux sur 82) sont jouables sans aucun achat, pour toujours.
- Les chapitres **IV à XII** demandent l'accès complet.
- L'accès complet est un **achat unique non consommable** : `net.steve_s.iris.unlock.fullgame`.
  Ce n'est pas un abonnement, et l'interface le dit explicitement (« Achat unique. Aucun abonnement, aucun
  renouvellement. »).
- **Le prix affiché vient de StoreKit** (`Product.displayPrice`). Aucun prix n'est écrit dans l'app.
- **« Restaurer mes achats »** est disponible sur l'écran d'accès complet et dans les réglages.

## Le second produit : accès promotionnel

Un abonnement auto-renouvelable `net.steve_s.iris.access.promopass` existe **uniquement** comme véhicule Apple d'un
Offer Code gratuit de 7 jours, configuré sans reconduction.

- Il n'est **jamais** proposé à la vente dans Iris : aucun bouton « S'abonner », aucune page d'abonnement, aucun
  prix affiché pour ce produit.
- L'utilisateur voit seulement « Utiliser un code d'accès », qui présente **la feuille officielle Apple de
  rédemption** (`offerCodeRedemption`).
- Iris **ne reconnaît aucun code par lui-même**. Il n'existe dans le binaire aucune comparaison de chaîne, aucun
  secret, aucune date locale faisant office de licence. Le droit provient exclusivement d'une transaction StoreKit
  vérifiée, et disparaît quand elle expire.
- À l'expiration, le joueur revient aux chapitres gratuits. **Sa progression est conservée** ; seuls les chapitres
  payants se reverrouillent.

## Confidentialité

- Iris **ne contient aucun code réseau** : ni `URLSession`, ni framework Network, ni WebView, ni backend, ni SDK
  tiers, ni analytics, ni tracker, ni crash reporter tiers.
- Aucune image de la caméra n'est enregistrée ni transmise. Les données de visage fournies par ARKit servent au
  calcul du regard, image après image, et ne sont ni stockées ni envoyées.
- Ce qui est conservé sur l'appareil : les coefficients de calibration, la progression de campagne, quatre
  préférences (son, ambiance, vibrations, indicateur de regard) et un indicateur « explication déjà vue ».
- Aucun compte n'est nécessaire. Aucune connexion n'est demandée, sauf celle que StoreKit fait lui-même pour un
  achat ou une restauration.
- `PrivacyInfo.xcprivacy` déclare deux API à raison obligatoire : `NSPrivacyAccessedAPICategoryUserDefaults`
  (`CA92.1`) et `NSPrivacyAccessedAPICategorySystemBootTime` (`35F9.1`). Aucune donnée collectée, aucun tracking.

## Aucun paiement externe

Tout achat passe par StoreKit et par l'App Store. Iris ne contient aucun lien de paiement externe, aucune
redirection vers un site marchand, aucune monnaie interne.

## Points d'attention pour le test

- Le jeu se joue **en portrait uniquement**.
- Le suivi du regard demande quelques secondes de stabilisation après la calibration ; si le visage sort du champ,
  le niveau se met en pause et reprend seul.
- Les mouvements de la tête sont utilisés dans quelques niveaux optionnels de fin de chapitre ; ils sont annoncés à
  l'écran.
