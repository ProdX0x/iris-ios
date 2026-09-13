// GameElement.swift
// Layer: Domain
// Purpose: The ideas a player meets along the campaign (level intro "nouveau" chip and the Carnet)

import Foundation

enum GameElement: String, Hashable, Sendable, CaseIterable, Codable {
    case lueur
    case iris
    case ecran
    case temperaments
    case ordre
    case cascade
    case courant
    case voile
    case veilleuse
    case irisMouvant
    // Expansion (chapter VII and beyond)
    case jumelles
    case souffle
    case dormeuse
    case echo

    var name: String {
        switch self {
        case .lueur: "lueur"
        case .iris: "iris"
        case .ecran: "regard sur l'écran"
        case .temperaments: "tempéraments"
        case .ordre: "ordre"
        case .cascade: "cascade"
        case .courant: "courant"
        case .voile: "voile"
        case .veilleuse: "veilleuse"
        case .irisMouvant: "iris mouvant"
        case .jumelles: "jumelles"
        case .souffle: "souffle"
        case .dormeuse: "dormeuse"
        case .echo: "écho"
        }
    }

    var summary: String {
        switch self {
        case .lueur: "Elle fuit votre regard et rejoint son iris quand on la laisse."
        case .iris: "Une lueur doit y rester trois quarts de seconde pour qu'il se ferme."
        case .ecran: "Si vos yeux quittent l'écran, les iris se ferment."
        case .temperaments: "La lueur vive fuit au moindre regard, la lourde résiste."
        case .ordre: "Les numéros fixent l'ordre : 1, puis 2, puis 3."
        case .cascade: "Si une lueur perd sa place, celles qui la suivent la perdent aussi."
        case .courant: "Il emporte les lueurs. Poussez-les avec votre regard."
        case .voile: "Les lueurs ne le traversent pas. Poussez-les autour."
        case .veilleuse: "Regardez la flamme pour la raviver. Éteinte, elle ferme ses iris."
        case .irisMouvant: "L'iris glisse. Anticipez sans le fixer."
        case .jumelles: "Elles n'ont pas d'iris : chacune est l'iris de l'autre. Réunissez-les."
        case .souffle: "Il passe et repasse sur son chemin. Ce qu'il traverse, il l'emporte par-dessus les voiles."
        case .dormeuse: "Elle dort : elle ne bouge pas et son iris reste fermé. Seul un écho la réveille."
        case .echo: "Un iris qui se ferme respire un écho. Il réveille les dormeuses à portée et les lance."
        }
    }
}
