// Campaign+Echos.swift
// Layer: Domain
// Purpose: Chapter IX, Échos: sleeping lueurs wake only when the echo of a closing iris reaches them; bring them within
// reach of an iris about to close (or already closed and breathing), then guide them once the echo has launched them

import Foundation

extension Campaign {
    static let echos = ChapterDefinition(
        number: 9, name: "échos", principle: "Un iris qui se ferme réveille ce qui dort à portée.", ambientFrequency: 138.59, theme: .echo,
        levels: [
            LevelDefinition(
                chapter: 9, index: 1, title: "l'écho",
                principle: "La seconde dort. Fermez le premier iris : son écho la réveille.",
                introduces: [.dormeuse, .echo], zone: 0.46,
                lueurs: [LueurDefinition(start: pt(0.5, 0.12), iris: pt(0.5, 0.42)),
                         LueurDefinition(start: pt(0.5, 0.62), iris: pt(0.5, 0.86), asleep: true)],
                echo: .standard,
                hints: [LevelHint(.start, "La lueur du bas dort. Rien ne la fera bouger, sauf un écho."),
                        LevelHint(.firstValidation, "L'iris se ferme et respire. Regardez l'écho."),
                        LevelHint(.firstWake, "Réveillée, elle vit comme les autres. Laissez-la se poser.")],
                par: LevelPar(time: 25, intrusions: 18)),
            LevelDefinition(
                chapter: 9, index: 2, title: "hors de portée",
                principle: "L'écho ne porte pas jusqu'à elle. Rapprochez-la avant.",
                zone: 0.46,
                lueurs: [LueurDefinition(start: pt(0.8, 0.86), iris: pt(0.78, 0.55), route: [pt(0.42, 0.56)], asleep: true),
                         LueurDefinition(start: pt(0.2, 0.12), iris: pt(0.25, 0.40))],
                echo: .standard,
                hints: [LevelHint(.start, "Endormie, elle fuit encore votre regard. Poussez-la vers l'iris de l'autre."),
                        LevelHint(.firstWake, "L'écho la lance. Elle rejoint son iris seule.")],
                par: LevelPar(time: 16, intrusions: 6)),
            LevelDefinition(
                chapter: 9, index: 3, title: "la chaîne",
                principle: "Un écho en réveille une, dont l'iris en réveille une autre.",
                zone: 0.46,
                lueurs: [LueurDefinition(start: pt(0.5, 0.12), iris: pt(0.5, 0.36)),
                         LueurDefinition(start: pt(0.2, 0.56), iris: pt(0.5, 0.64), asleep: true),
                         LueurDefinition(start: pt(0.82, 0.88), iris: pt(0.5, 0.88), route: [pt(0.62, 0.74)], asleep: true)],
                echo: .standard,
                hints: [LevelHint(.start, "Deux dormeuses. La première est à portée ; la seconde ne l'est d'aucun iris."),
                        LevelHint(.firstWake, "Son iris respirera à son tour.")],
                par: LevelPar(time: 19, intrusions: 5)),
            LevelDefinition(
                chapter: 9, index: 4, title: "à contre-écho",
                principle: "Le courant l'éloigne de l'iris qui doit la réveiller.",
                zone: 0.46,
                lueurs: [LueurDefinition(start: pt(0.75, 0.85), iris: pt(0.8, 0.45), route: [pt(0.48, 0.62)], asleep: true),
                         LueurDefinition(start: pt(0.2, 0.12), iris: pt(0.3, 0.40))],
                currents: [CurrentDefinition(area: band(0.0, 0.55, 1.0, 0.70), direction: right, strength: 0.75)],
                echo: .standard,
                hints: [LevelHint(.start, "Dans le courant, la dormeuse dérive vers la droite. Tenez-la à portée."),
                        LevelHint(.firstWake, "Lancée par l'écho, elle sort du courant.")],
                par: LevelPar(time: 18, intrusions: 7)),
            LevelDefinition(
                chapter: 9, index: 5, title: "la flamme et l'écho",
                principle: "La flamme éclaire l'iris qui doit se fermer. Sans elle, pas d'écho.",
                zone: 0.46,
                lueurs: [LueurDefinition(start: pt(0.5, 0.1), iris: pt(0.5, 0.38)),
                         LueurDefinition(start: pt(0.15, 0.85), iris: pt(0.5, 0.86), route: [pt(0.36, 0.6)], asleep: true)],
                veilleuses: [VeilleuseDefinition(position: pt(0.82, 0.22), lookRadius: 0.14, decay: 9, recharge: 0.8, initialCharge: 0.45, linked: [1])],
                echo: .standard,
                hints: [LevelHint(.start, "La flamme ferme l'iris du haut si elle s'éteint. Servez-la, puis réveillez."),
                        LevelHint(.veilleuseLow, "La flamme faiblit.")],
                par: LevelPar(time: 25, intrusions: 10)),
            LevelDefinition(
                chapter: 9, index: 6, title: "trois voix",
                principle: "Dans l'ordre : l'éveillée, puis chaque dormeuse que son écho atteint. Le voile impose le détour.",
                ordered: true, zone: 0.46,
                lueurs: [LueurDefinition(start: pt(0.5, 0.1), iris: pt(0.5, 0.34)),
                         LueurDefinition(start: pt(0.12, 0.8), iris: pt(0.28, 0.58), route: [pt(0.22, 0.44)], asleep: true),
                         LueurDefinition(start: pt(0.88, 0.86), iris: pt(0.7, 0.64), route: [pt(0.62, 0.42)], asleep: true)],
                veils: [VeilDefinition(a: pt(0.3, 0.66), b: pt(0.7, 0.72))],
                echo: .standard,
                hints: [LevelHint(.start, "L'éveillée d'abord. Amenez chaque dormeuse à portée de son écho, dans l'ordre."),
                        LevelHint(.firstLoss, "Un iris qui se rouvre entraîne les suivants.")],
                par: LevelPar(time: 27, intrusions: 8)),
        ])
}
