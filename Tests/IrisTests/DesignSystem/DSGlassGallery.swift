// DSGlassGallery.swift
// Layer: Tests
// Purpose: Development gallery of the Liquid Glass roles over a plain ground and a richer demonstration ground, shown
// by the test host for screenshots; never reachable in the app, and its demonstration ground is not Iris's background

import SwiftUI
@testable import Iris

struct DSGlassGallery: View {
    enum Page: String, CaseIterable, Sendable {
        case roles
        case comparaison
        case texte
    }

    enum Ground: String, CaseIterable, Sendable {
        case simple
        case riche
    }

    let page: Page
    let ground: Ground

    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency
    @Environment(\.colorSchemeContrast) private var contrast
    @Environment(\.dynamicTypeSize) private var typeSize
    @ScaledMetric private var controlSize: CGFloat = 48

    private let longText = "Le verre laisse passer le fond : ce texte doit se lire sans effort, quoi qu'il passe derrière. Le panneau grandit avec son contenu, sans hauteur fixe."

    var body: some View {
        ZStack {
            switch ground {
            case .simple: DSColor.Identity.ground.ignoresSafeArea()
            case .riche: GalleryDemoGround().ignoresSafeArea()
            }
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 12) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("galerie liquid glass · développement").dsEyebrowStyle()
                        label(stateLine)
                    }
                    .dynamicTypeSize(.large)
                    switch page {
                    case .roles: roles
                    case .comparaison: comparison
                    case .texte: text
                    }
                }
                .padding(.horizontal, DSSpacing.gutter)
                .padding(.top, DSSpacing.s)
            }
        }
    }

    private var stateLine: String {
        "verre natif \(DSGlassRendering.isNativeGlassAvailable ? "oui" : "non") · transparence réduite \(reduceTransparency ? "oui" : "non") · contraste \(contrast == .increased ? "élevé" : "standard") · fond \(ground.rawValue)"
    }

    private func label(_ text: String) -> some View {
        Text(text).font(DSFont.footnote).foregroundStyle(DSColor.Identity.textSecondary)
    }

    private func control(_ symbol: String) -> some View {
        Image(systemName: symbol)
            .font(DSFont.headline)
            .frame(width: controlSize, height: controlSize)
            .dsGlass(.clearControl)
    }

    private func chromeItem(_ symbol: String, _ title: String) -> some View {
        VStack(spacing: 2) {
            Image(systemName: symbol).font(DSFont.headline)
            Text(title).font(DSFont.footnote)
        }
        .frame(maxWidth: .infinity, minHeight: 48)
    }

    private var roles: some View {
        VStack(alignment: .leading, spacing: 12) {
            label("1 · contrôles clairs, séparés")
            HStack(spacing: 16) {
                control("pause.fill")
                control("xmark")
                control("gearshape")
            }
            label("5 · contrôles réunis dans un DSGlassGroup")
            DSGlassGroup(spacing: 8) {
                HStack(spacing: 8) {
                    control("backward.end.fill")
                    control("pause.fill")
                    control("forward.end.fill")
                }
            }
            label("2 · panneau régulier, texte court")
            VStack(alignment: .leading, spacing: 4) {
                Text("pause").font(DSFont.title)
                Text("III · courants — la brèche").font(DSFont.callout)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(DSSpacing.l)
            .dsGlass(.regularPanel)
            label("7 · panneau régulier, texte long")
            Text(longText)
                .font(DSFont.body)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(DSSpacing.l)
                .dsGlass(.regularPanel)
            label("3 · chrome")
            HStack(spacing: 0) {
                chromeItem("circle.hexagongrid", "chapitres")
                chromeItem("book.closed", "carnet")
                chromeItem("gearshape", "réglages")
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .dsGlass(.chrome)
            label("4 · action proéminente")
            Text("Commencer")
                .font(DSFont.headline)
                .frame(maxWidth: .infinity, minHeight: 52)
                .dsGlass(.prominentAction)
        }
    }

    @ViewBuilder
    private func sample(_ role: DSGlassRole) -> some View {
        switch role {
        case .clearControl:
            Image(systemName: "pause.fill").font(DSFont.headline).frame(width: controlSize, height: controlSize)
        case .regularPanel:
            Text("Aa").font(DSFont.title).frame(width: 96, height: 72)
        case .chrome:
            HStack(spacing: 14) {
                Image(systemName: "book.closed")
                Image(systemName: "gearshape")
            }
            .font(DSFont.headline)
            .frame(width: 96, height: 44)
        case .prominentAction:
            Text("Aller").font(DSFont.headline).frame(width: 96, height: 44)
        }
    }

    private var comparison: some View {
        VStack(alignment: .leading, spacing: 14) {
            label("colonne 1 : le rendu que le système choisit ici · colonnes 2 et 3 : surfaces de repli affichées directement, forcées pour comparaison")
            HStack(spacing: 8) {
                label("choisi ici").frame(maxWidth: .infinity)
                label("repli iOS 17–25").frame(maxWidth: .infinity)
                label("opaque (forcé)").frame(maxWidth: .infinity)
            }
            ForEach(DSGlassRole.allCases, id: \.self) { role in
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 8) {
                        sample(role).dsGlass(role).frame(maxWidth: .infinity)
                        sample(role).modifier(DSGlassSurface(role: role, shape: role.defaultShape, rendering: .translucent)).frame(maxWidth: .infinity)
                        sample(role).modifier(DSGlassSurface(role: role, shape: role.defaultShape, rendering: .opaque)).frame(maxWidth: .infinity)
                    }
                    label(String(describing: role))
                }
            }
            label("référence système, hors rôles : .buttonStyle(.glass), .glassProminent teinté, .glass en cercle")
            systemReference
        }
    }

    @ViewBuilder
    private var systemReference: some View {
        if #available(iOS 26.0, *) {
            HStack(spacing: 12) {
                Button("Verre") {}.buttonStyle(.glass)
                Button("Proéminent") {}.buttonStyle(.glassProminent).tint(DSColor.Navigation.primary)
                Button {} label: { Image(systemName: "xmark") }.buttonStyle(.glass).buttonBorderShape(.circle)
            }
        } else {
            label("boutons système Liquid Glass indisponibles avant iOS 26")
        }
    }

    private var text: some View {
        VStack(alignment: .leading, spacing: 14) {
            label("taille de texte appliquée à la vue : \(String(describing: typeSize))").dynamicTypeSize(.large)
            VStack(alignment: .leading, spacing: 8) {
                Text("résultat").font(DSFont.title)
                Text(longText).font(DSFont.body).fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(DSSpacing.l)
            .dsGlass(.regularPanel)
            HStack(spacing: 12) {
                control("xmark")
                Text("Chapitre suivant")
                    .font(DSFont.headline)
                    .padding(.horizontal, DSSpacing.m)
                    .frame(maxWidth: .infinity, minHeight: 52)
                    .dsGlass(.prominentAction)
            }
        }
    }
}

/// Exploratory demonstration ground: blue-black and indigo areas, diffuse light, fibres, bands and rings that let
/// glass show its refraction and edges. Not Iris's future background; none of these colours are tokens.
private struct GalleryDemoGround: View {
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(red: 0.02, green: 0.03, blue: 0.08), Color(red: 0.09, green: 0.07, blue: 0.24), Color(red: 0.03, green: 0.05, blue: 0.12)],
                           startPoint: .topLeading, endPoint: .bottomTrailing)
            RadialGradient(colors: [Color(red: 0.40, green: 0.42, blue: 0.98).opacity(0.55), .clear], center: UnitPoint(x: 0.18, y: 0.22), startRadius: 0, endRadius: 280)
            RadialGradient(colors: [Color(red: 0.62, green: 0.84, blue: 1.0).opacity(0.38), .clear], center: UnitPoint(x: 0.88, y: 0.58), startRadius: 0, endRadius: 260)
            RadialGradient(colors: [Color(red: 0.95, green: 0.72, blue: 0.40).opacity(0.22), .clear], center: UnitPoint(x: 0.35, y: 0.9), startRadius: 0, endRadius: 220)
            DSIrisFibers(opacity: 0.14, color: .white)
            Canvas { context, size in
                for index in 0..<14 {
                    let x = CGFloat(index) * size.width / 7 - size.width / 2
                    var band = Path()
                    band.move(to: CGPoint(x: x, y: 0))
                    band.addLine(to: CGPoint(x: x + size.height * 0.5, y: size.height))
                    context.stroke(band, with: .color(.white.opacity(index % 2 == 0 ? 0.10 : 0.05)), lineWidth: 10)
                }
                let rings = [CGPoint(x: 0.25, y: 0.35), CGPoint(x: 0.7, y: 0.2), CGPoint(x: 0.62, y: 0.72), CGPoint(x: 0.15, y: 0.8)]
                for (index, unit) in rings.enumerated() {
                    let center = CGPoint(x: unit.x * size.width, y: unit.y * size.height)
                    let radius = CGFloat(40 + index * 22)
                    context.stroke(Path(ellipseIn: CGRect(x: center.x - radius, y: center.y - radius, width: radius * 2, height: radius * 2)),
                                   with: .color(Color(red: 0.8, green: 0.84, blue: 1).opacity(0.45)), lineWidth: 2)
                    context.fill(Path(ellipseIn: CGRect(x: center.x - 5, y: center.y - 5, width: 10, height: 10)), with: .color(.white.opacity(0.8)))
                }
            }
            Text("iris")
                .font(.system(size: 160, weight: .light, design: .serif))
                .foregroundStyle(.white.opacity(0.10))
                .rotationEffect(.degrees(-12))
        }
    }
}
