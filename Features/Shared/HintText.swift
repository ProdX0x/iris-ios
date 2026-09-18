// HintText.swift
// Layer: Presentation (shared)
// Purpose: Gives every contextual instruction a stable identity again. The engine hands the screen a bare French
// sentence — the index that chose it is dropped inside HintTracker, which is frozen — so the identity is rebuilt here,
// where the level and its sentence are held together: what a trigger IS names the key, and the French only serves to
// find it. Nothing in Domain/Campaign, HintTracker or GameViewModel is read as a key, copied, or modified

import Foundation

enum HintText {
    /// The generic late help the engine synthesises when a level names none of its own. Which one applies is a
    /// function of the level itself, so the key is found without ever copying the engine's sentences.
    enum GenericHelp: String, CaseIterable {
        case oculo
        case balises
        case route
        case emptySpace
    }

    // MARK: - Identity

    /// A stable token for a trigger, written out case by case. Never `String(describing:)`, never a hash: a token
    /// changes only when someone deliberately changes this switch.
    static func token(for trigger: HintTrigger) -> String {
        switch trigger {
        case .start: "start"
        case let .afterSeconds(seconds): "afterSeconds.\(number(seconds))"
        case .firstIntrusion: "firstIntrusion"
        case .firstHold: "firstHold"
        case .firstValidation: "firstValidation"
        case .firstLoss: "firstLoss"
        case .attentionLeftField: "attentionLeftField"
        case .veilleuseLow: "veilleuseLow"
        case .braiseLit: "braiseLit"
        case .braiseFlared: "braiseFlared"
        case .twinsLinked: "twinsLinked"
        case .firstCarried: "firstCarried"
        case .firstWake: "firstWake"
        case .firstSwallow: "firstSwallow"
        case .firstBalise: "firstBalise"
        case .balisesCompleted: "balisesCompleted"
        case .firstOculoSuccess: "firstOculoSuccess"
        case .firstOculoMiss: "firstOculoMiss"
        case .oculoCompleted: "oculoCompleted"
        case let .oculoStageCompleted(stage): "oculoStageCompleted.\(stage)"
        case let .oculoSuccessInStage(stage, ordinal): "oculoSuccessInStage.\(stage).\(ordinal)"
        }
    }

    static func key(level id: String, trigger: HintTrigger) -> String {
        "level.\(id).hint.\(token(for: trigger))"
    }

    /// The late help a level names for its own oculomotor sequence.
    static func oculoHelpKey(level id: String) -> String { "level.\(id).hint.oculoHelp" }

    static func key(generic help: GenericHelp) -> String { "hint.generic.\(help.rawValue)" }

    /// Which generic help this level receives, read from the level itself — the same order the engine follows.
    static func genericHelp(for level: LevelDefinition) -> GenericHelp {
        if level.hasOculo { return .oculo }
        if level.hasBalises { return .balises }
        if level.requiresPushing { return .route }
        return .emptySpace
    }

    // MARK: - Registry, built from the campaign itself

    /// Every sentence this level names, and the key that identifies it. Built from `LevelDefinition`; not one French
    /// sentence is written down here.
    static func registry(for level: LevelDefinition) -> [String: String] {
        var registry: [String: String] = [:]
        for hint in level.hints {
            registry[hint.text] = key(level: level.id, trigger: hint.trigger)
        }
        if let help = level.oculo?.help {
            registry[help] = oculoHelpKey(level: level.id)
        }
        return registry
    }

    /// The key that identifies a sentence the engine is showing for this level.
    ///
    /// A sentence the level names is found in the registry. The only other sentence the engine can produce is the
    /// generic help it synthesises for a level naming none — identified by the level's own shape, never by its words.
    static func key(for french: String, in level: LevelDefinition) -> String {
        registry(for: level)[french] ?? key(generic: genericHelp(for: level))
    }

    // MARK: - What the screen shows

    /// The instruction, localised. With no translation in the catalogue the French received is the French returned.
    static func localized(_ french: String, in level: LevelDefinition) -> String {
        IrisText.gameplay(key(for: french, in: level), french: french)
    }

    /// A whole number keeps its digits; anything else keeps a deterministic form with no decimal separator.
    private static func number(_ value: TimeInterval) -> String {
        value == value.rounded() && abs(value) < 1e9
            ? String(Int(value))
            : String(value).replacingOccurrences(of: ".", with: "_")
    }
}
