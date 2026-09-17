# 10 — Signature de distribution App Store

Missions 4C (configuration), 4D (build signé et vérification du binaire) et 4E (clôture), 17-18 septembre 2026.
Branche `release/iris-appstore-rc1`, depuis `ea946fb`.

```
GATE 4C : PASS       GATE 4D : PASS
GATE 4  : PARTIAL    — et le reste de ce document explique pourquoi.
```

Aucun appareil n'a été utilisé. Aucune archive n'a été produite. Rien n'a été téléversé nulle part.

## 1. La politique de signature, désormais mixte

| | Debug — et tout le reste | Release — la cible Iris, et elle seule |
|---|---|---|
| `CODE_SIGN_STYLE` | `Automatic` | **`Manual`** |
| `CODE_SIGN_IDENTITY` | `Apple Development` | **`Apple Distribution`** |
| `PROVISIONING_PROFILE_SPECIFIER` | aucun | **`Iris App Store Connect Distribution`** |
| `DEVELOPMENT_TEAM` | `G4U9RG5GL7` | `G4U9RG5GL7` |
| `PRODUCT_BUNDLE_IDENTIFIER` | `net.steve-s.iris` (tests : `net.steve-s.iris.tests`) | `net.steve-s.iris` |

« Tout le reste » comprend les configurations de projet et **les deux configurations de la cible de tests, Release
comprise** : une cible de tests ne doit jamais porter le profil App Store.

Ce sont les valeurs **effectives** lues par `xcodebuild -showBuildSettings`, pas des déclarations d'intention.
`project.yml` reste l'unique source de vérité ; `Iris.xcodeproj` est régénéré par `xcodegen generate`.

## 2. Ce qui a changé, et l'empreinte de chaque fichier

Un seul bloc a été ajouté à `project.yml` : `settings.configs.Release` sur la cible Iris. Rien d'autre n'a bougé —
ni source Swift, ni `Config/Info.plist`, ni `Config/Iris.storekit`, ni le scheme, ni un fichier de test.

| Fichier | SHA-256 avant | SHA-256 après |
|---|---|---|
| `project.yml` | `fd1973e330854216196e85fbe146381277e1abe71fc39f49e974cee59a7abb6e` | `7daaa35dfd053cb00f9078f988f68c145df0a8ba153823a912462842ad32b55e` |
| `Iris.xcodeproj/project.pbxproj` | `5410a859731d487c8a7330f87383bbf3f2f22c3290a60026597a2375779bcc95` | `86f7b3b3fb5c256107c808c0e0f17c7cfb0b0cd8f8786a5e38333477f748f4d1` |
| `Tools/audit.py` | `db39805bbe39ada4ecaf040d682a794183bce0fb5617781a2e67fc5cb8e66fc3` | `5cd0c087e55492066b7fed285695044a63e3242ce8cea8c4307834e54bda807d` |

Le diff du `pbxproj` régénéré fait **+4 / −2** : quatre réglages dans le seul bloc Release de la cible Iris, et le
retrait de `ProvisioningStyle = Automatic;` des attributs de cible — conséquence mécanique d'un style mixte, sans
effet sur les réglages effectifs (Debug reste `Automatic`, vérifié).

`Iris.xcscheme` est inchangé : SHA-256 `56d1db6ce21194f31dcee60b15e91dbe51d027adbc769b2f4f9f75fa1e074756`,
identique à la sauvegarde du Gate 4A, référence `Config/Iris.storekit` toujours aux lignes 93-95.

## 3. Le certificat et le profil

**Certificat**, présent et valide dans le trousseau :

```
Apple Distribution: Stéphane SAULNIER (G4U9RG5GL7)
SHA-1  F0:67:74:01:E7:D9:EE:C8:27:C0:3C:C6:5C:D7:94:67:62:57:89:A1
valide 22 août 2026 → 22 août 2027
```

Une ancienne Apple Distribution `E9ED8216…` est expirée depuis le 2 février 2026 : ne pas la confondre.

**Profil**, installé dans le magasin d'Xcode
(`~/Library/Developer/Xcode/UserData/Provisioning Profiles/43baa942-c5af-42c3-984a-882e3bcba19e.mobileprovision`) :

| | |
|---|---|
| Name | `Iris App Store Connect Distribution` |
| UUID | `43baa942-c5af-42c3-984a-882e3bcba19e` |
| AppIDName | `Iris` |
| `application-identifier` | `G4U9RG5GL7.net.steve-s.iris` — **App ID explicite**, plus de wildcard |
| `get-task-allow` | **`false`** |
| `ProvisionedDevices` | **absent** |
| `ProvisionsAllDevices` | **absent** |
| Expiration | 22 août 2027 |

Absence de liste d'appareils **et** absence de `ProvisionsAllDevices`, avec `get-task-allow=false` : c'est la
signature d'un profil App Store, ni développement, ni Ad Hoc, ni Enterprise. **STRONGLY SUPPORTED** — typage par
caractéristiques observées ; le portail Apple n'a pas été interrogé depuis cette machine.

## 4. Gate 4D — le binaire réellement produit

Build Release générique, DerivedData neuf **hors dépôt** (`/tmp/iris-gate4d-release`), aucun appareil, aucun
simulateur, aucune archive.

```
** BUILD SUCCEEDED **
Signing Identity:     "Apple Distribution: Stéphane SAULNIER (G4U9RG5GL7)"
Provisioning Profile: "Iris App Store Connect Distribution"
```

Un seul avertissement dans tout le journal : `appintentsmetadataprocessor`, une note d'outil Apple sans rapport.

**Vérification de signature :**

```
codesign --verify --deep --strict --verbose=2
  → valid on disk
  → satisfies its Designated Requirement          (exit 0)

Identifier      = net.steve-s.iris
Authority       = Apple Distribution: Stéphane SAULNIER (G4U9RG5GL7)
                → Apple Worldwide Developer Relations Certification Authority
                → Apple Root CA
TeamIdentifier  = G4U9RG5GL7
Info.plist entries = 37        Sealed Resources version=2 rules=10 files=5
```

**Entitlements du bundle signé**, relevés sans interprétation :

```
application-identifier              = G4U9RG5GL7.net.steve-s.iris
com.apple.developer.team-identifier = G4U9RG5GL7
get-task-allow                      = false
beta-reports-active                 = true
```

`beta-reports-active` est la clé standard des profils App Store (TestFlight). Aucune autre clé n'est présente ;
rien n'est déduit d'une capacité absente.

**Profil embarqué dans le bundle** : identique au profil installé — nom, UUID `43baa942-…`, App ID explicite,
`get-task-allow=false`, `ProvisionedDevices` absent, `ProvisionsAllDevices` absent, expiration 22 août 2027.

**`Info.plist` du bundle : sain.**

```
plutil -lint : OK          binary plist, 2 085 octets, 37 entrées scellées
SHA-256      : 2635d925eddcbb04abcd73c97ed1fd7bf14f074a896ae5b0fc54e61949e29f8d
CFBundleIdentifier         = net.steve-s.iris
CFBundleShortVersionString = 1.0
CFBundleVersion            = 1
MinimumOSVersion           = 17.0
UIDeviceFamily             = [1, 2]        NSCameraUsageDescription : présent
```

## 5. L'ancien artefact corrompu — et la commande à ne plus jamais écrire

L'artefact du Gate 4 (`.iris-derived-data/device-release/Build/Products/Release-iphoneos/Iris.app`, construit et
signé le 17 septembre à 10:43:55) **échoue** `codesign --verify` : « invalid Info.plist (plist or signature have
been modified) ». Son `Info.plist` ne contient plus que **5 octets**, le texte `[1,2]`
(md5 `f79408e5ca998cd53faf44af31e6eb45`), horodaté 10:47:54 — le seul fichier du bundle postérieur à la signature.

La commande impliquée, retrouvée dans la trace de session `226e7b8e-b299-4081-9881-6c125470428d`, ligne 5163,
`2026-09-17T08:47:52.075Z` :

```
plutil -extract UIDeviceFamily json "$APP/Info.plist"      ← sans -o -
```

Sans `-o -`, `plutil -extract` écrit le résultat **dans le fichier d'entrée**. La chaîne observée :

| Instant | Observation |
|---|---|
| 08:47:52.075Z | commande lancée ; les 4 extractions `raw` qui la précèdent renvoient `1.0`, `1`, `net.steve-s.iris`, `17.0` — **plist intact** |
| — | l'extraction `json` n'imprime rien sur stdout : signature d'une écriture dans le fichier |
| **08:47:54Z** | mtime/ctime de `Info.plist`, dans la fenêtre d'exécution |
| 08:48:03.776Z | la commande suivante relit le plist : **sortie vide**, fichier déjà détruit |

Les quatre extractions `raw` faites sur le même fichier quelques centièmes plus tôt ne l'ont pas corrompu : c'est
un contrôle négatif naturel, observé, non fabriqué. Le contenu `[1,2]` est exactement la sérialisation JSON de
`UIDeviceFamily` pour `TARGETED_DEVICE_FAMILY = "1,2"`.

```
CAUSE DE LA CORRUPTION : STRONGLY_SUPPORTED
```

**Ne jamais écrire PROVEN.** Le périmètre de recherche était borné aux traces du projet, aucun autre écrivain
système n'a été exclu de façon exhaustive, et le mécanisme n'a pas été rejoué. Ce qui le prouverait : reproduire
la commande sur une copie jetable et observer l'écrasement.

**Règle, désormais :** pour lire un plist, utiliser `/usr/libexec/PlistBuddy`, `plutil -p`, ou
`plutil -extract <clé> raw -o -`. Jamais `plutil -extract <clé> json <fichier>`.

Le dommage est nul : DerivedData hors dépôt, non suivi, reconstructible. Le nouvel artefact du Gate 4D, lui, est
sain et vérifié. L'ancien n'a été ni supprimé ni modifié.

## 6. C12 — la règle a suivi la politique, sans être affaiblie

L'ancienne C12 datait de la politique tout-automatique : elle refusait `Manual` et tout profil épinglé, partout.
Après le Gate 4C elle produisait trois constats — attendus, et uniquement ceux-là.

La nouvelle C12 ne dit **pas** « Manual est autorisé ». Elle reconnaît la politique mixte, configuration par
configuration, sur les valeurs du projet généré, avec l'héritage Xcode résolu (réglage de cible, sinon réglage de
projet). Elle refuse toujours : `Manual` en Debug, un profil épinglé en Debug, `Apple Distribution` en Debug,
`Apple Development` pour Iris Release, un profil sur une cible de tests, une équipe ou un bundle identifier
incorrects, et tout profil Release autre que `Iris App Store Connect Distribution`.

La décision est isolée dans une fonction pure, `signing_findings`, entre deux marqueurs de `Tools/audit.py` — elle
peut donc être exercée sur des configurations synthétiques **sans toucher** `project.yml` ni le `pbxproj`.

### Les six cas, réellement exécutés

Harness : `/tmp/iris-gate4e-c12-tests.py` — hors dépôt, volontairement non versionné. Il charge le bloc de
politique depuis `Tools/audit.py` entre ses marqueurs et l'exécute tel quel : aucune logique n'est recopiée.

| | Cas | Attendu | Observé |
|---|---|---|---|
| A | Debug · Automatic · Apple Development · aucun profil | PASS | **PASS** |
| B | Release · Manual · Apple Distribution · profil attendu · équipe et bundle corrects | PASS | **PASS** |
| C | Debug · Manual | FAIL | **FAIL** |
| D | Debug · profil `Iris App Store Connect Distribution` épinglé | FAIL | **FAIL** |
| E | Release · Apple Development | FAIL | **FAIL** |
| F | Release · Manual · Apple Distribution · profil différent | FAIL | **FAIL** |

Quatre contrôles supplémentaires, non exigés, tous FAIL comme voulu : cible de tests portant le profil App Store,
équipe incorrecte en Release, bundle identifier incorrect en Release, `Apple Distribution` en Debug.

Le harness relit aussi le projet réel : **six configurations** vues et classées (`app`, `tests`, `project` ×
Debug/Release), valeurs effectives conformes au tableau du § 1, **zéro constat**.

### L'audit complet du dépôt

```
[C1] pass  [C2] pass  [C8] pass  [C9] pass  [TODO] pass  [C10] pass  [C12] pass
files: 349
```

Aucune autre règle n'a été touchée, et aucune n'est passée au rouge.

## 7. Ce que ce Gate ne dit pas

**Gate 4 reste PARTIAL.** La signature n'était qu'un des blocages. Restent ouverts, inchangés :

| | |
|---|---|
| Captures App Store | **aucune n'existe**, d'aucune taille — le seul blocage majeur entièrement local |
| URL d'assistance, URL de politique de confidentialité, adresse de contact | manquantes |
| Produits In-App Purchase dans App Store Connect | **NOT DETERMINED** — aucun accès n'a été utilisé |
| Contrat Applications payantes, fiscalité, banque | **NOT DETERMINED** |
| Achat réel en bac à sable, échange du code d'offre | **jamais observés** |
| Description de l'achat intégré | deux versions concurrentes, décision produit non tranchée |

```
PRÊT À CRÉER UNE ARCHIVE : la signature ne s'y oppose plus ; les produits App Store Connect, eux, ne sont pas établis
PRÊT À SOUMETTRE À APPLE : NON
```
