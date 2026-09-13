// Campaign+Braises.swift
// Layer: Domain
// Purpose: Chapter XI, Braises: the cold lueur that a brief gaze wakes (tuning A, human-validated and frozen), met
// alone, in pairs, in a current, behind a veil, next to a sleeper, and in order

import Foundation

extension Campaign {
    static let braises = ChapterDefinition(
        number: 11, name: "braises", principle: "Un regard bref la réveille. Un regard long l'affole.", ambientFrequency: 103.83, theme: .braises,
        levels: [
            LevelDefinition(
                chapter: 11, index: 1, title: "la braise",
                principle: "Elle dort, froide. Votre regard la réveille, et elle fuit.",
                introduces: [.braise], zone: 0.46,
                lueurs: [LueurDefinition(start: pt(0.3, 0.72), iris: pt(0.7, 0.3), braise: .prototype)],
                hints: [LevelHint(.start, "Elle est froide. Regardez-la."),
                        LevelHint(.braiseLit, "Elle s'allume et fuit. Laissez-la venir."),
                        LevelHint(.braiseFlared, "Trop regardée, elle s'affole."),
                        LevelHint(.afterSeconds(30), "Un regard bref suffit. Puis regardez ailleurs.")],
                par: LevelPar(time: 15, intrusions: 4)),
            LevelDefinition(
                chapter: 11, index: 2, title: "deux braises",
                principle: "Deux braises, deux réveils. Réveillez-les du côté opposé à leur iris.",
                zone: 0.46,
                lueurs: [LueurDefinition(start: pt(0.25, 0.75), iris: pt(0.25, 0.3), braise: .prototype),
                         LueurDefinition(start: pt(0.75, 0.75), iris: pt(0.75, 0.3), braise: .prototype)],
                hints: [LevelHint(.start, "Réveillez-les l'une après l'autre."),
                        LevelHint(.braiseFlared, "Affolée, elle fuit de plus loin. Regardez ailleurs.")],
                par: LevelPar(time: 14, intrusions: 5)),
            LevelDefinition(
                chapter: 11, index: 3, title: "la braise et le courant",
                principle: "Réveillée, elle monte dans le courant. Poussez-la au travers.",
                zone: 0.46,
                lueurs: [LueurDefinition(start: pt(0.5, 0.85), iris: pt(0.5, 0.2), route: [pt(0.64, 0.62), pt(0.62, 0.4)], braise: .prototype)],
                currents: [CurrentDefinition(area: band(0.0, 0.45, 1.0, 0.58), direction: left, strength: 0.85)],
                hints: [LevelHint(.start, "Froide, elle attend sous le courant."),
                        LevelHint(.braiseLit, "Elle monte. Le courant va l'emporter vers la gauche.")],
                par: LevelPar(time: 17, intrusions: 3)),
            LevelDefinition(
                chapter: 11, index: 4, title: "la braise et le voile",
                principle: "Son iris est derrière le voile. Réveillez-la, puis contournez.",
                zone: 0.46,
                lueurs: [LueurDefinition(start: pt(0.25, 0.8), iris: pt(0.72, 0.25), route: [pt(0.16, 0.52), pt(0.4, 0.34)], braise: .prototype)],
                veils: [VeilDefinition(a: pt(0.3, 0.5), b: pt(0.85, 0.5))],
                hints: [LevelHint(.start, "Le voile ferme la droite. Le passage est à gauche."),
                        LevelHint(.braiseLit, "Réveillée, elle vole vers le voile. Poussez-la vers la gauche.")],
                par: LevelPar(time: 17, intrusions: 3)),
            LevelDefinition(
                chapter: 11, index: 5, title: "deux réveils",
                principle: "La braise s'éveille au regard ; son iris fermé réveille la dormeuse.",
                zone: 0.46,
                lueurs: [LueurDefinition(start: pt(0.5, 0.8), iris: pt(0.5, 0.5), braise: .prototype),
                         LueurDefinition(start: pt(0.35, 0.35), iris: pt(0.2, 0.15), asleep: true)],
                echo: .standard,
                hints: [LevelHint(.start, "Deux sommeils : l'un cède au regard, l'autre à l'écho."),
                        LevelHint(.firstWake, "L'écho l'a réveillée. Elle rejoint son iris.")],
                par: LevelPar(time: 18, intrusions: 6)),
            LevelDefinition(
                chapter: 11, index: 6, title: "trois feux",
                principle: "Une braise, une lueur, une braise. Dans l'ordre, et le voile en travers.",
                ordered: true, zone: 0.46,
                lueurs: [LueurDefinition(start: pt(0.2, 0.8), iris: pt(0.2, 0.35), braise: .prototype),
                         LueurDefinition(start: pt(0.5, 0.12), iris: pt(0.5, 0.55)),
                         LueurDefinition(start: pt(0.8, 0.82), iris: pt(0.8, 0.3), route: [pt(0.58, 0.5), pt(0.62, 0.34)], braise: .prototype)],
                veils: [VeilDefinition(a: pt(0.66, 0.6), b: pt(0.96, 0.6))],
                hints: [LevelHint(.start, "La première braise, puis la lueur, puis la braise derrière le voile."),
                        LevelHint(.firstLoss, "Un iris qui se rouvre entraîne les suivants.")],
                par: LevelPar(time: 20, intrusions: 6)),
        ])
}
