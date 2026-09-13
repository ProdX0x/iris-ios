// Campaign+Souffles.swift
// Layer: Domain
// Purpose: Chapter VIII, Souffles: a gust travels its track periodically and carries what it crosses over the veils;
// against a veil a lueur drifts toward its iris, so it must be brought onto the track as the gust arrives, then left alone.
// The brume calms the lueurs (noise 0.08) so that where they wait is predictable.

import Foundation

extension Campaign {
    static let souffles = ChapterDefinition(
        number: 8, name: "souffles", principle: "Ce qu'il traverse, il l'emporte.", ambientFrequency: 87.31, theme: .brume,
        levels: [
            LevelDefinition(
                chapter: 8, index: 1, title: "le souffle",
                principle: "Le voile ferme tout. Le souffle passe par-dessus.",
                introduces: [.souffle], zone: 0.46, noise: 0.08,
                lueurs: [LueurDefinition(start: pt(0.4, 0.12), iris: pt(0.7, 0.82), route: [pt(0.2, 0.47)])],
                veils: [VeilDefinition(a: pt(0.0, 0.5), b: pt(1.0, 0.5))],
                souffles: [SouffleDefinition(path: [pt(0.2, 0.30), pt(0.2, 0.70)], period: 8, duty: 0.7, radius: 0.2, strength: 1.8)],
                hints: [LevelHint(.start, "Contre le voile, elle glisse vers son iris. Le souffle passe ailleurs."),
                        LevelHint(.firstIntrusion, "Quand le souffle approche, amenez-la sur son chemin."),
                        LevelHint(.firstCarried, "Il l'emporte. Ne la regardez plus."),
                        LevelHint(.afterSeconds(30), "Regardez loin à sa droite : elle glisse vers la gauche, jusqu'au chemin.")],
                par: LevelPar(time: 18, intrusions: 4)),
            LevelDefinition(
                chapter: 8, index: 2, title: "un souffle pour deux",
                principle: "Deux lueurs, un seul chemin. Ensemble, ou l'une après l'autre.",
                zone: 0.46, noise: 0.08,
                lueurs: [LueurDefinition(start: pt(0.3, 0.12), iris: pt(0.12, 0.82), route: [pt(0.5, 0.47)]),
                         LueurDefinition(start: pt(0.7, 0.12), iris: pt(0.88, 0.82), route: [pt(0.5, 0.47)])],
                veils: [VeilDefinition(a: pt(0.0, 0.5), b: pt(1.0, 0.5))],
                souffles: [SouffleDefinition(path: [pt(0.5, 0.30), pt(0.5, 0.70)], period: 8, duty: 0.7, radius: 0.2, strength: 1.8)],
                hints: [LevelHint(.start, "Elles s'écartent vers les bords. Le souffle passe au milieu."),
                        LevelHint(.firstCarried, "Une de moins. Le souffle reviendra pour l'autre.")],
                par: LevelPar(time: 29, intrusions: 10)),
            LevelDefinition(
                chapter: 8, index: 3, title: "la dérive",
                principle: "Le courant l'écarte du chemin. Ramenez-la quand le souffle vient.",
                zone: 0.46, noise: 0.08,
                lueurs: [LueurDefinition(start: pt(0.35, 0.1), iris: pt(0.35, 0.84), route: [pt(0.7, 0.47)])],
                currents: [CurrentDefinition(area: band(0.0, 0.34, 1.0, 0.49), direction: left, strength: 0.8)],
                veils: [VeilDefinition(a: pt(0.0, 0.5), b: pt(1.0, 0.5))],
                souffles: [SouffleDefinition(path: [pt(0.7, 0.30), pt(0.7, 0.70)], period: 8, duty: 0.7, radius: 0.2, strength: 1.8)],
                hints: [LevelHint(.start, "Contre le voile, le courant l'emporte vers la gauche. Le chemin est à droite."),
                        LevelHint(.firstCarried, "Le souffle est plus fort que le courant.")],
                par: LevelPar(time: 29, intrusions: 6)),
            LevelDefinition(
                chapter: 8, index: 4, title: "la flamme et la brume",
                principle: "La flamme éclaire l'iris d'en bas. Servez-la entre deux souffles.",
                zone: 0.46, noise: 0.08,
                lueurs: [LueurDefinition(start: pt(0.75, 0.12), iris: pt(0.65, 0.82), route: [pt(0.3, 0.47)])],
                veils: [VeilDefinition(a: pt(0.0, 0.5), b: pt(1.0, 0.5))],
                veilleuses: [VeilleuseDefinition(position: pt(0.16, 0.24), lookRadius: 0.14, decay: 9, recharge: 0.8, initialCharge: 0.45)],
                souffles: [SouffleDefinition(path: [pt(0.3, 0.30), pt(0.3, 0.70)], period: 8, duty: 0.7, radius: 0.2, strength: 1.8)],
                hints: [LevelHint(.start, "La flamme est loin du chemin. Regardez-la quand la lueur ne vole pas."),
                        LevelHint(.veilleuseLow, "La flamme faiblit.")],
                par: LevelPar(time: 18, intrusions: 3)),
            LevelDefinition(
                chapter: 8, index: 5, title: "double traversée",
                principle: "Deux voiles, deux souffles. Entre les deux, changez de chemin.",
                zone: 0.46, noise: 0.08,
                lueurs: [LueurDefinition(start: pt(0.5, 0.1), iris: pt(0.5, 0.9), route: [pt(0.18, 0.33), pt(0.82, 0.61)])],
                veils: [VeilDefinition(a: pt(0.0, 0.36), b: pt(1.0, 0.36)), VeilDefinition(a: pt(0.0, 0.64), b: pt(1.0, 0.64))],
                souffles: [SouffleDefinition(path: [pt(0.18, 0.2), pt(0.18, 0.5)], period: 7, duty: 0.7, radius: 0.18, strength: 1.8, phase: 0),
                           SouffleDefinition(path: [pt(0.82, 0.5), pt(0.82, 0.8)], period: 7, duty: 0.7, radius: 0.18, strength: 1.8, phase: 0.5)],
                hints: [LevelHint(.start, "Le premier souffle la dépose entre les voiles. Le second passe à droite.")],
                par: LevelPar(time: 21, intrusions: 5)),
            LevelDefinition(
                chapter: 8, index: 6, title: "jumelles dans la brume",
                principle: "Le voile sépare une jumelle de son poste. Le souffle l'y conduit.",
                zone: 0.46, noise: 0.08,
                lueurs: [LueurDefinition(start: pt(0.5, 0.12), iris: pt(0.3, 0.78), route: [pt(0.65, 0.47), pt(0.62, 0.8)], twin: 2),
                         LueurDefinition(start: pt(0.6, 0.92), iris: pt(0.82, 0.82), twin: 1)],
                veils: [VeilDefinition(a: pt(0.0, 0.5), b: pt(1.0, 0.5))],
                souffles: [SouffleDefinition(path: [pt(0.65, 0.30), pt(0.65, 0.70)], period: 8, duty: 0.7, radius: 0.18, strength: 1.8)],
                hints: [LevelHint(.start, "Son poste est de l'autre côté. Le souffle l'y conduira."),
                        LevelHint(.twinsLinked, "À portée. Laissez-les se rejoindre.")],
                par: LevelPar(time: 19, intrusions: 8)),
        ])
}
