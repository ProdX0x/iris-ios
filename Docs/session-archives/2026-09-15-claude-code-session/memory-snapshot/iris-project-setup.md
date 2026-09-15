---
name: iris-project-setup
description: "How the Iris iOS project is built and verified (xcodegen, test/build commands, debug launch options, campaign verification, what still needs a TrueDepth device)"
metadata: 
  node_type: memory
  type: project
  originSessionId: f88478cc-d512-4210-bc11-758059278995
  modified: 2026-09-11T11:46:40.732Z
---

Iris lives directly in the working directory, is a git repo (branch `feature/iris-v2`, remote `ProdX0x/iris-ios`) and `Iris.xcodeproj` is generated from `project.yml` with XcodeGen: run `xcodegen generate` after adding or removing files. Tests run on the `iPhone 17 Pro` simulator (220 tests on 2026-09-11 after the redesign). Device builds are signed for real with `-destination 'generic/platform=iOS'` (team G4U9RG5GL7, automatic profile), see [[iris-apple-identity]].

Product references live in `Design/` (PRODUCT_AUDIT, GAME_VISION, GAME_DESIGN, LEVEL_DESIGN_SYSTEM, UX_VISION, ART_DIRECTION). The campaign is authored data (`Domain/Campaign/Campaign+*.swift`, 6 chapters, 34 levels) resolved per screen by `LevelResolver`; `PrototypeLevelCatalog` (14 levels) is kept only for the golden traces of `attention-indirecte.html`.

Every level is proven by simulated players in `Tests/IrisTests/Campaign/` (`CampaignBot`, `CampaignMeasurements`, `CampaignValidationTests`); `LevelLabTests` prints the metrics table used in LEVEL_DESIGN_SYSTEM.md section 10. Changing a level's geometry means re-running the lab and recomputing its par (`time = round(1.8 × botTime + 6)`, `intrusions = ceil(botIntrusions) + 2`).

Debug launch arguments: `--iris-route <home|cameraAccess|gazeSetup|chapters|carnet|game|journeyComplete|unavailable>`, `--iris-level c-i`, `--iris-progress all|c-i`, `--iris-autoplay`, `--iris-gaze x,y`, `--iris-oracle-gaze`. For screenshots use `xcrun simctl` on the `iPhone 17` simulator while tests run on `iPhone 17 Pro` with `test-without-building`; never install while an `xcodebuild` is rewriting DerivedData.

**Why:** the user runs autonomous, no-question missions and wants honest status labels; README.md is the authoritative technical notebook.

**How to apply:** never modify `attention-indirecte.html`; commit only when asked (the reference commit `feat: complete Iris v2 refactor and Gaze Engine v2` was requested on 2026-09-11); real gaze accuracy, calibration comfort and human play feel are still `[nécessite validation sur iPhone TrueDepth]` (the app was installed and launched on the paired iPhone 14 Pro on 2026-09-11 via devicectl, but nobody has calibrated or played on it).

**Disk space (14 Sept 2026):** the Mac's internal disk is nearly full (a few GiB free; a full disk once broke builds and the tool harness). Build and test with `-derivedDataPath "/Volumes/Steve Pro BlackSSD/Dev/App Mobile/.iris-derived-data/<sim|release|device>"`, which sits outside the repo on the external SSD, and avoid creating new simulators. See [[iris-chapter-card-layout]].

**Memory (14 Sept 2026):** the Mac has 17 GB of RAM and its swap lives on the nearly full internal disk; two xcodebuild runs plus two booted simulators got background tasks killed for low memory. Run one xcodebuild at a time, keep one simulator booted, and shut down the screenshot simulator (iPhone 17) before running tests on iPhone 17 Pro.
