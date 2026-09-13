// Campaign+Constellation.swift
// Layer: Domain
// Purpose: Chapter XII, Constellation: the finale weaves the ideas of chapters VII to XI together, up to the last iris,
// woken by the echo of a rendez-vous

import Foundation

extension Campaign {
    static let constellation = ChapterDefinition(
        number: 12, name: "constellation", principle: "Tout ce que vous savez regarder, ensemble.", ambientFrequency: 110, theme: .constellation,
        levels: [
            LevelDefinition(
                chapter: 12, index: 1, title: "l'écho et le gouffre",
                principle: "La dormeuse est loin de l'iris qui doit la réveiller, et le gouffre est sur le chemin.",
                zone: 0.46,
                lueurs: [LueurDefinition(start: pt(0.5, 0.1), iris: pt(0.5, 0.34)),
                         LueurDefinition(start: pt(0.85, 0.85), iris: pt(0.15, 0.85), route: [pt(0.85, 0.55), pt(0.55, 0.5)], asleep: true)],
                echo: .standard,
                gouffres: [GouffreDefinition(center: pt(0.7, 0.65), radius: 0.11, pull: 0.24)],
                hints: [LevelHint(.start, "Contournez le gouffre avec la dormeuse, jusqu'à portée de l'iris du haut."),
                        LevelHint(.firstWake, "Lancée par l'écho, elle rejoint son iris.")],
                par: LevelPar(time: 34, intrusions: 4)),
            LevelDefinition(
                chapter: 12, index: 2, title: "la braise dans la brume",
                principle: "Réveillez la braise, puis confiez-la au souffle : son iris est de l'autre côté.",
                zone: 0.46, noise: 0.08,
                lueurs: [LueurDefinition(start: pt(0.7, 0.8), iris: pt(0.5, 0.2), route: [pt(0.15, 0.53)], braise: .prototype)],
                veils: [VeilDefinition(a: pt(0.0, 0.5), b: pt(1.0, 0.5))],
                souffles: [SouffleDefinition(path: [pt(0.15, 0.7), pt(0.15, 0.3)], period: 8, duty: 0.7, radius: 0.2, strength: 1.8)],
                hints: [LevelHint(.start, "Froide, elle attend sous le voile. Le souffle monte à gauche."),
                        LevelHint(.braiseLit, "Réveillée, elle glisse contre le voile. Amenez-la sur le chemin du souffle."),
                        LevelHint(.firstCarried, "Il l'emporte. Ne la regardez plus.")],
                par: LevelPar(time: 28, intrusions: 8)),
            LevelDefinition(
                chapter: 12, index: 3, title: "jumelles et gouffre",
                principle: "Le gouffre est entre leurs postes. Le fil le contourne.",
                zone: 0.46,
                lueurs: [LueurDefinition(start: pt(0.12, 0.15), iris: pt(0.2, 0.35), route: [pt(0.3, 0.68), pt(0.62, 0.74)], twin: 2),
                         LueurDefinition(start: pt(0.88, 0.88), iris: pt(0.8, 0.7), twin: 1)],
                gouffres: [GouffreDefinition(center: pt(0.5, 0.52), radius: 0.11, pull: 0.24)],
                hints: [LevelHint(.start, "Tout droit, c'est le gouffre. Passez par le bas."),
                        LevelHint(.twinsLinked, "À portée. Laissez-les se rejoindre, loin de la bouche.")],
                par: LevelPar(time: 17, intrusions: 4)),
            LevelDefinition(
                chapter: 12, index: 4, title: "souffle et écho",
                principle: "La dormeuse attend de l'autre côté du voile, à portée d'un iris que seul le souffle permet de fermer.",
                zone: 0.46, noise: 0.08,
                lueurs: [LueurDefinition(start: pt(0.5, 0.12), iris: pt(0.62, 0.78), route: [pt(0.2, 0.47)]),
                         LueurDefinition(start: pt(0.85, 0.62), iris: pt(0.85, 0.88), asleep: true)],
                veils: [VeilDefinition(a: pt(0.0, 0.5), b: pt(1.0, 0.5))],
                souffles: [SouffleDefinition(path: [pt(0.2, 0.3), pt(0.2, 0.7)], period: 8, duty: 0.7, radius: 0.2, strength: 1.8)],
                echo: .standard,
                hints: [LevelHint(.start, "Le souffle porte l'éveillée. Son iris, une fois fermé, réveillera la dormeuse."),
                        LevelHint(.firstWake, "L'écho a passé le voile.")],
                par: LevelPar(time: 21, intrusions: 4)),
            LevelDefinition(
                chapter: 12, index: 5, title: "la flamme et les braises",
                principle: "Deux braises dans l'ordre, une flamme en haut qui éclaire leurs iris, un gouffre entre elles.",
                ordered: true, zone: 0.46,
                lueurs: [LueurDefinition(start: pt(0.2, 0.85), iris: pt(0.2, 0.25), braise: .prototype),
                         LueurDefinition(start: pt(0.8, 0.85), iris: pt(0.8, 0.25), braise: .prototype)],
                veilleuses: [VeilleuseDefinition(position: pt(0.5, 0.1), lookRadius: 0.14, decay: 8, recharge: 0.8, initialCharge: 0.2)],
                gouffres: [GouffreDefinition(center: pt(0.5, 0.78), radius: 0.11, pull: 0.24)],
                hints: [LevelHint(.start, "La flamme d'abord, puis réveillez la braise de gauche, puis celle de droite."),
                        LevelHint(.veilleuseLow, "La flamme faiblit."),
                        LevelHint(.braiseFlared, "Affolée. Regardez ailleurs.")],
                par: LevelPar(time: 21, intrusions: 11)),
            LevelDefinition(
                chapter: 12, index: 6, title: "le dernier iris",
                principle: "Réunissez les jumelles ; leur rendez-vous respire. Amenez la dormeuse à portée, autour du gouffre.",
                zone: 0.46,
                lueurs: [LueurDefinition(start: pt(0.15, 0.12), iris: pt(0.22, 0.25), route: [pt(0.4, 0.3), pt(0.66, 0.3)], twin: 2),
                         LueurDefinition(start: pt(0.85, 0.12), iris: pt(0.78, 0.25), twin: 1),
                         LueurDefinition(start: pt(0.5, 0.7), iris: pt(0.5, 0.88), route: [pt(0.75, 0.6)], asleep: true)],
                echo: .standard,
                gouffres: [GouffreDefinition(center: pt(0.42, 0.5), radius: 0.11, pull: 0.24)],
                hints: [LevelHint(.start, "Les jumelles d'abord. Réunies, elles respirent un écho."),
                        LevelHint(.twinsLinked, "Elles se rejoignent. Maintenant la dormeuse, par la droite du gouffre."),
                        LevelHint(.firstWake, "Le dernier iris l'attend, en bas.")],
                par: LevelPar(time: 27, intrusions: 8)),
        ])
}
