# Feature: Haptics

Status: implemented (logic verified automatically; physical sensation needs a human on device)
Priority: P2
Depends on: Game

## Job
When a lueur settles or slips away, I want a brief touch confirmation that never competes with my gaze, so I can keep my eyes on the field.

## Screens
None. Feedback inside GameView; preference in SettingsView ("Vibrations", on by default, persisted).

## Acceptance criteria
- AC-1 Given haptics are on, when a lueur validates, then one medium impact plays at intensity 0.7 (R-31).
- AC-2 Given haptics are on, when a validation is lost for any cause, then one soft impact plays at intensity 0.45; a cascade in the same tick is one pulse (R-15, R-31).
- AC-3 Given haptics are on, when the level completes, then one success notification plays instead of the validation pulse, alongside the audio arpeggio.
- AC-4 Given two pulses would be closer than `FeedbackTiming.lossRetriggerInterval` (150 ms, shared with the audio loss guard), when the second is requested, then it is dropped; the completion pulse is never dropped.
- AC-5 Given a hold starts (presence accumulates), when the first progress event arrives, then the generator is prepared once so the validation pulse has no latency.
- AC-6 Given haptics are off, when any event happens, then no cue reaches the service; the change applies on the next tick and survives a relaunch.

## Entities
HapticCue, HapticCuePolicy, HapticFeedbackService (UIKitHapticFeedbackService, SilentHapticFeedbackService), FeedbackTiming.

## Notes
UIKit feedback generators are inert on hardware without a Taptic Engine and when iOS "System Haptics" (Settings, Sounds & Haptics) is off; Iris does not override that system choice.

## Test coverage
AC-1 to AC-5: HapticCuePolicyTests. AC-6 and the ViewModel wiring: GameViewModelTests (hapticsEnabled, hapticsDisabled), GameSettingsStoreTests. The pulse itself: `[sensation physique nécessite validation humaine]`.
