# Feature: Gaze

Status: implemented (device validation pending)
Priority: P0
Depends on: none

## Job
When I open the app, I want to start playing in seconds, so I can avoid setup and calibration.

## Screens
CameraAccessView (explain, requesting, denied, restricted). ViewModel: done. View: done.
UnavailableView (no face tracking). View: done.
GazeSetupView (readiness, calibrating, validating, insufficient, ready, failed). ViewModel: done. View: done.

## Acceptance criteria
- AC-1 Given a device without ARFaceTracking support, when the journey begins, then the Unavailable screen is shown.
- AC-2 Given camera access not determined, when the journey begins, then the explanation screen is shown before the system prompt.
- AC-3 Given camera access denied or restricted, when the screen appears, then a Settings shortcut or an explanation is shown and the game does not start.
- AC-4 Given a tracked face, when frames arrive, then the look-at ray is intersected with the device plane in the real interface orientation, axes are resolved from the eyes and gravity, the profile's affine correction is applied and the result is smoothed with alpha 0.1 (R-13, R-16, R-17).
- AC-5 Given the face leaves the frame for 0.3 s while playing, when frames stop, then the game pauses itself and resumes when the face is back (R-22).
- AC-6 Given the first launch, when the gaze setup runs, then nine fixations are collected without taps, blinks excluded, and five control targets validate the correction before the game (R-18 to R-20).
- AC-7 Given a stored valid profile, when the app launches again, then only the diagnostic and the five-point verification run (R-21).
- AC-8 Given a poor verification, when the verdict is shown, then Recalibrer restarts the setup and no endless loop occurs.

## Entities
GazeSample, GazeTrackingState, GazeViewport, DisplayGeometry.

## Notes
Gaze Engine v2: no hard-coded orientation, sign, mirror, ppi or camera position on the calibrated path. The diagnostic dots (raw coral, calibrated mint) can be shown from the pause overlay. Human validation on a TrueDepth iPhone is still required (see GAZE_ENGINE_V2_REPORT.md).

## Test coverage
AC-1 to AC-3: AppCoordinatorTests, CameraAccessViewModelTests. AC-4: GazeMapperTests, AxisMappingTests, GazeFilterTests. AC-5: GameViewModelTests. AC-6 to AC-8: GazeSetupViewModelTests, FixationSequenceTests, AffineTransform2DTests, RobustAggregatorTests, CalibrationProfileTests, GazeReadinessEvaluatorTests.
