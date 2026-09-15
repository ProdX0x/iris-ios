// DSGlassBarBehaviour.swift
// Layer: DesignSystem
// Purpose: The behaviours the system's own bars offer (a tab bar that steps aside while scrolling, softened edges
// under it): a screen asks for one, this file alone knows whether the running system provides it

import SwiftUI

struct DSGlassBarBehaviour: ViewModifier {
    enum Behaviour {
        /// The tab bar steps out of the way while the player scrolls down.
        case tabBarMinimizesOnScroll
        /// Content passing under the system's bars is softened instead of cut.
        case softScrollEdges(Edge.Set)
    }

    let behaviour: Behaviour

    @ViewBuilder
    func body(content: Content) -> some View {
        if #available(iOS 26.0, *) {
            switch behaviour {
            case .tabBarMinimizesOnScroll:
                content.tabBarMinimizeBehavior(.onScrollDown)
            case let .softScrollEdges(edges):
                content.scrollEdgeEffectStyle(.soft, for: edges)
            }
        } else {
            content
        }
    }
}

extension View {
    /// The tab bar steps out of the way while the player scrolls down, where the system does it.
    func dsTabBarMinimizesOnScroll() -> some View {
        modifier(DSGlassBarBehaviour(behaviour: .tabBarMinimizesOnScroll))
    }

    /// Softens the content passing under the system's bars instead of cutting it.
    func dsSoftScrollEdges(_ edges: Edge.Set = .all) -> some View {
        modifier(DSGlassBarBehaviour(behaviour: .softScrollEdges(edges)))
    }
}
