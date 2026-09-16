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

**MEASUREMENT**, 16 septembre 2026, test vert :

```
IRIS-ARKIT device.model=iPhone16,1 device.ios=26.6.1
IRIS-ARKIT faceTracking.isSupported=true
IRIS-ARKIT faceTracking.supportedNumberOfTrackedFaces=3
IRIS-ARKIT faceTracking.formatCount=4
IRIS-ARKIT format[0] resolution=1440x1080 fps=60 capturePosition=2 captureDeviceType=AVCaptureDeviceTypeBuiltInTrueDepthCamera hdr=true highResCapture=false
IRIS-ARKIT format[1] resolution=1440x1080 fps=30 capturePosition=2 captureDeviceType=AVCaptureDeviceTypeBuiltInTrueDepthCamera hdr=true highResCapture=false
IRIS-ARKIT format[2] resolution=1280x720  fps=60 capturePosition=2 captureDeviceType=AVCaptureDeviceTypeBuiltInTrueDepthCamera hdr=true highResCapture=false
IRIS-ARKIT format[3] resolution=1280x720  fps=30 capturePosition=2 captureDeviceType=AVCaptureDeviceTypeBuiltInTrueDepthCamera hdr=true highResCapture=false
```

Note d'exécution : une première tentative a échoué (`test runner exited with code 74 before establishing
connection`) parce que l'écran s'est reverrouillé pendant l'installation du support de test. La reprise, écran
déverrouillé et maintenu, a réussi en moins d'une seconde d'exécution.

## 4. Matrice

| | iPhone 14 Pro | iPhone 15 Pro | Différence |
|---|---|---|---|
| Modèle | `iPhone15,2` | `iPhone16,1` | — |
| iOS | 26.5.2 | 26.6.1 | oui |
| AR FACE TRACKING SUPPORTED | **oui** | **oui** | **non** |
| supportedNumberOfTrackedFaces | **3** | **3** | **non** |
| Nombre de formats vidéo | **4** | **4** | **non** |
| format[0] | 1440×1080 @ 60 | 1440×1080 @ 60 | **non** |
| format[1] | 1440×1080 @ 30 | 1440×1080 @ 30 | **non** |
| format[2] | 1280×720 @ 60 | 1280×720 @ 60 | **non** |
| format[3] | 1280×720 @ 30 | 1280×720 @ 30 | **non** |
| Position de capture | frontale (2) | frontale (2) | **non** |
| Type de capteur | `BuiltInTrueDepthCamera` | `BuiltInTrueDepthCamera` | **non** |
| HDR vidéo | `true` sur les 4 | `true` sur les 4 | **non** |
| Capture haute résolution recommandée | `false` sur les 4 | `false` sur les 4 | **non** |

```
SUPPORTED VIDEO FORMAT DIFFERENCE: NONE MEASURED
MEASURED FRAME RATE DIFFERENCE (formats exposés): NONE MEASURED
ARKIT RUNTIME DIFFERENCE: NOT PROVEN — aucune différence n'a été mesurée
TRACKING INTERRUPTION DIFFERENCE: NOT MEASURED (exige une session de jeu réelle)
```

**Lecture.** Sur ce que l'API publique expose pour le suivi de visage, les deux appareils sont **identiques, champ
par champ**. Cela rejoint exactement ce qu'Apple publie (document 03) : même caméra TrueDepth, même écran.

Iris ne fixe aucun `videoFormat` (`ARKitGazeTrackingService` ne l'assigne pas) : ARKit applique son format par
défaut, le premier de la liste — **1440×1080 à 60 fps**, identique sur les deux appareils. Ce point est une
**INFERENCE** fondée sur la convention ARKit ; il n'a pas été vérifié sur une session réelle.

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
