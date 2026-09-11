// Campaign+Partage.swift
// Layer: Domain
// Purpose: Chapter II, Partage: order, crossing, guard, cascade, three lueurs

import Foundation

extension Campaign {
    static let partage = ChapterDefinition(
        number: 2, name: "partage", principle: "Une attention, plusieurs lueurs.", ambientFrequency: 123.47,
        levels: [
            LevelDefinition(
                chapter: 2, index: 1, title: "dans l'ordre",
                principle: "La lueur 2 attend que la 1 soit posée.",
                introduces: [.ordre], ordered: true, zone: 0.46,
                lueurs: [LueurDefinition(start: pt(0.28, 0.86), iris: pt(0.28, 0.3)),
                         LueurDefinition(start: pt(0.74, 0.2), iris: pt(0.72, 0.56))],
                hints: [LevelHint(.start, "D'abord la 1, ensuite la 2.")],
                par: LevelPar(time: 16, intrusions: 2)),
            LevelDefinition(
                chapter: 2, index: 2, title: "croisement",
                principle: "Leurs chemins traversent l'écran et se croisent au centre.",
                ordered: true, zone: 0.46,
                lueurs: [LueurDefinition(start: pt(0.18, 0.12), iris: pt(0.8, 0.86)),
                         LueurDefinition(start: pt(0.82, 0.13), iris: pt(0.2, 0.87))],
                par: LevelPar(time: 19, intrusions: 4)),
            LevelDefinition(
                chapter: 2, index: 3, title: "garde",
                principle: "Protégez la 1 pendant que la 2 passe.",
                introduces: [.cascade], ordered: true, zone: 0.46,
                lueurs: [LueurDefinition(start: pt(0.5, 0.86), iris: pt(0.5, 0.5)),
                         LueurDefinition(start: pt(0.17, 0.28), iris: pt(0.83, 0.7))],
                hints: [LevelHint(.firstLoss, "Si la 1 perd sa place, la 2 la perd aussi.")],
                par: LevelPar(time: 14, intrusions: 2)),
            LevelDefinition(
                chapter: 2, index: 4, title: "trois",
                principle: "Trois lueurs, un seul regard.",
                ordered: true, zone: 0.46,
                lueurs: [LueurDefinition(start: pt(0.2, 0.87), iris: pt(0.52, 0.24)),
                         LueurDefinition(start: pt(0.82, 0.85), iris: pt(0.2, 0.52)),
                         LueurDefinition(start: pt(0.5, 0.11), iris: pt(0.8, 0.62))],
                par: LevelPar(time: 18, intrusions: 6)),
            LevelDefinition(
                chapter: 2, index: 5, title: "partage",
                principle: "Tout ce que vous avez appris, et une lueur vive.",
                ordered: true, zone: 0.46,
                lueurs: [LueurDefinition(start: pt(0.8, 0.13), iris: pt(0.24, 0.62)),
                         LueurDefinition(start: pt(0.2, 0.2), iris: pt(0.76, 0.66), temperament: .vive),
                         LueurDefinition(start: pt(0.5, 0.89), iris: pt(0.5, 0.34))],
                par: LevelPar(time: 17, intrusions: 5)),
        ])
}
