// GameElement+Glyph.swift
// Layer: Presentation
// Purpose: Maps the domain's game elements to design-system glyphs

import Foundation

extension GameElement {
    var glyphKind: DSGlyph.Kind {
        switch self {
        case .lueur: .lueur
        case .iris: .iris
        case .ecran: .ecran
        case .temperaments: .temperaments
        case .ordre: .ordre
        case .cascade: .cascade
        case .courant: .courant
        case .voile: .voile
        case .veilleuse: .veilleuse
        case .irisMouvant: .irisMouvant
        case .jumelles: .jumelles
        }
    }
}
