// ChapterTheme+Palette.swift
// Layer: Presentation
// Purpose: Maps each chapter theme of the domain to its design-system palette

import Foundation

extension ChapterTheme {
    var palette: DSThemePalette {
        switch self {
        case .chambreNoire: .chambreNoire
        case .jumelles: .jumelles
        case .brume: .brume
        case .echo: .echo
        case .gouffres: .gouffres
        case .braises: .braises
        }
    }
}
