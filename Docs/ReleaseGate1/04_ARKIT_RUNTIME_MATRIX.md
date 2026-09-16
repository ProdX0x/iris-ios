# 04 — Capacités ARKit réellement exposées à l'exécution

Là où Apple ne publie rien (document 03), l'API publique, elle, répond. Ce document ne contient que des mesures
faites sur les appareils.

## 1. L'instrument

`Tests/IrisTests/AR/DeviceCapabilityReportTests.swift` — un test qui **lit seulement** :
`ARFaceTrackingConfiguration.isSupported`, `.supportedNumberOfTrackedFaces`, `.supportedVideoFormats`, et pour
chaque format `imageResolution`, `framesPerSecond`, `captureDevicePosition`, `captureDeviceType`,
`isVideoHDRSupported`, `isRecommendedForHighResolutionFrameCapturing`.

Il **n'ouvre aucune `ARSession`**, ne touche ni `GazeFilter`, ni `GazeMapper`, ni la calibration, ni la physique.
Il affirme une seule chose : que ce qu'Iris croit de l'appareil (`ARKitDeviceCapabilities`) est ce qu'ARKit dit.

Commande :

```sh
xcodebuild -project Iris.xcodeproj -scheme Iris -configuration Debug \
  -destination 'platform=iOS,id=<UDID matériel>' \
  test -only-testing:IrisTests/DeviceCapabilityReportTests
# puis :  grep IRIS-ARKIT
```

UDID matériels (ceux que `xcodebuild` attend, différents des identifiants CoreDevice de `devicectl`) :
iPhone 14 Pro `00008120-0016341A2187C01E` · iPhone 15 Pro `00008130-000819961498001C`.

## 2. Mesure — iPhone 14 Pro

**MEASUREMENT**, 16 septembre 2026, test vert :

```
IRIS-ARKIT device.model=iPhone15,2 device.ios=26.5.2
IRIS-ARKIT faceTracking.isSupported=true
IRIS-ARKIT faceTracking.supportedNumberOfTrackedFaces=3
IRIS-ARKIT faceTracking.formatCount=4
IRIS-ARKIT format[0] resolution=1440x1080 fps=60 capturePosition=2 captureDeviceType=AVCaptureDeviceTypeBuiltInTrueDepthCamera hdr=true highResCapture=false
IRIS-ARKIT format[1] resolution=1440x1080 fps=30 capturePosition=2 captureDeviceType=AVCaptureDeviceTypeBuiltInTrueDepthCamera hdr=true highResCapture=false
IRIS-ARKIT format[2] resolution=1280x720  fps=60 capturePosition=2 captureDeviceType=AVCaptureDeviceTypeBuiltInTrueDepthCamera hdr=true highResCapture=false
IRIS-ARKIT format[3] resolution=1280x720  fps=30 capturePosition=2 captureDeviceType=AVCaptureDeviceTypeBuiltInTrueDepthCamera hdr=true highResCapture=false
```

`capturePosition=2` est `AVCaptureDevicePosition.front`. Les quatre formats viennent bien de la caméra TrueDepth.

**Lecture :** l'appareil expose une cadence maximale de **60 images par seconde** en 1440×1080. Iris ne choisit
aucun format (`ARKitGazeTrackingService` ne fixe pas `videoFormat`) : ARKit applique donc son format par défaut,
qui est le premier de la liste — **1440×1080 à 60 fps**. Ce point n'a pas été vérifié à l'exécution d'une session
réelle ; c'est une **INFERENCE** fondée sur la convention ARKit, à confirmer au Gate 2 si elle importe.

## 3. Mesure — iPhone 15 Pro

**NOT DETERMINED — non mesuré.** Écran verrouillé pendant toute la fenêtre de mesure. État relevé, et non supposé :

```
xcrun devicectl device info lockState --device 21ABC186-DEFC-59C7-9671-85E4FA69DA9A
→ passcodeRequired: true    unlockedSinceBoot: true
```

`xcodebuild` attend puis abandonne, avec l'erreur exacte :

```
Error Domain=com.apple.dt.deviceprep Code=-3 "Unlock The Grey to Continue"
Xcode cannot launch IrisTests on The Grey because the device is locked.
```

Contrairement à la capture StoreKit — qui n'a besoin que d'un lancement d'une seconde, son rapport étant ensuite
récupérable écran verrouillé — **ce test exige que l'écran reste déverrouillé pendant toute son exécution**
(installation du support de test, lancement, exécution : de l'ordre de quarante secondes). C'est la mesure la plus
exigeante des deux.

Commande à rejouer, écran déverrouillé et maintenu allumé :

```sh
xcodebuild -project Iris.xcodeproj -scheme Iris -configuration Debug \
  -destination 'platform=iOS,id=00008130-000819961498001C' \
  test -only-testing:IrisTests/DeviceCapabilityReportTests 2>&1 | grep IRIS-ARKIT
```

## 4. Matrice

| | iPhone 14 Pro | iPhone 15 Pro |
|---|---|---|
| AR FACE TRACKING SUPPORTED | **oui (mesuré)** | *non mesuré* |
| supportedNumberOfTrackedFaces | **3 (mesuré)** | *non mesuré* |
| Nombre de formats vidéo | **4 (mesuré)** | *non mesuré* |
| Résolutions | **1440×1080 et 1280×720 (mesuré)** | *non mesuré* |
| Cadences | **60 et 30 fps (mesuré)** | *non mesuré* |
| Type de capteur | **TrueDepth frontal (mesuré)** | *non mesuré* |
| SUPPORTED VIDEO FORMAT DIFFERENCE | **NOT MEASURED** (il faut les deux côtés) | |
| MEASURED FRAME RATE DIFFERENCE | **NOT MEASURED** | |
| TRACKING INTERRUPTION DIFFERENCE | **NOT MEASURED** | |

## 5. Ce qui n'a délibérément pas été mesuré

La **cadence réelle** des images AR, les horodatages, le nombre d'échantillons, les interruptions, les pertes de
visage et la durée des sessions **pendant une partie** n'ont pas été mesurés dans cette mission.

Raison, explicite : les produire demanderait soit d'ouvrir une `ARSession` dans un test (autorisation caméra, visage
réel devant l'objectif — donc une présence humaine), soit d'instrumenter `GameViewModel`, qui est gelé par
`GameContentFreezeTests`. Le mandat dit « mesurer d'abord » et interdit de toucher à la mécanique ; il prévoit aussi
un protocole humain. Ces grandeurs sont donc confiées au protocole du document 05, qui s'appuie sur les métriques
qu'Iris **calcule déjà** plutôt que d'en inventer.

**Aucune modification** n'a été faite à `GazeFilter`, `GazeMapper`, `ARKitGazeTrackingService`, à la calibration, aux
coefficients, aux axes, au filtrage ni à la physique.
