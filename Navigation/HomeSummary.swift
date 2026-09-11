// HomeSummary.swift
// Layer: Presentation (Navigation)
// Purpose: What the threshold screen proposes: begin, continue with the next level, or replay

import Foundation

struct HomeSummary: Hashable, Sendable {
    enum Action: Hashable, Sendable {
        case begin
        case resume
        case replay
    }

    let action: Action
    let detail: String?
    let eclats: Int
    let maxEclats: Int

    init(action: Action, detail: String?, eclats: Int, maxEclats: Int) {
        self.action = action
        self.detail = detail
        self.eclats = eclats
        self.maxEclats = maxEclats
    }

    var primaryTitle: String {
        switch action {
        case .begin: "Commencer"
        case .resume: "Continuer"
        case .replay: "Rejouer un chapitre"
        }
    }
}
