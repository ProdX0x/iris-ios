// DSGlassShape.swift
// Layer: DesignSystem
// Purpose: The few shapes glass may take: a circle for icons, a capsule where it means something, a moderately
// rounded rectangle for panels (radii come from DSRadius, unchanged)

import SwiftUI

enum DSGlassShape: Hashable, Sendable {
    case circle
    case capsule
    case rounded(CGFloat)

    var shape: AnyShape {
        switch self {
        case .circle: AnyShape(Circle())
        case .capsule: AnyShape(Capsule())
        case let .rounded(radius): AnyShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
        }
    }

    /// A one-point line inside the edge, drawn only on the plain surfaces that stand in for glass.
    @ViewBuilder
    func hairline(_ color: Color) -> some View {
        switch self {
        case .circle: Circle().strokeBorder(color, lineWidth: 1)
        case .capsule: Capsule().strokeBorder(color, lineWidth: 1)
        case let .rounded(radius): RoundedRectangle(cornerRadius: radius, style: .continuous).strokeBorder(color, lineWidth: 1)
        }
    }
}
