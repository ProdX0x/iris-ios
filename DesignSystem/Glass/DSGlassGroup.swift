// DSGlassGroup.swift
// Layer: DesignSystem
// Purpose: Neighbouring glass elements share one glass layer on iOS 26 (no glass on glass, coherent morphing, fewer
// layers to draw); elsewhere the content is laid out unchanged. `dsGlassID` names an element for morphing

import SwiftUI

/// Wraps one stack of glass elements; its children blend and morph together where Liquid Glass is drawn.
struct DSGlassGroup<Content: View>: View {
    private let spacing: CGFloat?
    private let content: Content

    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency

    init(spacing: CGFloat? = nil, @ViewBuilder content: () -> Content) {
        self.spacing = spacing
        self.content = content()
    }

    var body: some View {
        if DSGlassRendering.resolve(reduceTransparency: reduceTransparency) == .native {
            if #available(iOS 26.0, *) {
                GlassEffectContainer(spacing: spacing) {
                    content
                }
            } else {
                content
            }
        } else {
            content
        }
    }
}

extension View {
    /// Names a glass element so it morphs with its neighbours inside a DSGlassGroup; under Reduce Motion the glass
    /// only fades in and out.
    func dsGlassID<ID: Hashable & Sendable>(_ id: ID, in namespace: Namespace.ID) -> some View {
        modifier(DSGlassIdentity(id: id, namespace: namespace))
    }
}

private struct DSGlassIdentity<ID: Hashable & Sendable>: ViewModifier {
    let id: ID
    let namespace: Namespace.ID

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    func body(content: Content) -> some View {
        if #available(iOS 26.0, *) {
            content
                .glassEffectID(id, in: namespace)
                .glassEffectTransition(DSGlassRendering.transition(reduceMotion: reduceMotion) == .morph ? .matchedGeometry : .materialize)
        } else {
            content
        }
    }
}
