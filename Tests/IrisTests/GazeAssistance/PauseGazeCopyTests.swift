// PauseGazeCopyTests.swift
// Layer: Tests
// Purpose: The pause says what each mode does in three words and what the calibration figure means in one line,
// the settings keep their long explanations, and both still fit — at normal text and at accessibility sizes

import SwiftUI
import Testing
import UIKit
@testable import Iris

@Suite("Pause gaze copy")
@MainActor
struct PauseGazeCopyTests {
    /// Width the glass panel's content gets inside the pause overlay: the phone width (capped at the overlay's
    /// 420 pt), minus the two page gutters, minus the two paddings of the panel itself.
    static let panelWidths: [CGFloat] = [375, 393, 402, 430, 440].map { min($0, 420) - 2 * DSSpacing.gutter - 2 * DSSpacing.l }

    private func fittingSize(_ view: some View, width: CGFloat) -> CGSize {
        let host = UIHostingController(rootView: view)
        return host.sizeThatFits(in: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude))
    }

    // MARK: What the pause says

    @Test("CLASSIC in the pause: the name, and what it does in two words")
    func classicCopy() {
        #expect(GazeAssistanceMode.classic.title == "Classique")
        #expect(GazeAssistancePicker.meaning(for: .classic, variant: .compact) == "Sans repère")
    }

    @Test("GUIDED in the pause: the name, and what it does in two words")
    func guidedCopy() {
        #expect(GazeAssistanceMode.guided.title == "Guidé")
        #expect(GazeAssistancePicker.meaning(for: .guided, variant: .compact) == "Repère ponctuel")
    }

    @Test("VISIBLE in the pause: the name, and what it does in two words")
    func visibleCopy() {
        #expect(GazeAssistanceMode.visible.title == "Visible")
        #expect(GazeAssistancePicker.meaning(for: .visible, variant: .compact) == "Repère permanent")
    }

    @Test("the compact lines stay short, plain and free of jargon or of any claim about health")
    func compactCopyStaysCompact() {
        for mode in GazeAssistanceMode.allCases {
            let line = mode.compactSummary
            #expect(line.count <= 20, "\(mode) says too much for a pause: \(line)")
            #expect(line.contains(".") == false, "\(mode) is a label, not a sentence: \(line)")
            for word in ["diagnostic", "VALID", "YAW", "PITCH", "debug", "tracking", "curseur", "calibr"] {
                #expect(line.localizedCaseInsensitiveContains(word) == false, "\(mode) says \(word)")
            }
            for word in ["vue", "yeux", "thérap", "rééduc", "soigne", "corrige", "entraîn"] {
                #expect(line.localizedCaseInsensitiveContains(word) == false, "\(mode) claims \(word)")
            }
        }
    }

    // MARK: What the settings keep

    @Test("the settings keep their long explanations: they were not replaced by the pause labels")
    func settingsKeepTheLongCopy() {
        for mode in GazeAssistanceMode.allCases {
            let detailed = GazeAssistancePicker.meaning(for: mode, variant: .detailed)
            #expect(detailed == mode.summary, "\(mode) lost its detailed explanation")
            #expect(detailed != mode.compactSummary, "\(mode) shows the pause label where the settings explain")
            #expect(detailed.count > mode.compactSummary.count, "\(mode) no longer explains anything in the settings")
            #expect(detailed.hasSuffix("."), "\(mode) is a sentence in the settings")
        }
        #expect(GazeAssistanceMode.classic.summary.contains("halo"))
        #expect(GazeAssistanceMode.guided.summary.contains("brièvement"))
        #expect(GazeAssistanceMode.visible.summary.contains("visible pendant le jeu"))
    }

    @Test("one rule decides what a row says, so the drawn text and the spoken text can never differ")
    func oneCopyRule() {
        for mode in GazeAssistanceMode.allCases {
            #expect(GazeAssistancePicker.meaning(for: mode, variant: .compact) == mode.compactSummary)
            #expect(GazeAssistancePicker.meaning(for: mode, variant: .detailed) == mode.summary)
        }
    }

    // MARK: The calibration figure

    @Test("under the percentage, one line says which way is better — and promises nothing")
    func calibrationHelp() throws {
        let help = try #require(GazeCalibrationStatus.calibrated(meanError: 0.08, isValid: true).explanation)
        #expect(help == "Plus l'écart est faible, plus le suivi du regard est précis.")

        // The same line whether the calibration passed or has to be done again: it explains the figure, it does
        // not grade the player.
        #expect(GazeCalibrationStatus.calibrated(meanError: 0.2, isValid: false).explanation == help)
        #expect(GazeCalibrationStatus.calibrated(meanError: nil, isValid: true).explanation == help)

        // Nothing may suggest that zero is required, reachable, or a medical measurement.
        for word in ["0 %", "zéro", "parfait", "exact", "garanti", "médical", "précision absolue"] {
            #expect(help.localizedCaseInsensitiveContains(word) == false, "the help claims \(word)")
        }
        // And the long explanation is not dragged into the pause.
        #expect(help.count < 70)
    }

    @Test("the percentage itself is untouched: same figure, same rounding, same words around it")
    func percentagePreserved() {
        #expect(GazeCalibrationStatus.calibrated(meanError: 0.08, isValid: true).description
                == "Calibration réussie — écart moyen 8 %.")
        #expect(GazeCalibrationStatus.calibrated(meanError: 0.2, isValid: false).description
                == "Calibration à refaire — écart moyen 20 %.")
        #expect(GazeCalibrationStatus.uncalibrated.description == "Regard non calibré.")
    }

    @Test("with no calibration yet there is no figure to explain, so the line tells the player what to do instead")
    func uncalibratedHelp() {
        #expect(GazeCalibrationStatus.uncalibrated.explanation == "Recalibrez pour qu'Iris suive votre regard plus précisément.")
    }

    // MARK: Fitting the panel

    @Test("the compact selector fits every phone, at normal text and at accessibility sizes")
    func compactPickerFits() {
        for width in Self.panelWidths {
            for size in [DynamicTypeSize.large, .xxxLarge, .accessibility2, .accessibility5] {
                let view = GazeAssistancePicker(mode: .constant(.guided), variant: .compact)
                    .environment(\.dynamicTypeSize, size)
                let fitted = fittingSize(view, width: width)
                #expect(fitted.width <= width + 0.5, "the compact selector overflows \(width) pt at \(size): \(fitted.width)")
            }
        }
    }

    @Test("the detailed selector fits too, so the settings never widen the screen either")
    func detailedPickerFits() {
        for width in Self.panelWidths {
            for size in [DynamicTypeSize.large, .xxxLarge, .accessibility2, .accessibility5] {
                let view = GazeAssistancePicker(mode: .constant(.classic), variant: .detailed)
                    .environment(\.dynamicTypeSize, size)
                let fitted = fittingSize(view, width: width)
                #expect(fitted.width <= width + 0.5, "the detailed selector overflows \(width) pt at \(size): \(fitted.width)")
            }
        }
    }

    @Test("the learning note and the calibration lines wrap instead of being cut")
    func sentencesWrap() {
        let width = Self.panelWidths[0]
        let lines = [GazeAssistancePicker.learningNote,
                     GazeCalibrationStatus.calibrated(meanError: 0.08, isValid: true).description,
                     GazeCalibrationStatus.calibrated(meanError: 0.08, isValid: true).explanation ?? "",
                     GazeCalibrationStatus.uncalibrated.explanation ?? ""]
        for line in lines {
            var previousHeight: CGFloat = 0
            for size in [DynamicTypeSize.large, .xxxLarge, .accessibility2, .accessibility5] {
                let view = Text(line)
                    .font(DSFont.footnote)
                    .fixedSize(horizontal: false, vertical: true)
                    .environment(\.dynamicTypeSize, size)
                let fitted = fittingSize(view, width: width)
                #expect(fitted.width <= width + 0.5, "'\(line)' overflows \(width) pt at \(size)")
                // Growing taller as the text grows is what wrapping looks like; a clipped line would not.
                #expect(fitted.height >= previousHeight, "'\(line)' stopped growing at \(size): it is being cut")
                previousHeight = fitted.height
            }
        }
    }

    @Test("a locked selector still says what the modes mean, and adds the reason it cannot be used")
    func lockedSelectorStillExplains() {
        for width in Self.panelWidths {
            for size in [DynamicTypeSize.large, .accessibility5] {
                let free = fittingSize(GazeAssistancePicker(mode: .constant(.classic), variant: .compact)
                    .environment(\.dynamicTypeSize, size), width: width)
                let locked = fittingSize(GazeAssistancePicker(mode: .constant(.classic), variant: .compact, isLearning: true)
                    .environment(\.dynamicTypeSize, size), width: width)
                #expect(locked.width <= width + 0.5, "the locked selector overflows \(width) pt at \(size)")
                #expect(locked.height > free.height, "the locked selector does not show the reason at \(size)")
            }
        }
    }
}
