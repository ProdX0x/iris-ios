// Campaign+Gouffres.swift
// Layer: Domain
// Purpose: Chapter X, Gouffres: wells pull what comes near and send what they swallow back to its start;
// the straight line is never the way

import Foundation

extension Campaign {
    static let gouffres = ChapterDefinition(
        number: 10, name: "gouffres", principle: "Ce qu'il avale revient au départ.", ambientFrequency: 82.41, theme: .gouffres,
        levels: [
            LevelDefinition(
                chapter: 10, index: 1, title: "le gouffre",
                principle: "Le gouffre est sur le chemin direct. Contournez-le.",
                introduces: [.gouffre], zone: 0.46,
                lueurs: [LueurDefinition(start: pt(0.5, 0.12), iris: pt(0.5, 0.8), route: [pt(0.24, 0.5)])],
                gouffres: [GouffreDefinition(center: pt(0.5, 0.5), radius: 0.11, pull: 0.24)],
                hints: [LevelHint(.start, "Livrée à elle-même, elle file droit vers le gouffre."),
                        LevelHint(.firstSwallow, "Avalée, elle revient au départ. Tout est à refaire."),
                        LevelHint(.afterSeconds(30), "Poussez-la sur le côté avant qu'il ne l'aspire.")],
                par: LevelPar(time: 17, intrusions: 3)),
            LevelDefinition(
                chapter: 10, index: 2, title: "l'aspiration",
                principle: "Deux gouffres, et leur aspiration se touche. Passez large.",
                zone: 0.46,
                lueurs: [LueurDefinition(start: pt(0.5, 0.1), iris: pt(0.5, 0.9), route: [pt(0.16, 0.4), pt(0.24, 0.72)])],
                gouffres: [GouffreDefinition(center: pt(0.5, 0.4), radius: 0.11, pull: 0.24), GouffreDefinition(center: pt(0.62, 0.68), radius: 0.11, pull: 0.24)],
                hints: [LevelHint(.start, "L'aspiration commence bien avant la bouche."),
                        LevelHint(.firstSwallow, "Trop près. Elle revient au départ.")],
                par: LevelPar(time: 19, intrusions: 3)),
            LevelDefinition(
                chapter: 10, index: 3, title: "le courant et le gouffre",
                principle: "Le courant la porte droit dans le gouffre. Sortez-la du courant avant.",
                zone: 0.46,
                lueurs: [LueurDefinition(start: pt(0.2, 0.31), iris: pt(0.88, 0.46), route: [pt(0.4, 0.56)])],
                currents: [CurrentDefinition(area: band(0.0, 0.25, 1.0, 0.34), direction: right, strength: 0.7)],
                gouffres: [GouffreDefinition(center: pt(0.7, 0.33), radius: 0.13, pull: 0.24)],
                hints: [LevelHint(.start, "Le courant l'emporte vers le gouffre. Poussez-la vers le bas."),
                        LevelHint(.firstSwallow, "Avalée. Elle repart dans le courant.")],
                par: LevelPar(time: 14, intrusions: 3)),
            LevelDefinition(
                chapter: 10, index: 4, title: "la flamme en haut",
                principle: "La flamme veille tout en haut, loin du gouffre. Servez-la sans perdre le détour.",
                zone: 0.46,
                lueurs: [LueurDefinition(start: pt(0.15, 0.14), iris: pt(0.82, 0.86), route: [pt(0.82, 0.3), pt(0.86, 0.58)])],
                veilleuses: [VeilleuseDefinition(position: pt(0.5, 0.1), lookRadius: 0.14, decay: 9, recharge: 0.8, initialCharge: 0.45)],
                gouffres: [GouffreDefinition(center: pt(0.5, 0.52), radius: 0.11, pull: 0.24)],
                hints: [LevelHint(.start, "La flamme est en haut, le gouffre au centre. Faites le tour par la droite."),
                        LevelHint(.veilleuseLow, "La flamme faiblit.")],
                par: LevelPar(time: 21, intrusions: 3)),
            LevelDefinition(
                chapter: 10, index: 5, title: "de part et d'autre",
                principle: "Deux lueurs se croisent autour du gouffre. Chacune son côté.",
                zone: 0.46,
                lueurs: [LueurDefinition(start: pt(0.15, 0.18), iris: pt(0.82, 0.84), route: [pt(0.2, 0.56), pt(0.5, 0.82)]),
                         LueurDefinition(start: pt(0.85, 0.18), iris: pt(0.18, 0.84), route: [pt(0.8, 0.56), pt(0.5, 0.84)])],
                gouffres: [GouffreDefinition(center: pt(0.5, 0.5), radius: 0.12, pull: 0.24)],
                hints: [LevelHint(.start, "Leurs chemins se croisent au centre, là où le gouffre attend."),
                        LevelHint(.firstSwallow, "Une de perdue, pas les deux. Elle revient au départ.")],
                par: LevelPar(time: 24, intrusions: 7)),
            LevelDefinition(
                chapter: 10, index: 6, title: "l'abîme",
                principle: "Deux gouffres, trois lueurs, dans l'ordre. L'iris de la première est entre les bouches.",
                ordered: true, zone: 0.46,
                lueurs: [LueurDefinition(start: pt(0.5, 0.1), iris: pt(0.5, 0.52), route: [pt(0.74, 0.28), pt(0.72, 0.5)]),
                         LueurDefinition(start: pt(0.12, 0.9), iris: pt(0.15, 0.2), route: [pt(0.12, 0.55)]),
                         LueurDefinition(start: pt(0.88, 0.9), iris: pt(0.85, 0.35), route: [pt(0.9, 0.62)])],
                gouffres: [GouffreDefinition(center: pt(0.5, 0.34), radius: 0.11, pull: 0.24), GouffreDefinition(center: pt(0.65, 0.65), radius: 0.11, pull: 0.24)],
                hints: [LevelHint(.start, "L'ordre d'abord ; puis les couloirs des bords, loin des bouches."),
                        LevelHint(.firstSwallow, "Avalée. Et si elle était fermée, les suivantes s'ouvrent aussi.")],
                par: LevelPar(time: 20, intrusions: 4)),
        ])
}
