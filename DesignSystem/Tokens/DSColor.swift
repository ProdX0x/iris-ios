// DSColor.swift
// Layer: DesignSystem
// Purpose: Semantic colour tokens of the Iris identity (values live in the asset catalogue)

import SwiftUI

enum DSColor {
    // Grounds
    static let backgroundPrimary = Color("ds.background.primary")
    static let backgroundSurface = Color("ds.background.surface")
    static let backgroundElevated = Color("ds.background.elevated")

    // Text
    static let textPrimary = Color("ds.text.primary")
    static let textSecondary = Color("ds.text.secondary")
    static let textTertiary = Color("ds.text.tertiary")
    static let textOnAccent = Color("ds.text.onAccent")
    static let textWarm = Color("ds.text.warm")

    // Accent (amber) and status
    static let accent = Color("ds.accent")
    static let accentDeep = Color("ds.accent.deep")
    static let statusSuccess = Color("ds.status.success")
    static let statusDanger = Color("ds.status.danger")
    static let statusInfo = Color("ds.status.info")
    static let lineSubtle = Color("ds.line.subtle")

    // Game scene (ported from the reference engine palette)
    static let sceneSkyTop = Color("ds.scene.skyTop")
    static let sceneSkyHorizon = Color("ds.scene.skyHorizon")
    static let sceneFloorNear = Color("ds.scene.floorNear")
    static let sceneFloorFar = Color("ds.scene.floorFar")
    static let sceneSphere = Color("ds.scene.sphere")
    static let sceneSphereLight = Color("ds.scene.sphereLight")
    static let sceneSphereDark = Color("ds.scene.sphereDark")
    static let sceneSphereValidated = Color("ds.scene.sphereValidated")
    static let sceneSphereValidatedLight = Color("ds.scene.sphereValidatedLight")
    static let sceneSphereValidatedDark = Color("ds.scene.sphereValidatedDark")
    static let sceneShadow = Color("ds.scene.shadow")
    static let sceneRing = Color("ds.scene.ring")
    static let sceneLabel = Color("ds.scene.label")

    /// Sequence colours (`SEQ_COLORS`), 1-based, wrapping after five.
    static func sequence(_ sequence: Int) -> Color {
        let index = ((sequence - 1) % 5 + 5) % 5 + 1
        return Color("ds.sequence.\(index)")
    }
}
