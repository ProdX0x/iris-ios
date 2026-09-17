# 08 — Release Gate 4 : rapport

Audit du 17 septembre 2026. Branche `release/iris-appstore-rc1`, créée depuis `42ca32a`.
**Aucun code produit n'a été modifié.** Le diff de ce Gate ne contient que `Docs/ReleaseGate4/`.

## Les six questions posées

| | Question | Réponse |
|---|---|---|
| 1 | Tous les travaux validés sont-ils dans une seule lignée ? | **Oui.** 87 commits, 0 merge. Seules les branches Braises B — hypothèse rejetée et documentée — restent dehors |
| 2 | Une Release Candidate propre peut-elle être créée ? | **Oui, elle l'est** : `release/iris-appstore-rc1`, sans modification |
| 3 | Le binaire Release est-il techniquement prêt ? | **Le code oui, l'archive non.** Trois faits de signature l'interdisent |
| 4 | La fiche et la confidentialité sont-elles prêtes ? | **Confidentialité : oui. Fiche : partiellement** — deux URL obligatoires manquent, les captures n'existent pas |
| 5 | Quel est l'état réel de StoreKit ? | **Code correct et désormais prouvé à l'exécution.** App Store Connect non déterminé, les deux appareils pollués |
| 6 | Que reste-t-il d'externe ? | Document 07 — quatorze points, dont trois contrats/services Apple |

## Ce que ce Gate a gagné

**Les 17 « known issues » StoreKit n'en sont plus.** Le dépôt documentait qu'elles venaient du runtime iOS 26.3,
pas du code. Le contournement a été exécuté sur le simulateur iOS 18.6 déjà présent : **17 tests sur 17 passent
pour de vrai, zéro known issue**. Achat vérifié, achat refusé, révocation, restauration, code promotionnel, fin
d'accès promotionnel : démontrés.

## Ce que ce Gate a perdu

**L'iPhone 14 Pro a acquis un environnement de test StoreKit Xcode persistant.** Au Gate 1 il retournait zéro
produit — c'était le seul appareil montrant ce qu'un vrai client verrait. Le 17 septembre à 07:15 UTC il retourne
deux produits à 2,99 € avec `appTransaction.environment=Xcode`, comme le 15 Pro.

**Aucun des deux téléphones ne peut plus servir de preuve d'une expérience StoreKit réelle.** La marche à suivre
pour revenir à un environnement propre est au document 03 ; elle n'a pas été exécutée.

## Les trois faits qui interdisent l'archive

```
Authority       = Apple Development: Stéphane SAULNIER (NKN63DTRM4)
Profil          = "iOS Team Provisioning Profile: *"
get-task-allow  = true
```

1. Release est signée **Apple Development** ; une archive exige **Apple Distribution**.
2. `get-task-allow = true` est une entitlement de développement ; l'App Store refuse le binaire.
3. Le profil porte un **App ID générique** `*`, qui **ne peut pas** porter l'achat intégré.

Les trois touchent la signature, interdite par ce mandat. Elles sont consignées au document 07.

## Les blocages, par ordre de ce qui coûte le plus longtemps

| | Blocage | Qui peut le lever |
|---|---|---|
| 1 | Contrat Applications payantes, fiscalité, banque | **Apple** — délai non maîtrisé, et sans lui rien ne se teste |
| 2 | App ID explicite + In-App Purchase + profil de distribution | portail développeur |
| 3 | Les deux produits créés dans App Store Connect | humain |
| 4 | Signature de distribution (`Apple Distribution`) | modification de projet, autorisation requise |
| 5 | URL de politique de confidentialité et URL de support | hébergement |
| 6 | Captures 6,9″ + capture de relecture de l'achat | **local, faisable tout de suite** |
| 7 | Description de l'achat : deux versions concurrentes | décision produit |

## État vérifié du produit

```
567 tests · 80 suites · 0 échec · 5 ignorés · 17 known issues (iOS 26.3)
        dont les 17 prouvées séparément sur iOS 18.6 : 17/17, 0 known issue
Debug simulateur ✓   Release simulateur ✓   Release appareil signé ✓
Tools/audit.py : C1 C2 C8 C9 C10 C12 verts, 349 fichiers
Bundle Release : PrivacyInfo.xcprivacy à la racine, aucun framework tiers, aucun dossier Frameworks/
Instruments de développement : 0 symbole, sauf OculomotorTrace (compilé, jamais instancié)
Bundle net.steve-s.iris · version 1.0 · build 1 · iOS 17.0 minimum · équipe G4U9RG5GL7
```

## Quatre états qu'il ne faut pas confondre

| | |
|---|---|
| **Code prêt** | **OUI** — construit, testé, audité, et la logique d'achat prouvée à l'exécution |
| **Archive prête** | **NON** — signature de développement, App ID générique, `get-task-allow = true` |
| **App Store Connect configuré** | **NON DÉTERMINÉ** — aucun accès n'a été utilisé ; rien ne prouve que les produits existent |
| **Application prête à être soumise** | **NON** — aucune capture, deux URL obligatoires manquantes, aucun achat en bac à sable jamais observé |

## Verdict

```
GATE 4 : PARTIAL
PRÊT À CRÉER UNE ARCHIVE APP STORE : NON
PRÊT À SOUMETTRE À APPLE : NON
```

La prochaine action à plus forte valeur est celle qui ne dépend de personne : **produire les huit captures
6,9 pouces**, en suivant la recette déjà écrite.
