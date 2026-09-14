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
    case gouffre
    case braise
    /// PROTOTYPE (chapter I level 6).
    case balise
    // Oculomotor finals (chapters II to XII)
    case coeur
    case filVivant
    case miroir
    case etoileAbsente
    case jardin
    case croisement

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
        case .gouffre: "gouffre"
        case .braise: "braise"
        case .balise: "balise"
        case .coeur: "cœur de verre"
        case .filVivant: "fil vivant"
        case .miroir: "miroir menteur"
        case .etoileAbsente: "étoile absente"
        case .jardin: "jardin caché"
        case .croisement: "croisement"
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
        case .gouffre: "Il aspire ce qui s'approche. Ce qu'il avale revient à son départ."
        case .braise: "Froide, elle dort. Un regard bref la réveille et elle fuit ; un regard long l'affole."
        case .balise: "Elle s'éveille sous un regard posé, puis tend un fil vers la suivante. Le fil complet ouvre l'iris."
        case .coeur: "Froid, il se réchauffe sous un regard qui reste. Les étincelles autour n'attendent que votre regard pour le refroidir."
        case .filVivant: "Elle file sans jamais s'arrêter. Accompagnez-la du regard : le fil qu'elle laisse reste vivant."
        case .miroir: "Ce qui brille d'un côté appelle le regard ; la porte s'ouvre de l'autre. Ne suivez pas l'éclat."
        case .etoileAbsente: "Elle brille un instant puis s'efface. Retournez là où elle était : elle revient, et la constellation grandit."
        case .jardin: "Parmi les graines qui scintillent, quelques-unes respirent. Posez le regard sur celles-là : elles poussent."
        case .croisement: "Les jumelles s'appellent d'un coin à l'autre. Répondez à celle qui respire : leur lien se resserre."
        }
    }
}
