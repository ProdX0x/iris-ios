// Campaign+OculomotorFinals.swift
// Layer: Domain
// Purpose: OCULOMOTOR EXPANSION: the optional final level of each chapter II to XII, one gaze paradigm each,
// appended after the validated levels without touching them

import Foundation

extension Campaign {
    /// The oculomotor final of a chapter, nil when the chapter has none (chapter I's is `oculomoteur`, already in place).
    static func oculomotorFinal(forChapter number: Int) -> LevelDefinition? {
        oculomotorFinals[number]
    }

    static let oculomotorFinals: [Int: LevelDefinition] = [2: finalPartage, 3: finalCourants, 4: finalVoiles, 5: finalVeilleuses, 6: finalClairvoyance, 7: finalJumelles, 8: finalSouffles]
}
